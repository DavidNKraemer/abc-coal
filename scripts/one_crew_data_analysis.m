function [ one_cost, one_demurrage, one_crew ] = one_crew_data_analysis(sims)

final = 24 * 7;

one_cost = zeros(sims, final);
one_demurrage = zeros(sims, final);
one_crew = zeros(sims, final);

%mean_cost1 = zeros(1, final);
%mean_demurrage1 = zeros(1, final);
%mean_crew1 = zeros(1, final);

for i = 1:sims
    [one_cost(i,:), one_demurrage(i,:), one_crew(i,:)] = one_crew_week_sim(4);
end


%for i = 1:final
%   mean_cost1(i) = mean(one_cost(:,i)); 
%   mean_demurrage1(i) = mean(one_demurrage(:,i)); 
%   mean_crew1(i) = mean(one_crew(:,i)); 
%end

%annual_cost1 = mean_cost1(end) * 52;
%monthly_demurrage1 = mean_demurrage1(end) * 4;


