znum=$(/krnlab/ProstateStudy/invivo/ImageRegScripts/zDim.sh P64_reg_US_resliced.nii)
/krnlab/ProstateStudy/invivo/ImageRegScripts/adjust_canvas_size.py --fname P64_reg_US_resliced.nii --x 737 --y 370 --z $znum
/krnlab/ProstateStudy/invivo/ImageRegScripts/adjust_canvas_size.py --fname P64_capsule_reg_US_resliced.nii --x 737 --y 370 --z $znum
