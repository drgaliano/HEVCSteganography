% 
% Author: D. Rodriguez-Galiano / A. A. Del-Barrio / G. Botella / D. Cuesta
% Date: 2020/04/07
% Function: coordinates
% 
% Purpose: Reads the coordinates from a TXT file and add them into a
% matrix. The structure of the file is a list of (frame width height)
% tuples
% 

function coordinates = readCoordinates( filename )
coordinates = importdata(filename);
end

