function K = Kernel(X1,X2,Ker,param)

if strcmp(Ker, 'linear')  % Linear
    K = (X1*X2');
            
elseif strcmp(Ker,'poly')  % Polinomial 
    K=((X1*X2').^param);
   
elseif strcmp(Ker,'rbf')   %Função Gaussiana de Base Radial   
    n1=size(X1,1);
    n2=size(X2,1);
        
    normaVetorX1 = (sum(X1'.^2)'*ones(1,n2));
    normaVetorX2 = (ones(n1,1)*sum(X2'.^2));
    
    % - ||X1 - X2||^2
    calcNormaXs = (normaVetorX1 + normaVetorX2 - 2*(X1*X2'));
    
    % Exp(-(||X1 - X2||^2)/2*sigma^2)
    K = exp(-calcNormaXs/(2*param^2));  
    
end

end

