% Calcula os WorkSets
function [workset, worksetind, worksize, naoworkset, naoworkSV] = CalculeWorkSet(set1, set2, QPsize, searchDir, N, SV)
workset = logical(uint8(zeros(N, 1)));

% Se a quantidade de valores do Set1 e Set2 forem menor ou igual ao QPSize
if length(find(set1 | set2)) <= QPsize,
    workset(set1 | set2) = 1;
    
% Se o set1 tiver menos dados que o set2    
elseif length(find(set1)) <= floor(QPsize/2),
    workset(set1) = 1;
    set2 = find(set2 & ~workset);
    [~, ind] = sort(searchDir(set2));
    set2Selecionados = min(length(set2), QPsize-length(find(workset)));
    workset(set2(ind(1:set2Selecionados))) = 1;

% Se o set2 estiver com menos dados que o set1
elseif length(find(set2)) <= floor(QPsize/2),
    workset(set2) = 1;
    set1 = find(set1 & ~workset);
    [~, ind] = sort(-searchDir(set1));
    set1Selecionados = min(length(set1), QPsize-length(find(workset)));
    workset(set1(ind(1:set1Selecionados))) = 1;
    
    % Quando estão bem separados
else    
    set1 = find(set1);
    [~, ind] = sort(-searchDir(set1));
    set1Selecionados = min(length(set1), floor(QPsize/2));
    workset(set1(ind(1:set1Selecionados))) = 1;
    set2 = find(set2 & ~workset);
    [~, ind] = sort(searchDir(set2));
    set2Selecionados = min(length(set2), QPsize-length(find(workset)));
    workset(set2(ind(1:set2Selecionados))) = 1;
end

worksetind = find(workset == 1);
worksize  = length(find(workset == 1));
naoworkset = ~workset;
naoworkSV = find((naoworkset & SV) == 1);

