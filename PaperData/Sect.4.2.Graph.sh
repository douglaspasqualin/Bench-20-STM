#!/bin/bash

cd "Sect. 4.2"
Rscript CalcMSE.R 
Rscript BoxPlot.R

#Generate Visual communication Matrices
for f in *.csv; do
  Rscript VisualCommMatrix.R $f
done

