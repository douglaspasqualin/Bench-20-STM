#!/bin/bash

if [ $# -gt 1 ]; then
    executions=$1
    shift
    threads=$1
    shift
else
    echo "runDefaultParam.sh nb-executions nb-threads"
    exit
fi

#To show total of aborts and commits
export STM_STATS=1;\

cd ../tinySTM
make clean
make INSTRUMENT=-DINSTRUMENT=METHOD1 BIND_THREAD=-DBIND_THREAD=LINUX_DEFAULT
cd ../stamp
./compile.sh

export STM_BIND_THREAD=LINUX_DEFAULT;\
for j in `seq 1 $executions`; do
   ./stamp-test.sh outputDefaultParams.txt stm real ${threads}
done


