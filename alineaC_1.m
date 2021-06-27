%% Clear all vars
clear
clc

%% Get images
images = readImagesFolder('./Pasta3/', 0.01);

%% Prepare images target array
for i = 0:9
    for j = 1:10
        arr = zeros(1, 10);
        arr(i + 1) = 1;
        arr = reshape(arr, 1, []);
        imagesTarget(:, j + i * 10) = arr;
    end
end

%% Obter a rede neuronal com melhor qualidade
net = getNeuronalNetwork();

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