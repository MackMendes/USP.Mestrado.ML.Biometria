% Função de Saída do Kernel
function f= SaidaSVM(Xtr,Xts,Ytr,alfa,b, Ker, param) 
K = Kernel(Xts, Xtr, Ker, param); 
f = sign(K*(alfa.*Ytr)+b); 
end