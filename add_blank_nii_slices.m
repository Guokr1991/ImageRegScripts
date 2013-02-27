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
if (length(path_seg) > length(image_seg)),
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
else,
    num_blanks_to_have_each_side = ceil(((num_nonzero_image_slices - num_nonzero_path_slices) + 2)/2);
    
    % add zeros to the front of the vector as needed (the sum indicates the number of positions that are non-zero)
    path_blanks_to_add(1) = sum(path_seg(1:num_blanks_to_have_each_side))

    % do the same to the end
    path_blanks_to_add(2) = sum(path_seg(end:-1:(end-num_blanks_to_have_each_side+1)))
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
new_filename = regexprep(original_filename,'\d\d.nii',sprintf('%i.nii',new_num_slices));
keyboard
fprintf(fid,'run("NIfTI-1", "save=./%s");\n',new_filename);
fclose(fid);
system('~/local/ImageJ/jre/bin/java -Xmx5000m -jar ~/local/ImageJ/ij.jar -ijpath ~/local/ImageJ -batch add_blank_nii_slices.ijm');
return;
