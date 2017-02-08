#!/bin/bash
DIR=`dirname $0`

case $2 in
p1) $DIR/../../../bin/genprog_tests.py --program median $1 $DIR/../../tests/whitebox/3.out $DIR/../../tests/whitebox/3.in && exit 0;;
p2) $DIR/../../../bin/genprog_tests.py --program median $1 $DIR/../../tests/whitebox/2.out $DIR/../../tests/whitebox/2.in && exit 0;;
p3) $DIR/../../../bin/genprog_tests.py --program median $1 $DIR/../../tests/whitebox/1.out $DIR/../../tests/whitebox/1.in && exit 0;;
p4) $DIR/../../../bin/genprog_tests.py --program median $1 $DIR/../../tests/whitebox/5.out $DIR/../../tests/whitebox/5.in && exit 0;;
p5) $DIR/../../../bin/genprog_tests.py --program median $1 $DIR/../../tests/whitebox/4.out $DIR/../../tests/whitebox/4.in && exit 0;;
n1) $DIR/../../../bin/genprog_tests.py --program median $1 $DIR/../../tests/whitebox/6.out $DIR/../../tests/whitebox/6.in && exit 0;;
esac
exit 1
