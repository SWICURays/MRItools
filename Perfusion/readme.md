PERFUSION CLASS FOR BOTH T1 AND T2-STAR PERFUSION CALCULATIONS

T1-PERFUSION

Initiating a T1perfusion object takes these arguments:

0 arguments: Will read a .mat file containing vol, mask, prop and stats.
1 argument: Takes a 4D vol as input.
2 arguments: Takes a 4D vol and 3D mask as input
4 arguments: Takes a 4D vol, 3D mask, props and stats structs as input.

FUNCTIONS:

viewVol - launches imtool3D and shows 4D volume.
viewParametricMaps - prompts for selection of map and shows in imtool3D. Returns handle to imtool3D.

saveMask - saves mask from imtool3D instance to object
loadMask - loads a previosly saved mask to imtool3D object

ROI MENU IN Imtool3D
saveAIF - save current ROI as AIF
saveVIF - save current ROI as VIF
saveOtherROI - save current ROI and define which one

viewAIFROI - displays AIF ROI in vol or parametric maps
viewVIFROI - displays VIF ROI in vol or parametric maps

setTrucateVol - truncates vol. If no input users must input boundries. Otherwise provide low and high as input.
setPatientID - sets a new patientId


getParametricMaps - propmts for selection and returns parametric map.
getStats - returns stats struct

saveData - prompts for dir to save data
loadData - loads mat file to object overwriting all data in object
