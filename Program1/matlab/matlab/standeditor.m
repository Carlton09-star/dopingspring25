function [] = standeditor(edstand,v)
% Read the file into a cell array of strings
    fid = fopen('stored.m', 'r');
    if fid == -1
        error('File not found or permission denied');
    end
    fileContent = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
    fileContent=fileContent{1};
    fclose(fid);
    %fileContent = fileContent;
    startLine=edstand+1;
    endLine=startLine;
    
    % Check if the specified lines are within the file length
    if startLine < 1 || endLine > length(fileContent) || startLine > endLine
        error('Invalid line range specified');
    end
    v=arraytocell(v,edstand);

    
    % Replace the specified lines with new content
    fileContent(startLine:endLine) = v;

    % Write the modified content back to the file
    fid = fopen('stored.m', 'w');
    if fid == -1
        error('File not found or permission denied');
    end
    fprintf(fid, '%s\n', fileContent{:});
    fclose(fid);
end


