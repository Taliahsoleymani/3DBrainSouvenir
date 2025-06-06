# 3DBrainSouvenir
This is our pipeline to take our participants' brain MRIs and turn them into 3D printed souvenirs 

## Workflow 
1. Extract the brain from the MRI (Shell Script Template)
2. Smooth brain and combine all meshes(both hemispheres and cerebellum+brainstem)(Meshlab)

### Standardized Folder Structure
/data/MoodGroup/code/3D_Brain_Printing/

raw_data/
    
	sub-001/
        sub-001_T1w.nii.gz
    sub-002/
        sub-002_T1w.nii.gz
    
derivatives/
    
	freesurfer/
       
		sub-001/
        sub-002/
    stl/
        sub-001/
            lh_pial.stl
            rh_pial.stl
            lh_cereb_bs.stl
            rh_cereb_bs.stl
            subcortical.stl
        sub-002/

 print/
 
 	sub-001-full-brain-print.stl

scripts/
   
	run_freesurfer_and_export.sh
    smooth_and_merge_meshes.m

slurm/
    
	swarm.sub-001
    swarm.sub-002

logs/

*Folder Description*

raw_data/	Contains raw structural MRI for each subject (T1w.nii.gz)

derivatives/	Output data generated from processing

freesurfer/	Full recon-all output folders per subject

stl/	STL files for 3D printing: cortical surface, cerebellum, subcorticals

scripts/	Shell and MATLAB scripts used in the pipeline

slurm/	Swarm files for SLURM job submission (if using HPC)

logs/	Log outputs for recon-all and mesh creation

