function [mvstate]=setvalve(a,mv,manip_selected,mv_pressure)
%% determine valve states depending on needed pressure

if strcmp(mv_pressure,'Air')
    mvstate = [1,1,1,1];
    
elseif strcmp(mv_pressure,'Clean')
    mvstate = [0,1,1,1];
    
elseif strcmp(mv_pressure,'Low')
    mvstate = [1,1,0,1];
    
elseif strcmp(mv_pressure,'High')
    mvstate = [0,0,1,0];
    
elseif strcmp(mv_pressure,'Patch')
    mvstate = [0,0,1,1];
    
else
    mvstate = [1,1,1,1];
end



%% control valves of specified manipulators

for mv_index = 1:4     
    a.digitalWrite(mv(manip_selected,mv_index),mvstate(mv_index));
end