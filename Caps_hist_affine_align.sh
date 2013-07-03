#!/bin/bash
# hist_affine_align.sh - run ANTS and WarpImageMultiTransform to grossly align
# histology slides to one another
#
# Mark Palmeri (mlp6) & Sam Lipman (sll16)
# 2012-02-04
###########################################################################
#Updated 2012-06-26 by Mark and Sam
#Takes a reference slide (typically a large slice in the middle of the volume)
#and aligns the slides adjacent to it. It uses these registered images to align 
#the next adjacent slides to build up a volume in a more realistic manner
###########################################################################

#Variables to Change
PATIENT_NUM=59
SLIDE_REF_START=5
#SLIDE_LETTER='B'
MIN_SLIDE_NUM=1
MAX_SLIDE_NUM=12


HIST_PATH='/krnlab/ProstateStudy/invivo/Patient'$PATIENT_NUM'/Histology'
REG_PATH=$HIST_PATH'/registered'
SLIDE_NII='P'$PATIENT_NUM'_BW_seg-CHANGEME.nii' # CHANGEME will be the slide letter and number of interest (set below)
CAPS_NII='P'$PATIENT_NUM'_capsule-CHANGEME.nii'

# create the registered directory if it doesn't exist
if [ ! -d $REG_PATH ]
then
    mkdir -v $REG_PATH
fi

# handle the starting slide differently (can't just copy b/c of problems w/
# native bit-depth changing with ANTs save)
SLIDE_REF_START_NUM=`printf '%04i' $SLIDE_REF_START`
SLIDE_N_NII=`echo $SLIDE_NII | sed s/CHANGEME/$SLIDE_REF_START_NUM/`
CAPS_N_NII=`echo $CAPS_NII | sed s/CHANGEME/$SLIDE_REF_START_NUM/`

ANTS_OUTPUT='ANTS_'$PATIENT'_'$SLIDE_REF_START'_'$SLIDE_REF_START'_ab_'
ANTS 2 -m CC[$HIST_PATH/$SLIDE_N_NII,$HIST_PATH/$SLIDE_N_NII,1,12] -i 0 -o $REG_PATH/$ANTS_OUTPUT --rigid-affine true
WARP_OUTPUT_NII='P'$PATIENT_NUM'_'$SLIDE_REF_START'_'$SLIDE_REF_START'_reg.nii'
WARP_CAPS_OUTPUT_NII='P'$PATIENT_NUM'_capsule_'$SLIDE_REF_START'_'$SLIDE_REF_START'_reg.nii'

WarpImageMultiTransform 2 $HIST_PATH/$SLIDE_N_NII $REG_PATH/$WARP_OUTPUT_NII -R $HIST_PATH/$SLIDE_N_NII $REG_PATH/$ANTS_OUTPUT\Affine.txt --use-NN
WarpImageMultiTransform 2 $HIST_PATH/$CAPS_N_NII $REG_PATH/$WARP_CAPS_OUTPUT_NII -R $HIST_PATH/$SLIDE_N_NII $REG_PATH/$ANTS_OUTPUT\Affine.txt --use-NN

for (( n=$SLIDE_REF_START+1; n<=$MAX_SLIDE_NUM; n++ ))
do
    SLIDE_REF_NUM=$[$n-1]
    S_REF_NUM=`printf '%04i' $SLIDE_REF_NUM`
    S_NUM=`printf '%04i' $[$n-1 +1]`
    SLIDE_N_NII=`echo $SLIDE_NII | sed s/CHANGEME/$S_NUM/`
    CAPS_N_NII=`echo $CAPS_NII | sed s/CHANGEME/$S_NUM/`

    echo $SLIDE_N_NII
    echo $CAPS_N_NII

    ANTS_OUTPUT='ANTS_'$PATIENT'_'$n'_'$SLIDE_REF_NUM'_ab_'

    if [ $SLIDE_REF_NUM == $SLIDE_REF_START ]
    then
        REG_SLIDE_NII='P'$PATIENT_NUM'_'$SLIDE_REF_NUM'_'$SLIDE_REF_NUM'_reg.nii'
        REG_CAPS_SLIDE_NII='P'$PATIENT_NUM'_capsule_'$SLIDE_REF_NUM'_'$SLIDE_REF_NUM'_reg.nii'
    else
        REG_SLIDE_NII='P'$PATIENT_NUM'_'$SLIDE_REF_NUM'_'$[$SLIDE_REF_NUM-1]'_reg.nii'
        REG_CAPS_SLIDE_NII='P'$PATIENT_NUM'_capsule_'$SLIDE_REF_NUM'_'$[$SLIDE_REF_NUM-1]'_reg.nii'

    fi
    ANTS 2 -m CC[$REG_PATH/$REG_SLIDE_NII,$HIST_PATH/$SLIDE_N_NII,1,12] -i 0 -o $REG_PATH/$ANTS_OUTPUT --rigid-affine true

    WARP_OUTPUT_NII='P'$PATIENT_NUM'_'$n'_'$SLIDE_REF_NUM'_reg.nii'
    WARP_CAPS_OUTPUT_NII='P'$PATIENT_NUM'_capsule_'$n'_'$SLIDE_REF_NUM'_reg.nii'

    WarpImageMultiTransform 2 $HIST_PATH/$SLIDE_N_NII $REG_PATH/$WARP_OUTPUT_NII -R $REG_PATH/$REG_SLIDE_NII $REG_PATH/$ANTS_OUTPUT\Affine.txt --use-NN
    WarpImageMultiTransform 2 $HIST_PATH/$CAPS_N_NII $REG_PATH/$WARP_CAPS_OUTPUT_NII -R $REG_PATH/$REG_SLIDE_NII $REG_PATH/$ANTS_OUTPUT\Affine.txt --use-NN

done

for (( n=$SLIDE_REF_START-1; n>=$MIN_SLIDE_NUM; n-- ))
do
    SLIDE_REF_NUM=$[$n+1]
    S_REF_NUM=`printf '%04i' $SLIDE_REF_NUM`
    S_NUM=`printf '%04i' $n`
    SLIDE_N_NII=`echo $SLIDE_NII | sed s/CHANGEME/$S_NUM/`
    CAPS_N_NII=`echo $CAPS_NII | sed s/CHANGEME/$S_NUM/`

    ANTS_OUTPUT='ANTS_'$PATIENT'_'$SLIDE_LETTER$n'_'$SLIDE_LETTER$SLIDE_REF_NUM'_ab_'

    if [ $SLIDE_REF_NUM == $SLIDE_REF_START ]
    then
        REG_SLIDE_NII='P'$PATIENT_NUM'_'$SLIDE_LETTER$SLIDE_REF_NUM'_'$SLIDE_LETTER$SLIDE_REF_NUM'_reg.nii'
        REG_CAPS_SLIDE_NII='P'$PATIENT_NUM'_capsule_'$SLIDE_REF_NUM'_'$SLIDE_REF_NUM'_reg.nii'
    else
        REG_SLIDE_NII='P'$PATIENT_NUM'_'$SLIDE_LETTER$SLIDE_REF_NUM'_'$SLIDE_LETTER$[$SLIDE_REF_NUM+1]'_reg.nii'
        REG_CAPS_SLIDE_NII='P'$PATIENT_NUM'_capsule_'$SLIDE_REF_NUM'_'$[$SLIDE_REF_NUM-1]'_reg.nii'
    fi
    ANTS 2 -m CC[$REG_PATH/$REG_SLIDE_NII,$HIST_PATH/$SLIDE_N_NII,1,12] -i 0 -o $REG_PATH/$ANTS_OUTPUT --rigid-affine true

    WARP_OUTPUT_NII='P'$PATIENT_NUM'_'$SLIDE_LETTER$n'_'$SLIDE_LETTER$SLIDE_REF_NUM'_reg.nii'
    WARP_CAPS_OUTPUT_NII='P'$PATIENT_NUM'_capsule_'$n'_'$SLIDE_REF_NUM'_reg.nii'


    WarpImageMultiTransform 2 $HIST_PATH/$SLIDE_N_NII $REG_PATH/$WARP_OUTPUT_NII -R $REG_PATH/$REG_SLIDE_NII $REG_PATH/$ANTS_OUTPUT\Affine.txt --use-NN
    WarpImageMultiTransform 2 $HIST_PATH/$CAPS_N_NII $REG_PATH/$WARP_CAPS_OUTPUT_NII -R $REG_PATH/$REG_SLIDE_NII $REG_PATH/$ANTS_OUTPUT\Affine.txt --use-NN

done
