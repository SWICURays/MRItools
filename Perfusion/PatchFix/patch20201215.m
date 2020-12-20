function patch20201215()

%patch to recalculate CBV

%Select folder with GUI
dataDir = uigetdir();

%Create path to only list .mat files
path = [dataDir '/*.mat'];

%Get the filelist
fileList = dir(path);


for fileIter = 1:length(fileList)

    %Read the examination
    volIn = load([fileList(fileIter).folder, '/' fileList(fileIter).name]);

    %Initiate object
    obj = T1perfusion(volIn.vol, volIn.mask, volIn.props, volIn.stats);
    
    obj.setTruncateVol(1, 60);
    obj.saveData;
    
end

end