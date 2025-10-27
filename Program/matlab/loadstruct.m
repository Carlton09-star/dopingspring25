function data = loadstruct()
% loadAndRenameStruct - Loads a .mat file and renames the top-level field to 'data'
%
% Returns:
%   data - Struct renamed to 'data', or empty if canceled or invalid

    [fileName, filePath] = uigetfile('*.mat', 'Select a MAT-file');
    if isequal(fileName, 0)
        disp('File selection canceled.');
        data = [];
        return;
    end

    fullFileName = fullfile(filePath, fileName);
    loadedData = load(fullFileName);

    % Get top-level field names
    varNames = fieldnames(loadedData);

    if isempty(varNames)
        disp('No variables found in the file.');
        data = [];
        return;
    end

    % Assume first field is the main struct
    firstVar = varNames{1};
    data = loadedData.(firstVar);

    % Optional: warn if multiple variables exist
    if numel(varNames) > 1
        disp('⚠️ Multiple variables found. Using the first one:');
        disp(firstVar);
    end

    disp('\x2713 Data structure loaded and renamed to "data".');
end
