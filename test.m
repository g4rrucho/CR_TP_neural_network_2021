% Clear all vars
clear all
clc

% Get images
images = readImagesFolder("./Pasta1/", 0.01);
[m n] = size(images);
imagesTarget = eye(n);

% Criar a rede neuronal
net = feedforwardnet(10);
%et = patternnet(10);
net.trainFcn = 'trainbfg';
net.trainParam.epochs=100;

net.layers{1}.transferFcn = 'purelin';
net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 1;
net.divideParam.valRatio = 0.15;
net.divideParam.testRatio = 0.15;
[net, tr] = train(net, images, imagesTarget);

out = sim(net, images);

plotconfusion(imagesTarget, out)
plotperf(tr)

r = 0;
for i=1:size(out,1)
    [a b] = max(out(:,i));
    [c d] = max(imagesTarget(:,i));
    if b == d
      r = r+1;
    end
end

accuracy = r/size(out,2);
fprintf('Precisao total de treino %f\n', accuracy)
