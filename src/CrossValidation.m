function avg = CrossValidation(X,S,folds,algor)
%CROSS-VALIDATION Implementa validação cruzada
%   Divide o conjunto X em k partes (folds). Uma parte é reservada
%   para teste e as outras k-1 partes para treinamento. O procedimento é repetido
%   k vezes, variando a parte utilizada para treinamento a cada execução. 
%   A acurácia média das k execuções é reportada.
%   Para testar, basta chamar a função passando os parâmetros:
%   X = conjunto de instâncias, S = rótulos das instâncias, folds e
%   algor = rna ou svm

%=== INICIALIZAÇÃO ===

%Contar o tempo
dateInitial = datetime('now');

% Obtem informacões do conjunto de dados
[n,m] = size(X);
c = size(S,2);

% Define parâmetros dos folds
fold_avg = floor(n/folds);  % Tamanho médio do fold
fold_res = mod(n,folds);    % Número de instâncias excedentes
qtd_class = floor(fold_avg/c); % Quantidade de instâncias por classe no fold.
fold_max = (qtd_class+1)*c; % Tamanho do maior fold
fold_min = qtd_class*c;     % Tamanho do menor fold


% Inicializa variáveis
F = zeros(n/c,c);   % Matriz de índices das instâncias
acc = zeros(folds,1); % Vetor de acurácias

% Define parâmetros do classificador
switch algor
    case 'rna'
        epocasMax = 50;
        h = 2;
    case 'svm'
        kernel = 'rbf';
        C = 2000;
        param = 8190;
    case 'knn'
        k = 3;
end

% Randomiza o conjunto de treinamento
X = [X,S];
X = X(randperm(n),:);
S = X(:,m+1:m+c);
X(:,m+1:m+c) = [];

% Monta matriz base para folds
for j=1:c
    F(:,j) = find(S(:,j) == 1); % Encontra todos as instancias da classe j
end

% CLASSIFICAÇÃO
for k=1:folds
    
    % Define índices inferior e superior para instâncias do fold
    l = qtd_class*(k-1) + 1;
    u = qtd_class*k;
    
    % �?ndices das instâncias que farão parte do fold
    f = reshape(F(l:u,:),fold_min,1);
    
    % Caso haja instância excedente adiciona no fold
    if k-1 < fold_res
        f = [f; reshape(F(end-k,:),c,1)];
        fold_len = fold_max;
    else
        fold_len = fold_min;
    end
    
    % Prepara folds de teste e treinamento
    train = X; label = S;
    
    test = X(f,:);
    target = S(f,:);
    
    train(f,:) = [];
    label(f,:) = [];   
    
    % Treinamento e Teste do classificador
    switch algor
        case 'rna'
            [A,B,~,~] = NeuralNetwork(train,label,h,epocasMax);
            Y = perceptrons(test,A,B);
            Y = BinaryMatrix(Y);
            acc(k) = sum(all(Y == target,2)) / fold_len;
        case 'svm'
            [~,~,~,acc(k)] = OnevsOne(train,test,target,kernel, C, param);
        case 'knn'
            acc(k) = knn(train,label,test,target,k);
    end    
end

% Reporta acurácia média
avg = mean(acc);
disp(datetime('now') - dateInitial);