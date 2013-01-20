open("ROOT/PNUM/MR_HIST_PATH/MR_HIST_NII");
run("Duplicate...", "title=[Gleason 3] duplicate range=1-36");
run("Duplicate...", "title=[Gleason 4] duplicate range=1-36");
selectWindow("MR_HIST_NII");
setAutoThreshold("Default dark");
setThreshold(0.5,7.0);
run("Convert to Mask", "  black");
run("Subtract...", "value=100 stack");
selectWindow("Gleason 3");
setAutoThreshold("Default dark");
setThreshold(1.5,2.5);
run("Convert to Mask", "  black");
selectWindow("Gleason 4");
setAutoThreshold("Default dark");
setThreshold(4.5,5.5);
run("Convert to Mask", "  black");
imageCalculator("Add create stack", "Gleason 3","MR_HIST_NII");
selectWindow("Result of Gleason 3");
rename("Gleason 3 Outlines");
run("Find Edges", "stack");
run("16-bit");
run("Multiply...", "value=16.000 stack");
imageCalculator("Add create stack", "Gleason 4","MR_HIST_NII");
selectWindow("Result of Gleason 4");
rename("Gleason 4 Outlines");
run("Find Edges", "stack");
run("16-bit");
run("Multiply...", "value=16.000 stack");
imageCalculator("Add create stack", "Gleason 4","Gleason 3");
selectWindow("Result of Gleason 4");
rename("Gleason 3 + Gleason 4 Outlines")
imageCalculator("Add create stack", "MR_HIST_NII","Gleason 3 + Gleason 4 Outlines");
selectWindow("Result of MR_HIST_NII");
run("Find Edges", "stack");
run("16-bit");
run("Multiply...", "value=16.000 stack");
open("ROOT/PNUM/MR_PATH/MR_NOPHI_NII");
imageCalculator("Add create stack", "MR_NOPHI_NII","Gleason 3 Outlines");
rename("Gleason 3 Overlay");
selectWindow("Gleason 3 Overlay");
run("NIfTI-1", "save=[ROOT/PNUM/REG_FINAL_VOL/MR_Capsule_Gleason3_Overlays.nii]");
imageCalculator("Add create stack", "MR_NOPHI_NII","Gleason 4 Outlines");
rename("Gleason 4 Overlay");
selectWindow("Gleason 4 Overlay");
run("NIfTI-1", "save=ROOT/PNUM/REG_FINAL_VOL/MR_Capsule_Gleason4_Overlays.nii");
imageCalculator("Add create stack", "MR_NOPHI_NII","Result of MR_HIST_NII");
rename("Gleason 3 + Gleason 4 Overlay");
selectWindow("Gleason 3 + Gleason 4 Overlay");
run("NIfTI-1", "save=ROOT/PNUM/REG_FINAL_VOL/MR_Capsule_Gleason3_Gleason4_Overlays.nii");
