%% Swarm Dispersion/Coverage Simulation
%% Written by Pengqi Chen (chenpq1993@gmail.com).
% Zebro property
clear global;
global zLength;
global zWidth;
nZebros = 16;  % Number of zebros
%nZebros = 10;  % Number of zebros
zLength = 2.5; % Zebro length
zWidth = 2;    % Zebro width
vCeil = 4;     % Speed Ceiling Bound
aCeil = vCeil/2;     % Acceleration Ceiling Bound
% Dispersion property
nNeighbors = 3;          % Maximum number of neighbors to avoid
disDanger = 2 * zLength; % Dangerous distance
%disDisp = 10;            % Neighbor in disDisp may have repusion on the zebro

% Environment variable
global skyX; 
global skyY;
skyX = 100;      % SkyX: bound on x Axis
skyY = 100;      % SkyY: bound on y Axis

% Initialize zebros
global zebros;
global newzebros;
global range;
range = 15;
newzebros = initZebros(nZebros);
%newzebros = zebros;
% Pre-allocate array zsList
numIters = 100; 

% Simulation Iteration
stopFlag = 0;     % 0, Dispersion has not been finished
                  % 1, Approximate dispersion has been finished
                  % 2, Final dispersion has been finished
realNumIters = 1; % If final dispersion is finished in numIters, realNumIters
                  % equals to value of final iteration. Otherwise it equals
                  % to numIters.                 
%% To perform uniform dispersion
for iIter = 2:numIters
    zebros = newzebros;
    for izebro = 1:nZebros
        newzebros(izebro, :) = newZebroi(izebro);
    end
    if stopFlag==0
        realNumIters = iIter;
        % Sum of the vCeil of zebros on x-axis is less than 1
        % and Sum of the vCeil of zebros on y-axis is less than 1
        if (sum( abs(newzebros(:, 3)) ) < 0.5)&&(sum( abs(newzebros(:, 4)) ) < 0.5)
            fprintf('Approximate dispersion is finished at %dth iteration\n', iIter);
            stopFlag = 1;
        end
    elseif (stopFlag == 1)
        % Sum of the vCeil of zebros on x-axis equals to 0
        % and Sum of the vCeil of zebros on y-axis equals to 0
        if (sum( abs(newzebros(:, 3)) ) == 0) && (sum( abs(newzebros(:, 4)) ) == 0)
            fprintf('Final dispersion is finished at %dth iteration\n', iIter);
            stopFlag = 2;
            realNumIters = iIter;
        end
    end
    % Visualization
    viz(iIter, numIters);
    if stopFlag == 2
        break;
    end
end
viz(iIter, realNumIters);