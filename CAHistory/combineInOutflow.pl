#!/usr/bin/perl
#first argument is the map of people to team
@teams=split(/ /,$ARGV[0]); #list of teams
@fnames=split(/ /,$ARGV[1]); #list of files to generate
$inflow=$ARGV[2];
$outflow=$ARGV[3];
#populate the team map
open my $fd1, $inflow  or die("Couldn't open $inflow");
open my $fd2, $outflow or die("Couldn't open $outflow");
@inflow=<$fd1>;@outflow=<$fd2>; #buffer the files
shift @inflow;shift @outflow; #skip first header line
chomp @inflow;chomp @outflow; 
close $fd1;close $fd2;
#accumulate output in teams hash
%teams;
foreach(@inflow){
#map row to array of columns
	@inflowRow=split(/,/); @outflowRow= split(/,/,shift @outflow);
#first column is sprint rank
	$sprintRank=shift @inflowRow;shift @outflowRow;
#2nd column is sprint id
	$sprintID=shift @inflowRow;shift @outflowRow;
#assign each per team column to team hash
	foreach(@teams){
		$row=sprintf("%s,%s,%s,%s\n",$sprintRank,$sprintID,shift @inflowRow,shift @outflowRow);
#printf $row; #debug output
		$teams{$_}.=$row;
	}
}
foreach(@teams){
	my $filename = shift @fnames;
	open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
	print $fh "rank,sprint,inflow,outflow\n";
	print $fh $teams{$_};
	close $fh;	
}
exit 0;

