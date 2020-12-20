function [ttpVol, cbvVol, maxRelEnhanceVol] = T2perf_calcMaps(perfObj)

  [M, I] = max(perfObj.R2vol(:, :, :, perfObj.props.truncate4D.low:perfObj.props.truncate4D.high-1), [], 4);

  ttpVol = I;
  cbfVol = M;

  %baselineSignalSample = -1 * perfObj.vol(:,:,:,1:4);
  %baseline =  mean(baselineSignalSample, 4);

  maxRelEnhanceVol = M; %(((M - baseline) ./ baseline) .* 100 - 100) * -1;

  cbvVol = sum(perfObj.R2vol);


end
