function []=updater(temp,time,source,sourcet,path)
if sourcet==1
    sheet="GS-245";
elseif sourcet==2
    sheet="GS-139";
elseif sourcet==3
    sheet="TP-250";
elseif sourcet==4
    sheet="TP-470";
end

dat=readmatrix(path,'Sheet',sheet);
dat=dat(1:3,:);
[~,col]=size(dat);
s=col+1;

var=sprintf('%d%d%d%d',temp,time,source,sourcet);

%In all honesty I'm not complety sure if this will only ever generate
%unique variable names or if it will ever repeat If there is an issue with
%new 

var=str2double(var);
var=numtol(var);




filename = "D:\dopingspring25\data\json\"+var+".json";

data=struct('rowstart',s);

jsonText=jsonencode(data);

fid = fopen(filename, 'w');
if fid == -1
    error('Cannot create JSON file');
end
fwrite(fid, jsonText, 'char');
fclose(fid);





col1=numtol(s);
col2=numtol(s+16);
range1=sprintf('%s3:%s3',col1,col2);
col3=numtol(s+14);
col4=numtol(s+23);
range2=sprintf('%s3:%s3',col3,col4);
col5=numtol(s+24);
col6=numtol(s+32);
range3=sprintf('%s3:%s3',col5,col6);
range4=sprintf('%s2:%s2',col1,col2);
cells1={"Wafer #","zone 1 temp","zone 2 temp","zone 3 temp","input Current (A)"};
cells2={"Reading (V)"};
cells3={"Sheet Resistance","diffusion length (microns)","junction depth (microns)","Peak concentration","Anneal Time","Backround Sheet resistance","Substrate","Backround doping type"};
writecell(cells1,path,'Sheet',sheet,'Range',range1)
writecell(cells2,path,'Sheet',sheet,'Range',range2)
writecell(cells3,path,'Sheet',sheet,'Range',range3)

name=sprintf('%d degrees Celcius for %d minutes source %d',temp,time,source);

writematrix(name,path,'Sheet',sheet,'Range',range4)

end
