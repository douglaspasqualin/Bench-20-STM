#!/bin/bash

rootFolder=`pwd`

rm -rf Results

#create some folders
mkdir -p Results
cd Results
mkdir -p Sect4.1
mkdir -p Sect4.2
mkdir -p Sect4.3
mkdir -p Sect4.4
cd Sect4.4
mkdir -p 32th
mkdir -p 96th
cd ..
mkdir -p Sect4.5
mkdir -p Sect5.1

cd $rootFolder

#decompress input files used in some benchmarks
./DecompressStampInputs.sh

#Section 4.1
cd "1.Memory access info/stamp"
./run.sh 64

#move results to Results folder
mv *.txt ../../Results/Sect4.1/
cp ../../Scripts/MemoryInfo.R ../../Results/Sect4.1/


#Section 4.2
cd $rootFolder
cd "2.Sharing Behavior/stamp"
./runDefaultParam.sh 10 64
mv *.csv ../../Results/Sect4.2/
cp ../../Scripts/CalcMSE.R ../../Scripts/BoxPlot.R ../../Scripts/VisualCommMatrix.R ../../Results/Sect4.2/
cd ../../Results/Sect4.2/
Rscript CalcMSE.R
Rscript BoxPlot.R 
#Generate Visual communication Matrices
for f in *.csv; do
  Rscript VisualCommMatrix.R $f
done

#Section 4.3
cd $rootFolder
cd "2.Sharing Behavior/stamp"
./runSmallParam.sh 10 64
mv *.csv ../../Results/Sect4.3/
cp ../../Scripts/CalcMSENew.R ../../Scripts/BoxPlot.R ../../Scripts/VisualCommMatrix.R ../../Results/Sect4.3/
cd ../../Results/Sect4.3/
Rscript CalcMSENew.R
#Merge with the previous experiment (removing first line, because is the header)
tail -n +2 ../Sect4.2/mseCalculated.txt >> mseCalculated.txt 
Rscript BoxPlot.R 
#Generate Visual communication Matrices
for f in *.csv; do
  Rscript VisualCommMatrix.R $f
done

#Section 4.4
cd $rootFolder
#32 threads
cd "2.Sharing Behavior/stamp"
./runDefaultParam.sh 10 32
mv *.csv ../../Results/Sect4.4/32th
cp "../../PaperData/Sect. 4.4/32th/CalcMSE.R" ../../Scripts/BoxPlot.R ../../Scripts/VisualCommMatrix.R ../../Results/Sect4.4/32th
cd ../../Results/Sect4.4/32th
Rscript CalcMSE.R
Rscript BoxPlot.R 
#Generate Visual communication Matrices
for f in *.csv; do
  Rscript VisualCommMatrix.R $f
done

#96 threads
cd $rootFolder
cd "2.Sharing Behavior/stamp"
./runDefaultParam.sh 10 96
mv *.csv ../../Results/Sect4.4/96th
cp "../../PaperData/Sect. 4.4/96th/CalcMSE.R" ../../Scripts/BoxPlot.R ../../Scripts/VisualCommMatrix.R ../../Results/Sect4.4/96th
cd ../../Results/Sect4.4/96th
Rscript CalcMSE.R
Rscript BoxPlot.R 
#Generate Visual communication Matrices
for f in *.csv; do
  Rscript VisualCommMatrix.R $f
done

#Section 4.5
cd $rootFolder
cd "2.Sharing Behavior/stamp"
./verifyDynamic.sh 64
mv *.csv ../../Results/Sect4.5/
cp ../../Scripts/CalcMSEDynamic.R ../../Scripts/GenerateGraphDynamic.R ../../Scripts/VisualCommMatrix.R ../../Results/Sect4.5/
cd ../../Results/Sect4.5/
Rscript CalcMSEDynamic.R
Rscript GenerateGraphDynamic.R 
#Generate Visual communication Matrices
for f in *.csv; do
  Rscript VisualCommMatrix.R $f
done


#Section 5.1
cd $rootFolder
cd "2.Sharing Behavior/stamp"
./stamp-exec-ntimes.sh 10 32 && ./stamp-exec-ntimes.sh 10 64 ./stamp-exec-ntimes.sh 10 96
mv linux_default.txt staticMapping.txt ../../Results/Sect5.1/

cd $rootFolder
cd "3.Thread mapping/stamp"
./run.sh 10
mv online_mapping.txt ../../Results/Sect5.1/ 

cp "../../PaperData/Sect. 5.1/GenerateGraphs.R" ../../Results/Sect5.1/
java -jar ../../JavaParser/JavaParser.jar $HOME/Bench-20-STM/Results/Sect5.1/
cd ../../Results/Sect5.1/
Rscript GenerateGraphs.R
