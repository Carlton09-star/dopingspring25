function T = structToTable2(data)
% Convert nested wafer structure into a clean table
% Supports Pd-only and Pd+Dn wafers

rows = [];
sources = fieldnames(data);

trialCounter = 1;

for i = 1:numel(sources)
    src = sources{i};
    substrates = fieldnames(data.(src));
    for j = 1:numel(substrates)
        sub = substrates{j};
        processTypes = fieldnames(data.(src).(sub));
        for k = 1:numel(processTypes)
            proc = processTypes{k};
            temps = fieldnames(data.(src).(sub).(proc));
            for m = 1:numel(temps)
                tempField = temps{m};
                PtempVal = str2double(regexprep(tempField,'Ptemp',''));
                times = fieldnames(data.(src).(sub).(proc).(tempField));
                for n = 1:numel(times)
                    timeField = times{n};
                    PtimeVal = str2double(regexprep(timeField,'Ptime',''));
                    wafers = fieldnames(data.(src).(sub).(proc).(tempField).(timeField));
                    for t = 1:numel(wafers)
                        waferField = wafers{t};
                        wafer = data.(src).(sub).(proc).(tempField).(timeField).(waferField);

                        % Build row
                        row.Source = src;
                        row.Substrate = sub;
                        if strcmp(proc,'Pd')
                            row.ProcessType = 'Predeposition';
                            row.Dtemp = NaN;
                            row.Dtime = NaN;
                        elseif strcmp(proc,'PdDn')
                            row.ProcessType = 'Predeposition+Drive-in';
                            row.Dtemp = wafer.Dtemp;
                            row.Dtime = wafer.Dtime;
                        end
                        row.Ptemp = PtempVal;
                        row.Ptime = PtimeVal;
                        row.Trial = trialCounter;

                        % Numeric wafer data
                        row.Rs = getFieldOrNaN(wafer,'Rs');
                        row.Cs = getFieldOrNaN(wafer,'Cs');
                        row.Cbg = getFieldOrNaN(wafer,'Cbg');
                        row.Rsheet = getFieldOrNaN(wafer,'Rsheet');

                        % IV expansion
                        if isfield(wafer,'IV') && ~isempty(wafer.IV)
                            IV = wafer.IV;
                            if isempty(IV)
                                IV = NaN(1,0);
                            end
                            for ivIdx = 1:numel(IV)
                                if mod(ivIdx,2)==1
                                    suffix = '_in';
                                else
                                    suffix = '_out';
                                end
                                colName = sprintf('IV_%d%s',ivIdx,suffix);
                                row.(colName) = IV(ivIdx);
                            end
                        end

                        rows = [rows; row]; %#ok<AGROW>
                        trialCounter = trialCounter + 1;
                    end
                end
            end
        end
    end
end

% Convert to table
T = struct2table(rows);

% Fill missing IV columns with NaN if some rows had shorter IV
allIVCols = startsWith(T.Properties.VariableNames,'IV_');
for c = find(allIVCols)
    colData = T.(T.Properties.VariableNames{c});
    if isempty(colData)
        T.(T.Properties.VariableNames{c}) = NaN(height(T),1);
    end
end
end

function val = getFieldOrNaN(structure, fieldName)
% Return field value or NaN if missing
if isfield(structure, fieldName)
    val = structure.(fieldName);
    if isempty(val)
        val = NaN;
    end
else
    val = NaN;
end
end
