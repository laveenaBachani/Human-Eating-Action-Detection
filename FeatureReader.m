f = fopen('./FinalData/Eating_OUT.csv');             
g = textscan(f,'%s','',0,'delimiter','\n');
g = g{1};
fclose(f);
f = fopen('./FinalData/NonEating_OUT.csv');
gNonEating = textscan(f,'%s','',0,'delimiter','\n');
gNonEating = gNonEating{1};
fclose(f);
eatingMatrix = zeros(int64(numel(gNonEating)/18)+2, 90);
nonEatingMatrix = zeros(int64(numel(gNonEating)/18)+2, 90);
disp(int64(numel(gNonEating)/18)+2);
for i = 1: numel(g)
    row = int64(floor(i/18)) + 1;
    column  = int64((mod(i,18))) + 1;
    str = g(i+1);
    str = strsplit(str{1},',');
    len = numel(str);
    str = str(1:1,2:len-1);
    len = numel(str);
    str = arrayfun(@(x) str2double(x),str);
    disp('----------------')
    disp(row);
    disp(column);
    numel(str);
    disp('-----------------------')
    if(numel(str)==0)
        eatingMatrix(row+1,column) = NaN;
        eatingMatrix(row+1,column+18) = NaN;
        eatingMatrix(row+1,column+36) = NaN;
        eatingMatrix(row+1,column+54) = NaN;
        eatingMatrix(row+1,column+72) = NaN;
    else
        fftMax = abs(max(fft(str,1024)));
        eatingMatrix(row+1,column) = max(arrayfun(@(x) abs(x),str));
        eatingMatrix(row+1,column+18) = fftMax;
        eatingMatrix(row+1,column+36) = var(str);
        eatingMatrix(row+1,column+54) = rms(str);
        eatingMatrix(row+1,column+72) = sum(arrayfun(@(x) abs(x),str(1:min(numel(str),30))));
    end
    %Non Eating%
    str = gNonEating(i+1);
    str = strsplit(str{1},',');
    len = numel(str);
    str = str(1:1,2:len-1);
    len = numel(str);
    str = arrayfun(@(x) str2double(x),str);
        if(numel(str)==0)
            nonEatingMatrix(row,column) = NaN;
            nonEatingMatrix(row,column + 18) = NaN;
            nonEatingMatrix(row,column + 36) = NaN;
            nonEatingMatrix(row,column + 54) = NaN;
            nonEatingMatrix(row,column + 72) = NaN;
        else
            fftMax = abs(max(fft(str,1024)));
            nonEatingMatrix(row,column) = max(arrayfun(@(x) abs(x),str));
            nonEatingMatrix(row,column + 18) = fftMax;
            nonEatingMatrix(row,column + 36) = var(str);
            nonEatingMatrix(row,column + 54) = rms(str);
            nonEatingMatrix(row,column + 72) = sum(arrayfun(@(x) abs(x),str(1:min(numel(str),30))));
        end
end
clf;
hold all;
coeffNonEating = mtimes(nonEatingMatrix(1:int64(numel(gNonEating)/18)+1,1:90), pca(nonEatingMatrix(1:int64(numel(gNonEating)/18)+1,1:90),'Algorithm','eig','NumComponents',3));
coeffEating = mtimes(eatingMatrix(1:int64(numel(gNonEating)/18)+1,1:90),pca(eatingMatrix(1:int64(numel(gNonEating)/18)+1,1:90),'Algorithm','eig','NumComponents',3));
for j = 1:3 
    clf
    for k = 1:numel(g)/18
        hold all
        scatter(k,coeffNonEating(k,j),'MarkerEdgeColor','red')
        scatter(k,coeffEating(k,j),'MarkerEdgeColor','green')
        pause(0.1);
    end
end
%{
Uncomment this for scatter plot
for k = 1:2000
        hold all
        scatter(coeffNonEating(k,1),coeffNonEating(k,2),'MarkerEdgeColor','red')
        scatter(coeffEating(k,1),coeffEating(k,2),'MarkerEdgeColor','green')
        legend('Non Eating','Eating')
        pause(0.1);
end
}%
