function outVol = perf_getParametricMaps(varargin)

  switch nargin
    case 1
      perfObj = varargin{1};
      typeOfMap = input([ ...
          'Specify Parametric map to get:\n' ...
          '(1) TTP\n' ...
          '(2) TTP-masked\n' ...
          '(3) TTP-HD\n' ...
          '(4) CBV\n' ...
          '(5) CBV-masked\n' ...
          '(6) CBV-HD\n' ...
          '(7) CBF\n' ...
          '(8) CBF-masked\n' ...
          '(9) CBF-HD\n' ...
          '(10) Rel Max Enhancement\n' ...
          '(11) Rel Max Enhacement-masked\n' ...
          ]);
    case 2
      perfObj = varargin{1};
      typeOfMap = varargin{2};

  end

  switch typeOfMap

  %TTP options
    case 1
      outVol = perfObj.ttpVol;

    case 2
      if ischar(perfObj.mask)
        disp('No mask was provided, please load a mask to the object');
        outVol = perfObj.ttpVol;
      else
        outVol = perfObj.ttpVol;
        outVol(~perfObj.mask) = NaN;
      end

    case 3
      outVol = perf_makePretty(perfObj, perfObj.ttpVol);

      %CBV options
    case 4
      outVol = perfObj.cbvVol;

    case 5
      if ischar(perfObj.mask)
        disp('No mask was provided, please load a mask to the object');
        outVol = perfObj.cbvVol;
      else
        outVol = perfObj.cbvVol;
        outVol(~perfObj.mask) = NaN;
      end

    case 6
      outVol = perf_makePretty(perfObj, perfObj.cbvVol);

    %CBF options
    case 7
      outVol = perfObj.cbvVol;

    case 8
      if ischar(perfObj.mask)
        disp('No mask was provided, please load a mask to the object');
        outVol = perfObj.cbfVol;
      else
        outVol = perfObj.cbfVol;
        outVol(~perfObj.mask) = NaN;
      end

    case 9
      outVol = perf_makePretty(perfObj, perfObj.cbvVol);

    case 10
      outVol = perfObj.maxRelEnhanceVol;

    case 11
      if ischar(perfObj.mask)
        disp('No mask was provided, please load a mask to the object');
        outVol = perfObj.maxRelEnhanceVol;
      else
        outVol = perfObj.maxRelEnhanceVol;
        outVol(~perfObj.mask) = NaN;
      end

  end

  end

  function imtool3Dhandle = viewVol(perfObj)

  %Check if a truncation option has been used
  if ~isfield(perfObj.props, 'truncate4D')
    f = figure;
    perfObj.handles.imtoolfig = f;
    imtool3Dhandle = imtool3D(perfObj.vol, [], f, [], [], [], [], perfObj);
    perfObj.handles.imtool = imtool3Dhandle;
  else
    f = figure;
    perfObj.handles.imtoolfig = f;
    imtool3Dhandle = imtool3D(perfObj.vol(:,:,:,perfObj.props.truncate4D.low:perfObj.props.truncate4D.high), ...
        [], f, [], [], [], [], perfObj);
    perfObj.handles.imtool = imtool3Dhandle;
  end

end
