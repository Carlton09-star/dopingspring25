function data = addDopingData(data, sourcet, substrate, hasPd, hasDn, ...
    Ptemp, Ptime, Dtemp, Dtime, IV_data, Rs_data, Cd_data, Rb_data)
if ~isstruct(data)
    data = struct();
end

    function count = getTotalWaferCount(data)
        count = 0;
        sources = fieldnames(data);
        for i = 1:numel(sources)
            src = sources{i};
            substrates = fieldnames(data.(src));
            for j = 1:numel(substrates)
                sub = substrates{j};
                types = fieldnames(data.(src).(sub));
                for k = 1:numel(types)
                    type = types{k};
                    temps = fieldnames(data.(src).(sub).(type));
                    for m = 1:numel(temps)
                        tempField = temps{m};
                        times = fieldnames(data.(src).(sub).(type).(tempField));
                        for n = 1:numel(times)
                            timeField = times{n};
                            trials = fieldnames(data.(src).(sub).(type).(tempField).(timeField));
                            count = count + numel(trials);
                        end
                    end
                end
            end
        end
    end

    function branch = addWaferBranch(branch, tempField, timeField, ...
            IV_data, Rs_data, Cd_data, Rb_data, waferID)
        % Ensure subfields exist
        if ~isfield(branch, tempField)
            branch.(tempField) = struct();
        end
        if ~isfield(branch.(tempField), timeField)
            branch.(tempField).(timeField) = struct();
        end

        % Create wafer serial field
        waferField = sprintf('w%d', waferID);

        % Add the data
        branch.(tempField).(timeField).(waferField) = struct( ...
            'IV', IV_data, ...
            'Rs', Rs_data, ...
            'Cd', Cd_data, ...
            'Rb', Rb_data);
    end

    % --- Compute next wafer ID ---
    waferID = getTotalWaferCount(data) + 1;

    % --- Ensure top-level fields exist ---
    if ~isfield(data, sourcet)
        data.(sourcet) = struct();
    end
    if ~isfield(data.(sourcet), substrate)
        data.(sourcet).(substrate) = struct();
    end

    % --- Add Predeposition data if available ---
    if hasPd
        PdField = "Ptemp" + num2str(Ptemp);
        PtField = "Ptime" + num2str(Ptime);

        if ~isfield(data.(sourcet).(substrate), 'Pd')
            data.(sourcet).(substrate).Pd = struct();
        end
        data.(sourcet).(substrate).Pd = addWaferBranch( ...
            data.(sourcet).(substrate).Pd, PdField, PtField, ...
            IV_data, Rs_data, Cd_data, Rb_data, waferID);
    end

    % --- Add Drive-in data if available ---
    if hasDn
        DdField = "Dtemp" + num2str(Dtemp);
        DtField = "Dtime" + num2str(Dtime);

        if ~isfield(data.(sourcet).(substrate), 'Dn')
            data.(sourcet).(substrate).Dn = struct();
        end
        data.(sourcet).(substrate).Dn = addWaferBranch( ...
            data.(sourcet).(substrate).Dn, DdField, DtField, ...
            IV_data, Rs_data, Cd_data, Rb_data, waferID);
    end
end
