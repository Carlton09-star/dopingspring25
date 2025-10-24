function results = getDopingData(data, varargin)
% getDopingData  Extracts entries from the doping structure by filter criteria.
%
% Usage:
%   results = getDopingData(data, 'Source', 'TP470', 'Substrate', 'Silicon')
%   results = getDopingData(data, 'Type', 'Pd', 'Ptemp', 900)
%   results = getDopingData(data, 'Type', 'Dn', 'PreTemp', 900, 'PreTime', 90)
%
% Filters:
%   'Source', 'Substrate', 'Type' ('Pd' or 'Dn'), 'Ptemp', 'Ptime',
%   'Dtemp', 'Dtime', 'PreTemp', 'PreTime', 'Trial'
%
% Output:
%   Struct array of results with fields:
%     Source, Substrate, Type, PreTemp, PreTime, TempField, TimeField, Trial, Cd, Rs, IV

% ------------------------------
% Parse inputs
p = inputParser;
addParameter(p, 'Source', []);
addParameter(p, 'Substrate', []);
addParameter(p, 'Type', []);
addParameter(p, 'Ptemp', []);
addParameter(p, 'Ptime', []);
addParameter(p, 'Dtemp', []);
addParameter(p, 'Dtime', []);
addParameter(p, 'PreTemp', []);
addParameter(p, 'PreTime', []);
addParameter(p, 'Trial', []);
addParameter(p,'Field',[]);   % Can be 'Cd', 'Rs', or 'IV'


parse(p, varargin{:});
fieldToReturn = p.Results.Field;

f = p.Results;
% ------------------------------

results = struct('Source', {}, 'Substrate', {}, 'Type', {}, ...
    'PreTemp', {}, 'PreTime', {}, ...
    'TempField', {}, 'TimeField', {}, 'Trial', {}, ...
    'Cd', {}, 'Rs', {}, 'IV', {});

sources = fieldnames(data);
for iS = 1:numel(sources)
    source = sources{iS};
    if ~isempty(f.Source) && ~strcmp(source, f.Source), continue; end

    subs = fieldnames(data.(source));
    for iSub = 1:numel(subs)
        substrate = subs{iSub};
        if ~isempty(f.Substrate) && ~strcmp(substrate, f.Substrate), continue; end

        % Handle Pd and Dn
        types = {'Pd','Dn'};
        for iT = 1:numel(types)
            type = types{iT};
            if ~isfield(data.(source).(substrate), type), continue; end
            if ~isempty(f.Type) && ~strcmpi(type, f.Type), continue; end

            tempFields = fieldnames(data.(source).(substrate).(type));
            for iTemp = 1:numel(tempFields)
                tempField = tempFields{iTemp};
                % numeric value extraction
                tempNum = sscanf(tempField, '%*[^0-9]%d');

                if strcmpi(type, 'Pd')
                    if ~isempty(f.Ptemp) && tempNum ~= f.Ptemp, continue; end
                    PreTemp = tempNum; % Pd has no prior pre-temp
                    PreTime = [];
                else
                    if ~isempty(f.Dtemp) && tempNum ~= f.Dtemp, continue; end
                    PreTemp = f.PreTemp; % use supplied preconditions if any
                    PreTime = f.PreTime;
                end

                timeFields = fieldnames(data.(source).(substrate).(type).(tempField));
                for iTime = 1:numel(timeFields)
                    timeField = timeFields{iTime};
                    timeNum = sscanf(timeField, '%*[^0-9]%d');

                    if strcmpi(type, 'Pd')
                        if ~isempty(f.Ptime) && timeNum ~= f.Ptime, continue; end
                    else
                        if ~isempty(f.Dtime) && timeNum ~= f.Dtime, continue; end
                    end

                    trials = fieldnames(data.(source).(substrate).(type).(tempField).(timeField));
                    for iTrial = 1:numel(trials)
                        trialField = trials{iTrial};
                        trialNum = sscanf(trialField, 't%d');
                        if ~isempty(f.Trial)
    % Convert string trial names like "t1" to numeric
                         if ischar(f.Trial) || isstring(f.Trial)
        tNum = sscanf(char(f.Trial), 't%d');
                          else
        tNum = f.Trial;
                          end
                         if tNum ~= trialNum
                             continue;
                          end
                        end


                        entry = data.(source).(substrate).(type).(tempField).(timeField).(trialField);

                       % --- Safely extract data fields ---
Cd = []; Rs = []; IV = [];
if isfield(entry, 'Cd'), Cd = entry.Cd; end
if isfield(entry, 'Rs'), Rs = entry.Rs; end
if isfield(entry, 'IV'), IV = entry.IV; end

results(end+1) = struct( ...
    'Source', source, ...
    'Substrate', substrate, ...
    'Type', type, ...
    'PreTemp', f.PreTemp, ...
    'PreTime', f.PreTime, ...
    'TempField', tempField, ...
    'TimeField', timeField, ...
    'Trial', trialField, ...
    'Cd', Cd, ...
    'Rs', Rs, ...
    'IV', IV);

                    end
                end
            end
        end
    end
end
% --- Optionally filter output by requested field ---
if ~isempty(fieldToReturn)
    validFields = {'Cd','Rs','IV'};
    if ~ismember(fieldToReturn, validFields)
        error('Invalid Field name. Must be ''Cd'', ''Rs'', or ''IV''.');
    end

    % Extract only that field’s values into an array or cell
    vals = arrayfun(@(x) x.(fieldToReturn), results, 'UniformOutput', false);

    % Convert to numeric if possible
    if all(cellfun(@isnumeric, vals))
        vals = cell2mat(vals(:));
    end

    results = vals;  % Replace the structure array with just that field’s values
end

end
