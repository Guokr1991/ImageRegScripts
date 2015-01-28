import glob, os

adcdirs = glob.glob('/home/mlp6/ADC/P*')

for origdir in adcdirs:
    pnum = origdir.replace('/home/mlp6/ADC/P', '')
    target_path = '/luscinia/ProstateStudy/invivo/Patient%s/MRI_Images/ADC/' \
        % pnum
    if not os.path.exists(target_path):
        os.system('mkdir -p %s' % target_path)
        print('I just made %s!!' % target_path)
    else:
        print('Target directory already exists!!')
    os.system('rsync -av %s/_r*/ %s' % (origdir, target_path))
