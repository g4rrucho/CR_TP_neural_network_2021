%% Clear all vars
clear all
clc

%% Get images
images = readImagesFolder("./Pasta1/", 0.01);
[m n] = size(images);
imagesTarget = eye(n);

%% Criar a rede neuronal
net = feedforwardnet(10);
net.trainFcn = 'trainscg';
% trainlm, trainscg
net.trainParam.epochs=100;

net.layers{1}.transferFcn = 'purelin';
net.layers{2}.transferFcn = 'purelin';
net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 1;
net.divideParam.valRatio = 0;
net.divideParam.testRatio = 0;

%% Let's train the network
[net, tr] = train(net, images, imagesTarget);

%% Let's test it
out = sim(net, images);

%% Show results
plotconfusion(imagesTarget, out)
plotperf(tr)

%% Calculate and show classifications percentages 
r = 0;
for i=1:size(out,1)
    [a b] = max(out(:,i));
    [c d] = max(imagesTarget(:,i));
    if b == d
      r = r+1;
    end
end

accuracy = r/size(out,2)*100;
fprintf('Precisao total de treino %f\n', accuracy)

%% Simular apenas o conjunto de teste
tImages = images(:, tr.testInd);
tImagesTarget = imagesTarget(:, tr.testInd);

tOut = sim(net, tImages);
plotconfusion(imagesTarget, out)

%% Calcular a percentagem de classificações corretas no conjunto
r = 0;
for i = 1 : size(tr.testInd, 2)
    [a b] = max(tOut(:, i));
    [c d] = max(tImagesTarget(:, i));
    if b == d
        r = r + 1;
    end
end

tAccuracy = r/size(tr.testInd, 2) * 100;
fprintf('Precisao teste %f\n', accuracy)
