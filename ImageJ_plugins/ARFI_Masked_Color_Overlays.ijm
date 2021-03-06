open("");
rename("ARFI");
run("8-bit Color","number=256");
open("");
rename("SegPath");
run("Duplicate...", "title=Capsule duplicate range=1-500");
run("Duplicate...", "title=[Gleason 3] duplicate range=1-500");
run("Duplicate...", "title=[Gleason 4] duplicate range=1-500");
run("Duplicate...", "title=Atrophy duplicate range=1-500");
run("Duplicate...", "title=BPH duplicate range=1-500");
selectWindow("SegPath");
close();
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
selectWindow("Gleason 3");
setAutoThreshold("Default dark");
setAutoThreshold("Default dark");
setThreshold(1.5000, 2.5000);
run("Convert to Mask", "method=Default background=Dark black");
run("Find Edges", "stack");
run("Green");
selectWindow("Gleason 4");
setAutoThreshold("Default dark");
setAutoThreshold("Default dark");
setThreshold(4.5000, 5.5000);
run("Convert to Mask", "method=Default background=Dark black");
run("Find Edges", "stack");
run("Cyan");
selectWindow("Atrophy");
setAutoThreshold("Default dark");
setAutoThreshold("Default dark");
setThreshold(2.5000, 3.5000);
run("Convert to Mask", "method=Default background=Dark black");
run("Find Edges", "stack");
run("Blue");
selectWindow("BPH");
setAutoThreshold("Default dark");
setAutoThreshold("Default dark");
setThreshold(5.5000, 6.5000);
run("Convert to Mask", "method=Default background=Dark black");
run("Find Edges", "stack");
run("Magenta");
run("Merge Channels...", "c1=MaskedARFI c2=[Gleason 3] c3=[Gleason 4] c4=Atrophy c5=BPH create keep");
selectWindow("Composite");
run("Stack to RGB", "slices");
close("Atrophy");
close("BPH");
close("Gleason 3");
close("Gleason 4");
close("Capsule");
close("MaskedARFI");
close("ARFI");
