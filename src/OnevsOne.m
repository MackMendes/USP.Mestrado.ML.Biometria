function [F, A, B, Y] = OnevsOne(Xtr, Xts, Yts, kernel, C, param)
%ONEVSONE Implementa estratégia um-contra-um
%   Treinamento: Todas as combinções de K classificadores binários dois a
%   dois são treinados, resultando em K(K-1)/2 classificadores.
%   Esta implementação funciona apenas para conjuntos balanceados de dados.

%Contar o tempo
dateInitial = datetime('now');

% Obtém informações do conjunto de dados
n = size(Xtr,1);
[l,k] = size(Yts);
qtd = n / k;

% Parâmetros de execução das máquinas de vetores suporte
F = []; A = []; B = [];

if nargin<4,
  kernel = 'rbf';
end

if nargin<5,
  C = 20;
end

if nargin < 6 && strcmp(kernel,'rbf')
    %param = 16384;
    param = 2;
end

QpSize = 800;
T = zeros(l,k); % Matriz de vota��o

% Divide o conjunto de dados em K(K-1)/2 subconjuntos
for i=1:k-1
    tic;
    % Estabelece intervalo da primeira classe
    lbound = qtd*(i-1) + 1;
    ubound = qtd*i;
    
    % Obtem subconjunto de treinamento da primeira classe
    P = Xtr(lbound:ubound,:);
    disp(sprintf('Comecou: %d', i));
    for j=i+1:k        
        
        % Estabelece intervalo da segunda classe
        lbound = qtd*(j-1) + 1;
        ubound = qtd*j;
        
        % Obtem subconjunto da segunda classe
        Q = [P; Xtr(lbound:ubound,:)];
        
        % Prepara os rótulos do subconjunto
        m = size(Q,1);
        S = [ones(m/2,1); -ones(m/2,1)];
        
        
        % Treina máquina de vetores suporte para o subconjunto
        [f, alfa, b] = TreinaSVM(Q, S, C, QpSize, kernel, param);
        F = [F; f];
        A = [A; alfa];
        B = [B; b];        
        
        % Submeter conjunto de teste à avaliação do classificador i,j
        y = SaidaSVM(Q,Xts,S,alfa,b,kernel, param);
        
        %Voto majorit�rio
        
        % SVM i,j vota em i
        f = find(y == 1);
        T(f,i) = T(f,i) + 1;
    
        % SVM i,j vota em j
        f = find(y == -1);
        T(f,j) = T(f,j) + 1;
        
    end
    toc;
    disp(sprintf('Executando OneVsOne: %d/%d', i, k-1));
end


% Converte os valores da matriz de vota��o para bin�rios
for i=1:l
    lin = T(i,:);
    Tmax = max(lin);
    
    lin(lin ~= Tmax) = 0;
    lin(lin == Tmax) = 1;

    T(i,:) = lin;
end

disp(datetime('now') - dateInitial);

% Calcula a ac�racia. 
Y = sum(all(T==Yts,2)) / l;
disp(Y);


