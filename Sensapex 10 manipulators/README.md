# Pressure system with Sensapex micromanipulators

This Matlab-based graphical user interface allows programmatic control of the pressure system and the Sensapex manipulators. The solenoid valves of the pressure system are electronically switched by relais which are controlled through the digital output channels of the Arduino board. The Arduino board is controlled through Matlab.

## Getting Started

 1. Build the pressure system according to the supplement material and instruction guide. Connect the Arduino board to the Computer via USB. Connect the Sensapex micromanipulator system to your computer (via ethernet). Set up the Sensapex system by making sure that all manipulators are recognized by the control unit and the right id-numbers are assigned. 
 2. Make sure that the wiring of the different channels to the relays and their corresponding solenoid valves are documented.
 3. Install the Legacy Matlab support for Arduino which can be downloaded here: [https://de.mathworks.com/matlabcentral/fileexchange/32374-legacy-matlab-and-simulink-support-for-arduino](https://de.mathworks.com/matlabcentral/fileexchange/32374-legacy-matlab-and-simulink-support-for-arduino)
 4. Install the IDE on the Arduino board which is included in the Matlab addon (follow the instructions on the respective readme file).
 5. For automated cleaning, setup the specific parameters in manipulator_move_pressure.m adjusted to your specific setup configuration.
 6. Load the setup.m file and configure the specific variables:
	 1. arduino_comport: find out the COM port assigned to the arduino and write this as a string value (e.g. 'COM15'). 
	 2. manipulator_type: write 'sensapex' if you want to enable manipulator control in the pressure system. If you only want to control the pressure independent of manipulator manufacturer, enter 'none'.
	 3. valve_wiring: for each ventilID (="valve", first column) put in an ID for the relay and the corresponding Arduino digital output. ventilID 1xx represent the valves immediately connected to the pipette pressure tubes, switching between the other two valve manifolds. ventilID 2xx are the valves switching between the "clean" channel and the "high/patch" channel. ventilID 3xx are the valves switching between the "low" and "atmosphere/air" channel. ventilID 4xx are the bigger valves connected to the pressure regulators.
 7. Save the setup.m file and run app_pressure.mlapp

### Prerequisites

 - Matlab R2018a and Legacy Matlab support for Arduino addon
 - Arduino IDE (from Matlab addon)
 
 ### Installing

When the Arduino is configured with the IDE and the setup.m file is configured as shown above, no further installation is needed. Run the app_pressure.mlapp file for the GUI.

## Further notes

The software provided does not represent a plug&play solution. Customization of the code is very likely necessary to make it work with other systems.

 - An important aspect is to figure out the relay wiring and the correct controlling of these. The setvalve.m function is important for assigning the valves to the different pressure states.
 - We did not include the pipette finding algorithm. This would require extensive individual adjustments. We provide a conceptual guide on the programming approach in the supplementary documentation.
 - Further help is provided as comments in the code.
 - For further help, please contact franz.mittermaier@charite.de

## Contributors

Code for Scientifica setup is written by Yangfan Peng. Code for Sensapex setup is written by Franz X. Mittermaier
