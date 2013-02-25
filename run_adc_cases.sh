for i in `cat adc_cases.txt`
do 
    Pnum=$(echo $i | awk 'BEGIN { FS = "/" } ; {print $5}' | tr -d Patient)
    echo $Pnum
    cd /krnlab/ProstateStudy/invivo/Patient$Pnum/MRI_Images/Sequences
    sudo -u sll16 chmod 775 ADC
    cd ADC
    /krnlab/ProstateStudy/invivo/ImageRegScripts/adc.sh $Pnum
done
