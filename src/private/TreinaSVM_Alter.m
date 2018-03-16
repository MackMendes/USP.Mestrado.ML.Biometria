% Treina o SVM com base no conjunto de dados
function [f, alfa, b, svsCoeficientes, sv] = TreinaSVM_Alter(X, Y, c, QPSize, Ker, param)
[N, d] = size(X);
toleranciaAlfa = 0.0010;

interacao = 0;
workset = logical(uint8(zeros(N, 1)));
quantRepedido = 0;
limiteInteracao = 30;

toleranciaKKT = 0.0500;
C = ones(N ,1).*c;

% Obtendo os pontos que estão na classe Class0 e Class1
class1 = logical(uint8(Y>=0));
class0 = logical(uint8(Y<0));
Y(class1) = 1;
Y(class0) = -1;
%%%%%

QPsize = min(N, QPSize);
alfa = zeros(N, 1);

SVMSaida = zeros(N, 1);

%Opções do quadprog
quadprogopt = optimset('Display', 'off', 'MaxIter', 500);

while 1
    %===============================
    % Determinando os vetores de suporte
    [svind, SV, SVbound, SVnonbound] = buscarSVs(alfa, toleranciaAlfa, C);
    workSV = find(SVnonbound & workset);
    
    %===============================
    % Determinando a saida do SVM para todos os exemplos
    if (interacao==0),
        SVAlterados = svind;
        AlfasAlterados = alfa(SVAlterados);
        SVMSaida = zeros(N, 1);
        if strcmp(Ker, 'linear'),
            normalw = zeros([1 d]);
        end
    else
        %== Segunda vez, entrou aqui.
        
        % Encontre os coeficientes que foram alterados e ajuste a saída 
        % SVM somente pela diferença de alfa antigo e novo
        SVAlterados = find(alfa~=alphaOld);
        AlfasAlterados = alfa(SVAlterados)-alphaOld(SVAlterados);
    end
        
    [nchang, dchang] = size(SVAlterados');
    ind = nchang:N;
    ind2 = nchang:dchang;
    if strcmp(Ker, 'linear')
        temp = AlfasAlterados(ind2).*Y(SVAlterados(ind2));
        normalw = normalw+temp'*X(SVAlterados(ind2), :);
        SVMSaida = zeros(N, 1);        
        SVMSaida(ind) = X(ind,:)*(normalw');
    else
        k1 = Kernel(X(ind, :), X(SVAlterados(ind2), :), Ker, param);    
        coeficiente = AlfasAlterados(ind2).*Y(SVAlterados(ind2));
        SVMSaida(ind) = SVMSaida(ind)+k1*coeficiente;
    end
    
    %===============================
    % Calculando o BIAS
    bias = 0;
    if ~isempty(workSV),
        bias = (Y(workSV) - SVMSaida(workSV))' / SV(workSV)';
    end
    
    %===============================
    % Calculando as condições de KKT.
    KKT = (SVMSaida+bias).*Y-1;
    
    % Rever as condições de KKT
    KKTviolations = logical(uint8((SVnonbound & (abs(KKT)> toleranciaKKT)) | ...
        (SVbound & (KKT> toleranciaKKT)) | ...
        (~SV & (KKT<- toleranciaKKT))));
    
    %===============================
    %Se não teve violações, sair do laço
    if isempty(find(KKTviolations, 1)) || limiteInteracao == interacao,
        break;
    end   
    
    %===============================
    %Determine o novo conjunto de trabalho
    %Definindo direção de busca
    direcaoBusca = SVMSaida-Y;
    
    %Define Set1 e Set2
    set1 = logical(class0 | (~SVbound & SV));
    set2 = logical(class1 | (~SVbound & SV));
    
    if(interacao == 0),
        % Não melhorou deixando a direção da busca randomico na primeira
        % passagem.
        %searchDir = rand([N 1]);
        set1 = class1;
        set2 = class0;
    end
    
    %===============================
    %=======Calcula o worset
    worksetOld = workset;
    [workset, worksetind, worksize, naoworkSV] = CalculeWorkSet(set1, set2,...
        QPsize, direcaoBusca, N, SV);
    
    % Caso não ocorra mudanças no WorktSet em três vezes
    % consecutivas, saio do laço.
    if all(workset==worksetOld),
        quantRepedido = quantRepedido+1;
        if ((quantRepedido==3)),
            break;
        end
    else
        quantRepedido = 0;
    end
       
    % Determine a parte linear do problema quadratico.
    qBN = 0;
    if ~isempty(naoworkSV),
        [nnonworkSV, dnonworkSV] = size(naoworkSV');
        ind = nnonworkSV:dnonworkSV;
        Ki = Kernel(X(worksetind, :), X(naoworkSV(ind), :), Ker, param);
        qBN = qBN+Ki*(alfa(naoworkSV(ind)).*Y(naoworkSV(ind)));
        qBN = qBN.*Y(workset);
    end
    
    f = qBN-ones(worksize, 1);
    
    % Resolver o problema quadrático
    K = Kernel(X(worksetind,:), X(worksetind,:), Ker, param);
    
    % Máximar os valores, para aumentar a margen dos valores.
    H = K+diag(ones(worksize, 1)*eps^(2/3));
    
    H = (Y(workset)*Y(workset)').*H;
    
    vlb = zeros(worksize, 1);
    vub = C(workset);
    beq = 0;
    x0 = zeros(worksize,1);
    Aeq = Y(workset)';
    workalfa = quadprog(H, f, [], [], Aeq, beq, vlb,vub, x0, quadprogopt);
    
    % ==============================================================
    alphaOld = alfa;
    alfa(workset) = workalfa;
    
    interacao = interacao+1;
end

% if strcmp(Ker, 'linear'),
%     X = X*(normalw');
%     X = X+bias;
% end

svsCoeficientes = alfa(svind).*Y(svind);
sv = X(svind, :);

KSaida = Kernel(X, X, Ker, param);
NSV = sum(alfa>0);
b = 1/NSV*sum(Y-KSaida*(alfa.*Y));
f = KSaida*(alfa.*Y)+b;


function [svind, SV, SVbound, SVnonbound] = buscarSVs(alfa, toleranciaAlfa, C)
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
