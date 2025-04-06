function [out]=setsize(in)

[~,collum]=size(in);
for i=1:collum
    out(i)=in(i);
end
for i=collum+1:10
    out(i)=0;
end
end