function data = editWaferData(data, sourcet, substrate, processType, temp, time, waferID, fieldToEdit, newValue)
    % Validate input

    %data the structure name
    % source t -> the type of source
    % substrate
    % processType -> Dn or Pd
    % temp
    %time
    %wafer ID
    %fieldToEdit Cdg_data IV_Data Cs_data Rs_data 
    if ~isstruct(data)
        error('Input data must be a struct.');
    end

    % Build field names
    tempField = sprintf('%stemp%d', processType(1), temp);  % 'PtempXXX' or 'DtempXXX'
    timeField = sprintf('%stime%d', processType(1), time);  % 'PtimeXXX' or 'DtimeXXX'
    waferField = sprintf('w%d', waferID);

    % Navigate to the wafer
    try
        waferStruct = data.(sourcet).(substrate).(processType).(tempField).(timeField).(waferField);
    catch
        error('Specified wafer path does not exist.');
    end

    % Check if field exists
    if ~isfield(waferStruct, fieldToEdit)
        error('Field "%s" does not exist in wafer data.', fieldToEdit);
    end

    % Update the field
    data.(sourcet).(substrate).(processType).(tempField).(timeField).(waferField).(fieldToEdit) = newValue;
end
