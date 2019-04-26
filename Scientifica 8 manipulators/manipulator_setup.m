function [s]=manipulator_setup(app)
    s = cell(app.setup.manipulator_number,1); %generate s as cell matrix to hold serial objects
    
%% execute if manipulator type is set to scientifica
if strcmp(app.setup.manipulator_type,'scientifica')

    ports = app.setup.scientifica_ports;
    h = waitbar(0,sprintf('Loading %d scientifica serial ports...',app.setup.manipulator_number));

    for i = 1:app.setup.manipulator_number
        s{i} = serial(string(ports(i,2)),'terminator','CR');    %load COM ports with manipulators as serial objects
        fopen(s{i});                                            %opens serial ports
        waitbar(i / app.setup.manipulator_number)
    end
    close(h)
end
