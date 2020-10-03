#!/bin/bash

if [ $# -gt 0 ]; then
    threads=$1
else
    echo "verifyDynamic.sh nb-threads"
    exit
fi

export STM_STATS=1;\


cd ../tinySTM
make clean
make INSTRUMENT=-DINSTRUMENT=DYNAMIC BIND_THREAD=-DBIND_THREAD=LINUX_DEFAULT
cd ../stamp
./compile.sh


export SAVE_EVERY=2500;\
./bayes/bayes -v32 -r8192 -n10 -p40 -i2 -e8 -s1 -t ${threads} | tee -a RawResults.txt

export SAVE_EVERY=200000;\
./genome/genome -g49152 -s256 -n33554432 -t ${threads} | tee -a RawResults.txt

export SAVE_EVERY=9000000;\
./intruder/intruder -a10 -l128 -n262144 -s1 -t ${threads} | tee -a RawResults.txt

export SAVE_EVERY=3000;\
./labyrinth/labyrinth -i labyrinth/inputs/random-x1024-y1024-z9-n1024.txt -t ${threads} | tee -a RawResults.txt

export SAVE_EVERY=2000000;\
./kmeans/kmeans -m40 -n40 -t0.00001 -i kmeans/inputs/random-n65536-d32-c16.txt -p ${threads} | tee -a RawResults.txt

export SAVE_EVERY=350000;\
./ssca2/ssca2 -s21 -i1.0 -u1.0 -l3 -p3 -t ${threads} | tee -a RawResults.txt

export SAVE_EVERY=9000000;\
./vacation/vacation -n4 -q90 -u100 -r1310720 -t16777216 -c ${threads} | tee -a RawResults.txt

export SAVE_EVERY=5000000;\
./yada/yada -a15 -i yada/inputs/ttimeu1000000.2 -t ${threads} | tee -a RawResults.txt

