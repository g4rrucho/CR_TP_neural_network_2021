%   readImagesFolder
%   INPUT:
%   filepath - Filepath to images folder
%   scale - Image scale between 0 and 1
%   
%   OUTPUT:
%   images - matrix with all images converted to matrices
%
%   24/06/2021
%   Guilherme Garrucho, a21230252@isec.pt
%   Leonel Silva, a21230602@isec.pt

function images = readImagesFolder(filepath, scale)
    % Check if folder exists
    if (~isdir(filepath))
        errorMessage = sprintf('Error\nThe following folder does not exist:\n%s', filepath);
        uiwait(warndlg(errorMessage));
        return;
    end

    %% Find out how many images to read
    files = natsortfiles(dir(filepath));
    files = files(~ismember({files.name}, {'.','..'}));
    size = length(files);
    images = cell(1, size);
    
    %% Read all images to matrix
    for k = 1 : size
        image = imread(fullfile(filepath, files(k).name));
        image = imbinarize(image);
        
        %% Scale image if scale is 
        if(scale ~= 1)
            image = imresize(image, scale);
        end
        
        %% Convert matrix to single column vector
        image = reshape(image, [], 1);
        
        % Save image to images array
        images = repmat(image, 1, k);
    end
end