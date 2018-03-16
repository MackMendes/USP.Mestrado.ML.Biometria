%
% SVMDemo
function SVMDemo()
% 1� Compara��o
    [Xtr, Xts, Ytr, N, C] = InicialLinear();
    executa(Xtr,Xts,Ytr,N,C);
 
function C = ObterC()
lambda=1e-4;
C = 2 / lambda;  % convers�o do valor de lambda para o parametro C do SVM

% Carregamento do dataset feito pelo Andrei e pelo Charles
function [Xtr, Xts, Ytr, N, C]= InicialLinearCrab()
[X, S] = crab_dataset; X = X'; S = S';
[train, label, test, output] = Holdout(X, S, 1/2)



% Carregamento do dataset feito pelo Andrei e pelo Charles
function [Xtr, Xts, Ytr, N, C]= InicialLinear()
x = iris_dataset; % N�o utilizamos o t resultante deste dataset
X = x';
Xtr = X(1:30,:);
Xts = X(31:50,:);
Xtr = [Xtr ; X(51:80,:)];
Xts = [Xts ; X(81:100,:)];
Xtr = [Xtr ; X(101:130,:)];
Xts = [Xts ; X(131:150,:)];
Ytr(1: 30) = 1;
Ytr(31: 90) = -1;
Ytr = Ytr';
N = 90;
C = ObterC();  
    
 
function executa(X,Xts,Y,~,C)
kernel = 'rbf';
param = 1;

[Ssvm, alfa, b]=TreinaSVM(X,Y,C, kernel, param);

%Apenas para analisar os resultados
S = sign(Ssvm);
classpos = find(S==1);
classneg = find(S==-1);
%====================

d = 0.005;
x1plot = min(X(:,1)):d:max(X(:,2));
x2plot = min(X(:,1)):d:max(X(:,2));

[x1,x2] = meshgrid(x1plot,x2plot);
x1=x1(:);
x2=x2(:);
Nts=length(x1);

%Xn=[x1,x2];
%Ssvm = saida_svm(X,Xn,Y,alfa,b);
Ssvm = SaidaSVM(X,Xts,Y,alfa,b, kernel, param);

Ssvm = sign(Ssvm);
res=sqrt(Nts);

% Limpar o resultado anterior
figure(8)
clf
 
sum(Ssvm(1:20))
sum(Ssvm(21:60))

showResult(Ssvm, X);
% Mostrar o resultado!
%imagesc(x1,x2,reshape(Ssvm,res,res));
%hold on
%plot(X(1:N,1),X(1:N,2),'b*')
%plot(X(N+1:2*N,1),X(N+1:2*N,2),'r*')
%title('Saida gerada pelo SVM');






