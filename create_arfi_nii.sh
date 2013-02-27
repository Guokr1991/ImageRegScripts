#find /krnlab/ProstateStudy/invivo/ -type d -name AxialImages_imwrite > arfi_cases.txt
find /luscinia/ProstateStudy/invivo/ -type d -name AxialImages_imwrite >> arfi_cases.txt
for i in `cat arfi_cases.txt`
do 
    Pnum=$(echo $i | awk 'BEGIN { FS = "/" } ; {print $5}' | tr -d Patient)
    echo $Pnum
    cd /krnlab/ProstateStudy/invivo/Patient$Pnum/loupas/AxialImages_imwrite/
    cp /krnlab/ProstateStudy/invivo/ImageRegScripts/arfi_jpg_nii.ijm .
    numjpg=`ls arfi_ts3*.jpg | wc -l`
    sed -i -e "s/YY/$numjpg/g" arfi_jpg_nii.ijm
    sed -i -e "s/XX/$Pnum/g" arfi_jpg_nii.ijm
    ~/local/ImageJ/jre/bin/java -Xmx5000m -jar ~/local/ImageJ/ij.jar -ijpath ~/local/ImageJ -batch arfi_jpg_nii.ijm
done
