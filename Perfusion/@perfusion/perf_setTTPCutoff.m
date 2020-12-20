function stats = perf_setTTPCutoff(varargin)

  switch nargin
  %Option to input manual TTP values
  case 1

    perfObj = varargin{1};
    %Get new values
    low = input('Input low cutoff for TTP \n');
    high = input('Input high cutoff for TTP \n');

    %Save the values in props
    perfObj.props.bolusCutOff.ttpLow = low;
    perfObj.props.bolusCutOff.ttpHigh = high;

    %Get the masked volume
    ttpVolMasked = perfObj.getParametricMaps(2);

    %Calculate
    perfObj.perf_ttpVolCalc(ttpVolMasked, low, high);
    stats = perfObj.getStats;

  %Here TTP values are given as arguments
  case 3
    perfObj = varargin{1};
    %Get new values
    low = varargin{2};
    high = varargin{3};

    perfObj.props.bolusCutOff.ttpLow = low;
    perfObj.props.bolusCutOff.ttpHigh = high;

    %Calculate the ttpVol ratio
    perfObj.perf_ttpVolCalc(perfObj.ttpVol, low, high);
    stats = perfObj.getStats;
  end

end
