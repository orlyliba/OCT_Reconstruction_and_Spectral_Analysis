# OCT Reconstruction and Spectral Analysis
MATLAB code for reconstruction and spectral analysis of spectral domain OCT images. 
This code can be used as part of a platform for molecular imaging with OCT, which we call MOZART.

This code was created to read raw interferograms from Thorlabs OCTs (SW version 4 works best, but version 3 is also supported with a few changes).
It reconstructs the raw interferograms into OCT images, and supports both 2D and 3D.
In addition to reconstructing the images this code:
- Calculates the normalized spcekle variance (useful for detecting blood vessels)
- Calculates dispersion compensation
- Calculates a map of spectral contras, based on dual-band spectral analysis
- Calculates spectral-depth compensation
- Creates images that combine the OCT image, spectral analysis and speckle variance.
- and more features...

Example of image created with this code and analysis:

<p align="center">    
  <img src="https://cloud.githubusercontent.com/assets/19598320/19124011/2866bae4-8ae6-11e6-8de7-f9ffbae46de7.png">
  <br>
  <b>(Contract enhanced OCT image of a mouse pinna, after squential injections of two types of large gold nanorods)</b>
</p>

This code was used to create images and analysis for: "Contrast-enhanced optical coherence tomography with picomolar sensitivity for functional in vivo imaging" O Liba, ED SoRelle, D Sen, A de La Zerda - Scientific reports, 2016. 
<br>
Please cite our paper if you use our code.

I would like to acknowledge the Thorlabs team in Lubeck, Germany, for their support in working with the OCT systems and reconstructing the raw signals.

----------------------------------------------------------------------------------------------------------------------------------------
Usage of the code:

0. If you use Thorlabs spectral domain OCTs, export your data as raw interferogram.
This code supports all of ThorLabs SD-OCT systems, but was written specifically for Ganymede HR and Telesto. 
In any case you'll need to update the chirp.mat files from the Chirp.dat file that is stored in your OCT system (The Chirp.dat is calibrated for each individual system), and perhaps other parameters, such as size of buffer (1024 or 2048).
If you use an OCT from a different manufacturer, you'll need to update the functions that read the raw data.

1. Update the parameter files according to your system and the type of scans you acquired.
The parameter file should be readable enough. Feel free to contact me if you have any questions.
If you ran 3D volumes, use spectralParamsV3_3D. It will save your results as a .mat buffer file, and not png images.

2. run the file called runSpectralV3.m

3. If you have a 3D volume, you'll now need to create it into a Tiff file. To do this, run one of the createTiff functions in the display_functions folder.
This allows stitching of multiple files into one volume, and also choosing the type of output (OCT log signal, spectral signal, speckle variance...).
You can also change the colormap using the display functions.
If you saves a 2D .mat buffer, you can also play with the display parameters using createPngBscanFunction.m
