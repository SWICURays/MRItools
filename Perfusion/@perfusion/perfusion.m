classdef perfusion < handle

%SUPERCLASS OF PERFUSION OBJECTS
%-------------------------------
% Developed by Johan Lundberg, j.lundberg(at)ki.se
% Used in Rysz et al. 2020 COVID-19 may be driven by a RAAS imbalance.
%
%
% Dependent on imtool3D to view the volumes
%
% METHODS
%
% viewVol -> launch imtool3D to view 4D volume. Right click ROI to selec inflow handle
%            outflow ROI.
%
% saveMask -> saves the mask from the last launched imtool3D
%
% load mask -> loads a mask to the last launched imtool3D instance
%
% viewAIFROI -> displays ROI chosen for inflow function
%
% viewVIFROI -> display ROI chosen for outflow function
%
% viewParametricMaps ->  lanuch imtool3D to view parametric maps.
%                       To "make more Pretty" give any input variable e.g. perfObj.ttp(1)
%                       Returns handle to imtool3D object.
%
% getStats -> gets stats in struct
%
% getParametricMaps and getVolume returns parametric maps or volumes
%
% setTTPCutoff -> sets the cutoffvalues obtained from the ROI selected in 4D volume when applied to ttpMap
% setTruncateVol -> truncates the 4D volume if there is movement prior to or after the contrastbolus
% setPatientID -> sets the patient id


  properties (SetAccess = private, GetAccess = {?T1perfusion, ?T2starPerfusion})

    vol
    mask

  end

  properties (SetAccess = public, GetAccess = public)
    props
    handles
    stats
  end

  methods (Access = public)

    %Constructor of superclass
    function perfObj = perfusion(varargin)

      switch nargin

        %No input arguments, should read a saved file
        case 0
          [file, path] = uigetfile();
          load([path file]);

        %Input volume but no mask
        case 1
          vol = varargin{1};
          mask = 'No mask provided';

        %Inputs volume and mask
        case 2
          vol = varargin{1};
          mask = varargin{2};

        case 4
          vol = varargin{1};
          mask = varargin{2};
          props = varargin{3};
          stats = varargin{4};

      end

      %Create props and find dimensions
      if ~exist('props', 'Var')
          props = struct();

          %Get patientID
          patientId = input('Specify patient id (Enter for no patient ID)\n', 's');
          %Check if patientID was provided
          if isempty(patientId)
            patientId = 'NoPatIDProvided';
          end

          props.patientId = patientId;

          %Get rater ID
          raterId = input('Specify rater id. (Enter for no rater ID)\n', 's');
          %Check if rater ID was provided
          if isempty(raterId)
            raterId = 'NoRaterIdProvided';
          end

          props.raterID = raterId;

          %Get treatment status
          groupID = input('Specify group status (Enter for no group ID)\n');
          if isempty(groupID)
              groupID = 'NoGroupIDProvided';
          end

          props.groupID = groupID;

          %Get size of volume
          [props.size.xDim, props.size.yDim, props.size.zDim, props.size.timeDim] = size(vol);

          %Set default values

          props.bolusCutOff.ttpLow = 1;
          props.bolusCutOff.ttpLow = props.size.timeDim;

          props.truncate4D.low = 1;
          props.truncate4D.high = props.size.timeDim;

      end

      if ~exist('stats', 'Var')
          stats = struct();
      end

      %Save stuff in object
      perfObj.vol = vol;
      perfObj.mask = mask;
      perfObj.props = props;
      perfObj.stats = stats;

      %Check if volume is truncated.
      if ~isfield(perfObj.props, 'truncate4D')
        perfObj.setTruncateVol(1, props.size.timeDim);
      end

    end

    %VIEW FUNCTIONS

    %View parametric maps with imtool3D
    function imtool3Dhandle = viewParametricMaps(varargin)
      imtool3Dhandle = perf_viewParametricMaps(varargin{:});
    end

    function imtool3Dhandle = viewVol(perfObj)
      imtool3Dhandle = perf_viewVol(perfObj);
    end

    %GET FUNCTIONS

    function stats = getStats(perfObj)
      stats = perfObj.stats;
    end

    function outVol = getParametricMaps(varargin)
      outVol = perf_getParametricMaps(varargin{:});
    end

    function vol = getVolume(perfObj)
      vol = perfObj.vol;
    end

    function mask = getMask(perfObj)
      mask = perfObj.mask;
    end

    %SET FUNCTIONS

    %Function to change ttp values for ratio calculation
    function stats = setTTPCutoff(varargin)
      stats = perf_setTTPCutoff(varargin{:});
    end

    function setTruncateVol(varargin)
      perf_setTruncateVol(varargin{:});
    end

    function setPatientID(perfObj)

      newID = input('Specify new patient ID\n', 's');
      perfObj.props.patientId = newID;

    end

    %Interact with imtool

    function saveMask(perfObj)

      if isfield(perfObj.handles, 'imtool')
        perfObj.mask = perfObj.handles.imtool.mask;
      else
        fprintf('No Imtool3D instance');
      end

    end

    function loadMask(perfObj)
      perfObj.handles.imtool.mask = perfObj.mask;
    end

    function saveAIF(perfObj, stats)
        perfObj.stats.AIF = stats;
    end

    function saveVIF(perfObj, stats)
        perfObj.stats.VIF = stats;
    end

    function saveExtraROI(perfObj, stats, n)

      % '1  - Right pulmonary artery\n', ...
      % '2  - Left pulmonary artery\n', ...
      % '3  - Left atrium\n', ...
      % '4  - Ascending Aorta\n', ...
      % '5  - Desecending Aorta\n', ...
      % '6  - Lung vein Left Upper\n' ...
      % '7  - Lung vein Left Lower\n' ...
      % '8  - Lung vein Right Upper\n' ...
      % '9  - Lung vein Right Lower\n' ...
      % '10 - Right Atrium\n' ...
      % '11 - Superior Caval Vein\n' ...
      % '12 - Subclavial Vein\n' ...
      % '13 - Right Ventricle\n' ...
      % '14 - Extra 1\n' ...
      % '15 - Extra 2\n' ...
      % '16 - Extra 3\n' ...
      % '17 - Extra 4\n' ...
      % '18 - Extra 5\n' ...
      switch n
      case 1
        perfObj.stats.extraROI.RLa = stats;
      case 2
        perfObj.stats.extraROI.LLa = stats;
      case 3
        perfObj.stats.extraROI.LAt = stats;
      case 4
        perfObj.stats.extraROI.AAs = stats;
      case 5
        perfObj.stats.extraROI.ADe = stats;
      case 6
        perfObj.stats.extraROI.LvLu = stats;
      case 7
        perfObj.stats.extraROI.LvLl = stats;
      case 8
        perfObj.stats.extraROI.LvRu = stats;
      case 9
        perfObj.stats.extraROI.LvRl = stats;
      case 10
        perfObj.stats.extraROI.RAt = stats;
      case 11
        perfObj.stats.extraROI.SVC = stats;
      case 12
        perfObj.stats.extraROI.VCs = stats;
      case 13
        perfObj.stats.extraROI.RVt = stats;
      case 14
        perfObj.stats.extraROI.extra1 = stats;
      case 15
        perfObj.stats.extraROI.extra2 = stats;
      case 16
        perfObj.stats.extraROI.extra3 = stats;
      case 17
        perfObj.stats.extraROI.extra4 = stats;
      case 18
        perfObj.stats.extraROI.extra5 = stats;
      otherwise
        error('No allowed selection for ROI performed');
      end

    end

    function viewAIFROI(perfObj)

      figure(perfObj.handles.imtoolfig);
      perfObj.handles.imtool.setCurrentSlice(perfObj.stats.AIF.slice);
      perfObj.handles.imtool.displaySavedROI(perfObj.stats.AIF.position);

    end

    function viewVIFROI(perfObj)

      figure(perfObj.handles.imtoolfig);
      perfObj.handles.imtool.setCurrentSlice(perfObj.stats.VIF.slice);
      perfObj.handles.imtool.displaySavedROI(perfObj.stats.VIF.position);

    end

    %Save to disk and load from disk

    function loadData(perfObj)
      [file, path] = uigetfile();
      load([path file]);

      try
        perfObj.vol = vol;
      catch
        error('No Volume in file');
      end

      try
        perfObj.mask = mask;
      catch
        fprintf('No mask in file');
        perfObj.mask = 'No mask provided\n';
      end

      try
        perfObj.props = props;
      catch
        fprintf('No props in file\n')
      end

      try
        perfObj.stats = stats;
      catch
        fprintf('No stats in file\n')
      end

    end

    function saveData(perfObj)

      dirToWrite = uigetdir;
      vol = perfObj.vol;
      mask = perfObj.mask;
      props = perfObj.props;
      stats = perfObj.stats;

      try
        save([dirToWrite filesep props.patientId '.mat'], 'vol', 'mask', 'props', 'stats');
      catch
         fprintf('No directory was choosen! Data NOT saved!\n');
      end
    end



  end

  methods (Access = private)

    imtool3Dhandle = perf_viewParametricMaps(varargin)
    stats = perf_setTTPCutoff(varargin);
    outvol = perf_getParametricMaps(varargin);
    imtool3Dhandle = perf_viewVol(perfObj);

  end

  methods (Access = {?T1perfusion, ?T2starPerfusion})

      %Functions in separate files:
      maskedVol = perf_ApplyMask4D(perfObj, vol)
      vol = perf_makePretty(perfObj, volIn)
      [fraction, lungWithoutVessel] = perf_ttpVolCalc(perfObj, ttpMap, low, high)

      %Internal functions


  end

end
