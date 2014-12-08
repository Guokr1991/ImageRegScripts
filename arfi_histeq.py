#!/bin/env python
"""
script to apply histogram equialization with ImageJ to ARFI stacks acquired with the ER7B.  The hist eq is
applied with ImageRegScripts/prostate_arfi_histeq.ijm.

Mark Palmeri
mlp6@duke.edu
2013-07-09
"""

import os

root = "/luscinia/ProstateStudy/invivo"

#pnums = range(56, 98, 1)
#pnums = (62, 63, 64, 67)
pnums = (71, )

for p in pnums:
    pdir = "%s/Patient%i" % (root, p)
    if os.path.exists(pdir):
        os.chdir(pdir)
        print(pdir)
        if not os.path.exists("slicer"):
            os.mkdir("slicer")
        os.chdir("slicer")
        try:
            #os.system("ln -fs ../loupas/avolume_ts3* ./ARFI.nii.gz")
            os.system("/usr/local/ImageJ/jre/bin/java -Xmx5000m -jar /usr/local/ImageJ/ij.jar -ijpath /usr/local/ImageJ -batch /luscinia/ProstateStudy/ImageRegScripts/prostate_arfi_histeq.ijm")
            os.system("gzip -fv ARFI_Norm_HistEq.nii")
        except:
            print("ARFI imaging data does not exist for this patient.")
