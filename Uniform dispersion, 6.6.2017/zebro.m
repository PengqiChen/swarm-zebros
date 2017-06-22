%% Swarm Dispersion Simulation
%% Written by Pengqi Chen (chenpq1993@gmail.com).

import py.dispersion.new_zebros;

% Zebro property
nZebros = 12;  % Number of zebros
zLength = 2.5; % Zebro length
zWidth = 2;    % Zebro width
speed = 2;     % Speed Ceiling Bound

% Dispersion property
nNeighbors = 2;        % Maximum number of neighbors to avoid
disDanger = 2*zLength; % Dangerous distance
disDisp = 10;          % Neighbor in disDisp may have repusion on the zebro

% Environment variable
SkyX = 60;      % SkyX: bound on x Axis
SkyY = 60;      % SkyY: bound on y Axis

% Initialize zebros
zebros = initZebros(nZebros, zLength, SkyX, SkyY);

%Pre-allocate array zsList
numIters = 100; 
zsList = cell(numIters, 5);
for iIter = 1:numIters
    zsList{iIter} = [0 0 0 0 0];
end

zsList{1} = zebros; % zebros by frame for visualization

% Simulation Iteration
stopFlag=0; % 0, Dispersion has not been finished
            % 1, Approximate dispersion has been finished
            % 2, Final dispersion has been finished
realNumIters=1; % If final dispersion is finished in numIters, realNumIters
                % equals to value of final iteration. Otherwise it equals
                % to numIters.                % 

for iIter = 2:numIters
    % Transform matlab matrix to python array(Necessary, or there will be compiling error)
    % The calculation the Num.6 Zebro is done in Python
    % The calculation of other zebros is done in Matlab
    z6Py = py.numpy.array(zebros(:).');
    z6Py = reshape(z6Py,[5,nZebros]);
    z6Py = py.numpy.transpose(z6Py);
  
    % To get new data for zebro6
    z6Py = new_zebros(z6Py, speed, nNeighbors,disDanger,disDisp);
    z6Py = cell(z6Py);
    z6Py = cellfun(@double,z6Py);
    % Transform python array back to Matlab matrix 
    zebros = newZebros(zebros, speed, nNeighbors,disDanger,disDisp);
    zebros(6, :) = z6Py;
    if stopFlag==0
        realNumIters = iIter;
        % Sum of the speed of zebros on x-axis is less than 1
        % and Sum of the speed of zebros on y-axis is less than 1
        if (sum( abs(zebros(:,3)) )<1)&&(sum( abs(zebros(:,4)) )<1)
            fprintf('Approximate dispersion is finished at %dth iteration\n',iIter);
            stopFlag=1;
        end
    elseif (stopFlag==1)
        % Sum of the speed of zebros on x-axis equals to 0
        % and Sum of the speed of zebros on y-axis equals to 0
            if (sum( abs(zebros(:,3)) )==0)&&(sum( abs(zebros(:,4)) )==0)
                fprintf('Final dispersion is finished at %dth iteration\n',iIter);
                stopFlag=2;
                realNumIters = iIter;
            end
    end
    zsList{iIter} = zebros;
end
% Visualization
viz(zsList, zLength, zWidth, SkyX, SkyY, realNumIters);
