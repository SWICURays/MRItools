classdef T2starPerfusion < perfusion

  properties (SetAccess = public, GetAccess = public)

    ttpVol
    cbfVol
    maxRelEnhanceVol
    cbvVol
    R2vol

  end

  methods (Access = public)


    function perf = T2starPerfusion(varargin)

      %Initiate superclass Constructor
      perf@perfusion(varargin{:});

      %Create parametric maps and store in object

      R2vol = perf.T2perf_convertToR2star();
      perf.R2vol = R2vol;

      [ttp, cbv, maxRelEnhanceVol] = perf.T2perf_calcMaps();
      perf.ttpVol = ttp;
      perf.cbvVol = cbv;
      perf.maxRelEnhanceVol = maxRelEnhanceVol;

    end

  end

end
