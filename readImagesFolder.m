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
    % Find out how many images to read
    files = dir(filepath);
    files = files(~ismember({files.name}, {'.','..'}));
    size = length(files);
    images = cell(size, 1);
    
    % Read all images to matrix
    for k = 1 : size
        images{k} = imread(fullfile(filepath, files(k).name));
        
        if(scale ~= 1)
            images{k} = imresize(images{k}, scale);
        end
    end
end