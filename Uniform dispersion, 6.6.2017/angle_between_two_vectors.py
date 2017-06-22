# -*- coding: utf-8 -*-
"""
Created on Sun May 28 11:40:21 2017

@author: chenpq
"""
import sys
import numpy as np
from numpy import linalg as la

sys.dont_write_bytecode = True
# a will be the basis
def angle(a,b):
    cosab= np.dot(a,b)/(la.norm(a)*la.norm(b));
    d = [0,0];
    d[0]= float(np.arccos(cosab));
    d[1]= float(np.rad2deg(np.arccos(cosab)));
    return d;
