function [] = viz(iIter, nIter)
% To visualize the zebros
% Input:
%   iIter: ith iteration to visualize
%   nIter: number of total iterations
% Global Variable
%   zebros: zebro information of last iteration.
%   zebros(i, :): information of zebro No.i
%   zebros(:, 1): x coordinate of zebro
%   zebros(:, 2): y coordinate of zebro
%   zebros(:, 3): vCeil on x coordinate of zebro
%   zebros(:, 4): vCeil on x coordinate of zebro
%   zebros(:, 5): heading of zebro. (-pi, Pi].
%                     zebros(:, 5)>0 when vX<0. zebros(:, 5)<0 when vX>0.
%   newzebros: zebros information of newest iteration
%   zLength: zebro length
%   zWidth: zebro width
%   skyX: bound on x Axis
%   skyY: bound on y Axix
%   shorPath: set of id of zebros on shortest path
% Written by Pengqi Chen (chenpq1993@gmail.com).
global zebros;
global newzebros;
global zLength zWidth skyX skyY;
global shorPath;
oAngle = atan(zLength / zWidth);
txt1 = '\uparrow';
for t = 1:1:2
    numZebros = size(zebros, 1);            
    %% draw all birds in frame i(code below)
    for jZebro = 1:numZebros
        if(iIter > 1)
            if (t == 1)
                x = zebros(jZebro, 1);
                y = zebros(jZebro, 2);
                anglePi = zebros(jZebro, 5);
                xy = recRot(x, y, oAngle, anglePi); 
            else
                x = newzebros(jZebro, 1);
                y = newzebros(jZebro, 2);
                anglePi = newzebros(jZebro, 5);
                xy = recRot(x, y, oAngle, anglePi); 
            end
        else
            x = newzebros(jZebro, 1);
            y = newzebros(jZebro, 2);
            anglePi = newzebros(jZebro, 5);
            xy = recRot(x, y, oAngle, anglePi);
        end

        if ismember(jZebro,shorPath)
            fill(xy(:, 1),xy(:, 2),'g');
        else
            fill(xy(:, 1),xy(:, 2),'y');  
        end
        
        text(x, y, txt1, 'Rotation', anglePi * 180 / pi, 'HorizontalAlignment', 'center',...
             'VerticalAlignment', 'bottom', 'FontSize', 6, 'FontUnits', 'Inches');
        text(x,y,num2str(jZebro),'Rotation',anglePi*180/pi,'HorizontalAlignment','center',...
             'FontSize', 5, 'FontUnits', 'Inches');
        axis equal;
        hold on;
    end
    title(sprintf('Frame: %d', iIter));
    xlim([0, skyX]);
    ylim([0, skyY]);
    % waitforbuttonpress;
    % Wait for key press or mouse-button click,
    % Can replace 'pause(0.1)'.
    pause(0.1)
    if(iIter < nIter)
        clf;%clf deletes from the current figure all graphics objects whose handles are not hidden 
    elseif(iIter == nIter) && (t == 1)
        clf
    end
end 