%% Preparar e treinar rede

net = feedforwardnet([20 20 20 20 20 20]);

net.trainFcn = 'trainscg';
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'logsig';
net.layers{3}.transferFcn = 'purelin';
net.layers{4}.transferFcn = 'tansig';
net.layers{5}.transferFcn = 'tansig';
net.layers{6}.transferFcn = 'logsig';
net.layers{7}.transferFcn = 'purelin';
net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 0.7;
net.divideParam.valRatio = 0.15;
net.divideParam.testRatio = 0.15;

[net,~] = train(net, letrasBW, letrasTarget);

%% Simular e analisar resultados

out = sim(net, letrasBW)
r = 0;
for i=1:size(out,2)
    [a b] = max(out(:,i));
    [c d] = max(letrasTarget(:,i));
    if b == d
      r = r+1;
    end
end

accuracy = r/size(out,2);
fprintf('Precisao total de treino %f\n', accuracy)
