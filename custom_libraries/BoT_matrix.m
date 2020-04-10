% 
% Author: D. Rodriguez-Galiano / A. A. Del-Barrio / G. Botella / D. Cuesta
% Date: 2020/04/07
% Function: BoT_matrix
% 
% Purpose: Generate a matrix with tuples using BoT algorithm, whose 
% structure is (frame, width, height) for aech bit of the stego-message.
% The matrix size goes from 1 to num_blocks.
% Each tuple defines de first pixel of an Insertion Block.
%

function BoT_matrix = BoT_matrix( filename, pixel_depth, bit_to_change, char_size, block_size, frames, binMessage, messageLength, columns, rows, y_plane  )

% Difference between Matlab and YUV video players. Matlab starts matrix at
% 1 and video players at 0.
OFFSET_ = 1; 

% The number of IBs is defined by the length of the message and the char 
% size. A bit is represented in one block.
num_blocks = messageLength*char_size; 
    
% Matrix initialization.
BoT_matrix = zeros(num_blocks, 3);

tupleCounter = 1;
for i=1 : messageLength
    for j=1 : char_size
            
        bit_in_study = binMessage(i, j);

        % For each bit of the stego-message is generated three IBs.
        % The IB structure is (frame, width, height).

        % Random frames generation.
        randomFrame = randperm(frames,1);

        % Random widths generator. 
        % Each coordinate defined by (width, height) must be a multiple of 
        % BLOCK_SIZE_
        randomCol1 = randperm(columns-block_size,1);
        while (mod(randomCol1,block_size) ~= 0)
            randomCol1 = randperm(columns-block_size,1);
        end
        randomCol1=randomCol1+OFFSET_;

        randomCol2 = randperm(columns-block_size,1);
        while (mod(randomCol2,block_size) ~= 0)
            randomCol2 = randperm(columns-block_size,1);
        end
        randomCol2=randomCol2+OFFSET_;

        randomCol3 = randperm(columns-block_size,1);
        while (mod(randomCol3,block_size) ~= 0)
            randomCol3 = randperm(columns-block_size,1);
        end
        randomCol3=randomCol3+OFFSET_;

        % Random heights generator. 
        % Each coordinate defined by (width, height) must be a multiple of 
        % BLOCK_SIZE_
        randomRow1 = randperm(rows-block_size,1);
        while (mod(randomRow1,block_size) ~= 0)
            randomRow1 = randperm(rows-block_size,1);
        end
        randomRow1=randomRow1+OFFSET_;

        randomRow2 = randperm(rows-block_size,1);
        while (mod(randomRow2,block_size) ~= 0)
            randomRow2 = randperm(rows-block_size,1);
        end
        randomRow2=randomRow2+OFFSET_;

        randomRow3 = randperm(rows-block_size,1);
        while (mod(randomRow3,block_size) ~= 0)
            randomRow3 = randperm(rows-block_size,1);
        end
        randomRow3=randomRow3+OFFSET_;

        % Analizes the three IBs to detect the better one

        % Accesses to the 1st IB (frame, randomCol1, randomRow1) and 
        % counts the number of bits 1s and 0s found in the 2nd MSB position 
        % of each pixel IB.
        num_bits_0_random_coordinates1=0;
        num_bits_1_random_coordinates1=0;

        for row_ib=0 : block_size-1
            for col_ib=0 : block_size-1
                Y_DecValue = y_plane{randomFrame}(randomRow1+row_ib,randomCol1+col_ib);   % Decimal value of the Y component ('height','height') of the frame number 'frame'
                Y_BinValue = de2bi(Y_DecValue, pixel_depth, 'left-msb');                  % Binary value of the Y component ('height','height') of the frame number 'frame'

                if (Y_BinValue(bit_to_change) == 0)
                    num_bits_0_random_coordinates1 = num_bits_0_random_coordinates1+1;
                elseif (Y_BinValue(bit_to_change) == 1)
                    num_bits_1_random_coordinates1 = num_bits_1_random_coordinates1+1;    
                end

            end
        end

        % Accesses to the 2nd IB (frame, randomCol2, randomRow2) and 
        % counts the number of bits 1s and 0s found in the 2nd MSB position 
        % of each pixel IB.
        num_bits_0_random_coordinates2=0;
        num_bits_1_random_coordinates2=0;

        for row_ib=0 : block_size-1
            for col_ib=0 : block_size-1
                Y_DecValue = y_plane{randomFrame}(randomRow2+row_ib,randomCol2+col_ib);   % Decimal value of the Y component ('height','height') of the frame number 'frame'
                Y_BinValue = de2bi(Y_DecValue, pixel_depth, 'left-msb');                  % Binary value of the Y component ('height','height') of the frame number 'frame'

                if (Y_BinValue(bit_to_change) == 0)
                    num_bits_0_random_coordinates2 = num_bits_0_random_coordinates2+1;
                elseif (Y_BinValue(bit_to_change) == 1)
                    num_bits_1_random_coordinates2 = num_bits_1_random_coordinates2+1;    
                end

            end
        end

        % Accesses to the 3rd IB (frame, randomCol3, randomRow3) and 
        % counts the number of bits 1s and 0s found in the 2nd MSB position 
        % of each pixel IB.
        num_bits_0_random_coordinates3=0;
        num_bits_1_random_coordinates3=0;

        for row_ib=0 : block_size-1
            for col_ib=0 : block_size-1
                Y_DecValue = y_plane{randomFrame}(randomRow3+row_ib,randomCol3+col_ib);   % Decimal value of the Y component ('height','height') of the frame number 'frame'
                Y_BinValue = de2bi(Y_DecValue, pixel_depth, 'left-msb');                  % Binary value of the Y component ('height','height') of the frame number 'frame'

                if (Y_BinValue(bit_to_change) == 0)
                    num_bits_0_random_coordinates3 = num_bits_0_random_coordinates3+1;
                elseif (Y_BinValue(bit_to_change) == 1)
                    num_bits_1_random_coordinates3 = num_bits_1_random_coordinates3+1;    
                end

            end
        end          

        % Takes the better IB.
        randomCol=-1;
        randomRow=-1;
        
        % If the bit under study has value 0, it is needed to take that IB 
        % that has more 2nd MSB with value 0.
        if (bit_in_study == 0) 

            if num_bits_0_random_coordinates1 >= num_bits_0_random_coordinates2 && num_bits_0_random_coordinates1 >= num_bits_0_random_coordinates3 
                randomCol = randomCol1;
                randomRow = randomRow1;
            end
            if num_bits_0_random_coordinates2 >= num_bits_0_random_coordinates1 && num_bits_0_random_coordinates2 >= num_bits_0_random_coordinates3 
                randomCol = randomCol2;
                randomRow = randomRow2;
            end
            if num_bits_0_random_coordinates3 >= num_bits_0_random_coordinates1 && num_bits_0_random_coordinates3 >= num_bits_0_random_coordinates2 
                randomCol = randomCol3;
                randomRow = randomRow3;
            end

        % If the bit under study has value 1, it is needed to take that IB
        % that has more 2nd MSB with value 1.
        elseif (bit_in_study == 1)

            if num_bits_1_random_coordinates1 >= num_bits_1_random_coordinates2 && num_bits_1_random_coordinates1 >= num_bits_1_random_coordinates3 
                randomCol = randomCol1;
                randomRow = randomRow1;
            end
            if num_bits_1_random_coordinates2 >= num_bits_1_random_coordinates1 && num_bits_1_random_coordinates2 >= num_bits_1_random_coordinates3 
                randomCol = randomCol2;
                randomRow = randomRow2;
            end
            if num_bits_1_random_coordinates3 >= num_bits_1_random_coordinates1 && num_bits_1_random_coordinates3 >= num_bits_1_random_coordinates2 
                randomCol = randomCol3;
                randomRow = randomRow3;
            end        

        end

        % Creates the ultimate matrix.
        BoT_matrix(tupleCounter, 1) = randomFrame;
        BoT_matrix(tupleCounter, 2) = randomCol;
        BoT_matrix(tupleCounter, 3) = randomRow;

        tupleCounter = tupleCounter + 1;

    end % end_j=0
end % end_i=0

% Writes tuples into the TXT file
fid=fopen(filename,'w');
for i=1:num_blocks
    fprintf(fid,'%d\t%d\t%d\n',BoT_matrix(i,1),BoT_matrix(i,2),BoT_matrix(i,3));
end
fclose(fid);
end % end_BoT_matrix

