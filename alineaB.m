%% Clear all vars
clear
clc

%% Get images
images = readImagesFolder('./Pasta2/', 0.01);
[m n] = size(images);

for i = 0:9
    for j = 1:10
        arr = zeros(1, 10);
        arr(i + 1) = 1;
        arr = reshape(arr, 1, []);
        imagesTarget(:, j + i * 10) = arr;
    end
end

%% Criar a rede neuronal
net = feedforwardnet(10);

net.trainFcn = 'trainlm';
net.trainParam.epochs = 100;

net.layers{1}.transferFcn = 'purelin';
net.layers{2}.transferFcn = 'purelin';
net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 0.7    ;
net.divideParam.valRatio = 0.15;
net.divideParam.testRatio =  0.15;

%% Treinar a rede 
[net, tr] = train(net, images, imagesTarget);

%% Simular | Let's test it
out = sim(net, images);

%% Show performance
plotconfusion(imagesTarget, out); % Matrix de confusao
plotperf(tr); % Desempenho da rede

%% Calcular e mostrar a percentagem de classificações corretas
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

%% Simular a rede com o conjunto de teste
tImages = images(:, tr.testInd);
tImagesTarget = imagesTarget(:, tr.testInd);

tOut = sim(net, tImages);

%% Calcular e mostrar a percentagem de classificações corretas
r = 0;
for i = 1:size(tr.testInd, 2)
    [a b] = max(tOut(:, i));
    [c d] = max(tImagesTarget(:, i));
    
    if b == d
        r = r + 1;
    end
end

tAccuracy = r / size(tr.testInd, 2) * 100;
fprintf("Precisão teste %f\n", tAccuracy);