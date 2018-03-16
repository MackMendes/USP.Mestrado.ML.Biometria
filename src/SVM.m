
function [F, A, B, Yacc] = SVM()
    load('../datasets/iris_split.mat');
    C = 20;
    Kernel = 'rbf';
    Sigma = 2;
    [F, A, B, Yacc] = OnevsOne(Xtr, Xts, Sts, Kernel, C, Sigma);  
end
