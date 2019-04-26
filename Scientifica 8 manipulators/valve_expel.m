function valve_expel(app)
    h=waitbar(0,'Expelling for 10s');
%pressure for 10sec
    app.a.digitalWrite(app.vacuum1,1);
    app.a.digitalWrite(app.vacuum2,1);
    app.a.digitalWrite(app.pressure,0);
    
    for i = 1:10
        pause(1)
        waitbar(i/10);
    end
    
    app.a.digitalWrite(app.pressure,1);
    app.a.digitalWrite(app.vacuum2,0);
    pause(0.5)
    app.a.digitalWrite(app.vacuum2,1);
    
    close(h);