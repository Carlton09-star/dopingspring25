function []=graphplotter(temp,time,sourcet,source)
name=sprintf('%d_%d_%d_%d.csv',temp,time,sourcet,source);
data=matrixread(name);
x=data(1:2:end);
y=data(2:2:end);
plot(x,y)
title(name)
xlabel('trial number')
ylabel('Surface dopant atom count')

end

