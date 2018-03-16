function mtxResult = TuningSVM()
load('../datasets/db2_faces_split.mat');

variaC = [20 1000 2000];
variaParamRBF = [1 128 512 8192 16384 32768];
variaParamPoly = [1 2 3 6 8 12 18 22 30];

mtxResultRBF = TuringSVMRBF(variaParamRBF, variaC, Xtr, Xts, Sts);
mtxResultPoly = TuringSVMPoly(variaParamPoly, variaC, Xtr, Xts, Sts);

mtxResult = [mtxResultRBF; mtxResultPoly];


function mtxResultRBF = TuringSVMRBF(variaParamRBF, variaC, Xtr, Xts, Sts)
    [~, nrbf] = size(variaParamRBF);
    [~, nc] = size(variaC);
    mtxResultRBF = zeros((nrbf*nc), 3);
    
    iGlobal = 1;
    for c = 1:nc
        for n=1:nrbf
           [~,~,~,Y] = OnevsOne(Xtr, Xts, Sts, 'rbf', variaC(c), variaParamRBF(n));       
           mtxResultRBF(iGlobal, :) = [variaParamRBF(n) variaC(c) Y]; 
           iGlobal = iGlobal + 1;
        end
    end

function mtxResultPoly = TuringSVMPoly(variaParamPoly, variaC, Xtr, Xts, Sts)
    [~, nc] = size(variaC);  
    [~, npoly] = size(variaParamPoly);
    mtxResultPoly = zeros((npoly * nc), 3);
    
    iGlobal = 1;
    for c = 1:nc
        for n=1:npoly
           [~,~,~,Y] = OnevsOne(Xtr, Xts, Sts, 'poly', variaC(c), variaParamPoly(n));
           mtxResultPoly(iGlobal, :) = [variaParamPoly(n) variaC(c) Y];       
           iGlobal = iGlobal + 1;
        end
    end
