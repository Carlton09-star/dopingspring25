function [avg,standardd,standarde]=stat(dat,trials)
avg=mean(dat);
standardd=std(dat);
standarde=standardd/sqrt(trials);
end