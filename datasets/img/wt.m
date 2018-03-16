function wt()
    clear all
    close all
    % Quantidade de niveis de decomposicao
    niveldec=4;
    % Funcao Mae
    qtdpessoas=106;
    qtdif=12;
    poses=7;
    Wavelets={'db2'};
    C = [];
    for w=1:length(Wavelets)
        wavelet=Wavelets{w};
        % Quantidade de Individuos
        for z=1:qtdpessoas
            % Quantidade de Faces por individuo
            for i=1:qtdif
                for pose=1:poses
                    % Carrega a imagem de Face
                    arquivo=strcat('p',...
                            int2str(z),'.',int2str(i),'.',int2str(pose),'.CorteNovo.jpg');
                    I=imread(arquivo);
                    % Realiza a decomposi��o Wavelet em niveldec niveis
                    for n=1:niveldec
                        if n==1
                            [CA,~,~,~]=dwt2(I,wavelet);
                            [m,a] = size(CA);
                            coef.CA{n} = reshape(CA, 1, m*a);
                        else
                            [CA,~,~,~]=dwt2(CA,wavelet);
                            [m,a] = size(CA);
                            coef.CA{n} = reshape(CA, 1, m*a);
                        end
                    end
                    
                    % Insere o vetor de caracteristicas na matriz C
                    C = [C; coef.CA{4}];
                end
            end
        end
        
        %Salva os coeficientes das subimagens
        cd ..;
        saida=strcat(wavelet,'_faces_nivel4.mat');
        save(saida,'C');
    end
end