% 
% Author: D. Rodriguez-Galiano / A. A. Del-Barrio / G. Botella / D. Cuesta
% Date: 2020/04/07
% Function: textToDec
% 
% Purpose: Takes a TXT file with the stego-message and converts it to an 
% ascii string
% 

function [asciiStringMessage,messageLength]=textToDec(filename)

fileMessage = fopen(filename,'r');
asciiStringMessage = fread(fileMessage, [1, inf], 'char');
fclose(fileMessage);

messageLength = length (asciiStringMessage);

fclose(fileMessage);

end
