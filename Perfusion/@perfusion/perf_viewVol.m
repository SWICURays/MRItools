function imtool3Dhandle = perf_viewVol(perfObj)

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
