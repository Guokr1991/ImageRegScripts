#!/usr/bin/python2.7
'''
add_blank_nii_slices.py - add blank slices to a Nifti1 stack based on the number of slices in another image stack being registered to

This is replacing add_blank_nii_slices.m, which used the Matlab Nifti1 tools that had bugs in them.
'''

__author__ = 'Mark Palmeri'
__email__ = 'mlp6@duke.edu'
__date__ = '2013-06-25'






function []=add_blank_nii_slices(path_nii_stack,image_nii_stack)
% function []=add_blank_nii_slices(path_nii_stack,image_nii_stack)
% 
% Find blank slices of Nifti1 stack in the z (3) dimension.
%
% INPUTS:
%   path_nii_stack (string) - name of pathology Nifti1 stack
%   image_nii_stack (string) - name of imaging Nifti1 stack (US / MR)
%
% OUTPUTS:
%   ImageJ macro written and executed
%
% EXAMPLE: add_blank_nii_slices('P27_reg_MR_resliced_512_512_12.nii','P27_caps_seg.nii');
%
% Mark Palmeri
% mlp6@duke.edu
% 2013-02-26

addpath('/radforce/mlp6/NIFTI_20121012/');

pathnii = load_nii(path_nii_stack);
imagenii = load_nii(image_nii_stack);

[path_seg]=find_blank_nii_slices(pathnii);
num_nonzero_path_slices = sum(path_seg)

[image_seg]=find_blank_nii_slices(imagenii);
num_nonzero_image_slices = sum(image_seg)

% check to see if path has more slices than image 
% if so, then just add one extra blank to each side of path if they aren't already blank
if (num_nonzero_path_slices > num_nonzero_image_slices),
    disp('Number of pathology stack segmented slices is larger than image stack...');
    if (path_seg(1) ~= 0),
        path_blanks_to_add(1) = 1;
    else,
        path_blanks_to_add(1) = 0;
    end;
    if (path_seg(end) ~=0),
        path_blanks_to_add(2) = 1;
    else,
        path_blanks_to_add(2) = 0;
    end;
    disp(path_blanks_to_add)
else,
    num_blanks_to_have_each_side = ceil(((num_nonzero_image_slices - num_nonzero_path_slices) + 2)/2);
    
    % add zeros to the front of the vector as needed 
    first_nonzero_index = min(find(path_seg > 0));
    path_blanks_to_add(1) = num_blanks_to_have_each_side + 1 - first_nonzero_index;

    % do the same to the end
    last_nonzero_index = max(find(path_seg > 0));
    path_blanks_to_add(2) = num_blanks_to_have_each_side - (length(path_seg) - last_nonzero_index)
end;

write_run_ijm_macro(path_nii_stack,length(path_seg),path_blanks_to_add)

function [seg_vector]=find_blank_nii_slices(nii)
% INPUTS:
%   nii_stack (string) - name of Nifti1 stack
%
% OUTPUTS:
%   seg_vector (Booleans) - 1 if contains segments, 0 if blank

for i=1:size(nii.img,3),
    max_vector(i) = max(max(squeeze(nii.img(:,:,i))));
end;

seg_vector = logical(max_vector);
return;

function write_run_ijm_macro(original_filename,num_orig_slices,blanks_to_add)
fid = fopen('add_blank_nii_slices.ijm','w');
fprintf(fid,'open("%s");\n',original_filename);
fprintf(fid,'setSlice(%i);\n',num_orig_slices); 
if(blanks_to_add(2) > 0),
    for i=1:blanks_to_add(2),
        fprintf(fid,'run("Add Slice");\n');
    end;
end;
fprintf(fid,'run("Reverse");\n');
if(blanks_to_add(1) > 0),
    for i=1:blanks_to_add(1),
        fprintf(fid,'run("Add Slice");\n');
    end;
end;
fprintf(fid,'run("Reverse");\n');
new_num_slices = num_orig_slices+sum(blanks_to_add);
new_filename = regexprep(original_filename,'_\d*.nii',sprintf('_%i.nii',new_num_slices));
fprintf(fid,'run("NIfTI-1", "save=./%s");\n',new_filename);
fclose(fid);
system('~/local/ImageJ/jre/bin/java -Xmx5000m -jar ~/local/ImageJ/ij.jar -ijpath ~/local/ImageJ -batch add_blank_nii_slices.ijm');
return;
