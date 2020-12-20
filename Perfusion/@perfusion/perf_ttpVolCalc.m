function [fraction, lungWithoutVessel] = perf_ttpVolCalc(perfObj, ttpMap, low, high)

    i = ttpMap == 1;
    ttpMap(i) = NaN;

    totalLungVolume = sum(sum(sum(~isnan(ttpMap))));

    i = ttpMap <= low;
    ttpMap(i) = NaN;

    lungWithoutVessel = sum(sum(sum(~isnan(ttpMap))));

    i = ttpMap >= high;
    ttpMap(i) = NaN;

    subVol = sum(sum(sum(~isnan(ttpMap))));

    fraction = subVol/lungWithoutVessel;

    perfObj.stats.fractionLateTTP = fraction;
    perfObj.stats.lungsWithoutVessel = lungWithoutVessel;
    perfObj.stats.totalLungVolume = totalLungVolume;

    perfObj.props.bolusCutOff.ttpLow = low;
    perfObj.props.bolusCutOff.ttpHigh = high;


end
