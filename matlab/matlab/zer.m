function [en]=zer(en)
[~,col]=size(en);
for i=1:col
if en(i)==0
    en(i)=NaN;
end
end
end
