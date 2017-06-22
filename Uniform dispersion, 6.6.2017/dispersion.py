# -*- coding: utf-8 -*-
"""
Created on Sun Jun 04 10:06:23 2017

@author: chenpq
"""

from __future__ import division
import sys
import numpy as np
import math
from angle_between_two_vectors import angle 

#Don't generate .pyc file 
sys.dont_write_bytecode = True

# The function below is used execute the Dispersion Algorithm.
# To calculate the new position(coordinates) and velocity(speed/heading) for zebro.
# Input:
#   zebros:
#       zebros[i, :]: information of zebro_i
#       zebros[:, 1]: x coordinate of zebro
#       zebros[:, 2]: y coordinate of zebro
#       zebros[:, 3]: speed on x coordinate of zebro
#       zebros[:, 4]: speed on x coordinate of zebro
#       zebros[:, 5]: heading of zebro
#   speed: speed limitation on zebro
#   nNeighbors: Maximum number of neighbors to avoid
#   disDanger: Dangerous distance
#   disDisp: Neighbor in disDisp may have repusion on the zebro
# Output:
#   value: update of zebros. The data structure is the same with input 'zebros'. 
# Written by Pengqi Chen (chenpq1993@gmail.com).


def new_zebros(zebros, speed, nNeighbors, disDanger, disDisp):
    nNeighbors = int(nNeighbors)
    nZebros = len(zebros[:,0])
    # The code is for zebro 6. Python starts from 0.
    value = np.zeros((nZebros, 5))
                
    flag=0; # 0, Initial value
            # 1, Need to avoid collision with other zebros
    
    zebro = zebros[5] 
    v_x = zebro[2]
    v_y = zebro[3]
    v = 0
    r_angle_pi = zebro[4]
       
    # Calculate the distance from zebro i to all zebros(including itself)
    # and store the results in distance
    distance = np.zeros(nZebros)
    for j in range(0, nZebros):
        other = zebros[j]
        dis = math.sqrt(pow((zebro[0] - other[0]),2) +  pow((zebro[1] - other[1]),2))
        distance[j] = dis
                    
        
    # To sort the distance and put the sorted value in distance2(from lower to higher) 
    # To record the orignal number of sorted distance in order.
    distance2 = sorted(distance)
    order = sorted(range(len(distance)), key=lambda k: distance[k])
        

    count = 0
    # neighbor: [x, y, v_x, v_y, r_angle_pi, dist_x, dist_y, dist]
    neighbor = np.zeros((nNeighbors, 8))
    # 1, 2...num_Neighbros
    for n in range(0, nNeighbors):
        neighbor[n, 0:5] = zebros[order[n+1]]
        neighbor[n, 5] = zebro[0] - neighbor[n,0]
        neighbor[n, 6] = zebro[1] - neighbor[n,1]
        neighbor[n, 7] = math.sqrt(pow(neighbor[n,5], 2) + pow(neighbor[n,6], 2))
        if(distance2[n] < disDisp):
            count = count+1

            
    # There is only one neighbor in the range of disDanger
    con1 = distance2[1] < disDanger
    con2 = distance2[2] > disDanger
    if con1 and con2:
        flag = 1
        count = 1
   
    # To calculate the new velocity on x and y direction
    # k0: to keep the inertia of the movement of zebro 
    # k1: a coefficient to calculate the acceleration from distance
    a_x = 0
    a_y = 0
    a = 0
    a_ceil = speed / 3; # the ceiling bound of accelaration
    if flag == 0:
        k0 = 3.5/5
        k1 = 8
    elif flag == 1:
        k0 = 2/5
        k1 = 8
    
    if count == 0:    #No neighbor zebros is in the range of disDisp
        v_x = k0 * v_x
        v_y = k0 * v_y
            
    else:
        for p in range(0, count):
            dist_x = neighbor[p, 5]
            dist_y = neighbor[p, 6]
            dist3  = neighbor[p, 7]
            # To calculate accelaration
            if(dist3 < disDisp):  
                a_px = k1 / dist3 * dist_x / dist3
                a_py = k1 / dist3 * dist_y / dist3
                a_x = a_x + a_px
                a_y = a_y + a_py
             
            if(p == count-1):
                a = math.sqrt(pow(a_x, 2) + pow(a_y, 2))
                # To limit abs(a) to be in the range of speed/3
                a_x = a_x * (a_ceil) / max(a, a_ceil)
                a_y = a_y * (a_ceil) / max(a, a_ceil)
    
                # To calculate the new speed
                v_x = zebro[2] * k0 + a_x
                v_y = zebro[3] * k0 + a_y
                ##To limit abs(v) to be in the range of speed.
                v = math.sqrt(pow(v_x, 2) + pow(v_y, 2))
                v_x = v_x * speed / max(v, speed)
                v_y = v_y * speed / max(v, speed)
        
    # To eliminate jitter                     
    speed_floor = 0.2
    if(v < speed_floor):
        v_x = 0
        v_y = 0
            
        
    # To calculate the new heading 
    r_angle = np.zeros(2)
    if (v > speed_floor):
        # Calculate the heading of the zebro(direction of velocity)
        # with positive axis of yas the refrence, 
        # r_angle_pi>0 when x>0, r_angle_pi< 0 when x<0;
        # the range of r_angle_pi is (-pi, pi]
        m = [0, 1]
        n = [v_x, v_y]
        r_angle = angle(m, n)
        r_angle_pi = r_angle[0]
        if(v_x >= 0): 
            r_angle_pi = -r_angle_pi
    else:
        r_angle_pi = zebro[4]
                              
    if(r_angle_pi > math.pi):
        r_angle_pi = -r_angle_pi + 2*math.pi
    elif(r_angle_pi < -math.pi):
        r_angle_pi = 2*math.pi + r_angle_pi
        
    # output of the function
    value = [v_x + zebro[0], v_y + zebro[1], v_x, v_y, r_angle_pi]
    return value

