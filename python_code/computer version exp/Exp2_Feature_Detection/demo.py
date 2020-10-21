import numpy as np
import scipy
from scipy import ndimage
import cv2
import transformations
import features
import features_homework
from PIL import Image

HKD = features_homework.HarrisKeypointDetector()
orbdetc = features.ORBKeypointDetector()
#SFD = features.SimpleFeatureDescriptor()
MFD = features_homework.MOPSFeatureDescriptor()
orbdesc = features.ORBFeatureDescriptor()
SSDFM = features_homework.SSDFeatureMatcher()
Ratio = features_homework.RatioFeatureMatcher()
orb = features.ORBFeatureMatcher()

queryImage = np.array(Image.open('resources/mp3.jpg'))
trainImage = np.array(Image.open('resources/mp4.jpg'))

qgrayImage = cv2.cvtColor(queryImage.astype(np.float32) / 255.0, cv2.COLOR_BGR2GRAY)
tgrayImage = cv2.cvtColor(trainImage.astype(np.float32) / 255.0, cv2.COLOR_BGR2GRAY)

#queryKeyPoints = orbdetc.detectKeypoints(queryImage)
#trainKeyPoints = orbdetc.detectKeypoints(trainImage)

#queryDesc = orbdesc.describeFeatures(queryImage, queryKeyPoints)
#trainDesc = orbdesc.describeFeatures(trainImage, trainKeyPoints)

#matches = orb.matchFeatures(queryDesc, trainDesc)

queryKeyPoints = HKD.detectKeypoints(queryImage)
trainKeyPoints = HKD.detectKeypoints(trainImage)

queryDesc = MFD.describeFeatures(queryImage, queryKeyPoints)
trainDesc = MFD.describeFeatures(trainImage, trainKeyPoints)

matches = Ratio.matchFeatures(queryDesc, trainDesc)

#print(matches[0].queryIdx, matches[0].trainIdx, matches[0].distance)
for match in matches:
    print(match.queryIdx, match.trainIdx, match.distance)