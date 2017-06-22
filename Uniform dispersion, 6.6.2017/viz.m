function [] = viz(zsList, zLength, zWidth, SkyX, SkyY, nIter)
% To visualize the zebros
% Input:
%   zsList: List with all zebros' information of every iteration
%   zLength: zebro length
%   zWidth: zebro width
%   SkyX: bound on x Axis
%   SkyY: bound on y Axix
%   nIter: number of iterations to finish the dispersion
% Written by Pengqi Chen (chenpq1993@gmail.com).
oAngle = atan(zLength / zWidth);
txt1 = '\uparrow';
for iIter = 1:nIter% 1:1:nIter draw fram i every iteration 
    for t = 1:1:2
        numZebros = size(zsList{1}, 1);
        %% draw all birds in frame i(code below)
        for jZebro = 1:numZebros
            if(iIter > 1)
                if (t == 1)
                    x = zsList{iIter - 1}(jZebro, 1);
                    y = zsList{iIter - 1}(jZebro, 2);
                    anglePi = zsList{iIter}(jZebro, 5);
                    xy = recRot(zLength, zWidth, x, y, oAngle, anglePi); 
                else
                    x = zsList{iIter}(jZebro, 1);
                    y = zsList{iIter}(jZebro, 2);
                    anglePi = zsList{iIter}(jZebro, 5);
                    xy = recRot(zLength, zWidth, x, y, oAngle, anglePi); 
                end
            else
                x = zsList{iIter}(jZebro, 1);
                y = zsList{iIter}(jZebro, 2);
                anglePi = zsList{iIter}(jZebro, 5);
                xy = recRot(zLength, zWidth, x, y, oAngle, anglePi);
            end

            fill(xy(:, 1),xy(:, 2),'g'); 
            if (jZebro == 6) 
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
        xlim([0, SkyX]);
        ylim([0, SkyY]);
        % w = waitforbuttonpress;
        % Wait for key press or mouse-button click,
        % Can replace 'pause(0.1)'.
        pause(0.1)
        if(iIter < nIter)
            clf;%clf deletes from the current figure all graphics objects whose handles are not hidden 
        elseif(iIter == nIter) && (t == 1)
            clf
        end
    end 
end
end
