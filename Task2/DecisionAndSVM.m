%{
 We are going to train and visualize decision tree and
 kernel based SVM for 10 users and then will test with 
 the training data
%}
% Opening summary.csv as it has all the file names we
% want to use in this example
fid = fopen('./group_id_mapping.csv','rt');
A = textscan(fid,'%s', 'HeaderLines', 1);
mainTrainingEat = [];
mainTrainingNonEat = [];
% Now we are going to loop over every file. 
% This is the training part
for file_number = 1:2:20
    disp('------------------Start----------------------')
    disp(file_number)
    % Closing all previous opened file to increase the
    % Processing Speed
    fclose('all');
    
    % The two videofiles of the user
    videoFile1 = split(A{1}{file_number},',');
    videoFile1 = videoFile1{3};
    videoFile2 = split(A{1}{file_number+1},',');
    videoFile2 = videoFile2{3};
    
    % This is where the pca data will be read
    readPCAEating = strcat('./PCAData/Eating/',videoFile1,'_',videoFile2,'.csv');
    readPCANonEating = strcat('./PCAData/NonEating/',videoFile1,'_',videoFile2,'.csv');
    
    % Eating Training Data Consolidation
    trainingEat = csvread(readPCAEating);
    trainingEat = trainingEat(1:length(trainingEat)-2,:);
    mainTrainingEat = [mainTrainingEat;trainingEat];
    
    % Non-Eating Training Data Consolidation
    trainingNonEat = csvread(readPCANonEating);
    trainingNonEat = trainingNonEat(1:length(trainingNonEat)-2,:);
    mainTrainingNonEat = [mainTrainingNonEat;trainingNonEat];
    disp('-------------------End-----------------------')
end

%Collecting the data which will be used for training the 
%Classifiers
classFicationOne = ones(length(mainTrainingEat),1);
classficationZero = zeros(length(mainTrainingNonEat),1);
mainClassification = [classFicationOne;classficationZero];
mainTraining = [mainTrainingEat;mainTrainingNonEat];

%decision tree predictor
decisionTreePredictor = fitctree(mainTraining,mainClassification);
%svm predictor
svmPredictor = fitcsvm(mainTraining,mainClassification,'Standardize',true);

% This is the Testing Data. We will conslidate this with 
% in one variable
mainTestingData = [];
mainTestingClassification = [];
decisionTreePrecictedData = [];
resultMatrixTree = zeros(23,4);
resultMatrixSVM = zeros(23,4);
count = 1;
for file_number=21:2:66
   disp('------------------Start----------------------')
   disp(file_number) 
   % Closing all previous opened file to increase the
   % Processing Speed
   fclose('all');
   
   % The two videofiles of the user
   videoFile1 = split(A{1}{file_number},',');
   videoFile1 = videoFile1{3};
   videoFile2 = split(A{1}{file_number+1},',');
   videoFile2 = videoFile2{3};
   
   % This is where the pca data will be read
   readPCAEating = strcat('./PCAData/Eating/',videoFile1,'_',videoFile2,'.csv');
   readPCANonEating = strcat('./PCAData/NonEating/',videoFile1,'_',videoFile2,'.csv');
   
   % Eating Training Data Consolidation
   testingEat = csvread(readPCAEating);
   testingEat = testingEat(1:length(testingEat)-2,:);
  
   % Non-Eating Training Data Consolidation
   testingNonEat = csvread(readPCANonEating);
   testingNonEat = testingNonEat(1:length(testingNonEat)-2,:);
   mainTestingData = [mainTestingData;testingEat;testingNonEat];
   mainTestingClassification = [mainTestingClassification;ones(length(testingEat),1);zeros(length(testingNonEat),1)];
   [decisionTreePrecictedData,score,some,some1] = predict(decisionTreePredictor,mainTestingData);
   x = vertcat(score(:,2),score(:,1));
   
   % Calculate Precision, recall, F1 and AUC for decision tree
   [c,cm,ind,per] = confusion(transpose(mainTestingClassification),transpose(decisionTreePrecictedData));
   resultMatrixTree(count,1) = cm(2,2)/(cm(2,2)+cm(2,1)); 
   resultMatrixTree(count,2) = cm(2,2)/(cm(2,2)+cm(1,2));
   resultMatrixTree(count,3) =  2*cm(2,2)/(2*cm(2,2)+cm(2,1)+cm(1,2));
   b = vertcat(ones(length(testingEat),1),zeros(length(testingNonEat),1));
   y = vertcat(b,~b);
   [X,Y,T,AUC] = perfcurve( y, x , '1');
   resultMatrixTree(count,4) = AUC;
   [svmPrecictedData,score] = predict(svmPredictor,mainTestingData);
   x = vertcat(score(:,2),score(:,1));
   
   % Calculate Precision, recall, F1 and AUC for SVM
   [c,cm,ind,per] = confusion(transpose(mainTestingClassification),transpose(svmPrecictedData));
   resultMatrixSVM(count,1) = cm(2,2)/(cm(2,2)+cm(2,1));
   resultMatrixSVM(count,2) = cm(2,2)/(cm(2,2)+cm(1,2));
   resultMatrixSVM(count,3) = 2*cm(2,2)/(2*cm(2,2)+cm(2,1)+cm(1,2));
   b = vertcat(ones(length(testingEat),1),zeros(length(testingNonEat),1));
   y = vertcat(b,~b);
   [X,Y,T,AUC] = perfcurve( y, x , '1');
   resultMatrixSVM(count,4) = AUC;
   mainTestingData = [];
   mainTestingClassification = [];
   count = count +1;
   
   csvwrite('decisionTree10Users.csv', resultMatrixTree);
   csvwrite('svm10Users.csv', resultMatrixSVM);
   disp('-------------------End-----------------------')
end