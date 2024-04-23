# -*- coding: utf-8 -*-
"""
Created on Wed Oct 25 17:15:55 2023

@author: 1
"""

from __future__ import print_function
import os
import logging
import radiomics
from radiomics import featureextractor
from radiomics import getFeatureClasses
# Get the PyRadiomics logger (default log-level = INFO)
logger = radiomics.logger
logger.setLevel(logging.DEBUG)  # set level to DEBUG to include debug log messages in log file
import numpy as np 
# Write out all log entries to a file
handler = logging.FileHandler(filename='testLog.txt', mode='w')
formatter = logging.Formatter('%(levelname)s:%(name)s: %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
featureClasses = getFeatureClasses()

data_path = '/home3/Tumor_folder'
dirs = sorted(os.listdir(data_path))
       
result_list=list()    
savefilename1 = '/home3/Feature_folder/Tumor_feature.txt'

for pat in dirs:
    imageName = data_path + "/" + pat + "/DCE.nii.gz"
    maskName = data_path + "/" + pat + "/Mask.nii.gz"
  
    print(imageName)
    print(maskName)
    if imageName is None or maskName is None:  # Something went wrong, in this case PyRadiomics will also log an error
        raise Exception('Error getting testcase!')  # Raise exception to prevent cells below from running in case of "run all"

    extractor = featureextractor.RadiomicsFeatureExtractor()
    # Alternative: use hardcoded settings (separate for settings, input image types and enabled features)
    settings = {}
    settings['normalize'] = True
#    settings['binWidth'] = 25
    settings['binCount'] = 32
    settings['geometryTolerance'] = 1000
#    settings['resampledPixelSpacing'] = None
    settings['resampledPixelSpacing'] = [1, 1, 1]  # This is an example for defining resampling (voxels with size 3x3x3mm)
    settings['interpolator'] = 'sitkBSpline'
    settings['verbose'] = True 
    extractor = featureextractor.RadiomicsFeatureExtractor(**settings)
    ##By default, only 'Original' (no filter applied) is enabled. Optionally enable some image types:
    #extractor.disableAllImageTypes()
    extractor.enableImageTypeByName('Wavelet')
    #extractor.enableImageTypeByName('LoG', customArgs={'sigma':[3.0]})

    print('Calculating features') 
    featureVector = extractor.execute(imageName, maskName)
    result_list.append(featureVector )  
    # Show output
    
with open(savefilename1, 'w', newline='') as f:
    for key in result_list[0].keys():
        wc = list()
        for i in range(np.size(result_list)):
            wc.append(','+str(result_list[i].get(key)))
        f.write("".join(key)+"".join(wc)+'\n')