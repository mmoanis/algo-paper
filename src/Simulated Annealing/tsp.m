%%%
%%% COPYRIGHT Jyh-Shing Roger Jang
%%% https://www.mathworks.com/matlabcentral/fileexchange/2173-neuro-fuzzy-and-soft-computing?focused=5041127&tab=function&requestedDomain=true
%%%
function out = tsp()
% TSP Traveling salesman problem (TSP) using SA (simulated annealing).
% 	TSP by itself will generate 20 cities within a unit cube and
%	then use SA to slove this problem.
%
% (mmoanis): get Urugay data set.
loc = get_dataset();

% (mmoanis): start recording time
tic
 
NumCity = length(loc);		% Number of cities
distance = zeros(NumCity);	% Initialize a distance matrix
% Fill the distance matrix
for i = 1:NumCity,
	for j = 1:NumCity,
		distance(i, j) = norm(loc(i, :) - loc(j, :));
	end
end

% To generate energy (objective function) from path
%path = randperm(NumCity);
%energy = sum(distance((path-1)*NumCity + [path(2:NumCity) path(1)]));

% Find typical values of dE
count = 20;
all_dE = zeros(count, 1);
for i = 1:count
	path = randperm(NumCity);
	energy = sum(distance((path-1)*NumCity + [path(2:NumCity) path(1)]));
	new_path = path;
	index = round(rand(2,1)*NumCity+.5);
	inversion_index = (min(index):max(index));
	new_path(inversion_index) = fliplr(path(inversion_index));
	all_dE(i) = abs(energy - ...
		sum(sum(diff(loc([new_path new_path(1)],:))'.^2)));
end
dE = max(all_dE);

temp = 10*dE;	% Choose the temperature to be large enough
fprintf('Initial energy = %f\n\n',energy);
 
MaxTrialN = NumCity*100;		% Max. # of trials at a temperature
MaxAcceptN = NumCity*10;		% Max. # of acceptances at a temperature
StopTolerance = 0.005;		% Stopping tolerance
TempRatio = 0.5;		% Temperature decrease ratio
minE = inf;			% Initial value for min. energy
maxE = -1;			% Initial value for max. energy

% Major annealing loop
while (maxE - minE)/maxE > StopTolerance,
	minE = inf;
	maxE = 0;
	TrialN = 0;		% Number of trial moves
	AcceptN = 0;		% Number of actual moves 
	while TrialN < MaxTrialN & AcceptN < MaxAcceptN,
		new_path = path;
		index = round(rand(2,1)*NumCity+.5);
		inversion_index = (min(index):max(index));
		new_path(inversion_index) = fliplr(path(inversion_index)); 
		new_energy = sum(distance( ...
			(new_path-1)*NumCity+[new_path(2:NumCity) new_path(1)]));
		if rand < exp((energy - new_energy)/temp),	% accept it!
			energy = new_energy;
			path = new_path;
			minE = min(minE, energy);
			maxE = max(maxE, energy);
			AcceptN = AcceptN + 1;
		end
		TrialN = TrialN + 1;
	end
	
  % (mmoanis): Disabled - Print information in command window 
	%fprintf('temp. = %f\n', temp);
	%tmp = sprintf('%d ',path);
	%fprintf('path = %s\n', tmp);
	%fprintf('energy = %f\n', energy);
	%fprintf('[minE maxE] = [%f %f]\n', minE, maxE);
	%fprintf('[AcceptN TrialN] = [%d %d]\n\n', AcceptN, TrialN);
	
  % Lower the temperature
	temp = temp*TempRatio;
end

% (mmoanis) end recording time
toc

% (mmoais): plot at the end
out = [path path(1)];
plot(loc(out(:), 1), loc(out(:), 2),'r.', 'Markersize', 20);
axis square; hold on
h = plot(loc(out(:), 1), loc(out(:), 2)); hold off
% Update plot
out = [path path(1)];
set(h, 'xdata', loc(out(:), 1), 'ydata', loc(out(:), 2));
drawnow;
 
% Print sequential numbers in the graphic window
for i = 1:NumCity,
	text(loc(path(i),1)+0.01, loc(path(i),2)+0.01, int2str(i), ...
		'fontsize', 8);
end

