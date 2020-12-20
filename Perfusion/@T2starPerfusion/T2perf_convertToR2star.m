function volOut = T2perf_convertToR2star(perfObj)

  %https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3593114/

  TE = 20; %ms
  k = 100;
 
  volOut = -1 * (k/TE) * (log(perfObj.vol ./ mean(perfObj.vol(:,:,:,1:5), 4)));
  volOut = volOut(:,:,:,2:end);
  
end
