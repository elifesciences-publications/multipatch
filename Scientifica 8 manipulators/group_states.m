function [checkbox,low,high,mouth,air,clean,togglebutton]=group_states(app)

checkbox = [app.Manipulator1CheckBox,
            app.Manipulator2CheckBox,
            app.Manipulator3CheckBox,
            app.Manipulator4CheckBox,
            app.Manipulator5CheckBox,
            app.Manipulator6CheckBox,
            app.Manipulator7CheckBox,
            app.Manipulator8CheckBox,
            app.Manipulator9CheckBox,
            app.Manipulator10CheckBox];
        
low = [app.LowButton_1,
       app.LowButton_2,
       app.LowButton_3,
       app.LowButton_4,
       app.LowButton_5,
       app.LowButton_6,
       app.LowButton_7,
       app.LowButton_8,
       app.LowButton_9,
       app.LowButton_10];
   
high = [app.HighButton_1,
       app.HighButton_2,
       app.HighButton_3,
       app.HighButton_4,
       app.HighButton_5,
       app.HighButton_6,
       app.HighButton_7,
       app.HighButton_8,
       app.HighButton_9,
       app.HighButton_10];

mouth =   [app.PatchButton_1,
           app.PatchButton_2,
           app.PatchButton_3,
           app.PatchButton_4,
           app.PatchButton_5,
           app.PatchButton_6,
           app.PatchButton_7,
           app.PatchButton_8,
           app.PatchButton_9,
           app.PatchButton_10];
       
air =     [app.AirButton_1,
           app.AirButton_2,
           app.AirButton_3,
           app.AirButton_4,
           app.AirButton_5,
           app.AirButton_6,
           app.AirButton_7,
           app.AirButton_8,
           app.AirButton_9,
           app.AirButton_10];

clean =[app.CleanButton_1,
           app.CleanButton_2,
           app.CleanButton_3,
           app.CleanButton_4,
           app.CleanButton_5,
           app.CleanButton_6,
           app.CleanButton_7,
           app.CleanButton_8,
           app.CleanButton_9,
           app.CleanButton_10];

togglebutton = [app.ButtonGroup_1,
               app.ButtonGroup_2,
               app.ButtonGroup_3,
               app.ButtonGroup_4,
               app.ButtonGroup_5,
               app.ButtonGroup_6,
               app.ButtonGroup_7,
               app.ButtonGroup_8,
               app.ButtonGroup_9,
               app.ButtonGroup_10];