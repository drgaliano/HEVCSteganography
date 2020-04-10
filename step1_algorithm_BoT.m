% 
% Author: D. Rodriguez-Galiano / A. A. Del-Barrio / G. Botella / D. Cuesta
% Date: 2020/04/07
% Function: step1_algorithm_BoT
% 
% Purpose: Adds a stego-message inside a YUV video format (luminance 
% matrix) in 4x4 Insertion Blocks (IBs), applying BoT algorithm.
% 
% IMPORTANT DEPENDENCIES: This code uses the YUV processing tool developed 
% by Karol Gaida:
% Karol Gaida (2020). YUV processing tool for Matlab R2015 
% (https://es.mathworks.com/matlabcentral/fileexchange/36417-yuv-files-reading-and-converting),
% MATLAB Central File Exchange.
% Retrieved April 9, 2020.
% 

clear all
clc

% Initializes random seed.
rng('shuffle')

%%% VARIABLE DECLARATIONS                        %%%
%%% Modify values according to user requirements %%%

% YUV source filename.
FILE_NAME = 'source_YUV.yuv';

% YUV path.
YUV_PATH = ['/path/to/YUVfile/' FILE_NAME];

% TXT file where stego-message to embed is found.
MSG_PATH = '/path/to/file/stegomessage.txt';

% Path and filename where coordinates will be located.
COORDINATES_PATH = ['/path/to/video-modified/coord_BoT_' FILE_NAME(1:end-4) '.txt'];

% Path and filename where modified YUV video format will be located.
YUV_PATH_WITH_HIDDEN_MSG = ['/path/to/video-modified/toEncode_BoT_' FILE_NAME];

% Pixel depth.
PIXEL_DEPTH = 8;

% Char size in bits.
CHAR_SIZE = 8; 

% Number of frames in video.
FRAMES = 650;

% Number of the initial frame. Consider the 0 number as first frame of the
% video.
START_FRAME = 0;

% Width resolution (in number of pixels). E.g.: 1920 (in a 1920x1080 video
% resolution).
YUV_WIDTH  = 1920;

% Height resolution (in number of pixels). E.g.: 1080 (in a 1920x1080 video
% resolution).
YUV_HEIGHT = 1080;

% Source YUV video format. See "YUV_Libraries/yuv_import.m" for options.
YUV_FORMAT = 'YUV420_8';

% Bit position to modify. The MSB is the one on the right and the LSB the 
% one on the left.
% In 8-bit char size, the numeration is as follows:
% 1 2 3 4 5 6 7 8 (being the 1st the MSB and the 8th position the LSB).
BIT_TO_CHANGE = 2;

% Insertion Block (IB) size.
BLOCK_SIZE = 4;

%%% END VARIABLE DECLARATIONS %%%

%%% EXECUTION %%%

% Imports stego-message.
[binMessage, messageLength]=textToBin(MSG_PATH);

% Generates BoT coordinates.
coordinates=BoT_matrix(COORDINATES_PATH, PIXEL_DEPTH, BIT_TO_CHANGE, CHAR_SIZE, BLOCK_SIZE, FRAMES, binMessage, messageLength, YUV_WIDTH, YUV_HEIGHT, Y);

% Imports YUV video source. (Declared dependency)
[Y,U,V]=yuv_import(YUV_PATH,[YUV_WIDTH YUV_HEIGHT],FRAMES,START_FRAME,YUV_FORMAT);


letter = 1;
bit = 1;

for i=1 : messageLength*CHAR_SIZE
    
	frame = coordinates(i,1);
    width = coordinates(i,2);
    height = coordinates(i,3);
    
    % Modifies the affected bit in all the pixels that form the IB.
    for j=0 : BLOCK_SIZE-1
        for k=0 : BLOCK_SIZE-1
            
            if (j==0 && k==0)
                fprintf(1, 'Letra %d bit %d en frame %d y bloque %d x %d\n', letter, bit, frame, width, height);
            end
            
            Y_DecValue = Y{frame}(height+j,width+k);                  % Decimal value of the Y component ('height','height') of the frame number 'frame'
            Y_BinValue = de2bi(Y_DecValue, PIXEL_DEPTH, 'left-msb');  % Binary value of the Y component ('height','height') of the frame numer 'frame'

            Y_BinValue(BIT_TO_CHANGE) = binMessage(letter, bit);      % Modifies the affected bit.
            Y{frame}(height+j,width+k) = bi2de(Y_BinValue,'left-msb');
        end
    end

    if (bit < CHAR_SIZE)
        bit = bit+1;
    elseif (bit==CHAR_SIZE && letter<messageLength)
        bit=1;
        letter = letter+1;
    end    
end

% Exports the YUV video format with stego-message. (Declared dependency)
yuv_export(Y,U,V,YUV_PATH_WITH_HIDDEN_MSG,FRAMES,'w');

fprintf (1, 'Execution finished!\n');

%%% END EXECUTION %%%
