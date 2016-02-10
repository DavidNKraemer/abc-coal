function [ cost, demurrage, crew ] = one_crew_week_sim( n )

%Main script for loading fee: two parts: wait for A loading and wait for B
%loading

% cheack train 2 and train 1 status
endTime = 24*7;
dt = 1/1;

arrivals = zeros(7,n);

for i = 1:7
    arrivals(i,:) = sort(randi([((i-1)*24) / dt, (15 + (i-1)*24) / dt], 1, n) * dt);
end

dayCounter = 0;


arrivals(:,1) = 40000;
arrivals(5,1) = randi([(6 + (5-1)*24) / dt, (8 + (5-1)*24) / dt], 1, 1) * dt;


%arrivals = [0 0 0];

arrived = zeros(1,n);
loading = zeros(1,n);
loaded = zeros(1,n);
gone    = zeros(1,n);
waiting = zeros(1,n);% n is the number of trains expected


trainCost = ones(1,n) * 5000 * 3 * dt;
trainCost(1,1) = 5000 * 5 * dt;

crewFlag = 0;

time = 0.0;
cost = zeros(1, endTime / dt);
demurrage = zeros(1, endTime / dt);
crew = zeros(1, endTime / dt);

interval = 1;

tipple = 1.5;


while (time < endTime / dt)
    crewCost = 9000.0;
    
    % the goal is to determine which trains are incurring demurrage costs
    % if arrived(1, i) = 1, then train i has arrived at the coal factory
    % if loading(1, i) = 1, then train i is loading coal
    % the number loaded(1,i) indicates how much coal is loaded on train i
    % if waiting(1, i) = 1, then train i is incurring demurrage costs
    % if gone(1, i) = 1, then train i has fully loaded and left the
    % factory
    
    if mod(time, 24/dt) == 0
        dayCounter = dayCounter + 1;
        arrived = zeros(1,n);
        loading = zeros(1,n);
        loaded  = zeros(1,n);
        gone    = zeros(1,n);
        waiting = zeros(1,n);
    end
    
    
    % Super Train considerations
    
    if dayCounter ~= 5 || time < arrivals(5,1)
        arrived(1,1) = 0;
    else
        arrived(1,1) = 1;
        
        % plan of attack
        %   - first, check if the Super Train has finished loading
        %   - second, check if the Super Train is currently loading
        %       * is tipple < 0.5? Reload the tipple
        %       * otherwise, load the Super Train
        %   - third, check if the Super Train can go to the loading station
        %       * someone else is loading?
        %       * if tipple < 0.5, stay in waiting
        %   - otherwise, send the Super Train to the waiting queue
        
        if loaded(1,1) == 2
            waiting(1,1) = 0;
            loading(1,1) = 0;
            gone(1,1) = 1;
        elseif loading(1,1)
            if tipple <= 0.0
                % reload tipple
                waiting(1,1) = 1;
                loading(1,1) = 0;
            else
                loading(1,1) = 1;
                waiting(1,1) = 0;
                % load the train
                loaded(1,1) = min(2, loaded(1,1) + min(tipple, 1/3 * dt));
            end
        elseif not(sum(loading(1,2:n)))
            if tipple <= 0.0
                waiting(1,1) = 1;
                loading(1,1) = 0;
            else
                loading(1,1) = 1;
                waiting(1,1) = 0;
                % load the train
                loaded(1,1) = min(2, loaded(1,1) + min(tipple, 1/3 * dt));
            end
        else
            loading(1,1) = 0;
            waiting(1,1) = 1;
        end
    end
    
    
    
    % Normal trains...
    for i = 2:n
        % first, determine if the train has arrived
        if time < arrivals(dayCounter,i)
            arrived(1,i) = 0;
        else
            % assume that the train has arrived!
            arrived(1,i) = 1;
            
            % if the train has finished loading, leave
            if loaded(1,i) == 1
                loading(1,i) = 0;
                waiting(1,i) = 0;
                gone(1, i) = 1;
                
                
                % otherwise, if the train is currently loading, load some more
            elseif loading(1,i)
                loaded(1,i) = min(1, loaded(1,i) + min(1/3 * dt, tipple));
                loading(1, i) = 1;
                waiting(1,i) = 0;
                gone(1, i) = 0;
                
                % finally, if the train is not currently loading...
            else
                % if the tipple is insufficiently filled, go to the waiting
                % queue
                if tipple < 1 - loaded(1,i)
                    waiting(1,i) = 1;
                    loading(1,i) = 0;
                    
                    % if no one is loading, and no one is waiting (except maybe
                    % you), then go to loading
                elseif not(sum(loading)) && not(sum(waiting(1:(i-1))))
                    loading(1,i) = 1;
                    waiting(1,i) = 0;
                    loaded(1,i) = min(1, loaded(1,i) + min(tipple,1/3 * dt));
                else
                    waiting(1,i) = 1;
                end
            end
        end
    end
    
    % Determining what is going on with the tipple
    if sum(loading)
        tipple = max(0, tipple - 1/3 * dt);
        crewFlag = 0;
    else
        if tipple < 1 && sum(waiting)
            tipple = min(1.5, tipple + 1/4 * dt);
            crewFlag = 1;
            crewCost = 9000.0;
        elseif tipple < 1.5 && not(sum(waiting))
            tipple = min(1.5, tipple + 1/4 * dt);
            crewFlag = 1;
        else
            crewFlag = 0;
        end
    end
    
    
    waitingCost = waiting * (trainCost.');
    
    
    intervalCrewCost = crewFlag * crewCost * dt;
    
    intervalCost = waitingCost + intervalCrewCost;
    
    
    %     fprintf('time (%1.0f): %1.0f, %1.2f\n', time, dayCounter, mod(time, 24 * dt));
    %     fprintf('waitingCost: %1.0f\n', waitingCost);
    %     fprintf('intervalCrewCost: %1.0f\n', intervalCrewCost);
    %     fprintf('loaded: %1.2f\n', loaded);
    %     fprintf('tipple: %1.2f\n\n', tipple);
    
    if interval > 1
        cost(interval) = cost(interval - 1) + intervalCost;
        demurrage(interval) = demurrage(interval - 1) + waitingCost;
        crew(interval) = crew(interval - 1) + intervalCrewCost;
    else
        cost(interval) = intervalCost;
        demurrage(interval) = waitingCost;
        crew(interval) = intervalCrewCost;
    end
    
    time = time + dt;
    interval = interval + 1;
    
end
end