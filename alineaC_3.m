%% Clear all vars
clear
clc

%% Set variables
filename = 'alineaC_3.mat';

%% Treinar rede neuronal caso não exista
if(~isfile(filename))
    %% Get images
    images1 = readImagesFolder('./Pasta1/', 0.01);
    images2 = readImagesFolder('./Pasta2/', 0.01);
    images3 = readImagesFolder('./Pasta3/', 0.01);

    images = [];
    % Truncate all images
    for i = 1 : 10
        images(:, i) = images1(:, i);
    end

    for i = 11 : 110
        images(:, i) = images2(:, i - 10);
    end

    for i = 111 : 150
        images(:, i) = images3(:, i - 110);
    end

    imagesTarget = [];

    % Truncate images targets
    target  = eye(10);
    for i = 1 : 10 % pasta 1
        imagesTarget(:, i) = target(:, i);
    end

    for i = 0:9 % pasta 2
        for j = 1:10
            arr = zeros(1, 10);
            arr(10 - i) = 1;
            arr = reshape(arr, 1, []);
            target(:, j + i * 10) = arr;
        end
    end

    for i = 11 : 110 % pasta 3
        imagesTarget(:,i) = target(:, i - 10);
    end

    for i = 0:9
        for j = 1:4
            arr = zeros(1, 10);
            arr(i + 1) = 1;
            arr = reshape(arr, 1, []);
            target(:, j + i * 4) = arr;
        end
    end

    for i = 111 : 150
        imagesTarget(:,i) = target(:, i - 110);
    end
    
    %% Treinar rede neuronal
    net = feedforwardnet([20,20]);
    net = train(net, images, imagesTarget);
    
    net.layers{1}.transferFcn = 'tansig';
    net.layers{2}.transferFcn = 'tansig';
    net.layers{3}.transferFcn = 'purelin';
    
    net.divideFcn = 'dividerand';
    net.divideParam.trainRatio = 1;
    net.divideParam.valRatio = 0;
    net.divideParam.testRatio = 0;
    save(filename);
else
    load(filename);
    
    net.divideFcn = 'dividerand';
    net.divideParam.trainRatio = 1;
    net.divideParam.valRatio = 0;
    net.divideParam.testRatio = 0;
end

%% TODO Mudar a pasta a testar: 1, 2, 3 -> pasta1, pasta2, pasta3
folder = 3;

switch folder
    case 1
        images = readImagesFolder("./Pasta1/", 0.01);
        [m n] = size(images);
        imagesTarget = eye(n);
        
    case 2
        %% Folder Pasta2
        images = readImagesFolder('./Pasta2/', 0.01);
        imagesTarget = [];
        [m n] = size(images);

        for i = 0:9
            for j = 1:10
                arr = zeros(1, 10);
                arr(10 - i) = 1;
                arr = reshape(arr, 1, []);
                imagesTarget(:, j + i * 10) = arr;
            end
        end
        
    case 3
        %% Folder Pasta3
        images = readImagesFolder('./Pasta3/', 0.01);
        imagesTarget = [];

        for i = 0:9
            for j = 1:4
                arr = zeros(1, 10);
                arr(i + 1) = 1;
                arr = reshape(arr, 1, []);
                imagesTarget(:, j + i * 4) = arr;
            end
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

