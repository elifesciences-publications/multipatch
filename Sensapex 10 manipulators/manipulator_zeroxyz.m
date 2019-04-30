function manipulator_zeroxyz(app)
if strcmp(app.setup.manipulator_type,'scientifica')
  for i=1:app.setup.manipulator_number
    if app.checkbox(i).Value == 1    %only do if manipulator is selected
        fprintf(app.s{i},'ZERO'); %sets X,Y,Z axis to zero of passed serial object
        fgetl(app.s{i});
    end
  end
end