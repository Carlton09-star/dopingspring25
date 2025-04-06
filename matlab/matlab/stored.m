function [stand1,stand2,stand3,stand4,stand5,stand6,stand7,stand8,stand9]=stored()
% Step 1: Read the JSON file
jsonText = fileread('D:\dopingspring25\data.json');

% Step 2: Decode the JSON string
dataStruct = jsondecode(jsonText);

% Step 3: Access individual variables
stand1 = dataStruct.stand1;
stand2 = dataStruct.stand2;
stand3 = dataStruct.stand3;
stand4 = dataStruct.stand4;
stand5 = dataStruct.stand5;
stand6 = dataStruct.stand6;
stand7 = dataStruct.stand7;
stand8 = dataStruct.stand8;
stand9 = dataStruct.stand9;
end


