function acuracia = knn(train, label, test, target, k)
%k-Nearest Neighbor 
%   Dado um conjunto de treinamento, calcula a distancia euclideana
%   entre o dado de teste e cada instancia de treinamento. A pertinencia da
%   instancia de teste a determinada classe e decidida por voto majoritario
%   entre as k instancias mais proximas.

% Inicializacao
n = size(train,1);     % Quantidade de instancias de treinamento
[m,c] = size(target);   % Dimensoes do conjunto de teste
d = zeros(n,1);         % Vetor de distancias
S = zeros(m,c);         % Matriz de saidas

for i=1:m
    y = test(i,:);
    for j=1:n
        x = train(j,:);
        d(j) = norm(x-y);  % Distancia euclideana entre x e y
    end
    
    [d, ind] = sort(d);    % Ordena as linhas da matriz de D %% SORT ROWS?

    % Voto majoritario
    K = label(ind(1:k),:); % Classes dos k-vizinhos mais proximos
    votos = sum(K);        % Contagem dos votos
    
    [~, classe] = max(votos);
    
    S(i,:) = zeros(1,c);    % Inicializa vetor de saida
    S(i,classe) = 1;        % Assinala 1 a classe vencedora
end

acuracia = sum(all(S == target,2))/m;

end
