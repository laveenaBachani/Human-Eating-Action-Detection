%{
This file is used to extract the Non Eating Time Series
%}
%clearing any previous data
clear
fclose('all')
%Opening summary which was given to us
fid = fopen('summary.csv','rt');
A = textscan(fid,'%d,%d,%d,%f,%f,%s', 'HeaderLines', 1);
csvDataForThisFile=strcat({''});
%Used for how many non eating actions collected so far
count = 1
for j=1:66
    % A lot of files are opened in the process so making sure
    % everything is closed 
    fclose('all');
    % These hashmaps help in which frame has which timestamp
    % associated with it
    frameMap = java.util.HashMap;
    EMGFrameData = java.util.HashMap;
    IMUFrameData = java.util.HashMap;
    % Frame rate used to get to know which frame has what time
    milliSecondPerFrame=1000/A{5}(j:j);
    videoFile = split(A{6}(j:j),".mp4");
    %IMU and EMG data
    annotationFile = strcat('./IMU/',videoFile(1),'_IMU.txt')
    annotationFile2 = strcat('./EMG/',videoFile(1),'_EMG.txt');
    %Annotation File Used
    mainAnnotationFile = strcat('./Annotation/',videoFile(1),'.txt');
    AnnotationFileId = fopen(mainAnnotationFile{1},'rt');
    annotationData = textscan(AnnotationFileId,'%d,%d,%d', 'HeaderLines', 1);
    %IMU Data, EMG DAta
    IMUFileData = csvread(annotationFile{1});
    EMGFileData = csvread(annotationFile2{1});
    %IMUFile len
    len = size(IMUFileData);
    len1 = size(EMGFileData);
    tempIMU = IMUFileData(len);
    tempEMG = EMGFileData(len1);
    IMUMax = tempIMU(1);
    EMGMax = tempEMG(1);
    endTime = max(IMUMax,EMGMax);
    for i = A{3}(j:j):-1:1
        frameMap.put(i,endTime);
        endTime = endTime - milliSecondPerFrame;
    end
    tempALen = size(annotationData{1});
    annotationLen = tempALen(1);
    startFrame = 1
    for I = 1:annotationLen+1
        if I ~= annotationLen+1
            endFrame = int64(frameMap.get(annotationData{1}(I:I)))-1;
        else
            endFrame = int64(max(IMUMax,EMGMax));
        end
        a = [];
        b = [];
        c = [];
        d = [];
        e = [];
        f = [];
        g = [];
        h = [];
        i = [];
        j = [];
        k = [];
        l = [];
        m = [];
        n = [];
        o = [];
        p = [];
        q = [];
        r = [];
        csvStringA = strcat({'NonEating Action '},{int2str(count)},{' A,'});
        csvStringB = strcat({'NonEating Action '},{int2str(count)},{' B,'});
        csvStringC = strcat({'NonEating Action '},{int2str(count)},{' C,'});
        csvStringD = strcat({'NonEating Action '},{int2str(count)},{' D,'});
        csvStringE = strcat({'NonEating Action '},{int2str(count)},{' E,'});
        csvStringF = strcat({'NonEating Action '},{int2str(count)},{' F,'});
        csvStringG = strcat({'NonEating Action '},{int2str(count)},{' G,'});
        csvStringH = strcat({'NonEating Action '},{int2str(count)},{' H,'});
        csvStringI = strcat({'NonEating Action '},{int2str(count)},{' I,'});
        csvStringJ = strcat({'NonEating Action '},{int2str(count)},{' J,'});
        csvStringK = strcat({'NonEating Action '},{int2str(count)},{' K,'});
        csvStringL = strcat({'NonEating Action '},{int2str(count)},{' L,'});
        csvStringM = strcat({'NonEating Action '},{int2str(count)},{' M,'});
        csvStringN = strcat({'NonEating Action '},{int2str(count)},{' N,'});
        csvStringO = strcat({'NonEating Action '},{int2str(count)},{' O,'});
        csvStringP = strcat({'NonEating Action '},{int2str(count)},{' P,'});
        csvStringQ = strcat({'NonEating Action '},{int2str(count)},{' Q,'});
        csvStringR = strcat({'NonEating Action '},{int2str(count)},{' R,'});
        count = count + 1;
        for iter = 1: len
            if startFrame <= int64(IMUFileData(iter,1)) && endFrame >= int64(IMUFileData(iter,1))
                a = [a,IMUFileData(iter,2)];
                b = [b,IMUFileData(iter,3)];
                c = [c,IMUFileData(iter,4)];
                d = [d,IMUFileData(iter,5)];
                e = [e,IMUFileData(iter,6)];
                f = [f,IMUFileData(iter,7)];
                g = [g,IMUFileData(iter,8)];
                h = [h,IMUFileData(iter,9)];
                i = [i,IMUFileData(iter,10)];
                j = [j,IMUFileData(iter,11)];
            end
        end
        for iter = 1: len1
            if startFrame <= int64(EMGFileData(iter,1)) && endFrame >= int64(EMGFileData(iter,1))
                k = [k,EMGFileData(iter,2)];
                l = [l,EMGFileData(iter,3)];
                m = [m,EMGFileData(iter,4)];
                n = [n,EMGFileData(iter,5)];
                o = [o,EMGFileData(iter,6)];
                p = [p,EMGFileData(iter,7)];
                q = [q,EMGFileData(iter,8)];
                r = [r,EMGFileData(iter,9)];
            end
        end
        for iter = 1:numel(a)
            csvStringA = strcat(csvStringA,{num2str(a(iter))},{','});
            csvStringB = strcat(csvStringB,{num2str(b(iter))},{','});
            csvStringC = strcat(csvStringC,{num2str(c(iter))},{','});
            csvStringD = strcat(csvStringD,{num2str(d(iter))},{','});
            csvStringE = strcat(csvStringE,{num2str(e(iter))},{','});
            csvStringF = strcat(csvStringF,{num2str(f(iter))},{','});
            csvStringG = strcat(csvStringG,{num2str(g(iter))},{','});
            csvStringH = strcat(csvStringH,{num2str(h(iter))},{','});
            csvStringI = strcat(csvStringI,{num2str(i(iter))},{','});
            csvStringJ = strcat(csvStringJ,{num2str(j(iter))},{','});
        end
        for iter = 1:numel(k)
            csvStringK = strcat(csvStringK,{num2str(k(iter))},{','});
            csvStringL = strcat(csvStringL,{num2str(l(iter))},{','});
            csvStringM = strcat(csvStringM,{num2str(m(iter))},{','});
            csvStringN = strcat(csvStringN,{num2str(n(iter))},{','});
            csvStringO = strcat(csvStringO,{num2str(o(iter))},{','});
            csvStringP = strcat(csvStringP,{num2str(p(iter))},{','});
            csvStringQ = strcat(csvStringQ,{num2str(q(iter))},{','});
            csvStringR = strcat(csvStringR,{num2str(r(iter))},{','});
        end
        csvDataForThisFile = strcat(csvDataForThisFile,csvStringA,{newline},csvStringB,{newline},csvStringC,{newline},csvStringD,{newline},csvStringE,{newline},csvStringF,{newline},csvStringG,{newline},csvStringH,{newline},csvStringI,{newline},csvStringJ,{newline},csvStringK,{newline},csvStringL,{newline},csvStringM,{newline},csvStringN,{newline},csvStringO,{newline},csvStringP,{newline},csvStringQ,{newline},csvStringR,{newline});
        if I ~= annotationLen+1
            startFrame = int64(frameMap.get(annotationData{2}(I:I)))+1;
        end
    end
    
    clear startFrame,endFrame,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r;
    clear csvStringA,csvStringB,csvStringC,csvStringD,csvStringE,csvStringF,csvStringG,csvStringH,csvStringI,csvStringJ,csvStringK,csvStringL,csvStringM,csvStringN,csvStringO;
    clear csvStringP,csvStringQ,csvStringR;
    disp('----------------------Ended-------------------------')
end
outputData = './FinalData/NonEating_OUT.csv'
fileID = fopen(outputData,'w');
fprintf(fileID,'%s',csvDataForThisFile{1});
fclose(fileID);
fclose('all')
