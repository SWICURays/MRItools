function imtool3Dhandle = perf_viewParametricMaps(varargin)

    switch nargin
        case 1
          perfObj = varargin{1};
          typeOfMap = input([ ...
              'Specify Parametric map to view:\n' ...
              '(1)  TTP\n' ...
              '(2)  TTP-masked\n' ...
              '(3)  TTP-HD-masked\n' ...
              '(4)  CBV\n' ...
              '(5)  CBV-masked\n' ...
              '(6)  CBV-HD\n' ...
              '(7)  CBF\n' ...
              '(8)  CBF-masked\n' ...
              '(9)  CBF-HD\n' ...
              '(10) Rel Max Enhancement\n' ...
              '(11) Rel Max Enhancement-masked\n' ...
              '(12) Rel Max Enhancement-HD\n' ...
              ]);
        case 2
          perfObj = varargin{1};
          typeOfMap = varargin{2};

      end

      %Set default window
      range = [];

      switch typeOfMap

      %TTP options
        case 1
          displayVol = perfObj.ttpVol;
          range = [perfObj.props.bolusCutOff.ttpLow ...
            perfObj.props.bolusCutOff.ttpHigh];

        case 2
          if ischar(perfObj.mask)
            disp('No mask was provided, please load a mask to the object');
            displayVol = perfObj.ttpVol;
            range = [perfObj.props.bolusCutOff.ttpLow ...
            perfObj.props.bolusCutOff.ttpHigh];
          else
            displayVol = perfObj.ttpVol;
            displayVol(~perfObj.mask) = NaN;
            range = [perfObj.props.bolusCutOff.ttpLow ...
            perfObj.props.bolusCutOff.ttpHigh];
          end

        case 3
          displayVol = perf_makePretty(perfObj, perfObj.ttpVol);
          upSampleMask = imresize(perfObj.mask, 10);
          displayVol(~upSampleMask) = NaN;
          range = [perfObj.props.bolusCutOff.ttpLow ...
            perfObj.props.bolusCutOff.ttpHigh];


          %CBV options
        case 4
          displayVol = perfObj.cbvVol;

        case 5
          if ischar(perfObj.mask)
            disp('No mask was provided, please load a mask to the object');
            displayVol = perfObj.cbvVol;
          else
            displayVol = perfObj.cbvVol;
            displayVol(~perfObj.mask) = NaN;
          end

        case 6
          displayVol = perf_makePretty(perfObj, perfObj.cbvVol);

        %CBF options
        case 7
          displayVol = perfObj.cbvVol;

        case 8
          if ischar(perfObj.mask)
            disp('No mask was provided, please load a mask to the object');
            displayVol = perfObj.cbfVol;
          else
            displayVol = perfObj.cbfVol;
            displayVol(~perfObj.mask) = NaN;
          end

        case 9
          displayVol = perf_makePretty(perfObj, perfObj.cbvVol);

        case 10
          displayVol = perfObj.maxRelEnhanceVol;

        case 11
          if ischar(perfObj.mask)
            disp('No mask was provided, please load a mask to the object');
            displayVol = perfObj.maxRelEnhanceVol;
          else
            displayVol = perfObj.maxRelEnhanceVol;
            displayVol(~perfObj.mask) = NaN;
          end 
          
        case 12
          displayVol = perf_makePretty(perfObj, perfObj.maxRelEnhanceVol);
          upSampleMask = imresize(perfObj.mask, 10);
          displayVol(~upSampleMask) = NaN;
        end

      f = figure;
      perfObj.handles.imtoolfig = f;
      imtool3Dhandle = imtool3D(displayVol, [], f, range, [], [], [], perfObj);
      perfObj.handles.imtool = imtool3Dhandle;
      
end