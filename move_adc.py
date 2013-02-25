import glob,os

adcdirs=glob.glob('/krnlab/ProstateStudy/invivo/ADC_Maps/P*_ADC')

for origdir in adcdirs:
    print(origdir)
    pnum = int(origdir[39:41])
    target_path = '/krnlab/ProstateStudy/invivo/Patient%i/MRI_Images/Sequences/ADC/' % pnum
    if not os.path.exists(target_path):

        os.system('sudo -u sll16 mkdir -p %s' % target_path)
        print('I just made %s!!' % target_path)
    else:
        print('Target directory already exists!!')
    os.system('sudo -u sll16 cp -v %s/* %s' % (origdir,target_path))
