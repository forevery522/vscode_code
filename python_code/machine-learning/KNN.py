from numpy import *
import operator


def fileMartix(filename):
    file = open(filename)
    filelines = file.readlines()
    numoflines = len(filelines)
    returnMat = zeros((numoflines,3))
    index = 0
    labelvectors = []
    for line in filelines:
        line = line.strip()
        listofline = line.split('\t')
        returnMat[index,:] = listofline[0:3]
        labelvectors.append(listofline[-1])
        index += 1
    return returnMat, labelvectors

def createDataSet():
    group = array([[1.0,1.1],[1.0,1.0],[0,0],[0.1,0.1]])
    label = ['A','A','B','B']
    return group, label

def classify(testData, dataSet, label, k):
    '''
    calculate Euclidean Distance
    '''
    xlenth = dataSet.shape[0]
    diffData = tile(testData,(xlenth,1)) - dataSet
    sqData = diffData ** 2
    addsqData = sqData.sum(axis = 1)
    distances = sqrt(addsqData)

    '''
    sort the distance
    '''
    sortDistance = argsort(distances)  #return the serial number
    Count = {}
    for i in range(k):
        voteLabel = label[sortDistance[i]]
        Count[voteLabel] = Count.get(voteLabel, 0) + 1
        sortCount = sorted(list(Count.items()), key = operator.itemgetter(1), reverse = True)
    return sortCount[0][0]

def autoNorm(dataSet):   #autoDataSet = (dataSet - minval) / (maxval - minval)
    m = dataSet.shape[0]
    minval = dataSet.min(0)
    maxval = dataSet.max(0)
    minval = tile(minval,(m,1))
    maxval = tile(maxval,(m,1))
    ranges = maxval - minval
    autoDataSet = (dataSet - minval) / ranges
    return autoDataSet, minval, ranges

def dataClassTest():
    dataMat, labels = fileMartix('datingTestSet2.txt')
    ratio = 0.1  #ratio of testData
    numOfx = dataMat.shape[0]
    numOfTest = int(numOfx * ratio)
    normDataSet, minval, ranges = autoNorm(dataMat)
    errorCount = 0.0
    for i in range(numOfTest):
        classifyResult = classify(normDataSet[i], normDataSet[numOfTest:numOfx], labels[numOfTest:numOfx],3)
        if (classifyResult != labels[i]):
            errorCount += 1
    errorRatio = errorCount / numOfTest
    print("the errorRatio is:",errorRatio)

def classReal():
    pass

def main():
    dataClassTest()
    # group, label = createDataSet()
    # result = classify([1.1,1.0], group, label, 2)
    # print(result)

if __name__ == '__main__':
    main()   