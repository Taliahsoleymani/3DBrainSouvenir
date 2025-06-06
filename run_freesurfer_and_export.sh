#!/bin/bash

# ========== CONFIG ==========
export PROJECT_ROOT=/data/MoodGroup/code/Taliah/3D_Brain_Printing
export SUBJECT=$1  # e.g., sub-002
export T1_FILE=$(find ${PROJECT_ROOT}/raw_data/${SUBJECT} -name "*.nii" | head -n 1)
export SUBJECTS_DIR=${PROJECT_ROOT}/derivatives/freesurfer
export STL_DIR=${PROJECT_ROOT}/derivatives/stl/${SUBJECT}
mkdir -p "${STL_DIR}" "${SUBJECTS_DIR}"
# ============================

module load freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

# Run recon-all
recon-all -all -sd "${SUBJECTS_DIR}" -s "${SUBJECT}" -i "${T1_FILE}"

# Extract surfaces
mris_convert ${SUBJECTS_DIR}/${SUBJECT}/surf/lh.pial ${STL_DIR}/lh_pial.stl
mris_convert ${SUBJECTS_DIR}/${SUBJECT}/surf/rh.pial ${STL_DIR}/rh_pial.stl

# Left cerebellum + brainstem
mri_binarize --i ${SUBJECTS_DIR}/${SUBJECT}/mri/aseg.mgz --match 7 8 16 --o ${STL_DIR}/lh_cereb_bs.mgz
mri_tessellate ${STL_DIR}/lh_cereb_bs.mgz 255 ${STL_DIR}/lh_cereb_bs
mris_convert ${STL_DIR}/lh_cereb_bs ${STL_DIR}/lh_cereb_bs.stl

# Right cerebellum + brainstem
mri_binarize --i ${SUBJECTS_DIR}/${SUBJECT}/mri/aseg.mgz --match 46 47 16 --o ${STL_DIR}/rh_cereb_bs.mgz
mri_tessellate ${STL_DIR}/rh_cereb_bs.mgz 255 ${STL_DIR}/rh_cereb_bs
mris_convert ${STL_DIR}/rh_cereb_bs ${STL_DIR}/rh_cereb_bs.stl

# Subcortical structures
mri_binarize --i ${SUBJECTS_DIR}/${SUBJECT}/mri/aseg.mgz --match 10 11 12 13 17 18 49 50 51 52 53 54 --o ${STL_DIR}/subcortical.mgz
mri_tessellate ${STL_DIR}/subcortical.mgz 255 ${STL_DIR}/subcortical
mris_convert ${STL_DIR}/subcortical ${STL_DIR}/subcortical.stl

# Permissions
chgrp -R MoodGroup "${STL_DIR}"
chmod -R 770 "${STL_DIR}"

echo "STL files generated for ${SUBJECT} in ${STL_DIR}"
