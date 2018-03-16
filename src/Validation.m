function [Yts, acertoV, EQMv, acc] = Validation(Xts, Sts, A, B)
[N] = size(Xts,1);
Yts = perceptrons(Xts,A,B);

erro = Yts - Sts;
EQMv = (1/N)*(sum(sum(erro.*erro)));

Yts = adaptarMatriz(Yts); %tranforma a matriz Y em bin?ria 
acertoV = sum(Yts==Sts);
acc = Acuracy(acertoV, Xts);
end

function acc = Acuracy(acertoV, Xts)

m = size(acertoV, 2);
n = size(Xts, 1);
acuracia = [];

for i=1:m
    acuracia = acertoV/n;   
end
acc = sum(acuracia)/m;
end

function Y = adaptarMatriz(Y)%transformar a matriz Y em bin?ria
n = size(Y,1);%quantidade de dados da matriz Y (matriz de sa?da da rede)
for i=1:n
y = Y(i,:); %linha i da matriz
Y(i,:) = (y == max(y));  %transforma o maior valor da linha em 1 e os outros em 0  
end
end
