# Matlab2Trace
A Matlab script to generate Trace-input file (in \*.etf format), if you want to generate Trace file from Matlab environment.
For more details on the Trace tool: 
https://www.esi.nl/solutions/trace/index.dot.

# Prerequisites
Matlab is installed in your system. The Matlab script is independent of the Trace tool.
Trace software needs to be installed if you want to visualise the results. 
## Installing Trace 
Following the steps from https://www.esi.nl/solutions/trace/trace-getting-started.dot.

## How to run the Demo?
1.	Copy both `toTrace.m` and `toTraceDemo.m` to the same folder.
2.	Run `toTraceDemo.m` in Matlab.
This will generate three files: `traceMatlab.etf`, `traceMatlab2.etf` and `config.txt`. 	
3.	Copy the files `traceMatlab.etf`, `traceMatlab2.etf` and `config.txt` to the TRACE workspace directory you have created during Trace installation.
4.	Open the `\*.etf` files in ESI TRACE viewer.

