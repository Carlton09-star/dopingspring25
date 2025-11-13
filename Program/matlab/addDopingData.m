function data = addDopingData(data, sourcet, substrate, hasPd, hasDn, ...
    Ptemp, Ptime, Dtemp, Dtime, IV_data, Rs_data, Cs_data, Cbg_data, Rsheet_data)

if ~isstruct(data)
    data = struct();
end

% --- Compute next trial number (serial) ---
trialNum = 1;
sources = fieldnames(data);
for i = 1:numel(sources)
    src = sources{i};
    subs = fieldnames(data.(src));
    for j = 1:numel(subs)
        sub = subs{j};
        types = fieldnames(data.(src).(sub));
        for k = 1:numel(types)
            type = types{k};
            temps = fieldnames(data.(src).(sub).(type));
            for m = 1:numel(temps)
                tempF = temps{m};
                times = fieldnames(data.(src).(sub).(type).(tempF));
                for n = 1:numel(times)
                    timeF = times{n};
                    wafers = fieldnames(data.(src).(sub).(type).(tempF).(timeF));
                    trialNum = trialNum + numel(wafers);
                end
            end
        end
    end
end

% --- Ensure top-level fields exist ---
if ~isfield(data, sourcet)
    data.(sourcet) = struct();
end
if ~isfield(data.(sourcet), substrate)
    data.(sourcet).(substrate) = struct();
end

% --- Add Predeposition-only wafer ---
if hasPd && ~hasDn
    procField = 'Pd';
    tempField = sprintf('Ptemp%d', Ptemp);
    timeField = sprintf('Ptime%d', Ptime);
    if ~isfield(data.(sourcet).(substrate), procField)
        data.(sourcet).(substrate).(procField) = struct();
    end
    if ~isfield(data.(sourcet).(substrate).(procField), tempField)
        data.(sourcet).(substrate).(procField).(tempField) = struct();
    end
    if ~isfield(data.(sourcet).(substrate).(procField).(tempField), timeField)
        data.(sourcet).(substrate).(procField).(tempField).(timeField) = struct();
    end
    waferField = sprintf('w%d', trialNum);
    data.(sourcet).(substrate).(procField).(tempField).(timeField).(waferField) = ...
        struct('IV', IV_data, 'Rs', Rs_data, 'Cs', Cs_data, 'Cbg', Cbg_data, 'Rsheet', Rsheet_data);
end

% --- Add Pd+Dn wafer ---
if hasPd && hasDn
    procField = 'PdDn';
    tempField = sprintf('Ptemp%d', Ptemp);
    timeField = sprintf('Ptime%d', Ptime);
    if ~isfield(data.(sourcet).(substrate), procField)
        data.(sourcet).(substrate).(procField) = struct();
    end
    if ~isfield(data.(sourcet).(substrate).(procField), tempField)
        data.(sourcet).(substrate).(procField).(tempField) = struct();
    end
    if ~isfield(data.(sourcet).(substrate).(procField).(tempField), timeField)
        data.(sourcet).(substrate).(procField).(tempField).(timeField) = struct();
    end
    waferField = sprintf('w%d', trialNum);
    data.(sourcet).(substrate).(procField).(tempField).(timeField).(waferField) = ...
        struct('Dtemp', Dtemp, 'Dtime', Dtime, 'IV', IV_data, 'Rs', Rs_data, ...
               'Cs', Cs_data, 'Cbg', Cbg_data, 'Rsheet', Rsheet_data);
end
end
