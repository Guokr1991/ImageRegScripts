#!/bin/bash
# register_mri_path.sh - register MRI images to pathology
# Mark Palmeri (mlp6) & Sam Lipman (sll16)
# 2012-02-06

for SGE_TASK_ID in 1 
do
echo $SGE_TASK_ID

date
hostname

# have bash kill the job if we exceed 24G
ulimit -v 25000000
ulimit -d 25000000

PATH_OPTIONS=( dummy allpath capsuleonly lesion BPH )

PATHOLOGY="${PATH_OPTIONS[$SGE_TASK_ID]}"

PATIENT='Patient65'
IMAGE_SIZE='737_370_366' # pixels x pixels x frames
NUM_MRI_FRAMES='36'
MRI_IMAGE_SIZE='512_512_'$NUM_MRI_FRAMES
MRI_PATH_NII='Histo_MRI_'$PATHOLOGY'_regtest_CC_'$IMAGE_SIZE'.nii'
P_PATH='/krnlab/ProstateStudy/invivo/'$PATIENT'/raw_hist_mr_capsule_test_reg'
IMAGES_PATH=$P_PATH
MRI_ITK_SEG_NII='P65_capsule.nii'
REG_PATH=$P_PATH'/registered'

MRI_CAPSULE='P65_capsule.nii'
HIST_CAPSULE='P65_reg_capsule_vol_space_resliced_5blank_512_512_36.nii'
MRI_HIST_CAPSULE='ANTS_Histo_MRI_ab_'$IMAGE_SIZE'_'
HIST_CAPSULE_W_PATH='P65_Hist_reg_vol_MRresliced_5blank.nii'

HIST_MRI_ANTS_CC='Histo_MRI_CC_'$IMAGE_SIZE'_'
#SetSpacing 3 $REG_PATH/$HIST_CAPSULE $REG_PATH/$HIST_CAPSULE 0.3516 0.3516 2.9740028

if [ ! -f $REG_PATH/$MRI_HIST_CAPSULE\Affine.txt ]
then
    echo $REG_PATH/$MRI_HIST_CAPSULE'Affine.txt does not exist; running initial ANTS commands'
    ANTS 3 -m MI[ $REG_PATH/$MRI_CAPSULE,$REG_PATH/$HIST_CAPSULE,1,32] -i 0 -o $REG_PATH/$MRI_HIST_CAPSULE

    ANTS 3 -m MI[ $REG_PATH/$MRI_CAPSULE,$REG_PATH/$HIST_CAPSULE,1,32] -o $REG_PATH/$HIST_MRI_ANTS_CC -i 200x200x100x50 -t SyN[100] -a $REG_PATH/$MRI_HIST_CAPSULE\Affine.txt #-r Gauss[0 3] 
fi

#HIST_PATH_CAPSULE=`echo $HIST_CAPSULE | sed s/no_lesion/$PATHOLOGY/`
    WarpImageMultiTransform 3 $REG_PATH/$HIST_CAPSULE_W_PATH $REG_PATH/$MRI_PATH_NII -R $REG_PATH/$MRI_CAPSULE $REG_PATH/$HIST_MRI_ANTS_CC\Warp.nii.gz $REG_PATH/$MRI_HIST_CAPSULE\Affine.txt --use-NN
#MRI_PATH_NEW='Histo_MRI_'$PATHOLOGY'_scaled_CC_'$IMAGE_SIZE
#MRI_PATH_SCALED_NII='Histo_MRI_'$PATHOLOGY'_scaled_CC_'$IMAGE_SIZE'_'$MRI_IMAGE_SIZE'_base2apex.nii'


#matlab -nodesktop -nosplash -r "addpath('/krnlab/sll16/MATLAB'); make_registered_Histo_MR_sll16('$MRI_PATH_NII', '$MRI_PATH_NEW', $NUM_MRI_FRAMES, 0.15, 0.3516, 2.9740028); quit"



    #SetSpacing 3 $REG_PATH/$MRI_PATH_SCALED_NII $REG_PATH/$MRI_PATH_SCALED_NII 0.3516 0.3516 2.9740028

    #HIST_MRI_PATH_ANTS_CC='ANTS_reg_Histo_MRI_'$PATHOLOGY'_ab_'$IMAGE_SIZE'_'
    #ANTS 3 -m CC[ $IMAGES_PATH/$MRI_ITK_SEG_NII,$REG_PATH/$MRI_PATH_SCALED_NII,1, 8] -i 0 -o $REG_PATH/$HIST_MRI_PATH_ANTS_CC

    #WarpImageMultiTransform 3 $REG_PATH/$MRI_PATH_SCALED_NII $REG_PATH/Reg_$MRI_PATH_SCALED_NII -R $IMAGES_PATH/$MRI_ITK_SEG_NII $REG_PATH/$HIST_MRI_PATH_ANTS_CC\Affine.txt --use-NN
done
