%% Clear all vars
clear
clc

%% Get images
images = readImagesFolder('./Pasta3/', 0.01);

%% Prepare images target array
for i = 0:9
    for j = 1:4
        arr = zeros(1, 10);
        arr(i + 1) = 1;
        arr = reshape(arr, 1, []);
        imagesTarget(:, j + i * 4) = arr;
    end
end

%% Preparar a rede neuronal, caso ainda nao exista
if (~isfile('alineaC_2.mat'))
    net = feedforwardnet(10);

    net.trainFcn = 'trainlm';
    net.trainParam.epochs = 20;

    net.layers{1}.transferFcn = 'tansig';
    net.layers{2}.transferFcn = 'purelin';

    net.divideFcn = 'dividerand';
    net.divideParam.trainRatio = 1;
    net.divideParam.valRatio = 0;
    net.divideParam.testRatio =  0;

    [net, tr] = train(net, images, imagesTarget);
    
    save('alineaC_2.mat');
else
    load('alineaC_2.mat');
end

% TODO Mudar a pasta a testar: 1, 2, 3 -> pasta1, pasta2, pasta3
folder = 3;

switch folder
    case 1
        %% Folder Pasta1
        images = readImagesFolder("./Pasta1/", 0.01);
        [m n] = size(images);
        imagesTarget = eye(n);
        
    case 2
        %% Folder Pasta2
        images = readImagesFolder('./Pasta2/', 0.01);
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
