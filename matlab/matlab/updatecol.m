function [cols]=extractor(temp,time,source,sourcet)
%Extracts information from a json file

%Converts parameters into variable name of onelarge number
variable=sprintf('%d%d%d%d',temp,time,source,sourcet);

%Converts the number to a letter so it is compatable with json file format
variable=numtol(variable);

%Read the JSON file
jsonText = fileread('D:\dopingspring25\updatedcol.json.json');

% Parse the JSON string
dataStruct = jsondecode(jsonText);

% Access the variables
cols = dataStruct.variable;
end



