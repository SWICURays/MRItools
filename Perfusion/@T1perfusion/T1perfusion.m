classdef T1perfusion < perfusion

%Subclass of perfusion for T1 perfusion
%
% Developed by Johan Lundberg, j.lundberg(at)ki.se
% Used in Rysz et al. 2020 COVID-19 may be driven by a RAAS imbalance.
%
%

  properties (SetAccess = public, GetAccess = ?perfusion)

    ttpVol
    cbfVol
    maxRelEnhanceVol
    cbvVol

  end


  methods (Access = public)

    %Constructor of object
    function perf = T1perfusion(varargin)

      %Initiate superclass Constructor
      perf@perfusion(varargin{:});

      %Create parametric maps and store in object

      [ttp, cbf, cbv, maxRelEnhanceVol] = perf.T1perf_calcMaps();
      perf.ttpVol = ttp;
      perf.cbfVol = cbf;
      perf.cbvVol = cbv;
      perf.maxRelEnhanceVol = maxRelEnhanceVol;

    end

    function smoothTimeDimension(varargin)

      switch nargin
      case 1
        perfObj = varargin{1};
        SmoothingFactor = 0.5;
      case 2
        perfObj = varargin{1};
        SmoothingFactor = varargin{2};
      otherwise
        error('Faulty number of arguments, provide either zero argumetns for default or one arg for smoothingfactor');
      end

      perfObj.vol = smoothdata(perfObj.vol, 4, 'rlowess', 'SmoothingFactor', SmoothingFactor);
      perfObj.T1perf_calcMaps;
      ttpVolMasked = perfObj.getParametricMaps(2);
      perfObj.perf_ttpVolCalc(ttpVolMasked, perfObj.props.bolusCutOff.ttpLow, perfObj.props.bolusCutOff.ttpHigh);

    end

    function [ttpMean, ttpSD, ttpMedian] = calcAvgTTP(perfObj)

        ttp = perfObj.getParametricMaps(2);
        ttp(ttp <= perfObj.props.bolusCutOff.ttpLow) = NaN;
        ttpMean = mean(ttp, 'all', 'omitnan');
        ttpMean = (ttpMean - perfObj.props.bolusCutOff.ttpLow) / (perfObj.props.bolusCutOff.ttpHigh - perfObj.props.bolusCutOff.ttpLow);
        %ttpMean = ttpMean - (perfObj.props.bolusCutOff.ttpLow / perfObj.props.bolusCutOff.ttpHigh);
        ttpSD = std(ttp, [], 'all', 'omitnan');
        ttpSD = (ttpSD - perfObj.props.bolusCutOff.ttpLow) / (perfObj.props.bolusCutOff.ttpHigh - perfObj.props.bolusCutOff.ttpLow);
        ttpMedian = median(ttp, 'all', 'omitnan');


    end

    function calcTTPmaxRelEnhDist(perfObj)

      %Settings to select a resonable range for the relative enhacement
      minRelEnhancement = 0;
      maxRelEnhancement = 1500;
      lengthOfBin = (maxRelEnhancement - minRelEnhancement) / 50;
      numOfTTPValuesAfterAorta = 15;
      
      %Get the ttpvalues 
      ttpvector = [perfObj.props.bolusCutOff.ttpLow:perfObj.props.bolusCutOff.ttpLow+numOfTTPValuesAfterAorta];

      %Initiate vectors
      relEnhanceVector = [];
      xVals = [];

      %Get the volumes
      ttpVol = perfObj.getParametricMaps(2);
      mreVol = perfObj.getParametricMaps(11);

      %Sort the max rel enhance dependent of ttp value
      for ttpIter = ttpvector

        i = ttpVol == ttpIter;
        relEnhanceVector(ttpIter, :) = histcounts(mreVol(i), minRelEnhancement:lengthOfBin:maxRelEnhancement);
        
        
      end

      %Trunctae NaN;
      relEnhanceVector = relEnhanceVector(perfObj.props.bolusCutOff.ttpLow:end, :);
      
      %Normalise the maxEnhacement
      relEnhanceVector = relEnhanceVector ./ max(relEnhanceVector, [], 2);
      
      %Create figure
      f = figure;
      set(f, 'NumberTitle', 'off', 'Name', perfObj.props.patientId); 
      surf(1:size(relEnhanceVector, 2), ttpvector, relEnhanceVector);
      ylabel('TTP values');
      xlabel('Histogram of max Rel Enhance');

    end
    
    function [ceFraction, ce] = calcContrastLateContrastEnhancement(perfObj)
        
        %Get the volume and mask
        vol = perfObj.getVolume;
        mask = perfObj.getMask;
    
        %Mask the volume
        vol = vol .* double(mask);
        vol(vol == 0) = NaN;
        
        %Calculate contrastenhacement and SD
        ce = mean(vol(:,:,:,perfObj.props.bolusCutOff.ttpHigh+10:perfObj.props.bolusCutOff.ttpHigh+25), 4) ./ mean(vol(:,:,:,1:10), 4);
        ceSD = std(vol(:,:,:,perfObj.props.bolusCutOff.ttpHigh+10:perfObj.props.bolusCutOff.ttpHigh+25), [], 4);
        
        %Mask the volume
        ce = ce .* double(mask);
        ce(ce == 0) = NaN;
        
        %Calculate fraction
        ceFraction = sum(ce > 2*ceSD, 'all') / sum(~isnan(ce), 'all');
        
  end

  end

  methods (Access = ?perfusion)
  %Internal functions defined in separate files

  [ttpVol, cbfVol, cbvVol, maxRelEnhanceVol] = T1perf_calcMaps(perfObj);
  ratio = T1perf_fractionEnhancesAboveNoise(perfObj);

  %NOT YET IMPLEMENTED
  %Convert raw data to R1 maps
  vol = T1perf_convertToR1(perf, vol);

  function setParametricMaps(perfObj, ttp, cbf, cbv, maxRelEnhanceVol)

    perfObj.ttpVol = ttp;
    perfObj.cbfVol = cbf;
    perfObj.cbvVol = cbv;
    perfObj.maxRelEnhanceVol = maxRelEnhanceVol;

  end

  end

end
