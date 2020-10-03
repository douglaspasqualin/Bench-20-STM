#!/bin/bash

if [ $# -gt 1 ]; then
    executions=$1
    shift
    threads=$1
    shift
else
    echo "execute.sh nb-executions nb-threads"
    exit
fi

#To show total of aborts and commits
export STM_STATS=1;\

  cd ../tinySTM
  make clean
  make INSTRUMENT=-DINSTRUMENT=OFF BIND_THREAD=-DBIND_THREAD=LINUX_DEFAULT
  cd ../stamp
  ./compile.sh

  export STM_BIND_THREAD=LINUX_DEFAULT ;\
  for j in `seq 1 $executions`; do
    ./stamp-test.sh linux_default.txt stm real ${threads}
  done


#Custom maps
export THREAD_MAPPING_PATH="$HOME/Bench-20-STM/2.Sharing Behavior/stamp/inputMaps/";\


cd ../tinySTM
make clean
make INSTRUMENT=-DINSTRUMENT=OFF BIND_THREAD=-DBIND_THREAD=TOPO_MATCH
cd ../stamp
./compile.sh

export STM_BIND_THREAD=TOPO_MATCH;\


./stamp-customMap.sh $executions $threads topomatch
