#!/usr/bin/env perl
use strict; use warnings;
use feature qw/say/;
# USAGE:
#  # in shell
#  find . -type f -ipath '*contact*' -iname '*.elm' | xargs head -vc10M | vim - -c 'set syntax=elm'  
#  # in vim
#  !savemulti.pl %

# TODO:
#  add args/switch options set options
#  add options for
#    - write to tmpdir
#  check if in svm is in a clean state before adding/commiting

my %opt=(diff=>0, force=>0,scmadd=>0);
my $tmpfile='tmp';


my %files=();
my $fnamenull="nullfile";
my $fname=$fnamenull;
# how to check if something is tracked
my $scmcheckcmd="git ls-files --error-unmatch " ;
my $scmaddcmd="git add " ;
my $scmcommitcmd="git commit -m 'added by script before modification' " ;

while(<>){
   $fname=$1 and next if m/^==> (.*) <==$/;
   # make sure we dont have text without a filename
   die "text before filename or filename is unextable '$fnamenull'" unless m/^\S?$/ or $fname ne $fnamenull;
   push @{$files{$fname}}, $_; 
}


for my $fn (keys %files) {

 my $start=0;
 my $end=$#{$files{$fn}};
 #say "$fn: $end";
 
 my $nottracked= (-e $fn and system("$scmcheckcmd $fn 2>/dev/null >/dev/null") != 0);
 
 # if the file is not tracked but we want it too be. do that
 if( $nottracked and $opt{scmadd} ) {
   $nottracked=system("$scmaddcmd $fn && $scmcommitcmd")!=0;
 }
 # only make changes if we can undo (is version tracked)
 if($nottracked and !$opt{force} ) {
   warn "$fn exists but not a tracked file. Will not write!";
   next;
 }
 
 ## kill extra lines at top and bottom 
 # head adds an extra line to end; we probably add lines to the top while editing
 $start++ while $files{$fn}[$start] =~ /^\n$/;
 $end--   while $files{$fn}[$end] =~ /^\n$/;

 # are we writing to tmp or the actual file?
 my $oname=$fn;
 $oname=$tmpfile if $opt{diff};

 # write file
 open my $ofile, ">", $oname or (warn "cannot open $oname to write" and next);
 print $ofile @{$files{$fn}}[$start..$end];
 close $ofile;

 say "== $fn ==\n", qx/diff $fn $tmpfile/ if $opt{diff};
}

unlink $tmpfile if $opt{diff};

