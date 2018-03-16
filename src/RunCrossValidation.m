function RunCrossValidation(n,X,S,folds,algor)
acc = zeros(n,1);
for i=1:n
    acc(i) = CrossValidation(X,S,folds,algor);
end

info.rows = size(X,1);
info.cols = size(X,2);
info.alg = algor;
info.runs = n;
info.folds = folds;
info.accuracy = acc;

clear n X S folds algor i acc;
save('renomeie-este-arquivo.mat');
end