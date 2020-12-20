function vol = resortTo4D(old)

  %Function to resort DICOM file into correct 4D array

  vol = zeros(160, 160, 26, 90);

  toCopy = 1;

  for sliceIter = 1:26
    for timeIter = 1:90

      vol(:,:, sliceIter, timeIter) = old(:,:,toCopy);
      toCopy = toCopy +1;

    end
  end

end
