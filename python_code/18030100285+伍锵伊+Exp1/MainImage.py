import cv2
import hybrid as hy
import pdb

img1 = cv2.imread('cat.jpg',1)
img2 = cv2.imread('dog.jpg',1) 

img1_std = img1 / 255
img2_std = img2 / 255

img1_high = hy.high_pass(img1_std,20,13)
img2_low = hy.low_pass(img2_std,20,13)

img_hy = img1_high + img2_low

cv2.namedWindow('hybrid_MainImage',cv2.WINDOW_NORMAL)
cv2.namedWindow('low_pass_dog',cv2.WINDOW_NORMAL)
cv2.namedWindow('high_pass_cat',cv2.WINDOW_NORMAL)
cv2.imshow('low_pass_dog',img2_low)
cv2.imshow('high_pass_cat',img1_high)
cv2.imshow('hybrid_MainImage',img_hy)
cv2.waitKey(0)
cv2.destroyAllWindows()