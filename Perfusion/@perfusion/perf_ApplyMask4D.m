function maskedVol = perf_ApplyMask4D(perfObj, vol)

%Function to apply mask for 4D volume

  %Allocate the output to be masked
  maskedVol = vol;

  %Allocate the 4D mask
  mask4D = zeros(size(vol));

  %Copy the mask to every time point

  mask4D = repmat(mask, 1, 1, 1, perfObj.props.size.timeDim);

  %Set all voxels not part of mask to NaN
  maskedVol(~mask4D) = NaN;

end
