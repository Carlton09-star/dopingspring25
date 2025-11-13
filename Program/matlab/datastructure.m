



clc 
clear variables

%Nested Structure for data storage
Pretemp=900;
Pretime=90;
dtemp=1000;
dtime=120;

sourcet="TP470";
substrate="Silicon";
Ptemp="Ptemp"+num2str(Pretemp);
Ptime="Ptime"+num2str(Pretime);
dtemp="Dtemp"+num2str(dtemp);
dtime="Dtime"+num2str(dtime);
trialn="t"+num2str(1);
Cd_data=1*10^(26);
Rs_data=100;
IV_data=[1,10,100,-1,-10,-100;2,20,200,-2,-20,-200];
load('Data.mat')
data=addDopingData(data,sourcet,substrate,true,true,Pretemp,Pretime,1000,90,IV_data,Rs_data,Cd_data,1000,1);

data=addDopingData(data,"TP250","Silicon",true,true,1000,60,1200,120,[1,2,3,-1,-2,-3;10,20,30,-10,-20,-30],100,1*10^(-20),100,1);

data=addDopingData(data,"TP250","Silicon",true,false,900,90,[],[],[1,2,3,10,20,30],1000,3*10^(100),10,1);

an=data;