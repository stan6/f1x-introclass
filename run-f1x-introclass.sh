#!/usr/bin/env bash

#  This file is part of f1x.
#  Copyright (C) 2016  Sergey Mechtaev, Gao Xiang, Abhik Roychoudhury
#
#  f1x is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

require () {
    hash "$1" 2>/dev/null || { echo "command $1 is not found"; exit 1; }
}

require f1x
require make


experimentdir=/home/ubuntu/f1x-experiments/




cd "$( dirname "${BASH_SOURCE[0]}" )"

if [[ -z "$TESTS" ]]; then
    TESTS=`ls -d */`
fi
subjects=( 'median' 'smallest' 'digits' 'syllables' 'checksum' 'grade' )
subjects_tests=( "1 2 3 4 5 6 7" "1 2 3 4 5 6 7 8" "1 2 3 4 5 6" "1 2 3 4 5 6" "1 2 3 4 5 6" "1 2 3 4 5 6 7 8 9" )
index=0
for sub in "${subjects[@]}"
do
cat <<EOF > /tmp/simple-oracle
#!/bin/bash
testdir="/home/ubuntu/IntroClass/$sub/tests/blackbox/"
echo "calling:\$1 in \$(pwd)" &>/tmp/curr-call
"\$(pwd)/$sub" < "\$testdir/\$1.in" &> /tmp/\$1.out
diff -q /tmp/\$1.out \$testdir/\$1.out
EOF
        chmod u+x /tmp/simple-oracle
	find ~/IntroClass/$sub/ -name "$sub.c" | sed -e "s/$sub\.c//g" &> ~/$sub-direct
	sed -i "/tests/d" ~/$sub-direct
        sed -i "/src/d" ~/$sub-direct
        sed -i "/profile/d" ~/$sub-direct
 
	while read name
	do
	    origdirectory="$name"
            version=$(echo "$origdirectory" | cut -d'/' -f6 | cut -c1-5) 
            subdir=$(echo "$origdirectory" | cut -d'/' -f7)
	    work_dir=`mktemp -d`
            #echo "copying cp -r $origdirectory $work_dir"
	    cp -r $origdirectory/* $work_dir
            cd "$work_dir"
            rm -f $sub
            if grep -q "n1" "$origdirectory/blackbox_test.sh"; then  
		    curr_test=$(echo ${subjects_tests[$index]})
                    postests=($(grep -E "p[0-9]+\)" $origdirectory/blackbox_test.sh | cut -d')' -f 1))
                    negtests=($(grep -E "n[0-9]+\)" $origdirectory/blackbox_test.sh | cut -d')' -f 1))
		    repair_cmd="f1x $work_dir --files $sub.c --driver /tmp/simple-oracle --tests $curr_test --test-timeout 1000 --output output.patch --enable-cleanup"
		    f1x $work_dir --files $sub.c --driver /tmp/simple-oracle --tests $curr_test --test-timeout 1000 --output output.patch &> $work_dir/log.txt
		    if [[ ("$?" != 0) || (! -f output.patch) || (! -s output.patch) ]]; then
			echo "FAIL $origdirectory:pos=${#postests[@]}:neg=${#negtests[@]}"
			echo "----------------------------------------"
			echo "cmd: $repair_cmd"
			#cat "$work_dir/log.txt"
			echo "----------------------------------------"
			msg=$(grep "warning" $work_dir/log.txt)
                        if [[ "$?" == 0 ]];then
                          echo "WARNING:$msg"
                          exit 1
                        fi
                        echo -e "$sub\t$version\t$subdir\tFAIL\t$msg">>~/f1x-out.log
                        #exit 1 
		    else
			echo "SUCCESS"
                        echo -e "$sub\t$version\t$subdir\tSUCCESS">>~/f1x-out.log
                        cat output.patch
		    fi 
            fi
	#rm -rf "$work_dir"
	done < "/home/ubuntu/$sub-direct"
index=$((index+1))
done
