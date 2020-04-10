% 
% Author: D. Rodriguez-Galiano / A. A. Del-Barrio / G. Botella / D. Cuesta
% Date: 2020/04/07
% Function: random_matrix
% 
% Purpose: Generate a matrix with tuples using random algorithm, whose 
% structure is (frame, width, height) for aech bit of the stego-message. 
% The matrix size goes from 1 to num_blocks.
% Each tuple defines de first pixel of an Insertion Block.
% 

function random_matrix = random_matrix( filename, messageLength, frames, columns, rows )

% Char size in bits.
CHAR_SIZE_ = 8;

% Insertion Block (IB) size.
BLOCK_SIZE_= 4;

% Difference between Matlab and YUV video players. Matlab starts matrix at
% 1 and video players at 0.
OFFSET_ = 1; 

% The number of IBs is defined by the length of the message and the char 
% size. A bit is represented in one block.
num_blocks = messageLength*CHAR_SIZE_;

well_formed_random_matrix = false; %flag

while (well_formed_random_matrix == false)

    % Matrix initialization.
    random_matrix = zeros(num_blocks, 3);

    % Random frames generation.
    for i=1 : num_blocks
        random_matrix(i, 1) = randperm(frames,1);
    end

    % Random widths generator. 
    % Each coordinate defined by (width, height) must be a multiple of 
    % BLOCK_SIZE_
    for i=1 : num_blocks
        aleator = randperm(columns-BLOCK_SIZE_,1);
        while (mod(aleator,BLOCK_SIZE_) ~= 0)
            aleator = randperm(columns-BLOCK_SIZE_,1);
        end
        random_matrix(i, 2) = aleator+OFFSET_;
    end

    % Random heights generator. 
    % Each coordinate defined by (width, height) must be a multiple of 
    % BLOCK_SIZE_
    for i=1 : num_blocks
        aleator = randperm(rows-BLOCK_SIZE_,1);
        while (mod(aleator,BLOCK_SIZE_) ~= 0)
            aleator = randperm(rows-BLOCK_SIZE_,1);
        end
        random_matrix(i, 3) = aleator+OFFSET_;
    end

    % Checks that each tuple is unique.
    if (size(random_matrix) == size (unique(random_matrix,'rows')))
        well_formed_random_matrix = true;
    end
    
end % end_while
    
% Writes tuples into the TXT file
fid=fopen(filename,'w');
for i=1:num_blocks
	fprintf(fid,'%d\t%d\t%d\n',random_matrix(i,1),random_matrix(i,2),random_matrix(i,3));
end
fclose(fid);

end % end_random_matrix
