function colLetter = numtol(num)
    colLetter = '';
    while num > 0
        remainder = mod(num - 1, 26);
        colLetter = [char(remainder + 'A'), colLetter];
        num = floor((num - remainder - 1) / 26);
    end
end

