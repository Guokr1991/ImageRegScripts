cp /luscinia/ProstateStudy/ImageRegScripts/adc_dcm_nii.ijm .
numdcm=`ls *.dcm | wc -l`
sed -i -e "s/ZZ/$numdcm/" adc_dcm_nii.ijm
firstdcm=`ls *001.dcm` 
sed -i -e "s/YY/$firstdcm/" adc_dcm_nii.ijm
sed -i -e "s/XX/$1/g" adc_dcm_nii.ijm
/usr/local/ImageJ/jre/bin/java -Xmx5000m -jar /usr/local/ImageJ/ij.jar -ijpath /usr/local/ImageJ -batch adc_dcm_nii.ijm
tar -cvf P$1_ADC.tar *.dcm
gpg -e P$1_ADC.tar
rm -fv P$1_ADC.tar *.dcm adc_dcm_nii.ijm
gzip -v P$1_ADC.nii
