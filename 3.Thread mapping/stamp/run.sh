#!/bin/bash

if [ $# -gt 0 ]; then
    executions=$1
    shift
else
    echo "run.sh nb-executions"
    exit
fi

#To show total of aborts and commits
export LD_LIBRARY_PATH=$HOME/topomatch/lib:$LD_LIBRARY_PATH
export STM_STATS=1;\

#export TOPOLOGY_HWLOC_XML=$HOME/topology.xml;\

#Memory sample
#SAMPLE_INTERVAL AND MAPPING_INTERVAL should be defined in tinySTM Makefile
#export SAMPLE_INTERVAL=100;\
#export MAPPING_INTERVAL=10000;\
#export MAPPING_INTERVAL=50000;\


cd ../tinySTM
make clean
make SHARING_AWARE=-DSHARING_AWARE=THREAD_MAPPING BIND_THREAD=-DBIND_THREAD=LINUX_DEFAULT
cd ../stamp
./compile.sh

for i in 32 64 96; do

   export STM_BIND_THREAD=ONLINE2;\
   for j in `seq 1 $executions`; do
     ./stamp-test.sh online_mapping2.txt stm real ${i}
   done
   
done
