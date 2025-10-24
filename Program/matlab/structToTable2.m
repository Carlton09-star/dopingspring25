function [T, S] = structToTable(data, ...
    sourceFilter, substrateFilter, typeFilter, ...
    PtempFilter, PtimeFilter, DtempFilter, DtimeFilter, ...
    trialFilter, includeCd, includeRs, includeIV)

    % Set defaults if not provided
    if nargin < 2, sourceFilter = []; end
    if nargin < 3, substrateFilter = []; end
    if nargin < 4, typeFilter = []; end
    if nargin < 5, PtempFilter = []; end
    if nargin < 6, PtimeFilter = []; end
    if nargin < 7, DtempFilter = []; end
    if nargin < 8, DtimeFilter = []; end
    if nargin < 9, trialFilter = []; end
    if nargin < 10, includeCd = true; end
    if nargin < 11, includeRs = true; end
    if nargin < 12, includeIV = true; end

    rows = [];
    S = struct();  % Output structure matching input format
    sources = fieldnames(data);

    for i = 1:numel(sources)
        src = sources{i};
        if ~isempty(sourceFilter) && ~ismember(src, sourceFilter), continue; end

        substrates = fieldnames(data.(src));
        for j = 1:numel(substrates)
            sub = substrates{j};
            if ~isempty(substrateFilter) && ~ismember(sub, substrateFilter), continue; end

            types = fieldnames(data.(src).(sub));
            for k = 1:numel(types)
                type = types{k};
                if ~isempty(typeFilter) && ~ismember(type, typeFilter), continue; end

                temps = fieldnames(data.(src).(sub).(type));
                for m = 1:numel(temps)
                    tempField = temps{m};
                    tempVal = str2double(regexprep(tempField, '[PD]temp', ''));
                    if strcmp(type, 'Pd') && ~isempty(PtempFilter) && ~ismember(tempVal, PtempFilter), continue; end
                    if strcmp(type, 'Dn') && ~isempty(DtempFilter) && ~ismember(tempVal, DtempFilter), continue; end

                    times = fieldnames(data.(src).(sub).(type).(tempField));
                    for n = 1:numel(times)
                        timeField = times{n};
                        timeVal = str2double(regexprep(timeField, '[PD]time', ''));
                        if strcmp(type, 'Pd') && ~isempty(PtimeFilter) && ~ismember(timeVal, PtimeFilter), continue; end
                        if strcmp(type, 'Dn') && ~isempty(DtimeFilter) && ~ismember(timeVal, DtimeFilter), continue; end

                        trials = fieldnames(data.(src).(sub).(type).(tempField).(timeField));
                        for t = 1:numel(trials)
                            trialField = trials{t};
                            trialNum = str2double(erase(trialField, 't'));
                            if ~isempty(trialFilter) && ~ismember(trialNum, trialFilter), continue; end

                            record = data.(src).(sub).(type).(tempField).(timeField).(trialField);
                            fields = fieldnames(record);

                            % Build flat row
                            row.Source = src;
                            row.Substrate = sub;
                            row.Type = type;
                            row.Ptemp = tempVal;
                            row.Ptime = timeVal;
                            row.Trial = trialNum;

                            if includeCd
                                row.Cd = extractField(record, fields, 'cd', NaN);
                            end
                            if includeRs
                                row.Rs = extractField(record, fields, 'rs', NaN);
                            end
                            if includeIV
                                row.IV = extractField(record, fields, 'iv', []);
                            end

                            rows = [rows; row]; %#ok<AGROW>

                            % Build nested output structure
                            recordOut = struct();
                            if includeCd
                                recordOut.Cd = extractField(record, fields, 'cd', NaN);
                            end
                            if includeRs
                                recordOut.Rs = extractField(record, fields, 'rs', NaN);
                            end
                            if includeIV
                                recordOut.IV = extractField(record, fields, 'iv', []);
                            end

                            S.(src).(sub).(type).(tempField).(timeField).(trialField) = recordOut;
                        end
                    end
                end
            end
        end
    end

    % Convert to table
    T = struct2table(rows);

    % Expand IV if requested
    if includeIV && ismember('IV', T.Properties.VariableNames)
        ivLengths = cellfun(@numel, T.IV);
        maxIV = max(ivLengths, [], 'omitnan');
        for i = 1:maxIV
            colname = sprintf('IV_%d', i);
            T.(colname) = NaN(height(T), 1);
        end
        for r = 1:height(T)
            iv = T.IV{r};
            for i = 1:min(numel(iv), maxIV)
                T.(sprintf('IV_%d', i))(r) = iv(i);
            end
        end
        T.IV = [];
    end
end

function value = extractField(record, fields, keyword, default)
    idx = find(contains(lower(fields), keyword), 1, 'first');
    if ~isempty(idx)
        value = record.(fields{idx});
    else
        value = default;
    end
end
