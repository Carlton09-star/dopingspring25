function [cols]=extractor(temp,time,source,sourcet)
%Extracts information from a json file

%Converts parameters into variable name of onelarge number
variable=sprintf('%d%d%d%d',temp,time,source,sourcet);
variable=str2double(variable);

%Converts the number to a letter so it is compatable with json file format
variable=numtol(variable);

name="D:\dopingspring25\data\json\"+variable+".json";
%Read the JSON file
try
    fileread(name)
catch
    clc
    error('This parameter has not been added please add it then try agin')
end

jsonText = fileread(name);

% Parse the JSON string
dataStruct = jsondecode(jsonText);

% Access the variables
cols = dataStruct.rowstart;
end



