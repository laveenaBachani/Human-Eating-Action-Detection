filesEating= dir('PCAData/Eating');
filesNonEating = dir('PCAData/NonEating');
resultMatrix = zeros(33,3);
for k = 3:length(filesEating)
    %---------------Reading Files ----------------------%
    filenameEating = filesEating(k).name;
    filenameNonEating = filesNonEating(k).name;
    filenameEating = strcat('PCAData/Eating/',filenameEating );
    filenameNonEating = strcat('PCAData/NonEating/', filenameNonEating);
    %-------------Separating Data in form of Testing and Training---------%
    EatingPCAFile = csvread(filenameEating);
    NonEatingPCAFile =  csvread(filenameNonEating);
    traingDataEating = EatingPCAFile(1:ceil(0.6 * length(EatingPCAFile)),:);
    traingDataNonEating = NonEatingPCAFile(1:ceil(0.6 * length(NonEatingPCAFile)),:);
    totalTrainingData = [traingDataEating;traingDataNonEating];
    testingDataEating = EatingPCAFile(ceil(0.6 * length(EatingPCAFile)):end,:);
    testingDataNonEating = NonEatingPCAFile(ceil(0.6 * length(NonEatingPCAFile)):end,:);
    totalTestingData = [testingDataEating;testingDataNonEating];
    response = zeros(length(totalTrainingData),1);
    response(1:length(traingDataEating),1) = 1;
    svm = fitcsvm(totalTrainingData,response,'Standardize',true);
    [predictions,score] = predict(svm,totalTestingData);
    scores = vertcat(score(:,1),score(:,2));
    b = vertcat(zeros(length(testingDataEating),1),ones(length(testingDataNonEating),1));
    y = vertcat(b,~b);
    eatingPredictions = predictions(1:length(testingDataEating),:);
    noneatingPrediction = predictions(length(testingDataEating)+1:end,:);
    %-----------------Calculation---------------%
    TPmatrix = eatingPredictions(eatingPredictions == 1);
    FNmatrix = eatingPredictions(eatingPredictions == 0);
    FPmatrix = noneatingPrediction(noneatingPrediction == 1);
    TNmatrix = noneatingPrediction(noneatingPrediction == 0);
    precision = length(TPmatrix)/(length(TPmatrix) + length(FPmatrix));
    recall = length(TPmatrix)/(length(TPmatrix) + length(FNmatrix));
    f1 = (2 * precision * recall)/(precision+ recall);
    [X,Y,T,AUC] = perfcurve(y,scores, '1');
    %--------------Result -------------%
    resultMatrix(k-2,1) = precision;
    resultMatrix(k-2,2) = recall;
    resultMatrix(k-2,3) = f1;
    resultMatrix(k-2,4) = AUC;
    csvwrite('svmwrit.csv', resultMatrix);
end