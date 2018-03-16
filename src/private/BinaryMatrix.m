function Y = BinaryMatrix(Y)
%BINARYMATRIX Transformar a matriz Y em binária

n = size(Y,1); %quantidade de dados da matriz Y (matriz de sa?da da rede)

for i=1:n
y = Y(i,:); %linha i da matriz
Y(i,:) = (y == max(y));  %transforma o maior valor da linha em 1 e os outros em 0  
end

end

