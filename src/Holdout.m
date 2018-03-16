function [train, label, test, output] = Holdout(X,S,split)
% HOLDOUT Implementa estratégia holdout de validação.
% Recebe conjunto original de instâncias X, saídas desejadas S
% e percentual para conjunto de treinamento e.g. split = 2/3
% e retorna subconjuntos disjuntos para teste e treinamento
% na proporção especificada.

    % Obtém informações do conjunto de dados
    [n,m] = size(X);
    c = size(S,2);
	% Randomiza o conjunto de treinamento
	X = [X,S];
	X = X(randperm(n),:);
	S = X(:,m+1:m+c);
	X(:,m+1:m+c) = [];

	% Prepara os subconjuntos
	train = X(1:n*split,:);
	label = S(1:n*split,:);
	test = X((n*split)+1:end,:);
	output = S((n*split)+1:end,:);
end


