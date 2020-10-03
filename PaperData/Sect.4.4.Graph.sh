#!/bin/bash

cd "Sect. 4.4/32th"
Rscript CalcMSE.R 
Rscript BoxPlot.R

#Generate Visual communication Matrices
for f in *.csv; do
  Rscript VisualCommMatrix.R $f
done

cd ../96th
Rscript CalcMSE.R 
Rscript BoxPlot.R

#Generate Visual communication Matrices
for f in *.csv; do
  Rscript VisualCommMatrix.R $f
done
