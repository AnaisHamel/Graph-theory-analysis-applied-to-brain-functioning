%% DOCSTRING
% Based on functional connectivity matrices generated with the BRANT toolbox, 
% this script thresholds matrices to retain only the strongest connections and saves the results in multiple formats.
%
% Negative weights are usually removed due to the ambiguity in the interpretation of negative correlations (Chan et al., 2014).

%% Clean workspace
clear

%% Create a folder for thresholded matrices (example: retaining top 15% of connections)
mkdir("15percent_matrix")

%% Weight the matrices based only on positive values
result_folder = uigetdir; % Select the folder where results will be saved

% Navigate to the folder containing the ROI-to-ROI z-transformed correlation matrices with diagonals = 1
mkdir(result_folder, "MAT") 
mkdir(result_folder, "CSV") 
mkdir(result_folder, "TXT") 

myDir = uigetdir; % Select the folder containing the weighted connectivity matrices (.mat files)
fileList = dir(fullfile(myDir,'*.mat'));

%% Loop over each file / subject
for file=1:length(fileList)                                         
    Ma = fileList(file).name;                                       % Get the file name
    open_double = open(Ma);                                         % Load the .mat file
    threshold_matrix = threshold_proportional(open_double.M,0.15);  % Retain the top 15% of strongest connections
    %threshold_matrix(threshold_matrix~=0)=1;                       % Uncomment this line if a binary matrix is desired
    threshold_matrix_15 = threshold_matrix;                         % Store thresholded matrix
  
    %% Extract subject number from file name
    d = fileList(file).name;                                       % Get the file name (if needed)
    e = regexp(d,'\d+','match');                                   % Extract only the digits from the file name (number of the subject, if needed)
    f = cell2mat(e);                                               % Convert to string / number
    
    %% Save thresholded matrix in MAT, CSV, and TXT formats
    save([result_folder '/MAT/s' num2str(f) 'v1_threshold_matrix_15.mat'],'threshold_matrix_15');
    csvwrite([result_folder '/CSV/s',num2str(f),'v1_threshold_matrix_15.csv'], threshold_matrix_15);
    dlmwrite([result_folder '/TXT/s' num2str(f) 'v1_threshold_matrix_15.txt'], threshold_matrix_15);
end

%% Clear variables
clear result_folder threshold_matrix
