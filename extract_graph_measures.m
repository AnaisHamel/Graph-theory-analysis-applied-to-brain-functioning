%% DOCSTRING
% This script extracts graph theoretical measures from functional connectivity
% matrices using the Brain Connectivity Toolbox (BCT).
%
% All functions are adapted for positively weighted matrices.
%
% Measures are computed at three levels:
% 1. Whole brain level
% 2. Network level
% 3. Regional (node) level
%
% Whole brain measures include:
% - Global efficiency, which quantifies the efficiency of information transfer
%   across the entire brain network.
% - Modularity (Q), which reflects the balance between within-network and
%   between-network connectivity.
%
% Network level measures include:
% - Participation coefficient, which quantifies the extent to which a node
%   connects across different networks (functional integration).
% - Within-module degree z-score, which measures how strongly a node is
%   connected within its own network (functional segregation).
%
% Regional measures include:
% - Node strength, which quantifies the total strength of connectivity
%   between a given region and all other regions.
% - Clustering coefficient, which reflects the tendency of a node's neighbors
%   to form interconnected clusters.
%
% All measures were used in:
% Hamel et al. (2025)
% https://doi.org/10.1093/sleep/zsaf105
%
% Requirements:
% - Brain Connectivity Toolbox (https://sites.google.com/site/bctnet/)
% - MATLAB .mat files containing thresholded weighted connectivity matrices
%
% Author: Anaïs HAMEL
% Created during PhD research


%% Clear workspace
clear

%% Create a general folder to store all graph measures
mkdir("graph_measures")

%% Select parent directory where all result subfolders will be created
myDir_mesures_de_graphe = uigetdir;

%% Create subfolders for matrix transformations
mkdir(myDir_mesures_de_graphe, "connection_length_matrix" )
mkdir(myDir_mesures_de_graphe, "distance_matrix" )
mkdir(myDir_mesures_de_graphe, "matrix_normalized" )

%% Create subfolders for whole brain measures
mkdir(myDir_mesures_de_graphe, "community_affiliation_vector" )
mkdir(myDir_mesures_de_graphe, "community_structure_statistic" )
mkdir(myDir_mesures_de_graphe, "global_efficiency_wei" )

%% Create subfolders for network level measures
mkdir(myDir_mesures_de_graphe, "participation_coef" )
mkdir(myDir_mesures_de_graphe, "participation_coef_norm" )
mkdir(myDir_mesures_de_graphe, "within_module_degree_networks" )

%% Create subfolders for regional measures
mkdir(myDir_mesures_de_graphe, "strengths_und" )
mkdir(myDir_mesures_de_graphe, "coefficient_clustering" )

%% Select folder containing thresholded weighted connectivity matrices (.mat files)
myDir_weighted_matrices = uigetdir;
fileList_weighted_matrices = dir(fullfile(myDir_weighted_matrices,'*.mat'));

%% Convert connection weights to connection lengths
% This step is required to compute distance matrices and global efficiency

result_folder_length = uigetdir; % Select output folder for connection length matrices
mkdir(result_folder_length, "MAT" )
mkdir(result_folder_length, "CSV" )
mkdir(result_folder_length, "TXT" )

for file=1:length(fileList_weighted_matrices); 
    % Load weighted connectivity matrix
    open_double = open([fileList_weighted_matrices(file).folder '/' fileList_weighted_matrices(file).name]);
    % Convert weights to lengths
    weight_conversion_matrix = weight_conversion(open_double.threshold_matrix_15,'lengths');
    % Extract subject identifier from filename
    d=fileList_weighted_matrices(file).name;                                                                        % Get the file name (if needed) 
    e=regexp(d,'\d+','match');                                                                                      % Extract only the digits from the file name (number of the subject, if needed)
    f=e{1,1};                                                                                                       % Convert to string / number
    % Save results
    save([result_folder_length '/MAT/s' num2str(f) 'v1_weight_conversion_matrix.mat'],'weight_conversion_matrix');
    csvwrite([result_folder_length '/CSV/s',num2str(f),'v1_weight_conversion_matrix.csv'], weight_conversion_matrix);
    dlmwrite([result_folder_length '/TXT/s' num2str(f) 'v1_weight_conversion_matrix.txt'], weight_conversion_matrix);
end

clear d e f file open_double weight_conversion_matrix

%% Compute distance matrices from connection length matrices
% Distance matrices are required for global efficiency computation

result_folder_distance = uigetdir; % Select output folder
mkdir(result_folder_distance, "MAT" )
mkdir(result_folder_distance, "CSV" )
mkdir(result_folder_distance, "TXT" )

fileList_length = [result_folder_length '/MAT/'];
fileList_length_matrices = dir(fullfile(fileList_length,'*.mat'));


for file=1:length(fileList_length_matrices);
    % Load connection length matrix
    open_double = open([fileList_length_matrices(file).folder '/' fileList_length_matrices(file).name]);
    % Compute weighted distance matrix
    distance_wei_matrix = distance_wei(open_double.weight_conversion_matrix);
    % Extract subject identifier
    d=fileList_length_matrices(file).name; 
    e=regexp(d,'\d+','match');
    f=e{1,1};
    % Save results
    save([result_folder_distance '/MAT/s' num2str(f) 'v1_distance_wei_matrix.mat'],'distance_wei_matrix');
    csvwrite([result_folder_distance '/CSV/s',num2str(f),'v1_distance_wei_matrix.csv'], distance_wei_matrix);
    dlmwrite([result_folder_distance '/TXT/s' num2str(f) 'v1_distance_wei_matrix.txt'], distance_wei_matrix);
    clear d distance_wei e f M open_double file
end

clear file open_double e f g distance_wei_matrix


%% Matrix normalization
% Normalize weighted connectivity matrices.
% This step is required for the computation of the weighted clustering coefficient.

% Needed to calculate clustering coefficient

result_folder_normalization_matrice = uigetdir; % select result folder 
mkdir(result_folder_normalization_matrice, "MAT" )
mkdir(result_folder_normalization_matrice, "CSV" )
mkdir(result_folder_normalization_matrice, "TXT" )

for file=1:length(fileList_weighted_matrices);
    open_double = open([fileList_weighted_matrices(file).folder '/' fileList_weighted_matrices(file).name]);     
    weight_conversion_normalized_matrix = weight_conversion(open_double.threshold_matrix_15, 'normalize');
    d=fileList_weighted_matrices(file).name;
    % Extract subject number
    e=regexp(d,'\d+','match');
    f=e{1,1};
    % Save in MAT, CSV, and TXT formats
    save([result_folder_normalization_matrice '/MAT/s' num2str(f) 'v1_weight_conversion_normalized_matrix.mat'],'weight_conversion_normalized_matrix');
    csvwrite([result_folder_normalization_matrice '/CSV/s',num2str(f),'v1_weight_conversion_normalized_matrix.csv'], weight_conversion_normalized_matrix);
    dlmwrite([result_folder_normalization_matrice '/TXT/s' num2str(f) 'v1_weight_conversion_normalized_matrix.txt'], weight_conversion_normalized_matrix);
end


%% Global efficiency
% Compute whole brain global efficiency from weighted distance matrices.
% Global efficiency reflects the efficiency of information transfer
% across the entire brain network.


result_global_efficiency = uigetdir;
mkdir(result_global_efficiency, "MAT" )
mkdir(result_global_efficiency, "CSV" )
mkdir(result_global_efficiency, "TXT" )


fileList_distance = [result_folder_distance '/MAT/'];
fileList_distance_matrices = dir(fullfile(fileList_distance,'*.mat'));


for file=1:length(fileList_distance_matrices);
    open_double = open([fileList_distance_matrices(file).folder '/' fileList_distance_matrices(file).name]);
    [charpath_matrix,global_efficiency] = charpath(open_double.distance_wei_matrix);
    d=fileList_distance_matrices(file).name; 
    e=regexp(d,'\d+','match');
    f=e{1,1};
    save([result_global_efficiency '/MAT/s' num2str(f) 'v1_global_efficiency.mat'],'global_efficiency');
    csvwrite([result_global_efficiency '/CSV/s',num2str(f),'v1_global_efficiency.csv'], global_efficiency);
    dlmwrite([result_global_efficiency '/TXT/s' num2str(f) 'v1_global_efficiency.txt'], global_efficiency);
end

clear file open_double e f g characteristic_path_length global_efficiency ecc radius diameter


%% Modularity and community detection (Louvain algorithm)
% Identify community structure using the Louvain algorithm.
% This step computes:
% - The community affiliation vector for each node
% - The modularity statistic (Q), reflecting network segregation
% Community detection is constrained by a predefined network partition.


result_folder_community_affiliation_vector = uigetdir;% select result folder
mkdir(result_folder_community_affiliation_vector, "MAT" )
mkdir(result_folder_community_affiliation_vector, "CSV" )
mkdir(result_folder_community_affiliation_vector, "TXT" )

result_folder_community_structure_statistic = uigetdir; % select result folder
mkdir(result_folder_community_structure_statistic, "MAT" )
mkdir(result_folder_community_structure_statistic, "CSV" )
mkdir(result_folder_community_structure_statistic, "TXT" )


predefined_network = uigetdir;
fileList_predefined_network = dir(fullfile(predefined_network,'*.mat'));


for file=1:length(fileList_weighted_matrices);
    open_double = open([fileList_weighted_matrices(file).folder '/' fileList_weighted_matrices(file).name]); 
    open_vector = open([fileList_predefined_network(1).folder '/' fileList_predefined_network(1).name]);
    [community_louvain_vector,Q] = community_louvain(open_double.threshold_matrix_15,[],open_vector.networkvector);
    d=fileList_weighted_matrices(file).name; 
    e=regexp(d,'\d+','match');
    f=e{1,1};
    save([result_folder_community_affiliation_vector '/MAT/s' num2str(f) 'v1_community_louvain_vector.mat'],'community_louvain_vector');
    csvwrite([result_folder_community_affiliation_vector '/CSV/s',num2str(f),'v1_community_louvain_vector.csv'], community_louvain_vector);
    dlmwrite([result_folder_community_affiliation_vector '/TXT/s' num2str(f) 'v1_community_louvain_vector.txt'], community_louvain_vector);
    save([result_folder_community_structure_statistic '/MAT/s' num2str(f) 'v1_Q.mat'],'Q');
    csvwrite([result_folder_community_structure_statistic '/CSV/s',num2str(f),'v1_Q.csv'], Q);
    dlmwrite([result_folder_community_structure_statistic '/TXT/s' num2str(f) 'v1_Q.txt'], Q);
end

clear file f d e Q open_double open_vector community_louvain_vector Q


%% Participation coefficient
% Compute the participation coefficient for each node.
% This measure quantifies the extent to which a node connects
% across different functional networks (integration).

result_folder_pc = uigetdir; % select result folder 
mkdir(result_folder_pc, "MAT" )
mkdir(result_folder_pc, "CSV" )
mkdir(result_folder_pc, "TXT" )


for file=1:length(fileList_weighted_matrices);
    open_double = open([fileList_weighted_matrices(file).folder '/' fileList_weighted_matrices(file).name]);
    open_vector = open([fileList_predefined_network(1).folder '/' fileList_predefined_network(1).name]);
    ppos  = participation_coef(open_double.threshold_matrix_15, open_vector.networkvector);
    d=fileList_weighted_matrices(file).name; 
    e=regexp(d,'\d+','match');
    f=e{1,1};
    save([result_folder_pc '/MAT/s' num2str(f) 'v1_participation_coef.mat'],'ppos');
    csvwrite([result_folder_pc '/CSV/s',num2str(f),'v1_participation_coef.csv'], ppos);
    dlmwrite([result_folder_pc '/TXT/s' num2str(f) 'v1_participation_coef.txt'], ppos);
    
end

clear file open_double e f g ppos 


%% Within module degree z-score
% Compute the within-module degree z-score for each node.
% This measure quantifies how strongly a node is connected
% to other nodes within its own functional network (segregation).

result_folder_within_module = uigetdir; % select result folder 
mkdir(result_folder_within_module, "MAT" )
mkdir(result_folder_within_module, "CSV" )
mkdir(result_folder_within_module, "TXT" )


for file=1:length(fileList_weighted_matrices);
    open_double = open([fileList_weighted_matrices(file).folder '/' fileList_weighted_matrices(file).name]);
    module_degree_zscore_value = module_degree_zscore(open_double.threshold_matrix_15, open_vector.networkvector); %community_louvain_vector ou network_vector pour les réseaux
    d=fileList_weighted_matrices(file).name; 
    e=regexp(d,'\d+','match');
    f=e{1,1};
    save([result_folder_within_module '/MAT/s' num2str(f) 'v1_module_degree_zscore_value.mat'],'module_degree_zscore_value');
    csvwrite([result_folder_within_module '/CSV/s',num2str(f),'v1_module_degree_zscore_value.csv'], module_degree_zscore_value);
    dlmwrite([result_folder_within_module '/TXT/s' num2str(f) 'v1_module_degree_zscore_value.txt'], module_degree_zscore_value);
end

%% Node strength
% Compute node strength for each brain region.
% Node strength is defined as the sum of weighted connections
% between a node and all other nodes in the network.

result_folder_strength_node = uigetdir; % select result folder
mkdir(result_folder_strength_node, "MAT" )
mkdir(result_folder_strength_node, "CSV" )
mkdir(result_folder_strength_node, "TXT" )

for file=1:length(fileList_weighted_matrices);
    open_double = open([fileList_weighted_matrices(file).folder '/' fileList_weighted_matrices(file).name]);     
    strength_matrix = strengths_und(open_double.threshold_matrix_15);
    d=fileList_weighted_matrices(file).name;
    e=regexp(d,'\d+','match');
    f=e{1,1};
    save([result_folder_strength_node '/MAT/s' num2str(f) 'v1_strength_node.mat'],'strength_matrix');
    csvwrite([result_folder_strength_node '/CSV/s',num2str(f),'v1_strength_node.csv'], strength_matrix);
    dlmwrite([result_folder_strength_node '/TXT/s' num2str(f) 'v1_strength_node.txt'], strength_matrix);
end

clear file f d e Q open_double strength_matrix


%% Clustering coefficient
% Compute the weighted clustering coefficient for each node.
% This measure reflects the tendency of a node's neighbors
% to form interconnected clusters.

result_clustering_coefficient_matrice = uigetdir; % select result folder
mkdir(result_clustering_coefficient_matrice, "MAT" )
mkdir(result_clustering_coefficient_matrice, "CSV" )
mkdir(result_clustering_coefficient_matrice, "TXT" )

fileList_normalized = [result_folder_normalization_matrice '/MAT/'];
fileList_normalized_matrices = dir(fullfile(fileList_normalized,'*.mat'));

for file=1:length(fileList_normalized_matrices);
    open_double = open([fileList_normalized_matrices(file).folder '/' fileList_normalized_matrices(file).name]);     
    clustering_coeff_matrix = clustering_coef_wu_sign(open_double.weight_conversion_normalized_matrix);
    d=fileList_weighted_matrices(file).name;
    e=regexp(d,'\d+','match');
    f=e{1,1};
    save([result_clustering_coefficient_matrice '/MAT/s' num2str(f) 'v1_clustering_coeff_matrix.mat'],'clustering_coeff_matrix');
    csvwrite([result_clustering_coefficient_matrice '/CSV/s',num2str(f),'v1_clustering_coeff_matrix.csv'], clustering_coeff_matrix);
    dlmwrite([result_clustering_coefficient_matrice '/TXT/s' num2str(f) 'v1_clustering_coeff_matrix.txt'], clustering_coeff_matrix);
end

