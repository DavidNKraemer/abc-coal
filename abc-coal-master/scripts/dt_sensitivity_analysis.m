%% preliminaries
sims = 500;
dt = [0.5 1.0 1.5];

final = int64(24 * 7 * dt.^(-1));
n = 4;

tipple = 1.5;
engine_cost = 5000;

% dimension labels: dt value, configuration number, simulation, week length 
[cost_low_one dem_low_one crew_low_one] = one_crew_week_sim_sensitivity(sims, dt(1), tipple, engine_cost);
[cost_mid_one dem_mid_one crew_mid_one] = one_crew_week_sim_sensitivity(sims, dt(2), tipple, engine_cost);
[cost_high_one dem_high_one crew_high_one] = one_crew_week_sim_sensitivity(sims, dt(3), tipple, engine_cost);

[cost_low_two dem_low_two crew_low_two] = two_crew_week_sim_sensitivity(sims, dt(1), tipple, engine_cost);
[cost_mid_two dem_mid_two crew_mid_two] = two_crew_week_sim_sensitivity(sims, dt(2), tipple, engine_cost);
[cost_high_two dem_high_two crew_high_two] = two_crew_week_sim_sensitivity(sims, dt(3), tipple, engine_cost);

[cost_low_three dem_low_three crew_low_three] = three_crew_week_sim_sensitivity(sims, dt(1), tipple, engine_cost);
[cost_mid_three dem_mid_three crew_mid_three] = three_crew_week_sim_sensitivity(sims, dt(2), tipple, engine_cost);
[cost_high_three dem_high_three crew_high_three] = three_crew_week_sim_sensitivity(sims, dt(3), tipple, engine_cost);
