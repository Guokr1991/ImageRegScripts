open("");
rename("ARFI");
run("8-bit Color","number=256");
open("");
rename("Capsule");
selectWindow("Capsule");
setAutoThreshold("Default dark");
//run("Threshold...");
setAutoThreshold("Default dark");
setThreshold(0.5000, 7.0000);
run("Convert to Mask", "method=Default background=Dark black");
imageCalculator("AND create stack","Capsule","ARFI");
selectWindow("Result of Capsule");
rename("MaskedARFI");
run("LUT... ", "open=/home/mlp6/local/ImageJ/luts/ProstateCopperLUT.xls");
close("Capsule");
close("ARFI");
