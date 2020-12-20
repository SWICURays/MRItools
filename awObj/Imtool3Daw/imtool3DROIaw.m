classdef imtool3DROIaw < handle
    %This is an abstract class for the ROI tools used in imtool3D

    properties (SetObservable = true)
        imageHandle
        axesHandle
        figureHandle
        graphicsHandles
        menuHandles
        textHandle
        tool
        listenerHandle
        lineColor = 'y';
        markerColor = 'r';
        visible = true;
        textVisible = false; %this property is a slave to visible (i.e., if visible is false, the text will not be visible even if textVisible is true)
        
        id
        %Added to handle plot
        %tool
%         ROIfigHandles
%         timeVolume
%         curveInFig
    end

    events
        ROIdeleted
        newROIPosition
    end

    methods

        %Constructor
        function ROI = imtool3DROIaw(imageHandle,graphicsHandles, menuLabels,menuFunction,varargin)

            %Set the properties
            ROI.imageHandle = imageHandle;
            ROI.graphicsHandles = graphicsHandles;
            %ROI.ROIfigHandles = ROIfigHandle;


            %Get the parent axes of the image
            ROI.axesHandle = get(imageHandle,'Parent');

            %Find the parent figure of the object
            ROI.figureHandle = getParentFigure(imageHandle);

            %create the context menu
            c = uicontextmenu;

            %set the graphics handles to use the context menu and set their
            %color
            if ROI.visible
                str = 'on';
            else
                str = 'off';
            end
            for i=1:length(graphicsHandles)
                set(graphicsHandles(i),'UIContextMenu',c)
                switch class(graphicsHandles(i))
                    case 'matlab.graphics.chart.primitive.Line'
                        set(graphicsHandles(i),'Color',ROI.lineColor,'MarkerFaceColor',ROI.markerColor,'MarkerEdgeColor',ROI.markerColor,'Visible',str)
                    case 'matlab.graphics.primitive.Rectangle'
                        set(graphicsHandles(i),'EdgeColor',ROI.lineColor,'Visible',str)
                    otherwise
                        disp(class(graphicsHandles(i)))
                end

            end

            %create each of the menu items and set their callback
            %functions
            menuFunction = @(source,callbackdata) menuFunction(source,callbackdata,ROI,varargin{:});
            for i=1:length(menuLabels)
                ROI.menuHandles(i) = uimenu('Parent',c,'Label',menuLabels{i},'Callback',menuFunction);
            end

            %Link the ROI object to the ROI plot axes
            ROI.tool = varargin{1};
            ROI.id = varargin{2};
            %h = t.getHandles;
            %ROI.ROIfigHandles = h.ROIfig;

            %Get the volume to calculate curves
            %ROI.timeVolume = tool.datahandler.dataobj.getVolume;
            
            
            set(ROI.textHandle,'Visible','off');




        end

        function set.lineColor(ROI,lineColor)
            ROI.lineColor = lineColor;
            graphicsHandles = ROI.graphicsHandles;
            for i=1:length(graphicsHandles)
                switch class(graphicsHandles(i))
                    case 'matlab.graphics.chart.primitive.Line'
                        set(graphicsHandles(i),'Color',ROI.lineColor)
                    case 'matlab.graphics.primitive.Rectangle'
                        set(graphicsHandles(i),'EdgeColor',ROI.lineColor)
                    otherwise
                        disp(class(graphicsHandles(i)))
                end

            end
        end

        function set.markerColor(ROI,markerColor)
            ROI.markerColor = markerColor;
            graphicsHandles = ROI.graphicsHandles;
            for i=1:length(graphicsHandles)
                switch class(graphicsHandles(i))
                    case 'matlab.graphics.chart.primitive.Line'
                         set(graphicsHandles(i),'MarkerFaceColor',ROI.markerColor,'MarkerEdgeColor',ROI.markerColor)
                    otherwise
                        disp(class(graphicsHandles(i)))
                end

            end
        end

        function set.visible(ROI,visible)
            ROI.visible=visible;
            if visible
                str = 'on';
            else
                str = 'off';
            end
            %turn on or off the visibility of the ROI graphics
            for i=1:length(ROI.graphicsHandles)
                set(ROI.graphicsHandles(i),'Visible',str);
            end

            %Turn on or off the visibility of the text box
            if visible
                if ROI.textVisible
                    set(ROI.textHandle,'Visible','on');
                else
                    set(ROI.textHandle,'Visible','off');
                end
            else
                set(ROI.textHandle,'Visible','off');
            end



        end

        function set.textVisible(ROI,textVisible)
            ROI.textVisible=textVisible;
            if textVisible
                if ROI.visible
                    set(ROI.textHandle,'Visible','on');
                else
                    set(ROI.textHandle,'Visible','off');
                end
            else
                set(ROI.textHandle,'Visible','off');
                %make sure the context menu is in sync with this
                for i=1:length(ROI.menuHandles)
                    switch get(ROI.menuHandles(i),'Label')
                        case 'Hide Text'
                            set(ROI.menuHandles(i),'Checked','on');
                    end
                end
            end
        end

        %Destructor
        function delete(ROI)
            %Communicate the destruction to the aw object
                status = 0;
                stats = 0;
                slice = ROI.tool.handles.Slider.Value;
                ROI.tool.datahandler.aw_updateROI(stats, slice, ROI, status);
            
            try
                
                
                %delete the ROI
                delete(ROI.graphicsHandles);
                delete(ROI.textHandle);
                delete(ROI.listenerHandle);
                delete(ROI.curveInFig);
                notify(ROI,'ROIdeleted');
            
            end
        end
    end

end

function fig = getParentFigure(fig)
% if the object is a figure or figure descendent, return the
% figure. Otherwise return [].
while ~isempty(fig) & ~strcmp('figure', get(fig,'type'))
  fig = get(fig,'parent');
end
end
