function reslice_voxel(nii_file,voxel_size)
% function reslice_voxel(nii_file,image)
%
% Reslice images to specified voxel size using nearest neighbor interpolation
% 
% INPUTS:
%   nii_file (string) - Nifti-1 filename
%   voxel_size [float float float]
%       EV9F4: [0.1877 0.1877 0.1877]
%       ER7B [0.15 0.15 0.15]
%       MR - case dependent
%
% OUTPURS:
%   new resliced images are saved 
%
% EXAMPLE: reslice_voxel('P27_reg_US.nii',[0.1877 0.1877 0.1877);

addpath('/radforce/mlp6/NIFTI_MATLAB');

resliced_filename = regexprep(nii_file,'.nii.gz','_resliced.nii.gz');

reslice_nii(nii_file,resliced_filename,voxel_size,1,0,2);
