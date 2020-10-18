from numpy import *
import operator
import os
from math import *

file = open('./testDigits/0_0.txt')
file_lines = file.readlines()
file = open('./testDigits/0_0.txt')
file_line = file.readline().strip()
length_x = len(file_lines)
length_y = len(file_line)

def imgVector(filename):
    file = open(filename)
    fileVector = zeros((1,length_x*length_y))
    for i in range(length_x):
        line = file.readline().strip()
        for j in range(length_y):
            fileVector[0,i * length_y + j] = int(line[j])
    return fileVector

def classfiy(testData, dataSet, labels, k):
    # Euclidean distance
    length = dataSet.shape[0] 
    diffData = tile(testData,(length,1)) - dataSet
    Data = diffData ** 2
    sumData = Data.sum(axis = 1)
    distances = sqrt(sumData)
    #sort
    sortDistance = argsort(distances)
    count = {}
    for i in range(k):
        votelabel = labels[sortDistance[i]]
        count[votelabel] = count.get(votelabel,0) + 1
        sortCount = sorted(list(count.items()), key = operator.itemgetter(1),reverse = True)
    return sortCount[0][0]

def datingtest():
    filedir = os.listdir('./trainingDigits')
    label = []
    length_f = len(filedir)
    trainMat = zeros((length_f,length_x*length_y))
    for i in range(length_f):
        filename = filedir[i]
        filestr = filename.split('.')[0]
        labelname = int(filestr.split('_')[0])
        label.append(labelname)
        trainMat[i] = imgVector('./trainingDigits/%s' %filename)
    # handwriting test
    resultList = [0,1,2,3,4,5,6,7,8,9]
    result = classfiy(imgVector('./testDigits/2_45.txt'), trainMat, label, 3)
    print("the number is:", resultList[int(result)])

    #error test
    testFileList = os.listdir('./testDigits')  # iterate through the test set
    errorCount = 0
    mTest = len(testFileList)
    for i in range(mTest):
        fileNameStr = testFileList[i]
        fileStr = fileNameStr.split('.')[0]  # take off .txt
        classNumStr = int(fileStr.split('_')[0])
        vectorUnderTest = imgVector('./testDigits/%s' % fileNameStr)
        classifierResult = classfiy(vectorUnderTest, trainMat, label, 3)
        print("the classifier came back with: %d, the real answer is: %d" % (classifierResult, classNumStr)) 
        if (classifierResult != classNumStr): errorCount += 1
    print ("\nthe total number of errors is: %d" % errorCount)
    print ("\nthe total error rate is: %f" % (errorCount / float(mTest)))

def main():
    datingtest()

if __name__ == '__main__':
    main()
    