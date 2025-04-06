function [filen]=compactor(filen,collums)

%filen=filen(:,collums:collums+27);
nanRows = find(all(isnan(filen), 2));
filen(nanRows, :) = [];

end


