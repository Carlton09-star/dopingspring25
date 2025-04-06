function []=updater(temp,time,source,sourcet,path)
if sourcet==1
    sheet="GS-245";
elseif sourcet==2
    sheet="GS-129";
end

dat=readmatrix(path,'Sheet',sheet);
dat=dat(1:3,:);
[~,col]=size(dat);
s=col+1;

var=sprintf('%d%d%d%d',temp,time,source,sourcet);

%In all honesty I'm not complety sure if this will only ever generate
%unique variable names or if it will ever repeat If there is an issue with
%new 
var=numtol(var);



% Step 3: Write the JSON string to a file
filename = 'D:\dopingspring25\updatedcol.json';

% Step 1: Read the existing JSON file
    fid = fopen(filename, 'r');
    raw = fread(fid, inf);
    str = char(raw');
    fclose(fid);
    data = jsondecode(str);

% Step 2: Modify the data
newEntry = struct(var,s);
if isfield(data, 'entries')
    data.entries(end+1) = newEntry;
else
    data.entries = newEntry;
end

% Step 3: Write the modified data back to the JSON file
jsonStr = jsonencode(data);
fid = fopen(filename, 'w');
if fid == -1
    error('Cannot open file for writing.');
end
fwrite(fid, jsonStr, 'char');
fclose(fid);


end
