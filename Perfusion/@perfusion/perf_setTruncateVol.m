function perf_setTruncateVol(varargin)

  perfObj = varargin{1};

  switch nargin
  case 1
    lowTimeCut = input('Input first timepoint to use from 4D-vol\n');
    highTimeCut = input('Input last timepoint to use from 4D-vol\n');
    perfObj.props.truncate4D.low = lowTimeCut;
    perfObj.props.truncate4D.high = highTimeCut;
  case 3
    perfObj.props.truncate4D.low = varargin{2};
    perfObj.props.truncate4D.high = varargin{3};
    return
  end

  %Recalculate parametric maps
  [ttp, cbf, cbv, maxRelEnhanceVol] = perfObj.T1perf_calcMaps();
  perfObj.ttpVol = ttp;
  perfObj.cbfVol = cbf;
  perfObj.cbvVol = cbv;
  perfObj.maxRelEnhanceVol = maxRelEnhanceVol;

end
