function manipulator_move_pressure(app)
%move manipulators to cleaning solution and run the cleaning protocol

%% execute if manipulator type is set to scientifica
if strcmp(app.setup.manipulator_type,'scientifica') 

    %manipulator_selected = {1,0,1,0,1,0,1,0}; %array indicating which manipulator to move
    s = app.s;
    n = app.setup.manipulator_number;
    startpos = cell(n,1);     %defines startpos as nx1 array
    homeout = cell(n,1);      %array for storing homeout positions

    offsetz_cleaning=3000;    %z offset for position in cleaning bath
    offsetz=22500;            %z-offset for expelling position 2.25 mm above slice
    offsetx=60000;            %x-offset for explelling position, 6 mm from slice center

    %save starting position and acceleration and speed
    for i=1:n
        if app.cleaning(i).Value == 1
            flushinput(s{i});       %flush serial inputs to prevent reading previous inputs
            fprintf(s{i},'P');      %asks for position coordinate of manipulator
            startpos{i}=str2double(strsplit(fgetl(s{i})));  %saves the coordinate as startpos
            fprintf(s{i},'ACC');    %asks for acceleration value
            acceleration{i}=str2double(fgetl(s{i}));
            fprintf(s{i},'TOP');    %asks for top speed value
            topspeed{i}=str2double(fgetl(s{i}));
        end
    end

    %set low spped and high acceleration to move out of slice
    for i=1:n
        if app.cleaning(i).Value == 1
            fprintf(s{i},'ACC 1000');
            fgetl(s{i});        
            fprintf(s{i},'TOP 1000');
            fgetl(s{i});
        end
    end

    %move manipulators slowly out of slice
    for i=1:n
        if app.cleaning(i).Value == 1
            fprintf(s{i},'REL 6000 0 3000'); %move to home out for 600/300 µm very slowly
            fgetl(s{i});
        end
    end

    %query status of manipulators and stop loop when all are idle (status=0)
    status(1:n)=1;                  %set status variable to 1
    while any(status > 0)
        for i = 1:n
            fprintf(s{i},'S');      %asks for status, not moving = 0
            status(i) = str2double(fgetl(s{i}));
        end
    end

    %set high acceleration and speed
    for i=1:n
        if app.cleaning(i).Value == 1
            fprintf(s{i},'ACC 500');
            fgetl(s{i});        
            fprintf(s{i},'TOP 50000');
            fgetl(s{i});
        end
    end

    %moves manipulator to home out position
    for i=1:n
        if app.cleaning(i).Value == 1
            fprintf(s{i},'OUT'); %move to home out
            fgetl(s{i});
        end
    end

    %query status of manipulators and stop loop when all are idle (status=0)
    status(1:n)=1;                  %set status variable to 1
    while any(status > 0)
        for i = 1:n
            fprintf(s{i},'S');          %asks for status, not moving = 0
            status(i) = str2double(fgetl(s{i}));
        end
    end

    %save home out coordinates
    for i=1:n
        if app.cleaning(i).Value == 1
            fprintf(s{i},'P');
            homeout{i}=str2double(strsplit(fgetl(s{i})));
        end
    end

    %move manipulators down into cleaning solution to z position with offset
    for i=1:n
        if app.cleaning(i).Value == 1
           bathposz=sprintf('%s %d','ABSZ',startpos{i}(3)+offsetz_cleaning); %moves to the same z-position as in bath
           fprintf(s{i},bathposz);
           fgetl(s{i});
         end
    end

    %query status of manipulators and stop loop when all are idle (status=0)
    status(1:n)=1;                  %set status variable to 1
    while any(status > 0)
        for i = 1:n
            fprintf(s{i},'S');          %asks for status, not moving = 0
            status(i) = str2double(fgetl(s{i}));
        end
    end

    %function to control arduino board and valves
    valve_cleaning(app)

    %move to saved home out position, because second 'out' command would be buggy
    for i=1:n
        if app.cleaning(i).Value == 1
            fprintf(s{i},sprintf('%s %d','ABSZ',homeout{i}(3)));        
            fgetl(s{i});
        end
    end

    %query status of manipulators and stop loop when all are idle (status=0)
    status(1:n)=1;                  %set status variable to 1
    while any(status > 0)
        for i = 1:n
            fprintf(s{i},'S');          %asks for status, not moving = 0
            status(i) = str2double(fgetl(s{i}));
        end
    end

    %set lower acceleration and speed
    for i=1:n
        if app.cleaning(i).Value == 1
            fprintf(s{i},'ACC 500');
            fgetl(s{i});        
            fprintf(s{i},'TOP 20000');
            fgetl(s{i});
        end
    end

    %moves to distant position in acsf bath
    for i=1:n
        if app.cleaning(i).Value == 1
            targetpos=sprintf('%s %d %d %d','ABS',startpos{i}(1)+offsetx,startpos{i}(2),startpos{i}(3)+offsetz); 
            fprintf(s{i},targetpos);
            fgetl(s{i});
        end
    end

    %query status of manipulators and stop loop when all are idle (status=0)
    status(1:n)=1;                  %set status variable to 1
    while any(status > 0)
        for i = 1:n
            fprintf(s{i},'S');          %asks for status, not moving = 0
            status(i) = str2double(fgetl(s{i}));
        end
    end

    %call function to expel in ACSF for 10s
    valve_expel(app);

    %set higher acceleration and lower speed
    for i=1:n
        if app.cleaning(i).Value == 1
            fprintf(s{i},'ACC 1000');
            fgetl(s{i});        
            fprintf(s{i},'TOP 10000');
            fgetl(s{i});
        end
    end

    %move manipulators to 300µm above last recording position
    for i=1:n
        if app.cleaning(i).Value == 1
            finalpos=sprintf('%s %d %d %d','ABS',startpos{i}(1),startpos{i}(2),startpos{i}(3)+3000); %offset 300µm in z
            fprintf(s{i},finalpos);
            fgetl(s{i});
        end
    end

    %query status of manipulators and stop loop when all are idle (status=0)
    status(1:n)=1;                  %set status variable to 1
    while any(status > 0)
        for i = 1:n
            fprintf(s{i},'S');          %asks for status, not moving = 0
            status(i) = str2double(fgetl(s{i}));
        end
    end

    %set acceleration and speed back to before
    for i=1:n
        if app.cleaning(i).Value == 1    
            fprintf(s{i},'ACC');
            fprintf(s{i},sprintf('%s %d','ACC',acceleration{i}));
            fgetl(s{i});      
            fprintf(s{i},'TOP');
            fprintf(s{i},sprintf('%s %d','TOP',topspeed{i}));
            fgetl(s{i});
        end
    end

else        %in case of no automatic manipulator control
    answer=questdlg('Please move pipette into cleaning solution and click "Clean"',...
                    'Wait for manual manipulator movement',...
                    'Clean','Stop','Stop');
        if strcmp(answer,'Clean')
             valve_cleaning(app);     %control arduino board and valves to perform cleaning sequence
                    answer=questdlg('Please move pipette to distant position in the recording chamber and click "Expel"',...
                                    'Wait for manual manipulator movement',...
                                    'Expel','Stop','Stop');
             if strcmp(answer,'Expel')
                 valve_expel(app);    %control arduino board and valves to perform expelling sequence for 10s
                 msgbox('Cleaning sequence finished, pipette can now be reused');
             end
        end    
end







%%execute if manipulator type is sensapex

if strcmp(app.setup.manipulator_type,'sensapex')
    
    n = app.setup.manipulator_number; %the number of manipulators that are being used
    
    %this paragraph loads the sensapex library
    %clc
    %clear all
    [notfound,warnings]=loadlibrary('ump.dll','libump.h','alias','ump')
    libfunctions  ump
    %libfunctionsview('ump')
    [ump_handle, st] = calllib('ump','ump_open','169.254.255.255',uint32(20),int32(0));

    try 
        calllib('ump','ump_receive',ump_handle,uint32(100));
        
        %saving the startposition of the manipulators in a cell array
        startpos = cell(10,3);
        
        for i = 1:n
            if app.checkbox(i).Value == 1
                calllib('ump','ump_read_positions_ext',ump_handle, uint32(i), uint32(-1));
                startpos{i,1} = calllib('ump','ump_get_position_ext',ump_handle,uint32(i),uint8('x'))
                startpos{i,2} = calllib('ump','ump_get_position_ext',ump_handle,uint32(i),uint8('y'))
                startpos{i,3} = calllib('ump','ump_get_position_ext',ump_handle,uint32(i),uint8('z'))
            end
        end 
        
        %moving the manipulators to the position 100, 10000, default
        for i = 1:n
            if app.checkbox(i).Value == 1
                speed = 4000;
                move_mode = 0;
                calllib('ump','ump_goto_position_ext',ump_handle, uint32(i), uint32(100*1000), uint32(10000*1000), uint32((startpos{i,3})),uint32(0),uint32(speed), uint32(move_mode))
            end
        end
        pause(9);
        
        %moving the manipulators into the cleaning solution (to 100, 10000,
        %starpos + 100)
        for i = 1:n
            if app.checkbox(i).Value == 1
                speed = 4000;
                move_mode = 0;
                z_axis = uint32(((startpos{i,3})-(100*1000)) + (sind(27)*((startpos{i,1}) - 100*1000)))
                if z_axis > 20000000 %this if statement is necessary, because if the z_axis exceeds the range of the manipulator, then the manipulator won't move
                    calllib('ump','ump_goto_position_ext',ump_handle, uint32(i), uint32(100*1000), uint32(10000*1000), uint32((20000*1000)),uint32(0),uint32(speed), uint32(move_mode))
                else
                    calllib('ump','ump_goto_position_ext',ump_handle, uint32(i), uint32(100*1000), uint32(10000*1000), uint32(z_axis),uint32(0),uint32(speed), uint32(move_mode))
                    pause(1);
                end
            end
        end
        pause(4);
        
        %set valves to cleaning configuration
        for i = 1:n
            if app.checkbox(i).Value == 1
                app.cleaning(i).Value = app.checkbox(i).Value;
                setvalve(app.a,app.pipette_valves,i,'Clean');
            end
        end 
        
        %running the cleaning pressure protocol
        valve_cleaning(app);
        
        %after clean set cleaned pipette to low while moving into the acsf
        %for expelling
        for i = 1:n
            if app.checkbox(i).Value == 1
                app.low(i).Value = app.checkbox(i).Value;
                setvalve(app.a,app.pipette_valves,i,'Low');
            end
        end
        pause(1);
        
        %moving manipulators back to acsf --> x-offset of 7000 µm
        for i = 1:n
            if app.checkbox(i).Value == 1
                speed = 4000;
                move_mode = 0;
                calllib('ump','ump_goto_position_ext',ump_handle, uint32(i), uint32(((startpos{i,1})-(7000*1000))), uint32((startpos{i,2})), uint32(((startpos{i,3})+(500*1000))),uint32(0),uint32(speed), uint32(move_mode));
                pause(1);
            end
        end
        pause(8);
        
        %set valves back to cleaning configuration
        for i = 1:n
            if app.checkbox(i).Value == 1
                app.cleaning(i).Value = app.checkbox(i).Value;
                setvalve(app.a,app.pipette_valves,i,'Clean');
            end
        end 
        
        %running the expel pressure protocol
        valve_expel(app);
        
        %after clean set cleaned pipette to low
        for i = 1:n
            if app.checkbox(i).Value == 1
            app.low(i).Value = app.checkbox(i).Value;
            setvalve(app.a,app.pipette_valves,i,'Low');
            end
        end
        
        %moving manipulators back to slice surface --> z-offset of 300 µm
        for i = 1:n
            if app.checkbox(i).Value == 1
                speed = 4000;
                move_mode = 0;
                calllib('ump','ump_goto_position_ext',ump_handle, uint32(i), uint32(((startpos{i,1})-(8000*1000))), uint32((startpos{i,2})), uint32(((startpos{i,3})-(300*1000))),uint32(0),uint32(speed), uint32(move_mode));
                pause(2);
                calllib('ump','ump_goto_position_ext',ump_handle, uint32(i), uint32((startpos{i,1})), uint32((startpos{i,2})), uint32(((startpos{i,3})-(300*1000))),uint32(0),uint32(speed), uint32(move_mode));
            end
        end

    %% Error hadnling, in case of error, we must make sure socket is closed. Otherwise matlab keeps socket open and next run does not work.
    catch ME
       calllib('ump','ump_close',ump_handle);
       fprintf('Closing ump anyways');
       rethrow(ME)
    end 
    %% IMPORTANT! Close socket connection always!
    calllib('ump','ump_close',ump_handle)
    
    
    else        %in case of no automatic manipulator control
    answer=questdlg('Please move pipette into cleaning solution and click "Clean"',...
                    'Wait for manual manipulator movement',...
                    'Clean','Stop','Stop');
        if strcmp(answer,'Clean')
             valve_cleaning(app);     %control arduino board and valves to perform cleaning sequence
                    answer=questdlg('Please move pipette to distant position in the recording chamber and click "Expel"',...
                                    'Wait for manual manipulator movement',...
                                    'Expel','Stop','Stop');
             if strcmp(answer,'Expel')
                 valve_expel(app);    %control arduino board and valves to perform expelling sequence for 10s
                 msgbox('Cleaning sequence finished, pipette can now be reused');
             end
        end
    
end

