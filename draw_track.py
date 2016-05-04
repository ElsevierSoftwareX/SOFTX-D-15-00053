# -*- coding: utf-8 -*-
"""
Created on Mon Oct  6 11:04:39 2014

@author: Dr. Milos Ivanovic
         Assistant Professor
         Department of Mathematics & Informatics
         Faculty of Science, University of Kragujevac
         Radoja Domanovica 12
         34000 Kragujevac
         Serbia
         internet: http://imi.pmf.kg.ac.rs/~milos/cv
         email: mivanovic@kg.ac.rs
         phone: +381 34 336 223, ext. 306
"""
from __future__ import print_function
import fileinput
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.path import Path
import matplotlib.patches as patches
from mpl_toolkits.mplot3d import Axes3D

#### Parameter definition ###########################
profile_file_name = 'TRACK_COORDINATES.DAT'
contour_file_name = 'Contour.dat'
optics_file_name = 'BE.DAT'
data_3d_file_name = '3_D.DAT'
# X scaling factor (used for scaling range of X axis)
axis_scaling = 3.0
# Translation factor (used to translate contour and optical image up and down)
trans_scaling = 1.0
# File names
#####################################################

# Function used to replace 'D' for 'E' in a file - conversion from Fortran notation
def replace_de(file_name):
    for line in fileinput.input(file_name, inplace=1):
        print(line.replace('D', 'E'), end='')

"""
Main routine starts here
"""
# Replace 'D' with 'E' if necessary
replace_de(profile_file_name)
replace_de(contour_file_name)
replace_de(optics_file_name)
replace_de(data_3d_file_name)
# Load files into arrays
profil = np.loadtxt(profile_file_name)
contour = np.loadtxt(contour_file_name)
optics = np.loadtxt(optics_file_name)
data_3d = np.loadtxt(data_3d_file_name)

# Find length of contour projection on X axis
contour_diameter_x = np.max(contour[:,0]) - np.min(contour[:,0])

# Translate contour up for trans_y
trans_y = trans_scaling * contour_diameter_x
contour = contour + [0, trans_y]

# Translate optics down for trans_y
optics = optics - [0,trans_y,0,trans_y,0,trans_y,0,trans_y,0]

"""
Plot 2D track
"""
fig1 = plt.figure()
ax1 = fig1.add_subplot(111)
ax1.set_title('Proton Track Projection')
ax1.axes.set_aspect('equal', 'datalim')

drawing_codes = [Path.MOVETO, Path.LINETO, Path.LINETO, Path.LINETO, Path.CLOSEPOLY]

for i in range(len(optics)):
    v = optics[i]
    frame = [ (v[0],v[1]), (v[4],v[5]), (v[6],v[7]), (v[2],v[3]), (0,0) ]
    element = Path(frame, drawing_codes)
    patch = patches.PathPatch(element, facecolor=(v[8],v[8],v[8]), lw=0)
    ax1.add_patch(patch)

# Set X axis limits
min_x, max_x = -axis_scaling*contour_diameter_x, axis_scaling*contour_diameter_x
ax1.set_xlim(min_x, max_x)

# Insert first and last point for the profile, far away "enough"
profil = np.insert(profil, 0, [[100*max_x,0]], axis=0)
profil = np.append(profil, [[100*min_x,0]], axis=0)

# Plot profile and contour
ax1.plot(profil[:,0], profil[:,1], lw=2)
ax1.plot(contour[:,0], contour[:,1], lw=2)

"""
Plot 3D track
"""
fig2 = plt.figure()
ax2 = fig2.add_subplot(111, projection='3d')
ax2.scatter(data_3d[:,0], data_3d[:,1], data_3d[:,2], marker='.', s=1)
ax2.set_xlabel('X Axis')
ax2.set_ylabel('Y Axis')
ax2.set_zlabel('Z Axis')
ax2.set_title('Proton Track 3D')
ax1.axes.set_aspect('equal', 'datalim')

# Show both figures
plt.show()
