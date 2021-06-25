% Get images
images = readImagesFolder("./Pasta1/", 0.5);
[m n] = size(images);
imagesTarget = eye(n);

% Criar a rede neuronal
net = feedforwardnet(10);
net.trainFcn = 'trainscg';
net.layers{1}.transferFcn = 'tansig';
net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 0.7;
net.divideParam.valRatio = 0.15;
net.divideParam.testRatio = 0.15;
[net, ~] = train(net, images, imagesTarget);
% 
% 
% a = [1:10]
% a = transpose(a);
% 
% images = repmat(a,1,1)
% images = repmat(a,1,2)
% images{1,2} = a