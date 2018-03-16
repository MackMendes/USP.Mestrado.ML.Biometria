function RunHoldout(n,X,S,split,algor)
%% INICIALIZACAO
% Vetor de acuracias
acc = zeros(n,1);

% Parametros RNA
h = 4;              % Numero de neuronios na camada escondida
epocasMax = 750;    % Numero maximo de epocas

% Parametros SVM
kernel = 'rbf';
C = 20;
sigma = 2;

% Parametros kNN
k = 3;

for i=1:n
    [train, label, test, target] = Holdout(X,S,split);
    switch algor
        case 'rna'
            [A, B, ~,~] = NeuralNetwork(train,label,h,epocasMax);
            Y = perceptrons(test,A,B);
            Y = BinaryMatrix(Y);
            acc(i) = sum(all(Y == target,2)) / size(target,1);
        case 'svm'
            [~,~,~,acc(i)] = OnevsOne(train,test,target,kernel,C,sigma);
        case 'knn'
            acc(i) = knn(train,label,test,target,k);
    end
            
end

info.rows = size(X,1);
info.cols = size(X,2);
info.alg = algor;
info.runs = n;
info.folds = split;
info.accuracy = acc;

clear n X S folds algor i acc A B C epocasMax h k kernel label sigma split target test train Y;
save('renomeie-este-arquivo.mat');
end