import cv2
import numpy as np
import math

width = 3
height = 7
sigma = 1
a = np.array([[ 0.00121496,  0.00200313,  0.00121496],
            [ 0.01480124,  0.02440311,  0.01480124],
            [ 0.06633454,  0.10936716,  0.06633454],
            [ 0.10936716,  0.18031596,  0.10936716],
            [ 0.06633454,  0.10936716,  0.06633454],
            [ 0.01480124,  0.02440311,  0.01480124],
            [ 0.00121496,  0.00200313,  0.00121496]])

G_sigma = np.zeros((7,3))
center_width = math.floor(width/2)
center_height = math.floor(height/2)

for i in range(height):
    for j in range(width):
        x = abs(j - center_width)
        y = abs(i - center_height)
        coe = 1 / (2 * math.pi * (sigma ** 2))
        index = -(x ** 2 + y ** 2) / (2 * (sigma ** 2))
        G_sigma[i, j] = (coe * math.exp(index))

k = 0
for i in range(height):
    for j in range(width):
        k += G_sigma[i,j]
G_sigma = G_sigma / k

iseq = np.allclose(G_sigma, a,atol=1e-08)
print(G_sigma)
print(iseq)