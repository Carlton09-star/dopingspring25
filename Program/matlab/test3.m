clc; clear;

data = [];

% Pd+Dn wafer
data = addDopingData(data, "TP470", "Silicon", true, true, 900, 90, 1000, 90, ...
    [1,2,3,-1,-2,-3], 100, 1e26, 1000, 10);

% Pd-only wafer
data = addDopingData(data, "TP250", "Silicon", true, false, 1000, 60, [], [], ...
    [1,2,3,10,20,30], 100, 1e-20, 100, 5);

% Edit a wafer
data = editWaferData(data, "TP470", "Silicon", "Predeposition+Drive-in", 900, 90, 1, 'Rs', 150);

% Convert to table
T = structToTable2(data);
disp(T);
