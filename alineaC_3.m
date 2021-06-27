%% Clear all vars
clear
clc

%% Set variables
filename = 'alineaC_3.mat';

%% Get images
images = readImagesFolder('./Pasta1/', 0.01);

if(~isfile(filename))
    net = feedforwardnet([5,5]);
    net = train(net, images, imagesTarget);
    
    net.layers{1}.transferFcn = 'tansig';
    net.layers{2}.transferFcn = 'tansig';
    net.layers{3}.transferFcn = 'tansig';
    
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

%% Check agaisn't images in folder
folder = 1;

switch folder
    case 1
    case 2
    case 3
end
