function [out]=setsize(in)

[row,collum]=size(in);
for i=1:row
    out(i)=in(i);
end
for i=row+1:10
    out(i)=0;
end
end