function [a,pipette_valves,vacuum1,vacuum2,pressure]=setup_arduinomega(app)

h = waitbar(0,'Loading Arduino Mega...'); %generates a waitbar for visualization

arduino_comport=app.setup.arduino_comport;      %loads comport from setup variables
a=arduino(arduino_comport);                     %load arduino on set comport

waitbar(95 / 100)                       %progress waitbar for visualization

%%
for pin = 2:56
a.pinMode(pin,'output');                %set pin mode for all 56 arduino digital pins as output
a.digitalWrite(pin,1);                  %1=relais off, turn all relais off
end

%% assigning the wiring pins to arrays
valve_wiring=app.setup.valve_wiring;    %extract valve_wiring table from setup variables

for i = 1:3
    pipette_valves(1:10,i) = valve_wiring.Arduino(valve_wiring.ventilID >= i*100 & valve_wiring.ventilID <= i*100 +10); %reads Arduino outputs for respective pipette valve
end

pipette_valves(1:10,4) = valve_wiring.Arduino(valve_wiring.ventilID == 111); %4th valve the same for all pipettes, switches between HIGH and PATCH
pressure = valve_wiring.Arduino(valve_wiring.ventilID == 401);     %valve for pressure of cleaning
vacuum1 = valve_wiring.Arduino(valve_wiring.ventilID == 402);      %first valve for suction of cleaning
vacuum2 = valve_wiring.Arduino(valve_wiring.ventilID == 403);      %second valve for suction of cleaning

close(h) 