function [svind, SV, SVbound, SVnonbound] = BuscarSVs(alfa, toleranciaAlfa, C)
maxalfa = max(alfa);
if maxalfa > toleranciaAlfa,
  SVLimiar = toleranciaAlfa;
else
  % Quanto o kernel � complexo e o conjunto de dados � pequeno, todos os  
  % alfas ser�o muito pequenos. Assim, foi utilizado a m�dia entre o 
  % logaritmo m�nimo e os valores m�ximos dos alfas como limiar.  
  SVLimiar = exp((log(max(eps,maxalfa))+log(eps))/2);
end
SV = logical(uint8((C-toleranciaAlfa) >= alfa & alfa >=SVLimiar));
SVbound = logical(uint8(alfa>(C-toleranciaAlfa)));

SVnonbound = SV & (~SVbound);
svind = find(SV == 1);