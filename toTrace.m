function [ fid_trace ] = toTrace( slots, fileName, coloring, configFileName, generateConfig,resources)
% TOTRACE: from Matlab to TRACE tool translator 
%   Arguments:
%       (allocation) slots: Cell array with a cell per label. A cell
%                           corresponds to the allocation of a task to a (resource) slot.
%                           A cell is a vector that denotes alternating begin and end times (absolute) of the task.
%                           eg: [<start_time_t1> <end_time_t1> <start_time_t2> <end_time_t2>]
%       fileName: Name (string) of the *.etf file to generate. Please add the extension as well.       
%       coloring:   'unique': (default) coloring is unique whenever possible, 
%                   'alt-diff': coloring alternates for the same resource and color changes per resource 
%                   'alt-same': coloring alternates on the same resource and color is same per resource, 
%                   'same': the color is always same 
%       configFileName: Name (string) of the config file to generate/link the *.etf file
%       generateConfig: a boolean flag to generate/overwrite the config file. default= 1
%       resources: vector containing resource/processor labels.           
%   Returns:
%       fid_trace: file handle for the trace file
%   Assumptions:
%       1. Unique <TASK_NAMES>. May be updated if needed.
%       2. length(slots)==length(resources): Can be adapted for length(slots) corresponding to #tasks. The mapping/binding of tasks to resources then needs to be explicit.
%   Usage:
%       TOTRACE(slots)
%       TOTRACE(slots,fileName)
%       TOTRACE(slots,fileName,coloring)
%       TOTRACE(slots,fileName,coloring,configFileName)
%       TOTRACE(slots,fileName,coloring,configFileName,generateConfig)
%       TOTRACE(slots,fileName,coloring,configFileName,generateConfig,resources)

%   Author: Sajid Mohamed (s.mohamed@tue.nl)
%   Organization: Eindhoven University of Technology
%   Date: January 15, 2020
%% Default argument values
if nargin < 2
    fileName='traceMatlab.etf';
end

if nargin < 3
    coloring='unique';
end

if nargin < 4
    configFileName='config.txt';
end

if nargin < 5
    generateConfig=1;
end

if nargin < 6    
    % Just numbered labels
    resources = 1:size(slots, 1);
end
%% Constraint check
 if length(resources)~=length(slots) %CONSTRAINT FOR THE CURRENT TRANSLATOR.
     error('The number of resources (for resources) and number of allocation slots (for tasks) do not match.');
 end
%% Default Configuration File
if generateConfig
    configText=["ConfigurationVersion	V0.1\n"
                "ConfigurationName	Config\n"
                sprintf("ConfigurationID	%s\n",configFileName)
                "TimeScaleShift	0\n"
                "TimeScaleUnit	ms\n"
                "TimeDisplayFormat	%%3g\n"
                "ScaleClaimsActivityView	false\n"
                "Attribute	0	ResourceName	String	Describing	Grouping	Coloring\n"
                "Attribute	1	TaskName	String	Describing	Grouping\n"
                "Attribute	2	id	String	Describing	Coloring\n"
                "Context	0	Resource	0\n"
                "Context	1	Task	1	2\n"
                ];

    fid_config=fopen(configFileName,'w');
    for i=1:length(configText)
        fprintf(fid_config,configText(i));
    end
    fclose(fid_config);
end
%% Trace file: header generation in .etf 
traceText=["TraceVersion	V0.1\n"
           sprintf("ConfigurationID	%s\n",configFileName)
           sprintf("ConfigurationSource	%s\n",configFileName)
           "\n" ];        
fid_trace=fopen(fileName,'w');
for i=1:length(traceText)
    fprintf(fid_trace,traceText(i));
end
%% Trace file: Resources' lines in .etf 
for i=1:length(resources)
    %line=sprintf("R\t %1$d 100.0 unit 1 0 0 Processor_%1$d\n",i);
    line=sprintf("R\t%d\t100.0\tunit\t1\t0\t%s\n",i-1,resources(i));
    fprintf(fid_trace,line);
end
fprintf(fid_trace,"\n");
%% Trace file: Context's lines in .etf
Cid=0;color=0;
for i=1:length(resources)
    j=1;
    while j<size(slots{i},2)
        %BEGIN:COLORING
        if strcmp(coloring,'unique')
            color=Cid;
        elseif strcmp(coloring,'alt-diff')
            color=mod(Cid,2)+ 2*i;
        elseif strcmp(coloring,'alt-same')
            color=mod(Cid,2);
        elseif strcmp(coloring,'same')
            color=0;
        else
            color=Cid;
        end
        %END:COLORING
        %C <Cid> <Resource_allocated> <%utilisation> <start time> <finish time> 0 1 <task_name> <coloring to give> 
        line=sprintf("C\t%d\t%d\t100.0\t%.4f\t%.4f\t0\t1\ttaskInstance%.0d\t%d\n",Cid,i-1,slots{i}(j),slots{i}(j+1),Cid,color);
        fprintf(fid_trace,line);
        Cid=Cid+1;
        j=j+2;
    end
end        
fclose(fid_trace);
%END:function

