
OUTPUT_FOLDER='D:/VGG_FACE_DATASET/';

subjects = dir(fullfile('files','*.txt'));


startSubj=1;


for i=startSubj:numel(subjects)
    
    [~,subjName,~] = fileparts(subjects(i).name);
    mkdir(fullfile(OUTPUT_FOLDER,subjName))

    auxC = importfile(['files\' subjName '.txt']); %% subject images
    
    %% SUBJECT LOOP (SHOULD BE RUN ON 16 WORKERS IN PARALLEL)
    parfor j=1:size(auxC,1)
        
        
        if((i==806 && j==665+1) || (i==821 && j==815) || ...
           (i==1053 && j==550) || (i==1594 && j==593) || ...
           (i==1811 && j==767) || (i==1811 && j==972) || ...
           (i==2448 && j==515) || (i==1594 && j==180) || ...
           (i==1930 && j==875))
            continue;
        end
        
        url=auxC{j,2};
        filename=sprintf('%s%s/%s_%04d.jpg',...
            OUTPUT_FOLDER,subjName,subjName,j);
        try
            outfilename = websave(filename,url);
            [~,~,ext] = fileparts(outfilename)
            if(strcmp(ext,'.html'))
                delete(outfilename)
            end
        catch
            
            if(exist(filename,'file'))
                delete(filename);
            else
                try
                    delete([filename '.html']);
                catch
                end
            end
        end
        
    end
    
    
end