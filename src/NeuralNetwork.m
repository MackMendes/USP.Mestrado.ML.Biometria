function [A, B, errotr, Y] = NeuralNetwork(X, S, h, epocasMax)

%   errotr -> vetor que guardará todo o erro quadrático médio (EQM)
%        X -> conjunto de dados de entrada
%        h -> número de neurônios na camada escondida
%        S -> conjunto de valores desejados
%epocasMax -> número máximo de épocas desejado

[N,ne] = size(X); %dimensões do conjunto de dados N linhas e ne colunas (entradas)
[N,ns] = size(S); %dimensões do conjunto de dados N linhas e ns colunas (saídas)

A = rands(h,ne+1)/5; %inicilizando a matriz A de pesos com h linhas e ne+1(bias) colunas
B = rands(ns,h+1)/5; %inicilizando a matriz B de pesos com ns linhas e h+1(bias) colunas

alfa = 1; %taxa de aprendizado
erromin = 1e-5; %erro mínimo

%calcular saída da rede
Y = perceptrons(X,A,B);
%calcular erro da rede
erro = Y-S;
%calcular o erro quadrático médio
EQM = (1/N)*(sum(sum(erro.*erro)));
%vetor de erro
errotr = [];
errotr = [errotr, EQM];

epoca = 0; %inicializa o número de épocas

while EQM > erromin && epoca < epocasMax
   epoca = epoca +1; 
   [dJdA,dJdB]=gradiente(X,A,B,S,h); %calcula o gradiente
   
   %transforma opara vetor
   vetdJdA = reshape(dJdA,1,h*(ne+1))';
   vetdJdB = reshape(dJdB,1,ns*(h+1))';
   
   %vetor gradiente
   g = [vetdJdA;vetdJdB];
   g = g/norm(g); %normaliza o vetor gradiente
   
   %tranforma em vetor
   vetdJdA = g(1:h*(ne+1));
   vetdJdB = g(h*(ne+1)+1:end);
   
   %tranforma em matriz
   dJdA = reshape(vetdJdA',h,ne+1);
   dJdB = reshape(vetdJdB',ns,h+1);
   
   %atualiza as matrizes A e B
   Aatual = A-alfa*dJdA;
   Batual = B-alfa*dJdB;
   
   Y = perceptrons(X,Aatual,Batual); %calcula a saída da rede
   erro = Y-S; %calcula o vetor com os erros
   
   EQMatual=(1/N)*(sum(sum(erro.*erro))); %calcula o erro quadrático médio
   
   while EQMatual > EQM
        alfa = alfa/2;
        % Atualiza a matriz A e B
        Aatual = A-alfa*dJdA;
        Batual = B-alfa*dJdB;
        % Calcula a S da rede
        Y = perceptrons(X,Aatual,Batual);
        % Calcula o vetor com os erros
        erro = Y-S;
         % Calcula o Erro quadratico medio
        EQMatual=(1/N)*(sum(sum(erro.*erro)));
   end 

   % Incrementa a taxa de aprendizagem
   alfa = alfa*2;
   % Atualiza as matrizes de entrada e S
   A = Aatual;
   B = Batual;
   EQM = EQMatual;   
   errotr = [errotr,EQM];
   
end

Y = BinaryMatrix(Y); %tranforma a matriz Y em bin?ria 
%acertoCL = sum(Y==S);
plot(errotr);
end

function [dJdA, dJdB] = gradiente(X,A,B,S,h)
N = size(X,1);
Zin = [X,ones(N,1)]*A';
Z = 1./(1+exp(-Zin));
Yin = [Z,ones(N,1)]*B';
Y = 1./(1+exp(-Yin));
erro = Y-S; %calcula o erro da rede
dJdB = erro'*[Z,ones(N,1)]; %calcula o gradiente de B
sig = erro*B(:,1:h).*(1-Z).*Z;
dJdA = sig'*[X,ones(N,1)]; %calcula o gradiente de A
end
