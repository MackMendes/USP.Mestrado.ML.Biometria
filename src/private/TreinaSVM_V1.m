% Treina o SVM com base no conjunto de dados
function [f, alfa,b] = TreinaSVM_V1(X,Y,C,Ker,param)
 K = Kernel(X, X, Ker, param);
 H = (Y*Y').*K;
 [N, ~] = size(X);
 c = -ones(N,1);
 vlb = zeros(N,1);
 vub = C*ones(N,1);
 x0 = zeros(N,1);
 A =[ ];
 b = [ ];
 Aeq =Y';
 beq =0;
 alfa = quadprog(H,c,A,b,Aeq,beq,vlb,vub,x0);
 NSV = sum(alfa>0);
 b = 1/NSV*sum(Y-K*(alfa.*Y));
 f = K*(alfa.*Y)+b;