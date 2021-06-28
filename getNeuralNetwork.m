function net = getNeuronalNetwork()
%% Get images
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

%% Criar a rede neuronal
net = feedforwardnet([20, 20]);

% Funçao de treino
net.trainFcn = 'trainlm';
net.trainParam.epochs = 100;

% Funçao de ativação das camadas
net.layers{1}.transferFcn = 'tansig'; % Hidden layer 1
net.layers{2}.transferFcn = 'tansig'; % Hidden layer 2
net.layers{3}.transferFcn = 'purelin'; % Output layer
net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 0.7;
net.divideParam.valRatio = 0.15;
net.divideParam.testRatio =  0.15;

%% Treinar a rede
[net, tr] = train(net, images, imagesTarget);
end