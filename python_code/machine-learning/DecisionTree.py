from math import *
import operator

def createDataSet():
    dataset = [[1,1,'yes'],
               [1,0,'no'],
               [0,1,'no'],
               [0,0,'no']]
    labels = ['no sufacing','flippers']
    return dataset, labels

def calcShannonEnt(dataset):
    numlength = len(dataset)
    labelcounts = {}
    for featvec in dataset:
        label = featvec[-1]
        if label not in labelcounts.keys():
            labelcounts[label] = 0
        labelcounts[label] += 1
    shannonEnt = 0.0
    for key in labelcounts:
        prob = float(labelcounts[key]) / numlength
        shannonEnt -= prob * log(prob, 2)
    return shannonEnt

def splitDataSet(dataset, i, value):
    returnset = []
    for featvec in dataset:
        if (featvec[i] == value):
            retvec = featvec[:i]
        retvec.extend(featvec[i+1:])
        returnset.append(retvec)
    return returnset

def chooseBestFeatureSplit(dataset):
    numfeatures = len(dataset[0] - 1)
    bestinfoGain = 0.0
    bestfeature = -1
    baseEntropy = calcShannonEnt(dataset)
    for i in range(numfeatures):
        featurelist = [example[i] for example in dataset]
        uniqueVals = set(featurelist)
        newEntropy = 0.0
        for value in uniqueVals:
            subdataset = splitDataSet(dataset, i, value)
            prob = len(subdataset) / float(len(dataset))
            newEntropy += prob * calcShannonEnt(subdataset)
        infoGain = newEntropy - baseEntropy
        if(infoGain > bestinfoGain):
            bestinfoGain = infoGain
            bestfeature = i
    return  bestfeature

def createTree(dataset, labels):
    classlist = [example[-1] for example in dataset]
    if classlist.count(classlist[0]) == len(dataset):
        return classlist[0]
    if len(dataset) == 1:
        return majorityCnt(classlist)
    
    bestfeature = chooseBestFeatureSplit(dataset)
    bestlabel = labels[bestfeature]

    Tree = {bestlabel: {}}
    del(labels[bestfeature])

    featurevalue = [example[bestfeature] for example in dataset]
    uniqueval = set(featurevalue)
    for value in uniqueval:
        sublabels = labels[:]
        Tree[bestlabel][value] = createTree(splitDataSet(dataset, bestfeature, value), sublabels)
    return Tree

def majorityCnt(classlist):
    classcount = {}
    for vote in classlist:
        if vote not in classcount.key():
            classcount[vote] = 0
        classcount[vote] += 1
    
    sortclasscount = sorted(classcount.items(), key = operator.itemgetter(1), reverse = True)
    return sortclasscount[0][0]

def classify(inputTree, labels, testvec):
    rootStr = list(inputTree.key())[0]
    secondDict = inputTree[rootStr]
    featureIndex = labels.index(rootStr)
    key = testvec[featureIndex]
    valueoffeat = secondDict[key]
    if isinstance(valueoffeat, dict):
        classify(valueoffeat, labels, testvec)
    else:
        classlabel = valueoffeat
    return classlabel