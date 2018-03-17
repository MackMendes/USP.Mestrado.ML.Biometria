#Instruções para execução

1° passo - Carregar o dataset desejado no Matlab: load db2_faces;
	
	Para que o primeiro passo aconteça, o diretório do Matlab deve estar apontando
	na pasta do dataset, assim, pode ser carregado o dataset dando duplo clique no 
	nome do dataset em current folder.

2° passo - Rodar o RunCrossValidation.
	
	Este arquivo encontra-se na pasta src/. Para executá-lo deve-se 
	escrever no command window: RunCrossValidation(n, X, S, folds, algor)
		n : Quantidade de execuções do CrossValidation
		X e S : São as matrizes de entrada e saída.
		folds : quantidade de folds desejada
		algor : algoritmo desejado ('rna','svm' e 'knn').
	Após a execução deste arquivo, haverá a criação automática de um arquivo .mat
	no diretório do arquivo, este arquivo criado é uma struct que conterá informações,
	sendo a mais importante o vetor de acurácia, que conterá as 'n' acurácias da execução
	do algoritmo no CrossValidation.

3° passo - RunHoldout
	
	Este arquivo encontra-se na pasta src/. Colocar no command window: RunHoldout(n, X, S, split, algor) 
		split : dividir o dataset. Por exemplo:  2/3 para treinamento e 1/3 para teste.
	Dentro deste arquivo pode ser realizado alterações no parâmetro do algoritmo desejado.
	Após a excecução será criado os subsets: train, label, test, output.

4° passo - Rodar o CrossValidation
	
	Para rodar este arquivo, basta escrever no command window: 
	avg = CrossValidation(X, S, folds, algor)
	onde avg guardará a média da acurácia realizada pelo algoritmo.
		X e S : São as matrizes de entrada e saída.
		folds : quantidade de folds desejada
		algor : algoritmo desejado ('rna','svm' e 'knn').
	Dentro do CrossValidation, na parte abaixo do comentário de definição de parâmetros,
	pode ser feito alterações nos parâmetros do algoritmo desejado. 

5° passo - Rodar o Holdout uma única vez
	
	Colocar no command window:    [train, label, test, output] = Holdout(X, S, split)
		split : sendo a divisão do dataset desejado. Por exemplo: 2/3 
	Após a realização, serão criados 4 subsets, train, label, test e output, podendo assim ser 
	utilizados nos algoritmos isolados.


-------------------------------------------------------------------------------------------
#Rodar algoritmos isolados

Depois de realizar o Holdout ou qualquer outro procedimento para divisão do dataset em subsets.


1° algoritmo: SVM

	command window: [F, A, B, Y] = OnevsOne(train, test, output, ker, C, param);
		train : é o subset de treinamento 
		test :  é o subset de teste
		output : é o subset das saídas de testes desejada
		ker : é o kernel desejado para a execução ('linear' ou 'poly' ou 'rbf')
		C : é o Trade-off entre a margem de separação e o erro mínimo esperado (2000)
		param : parâmetro de entrada para passar a ordem do polinomial ou o sigma do rbf
 	

2° algoritmo: RNA

	command window: [A, B, errotr, Y] = NeuralNetwork(train, label, h, epocasMax)
		X : é o subset de treinamento (train)
		S : é o subset de saída desejada (label)
		h : é o número de neurônios desejados 
		epocasMax : é o máximo de épocas desejada
	Após a realização do treinamento, utilizar o arquivo Y = perceptrons(test, A, B) no command
	window.


3° k-NN

	command window: acuracia = knn(train, label, test, target, k)
		train : é o subset de treinamento
		label: é o subset de saída desejada
		test : é o subset de teste
		target : é a saída desejada para os dados de teste
		k : número de vizinhos próximos desejado
		
--------------------------		 
Desenvolvido por Andrei Martins, Charles Mendes, Fernando Costa e William Conceição.
