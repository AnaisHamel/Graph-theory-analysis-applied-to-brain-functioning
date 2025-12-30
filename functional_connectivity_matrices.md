# Extraction of ROI-to-ROI functional connectivity matrices using the BRANT toolbox

This section describes the procedure used to extract pairwise functional connectivity matrices between brain regions using the BRANT toolbox through the MATLAB graphical interface.

Required software

- SPM12 : https://www.fil.ion.ucl.ac.uk/spm/software/spm12/
- BRANT toolbox : https://sphinx-doc-brant.readthedocs.io/en/latest/
- BRANT documentation (ROI FC calculation) : https://sphinx-doc-brant.readthedocs.io/en/latest/FC_ROI_Calculation.html

Procedure

- Open MATLAB.
- In the MATLAB Command Window, run: SPM fmri
  - ⚠️ Do not close SPM after launching it, as this may cause errors.
- Add the BRANT toolbox (including all subfolders) to the MATLAB path.
- In the MATLAB Command Window, run: brant

In the BRANT interface, select:
FC → ROI Signal Calculation
- ROI file : Atlas mask file (e.g. Schaefer atlas or Power atlas)

- ROI index : CSV file (comma-separated) containing the index and name of each ROI included in the atlas.
Example:
1,SFG
2,MFG
3,IFG
-	Clustersize : 0
-	Mask : gray matter mask
-	Id index : 1
-	Filetype : f*.nii 
-	4D nifti files : ✓ (checked)
-	Input dirs, Two options are available:
    -	Manual selection : Click on “…” and manually select the preprocessed fMRI directory for each participant.
    -	Text file input (recommended) : Create a text file listing the full paths to each participant’s preprocessed data directory.
In BRANT, select From text file, click on “…” and load this file.
-	Extract mean : ✓ (checked)
-	Roi to roi correlation : ✓ (checked)
-	Roi to whole brain correlation : ⨯ (unchecked)
-	Patial correlation : ⨯ (unchecked, unless partial correlations are required)
-	Smooth results : ⨯ (unchecked if data were already smoothed during preprocessing)
-	Out dir : specify the directory where results will be saved

Output : 
The procedure outputs ROI-to-ROI functional connectivity matrices in .txt format, after Fisher z-transformation.
Diagonal values are set to Inf.
