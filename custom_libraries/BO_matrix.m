% 
% Author: D. Rodriguez-Galiano / A. A. Del-Barrio / G. Botella / D. Cuesta
% Date: 2020/04/07
% Function: BO_matrix
% 
% Purpose: Generate a matrix with tuples using BO algorithm, whose 
% structure is (frame, width, height) for aech bit of the stego-message.
% The matrix size goes from 1 to num_blocks.
% Each tuple defines de first pixel of an Insertion Block.
% 

function BO_matrix = BO_matrix(maxIterations, acceptablePercentage, filename, pixel_depth, bit_to_change, char_size, block_size, frames, binMessage, messageLength, columns, rows, y_plane  )

% Difference between Matlab and YUV video players. Matlab starts matrix at
% 1 and video players at 0.
OFFSET_ = 1; 

% The number of IBs is defined by the length of the message and the char 
% size. A bit is represented in one block.
num_blocks = messageLength*char_size; 
    
% Matrix initialization.
BoT_matrix = zeros(num_blocks, 3);

tupleCounter = 1;
tupleAVG = 0;
tuplesExcess_exit = 0;

for i=1 : messageLength
    for j=1 : char_size

        randomTuple=1;

        bit_in_study = binMessage(i, j);

        % Percentage initialization
        percentage=0;

        % While bit under study >= acceptablePercentage and iteration 
        % (randomTuple) is lower than maxIterations do
        while (randomTuple<=maxIterations && percentage <= acceptablePercentage)

            % Random frames generation.
            randomFrameAux = randperm(frames,1);

            % Random widths generator. 
            % Each coordinate defined by (width, height) must be a multiple
            % of BLOCK_SIZE_
            randomColAux = randperm(columns-block_size,1);
            while (mod(randomColAux,block_size) ~= 0)
                randomColAux = randperm(columns-block_size,1);
            end
            randomColAux=randomColAux+OFFSET_;

            % Random heights generator. 
            % Each coordinate defined by (width, height) must be a multiple
            % of BLOCK_SIZE_
            randomRowAux = randperm(rows-block_size,1);
            while (mod(randomRowAux,block_size) ~= 0)
                randomRowAux = randperm(rows-block_size,1);
            end
            randomRowAux=randomRowAux+OFFSET_;

            % Accesses to each proposed IB and counts the number of 1s and
            % 0s of each 2nd MSB of each pixel.
            num_bits_0_random_coordinatesAux=0;
            num_bits_1_random_coordinatesAux=0;

            for row_ib=0 : block_size-1
                for col_ib=0 : block_size-1
                    Y_DecValue = y_plane{randomFrameAux}(randomRowAux+row_ib,randomColAux+col_ib);   % Decimal value of the Y component ('height','height') of the frame number 'frame'
                    Y_BinValue = de2bi(Y_DecValue, pixel_depth, 'left-msb');                         % Binary value of the Y component ('height','height') of the frame number 'frame'

                    if (Y_BinValue(bit_to_change) == 0)
                        num_bits_0_random_coordinatesAux = num_bits_0_random_coordinatesAux+1;
                    elseif (Y_BinValue(bit_to_change) == 1)
                        num_bits_1_random_coordinatesAux = num_bits_1_random_coordinatesAux+1;    
                    end

                end
            end

            % Checks percentage for each proposed IB.
            if (bit_in_study == 0)
                percentageAux = num_bits_0_random_coordinatesAux/(block_size*block_size);
            elseif (bit_in_study == 1)
                percentageAux = num_bits_1_random_coordinatesAux/(block_size*block_size);
            end

            % Takes the best option.
            if (percentageAux > percentage)
                percentage = percentageAux;
                randomFrame = randomFrameAux;
                randomCol = randomColAux;
                randomRow = randomRowAux;
            end

            % Increases iteration.
            randomTuple = randomTuple+1;

        end %End while

        % Calculates the number of random coordinates that 
        % were generated to hide the information
        tupleAVG = tupleAVG + (randomTuple-1);

        % Creates the ultimate matrix.
        BO_matrix(tupleCounter, 1) = randomFrame;
        BO_matrix(tupleCounter, 2) = randomCol;
        BO_matrix(tupleCounter, 3) = randomRow;

        tupleCounter = tupleCounter + 1;

        if (randomTuple > maxIterations)
            tuplesExcess_exit = tuplesExcess_exit+1;
        end

    end % end_j=0
end % end_i=0

% Writes tuples into the TXT file
fid=fopen(filename,'w');
for i=1:num_blocks
    fprintf(fid,'%d\t%d\t%d\n',BO_matrix(i,1),BO_matrix(i,2),BO_matrix(i,3));
end
fclose(fid);

% Prints the AVG tuples generated.
fprintf (1, 'AVG tuples %.2f\n', tupleAVG/num_blocks);

% Prints the number of times that was reached the maximum number of 
% iterations (excess of tuples).
fprintf (1, 'Exit by tuples excedeed %d\n', tuplesExcess_exit);
    
end % end_BO_matrix

