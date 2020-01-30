%% A simple demo to use the toTrace() function to generate the *.etf and config.txt (if needed) file(s) 
clc;
clear all;
close all;
help toTrace
configFileName='config.txt';
fileName='traceMatlab.etf';
coloring='unique';
resources=["P1"
        "P2"
        "P3"
        "P4"];
slots={[0 1 2 3 4 5 6 7],
       [1 2 3 4],
       [1 2 3 4],
       [1 4 5 6]
      }; 
%FORMAT: toTrace(slots, fileName, coloring, configFileName, generateConfig,resources)
toTrace(slots, fileName, coloring, configFileName,1,resources);
toTrace(slots, 'traceMatlab.etf', 'same',configFileName,0);