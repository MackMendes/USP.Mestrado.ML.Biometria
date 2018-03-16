% Treina o SVM com base no conjunto de dados
function [f, alfa, b, svsCoeficientes, sv] = TreinaSVM(X, Y, c, QPSize, Ker, param)
[N, d] = size(X);
toleranciaAlfa = 0.0010;

interacao = 0;
workset = logical(uint8(zeros(N, 1)));
quantRepedido = 0;
limiteInteracao = 300;

toleranciaKKT = 0.0500;
C = ones(N ,1).*c;

% Obtendo os pontos que estão na classe Class0 e Class1
class1 = logical(uint8(Y>=0));
class0 = logical(uint8(Y<0));
Y(class1) = 1;
Y(class0) = -1;
%%%%%

% Obtem o QPsize
QPsize = min(N, QPSize);
alfa = zeros(N, 1);

SVMSaida = zeros(N, 1);

%Opções do quadprog
quadprogopt = optimset('Display', 'off', 'MaxIter', 500);

while 1
    %===============================
    % Determinando os vetores de suporte
    [svind, SV, SVbound, SVnonbound] = BuscarSVs(alfa, toleranciaAlfa, C);
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
        % Encontra os coeficientes que foram alterados e ajusta a saída 
        % dos SVMs, com a diferença dos alfas antigo sobre os novos
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
        % Obtendo a direação da busca randomica no primeiro passo.
        direcaoBusca = rand([N 1]);
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
    H = (Y(workset)*Y(workset)').*K;
    
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

svsCoeficientes = alfa(svind).*Y(svind);
sv = X(svind, :);

% Calculando a saída sobre todos os alfas encontrados
KSaida = Kernel(X, X, Ker, param);
NSV = sum(alfa>0);
b = 1/NSV*sum(Y-KSaida*(alfa.*Y));
f = KSaida*(alfa.*Y)+b;



