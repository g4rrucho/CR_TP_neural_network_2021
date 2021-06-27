%% Clear all vars
clear
clc

%% Get best neural network
filename = 'melhorRede.mat';
load(filename);

%% Get images
images = [];
imagesTarget = [];
images = readImagesFolder('./Pasta4/', 0.01);
[m n] = size(images);
for i = 0:9
    for j = 1:4
        arr = zeros(1, 10);
        arr(i + 1) = 1;
        arr = reshape(arr, 1, []);
        imagesTarget(:, j + i * 4) = arr;
    end
end

%% Simular | Let's test it
out = sim(net, images);

%% Show performance
plotconfusion(imagesTarget, out);

%% Calcular e mostrar a percentagem de classificações
r = 0;
for i = 1:size(out, 2)
    [a b] = max(out(:, i));
    [c d] = max(imagesTarget(:, i));
    
    if b == d
        r = r + 1;
    end
end

accuracy = r/size(out, 2) * 100;
fprintf("Precisao total %f\n", accuracy);