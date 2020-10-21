import numpy as np
import cv2
import skimage

img = cv2.imread('./resources/cat.jpg',1)
img1 = cv2.imread('./resources/dog.jpg',1)

img_standard = img/255.0
img1_standard = img1/255.0

# print(img_standard)
img_noise = skimage.util.random_noise(img_standard,mode='gaussian')
img_blur = cv2.GaussianBlur(img_noise,(21,21),9)

img1_noise = skimage.util.random_noise(img1_standard,mode='gaussian')
img1_blur = cv2.GaussianBlur(img1_noise,(21,21),9)

img_highpass = img_standard - img_blur
img_mix = img_highpass + img1_blur


imgs = [img_standard,img1_standard,img_highpass,img_mix]
imgs = np.hstack(imgs)
cv2.namedWindow('image',cv2.WINDOW_NORMAL)
cv2.imshow('image',imgs)
# cv2.imwrite('mixImage2.jpg',img_mix*255)
cv2.waitKey(0)
cv2.destroyAllWindows()