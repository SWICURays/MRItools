function [ttpVol, cbfVol, cbvVol, maxRelEnhanceVol] = T1perf_calcMaps(perfObj)

  %Function to create perfusionmaps
  %Input is contrast concentration T1 4D volume

  [M, I] = max(perfObj.vol(:, :, :, perfObj.props.truncate4D.low:perfObj.props.truncate4D.high), [], 4);

  ttpVol = I;
  cbfVol = M;

  baselineSignalSample = perfObj.vol(:,:,:,1:4);
  baseline = mean(baselineSignalSample, 4);

  maxRelEnhanceVol = ((M - baseline) ./ baseline) .* 100;

  cbvVol = sum(perfObj.vol - baseline, 4);


end
