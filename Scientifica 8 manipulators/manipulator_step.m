function manipulator_step(app)

%% execute if manipulator type is set to scientifica
if strcmp(app.setup.manipulator_type,'scientifica')
    
  command = sprintf('%s %d','RELZ',app.stepsize.Value*-10); %uses the value of the stepsize field
  for i=1:app.setup.manipulator_number
    if app.checkbox(i).Value == 1    %only do if manipulator is selected
        fprintf(app.s{i},command);   %steps down stepsize input
    end
  end
end