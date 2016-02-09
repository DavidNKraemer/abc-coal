function [ three_cost, three_demurrage, three_crew ] = three_crew_data_analysis(sims)
final = 24 * 7;

three_cost = zeros(sims, final);
three_demurrage = zeros(sims, final);
three_crew = zeros(sims, final);

%mean_cost3 = zeros(1, final);
%mean_demurrage3 = zeros(1, final);
%mean_crew3 = zeros(1, final);

for i = 1:sims
    [three_cost(i,:), three_demurrage(i,:), three_crew(i,:)] = three_crew_week_sim(4);
end


%for i = 1:final
%   mean_cost3(i) = mean(three_cost(:,i)); 
%   mean_demurrage3(i) = mean(three_demurrage(:,i)); 
%   mean_crew3(i) = mean(three_crew(:,i)); 
%end

%annual_cost3 = mean_cost3(end) * 52;
%monthly_demurrage3 = mean_demurrage3(end) * 4;
