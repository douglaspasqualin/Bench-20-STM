#!/bin/bash

cd "Sect. 4.5"
Rscript CalcMSE.R
Rscript GenerateGraph.R

#Generate Visual communication Matrices
for f in *.csv; do
  Rscript VisualCommMatrix.R $f
done

