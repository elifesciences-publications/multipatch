function manipulator_stop(app)
%stops all manipulator movements
%% execute if manipulator type is set to scientifica
if strcmp(app.setup.manipulator_type,'scientifica')
    
    for i = 1:app.setup.manipulator_number
        fprintf(app.s{i},'STOP');
        fgetl(app.s{i});
    end
end