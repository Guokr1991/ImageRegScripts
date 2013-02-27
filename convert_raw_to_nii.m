function convert_raw_to_nii(filename,height,width,num_images);
% function convert_raw_to_nii(filename,height,width,num_images);
% INPUTS:   filename - name of the raw file w/o the .raw extension (CWD)
%           height - image heigh (pixels)
%           width - image width (pixels)
%           num_images - number of image frames in the RAW sequence
%
% OUTPUTS:  filename.nii is written in the CWD
% 
% EXAMPLE: convert_raw_to_nii('MRI_compressed_BPH_737_370_366_1000',737,370,366)
%
% Mark Palmeri (mlp6)
% mark.palmeri@duke.edu
% 2012-06-15

% command to launch ImageJ on your system
PATH_IMAGEJ = '/usr/bin/java -Xmx5120m -jar /usr/local/ImageJ/ij.jar -ijpath /usr/local/ImageJ';
IMAGEJ_MACRO_FILE = 'raw_to_nii.txt';

cwd = pwd;

fid = fopen(IMAGEJ_MACRO_FILE,'w');

disp(filename)

fprintf(fid,'run("Raw...", "open=%s/%s.raw image=[16-bit Unsigned] width=%i height=%i offset=0 number=%i gap=0");\n',cwd,filename,height,width,num_images);
fprintf(fid,'run("NIfTI-1", "save=%s/%s.nii");\n',cwd,filename);
fprintf(fid,'run("Quit");\n');

system(sprintf('%s -batch %s',PATH_IMAGEJ,IMAGEJ_MACRO_FILE))

fclose(fid);
