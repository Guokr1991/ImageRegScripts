#!/usr/local/bin/python2.7
'''
adjust_canvas_size.py - adjust canvas size of the path Nifti1 stack to match the native imaging modality canvas size
'''

__name__ = "Mark Palmeri"
__email__ = "mlp6@duke.edu"

import re,sys,os

if sys.version < '2.7':
    sys.exit("ERROR: Requires Python >= v2.7") # needed for argparse

import argparse

# lets read in some command-line arguments
parser = argparse.ArgumentParser(description="Generate ImageJ macro to adjust canvas size to specified values",formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument("--fname",help="Nifti1 filename to adjust",default="P_resliced.nii")
parser.add_argument("--x",help="Target canvas size (X: 512, 585 (EV9F4), 737 (ER7B))",default="512")
parser.add_argument("--y",help="Target canvas size (Y: 512, 286 (EV9F4), 370 (ER7B))",default="512")
parser.add_argument("--z",help="Number of z slices (get from PrintHeader)",default="10")
args = parser.parse_args()

x = int(args.x)
y = int(args.y)
z = int(args.z)
nii_file = args.fname

fid = open('adjust_canvas_size.ijm','w')

fid.write('open("%s");\n' % (nii_file))
fid.write('run("Canvas Size...", "width=%i height=%i position=Center zero");\n' % (x,y))

fname_start = re.sub('.nii','',nii_file)
fid.write('run("NIfTI-1", "save=./%s_%i_%i_%i.nii");\n' % (fname_start,x,y,z))
fid.close()

os.system('~/local/ImageJ/jre/bin/java -Xmx5000m -jar ~/local/ImageJ/ij.jar -ijpath ~/local/ImageJ -batch adjust_canvas_size.ijm')
