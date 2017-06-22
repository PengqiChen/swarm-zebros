%% Swarm Dispersion/Coverage Simulation
%% Written by Pengqi Chen (chenpq1993@gmail.com).
% Zebro property
clear global;
global zLength;
global zWidth;
nZebros = 20;  % Number of zebros
zLength = 2.5; % Zebro length
zWidth = 2;    % Zebro width
vCeil = 4;     % Speed Ceiling Bound
aCeil = 1;     % Acceleration Ceiling Bound
% Dispersion property
nNeighbors = 3;          % Maximum number of neighbors to avoid
disDanger = 2 * zLength; % Dangerous distance
disDisp = 25;            % Neighbor in disDisp may have repusion on the zebro

% Environment variable
global skyX; 
global skyY;
skyX = 100;      % SkyX: bound on x Axis
skyY = 100;      % SkyY: bound on y Axis

% Initialize zebros
global zebros;
global newzebros;
zebros = initZebros(nZebros);
newzebros = zebros;
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
    newzebros = newZebros(vCeil, nNeighbors, disDanger, disDisp);
    if stopFlag==0
        realNumIters = iIter;
        % Sum of the vCeil of zebros on x-axis is less than 1
        % and Sum of the vCeil of zebros on y-axis is less than 1
        if (sum( abs(zebros(:,3)) )<1)&&(sum( abs(zebros(:,4)) )<1)
            fprintf('Approximate dispersion is finished at %dth iteration\n',iIter);
            stopFlag = 1;
        end
    elseif (stopFlag == 1)
        % Sum of the vCeil of zebros on x-axis equals to 0
        % and Sum of the vCeil of zebros on y-axis equals to 0
        if (sum( abs(zebros(:, 3)) ) == 0) && (sum( abs(zebros(:, 4)) ) == 0)
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
%% To calculate the shortest path from source zebro to destination zebro 
global shorPath;     % Set of ids of zebros on shortest path
                     % shorPath(1) is the id of destination zebro
global zebroXY;      % Positions(coordinates) of zebros
global success;      % Suceess = 0, source zebro has not arrived destination
                     % Suceess = 1, source zebro has arrived destination
global range;        % Detection range
range = 26;        
zebros = newzebros;
sZebro = 1;          % Id of sourse zebro
dZebro = nZebros;    % Id of destination zebro
nPos = zebros(1:nZebros, 1:2);
zebroXY = struct('pos', mat2cell(nPos, ones(nZebros, 1), 2));  % Position of node (1x2 number)
shorPath = dijkstra(sZebro, dZebro);
disp('Shortest path: From destination to source \n');
fprintf('%d\n',shorPath);
fprintf('shorPath(1): %d\n',shorPath(1));

%% To move from source to destination by shortest path
vCeil = 5;              
success = 0;
numIter = 100;          
for iIter= 1:numIter
    zebros(sZebro, :) = newSZebro(sZebro, vCeil, aCeil, disDanger);
    if success == 1
        numIter = iIter;    
        break;
    end
    newzebros = zebros;
    viz(iIter, numIter);
end
viz(iIter, numIter);
clear shortest_Path;    