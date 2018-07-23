function [] = write_file()
fileID = fopen('accu.csv','w');
load('taccu.mat');
formatSpec = '%4.2f ';

[nrows,ncols]= size(taccu);
for row=1:nrows
    for col=1:length(taccu{row})
        fprintf(fileID, '%4.2f,', taccu{row}(col));
    end
    fprintf(fileID, '\n');
end
fclose(fileID);
end

