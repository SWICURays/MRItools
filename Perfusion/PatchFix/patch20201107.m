function patch20201107()

%%Patch to fix redudant fields in stats. Goes through datadir and deletes
% legacy fields in stats.
% Implemented 20201107.

%%

%Create a waitbar
f = waitbar(0, 'Patching ...');

%Select folder with GUI
dataDir = uigetdir();

%Create path to only list .mat files
path = [dataDir '/*.mat'];

%Get the filelist
fileList = dir(path);

for fileIter = 1:length(fileList)

    %Read the examination
    volIn = load([fileList(fileIter).folder, '/' fileList(fileIter).name]);

    vol = volIn.vol;
    stats = volIn.stats;
    props = volIn.props;
    mask = volIn.mask;
    stats = rmfield(stats, 'lungVolWithoutVessel');
    stats = rmfield(stats, 'functionalRatio');
    
    save([dataDir filesep props.patientId '.mat'], 'vol', 'mask', 'props', 'stats');
   
    waitbar(fileIter/length(fileList), f);
    
end
    
close(f)

end
    

    