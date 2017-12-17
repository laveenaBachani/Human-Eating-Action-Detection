%{
 We are going to train and visualize neural network
 for 10 users and then will test with the training 
 data
%}
% Opening summary.csv as it has all the file names we
% want to use in this example
fid = fopen('./group_id_mapping.csv','rt');
A = textscan(fid,'%s', 'HeaderLines', 1);
mainTrainingEat = [];
mainTrainingNonEat = [];
resultMatrix = zeros(23,3);
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

%neural network
hiddenLayerSize = 12;
net = patternnet(hiddenLayerSize);
% Set up Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 30/100;
net.divideParam.testRatio = 70/100;

% Train the Network
targetData = zeros(length(mainTraining),2);
for i=1:length(mainTraining)
    if i<=length(mainTraining)/2
        targetData(i,1) = 1;
    else
        targetData(i,2) = 1;
    end
end

[net,tr] = train(net,transpose(mainTraining),transpose(targetData));
index = 0;
for file_number=21:2:66

% The two videofiles of the user
   videoFile1 = split(A{1}{file_number},',');
   videoFile1 = videoFile1{3};
   videoFile2 = split(A{1}{file_number+1},',');
   videoFile2 = videoFile2{3};
   
   % This is where the pca data will be read
   readPCAEating = strcat('./PCAData/Eating/',videoFile1,'_',videoFile2,'.csv');
   readPCANonEating = strcat('./PCAData/NonEating/',videoFile1,'_',videoFile2,'.csv');
   EatingPCAFile = csvread(readPCAEating);
   NonEatingPCAFile =  csvread(readPCANonEating);
   totaldata = [EatingPCAFile;NonEatingPCAFile];
    output = net(transpose(totaldata));
    output = transpose(output);
    firstcolumn = output(:,1);
    consolidated = firstcolumn > 0.5;
    eatingPredictions = consolidated(1:length(EatingPCAFile),:);
    noneatingPrediction = consolidated(length(EatingPCAFile)+1:end,:);
    TPmatrix = eatingPredictions(eatingPredictions == 1);
    FNmatrix = eatingPredictions(eatingPredictions == 0);
    FPmatrix = noneatingPrediction(noneatingPrediction == 1);
    TNmatrix = noneatingPrediction(noneatingPrediction == 0);
    precision = length(TPmatrix)/(length(TPmatrix) + length(FPmatrix));
    recall = length(TPmatrix)/(length(TPmatrix) + length(FNmatrix));
    f1 = (2 * precision * recall)/(precision+ recall);
    resultMatrix(index+2,1) = precision;
    resultMatrix(index+2,2) = recall;
    resultMatrix(index+2,3) = f1;
    x = vertcat(output(:,1),output(:,2));
    b = vertcat(ones(length(EatingPCAFile),1),zeros(length(NonEatingPCAFile),1));
    y = vertcat(b,~b);
    [X,Y,T,AUC] = perfcurve(y , x , '1');
    resultMatrix(index+2,4) = AUC;
    csvwrite('neuralnetwork10Users.csv', resultMatrix);
    index = index+1;
end