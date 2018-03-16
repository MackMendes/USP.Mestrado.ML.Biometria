function Y = perceptrons(X,A,B)
N = size(X,1);
Zin = [X,ones(N,1)]*A'; %neurônios na camada escondida
Z = 1./(1+exp(-Zin)); %resultados da saída dos neurônios com a função de ativação
Yin = [Z,ones(N,1)]*B'; %neurônios na camada de saída
Y = 1./(1+exp(-Yin)); %resultados da saída da rede depois da função de ativação
end
