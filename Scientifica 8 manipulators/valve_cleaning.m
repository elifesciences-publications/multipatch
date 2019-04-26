function valve_cleaning(app)
    h=waitbar(0,'Suction for 4s');

%suction for 4s
    app.a.digitalWrite(app.vacuum1,0);
    app.a.digitalWrite(app.vacuum2,0);
    app.a.digitalWrite(app.pressure,1);
    
    for i = 1:4
        pause(1)
        waitbar(i/24,h,'Suction for 4s');
    end
    waitbar(4/24,h,'5 cycles of expelling and suction for 1s each');
for i = 1:5 %5 repititions
    %pressure for 1s
    app.a.digitalWrite(app.vacuum1,1);
    app.a.digitalWrite(app.vacuum2,1);
    app.a.digitalWrite(app.pressure,0);
    pause(1)
    waitbar((4+(2*i-1))/24);
    
    %suction for 1s
    app.a.digitalWrite(app.vacuum1,0);
    app.a.digitalWrite(app.vacuum2,0);
    app.a.digitalWrite(app.pressure,1);
    pause(1)
    waitbar((4+(2*i))/24);
end
    waitbar(14/24,h,'Expelling for 10s');
    %pressure for 10s
    app.a.digitalWrite(app.vacuum1,1);
    app.a.digitalWrite(app.vacuum2,1);
    app.a.digitalWrite(app.pressure,0);
    
    for i = 1:10
        pause(1)
        waitbar((14+i)/24);
    end
   
    %valves close
    app.a.digitalWrite(app.vacuum1,1);
    app.a.digitalWrite(app.pressure,1);
    
    %release pressure through vaccum generator
    app.a.digitalWrite(app.vacuum2,0);
    pause(0.5)
    app.a.digitalWrite(app.vacuum2,1);
    
    close(h);