function S()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% 1 0 0 0
% 1 0 0 0
% 1 0 0 0
% 1 0 0 0
% 0 1 0 0
% 0 1 0 0
% 0 1 0 0
% 0 1 0 0
% 0 0 1 0
% 0 0 1 0
% 0 0 1 0
% 0 0 1 0
% 0 0 0 1
% 0 0 0 1
% 0 0 0 1
% 0 0 0 1

coluna = 1;
a = 1;

for i=1:8904   
    for j=1:106
        if(i/(84 + a) == 1)
            coluna = coluna + 1;
            a = a + 84;
        end
        
        if(coluna == j)
            S(i,j) = 1;
        else
            S(i,j) = 0;
        end 
        
%         if(i/(4 + a) == 1)
%             coluna = coluna + 1;
%             a = a + 4;
%         end
        
        
    end  

end  

%disp(S);
save MatrizS S;
end

