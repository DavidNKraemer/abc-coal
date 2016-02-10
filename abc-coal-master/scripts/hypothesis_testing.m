%% preliminaries
sims = 500;
final = 24 * 7;

%% obtain necessary total cost, demurrage cost, and crew cost data
load_data = 1;

if load_data
    load('C:\Users\kraemerd17\Documents\abc-coal-master\data\cost_array.mat');
    load('C:\Users\kraemerd17\Documents\abc-coal-master\data\crew_array.mat');
    load('C:\Users\kraemerd17\Documents\abc-coal-master\data\demurrage_array.mat');
else
    cost = zeros(3, sims, final);
    demurrage = zeros(3, sims, final);
    crew = zeros(3, sims, final);
    
    [cost(1,:,:), demurrage(1,:,:), crew(1,:,:)] = one_crew_data_analysis(sims);
    [cost(2,:,:), demurrage(2,:,:), crew(2,:,:)] = two_crew_data_analysis(sims);
    [cost(3,:,:), demurrage(3,:,:), crew(3,:,:)] = three_crew_data_analysis(sims);
end

mean_cost = zeros(3, final);
mean_demurrage = zeros(3, final);
mean_crew = zeros(3, final);

stdev_cost = zeros(3, final);
stdev_demurrage = zeros(3, final);
stdev_crew = zeros(3, final);

%% compute averages
for i = 1:3
    for j = 1:final
        mean_cost(i,j) = mean(cost(i,:,j));
        mean_demurrage(i,j) = mean(demurrage(i,:,j));
        mean_crew(i,j) = mean(crew(i,:,j));
        
        stdev_cost(i,j) = std(cost(i,:,j));
        stdev_demurrage(i,j) = std(demurrage(i,:,j));
        stdev_crew(i,j) = std(crew(i,:,j));
    end
end

%% for the presentation

annual_cost = 52 * mean(cost(:,:,end).');
annual_std = 52 * std(cost(:,:,end).');

monthly_demurrage = 4 * mean(demurrage(:,:,end).');
monthly_std = 4 * std(cost(:,:,end).');






