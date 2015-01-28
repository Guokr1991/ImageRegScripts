import glob
import os

adcdirs = glob.glob('/home/mlp6/ADC/P*')

for d in adcdirs:
    pnum = d.replace('/home/mlp6/ADC/P', '')
    adc_path = '/luscinia/ProstateStudy/invivo/Patient%s/MRI_Images/ADC' % pnum
    os.system('chmod 755 %s' % adc_path)
    os.chdir(adc_path)
    os.system('/luscinia/ProstateStudy/ImageRegScripts/adc.sh %s' % pnum)
