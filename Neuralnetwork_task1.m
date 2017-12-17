filesEating= dir('PCAData/Eating');
filesNonEating = dir('PCAData/NonEating');
resultMatrix = zeros(33,3);
for k = 3:length(filesEating)
    %---------------Reading Files ----------------------%
    filenameEating = filesEating(k).name;
    filenameNonEating = filesNonEating(k).name;
    filenameEating = strcat('PCAData/Eating/',filenameEating );
    filenameNonEating = strcat('PCAData/NonEating/', filenameNonEating);
    EatingPCAFile = csvread(filenameEating);
    NonEatingPCAFile =  csvread(filenameNonEating);
    hiddenLayerSize = 12;
    net = patternnet(hiddenLayerSize);
    %-------------Separating Data in form of Testing and Training---------%
    net.divideParam.trainRatio = 40/100;
    net.divideParam.testRatio = 60/100;
    totaldata = [EatingPCAFile;NonEatingPCAFile];
    length(totaldata)
    target = [ones(length(EatingPCAFile),1);zeros(length(NonEatingPCAFile),1)];
    targets = horzcat(target,~target);
    [net,tr] = train(net,transpose(totaldata),transpose(targets));
    %view(net)
    output = net(transpose(totaldata));
    output = transpose(output);
    firstcolumn = output(:,1);
    consolidated = firstcolumn > 0.5;
    eatingPredictions = consolidated(1:length(EatingPCAFile),:);
    noneatingPrediction = consolidated(length(EatingPCAFile)+1:end,:);
    %-----------------Calculation---------------%
    TPmatrix = eatingPredictions(eatingPredictions == 1);
    FNmatrix = eatingPredictions(eatingPredictions == 0);
    FPmatrix = noneatingPrediction(noneatingPrediction == 1);
    TNmatrix = noneatingPrediction(noneatingPrediction == 0);
    precision = length(TPmatrix)/(length(TPmatrix) + length(FPmatrix));
    recall = length(TPmatrix)/(length(TPmatrix) + length(FNmatrix));
    f1 = (2 * precision * recall)/(precision+ recall);
    resultMatrix(k-2,1) = precision;
    resultMatrix(k-2,2) = recall;
    resultMatrix(k-2,3) = f1;
    %For AUC calculation
    x = vertcat(output(:,1),output(:,2));
    b = vertcat(ones(length(EatingPCAFile),1),zeros(length(NonEatingPCAFile),1));
    y = vertcat(b,~b);
    %--------------Result -------------%
    [X,Y,T,AUC] = perfcurve(y , x , '1');
    resultMatrix(k-2,4) = AUC;
    csvwrite('neuralnetwork.csv', resultMatrix);
    
end