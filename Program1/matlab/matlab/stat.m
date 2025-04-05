function [avg,standardd,standarde]=stat(dat,trials)
avg=average(dat);
standardd=std(dat);
standarde=standardd/sqrt(trials);
end