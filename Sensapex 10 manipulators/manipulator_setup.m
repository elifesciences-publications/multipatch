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

%% execute if manipulator type is set to sensapex
if strcmp (app.setup.manipulator_type, 'sensapex')
    
    %clc
    %clear all
    [notfound,warnings]=loadlibrary('ump.dll','libump.h','alias','ump')
    libfunctions  ump
    %libfunctionsview('ump')
    [ump_handle, st] = calllib('ump','ump_open','169.254.255.255',uint32(20),int32(0));

    try 
    %% Error hadnling, in case of error, we must make sure socket is closed. Otherwise matlab keeps socket open and next run does not work.
    catch ME
       calllib('ump','ump_close',ump_handle);
       fprintf('Closing ump anyways');
       rethrow(ME)
    end 
    %% IMPORTANT! Close socket connection always!
    calllib('ump','ump_close',ump_handle);
    
end