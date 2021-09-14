/* Analyse areas of particles in thresholded NMJ images
 * 14 Sep 2021
 * Dalia Sara Gala, dalia.gala@bioch.ox.ac.uk
 * 
 * Select folder containing images
 * Select folder for output
 * Opens fileand thresholds
 * Analyses particles excluding ones smaller than 2.00 units
 * Saves particles as .tiff
 * Saves results as .csv
 */



// Define directories
input = getDirectory("Choose Source Directory ");
output = getDirectory("Choose output Directory "); 

// Get the list of files
list = getFileList(input);

// Produce MAX project, split channels
setBatchMode(true);

for (i=0; i<list.length; i++) {
	showProgress(i+1, list.length);
	path = input + list[i];
	fileName = substring(list[i],0,lengthOf(list[i])-4);
	open(path);
	run("Auto Threshold", "method=Yen ignore_black ignore_white white");
	run("Set Measurements...", "area mean min integrated limit display redirect=None decimal=3");
	run("Analyze Particles...", "size=2.00-Infinity show=Outlines display include");
	saveAs("Tiff", output+fileName+"_particles.tif");
	close();
	}

selectWindow("Results");
saveAs("Results", output + "Results_Area" + ".csv");
close("Results");

setBatchMode(false);
close("*");
