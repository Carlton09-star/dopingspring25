function []=standeditor(stande,ev)

%Records all of the standardvalues from the json file
[stand1,stand2,stand3,stand4,stand5,stand6,stand7,stand8,stand9]=stored();

%Changes the relevent standard value
if  stande==1
    stand1=ev;
elseif stande==2
    stand2=ev;
elseif stande==3
    stand3=ev;
elseif stande==4
    stand4=ev;
elseif stande==5
    stand5=ev;
elseif stande==6
    stand6=ev;
elseif stande==7
    stand7=ev;
elseif stande==8
    stand8=ev;
elseif stande==9
    stand9=ev;
end

data = struct('stand1',stand1 , 'stand2', stand2, 'stand3',stand3, 'stand4',stand4,'stand5',stand5,'stand6',stand6,'stand7',stand7,'stand8',stand8,'stand9',stand9);

% Encode the structure into a JSON string
jsonText = jsonencode(data);

% Specify the path to save the JSON file
filePath = 'D:\dopingspring25\data.json';

% Write the JSON string to the file
fid = fopen(filePath, 'w');
if fid == -1
    warning('Cannot find JSON file please input path');
    path=input('');
    fid=fopen(path,'w');
end

fwrite(fid, jsonText, 'char');
fclose(fid);