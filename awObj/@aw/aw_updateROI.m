function aw_updateROI(aw, stats, slice, ROI, status)

  %Check if this is the deletion of a ROI
  
  if status == 0
      for ROIindex = 1:size(aw.ROIlist, 1)
        if aw.ROIlist{ROIindex, 1} == ROI.id
            newROI = false;
            break
        end
      end
    
    aw.ROIlist(ROIindex,:) = [];
    
  end

  %Check if new ROI is calling in or a new is added
  
  vol = aw.dataobj.getVolume;
  newROI = true;
  
  %First check if no ROIs are active
  if size(aw.ROIlist, 1) > 0 && status == 1
    
    %Loop over the roiList  
    for ROIindex = 1:size(aw.ROIlist, 1)
        if aw.ROIlist{ROIindex, 1} == ROI.id
            newROI = false;
            break
        end
    end
  end
  
  if newROI == true && status == 1
      pos = size(aw.ROIlist, 1) +1;
      aw.ROIlist{pos, 1} = ROI.id;
      aw.ROIlist{pos, 2} = stats;
      aw.ROIlist{pos, 3} = slice;
      aw.ROIlist{pos, 4} = ROI;
  elseif newROI == false && status == 1
      aw.ROIlist{ROIindex, 1} = ROI.id;
      aw.ROIlist{ROIindex, 2} = stats;
      aw.ROIlist{ROIindex, 3} = slice;
      aw.ROIlist{ROIindex, 4} = ROI;
  end
  
  axes(aw.handles.axes);
  cla(aw.handles.axes);
  hold on;
  
  
  if size(aw.ROIlist, 1) > 0
      
      for roiIter = 1:size(aw.ROIlist, 1)
        [sic, stdSic] = roiVector(vol, aw.ROIlist{roiIter, 2}, aw.ROIlist{roiIter, 3});
        errorbar(aw.handles.axes, 1:size(vol, 4), sic, stdSic, 'lineWidth', 1);
      end
      
  end
  
  hold off

end

function [sic, stdSic] = roiVector(vol, roi, slice)

    timePoints = size(vol, 4);

    maskedVol = double(vol(:,:,slice,:)) .* roi.mask;
    maskedVol = squeeze(maskedVol);

    sic = zeros(timePoints, 1);
    stdSic = zeros(timePoints, 1);

     for timeIter = 1:timePoints

         sic(timeIter) = mean(mean(nonzeros(maskedVol(:, :, timeIter))));
         stdSic(timeIter) = std(nonzeros(maskedVol(:, :, timeIter)));

     end
 
end
