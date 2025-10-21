% ---------- Helper Function for Adding Trials ----------

function data = addDopingData(data, sourcet, substrate, hasPd, hasDn, Ptemp, Ptime, Dtemp, Dtime, IV_data, Rs_data, Cd_data)
   function branch = addTrialBranch(branch, tempField, timeField, IV_data, Rs_data, Cd_data)
    % Ensure subfields exist
    if ~isfield(branch, tempField)
        branch.(tempField)=struct();
    end
    if ~isfield(branch.(tempField), timeField)
        branch.(tempField).(timeField)=struct();
    end

    % Find next available trial number
    trials = fieldnames(branch.(tempField).(timeField));
    if isempty(trials)
        trialNum=1;
    else
        nums=cellfun(@(x)sscanf(x,'t%d'),trials);
        trialNum=max(nums)+1;
    end
    trialField=sprintf('t%d',trialNum);

    % Add the data
    branch.(tempField).(timeField).(trialField)=struct('IV',IV_data,'Rs', Rs_data,'Cd', Cd_data);
end


% Helper function to add or update trial data in a doping experiment structure
        %load(DopingData.mat   Will be added in once data is put in
    % --- Ensure top-level fields exist ---
    if ~isfield(data,sourcet)
        data.(sourcet)=struct();
    end
    if ~isfield(data.(sourcet),substrate)
        data.(sourcet).(substrate)=struct();
    end

    % --- Add Predeposition data if available ---
    if hasPd
        PdField="Ptemp"+num2str(Ptemp);
        PtField="Ptime"+num2str(Ptime);

        if ~isfield(data.(sourcet).(substrate), 'Pd')
            data.(sourcet).(substrate).Pd=struct();
        end
        data.(sourcet).(substrate).Pd=addTrialBranch(data.(sourcet).(substrate).Pd, PdField, PtField, IV_data, Rs_data, Cd_data);
    end

    % --- Add Drive-in data if available ---
    if hasDn
        DdField="Dtemp"+num2str(Dtemp);
        DtField="Dtime"+num2str(Dtime);

        if ~isfield(data.(sourcet).(substrate),'Dn')
            data.(sourcet).(substrate).Dn=struct();
        end
        data.(sourcet).(substrate).Dn=addTrialBranch(data.(sourcet).(substrate).Dn,DdField,DtField,IV_data,Rs_data,Cd_data);
    end
    %save("DopingData.mat",data)
end




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





data=struct(sourcet,struct(substrate,struct('Pd',struct(Ptemp,struct(Ptime,struct(trialn,struct('Cd',Cd_data,'Rs',Rs_data,'IV',IV_data)))),'Dn',struct(Ptemp,struct(Ptime,struct(dtemp,struct(dtime,struct(trialn,struct('Cd',Cd_data,'Rs',Rs_data,'IV',IV_data)))))))));



data=addDopingData(data,"TP250","Silicon",true,true,1000,60,1200,120,[1,2,3,-1,-2,-3;10,20,30,-10,-20,-30],100,1*10^(-20));
data=addDopingData(data,"TP250","Silicon",true,false,900,90,[],[],[1,2,3,10,20,30],1000,3*10^(100));