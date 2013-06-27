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
NUM_US_SEG_SLICES=$2
PATIENT='Patient'$PNUM
US_HIST_NII='Histo_US_'$PATHOLOGY'_regtest_CC.nii'
P_PATH='/krnlab/ProstateStudy/invivo/'$PATIENT
HIST_REG_PATH=$P_PATH'/Histology/registered'
US_PATH=$P_PATH'/loupas.old'

# setup MI parameters
SYN=1.2 # MI step size
SYN_PATH=`echo $SYN | tr . p`
RADIUS=8
#RADIUS=$4
ITERS='200x200x100x50'

REG_PATH=$P_PATH'/registered/US_CC_SyN'$SYN_PATH'_Radius'$RADIUS'_Iters'$ITERS

echo 'Running ANTS image registration for '$PATIENT

if [ ! -e $REG_PATH ]
then
    mkdir -p $REG_PATH
    echo 'Creating Directory: '$REG_PATH
fi


US_CAPSULE='Patient'$PNUM'_seg.nii.gz'
HIST_CAPSULE='P'$PNUM'_capsule_reg_US_resliced_737_370_'$NUM_US_SEG_SLICES'.nii.gz'
US_HIST_CAPSULE='ANTS_Histo_US_ab_'
HIST_CAPSULE_W_HIST='P'$PNUM'_reg_US_resliced_737_370_'$NUM_US_SEG_SLICES'.nii.gz'

HIST_US_ANTS_CC='Histo_US_CC_'

ANTS 3 -m CC[ $US_PATH/$US_CAPSULE,$HIST_REG_PATH/$HIST_CAPSULE,1,$RADIUS] -i 0 -o $REG_PATH/$US_HIST_CAPSULE

ANTS 3 -m CC[ $US_PATH/$US_CAPSULE,$HIST_REG_PATH/$HIST_CAPSULE,1,$RADIUS] -o $REG_PATH/$HIST_US_ANTS_CC -i $ITERS -t SyN[$SYN] -a $REG_PATH/$US_HIST_CAPSULE\Affine.txt #-r Gauss[0 3] 

WarpImageMultiTransform 3 $HIST_REG_PATH/$HIST_CAPSULE_W_HIST $REG_PATH/$US_HIST_NII -R $US_PATH/$US_CAPSULE $REG_PATH/$HIST_US_ANTS_CC\Warp.nii.gz $REG_PATH/$US_HIST_CAPSULE\Affine.txt --use-NN

gzip -v $US_HIST_NII
