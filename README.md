# Reproducing the experiments of Bench'20 - Paper 19

## Overview

* [Paper Info](#paper-info)
* [Environment](#environment)
* [Software prerequisites](#software-prerequisites)
* [Running all experiments](#running-all-experiments)
* [Running individual experiments](#running-individual-experiments)
  * [Section 4.1 (STM memory access information)](#section-41-stm-memory-access-information)
  * [Section 4.2 (Stability across different executions)](#section-42-stability-across-different-executions)
  * [Section 4.3 (Stability when changing input)](#section-43-stability-when-changing-input)
  * [Section 4.4 (Stability with different number of threads)](#section-44-stability-with-different-number-of-threads)
  * [Section 4.5 (Dynamic behavior)](#section-45-dynamic-behavior)
  * [Section 5.1 (Case Study)](#section-51-case-study)
  * [Section 5.2 (False sharing in Kmeans)](#section-52-false-sharing-in-kmeans)

## Paper Info

* Paper ID: 19
* Title: Characterizing the Sharing Behavior of Applications using Software Transactional Memory
* Authors: Douglas Pereira Pasqualin, Matthias Diener, André Rauber Du Bois and Maurício Lima Pilla


## Environment 
To run the experiments, we have used a Xeon machine with 8 sockets/NUMA nodes. Each socket has 12 cores totalling 96 cores (192 threads). For more details, please see the file [xeon.png](xeon.png)

## Software prerequisites
To reproduce our experiments, the following packages/applications are necessary:

- gcc
- tar, gzip
- make
- hwloc (with development headers)
- Java
- R
- Ghostscript (embed fonts in R)

On Debian-based Linux distributions, the following command installs the required packages:

`$ sudo apt-get install tar gzip build-essential hwloc libhwloc-dev default-jre r-base r-cran-car r-cran-ggplot2 ghostscript`

Installing additional R packages.

`$ sudo Rscript Scripts/InstallPackages.R`

For online thread mapping, [TopoMatch](https://gitlab.inria.fr/ejeannot/topomatch) must be installed. The same version used in the paper can be found in the folder [Tool](Tools). The following commands will install TopoMatch in the home folder:
```
$ cd Tools
$ tar -zxvf topomatch-1.0.tar.gz
$ cd topomatch-1.0/
$ ./configure --prefix=$HOME/topomatch
$ make install
```

Others (To decompress input files used in some benchmarks)

`$ ./DecompressStampInputs.sh`

## Running all experiments

After installing all [prerequisites](#software-prerequisites), the easiest way to run all experiments described in the paper is to clone this repository in your home directory and run:

`$ ./run-all.sh`

This script will run all experiments with exactly the same configuration that we have used in the paper. It will probably take **more than 24 hours** to run all experiments. Also, make sure that the machine where you will run the experiments supports at least 192 threads. Additionally, this script will generate the graphs in the "Results" folder.

The next subsections explain how to run each experiment in the paper individually.

## Running individual experiments

### Section 4.1 (STM memory access information)
To be able to reproduce this experiment, it is necessary to use the modified tinySTM and STAMP benchmark suite available in the folder [1.Memory access info](1.Memory%20access%20info). In this folder, type:
```
$ cd stamp
$ ./run.sh NUMBER_THREADS
```

For each stamp application, one text file will be generated as an output. The file will have the following format: 

_APPLICATION_NAME_memoryInfo_NUMBER_THREADS.txt_

To generate the data of Table 2 shown in the paper, use the script [MemoryInfo.R](Scripts/MemoryInfo.R) in folder [Scripts](Scripts):

`$ Rscript MemoryInfo.R fileName.txt`

In the folder [PaperData/Sect. 4.1](PaperData/Sect.%204.1) there are two files used to generate the data in the paper (Table 2). Due to the large size of the other files, some of them more than 1 GiB, we can not put all of them in this repository.

### Section 4.2 (Stability across different executions)
To be able to reproduce this experiment, it is necessary to use the modified tinySTM and STAMP benchmark available in the folder [2.Sharing Behavior](2.Sharing%20Behavior). In this folder, type:
```
$ cd stamp
$ ./runDefaultParam.sh NUMBER_EXECUTIONS NUMBER_THREADS
```

In the paper, we used 64 threads and 10 executions. For each STAMP application and for each execution, a .csv file will be generated with the communication matrix. We have used those matrices to calculate the MSE and generate the graphs. 

To calculate the MSE of all .csv files in a folder, use the script [CalcMSE.R](Scripts/CalcMSE.R), available in the folder [Scripts](Scripts).

* Note: This script is configured to generate the MSE for 64 threads. To change it, edit the line [57](Scripts/CalcMSE.R#L57).
* Note: It is necessary more than one csv per application in order to calculate the MSE.

The script will generate a file _mseCalculated.txt_, that can be used for input to generate the graphic. Use the script [BoxPlot.R](Scripts/BoxPlot.R) to generate the graphic.

To generate the graphic used in the paper, open the folder [PaperData](PaperData) and type:

`$ ./Sect.4.2.Graph.sh`

Open the folder [Sect. 4.2](PaperData/Sect.%204.2) and there will be the file _Figure_1.pdf_ and other pdfs with all communication matrices generated in this experiment.

### Section 4.3 (Stability when changing input)
In the folder [2.Sharing Behavior](2.Sharing%20Behavior), type:
```
$ cd stamp
$ ./runSmallParam.sh NUMBER_EXECUTIONS NUMBER_THREADS
```

In the paper, we have used 64 threads and 10 executions. Like the previous experiment, it will generate the communication matrices. To calculate the MSE, use the script [CalcMSENew.R](Scripts/CalcMSENew.R). Like the previous experiment, it will generate a file called _mseCalculated.txt_. Do a merge of the previous _mseCalculated.txt_ file with this new one and use the script [BoxPlot.R](Scripts/BoxPlot.R) to generate the graphic, comparing both.

To generate the graphic used in the paper, open the folder [PaperData](PaperData) and type:

`$ ./Sect.4.3.Graph.sh`

Open the folder [Sect. 4.3](PaperData/Sect.%204.3) and there will be the file _Figure_3.pdf_ and other pdfs with all communication matrices generated in this experiment.

### Section 4.4 (Stability with different number of threads)

For this experiment, just follow the instructions of [Section 4.1](#section-41-stm-memory-access-information), just changing  NUMBER_THREADS. In the paper, we have used 32 and 96 threads and 10 executions.

To generate the figure used in the paper, open the folder [PaperData](PaperData) and type:

`$ ./Sect.4.4.Graph.sh`

Open the folder [Sect. 4.4](PaperData/Sect.%204.4) and there will be two subfolders. Inside the folder [32th](PaperData/Sect.%204.4/32th) there will be the file _Figure_5a.pdf_ and under the folder [96th](PaperData/Sect.%204.4/96th) the file _Figure_5b.pdf_. 


### Section 4.5 (Dynamic behavior)

To be able to reproduce this experiment, it is necessary to save at least 10 communication matrices during the run of each application. To do that, we have used a metric called **SAVE_EVERY** based on the total of memory addresses accessed by one thread. In the script [verifyDynamic.sh](2.Sharing%20Behavior/stamp/verifyDynamic.sh) there are all values of **SAVE_EVERY** that we have used to generate the matrices, using 64 threads. In the folder [2.Sharing Behavior](2.Sharing%20Behavior), type
```
$ cd stamp
$ ./verifyDynamic.sh NUMBER_THREADS
```

To calculate the MSE of all .csv files in the folder, use the script [CalcMSEDynamic.R](Scripts/CalcMSEDynamic.R). After that, use the script [GenerateGraphDynamic.R](Scripts/GenerateGraphDynamic.R) to generate the graphic.

To generate the graphic used in the paper, open the folder [PaperData](PaperData) and type:

`$ ./Sect.4.5.Graph.sh`

Open the folder [Sect. 4.5](PaperData/Sect.%204.5) and there will be the file _Figure_7.pdf_ and other pdfs with all communication matrices generated in this experiment

### Section 5.1 (Case Study)

To be able to reproduce this experiment, the applications must be executed running a _linux default configuration_, and a static and online thread mapping.

To create the inputs used for static thread mapping, we have used the [TopoMatch](https://gitlab.inria.fr/ejeannot/topomatch) tool. First, we need a communication matrix of each application for each thread configuration that we would like to use a static mapping.

* Note: Instead of using the .csv file, TopoMatch uses .mat files, but these files are generated by our mechanism, together with the .csv files. 

For 64 threads it is possible to use the matrices generated in [Section 4.1](#section-41-stm-memory-access-information). For 32 and 96, the matrices generated in [Section 4.4](#section-44-stability-with-different-number-of-threads).

Before using TopoMatch, it is necessary to generate an xml file of the machine topology. This file can be generated using hwloc:

`$ lstopo --no-io --merge --of xml >> topology.xml`

After that, we can use the "mapping" tool (part of TopoMatch, installed in [Prerequisites](#software-prerequisites)), sending the topology and the communication matrix to generate the optimized mapping. For instance:

`$ #HOME/topomatch/bin/mapping -x topology.xml -c genome_64.mat`

Copy all numbers of the result of the first line _TopoMatch_:
![Alt text](mapping.png?raw=true "Output of mapping tool. Part of TopoMatch")

In the [2.Sharing Behavior/stamp](2.Sharing%20Behavior/stamp) folder, create a folder called **inputMaps** and in this folder, create a subfolder for each thread configuration. Finally, in each thread subfolder, create a file called _topo.txt_.

Paste the result of the generated topomatch mapping to this file. 

* Note: In each subfolder, each application mapping must be in the same order in all files. 

Before running the application, the environment variable **MAP_LINE** must be set, mapping each line of _topo.txt_ file to their respective static thread mapping configuration. See the file [stamp-customMap.sh](2.Sharing%20Behavior/stamp/stamp-customMap.sh). 

To facilitate the execution, we kept our [static mapping](2.Sharing%20Behavior/stamp/inputMaps) calculated for the machine that we have used. Thus, just type the following command to run all experiments using linux default configuration and the static thread mapping: 

`$ ./stamp-exec-ntimes.sh NUMBER_EXECUTIONS NUMBER_THREADS`

* Note: Verify the environment variable [THREAD_MAPPING_PATH](2.Sharing%20Behavior/stamp/stamp-exec-ntimes.sh#L29) inside [stamp-exec-ntimes.sh](2.Sharing%20Behavior/stamp/stamp-exec-ntimes.sh) to make sure that the path to the folder inputMaps is correct.

The result of the execution will be save in the files _linux_default.txt_ and _staticMapping.txt_

Finally, for the online thread mapping, use the files under the folder [3.Thread mapping](3.Thread%20mapping). Under this folder type:
```
$ cd stamp
$ ./run.sh NUMBER_EXECUTIONS
```

* Note: This script is configured to run using 32, 64 and 96 threads.

The result of the execution will be save in the file _online_mapping.txt_

To generate the graphs, we have used a text file with the following data (separated by TAB):

APPLICATION	THREADS	TIME	CONFIGURATION.

See the file [timeExec.txt](PaperData/Sect.%205.1/timeExec.txt) as an example. Additionally, you can use the JavaParser to generate the outputfile. Copy the generated _linux_default.txt_ , _staticMapping.txt_ and _online_mapping.txt_ to a new folder and use:

`java -jar JavaParser/JavaParser.jar PATH_TO_FILES`

It will generate a file _timeExec.txt_. Use the script [GenerateGraphs.R](Scripts/GenerateGraphs.R) to generate the graphic.

To generate the graphic used in the paper, open the folder [PaperData](PaperData) and type:

`$ ./Sect.5.1.Graph.sh`

Open the folder [Sect. 5.1](PaperData/Sect.%205.1), there will be the graphics comparing the execution time of each configuration, grouped by thread number.


### Section 5.2 (False sharing in Kmeans)

For this experiment, it is necessary to change line [252](2.Sharing%20Behavior/stamp/kmeans/normal.c#L252) in the file [stamp/kmeans/normal.c](2.Sharing%20Behavior/stamp/kmeans/normal.c)

Replace 
* const int cacheLineSize = 32; with
* const int cacheLineSize = 64;

Re-run the application using the desired configuration.

Under the folder [PaperData/Sect. 5.2](PaperData/Sect.%205.2) there is a .csv file [kmeans_false_sharing.csv](PaperData/Sect.%205.2/kmeans_false_sharing.csv) with the results of our runs. These results are in Table 4 in the paper.
