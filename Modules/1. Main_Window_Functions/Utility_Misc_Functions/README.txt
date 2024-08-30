This folder contains the following functions with respective Header:

 ###################################################### 

File: LineClicked.m
%________________________________________________________________________________________
%% Function to Handle Case that user clicks at a plotted line in the main window data plot to display channel name
% This function handles displaying a channel name in the main plot when the
% user clicks on a polotted line in the main plot. This has for some reason to be handled by a different callback function
% than clicking on a empty part of the plot. This function is called within
% the callback specified in the Utility_Initialize_Clicks_Plots function
% which gets called every time smt is plotted.

% Input Arguments:
% 1. app: app object of main window
% 2. event: Event handle of clicking containing x and y corrdinates, where the user clicked. This is set up and initialized in the
% Utility_Initialize_Clicks_Plots

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: LineClickedTime.m
%________________________________________________________________________________________
%% Function to Handle Case that user clicks at a plotted line in the main window time plot to switch displayed time
% This has for some reason to be handled by a different callback function
% than clicking on a empty part of the plot. This function is called within
% the callback specified in the Utility_Initialize_Clicks_Plots function,
% which is executed every time the plots get changed when the user clicks on some point of the time plot.

% Input Arguments:
% 1. app: app object of main window
% 2. event: Event handle of clicking containing x and y corrdinates, where the user clicked. This is set up and initialized in the
% Utility_Initialize_Clicks_Plots

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: UIAxesButtonDown.m
%________________________________________________________________________________________
%% Callback Function that handles a click on the data plot and displays a corresponding channel
% This function captures the event when the user clicks on a plot. The
% event contains x and y coordinateds of the click in the event structure.
% It then searches for the closest available y value in the data matrix
% plotted to the y coordinate of the data plot the user clicked on.

% Input Arguments:
% 1. app: app object of main window
% 2. event: Event handle of clicking. This is set up and initialized in the
% Utility_Initialize_Clicks_Plots

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: UIAxes_2ButtonDown.m
%________________________________________________________________________________________
%% Callback Function that handles a click on the time plot
% This function captures the event when the user clicks on a plot. The
% event contains x and y coordinateds of the click in the event structure.
% It then searches for the closest available time point in the time vector
% to the x coordinate of the time plot the user clicked on.

% Input Arguments:
% 1. app: app object of main window
% 2. event: Event handle of clicking. This is set up and initialized in the
% Utility_Initialize_Clicks_Plots

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_CreateChannelNames.m
%________________________________________________________________________________________
%% Function to create standard channel names (Channel1, Channel2 and so on)
% This function gets called for example to display the create channel names when the
% user clicks on the data plot of the main window

% Input Arguments:
% 1. app: app object with fields 'Data.Raw' needed for max channel nr

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_Extract_Contents_of_Folder.m
%________________________________________________________________________________________
%% Function to extract all contents of a selcted folder and output them in a string array for easy use
% This function gets called for example whenever the user makes a folder
% selection and the contents are checked for a proper recording format or
% the contents are shown in a textarea of a gui window

% Input Arguments:
% 1. Path: Path to the folder as char

% Output Arguments:
% 1. stringArray: Contens of folder in a n x 1 string array with n being
% the number of contents

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_Extract_Function_Headers_to_txt.m
    headerDelimiter = '%________________________________________________________________________________________';
    
    fprintf(fidOut, 'This folder contains the following functions with respective Header:\n\n ###################################################### \n\n');

    % Loop over each .m file
    for i = 1:length(files)
        filePath = fullfile(files(i).folder, files(i).name);
        fidIn = fopen(filePath, 'r');
        
        if fidIn == -1
            warning('Could not open file "%s". Skipping...', files(i).name);
            continue;
        end
        
        % Read the file line by line
        isHeader = false;
        headerLines = {};
        
        while ~feof(fidIn)
            line = fgetl(fidIn);
            if contains(line, headerDelimiter)
                if isHeader
                    % If we reach the second delimiter, break out of the loop
                    headerLines{end+1} = line; %#ok<AGROW>
                    break;
                else
                    % Start recording the header
                    isHeader = true;
                end
            end
            
            if isHeader
                headerLines{end+1} = line; %#ok<AGROW>
            end
        end
        
        fclose(fidIn);
        
        % Write the header to the output file
        if ~isempty(headerLines)
            fprintf(fidOut, 'File: %s\n', files(i).name);
            for j = 1:length(headerLines)
                fprintf(fidOut, '%s\n', headerLines{j});
            end
            fprintf(fidOut, '\n\n ###################################################### \n\n');
        end
    end
    
    % Close the output file
    fclose(fidOut);
    
    fprintf('Headers extracted to "%s"\n', outputFilePath);
end


 ###################################################### 

File: Utility_Initialize_Clicks_Plots.m
%________________________________________________________________________________________
%% Function to initilaze click functionality of plots
% This function gets called whenever something new is plotted in the main
% window to initiate the UIAxesButtonDown callcbacks that capture the x and
% y corrdinate of a point being clicked.

% UIAxesButtonDown and LineClicked = main window data plot (buttondown when clicking on empty space of plot, lineclicked when clicking on a data line)
% UIAxes_2ButtonDown and LineClickedTime = maine window time plot (buttondown when clicking on empty space of plot, lineclicked when clicking on a data line)

% Input Arguments:
% 1. app: main window app object

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_Show_Info_Loaded_Data.m
%________________________________________________________________________________________
%% Function to show all contents of the Data.Info object in the textarea on the bottom left of the main window 
% This function gets called whenever Data.Info is modified to update the
% recording infomation textarea. It rearranges the Data.Info structure so
% that subfields get primary fields that can be shown as is and converts
% double values to strings

% Input Arguments:
% 1. app: main window app object

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_SimpleCheckInputs.m
%________________________________________________________________________________________
%% Function to check whether user input into a field like the channelnr obeys format regulations
% This is the primarily used function to check inputs and corrects them when they violate format, since it is more
% robust than 'Organize_CheckProperInput' function.
% Organize_CheckProperInput gets bit by bit replaced in the future 

% Input Arguments:
% 1. Input: input to be checked as char. I diretly pass the app.Button.Value
% 2. Type: string, options: "One" to chekc format of a single number, "Two"
% for two numbers seperated by a comma
% 3. StandardValues: char containing a value the original input gets
% replaced by when the format is violated
% 4, CompareToStandard: double, 1 or 0, 1 if compare to standarad value. If
% bigger it gets resetted
% 5. Negative: double, 1 or 0, 1 if negative values are expected, 0
% otherwise

% Output Arguments:
% 1. Corrected_Input: char with either the original input when its format
% is proper, char with standardvalue if format was violated

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_findClosestLineDatPlot.m
%________________________________________________________________________________________
%% Function to identify the closest line to the point in the plot the user clicked on
% This function gets called when the user clicks on the data plot to
% display the channel nr. For this, the y value of the clicked position
% has to be compared to the y values of the plotteded data lines. The Nr of data line
% closest to the clicked point is the channel nr to display

% Input Arguments:
% 1. app: app -- not needed ynamore but maybe useful for modifications
% 2. axis: handle to fugure the user clicked on (data plot in main window)
% 3. clickPoint: 1 x 3 double containing the x and y and z value of the point the
% user clicked on (z==0) -- can also be 1 x 2 with just x and y

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: updateUIAxesProperty.m
%________________________________________________________________________________________
%% Function responsible to change figure properties when the user right-clicks on a figure and inputs a new propertie value

% Input Arguments:
% 1. UIAxes: Axis handle of figure for which a property has to be changed
% 2. type: Type of property changed as string, like "xlim" or "ylim" (normal matlab commands)
% 3. value: the value the user inputted replacing the old peroperty value,
% as string

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

