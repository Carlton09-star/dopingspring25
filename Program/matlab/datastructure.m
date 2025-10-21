clc 
clear variables
%Nested Structure for data storage
Pretemp=900;
Pretime=90;

sourcet="TP470";
substrate="Silicon";
Ptemp="Ptemp"+num2str(Pretemp);
Ptime="Ptime"+num2str(Pretime);
trialn="t"+num2str(1);






data=struct(sourcet,struct(substrate,struct('Pd',struct(Ptemp,struct(Ptime,struct(trialn,struct('Cd',[],'Rs',[],'IV',[])))),'Dn',struct(Ptemp,struct(Ptime,struct(trialn,struct('Cd',[],'Rs',[],'IV',[])))))));


%% Haven't checked this next part yet need to test


clc
clear variables

% --- Example inputs ---
sourcet  = "TP470";   % could also be TP480, etc.
substrate = "Silicon";
Pretemp  = 900;
Pretime  = 90;

Ptemp = "Ptemp" + num2str(Pretemp);
Ptime = "Ptime" + num2str(Pretime);

% --- Initialize or load structure ---
if exist('data','var')
    % do nothing
else
    data = struct();
end

% --- Create source and substrate levels if they don't exist ---
if ~isfield(data, sourcet)
    data.(sourcet) = struct();
end

if ~isfield(data.(sourcet), substrate)
    data.(sourcet).(substrate) = struct('Pd', struct(), 'Dn', struct());
end

% --- Check Pd level (we’ll focus on Pd for example) ---
Pd = data.(sourcet).(substrate).Pd;

if ~isfield(Pd, Ptemp)
    Pd.(Ptemp) = struct();
end
if ~isfield(Pd.(Ptemp), Ptime)
    Pd.(Ptemp).(Ptime) = struct();
end

% --- Determine next trial automatically ---
trialNames = fieldnames(Pd.(Ptemp).(Ptime));
if isempty(trialNames)
    trialNum = 1;
else
    nums = cellfun(@(x) sscanf(x,'t%d'), trialNames);
    trialNum = max(nums) + 1;
end

trialfield = sprintf('t%d', trialNum);

% --- Add new trial ---
Pd.(Ptemp).(Ptime).(trialfield) = struct('Cd', [], 'Rs', [], 'IV', []);

% --- Write back to main structure ---
data.(sourcet).(substrate).Pd = Pd;

% --- Display result ---
disp(['Added trial ' trialfield ' to ' sourcet ', ' substrate])
