import cv2
import numpy as np
import math
import pdb

def cross_correlation_2d(img, kernel):
    if len(img.shape) == 2:
        m_l = kernel.shape[0]
        n_l = kernel.shape[1]
        origin_x_l = img.shape[0]
        origin_y_l = img.shape[1]
        img_a_l = np.zeros((origin_x_l+int((m_l-1)),origin_y_l+int((n_l-1))))
        for i in range(origin_x_l):
            for j in range(origin_y_l):
                img_a_l[i+int((m_l-1)/2),j+int((n_l-1)/2)] += img[i,j]
        x = img_a_l.shape[0]
        y = img_a_l.shape[1]
        G1_l = np.zeros((x,y))
        for i in range(int((m_l-1)/2),x-int((m_l-1)/2)):
            for j in range(int((n_l-1)/2),y-int((n_l-1)/2)):
                for a in range(0,m_l):
                    for b in range(0,n_l):
                       G1_l[i,j] += img_a_l[i-int((m_l-1)/2)+a,j-int((n_l-1)/2)+b]*kernel[a,b]
        G1_a_l = np.zeros((x-(m_l-1),y-(n_l-1)))
        for i in range(x-(m_l-1)):
            for j in range(y-(n_l-1)):
                G1_a_l[i,j] = G1_l[i+int((m_l-1)/2),j+int((n_l-1)/2)]
        return G1_a_l
    elif len(img.shape) == 3:
        G1_s = []
        img_b,img_g,img_r = cv2.split(img)
        img_s = [img_b,img_g,img_r]
        for img_l in img_s:
            m = kernel.shape[0]
            n = kernel.shape[1]
            origin_x = img_l.shape[0]
            origin_y = img_l.shape[1]
            img_a = np.zeros((origin_x + int((m - 1)), origin_y + int((n - 1))))
            for i in range(origin_x):
                for j in range(origin_y):
                    img_a[i + int((m - 1) / 2), j + int((n - 1) / 2)] += img_l[i, j]
            x = img_a.shape[0]
            y = img_a.shape[1]
            G1 = np.zeros((x, y))
            for i in range(int((m - 1) / 2), x - int((m - 1) / 2)):
                for j in range(int((n - 1) / 2), y - int((n - 1) / 2)):
                    for a in range(0, m):
                        for b in range(0, n):
                            G1[i, j] += img_a[i - int((m - 1) / 2) + a, j - int((n - 1) / 2) + b] * kernel[a, b]
            G1_a = np.zeros((x - (m - 1), y - (n - 1)))
            for i in range(x - (m - 1)):
                for j in range(y - (n - 1)):
                    G1_a[i, j] = G1[i + int((m - 1) / 2), j + int((n - 1) / 2)]
            G1_s.append(G1_a)
        G1_1 = cv2.merge([G1_s[0],G1_s[1],G1_s[2]])
        return G1_1

    # TODO-BLOCK-BEGIN
    raise Exception("TODO in hybrid.py not implemented")
    # TODO-BLOCK-END

def convolve_2d(img, kernel):
    kernel_y = np.flipud(kernel)
    nkernel = np.fliplr(kernel_y)
    G2_a = cross_correlation_2d(img,nkernel)
    return G2_a
    # TODO-BLOCK-BEGIN
    raise Exception("TODO in hybrid.py not implemented")
    # TODO-BLOCK-END

def gaussian_blur_kernel_2d(sigma, height, width):
    G_sigma = np.zeros((height,width))
    center_width = int(math.floor(width/2))
    center_height = int(math.floor(height/2))
    for i in range(height):
        for j in range(width):
            x = abs(j-center_width)
            y = abs(i-center_height)
            coe = 1/(2*math.pi*(sigma**2))
            index = -(x**2+y**2)/(2*(sigma**2))
            G_sigma[i,j] = coe*math.exp(index)
    k = G_sigma.sum()
    G_sigma = G_sigma / k
    return G_sigma

    # TODO-BLOCK-BEGIN
    raise Exception("TODO in hybrid.py not implemented")
    # TODO-BLOCK-END

def low_pass(img, sigma, size):
    kernel = gaussian_blur_kernel_2d(sigma, size, size)
    if len(img.shape) == 3:
        img_b,img_g,img_r = cv2.split(img)
        low_pass_img_b = convolve_2d(img_b,kernel)
        low_pass_img_g = convolve_2d(img_g, kernel)
        low_pass_img_r = convolve_2d(img_r, kernel)
        low_pass_img_1 = cv2.merge([low_pass_img_b,low_pass_img_g,low_pass_img_r])
        return low_pass_img_1

    elif len(img.shape) == 2:
        low_pass_img = convolve_2d(img,kernel)
        return low_pass_img

    # TODO-BLOCK-BEGIN
    raise Exception("TODO in hybrid.py not implemented")
    # TODO-BLOCK-END

def high_pass(img, sigma, size):
    high_pass_img = img - low_pass(img,sigma,size)
    return high_pass_img

    # TODO-BLOCK-BEGIN
    raise Exception("TODO in hybrid.py not implemented")
    # TODO-BLOCK-END

def create_hybrid_image(img1, img2, sigma1, size1, high_low1, sigma2, size2,
        high_low2, mixin_ratio):
    high_low1 = high_low1.lower()
    high_low2 = high_low2.lower()

    if img1.dtype == np.uint8:
        img1 = img1.astype(np.float32) / 255.0
        img2 = img2.astype(np.float32) / 255.0

    if high_low1 == 'low':
        img1 = low_pass(img1, sigma1, size1)
    else:
        img1 = high_pass(img1, sigma1, size1)

    if high_low2 == 'low':
        img2 = low_pass(img2, sigma2, size2)
    else:
        img2 = high_pass(img2, sigma2, size2)

    img1 *= 2 * (1 - mixin_ratio)
    img2 *= 2 * mixin_ratio
    hybrid_img = (img1 + img2)
    return (hybrid_img * 255).clip(0, 255).astype(np.uint8)