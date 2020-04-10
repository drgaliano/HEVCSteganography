% 
% Author: D. Rodriguez-Galiano / A. A. Del-Barrio / G. Botella / D. Cuesta
% Date: 2020/04/07
% Function: textToBin
% 
% Purpose: Takes a TXT file with the stego-message and  converts it to a 
% bit string
% 

function [message,messageLength]=textToBin(filename)

CHAR_SIZE_ = 8;

fileMessage = fopen(filename,'r');
asciiStringMessage = fread(fileMessage, [1, inf], 'char');

messageLength = length (asciiStringMessage);

message = zeros(messageLength, CHAR_SIZE_);

for i=1 : messageLength
        ascii_binary_string = de2bi(asciiStringMessage(i), CHAR_SIZE_, 'left-msb');
        for j=1 : CHAR_SIZE_
            message(i,j) = ascii_binary_string(j);
        end
end


fclose(fileMessage);

end
