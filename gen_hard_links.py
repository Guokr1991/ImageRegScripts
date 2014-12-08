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

pnums = range(56, 98, 1)

for p in pnums:
    pdir = "%s/Patient%i" % (root, p)
    if os.path.exists(pdir):
        os.chdir(pdir)
        print(pdir)
        if not os.path.exists("slicer"):
            os.mkdir("slicer")
        os.chdir("slicer")
        try:
            os.system("ln -f ../loupas/ccvolume_ts3* ./ARFI_CC_Mask.nii.gz")
        except:
            print("ARFI imaging data does not exist for this patient.")
