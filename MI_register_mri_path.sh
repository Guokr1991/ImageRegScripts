#!/bin/bash
# register_mri_path.sh - register MRI images to pathology
# Mark Palmeri (mlp6) & Sam Lipman (sll16)
# 2012-02-06
#####################################################################################
# MODIFIED 2013-01-20 (Mark & Sam)
# consolidated variables for more generic patient application
# cleaned up using new MI registration parameters
# registered path reflect MI parameters
# made the P# the first commandline argument and the number of slices in the
# stack, including blanks, the second commandline argument
#####################################################################################

#ulimit -v 8000000
#ulimit -d 8000000

PATHOLOGY="allpath"

PNUM=$1
NUM_MR_SEG_SLICES=$2
PATIENT='Patient'$PNUM
MRI_HIST_NII='Histo_MRI_'$PATHOLOGY'_regtest_MI.nii'
P_PATH='/krnlab/ProstateStudy/invivo/'$PATIENT
HIST_REG_PATH=$P_PATH'/Histology/registered'
MR_PATH=$P_PATH'/MRI_Images'

# setup MI parameters
SYN=1.2 # MI step size
SYN_PATH=`echo $SYN | tr . p`
NUM_BINS=32
ITERS='200x200x100x50'

REG_PATH=$P_PATH'/registered/SyN'$SYN_PATH'_NumBins'$NUM_BINS'_Iters'$ITERS

echo 'Running ANTS image registration for '$PATIENT

if [ ! -e $REG_PATH ]
then
    mkdir -p $REG_PATH
    echo 'Creating Directory: '$REG_PATH
fi


MRI_CAPSULE='P'$PNUM'_caps_seg.nii'
HIST_CAPSULE='P'$PNUM'_capsule_reg_MR_resliced_512_512_'$NUM_MR_SEG_SLICES'.nii'
MRI_HIST_CAPSULE='ANTS_Histo_MRI_ab_'
HIST_CAPSULE_W_HIST='P'$PNUM'_reg_MR_resliced_512_512_'$NUM_MR_SEG_SLICES'.nii'

HIST_MRI_ANTS_MI='Histo_MRI_MI'

ANTS 3 -m MI[ $MR_PATH/$MRI_CAPSULE,$HIST_REG_PATH/$HIST_CAPSULE,1,$NUM_BINS] -i 0 -o $REG_PATH/$MRI_HIST_CAPSULE

ANTS 3 -m MI[ $MR_PATH/$MRI_CAPSULE,$HIST_REG_PATH/$HIST_CAPSULE,1,$NUM_BINS] -o $REG_PATH/$HIST_MRI_ANTS_MI -i $ITERS -t SyN[$SYN] -a $REG_PATH/$MRI_HIST_CAPSULE\Affine.txt #-r Gauss[0 3] 

WarpImageMultiTransform 3 $HIST_REG_PATH/$HIST_CAPSULE_W_HIST $REG_PATH/$MRI_HIST_NII -R $MR_PATH/$MRI_CAPSULE $REG_PATH/$HIST_MRI_ANTS_MI\Warp.nii.gz $REG_PATH/$MRI_HIST_CAPSULE\Affine.txt --use-NN
