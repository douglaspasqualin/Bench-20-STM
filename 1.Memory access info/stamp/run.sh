#!/bin/bash

if [ $# -gt 0 ]; then
    threads=$1
    shift
else
    echo "run.sh nb-threads"
    exit
fi

#To show total of aborts and commits
export STM_STATS=1;\

cd ../tinySTM
make clean
make INSTRUMENT=-DINSTRUMENT=METHOD1 BIND_THREAD=-DBIND_THREAD=LINUX_DEFAULT
cd ../stamp
./compile.sh

./stamp-test.sh memoryInfo.txt stm real ${threads}
