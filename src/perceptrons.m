function Y = perceptrons(X,A,B)
N = size(X,1);
Zin = [X,ones(N,1)]*A'; %neur�nios na camada escondida
Z = 1./(1+exp(-Zin)); %resultados da sa�da dos neur�nios com a fun��o de ativa��o
Yin = [Z,ones(N,1)]*B'; %neur�nios na camada de sa�da
Y = 1./(1+exp(-Yin)); %resultados da sa�da da rede depois da fun��o de ativa��o
end
