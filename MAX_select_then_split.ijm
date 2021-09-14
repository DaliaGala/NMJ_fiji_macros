// Define directories
input = getDirectory("Choose Source Directory ");
//output = getDirectory("Choose output Directory "); 
outputROI = getDirectory("Choose Destination Directory for ROI ");
outputCh = getDirectory("Choose Destination Directory for split channels ");

// Get the list of files
list = getFileList(input);

// Produce MAX project, split channels

// setBatchMode(true);

for (i=0; i<list.length; i++) {
	showProgress(i+1, list.length);
	if (endsWith(list[i], ".oir")) {
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
		//run("Median...", "radius=1.5");
		//saveAs("Tiff", outputMEDIAN+"MEDIAN_"+fileName+".tif");
		//close();
		//run("Z Project...", "projection=[Average Intensity]");
		//saveAs("Tiff", outputSUM+"AVG_"+fileName);
		//close();
		run("Split Channels");
		saveAs("Tiff", outputCh+fileName+"_C3.tif");
		close();
//		saveAs("Tiff", outputCh+fileName+"_C2.tif");
		close();
		saveAs("Tiff", outputCh+fileName+"_C1.tif");
		//saveAs("Tiff", output+fileName+".tif");
		run("Close All");
	}
}
setBatchMode(false);
close("*");
