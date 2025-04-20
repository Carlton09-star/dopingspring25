function []=totalstore(temp,time,source,sourcet,wafern,data)

%Gives a name to the file
name1=sprintf('%d-%d-%d-%d-%dtotalout.txt',temp,time,source,sourcet,wafern);
name2="D:\dopingspring25\data\totalout\";
name=name2+name1;

%Opens a file with above name
filen=fopen(name,'a');

%Prints the output voltage into a text file with the given name and formats
%it a little nicely
[~,col]=size(data);
for i=1:col
fprintf(filen,'%10.5f   ',data(i));
end
fprintf(filen,'\n');


fclose(filen);

end
