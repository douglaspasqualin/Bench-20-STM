#!/bin/bash

if [ $# -gt 2 ]; then
    executions=$1
    shift
    threads=$1
    shift
    filename=$2
    shift
else
    echo "execute.sh nb-executions nb-threads"
    exit
fi

#Bayes	
  export MAP_LINE=1;\
  for j in `seq 1 $executions`; do
    ./bayes/bayes -v32 -r8192 -n10 -p40 -i2 -e8 -s1 -t ${threads} | tee -a staticMapping.txt
  done

#Genome
  export MAP_LINE=2;\
  for j in `seq 1 $executions`; do
    ./genome/genome -g49152 -s256 -n33554432 -t ${threads} | tee -a staticMapping.txt
  done

#Intruder
  export MAP_LINE=3;\
  for j in `seq 1 $executions`; do
    ./intruder/intruder -a10 -l128 -n262144 -s1 -t ${threads} | tee -a staticMapping.txt
  done


#Kmeans
  export MAP_LINE=4;\
  for j in `seq 1 $executions`; do
    ./kmeans/kmeans -m40 -n40 -t0.00001 -i kmeans/inputs/random-n65536-d32-c16.txt -p ${threads} | tee -a staticMapping.txt
  done

#Labyrinth
  export MAP_LINE=5;\
  for j in `seq 1 $executions`; do
    ./labyrinth/labyrinth -i labyrinth/inputs/random-x1024-y1024-z9-n1024.txt -t ${threads} | tee -a staticMapping.txt
  done

#ssca2
  export MAP_LINE=6;\
  for j in `seq 1 $executions`; do
    ./ssca2/ssca2 -s21 -i1.0 -u1.0 -l3 -p3 -t ${threads} | tee -a staticMapping.txt
  done

#Vacation
  export MAP_LINE=7;\
  for j in `seq 1 $executions`; do
    ./vacation/vacation -n4 -q90 -u100 -r1310720 -t16777216 -c ${threads} | tee -a staticMapping.txt
  done


#Yada
  export MAP_LINE=8;\
  for j in `seq 1 $executions`; do
    ./yada/yada -a15 -i yada/inputs/ttimeu1000000.2 -t ${threads} | tee -a staticMapping.txt
  done
