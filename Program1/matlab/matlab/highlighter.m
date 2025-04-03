function []=highlighter(range,sheet,path)
% Start an ActiveX session with Excel
excelApp = actxserver('Excel.Application');

% Open an existing workbook or create a new one
workbook = excelApp.Workbooks.Open(path); % Update with your file path

% Access the first worksheet
worksheet = workbook.Sheets.Item(sheet);

% Define the range of cells you want to highlight
range = worksheet.Range(range); % Update with your desired range

% Set the interior color of the specified range
range.Interior.Color = 65535; % Yellow color (RGB: 255, 255, 0)

% Save the workbook
workbook.Save();

% Close the workbook and quit Excel
workbook.Close();
excelApp.Quit();

% Release the COM server
delete(excelApp);