# -*- coding: utf-8 -*-
"""
Created on Thu Apr  6 15:14:00 2023

@author: 1
"""

import ants
import os

data_path='/home3/Data'
dirs = sorted(os.listdir(data_path))

for pat in dirs:
    datapath_Target = data_path + "/" + pat + "/" +"Target.nii.gz"
    datapath_Moving = data_path + "/" + pat + "/" +"Moving.nii.gz"
    
    fix_img = ants.image_read(datapath_Target)
    move_img = ants.image_read(datapath_Moving)
    outs = ants.registration(fix_img,move_img,type_of_transforme = 'SyNRA')  
    reg_img = outs['warpedmovout'] 
    save_path = data_path + "/" + pat + "/" +'reg_Moving.nii.gz'
    ants.image_write(reg_img,save_path) 