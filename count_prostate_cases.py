#!/bin/env python
"""
count_prostate_cases.py

Walk the in vivo directory tree and check what result files exist for histology,
B-mode/ARFI and MRI.

There are the unique files to look for:

    ARFI Files
    /luscinia/ProstateStudy/invivo/PatientXX/slicer/ARFI_CC_Mask.nii.gz
    /luscinia/ProstateStudy/invivo/PatientXX/slicer/ARFI_Norm_HistEq.nii.gz
    /luscinia/ProstateStudy/invivo/PatientXX/slicer/Bmode.nii.gz
    /luscinia/ProstateStudy/invivo/PatientXX/slicer/us_cap.vtk

    MRI Files
    /luscinia/ProstateStudy/invivo/PatientXX/MRI_Images/T2
    (look for any file in this directory/check if empty)

    /luscinia/ProstateStudy/invivo/PatientXX/MRI_Images/ADC
    (look for any file in this directory, the ADC maps are in different formats
    for many patients, e.g. some are Nifty (P62) but some are series of images
    (P80))

    Path Files
    /luscinia/ProstateStudy/invivo/Patient93/Histology/Images
    (look for any file in this directory, if there are more than 1 file, then
    there are separate image files for each pathology slide)
    /luscinia/ProstateStudy/invivo/Patient93/Histology/Path_Report
    (look for any file in this directory)

We will only look at P56-P016; earlier cases with old ultrasound configurations
will not be considered.

Mark Palmeri
Tyler Glass
2014-11-15
"""


def main():
    import os

    Pmin = 56
    Pmax = 106

    invivo = '/luscinia/ProstateStudy/invivo'

    ARFI = [0]*(Pmax+1)
    MRI = [0]*(Pmax+1)
    HIST = [0]*(Pmax+1)

    for root, dirs, files in os.walk(invivo):
        if 'Tyler_Patients' in root:
            continue
        elif 'ARFI_Norm_HistEq.nii.gz' in files:
            Pnum = extract_Pnum(root)
            ARFI[Pnum] = 1
        elif 'T2' in os.path.basename(root):
            if os.listdir(root):
                Pnum = extract_Pnum(root)
                MRI[Pnum] = 1
        elif 'Images' in os.path.basename(root) and 'Histology' in root:
            if os.listdir(root):
                Pnum = extract_Pnum(root)
                HIST[Pnum] = 1

    ARFI = ARFI[Pmin::]
    MRI = MRI[Pmin::]
    HIST = HIST[Pmin::]

    print "Case Counts (P%i - P%i)" % (Pmin, Pmax)
    print "========================"
    print "Total ARFI: %i" % sum(ARFI)
    print "Total HIST: %i" % sum(HIST)
    print "Total MRI: %i" % sum(MRI)

    ARFI_HIST_MRI = [a + b + c for a, b, c in zip(ARFI, HIST, MRI)]
    print "ARFI + HIST + MRI: %i" % (ARFI_HIST_MRI.count(3))
    ARFI_HIST = [a + b for a, b in zip(ARFI, HIST)]
    print "ARFI + HIST: %i" % (ARFI_HIST.count(2))
    MRI_HIST = [a + b for a, b in zip(MRI, HIST)]
    print "MRI + HIST: %i" % (MRI_HIST.count(2))
    ARFI_MRI = [a + b for a, b in zip(ARFI, MRI)]
    print "ARFI + MRI: %i" % (ARFI_MRI.count(2))

    print "\nPatient Numbers"
    print "==============="
    print "ARFI + HIST + MRI"
    print [i+Pmin for i, j in enumerate(ARFI_HIST_MRI) if j == 3]
    print "ARFI + HIST"
    print [i+Pmin for i, j in enumerate(ARFI_HIST) if j == 2]
    print "MRI + HIST"
    print [i+Pmin for i, j in enumerate(MRI_HIST) if j == 2]
    print "ARFI + MRI"
    print [i+Pmin for i, j in enumerate(ARFI_MRI) if j == 2]


def extract_Pnum(r):
    """
    Extract P# from path, assuming it is the 4th string in the absolute path.
    """
    PtPathLoc = 4
    pt = r.split('/')[PtPathLoc]
    try:
        pnum = int(pt.strip('Patient'))
        return pnum
    except:
        print "Not in a patient directory"

if __name__ == '__main__':
    main()
