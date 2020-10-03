#!/bin/bash

cd "Sect. 4.3"
Rscript BoxPlot.R

#Generate Visual communication Matrices
for f in *.csv; do
  Rscript VisualCommMatrix.R $f
done

