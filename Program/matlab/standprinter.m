function []=standprinter()
% Define the matrix
[stand1,stand2,stand3,stand4,stand5,stand6,stand7,stand8,stand9]=stored;
matrix=[stand1,stand2,stand3,stand4,stand5,stand6,stand7,stand8,stand9];
% Get the size of the matrix
[rows, cols] = size(matrix);

% Loop through each element and print it
fprintf('1. ')
counter=1;
for k=1:cols
used=matrix(:,k);
[rows1,cols1]=size(used);
for i = 1:rows1
    for j = 1:cols1
        fprintf('%d ', used(i, j));
    end
    
end

 counter=counter+1;
 fprintf('\n')
 if counter==10
     break
 end

fprintf('%d. ',counter); % New line after each row
   
end