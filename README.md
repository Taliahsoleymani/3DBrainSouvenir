# 3DBrainSouvenir
This is our pipeline to take our participants' brain MRIs and turn them into 3D printed souvenirs 

## Workflow 
1. Extract the brain from the MRI (Shell Script Template)
2. Smooth brain (MATLAB Smoothing Template)
3. Visualize the Brain in Blender + optional add pins
4. Cleanup Script 

### Standardized Folder Structure
/data/MoodGroup/code/3D_Brain_Printing/
│
├── raw_data/
│   ├── sub-001/
│   │   └── sub-001_T1w.nii.gz
│   ├── sub-002/
│   │   └── sub-002_T1w.nii.gz
│
├── derivatives/
│   ├── freesurfer/
│   │   ├── sub-001/
│   │   └── sub-002/
│   ├── stl/
│   │   ├── sub-001/
│   │   │   ├── lh_pial.stl
│   │   │   ├── rh_pial.stl
│   │   │   ├── lh_cereb_bs.stl
│   │   │   ├── rh_cereb_bs.stl
│   │   │   └── subcortical.stl
│   │   └── sub-002/
│
├── scripts/
│   ├── run_freesurfer_and_export.sh
│   ├── smooth_and_merge_meshes.m
│   └── README.md
│
├── slurm/
│   ├── swarm.sub-001
│   └── swarm.sub-002
│
└── logs/
    ├── recon-all-sub-001.log
    └── meshgen-sub-001.log
