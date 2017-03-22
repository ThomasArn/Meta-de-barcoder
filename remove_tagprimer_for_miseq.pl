use strict;
use warnings;
use Data::Dumper;

my $i=1;
my $name;
my @barcodes_F;
my @barcodes_R;
my @bar_names;
my $order = "NO";
my $l1;
my $l2;
my @filehandles;
my $b1;
my $b2;
my %handles;

open(my $tags, "<", "$ARGV[0]") or die "cannot open < input.txt: $!";



##Read in barcodes into array for later use

while (<$tags>){
	chomp;
	my @data = split();
	### double up due to either primer 1 or 2 can be read first
	push(@bar_names, $data[0]);
	push(@bar_names, $data[0]);
	push(@barcodes_F, $data[1]);
	push(@barcodes_R, $data[2]);
	push(@barcodes_F, $data[2]);
	push(@barcodes_R, $data[1]);
}

	
	
	open ( my $fh1,">>","/$ARGV[1].pair1.fastq")  || die $!;
    open ( my $fh2,">>","/$ARGV[1].pair2.fastq")  || die $!;


## Go through fastq file and take up only if they have the correct primer/barcode in pair1 and pair2 

while (<STDIN>){
	 chomp;

	if ($i==1){
		$name = $_;
		$i++;
		next;
	}

	elsif($i==2) {
		chomp;
		my ($name1,$name2) = split(/\|/, $name);
		my ($seq1,$seq2) = split(/\|/, $_);

		foreach my $index (0..$#barcodes_F) {
    		next if $seq1 !~ /^$barcodes_F[$index]/;
			
    		if ($seq2 =~ /^$barcodes_R[$index]/) {
				
				$l1 = length($barcodes_F[$index]);
				$l2 = length($barcodes_R[$index]);
    			$seq1 =~ s/^$barcodes_F[$index]//;
    			$seq2 =~ s/^$barcodes_R[$index]//;
				
				$b1 = $bar_names[$index].1;
				$b2 = $bar_names[$index].2;
				print( $fh1  "$name1\_\;barcodelabel\=$bar_names[$index]\;\n$seq1\n") ;
				print( $fh2  "$name2\_\;barcodelabel\=$bar_names[$index]\;\n$seq2\n") ;
    			
    			$order = "YES";
    			}
    	last; # quit the loop early, which is why I didn't use "map" here
		
		}
		$i++;
		next;
	}
	
	elsif($i==3){
#		
		if ($order eq "YES") {
			my ($n1,$n2) = split(/\|/, $_); 
			no strict "refs";
			print $fh1 "$n1\n";
			print $fh2 "$n2\n";
			use strict;
			} 

		$i++;
		next;
	}

	else{
		if ($order eq "YES") {
			my ($d1,$d2) = split(/\|/, $_); 
			$d1 =~ s/^.{$l1}//;
    		$d2 =~ s/^.{$l2}//;
    		no strict "refs";
			print $fh1 "$d1\n";
			print $fh2 "$d2\n";
			use strict;
			} 

		$i=1;
		$order = "NO";
		next;
	}
}
