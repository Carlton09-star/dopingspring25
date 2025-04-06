function []=datastorer(temp,time,sourcet,source,wafernumber,peak)
name=sprintf('%d_%d_%d_%d.csv',temp,time,sourcet,source);
part1="D:\dopingspring25\data\plots\";
file=part1+name;
data=[wafernumber;peak];
writematrix(data,file,"WriteMode","append")
end
