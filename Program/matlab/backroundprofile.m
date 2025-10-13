function [backsheet,subst,bdt]=backroundprofile()

    backsheet=input('What is the backround sheet resistance of the wafer in Ohms/squae?\n');
    %update this based on what we use idk
    fprintf('1. Silicon     2.Glass\n');
    subst=input('What is the substrate of doping to be used?\n');
    if subst==1
        subst='Silicon';
    elseif subst==2
        subst='Glass';
    end
    clc
    fprintf('1. Boron       2. Phosphorus       3. Pure Silicon\n')
    bdt=input('What is the Backround dopant of the Wafer?\n');
    if bdt==1
        bdt='Boron';
    elseif bdt==2
        bdt='Phosphorus';
    elseif bdt==3
        bdt='Pure Silicon';
    end
end
