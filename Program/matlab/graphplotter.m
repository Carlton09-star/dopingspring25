function []=graphplotter(temp,time,sourcet,source)
name=sprintf('%d_%d_%d_%d.csv',temp,time,sourcet,source);
part1="D:\dopingspring25\data\plots\";
name1=part1+name;
try 
    readmatrix(name1);
catch
    warning('Bad path to file please input the path to the data you are looking for')
    name1=input('');
end

data=readmatrix(name1);
[col,~]=size(data);
x=data(1:2:end);
y=data(2:2:end);
ymax=max(y)*10;
ymin=min(y)/10;

plot(x,y,'o', 'MarkerSize', 5, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r')
set(gca, 'YScale', 'log'); % Set y-axis to logarithmic scale
title(name)
xlabel('trial number')
ylabel('Surface dopant atom count')
xlim([0,col+1]);
xticks(0:1:col+1);
ylim([ymin,ymax]);

end

