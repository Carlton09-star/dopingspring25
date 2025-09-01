function []=standprinter()
[stand1,stand2,stand3,stand4,stand5,stand6,stand7,stand8,stand9]=stored;
[s1,~]=size(stand1);
[s2,~]=size(stand2);
[s3,~]=size(stand3);
[s4,~]=size(stand4);
[s5,~]=size(stand5);
[s6,~]=size(stand6);
[s7,~]=size(stand7);
[s8,~]=size(stand8);
[s9,~]=size(stand9);

fprintf('1. ') 
for k=1:s1
    fprintf('%d ',stand1(k) )
end
fprintf('\n2. ')
for l=1:s2
    fprintf('%d ',stand2(k))
end
fprintf('\n3. ')
for k=1:s3
    fprintf('%d ',stand3(k))
end
fprintf('\n4. ')
for k=1:s4
    fprintf('%d ',stand4(k))
end
fprintf('\n5. ')
for k=1:s5
    fprintf('%d ',stand5(k))
end
fprintf('\n6. ')
for k=1:s6
    fprintf('%d ',stand6(k))
end
fprintf('\n7. ')
for k=1:s7
    fprintf('%d ',stand7(k))
end
fprintf('\n8. ')
for k=1:s8
    fprintf('%d ',stand8(k))
end
fprintf('\n9. ')
for k=1:s9
    fprintf('%d ', stand9(k))
end
fprintf('\n')