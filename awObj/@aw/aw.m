classdef aw < handle

%Subclass of perfusion for T1 perfusion

  properties (SetAccess = public, GetAccess = public)

    handles
    props
    dataobj
    tools
    ROIlist


  end


  methods (Access = public)

    %Constructor of object
    function aw = aw(varargin)

      aw.dataobj = varargin{1};

      I = aw.dataobj.getVolume;
      position = [0, 0, 1, 1];

      S = [size(I,1)*2, size(I,2)*2, size(I,3)];


      f = figure;
      set(f,'Toolbar','none','Menubar','none','NextPlot','new');
      set(f, 'NumberTitle', 'off', 'Name', aw.dataobj.props.patientId); 
      set(f,'Units','Pixels');

      pos=get(f,'Position');

      pos = pos *2;
      f.Position = pos;

      Af=pos(3)/pos(4); %Input ratio of the figure

      AI=S(1)/S(2); %input Ratio of the image
                if Af>AI    %Figure is too wide, make it taller to match
                   pos(4)=pos(3)/AI;
                elseif Af<AI    %Figure is too long, make it wider to match
                    pos(3)=AI*pos(4);
                end

                %set minimal size
                screensize = get(0,'ScreenSize');
                pos(3)=min(max(600,pos(3)),screensize(3));
                pos(4)=min(max(500,pos(4)),screensize(4));

                %make sure the figure is centered
                pos(1) = ceil((screensize(3)-pos(3))/2);
                pos(2) = ceil((screensize(4)-pos(4))/2);
                set(f,'Position',pos)
                set(f,'Units','normalized');

      %Create panels

      w = 50; %Pixel width of Panels
      wbutt = 40; %Pixel size of buttons



      aw.handles.figure = f;

      aw.handles.Panels.Large = uipanel(aw.handles.figure, ...
       'Units','normalized', ...
       'Position',position, ...
       'Title','', ...
       'Tag','aw');
      pos=getpixelposition(aw.handles.figure);
      pos(1) = pos(1)+position(1);%*pos(3);
      pos(2) = pos(2)+position(2);%*pos(4);
      pos(3) = pos(3)*position(3);
      pos(4) = pos(4)*position(4);
      aw.handles.menu = uipanel(aw.handles.Panels.Large, ...
       'Units','Pixels', ...
       'Position',[0 pos(4)-w pos(3) w], ...
       'Title','menu');
      aw.handles.Panels.viewports = uipanel(aw.handles.Panels.Large, ...
          'Units', 'pixels', ...
          'Position', [0, position(4), pos(3), pos(4) - w], ...
          'Title', 'Viewports');

      aw.handles.viewport1 = uipanel(aw.handles.Panels.viewports, ...
       'Units', 'Normalized', ...
       'Position', [0, 0.5, 0.5, 0.5], ... %[0, pos(4)-(pos(4)/2)-w, pos(3)/2, pos(4)/2], ...
       'Title', 'ViewPort 1');
      aw.handles.viewport2 = uipanel(aw.handles.Panels.viewports, ...
       'Units', 'Normalized', ...
       'Position', [0.5, 0.5, 0.5, 0.5], ...
       'Title', 'ViewPort 2');
      aw.handles.viewport3 = uipanel(aw.handles.Panels.viewports, ...
       'Units', 'Normalized', ...
       'Position', [0, 0, 0.5, 0.5], ...
       'Title', 'ViewPort 3');
      aw.handles.viewport4 = uipanel(aw.handles.Panels.viewports, ...
       'Units', 'Normalized', ...
       'Position', [0.5, 0, 0.5, 0.5], ...
       'Title', 'ViewPort 4');

      %Load the imtools
      aw.tools.t1 = imtool3Daw(aw.dataobj.getVolume, [], aw.handles.viewport1, [], [], [], [], aw);
      aw.tools.t2 = imtool3Daw(aw.dataobj.getParametricMaps(1), [], ...
           aw.handles.viewport2, [aw.dataobj.props.bolusCutOff.ttpLow aw.dataobj.props.bolusCutOff.ttpHigh], ...
           [], [], [],  aw);
      aw.tools.t2.setNewColorMap(3);
      aw.tools.t3 = imtool3Daw(aw.dataobj.getParametricMaps(10), [], aw.handles.viewport4, [100 400], [], [], [], aw);
      aw.tools.t3.setNewColorMap(4);

      aw.tools.t1.storeToolsToSync([aw.tools.t2 aw.tools.t3]);
      aw.tools.t2.storeToolsToSync([aw.tools.t1 aw.tools.t3]);
      aw.tools.t3.storeToolsToSync([aw.tools.t1 aw.tools.t2]);

      %Set up axes for plot
      aw.handles.axes = axes(aw.handles.viewport3, 'Position', [0.1, 0.1, 0.9, 0.8]);
      title(aw.handles.axes, 'Signal Intensity Curves');
      xlabel(aw.handles.axes, 'Time');
      ylabel(aw.handles.axes, 'Absolute Signal Intensity');

      %Resize function
      fun= @(x, y) aw_resizewindow(x, y, aw, w, wbutt);
      aw.handles.Panels.Large.ResizeFcn = fun;
      
      %Setup list of ROI;
      ROIlist = cell(0,0);
      aw.ROIlist = ROIlist;

    end

  end

  methods (Access = public)

    aw_updateROI(aw, stats, slice, name, status)

  end

end



function aw_resizewindow(hObject, event, aw, w, wbutt)

  position = [0, 0, 1, 1];
  pos=aw.handles.figure.Position;

  aw.handles.Panels.Large.Position = position;

  pos=getpixelposition(aw.handles.figure);
  pos(1) = pos(1)+position(1);%*pos(3);
  pos(2) = pos(2)+position(2);%*pos(4);
  pos(3) = pos(3)*position(3);
  pos(4) = pos(4)*position(4);
  aw.handles.menu.Units = 'Pixels';
  aw.handles.menu.Position = [0 pos(4)-w pos(3) w];

  aw.handles.Panels.viewports.Units = 'Pixels';
  aw.handles.Panels.viewports.Position = [0, position(4), pos(3), pos(4) - w];
  aw.handles.viewport2.Selected = 'on';
  aw.handles.viewport2.SelectionHighlight = 'on';


end
