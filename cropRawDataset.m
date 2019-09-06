
DATASET_FOLDER='D:/VGG_FACE_DATASET/';
OUTPUT_FOLDER='D:/vggface_crop/';
mkdir(OUTPUT_FOLDER)

subjects = dir(fullfile('files','*.txt'));

% params

startSubj = 1;
keeponlycurated = 1;
cropsize = [512 512];

% main loop 

for i=startSubj:numel(subjects)
    
    [~,subjName,~] = fileparts(subjects(i).name);
    mkdir(fullfile(OUTPUT_FOLDER,subjName))

    auxC = importfile(['files\' subjName '.txt']); %% subject images
    
    parfor j = 1:size(auxC,1)
        
        filename = sprintf('%s%s/%s_%03d.jpg',...
            DATASET_FOLDER,subjName,subjName,j);
        
        bb = cat(2,auxC{j,3:6});
        curated = auxC{j,end};
        bb = [bb(1:2) bb(3:4)-bb(1:2)];
        
        % this condition ensures that non curated photos will not be cropped
        if(keeponlycurated==1 && curated==0)
            continue;
        end
        
        if(exist(filename,'file'))
            
            try
                im = imread(filename);

                if(bb(3)/bb(4)~=1)
                    bb = adjust_ar(bb,1,1);
                end

                imc = imcrop(im,bb);
                if(~isempty(cropsize))
                    imc = imresize(imc,cropsize);
                end
                imwrite(imc,fullfile(OUTPUT_FOLDER,subjName,sprintf('%04d.jpg',j)));
            catch
                display(sprintf('%s is invalid',filename));
            end
            
        end
    end
    
end    