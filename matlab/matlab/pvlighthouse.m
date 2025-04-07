function []=pvlighthouse()

url = 'https://www2.pvlighthouse.com.au/calculators/Sheet%20resistance%20calculator/Sheet%20resistance%20calculator.aspx';
text = 'Visit PV Lighthouse';
fprintf('<a href="%s">%s</a>\n', url, text);
end