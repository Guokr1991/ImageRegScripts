cp /krnlab/ProstateStudy/invivo/ImageRegScripts/adc_dcm_nii.ijm .
numdcm=`ls *.dcm | wc -l`
sed -i -e "s/ZZ/$numdcm/" adc_dcm_nii.ijm
firstdcm=`ls *001.dcm` 
sed -i -e "s/YY/$firstdcm/" adc_dcm_nii.ijm
sed -i -e "s/XX/$1/g" adc_dcm_nii.ijm
~/local/ImageJ/jre/bin/java -Xmx5000m -jar ~/local/ImageJ/ij.jar -ijpath ~/local/ImageJ -batch adc_dcm_nii.ijm
tar -zcvf P$1_ADC.tgz *.dcm
gpg --encrypt P$1_ADC.tgz
rm -fv P$1_ADC.tgz *.dcm
