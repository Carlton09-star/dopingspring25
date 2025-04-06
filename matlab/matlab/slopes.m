function [slope]=slopes(x,y)

% Calculate the slope using polyfit function
p = polyfit(x, y, 1); % 1 indicates linear fit

% Extract the slope from the coefficients
slope = p(1);
end
