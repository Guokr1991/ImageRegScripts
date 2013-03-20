#!/usr/local/bin/python2.7
'''
overlay_us.py - generate an ImageJ macro to generate overlays of PCA, BPH and
atrophy on ARFI / Bmode images from user-input variables (described using --help); based on overlay_mr.py
'''

__author__ = "Mark Palmeri"
__email__ = "mark.palmeri@duke.edu"
__created__ = "2013-02-28"

def main():
    import os,sys,shutil,re

    if sys.version < '2.7':
        sys.exit("ERROR: Requires Python >= v2.7") # needed for argparse

    import argparse

    # lets read in some command-line arguments
    parser = argparse.ArgumentParser(description="Generate ImageJ macro to generate MR / PCA overlay images",formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument("--root",help="Root directory for all invivo patient data",default="/krnlab/ProstateStudy/invivo")
    parser.add_argument("--pnum",help="Patient number (int)",default="65")
    parser.add_argument("--us_hist_path",help="Path in ROOT/PatientPNUM containing US Histology Nifti input",default="registered/US_CC_SyN1p2_Radius8_Iters200x200x100x50")
    parser.add_argument("--us_hist_nii",help="US Histology Nifti input",default="Histo_US_allpath_regtest_CC.nii")
    parser.add_argument("--us_path",help="path for US Nifti input",default="loupas")
    parser.add_argument("--arfi_path",help="path for ARFI Nifti input",default="AxialImages_imwrite")
    parser.add_argument("--arfi_nii",help="ARFI Nifti input",default="P_ARFI_TS3.nii")
    parser.add_argument("--bmode_raw",help="B-mode Nifti input",default="bvolume_737_370_366.raw")
    parser.add_argument("--reg_final_vol",help="path for registered final volume in ROOT/PatientPNUM",default="registered/US_CC_SyN1p2_Radius8_Iters200x200x100x50/final_volumes")
    parser.add_argument("--ijm_template_path",help="ImageJ macro template path",default="/krnlab/ProstateStudy/invivo/ImageRegScripts")
    parser.add_argument("--ijm_template",help="ImageJ macro template",default="Gen_US_Overlays.ijm")
    parser.add_argument("--ij",help="Path and commandline syntax to run ImageJ in batch mode",default="~/local/ImageJ/jre/bin/java -Xmx10000m -jar ~/local/ImageJ/ij.jar -ijpath ~/local/ImageJ")

    args = parser.parse_args()
    ROOT = args.root
    ROOT_PNUM = '%s/Patient%i' % (args.root,int(args.pnum))
    US_HIST_PATH = args.us_hist_path
    US_HIST_NII = args.us_hist_nii
    US_PATH = args.us_path
    ARFI_PATH = args.arfi_path
    ARFI_NII = args.arfi_nii
    BMODE_RAW= args.bmode_raw
    REG_FINAL_VOL = args.reg_final_vol
    IJM_TEMPLATE_PATH = args.ijm_template_path
    IJM_TEMPLATE = args.ijm_template
    IJ = args.ij

    IJM_STRING_SUBS = {
        'ROOT_PNUM' : ROOT_PNUM,
        'US_HIST_PATH' : US_HIST_PATH,
        'US_HIST_NII' : US_HIST_NII,
        'US_PATH' : US_PATH,
        'ARFI_PATH' : ARFI_PATH,
        'ARFI_NII' : ARFI_NII,
        'BMODE_RAW' : BMODE_RAW,
        'REG_FINAL_VOL' : REG_FINAL_VOL,
        }
    re_ijm_sub = re.compile('|'.join(IJM_STRING_SUBS.keys()))

    # check for existence of specified files and directories (create some
    # directories if they don't exist)
    check_dir_file_exist('ROOT_PNUM',ROOT_PNUM)
    check_dir_file_exist('US_HIST_PATH','%s/%s' % (ROOT_PNUM,US_HIST_PATH))
    check_dir_file_exist('US_HIST_NII','%s/%s/%s' % (ROOT_PNUM,US_HIST_PATH,US_HIST_NII))
    check_dir_file_exist('US_PATH','%s/%s' % (ROOT_PNUM,US_PATH))
    check_dir_file_exist('ARFI_NII','%s/%s/%s/%s' % (ROOT_PNUM,US_PATH,ARFI_PATH,ARFI_NII))
    check_dir_file_exist('BMODE_RAW','%s/%s/%s' % (ROOT_PNUM,US_PATH,BMODE_RAW))
    check_dir_file_exist('REG_FINAL_VOL','%s/%s' % (ROOT_PNUM,REG_FINAL_VOL))
    check_dir_file_exist('IJM_TEMPLATE_PATH',IJM_TEMPLATE_PATH)
    check_dir_file_exist('IJM_TEMPLATE','%s/%s' % (IJM_TEMPLATE_PATH,IJM_TEMPLATE))

    # copy IJM template into patient directory and modify for patient-specific files
    P_IJM_FILE = '%s/%s/%s' % (ROOT_PNUM,US_HIST_PATH,IJM_TEMPLATE)
    P_IJM_FID = open(P_IJM_FILE, 'w')
    ijm_temp_file = open('%s/%s' % (IJM_TEMPLATE_PATH,IJM_TEMPLATE),'r')

    for i in ijm_temp_file:
        P_IJM_FID.write(re_ijm_sub.sub(lambda m: IJM_STRING_SUBS[m.group(0)], i))

    ijm_temp_file.close()
    P_IJM_FID.close()

    print('Created ImageJ Batch Macro: %s' % P_IJM_FILE)

    # run ImageJ in batch (headless) mode
    print('Running ImageJ in batch mode...')
    os.system('%s -batch %s' % (IJ,P_IJM_FILE))

    print('Completed generation of overlay images')

#####################################################################################################
def check_dir_file_exist(str_holder,file_dir):
    '''
    Check for existence of file or directory specified in input.  If the
    REG_FINAL_VOL directory doesn't exist, then it is created.
    '''
    import os,sys
    if not os.path.exists(file_dir):
        if str_holder == 'REG_FINAL_VOL':
            os.system('mkdir -p %s' % file_dir)
            print('Created Directory: %s' % file_dir)
        else:
            sys.exit('ERROR: %s = %s does not exist!' % (str_holder, file_dir))
    else:
        print('File/directory existence confirmed: %s' % file_dir)
#####################################################################################################

if __name__ == "__main__":
    main()

