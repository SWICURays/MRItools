function vol = perf_makePretty(perfObj, volIn)

  upSampleVol = imresize(volIn, 10);
  vol = zeros(size(upSampleVol));
  
  filtVol = imgaussfilt(upSampleVol, 0.5, 'FilterSize', 25);
  
  f = waitbar(0, 'Making it Pretty: Every pixel is an artefact and with great power ...');

  noOfSlices = size(vol, 3);

    for sliceIter = 1:noOfSlices

      waitbar((sliceIter/noOfSlices), f);
      vol(:,:, sliceIter) = imsharpen(filtVol(:,:, sliceIter), 'Radius', 40, 'Amount', 1, 'Threshold', 1);

    end

  close(f);

end
