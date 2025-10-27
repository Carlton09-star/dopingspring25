function T = structToTable(data)
    rows = [];  % initialize array of structures   each row
    sources = fieldnames(data);

    for i = 1:numel(sources)
        src = sources{i};
        substrates = fieldnames(data.(src));

        for j = 1:numel(substrates)
            sub = substrates{j};
            types = fieldnames(data.(src).(sub)); % Pd, Dn, etc.

            for k = 1:numel(types)
                type = types{k};
                Ptemps = fieldnames(data.(src).(sub).(type));

                for m = 1:numel(Ptemps)
                    ptemp = Ptemps{m};
                    Ptimes = fieldnames(data.(src).(sub).(type).(ptemp));

                    for n = 1:numel(Ptimes)
                        ptime = Ptimes{n};
                        trials = fieldnames(data.(src).(sub).(type).(ptemp).(ptime));

                        for t = 1:numel(trials)
                            trial = trials{t};
                            record = data.(src).(sub).(type).(ptemp).(ptime).(trial);

                            % Create a single row structure
                            row.Source    = src;
                            row.Substrate = sub;
                            row.Type      = type;
                            row.Ptemp     = str2double(erase(ptemp,"Ptemp"));
                            row.Ptime     = str2double(erase(ptime,"Ptime"));
                            row.Trial     = str2double(erase(trial,"t"));
fields = fieldnames(record);

% --- Safe helper to find field names ---
idx = find(contains(lower(fields), 'cd'), 1, 'first');
if ~isempty(idx)
    CdField = fields{idx};
else
    CdField = '';
end

idx = find(contains(lower(fields), 'rs'), 1, 'first');
if ~isempty(idx)
    RsField = fields{idx};
else
    RsField = '';
end

idx = find(contains(lower(fields), 'iv'), 1, 'first');
if ~isempty(idx)
    IVField = fields{idx};
else
    IVField = '';
end


% Assign only if found
if ~isempty(CdField)
    row.Cd = record.(CdField);
else
    row.Cd = NaN;
end

if ~isempty(RsField)
    row.Rs = record.(RsField);
else
    row.Rs = NaN;
end

if ~isempty(IVField)
    row.IV = record.(IVField);
else
    row.IV = [];
end



                            rows = [rows; row]; %#ok<AGROW>
                        end
                    end
                end
            end
        end
    end
% --- Convert struct array to table ---
T = struct2table(rows);

%  Expand IV arrays into separate columns
if ismember('IV', T.Properties.VariableNames)
    % Safely compute the largest IV vector length
    ivLengths = cellfun(@numel, T.IV);
    if isempty(ivLengths)
        maxIV = 0;
    else
        maxIV = max(ivLengths);
    end

    % Initialize new IV columns
% Initialize new IV columns with (in)/(out) suffixes
for i = 1:maxIV
    if mod(i, 2) == 1
        suffix = '(in)';
    else
        suffix = '(out)';
    end
    colname = sprintf('IV_%d %s', i, suffix);
    T.(colname) = NaN(height(T), 1);  % Pre-fill with NaN
end


    % Fill in data safely
  % Fill in data safely with (in)/(out) suffixes
for r = 1:height(T)
    iv = T.IV{r};
    if isempty(iv)
        continue;  % skip empty rows
    end
    n = numel(iv);
    for i = 1:min(n, maxIV)
        if mod(i, 2) == 1
            suffix = '(in)';
        else
            suffix = '(out)';
        end
        colname = sprintf('IV_%d %s', i, suffix);
        T.(colname)(r) = iv(i);
    end
end

    % Remove the original IV column
    T.IV = [];
end


end



