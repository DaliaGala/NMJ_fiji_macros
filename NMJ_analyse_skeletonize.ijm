// Define directories
input = getDirectory("Choose Source Directory ");
output = getDirectory("Choose Output Directory "); 

// Get the list of files
list = getFileList(input);

// Run loop to skeletonise for glial channel - C1

setBatchMode(true);

for (i=0; i<list.length; i++) {
	showProgress(i+1, list.length);
	path = input + list[i];
	fileName = substring(list[i],0,lengthOf(list[i])-4);
	open(path);
//	if (endsWith(list[i], "C1.tif")); {
		run("Median...", "radius=1.5");
		run("Auto Threshold", "method=Yen ignore_black ignore_white white");
		run("Set Measurements...", "area mean min integrated limit display redirect=None decimal=3");
		run("Dilate");
		run("Dilate");
		run("Dilate");
		run("Dilate");
		run("Analyze Particles...", "size=2.00-Infinity show=Masks add in_situ");
		run("Skeletonize (2D/3D)");
		run("Analyze Skeleton (2D/3D)", "prune=none prune_0 calculate display");
		selectWindow("Tagged skeleton");
		saveAs("Tiff", output+fileName+"_skeleton.tif");
		close("Tagged skeleton");
		selectWindow("Results");
		saveAs("Results", output + "Results_Skeleton" + fileName + "_glia" + ".csv");
		close("Results");
	}



setBatchMode(false);
close("*");
run("Close All")
