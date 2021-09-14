/* Get MAX projection, select ROI, split channels, save
 * 14 Sep 2017
 * Dalia Sara Gala, dalia.gala@bioch.ox.ac.uk
 * 
 * Select folder containing images
 * Select folder for ROI
 * Select folder for channels
 * Projects max of z series
 * Subtracts background
 * Asks user to circle around the synapse
 * Duplicates, saves ROI
 * Splits channels, saves channels
 */

 
// Define directories
input = getDirectory("Choose Source Directory ");

//output = getDirectory("Choose output Directory "); 
outputROI = getDirectory("Choose Destination Directory for ROI ");
outputCh = getDirectory("Choose Destination Directory for split channels ");

// Get the list of files
list = getFileList(input);

// Produce MAX project, split channels
for (i=0; i<list.length; i++) {
	showProgress(i+1, list.length);
	if (endsWith(list[i], ".lsm")) {
		path = input + list[i];
		run("Bio-Formats Importer", "open=[" + path + "] autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_1");
		fileName = substring(list[i],0,lengthOf(list[i])-4);
		run("Subtract Background...", "rolling=50");
		run("Z Project...", "projection=[Max Intensity]");
		run("Select None");
		do	{
		waitForUser("Interactive ROI select", "Circle around the synapse");
		type = selectionType();
			} while (type ==-1);
		run("Duplicate...", "duplicate");
		setBackgroundColor(0, 0, 0);
		run("Clear Outside");
		run("Select None");
		saveAs("Tiff", outputROI+"ROI_"+fileName+".tif");
		run("Split Channels");
		saveAs("Tiff", outputCh+fileName+"_C2.tif");
		close();
		saveAs("Tiff", outputCh+fileName+"_C1.tif");
		close();
		run("Close All");
	}
}
close("*");
