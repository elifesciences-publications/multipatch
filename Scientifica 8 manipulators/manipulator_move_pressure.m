function manipulator_move_pressure(app)
%move manipulators to cleaning solution

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

