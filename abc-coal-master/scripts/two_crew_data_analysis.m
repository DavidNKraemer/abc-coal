function [ two_cost, two_demurrage, two_crew ] = two_crew_data_analysis(sims)
final = 24 * 7;

two_cost = zeros(sims, final);
two_demurrage = zeros(sims, final);
two_crew = zeros(sims, final);

%mean_cost2 = zeros(1, final);
%mean_demurrage2 = zeros(1, final);
%mean_crew2 = zeros(1, final);

for i = 1:sims
    [two_cost(i,:), two_demurrage(i,:), two_crew(i,:)] = two_crew_week_sim(4);
end


%for i = 1:final
%   mean_cost2(i) = mean(two_cost(:,i)); 
%   mean_demurrage2(i) = mean(two_demurrage(:,i)); 
%   mean_crew2(i) = mean(two_crew(:,i)); 
%end

%annual_cost2 = mean_cost2(end) * 52;
%monthly_demurrage2 = mean_demurrage2(end) * 4;
