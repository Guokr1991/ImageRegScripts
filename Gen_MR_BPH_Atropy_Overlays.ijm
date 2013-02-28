open("ROOT_PNUM/MR_HIST_PATH/MR_HIST_NII");
run("Duplicate...", "title=[BPH] duplicate range=1-36");
run("Duplicate...", "title=[Atrophy] duplicate range=1-36");
selectWindow("MR_HIST_NII");
setAutoThreshold("Default dark");
setThreshold(0.5,7.0);
run("Convert to Mask", "  black");
run("Subtract...", "value=100 stack");
selectWindow("BPH");
setAutoThreshold("Default dark");
setThreshold(5.5,7.5);
run("Convert to Mask", "  black");
selectWindow("Atrophy");
setAutoThreshold("Default dark");
setThreshold(2.5,3.5);
run("Convert to Mask", "  black");
imageCalculator("Add create stack", "BPH","MR_HIST_NII");
selectWindow("Result of BPH");
rename("BPH Outlines");
run("Find Edges", "stack");
run("16-bit");
run("Multiply...", "value=16.000 stack");
imageCalculator("Add create stack", "Atrophy","MR_HIST_NII");
selectWindow("Result of Atrophy");
rename("Atrophy Outlines");
run("Find Edges", "stack");
run("16-bit");
run("Multiply...", "value=16.000 stack");
imageCalculator("Add create stack", "Atrophy","BPH");
selectWindow("Result of Atrophy");
rename("BPH + Atrophy Outlines")
imageCalculator("Add create stack", "MR_HIST_NII","BPH + Atrophy Outlines");
selectWindow("Result of MR_HIST_NII");
run("Find Edges", "stack");
run("16-bit");
run("Multiply...", "value=16.000 stack");
open("ROOT_PNUM/MR_PATH/MR_NOPHI_NII");
imageCalculator("Add create stack", "MR_NOPHI_NII","BPH Outlines");
rename("BPH Overlay");
selectWindow("BPH Overlay");
run("NIfTI-1", "save=[ROOT_PNUM/REG_FINAL_VOL/MR_Capsule_BPH_Overlays.nii]");
imageCalculator("Add create stack", "MR_NOPHI_NII","Atrophy Outlines");
rename("Atrophy Overlay");
selectWindow("Atrophy Overlay");
run("NIfTI-1", "save=ROOT_PNUM/REG_FINAL_VOL/MR_Capsule_Atrophy_Overlays.nii");
imageCalculator("Add create stack", "MR_NOPHI_NII","Result of MR_HIST_NII");
rename("BPH + Atrophy Overlay");
selectWindow("BPH + Atrophy Overlay");
run("NIfTI-1", "save=ROOT_PNUM/REG_FINAL_VOL/MR_Capsule_BPH_Atrophy_Overlays.nii");
