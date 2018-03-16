function [svind, SV, SVbound, SVnonbound] = BuscarSVs(alfa, toleranciaAlfa, C)
maxalfa = max(alfa);
if maxalfa > toleranciaAlfa,
  SVLimiar = toleranciaAlfa;
else
  % Quanto o kernel é complexo e o conjunto de dados é pequeno, todos os  
  % alfas serão muito pequenos. Assim, foi utilizado a média entre o 
  % logaritmo mínimo e os valores máximos dos alfas como limiar.  
  SVLimiar = exp((log(max(eps,maxalfa))+log(eps))/2);
end
SV = logical(uint8((C-toleranciaAlfa) >= alfa & alfa >=SVLimiar));
SVbound = logical(uint8(alfa>(C-toleranciaAlfa)));

SVnonbound = SV & (~SVbound);
svind = find(SV == 1);