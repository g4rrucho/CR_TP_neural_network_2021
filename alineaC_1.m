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

%% Obter a rede neuronal com melhor qualidade, caso ainda nao exista
if(~isfile('alineaC_1.mat'))
    net = getNeuralNetwork();
    save('alineaC_1.mat');
else
    load('alineaC_1.mat');
    
    net.trainFcn = 'trainlm';
    net.trainParam.epochs = 100;

    net.layers{1}.transferFcn = 'tansig'; % Hidden layer 1
    net.layers{2}.transferFcn = 'tansig'; % Hidden layer 2
    net.layers{3}.transferFcn = 'purelin'; % Output layer
    net.divideFcn = 'dividerand';
    net.divideParam.trainRatio = 0.7;
    net.divideParam.valRatio = 0.15;
    net.divideParam.testRatio =  0.15;
end

%% Simulate
out = sim(net, images);

%% Show performance
plotconfusion(imagesTarget, out);

%% Calcular e mostrar percentagem de classificações
r = 0;
for i = 1:size(out, 2)
    [a b] = max(out(:, i));
    [c d] = max(imagesTarget(:, i));
    
    if b == d
        r = r + 1;
    end
end

accuracy = r / size(out, 2) * 100;
fprintf("Precisao total %f\n", accuracy);