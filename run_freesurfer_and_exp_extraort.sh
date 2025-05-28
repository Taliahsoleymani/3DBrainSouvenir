#!/bin/bash

# ========== USER CONFIG ==========
export PROJECT_ROOT=/data/MoodGroup/code/Taliah/3D_Brain_Printing
export SUBJECT=$1  # e.g., sub-001
export T1_FILE=$(find ${PROJECT_ROOT}/raw_data/${SUBJECT} -name "*.nii" | head -n 1)
export SUBJECTS_DIR=${PROJECT_ROOT}/derivatives/freesurfer
export STL_DIR=${PROJECT_ROOT}/derivatives/stl/${SUBJECT}
mkdir -p ${SUBJECTS_DIR} ${STL_DIR}
# =================================

module load freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

# ====== Run recon-all if not already done ======
if [ ! -d "${SUBJECTS_DIR}/${SUBJECT}" ]; then
  recon-all -all -sd "${SUBJECTS_DIR}" -s "${SUBJECT}" -i "${T1_FILE}"
fi

# ====== Export cortical surfaces ======
for hemi in lh rh; do
  mris_convert "${SUBJECTS_DIR}/${SUBJECT}/surf/${hemi}.pial" \
    "${STL_DIR}/${hemi}_pial.stl"
done

# ====== Binarize cerebellum + brainstem ======
mri_binarize --i "${SUBJECTS_DIR}/${SUBJECT}/mri/aseg.mgz" \
  --match 8 7 16 \
  --o "${STL_DIR}/lh_cereb_bs.mgz"

mri_binarize --i "${SUBJECTS_DIR}/${SUBJECT}/mri/aseg.mgz" \
  --match 47 46 16 \
  --o "${STL_DIR}/rh_cereb_bs.mgz"

mri_tessellate "${STL_DIR}/lh_cereb_bs.mgz" 1 "${STL_DIR}/lh_cereb_bs"
mri_tessellate "${STL_DIR}/rh_cereb_bs.mgz" 1 "${STL_DIR}/rh_cereb_bs"

mris_convert "${STL_DIR}/lh_cereb_bs" "${STL_DIR}/lh_cereb_bs.stl"
mris_convert "${STL_DIR}/rh_cereb_bs" "${STL_DIR}/rh_cereb_bs.stl"

# ====== Optional: Subcortical extraction ======
mri_binarize --i "${SUBJECTS_DIR}/${SUBJECT}/mri/aseg.mgz" \
  --match 10 49 11 50 12 51 17 53 18 54 4 43 31 63 \
  --o "${STL_DIR}/subcortical.mgz"

mri_tessellate "${STL_DIR}/subcortical.mgz" 1 "${STL_DIR}/subcortical"
mris_convert "${STL_DIR}/subcortical" "${STL_DIR}/subcortical.stl"

# ====== Permissions ======
chgrp -R MoodGroup "${STL_DIR}"
chmod -R 770 "${STL_DIR}"

