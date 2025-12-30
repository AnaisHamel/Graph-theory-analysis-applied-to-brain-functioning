%% DOCSTRING
% Based on functional connectivity matrices generated with the BRANT toolbox, this script converts negative values and "Inf" to 0.

% Negative weights are usually removed from the matrix due to the ambiguity in the meaning and interpretation of negative correlations (Chan et al., 2014).

%% Clean workspace
clear

%% Select the folder containing the functional connectivity matrices
spmpath = uigetdir;
fileList = dir(fullfile('*.txt')); % Place yourself in the folder and run this line

%% Navigate to the folder containing the txt files before creating new directories
mkdir corr_z-diag0_positives_values
mkdir corr_z-diag0_positives_values/MAT 
mkdir corr_z-diag0_positives_values/CSV 
mkdir corr_z-diag0_positives_values/TXT 

%% Loop over each subject
for file=1:length(fileList)           % Place yourself in the folder and run this line
    M = dlmread(fileList(file).name); % Load the matrix
    M(1:1+size(M,1):end) = 0;         % Set the diagonal values to 0
    M(M < 0) = 0;                     % Set negative values to 0
%% Extract subject number from file name
    d=fileList(file).name;            % Get the file name (if needed)
    e=regexp(d,'\d+','match');        % Extract only the digits from the file name (number of the subject, if needed)
    f=cell2mat(e);                    % Convert to string / number

%% Save in MAT, CSV, and TXT formats
    save([spmpath '/corr_z-diag0_positives_values/MAT/s' num2str(f) 'v1.mat'],'M');
    csvwrite([spmpath '/corr_z-diag0_positives_values/CSV/s',num2str(f),'v1.csv'], M);
    dlmwrite([spmpath '/corr_z-diag0_positives_values/TXT/s' num2str(f) 'v1.txt'], M);
end

