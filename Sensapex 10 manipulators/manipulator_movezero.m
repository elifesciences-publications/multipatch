function manipulator_movezero(app)
  %% execute if manipulator type is set to scientifica  
if strcmp(app.setup.manipulator_type,'scientifica')
  for i=1:app.setup.manipulator_number
    if app.checkbox(i).Value == 1    %only do if manipulator is selected
        fprintf(app.s{i},'ABS 0 0 0'); %move to coordinate 0 0 0
        fgetl(app.s{i}); 
    end
  end
end