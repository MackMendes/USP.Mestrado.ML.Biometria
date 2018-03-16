function H = Wilcoxon(X,Y)
% WILCOXON Teste estatístico não-paramétrico
% Dadas duas amostras X oriunda de uma c.d.f desconhecida F e Y oriunda de 
% uma c.d.f desconhecida G, o objetivo é verificar se ambas pertencem
% a mesma distribuição de probabilidades:
% H0 F == G
% H1 F != G 
% Caso positivo, a hipótese nula é aceita. Caso contrário, é rejeitada.
% Retorna o resultado booleano do teste. H assume true caso H0 seja aceita 
% ou false caso a H1 seja rejeitada.

% Carrega dimensoes das amostras
m = size(X,1);
n = size(Y,1);

alpha = 0.01; % Nível de significância

% Esperanca e Variancia
ES = (m*(m+n+1)) / 2;
VarS = ((m*n)*(m + n + 1)) / 12;

% Vetor de ranqueamento
[R, I] = sort([X; Y]);   % Em I, numeros até m, pertencem a X, numeros > m pertencem a Y.

S = sum(find(I <= m));    % Soma as posições de todas as observações de X

% Considerando que a media do rank I = 1/2 * (m+n+1)...
% Se hipotese nula verdadeira, Esperanca de S = m(m + n + 1) / 2


% Alem disso, se hipotese nula verdadeira a variancia de S sera dada por:

% Por fim, considerando m e n suficientemente grandes, as respectivas
% distribuicoes sao aproximadamente normais. Portanto rejeita-se a hipotese
% nula caso o valor de S distancia-se muito da Esperanca de S.

Z = (S - ES) / (VarS^(1/2));

p = normcdf(Z); % Obtem p-value;


% Assumindo que S é oriunda da distribuição normal, calcula-se o threshold
% c para que o teste tenha nivel de significancia = alpha

if abs(S - (1/2)*m*(m + n + 1)) >= VarS^(1/2)*norminv(1 - alpha/2)
    H = true;  % Rejeita hipotese nula
    fprintf('Hipótese nula rejeitada ao nível de significância %2.2f \n', alpha);
else % Aceita hipotese nula
    fprintf('Falhamos em rejeitar a hipótese nula. Ambos os algoritmos possuem mesma c.d.f ao nível de significância %2.2f \n',alpha);
    H = false;
end

