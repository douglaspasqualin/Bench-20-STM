#!/bin/bash

ScriptFolder=`pwd`


cd "1.Memory access info/stamp"
cd kmeans/inputs/
gzip -d random-n65536-d32-c16.txt*
cd ../../
cd yada/inputs
gzip -d ttimeu1000000.2*

cd $ScriptFolder
cd "2.Sharing Behavior/stamp"
cd kmeans/inputs/
gzip -d random-n65536-d32-c16.txt*
cd ../../
cd yada/inputs
gzip -d ttimeu1000000.2*
gzip -d ttimeu100000.2*

cd $ScriptFolder
cd "3.Thread mapping/stamp"
cd kmeans/inputs/
gzip -d random-n65536-d32-c16.txt*
cd ../../
cd yada/inputs
gzip -d ttimeu1000000.2*

