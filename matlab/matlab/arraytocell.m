function [v4]=arraytocell(v1,en)
[~,coll]=size(v1);
if coll==1
    v2=sprintf('[%d]',v1);
elseif coll==2
    v2=sprintf('[%d,%d]',v1);
elseif coll==3
    v2=sprintf('[%d,%d,%d]',v1);
elseif coll==4
    v2=sprintf('[%d,%d,%d,%d]',v1);
elseif coll==5
    v2=sprintf('[%d,%d,%d,%d,%d]',v1);
end
a="stand"+en+"=";

v3=sprintf('%s%s;',a,v2);
v4={v3};
end