function [ output ] = PID_controller( kp, ki, kd, input, set_point, distrubance, range )
    global A;

    persistent prev_e;
    persistent sum_e; 
    
    if A.init == 0
        prev_e = 0;
        sum_e = 0;
    end
    
    if distrubance ~= 0
        e_dist = randi(distrubance*2) - distrubance; % error introduced = +-distrubance
    end
    
    error = set_point - input;
    
    sum_e = sum_e + error;
    
    output = kp * error + ki * sum_e + (error - prev_e) * kd + e_dist;
    
    prev_e = error;

    if output < range(1)
        output = range(1);
    else if output > range(2)
        output = range(2);
    end
    
end

