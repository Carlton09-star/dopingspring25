function []=tables(temp,time,source,sourcet,data)

name1=sprintf('%d-%d-%d-%danalysis.csv',temp,time,source,sourcet);
name2="D:\dopingspring25\data\analysis\";
name=name2+name1;
% Open a text file to write the table

writematrix(data,name)
end
