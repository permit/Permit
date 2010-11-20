#!/usr/bin/csh
#
#  Use find fund.actions:ARCHIVE199810* -exec zgrep.pl F1631500 {} \;
#  Or  find prof1.out.* -exec zgrep.pl MYOUNG {} \;
#
echo $2
zcat $2 | grep $1

