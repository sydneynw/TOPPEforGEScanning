# TOPPEforGEScanning <br/>
TOPPE files used for scanning on the University of Michigan fMRI Lab 3T GE Scanners <br/>
Please refer to the [TOPPE Github](https://github.com/toppeMRI/) and the original paper J-F. Nielsen, MRM 2018 [https://doi.org/10.1002/mrm.26990](https://doi.org/10.1002/mrm.26990). Most up-to-date information about using the TOPPE platform is available from Jon-Fredrik Nielsen.<br/>
<br/>
## Files provided here:<br/>
For a spin-warp double-echo SPGR acquisition for B0 field mapping with 2.3 ms echo time difference. <\br>
64x64x84 matrix, FOV = 24 cm x 24 cm x 33.6 cm. <br/>
**Scanning**<br/>      
-tipdown.mod : hard pulse </br>
-readout.mod : spin warp readout for 64 RO resoltuion (PE resolution determined by scanloop.txt) <br/>
-scanloop.txt :  double-echo SPGR for 64 PE steps and 84 slices <br/>
-timing.txt : 3T Discovery MR timings<br/>
-modules.txt : interleaves double echoes with 2.3 ms echo time spacing<br/>
-mat2mod.mod : used to generate excitation/readout waveforms from MATLAB<br/>
**Recon**<br/>
-freadc.m : utility files for loading Pfile data (Jon-Fredrik Nielsen)<br/>
-loaddat_ge.m : utility files for loading Pfile data (Jon-Fredrik Nielsen)<br/>
-loadpfile.m : utility files for loading Pfile data (Jon-Fredrik Nielsen)<br/>
-recon_syd.m : reconstructs multi-coil cartesian k-space data<br/>
-recon_syd_coilcombine.m : reconstructs complex multi-coil cartesian k-space data given sensitivity maps<br/>
-sMapCombine.m : linearly combines complex sensitivity maps and multi-coil data (Tianrui Luo)<br/>
-sense-map.mat : complex sensitivity map from 8-Rx coil using body coil reference, downsampled to 64x32x84x8<br/>  
-P02048.7 : sample raw data P-file acquired with FBIRN phantom and SPGR sequence for practice recon w/readout.mod 
