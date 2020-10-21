import numpy as np
import cv2

# small_height = 10
# small_width = 8
# small_height = small_height % 2 + small_height + 1
# small_width = small_width % 2 + small_width + 1
# print(small_height,small_width)
small_img_grey = np.random.rand(10,8)
small_img_grey_a = np.zeros((12,10))
identity = np.ones((3,3))
identity = np.fliplr(np.flipud(identity))
# identity[1,1] = 1
# identity = 1/9*identity
m = identity.shape[0]
n = identity.shape[1]
for i in range(10):
    for j in range(8):
        small_img_grey_a[i+int((m-1)/2),j+int((n-1)/2)]+=small_img_grey[i,j]
# print(small_img_grey,small_img_grey_a)

x = small_img_grey_a.shape[0]
y = small_img_grey_a.shape[1]

G1 = np.zeros((x,y))
for i in range(int((m-1)/2),x-int((m-1)/2)):
    for j in range(int((n-1)/2),y-int((n-1)/2)):
        for a in range(0,m):
            for b in range(0,n):
                G1[i,j] += small_img_grey_a[i-int((m-1)/2)+a,j-int((n-1)/2)+b]*identity[a,b]

# G1 = np.zeros((x,y))
# for i in range(int((m-1)/2),x-int((m-1)/2)):
#     for j in range(int((n-1)/2),y-int((n-1)/2)):
#         for a in range(0,m):
#             for b in range(0,n):
#                 G1[i,j] += small_img_grey_a[i-int((m-1)/2)+a,j-int((n-1)/2)+b]*identity[a,b]

G1_a = np.zeros((x-(m-1),y-(n-1)))
for i in range(x - (m-1)):
    for j in range(y - (n-1)):
        G1_a[i,j] = G1[i + int((m-1)/2), j + int((n-1)/2)]
solution = cv2.filter2D(small_img_grey, -1, identity, borderType=cv2.BORDER_CONSTANT)
eq = np.allclose(solution, G1_a, atol=1e-08)
print(eq)
# print(G1,small_img_grey_a,solution)