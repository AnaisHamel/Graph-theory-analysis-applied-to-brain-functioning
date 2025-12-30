# Graph-theory-analysis-applied-to-brain-functioning

## 🔍 Project overview

This repository documents a complete analytical pipeline for studying brain network organization and extracting graph-theoretical measures from resting-state fMRI data.
While developed in a neuroscience context, this pipeline can be adapted to other types of network-based data (e.g. structural MRI).

The project focuses on:

- extracting functional connectivity matrices using the BRANT toolbox
- computing graph-theoretical metrics using the Brain Connectivity Toolbox (BCT)
- interpreting network-level properties of brain organization

The scripts and methodology presented here were developed and used in a peer-reviewed neuroscience study, and are shared for methodological transparency and educational purposes.

## 📚 Reference

All scripts in this repository were used in the following publication.
If you use or adapt this methodology, please cite:

Hamel, A., Champetier, P., Rehel, S., André, C., Landeau, B., Mézenge, F., Haudry, S., Roquet, D., Vivien, D., de La Sayette, V., Chételat, G., Rauchs, G., Mary, A., & Medit-Ageing Research Group (2025). Resting-state functional connectivity and fast spindle temporal organization contribute to episodic memory consolidation in healthy aging. Sleep, 48(8), zsaf105. https://doi.org/10.1093/sleep/zsaf105

## 🧠 Scientific context

Functional connectivity is defined as the temporal correlation between neurophysiological signals from distinct brain regions (Friston, 1994).
The brain is organized into large-scale functional networks supporting different cognitive processes. This organization can be studied at rest, i.e., in the absence of goal-directed mental or physical activity.

Using a connectome-based approach, the brain is modeled as a graph where nodes represent brain regions and edges represent functional connections between regions

Graph theory provides quantitative tools to characterize brain organization through measures of integration (between-network connectivity) and segregation (within-network connectivity).

Graph metrics can be extracted at multiple levels:

(-) whole-brain
(-) network
(-) regional

This pipeline illustrates how graph-based metrics can be derived from fMRI time series to investigate large-scale brain organization.

##  Methodology
Pre-processed data are needed 

# 1. Extraction of connectivity matrices using the BRANT toolbox

# 2. Graph construction

# 3. Graph-theoretical measures

Using the Brain Connectivity Toolbox, the following metrics are computed:

(-) Whole-brain measures : 
(-) (-) Global efficiency 
(-) (-) Modularity 

(-) Network measures : 
(-) (-) Participation coefficient (integration) 
(-) (-) Within-module degree (segregation)

(-) Regional measures : 
(-) (-) Strength (centrality) 
(-) (-) Clustering coefficient
