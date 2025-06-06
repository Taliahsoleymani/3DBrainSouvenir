# 3DBrainSouvenir
This is our pipeline to take our participants' brain MRIs and turn them into 3D printed souvenirs 

## Workflow 
1. Extract the brain from the MRI (Shell Script Template)
2. Smooth brain and combine all meshes(both hemispheres and cerebellum+brainstem)(Meshlab)

### Standardized Folder Structure
/data/MoodGroup/code/3D_Brain_Printing/

raw_data/
    
	sub-001/
        sub-001_*.nii
    sub-002/
        sub-002_*.nii
    
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

print/ contains the finished producted after smoothed and merged as a single mesh

scripts/	Shell and MATLAB scripts used in the pipeline

slurm/	Swarm files for SLURM job submission (if using HPC)

logs/	Log outputs for recon-all and mesh creation

## 🧠 Run FreeSurfer `recon-all` and Export STL Files

This step takes a participant's T1-weighted MRI and produces surface meshes of key brain structures using FreeSurfer.
🔁 Optional: If `anatwrap` output is available, use the skull-stripped (masked) MRI as input instead of the raw `.nii` file.

---

### 🛠️ Run the Processing Script

Submit your job on the HPC (e.g., Biowulf) using `sbatch`:

```bash
sbatch --mem=64G --cpus-per-task=8 --time=2-00:00:00 scripts/generate_brain_stl.sh sub-001
``` 

--- 

## 🧠 Meshlab Post-Processing

After generating individual STL files for each brain region, use **Meshlab** to prepare the final printable mesh.

---

### Upload Files to Meshlab

Open Meshlab and drag in the following STL files from the `stl/sub-XXX/` folder:

- `lh_pial.stl`
- `rh_pial.stl`
- `lh_cereb_bs.stl`
- `rh_cereb_bs.stl`
- `subcortical.stl`

Each will load as a separate layer.

---

### ✅ 1. Smooth cerebellum 

Filters
    > Smoothing, Fairing, and Deformation
        > ScaleDependent Laplacian Smooth
This should open up the following window:
![laplacian_smooth](https://github.com/user-attachments/assets/4f5a3340-ce41-4d29-b26c-264ca1074990)

Just set Smoothing steps to 100 and perc on under delta (abs and %) to 0.100. 
> 💡 Use the preview window to avoid over-smoothing and losing anatomical detail.
And then press Apply. 

### 📏 2. Scale brain to approximately 4 inches (~100 mm)

To ensure the brain fits a small print format:

1. Select a mesh layer (e.g., `lh_pial`)
2. Go to:  
   `Filters` → `Normals, Curvatures and Orientation` → `Transform: Scale, Normalize`
3. Estimate current width and compute scaling factor (e.g., if 160 mm wide, scale by `0.625`)
4. Apply the **same scaling factor** to all layers manually

> 💡 You can view mesh dimensions under `Render` → `Show Box Corners`.

---

### 🔗 3. Merge the meshes together

To create a unified printable mesh:

1. Ensure all 5 layers are visible (eye icon)
2. Go to:  
   `Filters` → `Mesh Layer` → `Flatten Visible Layers`
3. In the popup:
   - Check **Merge Only Visible Layers**
   - Leave other settings as default
4. Click **Apply**

This will create a new mesh called `FlattenedMesh`.

---

### 💾 Export Final Mesh

1. Select `FlattenedMesh`
2. Go to:  
   `File` → `Export Mesh As...`
3. Save as:  
   `print/sub-XXX-full-brain-print.stl`
4. Export as **Binary STL**  
   (optional: check `Save normals`)

---

### Now you are ready to print!

