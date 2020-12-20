function [stats, ttp] = batchProcessCOVIDSwineManuscript()

    %Descriptive and statistical analysis of MRI lung perfusion in swine Used
    %in Rysz et al.
    %
    %Code: Johan Lundberg, j.lundberg(at)ki.se

    %Read the Datadir
    [stats, ttp] = readDir();

    %STATISTICAL TESTING AND DESCRIPTIVE ANALYSIS

    %Functional Ratio testing
    normal = stats.table.FunctionalRatio(stats.table.GroupID == 0);
    MLN = stats.table.FunctionalRatio(stats.table.GroupID == 1);
    treatment = stats.table.FunctionalRatio(stats.table.GroupID == 2);

    fprintf('\n \nDESCRIPTIVE STATISTICS: \n \n');
    fprintf(['Mean Functionally perfused Lung of Normal:        ' num2str(1 - mean(normal)) '\n']);
    fprintf(['STD Functionally perfused Lung of Normal:         ' num2str(std(normal)) '\n']);
    fprintf(['Mean Functionally perfused Lung of MLN:           ' num2str(1 - mean(MLN)) '\n']);
    fprintf(['STD Functionally perfused Lung of MLN:            ' num2str(std(MLN)) '\n']);
    fprintf(['Mean Functionally perfused Lung of Treatment:     ' num2str(1 - mean(treatment)) '\n']);
    fprintf(['STD Functionally perfused Lung of Treatment:      ' num2str(std(treatment)) '\n\n']);

    %Arrange data for n-way ANOVA
    data = [normal; MLN; treatment];
    grouping = [ones(1, length(normal)), 2.*ones(1, length(MLN)), 3.*ones(1, length(treatment))];
    [p, ~, anovaStats] = anovan(data, grouping', 'display', 'off');
    [c, m, h] = multcompare(anovaStats, 'CType', 'dunn-sidak');
    close(h);

    fprintf('Results of unbalanced ANOVA Functionally perfused Lung:\n')
    fprintf(['p= ' num2str(p) '\n\n']);
    fprintf('Results from multiple comparison (post hoc Dunn-Sidak):\n');
    array2table(c, 'VariableNames', {'Group to Compare', 'Group compared to', '.95 CI low', 'Estimated Mean', '.95 CI high', 'p-value'})

    %Mean value of TTP map
    normalTTPmean = stats.table.ttpMean(stats.table.GroupID == 0);
    MLNttpmean = stats.table.ttpMean(stats.table.GroupID == 1);
    treatmenTTPtMean = stats.table.ttpMean(stats.table.GroupID == 2);

    fprintf('\n \nDESCRIPTIVE STATISTICS: \n \n');
    fprintf(['Mean TTP value of entire Lung, Normal:        ' num2str(mean(normalTTPmean)) '\n']);
    fprintf(['STD TTP value of entire Lung, Normal:         ' num2str(std(normalTTPmean)) '\n']);
    fprintf(['Mean TTP value of entire Lung, MLN:           ' num2str(mean(MLNttpmean)) '\n']);
    fprintf(['STD TTP value of entire Lung, MLN:            ' num2str(std(MLNttpmean)) '\n']);
    fprintf(['Mean TTP value of entire Lung, Treatment:     ' num2str(mean(treatmenTTPtMean)) '\n']);
    fprintf(['STD TTP value of entire Lung, Treatment:      ' num2str(std(treatmenTTPtMean)) '\n\n']);


    %Arrange data for n-way ANOVA
    data = [normalTTPmean; MLNttpmean; treatmenTTPtMean];
    grouping = [ones(1, length(normal)), 2.*ones(1, length(MLN)), 3.*ones(1, length(treatment))];
    [p, ~, anovaStats] = anovan(data, grouping', 'display', 'off');
    [c, m, h] = multcompare(anovaStats, 'CType', 'dunn-sidak');
    close(h);

    fprintf('Results of unbalanced ANOVA TTP mean for entire lung:\n')
    fprintf(['p= ' num2str(p) '\n\n']);
    fprintf('Results from multiple comparison (post hoc Dunn-Sidak):\n');
    array2table(c, 'VariableNames', {'Group to Compare', 'Group compared to', '.95 CI low', 'Estimated Mean', '.95 CI high', 'p-value'})

    %Contrast enhacement
    
    normalMRE = stats.table.ceFraction(stats.table.GroupID == 0);
    MLNMRE = stats.table.ceFraction(stats.table.GroupID == 1);
    treatmentMRE = stats.table.ceFraction(stats.table.GroupID == 2);
    
    fprintf('\n \nDESCRIPTIVE STATISTICS: \n \n');
    fprintf(['Mean CE fraction, Normal:                    ' num2str(mean(normalMRE)) '\n']);
    fprintf(['STD CE fraction, Normal:                     ' num2str(std(normalMRE)) '\n']);
    fprintf(['Mean CE fraction, MLN:                       ' num2str(mean(MLNMRE)) '\n']);
    fprintf(['STD CE fraction, MLN:                        ' num2str(std(MLNMRE)) '\n']);
    fprintf(['Mean CE fraction, Treatment:                 ' num2str(mean(treatmentMRE)) '\n']);
    fprintf(['STD CE fraction, Treatment:                  ' num2str(std(treatmentMRE)) '\n\n']);

    %Arrange data for n-way ANOVA
    data = [normalMRE; MLNMRE; treatmentMRE];
    grouping = [ones(1, length(normal)), 2.*ones(1, length(MLN)), 3.*ones(1, length(treatment))];
    [p, ~, anovaStats] = anovan(data, grouping', 'display', 'off');
    [c, m, h] = multcompare(anovaStats, 'CType', 'dunn-sidak');
    close(h);

    fprintf('Results of unbalanced ANOVA MRE fraction:\n')
    fprintf(['p= ' num2str(p) '\n\n']);
    fprintf('Results from multiple comparison (post hoc Dunn-Sidak):\n');
    array2table(c, 'VariableNames', {'Group to Compare', 'Group compared to', '.95 CI low', 'Estimated Mean', '.95 CI high', 'p-value'})

    
    
    %PLOT THE DATA
    %Find and sort the groups
    %0 = normal, 1 = MLN + low dose, 2=MLN + treatment

    ttpNormal = ttp(stats.table.GroupID == 0, :);
    ttpMLN = ttp(stats.table.GroupID == 1,:);
    ttpTreatment = ttp(stats.table.GroupID == 2,:);

    %Define vectors
    vqMLN = [];
    vqNorm = [];
    vqTreatment = [];
    xVal = 0:0.01:3;
    xVal = xVal';

    %Prepare data for plotting, MLN group
    for i = 1:size(ttpMLN, 1)
        %Set origio
        ttpMLN{i, 1} = [0 ttpMLN{i, 1}];
        ttpMLN{i, 2} = [0 ttpMLN{i, 2}];
        %Get an interpolated vector for plotting
        vqMLN(:, i) = interp1(ttpMLN{i,2}, ttpMLN{i,1}, xVal, 'makima');
        %Normalize the vector
        vqMLN(:, i) = vqMLN(:, i) ./ max(vqMLN(:,i));
    end

    %Prepare data for plotting Normal group, same steps
    for i = 1:size(ttpNormal, 1)
        ttpNormal{i, 1} = [0 ttpNormal{i, 1}];
        ttpNormal{i, 2} = [0 ttpNormal{i, 2}];
        vqNorm(:, i) = interp1(ttpNormal{i,2}, ttpNormal{i,1}, xVal, 'makima');
        vqNorm(:, i) = vqNorm(:, i) ./ max(vqNorm(:,i));
    end

    %Prepare data for plotting Treatment group, same steps
    for i = 1:size(ttpTreatment, 1)
        ttpTreatment{i, 1} = [0 ttpTreatment{i, 1}];
        ttpTreatment{i, 2} = [0 ttpTreatment{i, 2}];
        vqTreatment(:, i) = interp1(ttpTreatment{i,2}, ttpTreatment{i,1}, xVal, 'makima');
        vqTreatment(:, i) = vqTreatment(:, i) ./ max(vqTreatment(:,i));
    end


    %Calculate the normalized mean of groups
    meanMLN = mean(vqMLN, 2) ./ max(mean(vqMLN, 2));
    stdMLN = std(vqMLN, [], 2);
    meanNorm = mean(vqNorm, 2) ./ max(mean(vqNorm, 2));
    stdNorm = std(vqNorm, [], 2);
    meanTreatment = mean(vqTreatment, 2) ./ max(mean(vqTreatment, 2));
    stdTreatment = std(vqTreatment, [], 2);

    %Define the colours
    colorMLN = [144 53 59]/255;
    colorNormal = [26 71 111]/255;
    colorTreatment = [85 117 47]/255;
    colorAortaPeak = [0 0 0];

    %Create the figure
    propsMLNindividual = {'Color', colorMLN, 'LineStyle', '-'};
    propsNormalInvdividual = {'Color', colorNormal, 'LineStyle', '-'};
    propsTreatmentIndividual = {'Color', colorTreatment, 'LineStyle', '-'};
    propsMLNmean = {'Color', colorMLN, 'LineWidth', 3, 'LineStyle', '-'};
    propsNormalMean = {'Color', colorNormal, 'LineWidth', 3, 'LineStyle', '-'};
    propsTreatmentMean = {'Color', colorTreatment, 'LineWidth', 3, 'LineStyle', '-'};

    f = figure;
    set(gcf,'Position',[-1800 400 1400 800]);
    largeA = axes(f, 'Position', [0.05, 0.1, 0.65, 0.85]);
    hold on;
    %Plot the MLN group
    for i = 1:size(vqMLN, 2)
        hMLNind = plot(largeA, xVal, vqMLN(:, i), propsMLNindividual{:});
    end
    %Plot the control group
    for i = 1:size(vqNorm, 2)
        hControlind = plot(largeA, xVal, vqNorm(:, i), propsNormalInvdividual{:});
    end
    %Plot the treatment group
    for i = 1:size(vqTreatment, 2)
        hTreatmentind = plot(largeA, xVal, vqTreatment(:, i), propsTreatmentIndividual{:});
    end

    %Plot the mean
    hMeanMLN = plot(largeA, xVal, meanMLN, propsMLNmean{:});
    hMeanNorm = plot(largeA, xVal, meanNorm, propsNormalMean{:});
    hMeanTreatment = plot(largeA, xVal, meanTreatment, propsTreatmentMean{:});
    %Plot the aorta bar
    hAorta = plot(largeA, [1 1], [0 1], 'Color', colorAortaPeak, 'LineWidth', 3);

    %Set the axis
    xlim([0 2]);
    ylim([0 1.1]);

    %Annotate
    %title('Distribution of voxels in Time To Peak parametric maps');
    title('a.');
    xlabel('Normalized time scale, 0 for Peak in Pulmonary Artery, 1 for peak in Aorta');
    ylabel('Normalized distribution');
    legend( [hMLNind hControlind hTreatmentind hMeanMLN hMeanNorm hMeanTreatment hAorta], ...
            'Model individual',...
            'Control individual',...
            'Treatment invididuval',...
            'Normalized mean of model group', ...
            'Normalized mean of control group', ...
            'Normalized mean of treatment group', ...
            'Aortic Peak' ...
            );

    set(gca,'FontSize',17);
    hold off

    %Define colors etc.
    propsPlotNormal = {'Color', colorNormal, 'LineWidth', 2};
    propsPlotMLN = {'Color', colorMLN, 'LineWidth', 3, 'LineWidth', 2};
    propsPlotTreatment = {'Color', colorTreatment, 'LineWidth', 3, 'LineWidth', 2};

    %Create scatterplot 1
    smallA1 = axes(f, 'Position', [0.75 0.1, 0.2, 0.35]);
    hold on
    %Plot normal
    scatter(smallA1, ones(size(normalTTPmean, 1), 1), normalTTPmean, 100, 'MarkerEdgeColor', colorNormal, 'MarkerFaceColor', colorNormal);
    %Plot mean and whiskers
    plot(smallA1, [0.8 1.2], [mean(normalTTPmean) mean(normalTTPmean)], propsPlotNormal{:});
    plot(smallA1, [1 1], [mean(normalTTPmean - std(normalTTPmean)) mean(normalTTPmean) + std(normalTTPmean)], propsPlotNormal{:});
    plot(smallA1, [0.9 1.1], [mean(normalTTPmean + std(normalTTPmean)) mean(normalTTPmean) + std(normalTTPmean)], propsPlotNormal{:});
    plot(smallA1, [0.9 1.1], [mean(normalTTPmean - std(normalTTPmean)) mean(normalTTPmean) - std(normalTTPmean)], propsPlotNormal{:});
    plot(smallA1, [0.8 1.2], [mean(normalTTPmean) mean(normalTTPmean)], propsPlotNormal{:})

    %Plot MLN
    scatter(smallA1, 2*ones(size(MLNttpmean, 1), 1), MLNttpmean, 100, 'MarkerEdgeColor', colorMLN, 'MarkerFaceColor', colorMLN);
    %Plot mean and whiskers
    plot(smallA1, [1.8 2.2], [mean(MLNttpmean) mean(MLNttpmean)], propsPlotMLN{:})
    plot(smallA1, [2 2], [mean(MLNttpmean - std(MLNttpmean)) mean(MLNttpmean) + std(MLNttpmean)], propsPlotMLN{:})
    plot(smallA1, [1.9 2.1], [mean(MLNttpmean + std(MLNttpmean)) mean(MLNttpmean) + std(MLNttpmean)], propsPlotMLN{:})
    plot(smallA1, [1.9 2.1], [mean(MLNttpmean - std(MLNttpmean)) mean(MLNttpmean) - std(MLNttpmean)], propsPlotMLN{:})
    plot(smallA1, [1.8 2.2], [mean(MLNttpmean) mean(MLNttpmean)], propsPlotMLN{:})

    %Plot Treatment
    scatter(smallA1, 3*ones(size(treatmenTTPtMean, 1), 1), treatmenTTPtMean, 100, 'MarkerEdgeColor', colorTreatment, 'MarkerFaceColor', colorTreatment);
    %Plot mean and whiskers
    plot(smallA1, [2.8 3.2], [mean(treatmenTTPtMean) mean(treatmenTTPtMean)], propsPlotTreatment{:})
    plot(smallA1, [3 3], [mean(treatmenTTPtMean - std(treatmenTTPtMean)) mean(treatmenTTPtMean) + std(treatmenTTPtMean)], propsPlotTreatment{:})
    plot(smallA1, [2.9 3.1], [mean(treatmenTTPtMean + std(treatmenTTPtMean)) mean(treatmenTTPtMean) + std(treatmenTTPtMean)], propsPlotTreatment{:})
    plot(smallA1, [2.9 3.1], [mean(treatmenTTPtMean - std(treatmenTTPtMean)) mean(treatmenTTPtMean) - std(treatmenTTPtMean)], propsPlotTreatment{:})
    plot(smallA1, [2.8 3.2], [mean(treatmenTTPtMean) mean(treatmenTTPtMean)], propsPlotTreatment{:})

    %Prepare the axes
    xlim([0.6 3.4])
    ylim([0 1])
    xticks([1 2 3])
    xticklabels({'Control', 'Model', 'Treatment'})
    %title('Mean Time To Peak')
    title('c.');
    ylabel('Normalized Time')
    xlabel('');
    set(gca,'FontSize',17);

    %Create scatterplot 2
    smallA2 = axes(f, 'Position', [0.75 0.6, 0.2, 0.35]);
    hold on
    %Plot Normal
    scatter(smallA2, ones(size(normal, 1), 1), normal, 100, 'MarkerEdgeColor', colorNormal, 'MarkerFaceColor', colorNormal);
    plot(smallA2, [0.8 1.2], [mean(normal) mean(normal)], propsPlotNormal{:});
    plot(smallA2, [1 1], [mean(normal - std(normal)) mean(normal) + std(normal)], propsPlotNormal{:});
    plot(smallA2, [0.9 1.1], [mean(normal + std(normal)) mean(normal) + std(normal)], propsPlotNormal{:});
    plot(smallA2, [0.9 1.1], [mean(normal - std(normal)) mean(normal) - std(normal)], propsPlotNormal{:});
    plot(smallA2, [0.8 1.2], [mean(normal) mean(normal)], propsPlotNormal{:})

    %Plot MLN
    scatter(smallA2, 2*ones(size(MLN, 1), 1), MLN, 100, 'MarkerEdgeColor', colorMLN, 'MarkerFaceColor', colorMLN);
    plot(smallA2, [1.8 2.2], [mean(MLN) mean(MLN)], propsPlotMLN{:})
    plot(smallA2, [2 2], [mean(MLN - std(MLN)) mean(MLN) + std(MLN)], propsPlotMLN{:})
    plot(smallA2, [1.9 2.1], [mean(MLN + std(MLN)) mean(MLN) + std(MLN)], propsPlotMLN{:})
    plot(smallA2, [1.9 2.1], [mean(MLN - std(MLN)) mean(MLN) - std(MLN)], propsPlotMLN{:})
    plot(smallA2, [1.8 2.2], [mean(MLN) mean(MLN)], propsPlotMLN{:})

    %Plot Treatment
    scatter(smallA2, 3*ones(size(treatment, 1), 1), treatment, 100, 'MarkerEdgeColor', colorTreatment, 'MarkerFaceColor', colorTreatment);
    plot(smallA2, [2.8 3.2], [mean(treatment) mean(treatment)], propsPlotTreatment{:})
    plot(smallA2, [3 3], [mean(treatment - std(treatment)) mean(treatment) + std(treatment)], propsPlotTreatment{:})
    plot(smallA2, [2.9 3.1], [mean(treatment + std(treatment)) mean(treatment) + std(treatment)], propsPlotTreatment{:})
    plot(smallA2, [2.9 3.1], [mean(treatment - std(treatment)) mean(treatment) - std(treatment)], propsPlotTreatment{:})
    plot(smallA2, [2.8 3.2], [mean(treatment) mean(treatment)], propsPlotTreatment{:})

    %Prepare the figure
    xlim([0.6 3.4])
    ylim([0.4 1.2])
    xticks([1 2 3])
    xticklabels({'Control', 'Model', 'Treatment'})
    %title('Functional Ratio')
    title('b.');
    ylabel('Normalized Fraction')
    xlabel('');

    set(gca,'FontSize',17);

end

function [stats, ttpCurve] = readDir()

%Settings for plot range
extendBeyondHighCut = 10;
extendBeyondLowCut = 0;

%Initiate the output struct
stats = struct;

%Select folder with GUI
dataDir = uigetdir();

%Create path to only list .mat files
path = [dataDir '/*.mat'];

%Get the filelist
fileList = dir(path);

%Create the output arrayes that will be put in the output table
ttpLow = [];
ttpHigh = [];
transitTime = [];
ratio = [];
id = cell(1);
group = [];
ttpCurve = cell(1);
ttpMean = [];
mreLow = [];
mreMean = [];
mreStd = [];
contrastEnhacementFraction = [];

%Create a waitbar
f = waitbar(0, 'Reading group folder ...');

for fileIter = 1:length(fileList)

    %Read the examination
    volIn = load([fileList(fileIter).folder, '/' fileList(fileIter).name]);

    %Extract metadata
    id{fileIter} = volIn.props.patientId;
    group(fileIter) = volIn.props.groupID;
    ttpLow(fileIter) = volIn.props.bolusCutOff.ttpLow;
    ttpHigh(fileIter) = volIn.props.bolusCutOff.ttpHigh;
    transitTime(fileIter) = ttpHigh(fileIter) - ttpLow(fileIter);
    ratio(fileIter) =  volIn.stats.fractionLateTTP;
    
    %Initiate the object
    obj = T1perfusion(volIn.vol, volIn.mask, volIn.props, volIn.stats);

    %Get the contrastenhancementfraction
    contrastEnhacementFraction(fileIter) = obj.calcContrastLateContrastEnhancement;
    
    %Get parametric maps
    ttp = obj.getParametricMaps(2);

    %Get the mean values
    [ttpMean(fileIter), ttpSD, ttpMedian] = obj.calcAvgTTP;

    %Exclude values outside cutoff +/- extensions for plotting (useful to
    %plot unmasked whole 4D vol).
    ttp(ttp <= (ttpLow(fileIter) - extendBeyondLowCut)) = NaN;
    ttp(ttp > (ttpHigh(fileIter) + extendBeyondHighCut)) = NaN;

    %Get the vector describing the distribution
    [v, edges] = histcounts(ttp, max(ttp, [], 'all') - min(ttp, [], 'all'));

    %Normlize x-axis values
     xVals = edges(1:end-1);
     xVals = xVals - ttpLow(fileIter);
     xVals = xVals / (ttpHigh(fileIter) - ttpLow(fileIter));

    %Save the data
    ttpCurve{fileIter, 1} = v;
    ttpCurve{fileIter, 2} = xVals;
    
    %Update the waitbar
    waitbar(fileIter/length(fileList), f);

end

%Close the waitbar
close(f)

%Convert id to Strings
id = convertCharsToStrings(id);

%Construct the output table
stats.table = table(id', group', ttpLow', ttpHigh', transitTime', ratio', ttpMean', contrastEnhacementFraction', 'VariableNames', {'ID', 'GroupID', 'PeakInPA', 'PeakInAorta', 'TransitTime', 'FunctionalRatio', 'ttpMean',  'ceFraction'});

end
