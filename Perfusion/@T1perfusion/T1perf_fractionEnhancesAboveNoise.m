function ratio = T1perf_fractionEnhancesAboveNoise(perfObj)

  baseLineSample = perfObj.vol(:,:,:,1:4);
  baseLineSample(~perfObj.mask) = NaN;
  noiseMap = 3 .* nanstd(baseLineSample, [], 4);

  indexEnhanced = perfObj.cbfVol > noiseMap;
  volEnhancing = perfObj.cbfVol(indexEnhanced);
  volNotEnhancing = perfObj.cbfVol(~indexEnhanced);

  noEnhance = sum(sum(sum(volNotEnhancing)))
  enhancing = sum(sum(sum(volEnhancing)))
  ratio = noEnhance /enhancing

end
