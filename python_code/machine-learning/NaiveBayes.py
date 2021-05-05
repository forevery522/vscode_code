import numpy as np

def loadDataSet():
    postinglist = [['my', 'dog', 'has', 'flea', 'problems', 'help', 'please'], 
                   ['maybe', 'not', 'take', 'him', 'to', 'dog', 'park', 'stupid'],
                   ['my', 'dalmation', 'is', 'so', 'cute', 'I', 'love', 'him'],
                   ['stop', 'posting', 'stupid', 'worthless', 'garbage'],
                   ['mr', 'licks', 'ate', 'my', 'steak', 'how', 'to', 'stop', 'him'],
                   ['quit', 'buying', 'worthless', 'dog', 'food', 'stupid']]
    classvec = [0, 1, 0, 1, 0, 1]
    return postinglist, classvec

def creatVocablist(dataSet):
    vocabset = set()
    for document in dataSet:
        vocabset = vocabset | set(document)
    return list(vocabset)

def setOfwords2vec(vocablist, inputSet):
    returnVec = [0] * len(vocablist)
    for word in inputSet:
        if word in vocablist:
            returnVec[vocablist.index(word)] = 1
        else:
            print("the word: %s is not in the vocabulary!" %word)
    return returnVec

def trainNB(trainMartix, trainCategory):
    numTrainDocs = len(trainMartix)
    numWords = len(trainMartix[0])
    pAbusive = np.sum(trainCategory) / float(numTrainDocs)
    p0Num = np.ones(numWords)
    p1Num = np.ones(numWords)
    p0Denom = 2.0
    p1Denom = 2.0
    for i in range(numTrainDocs):
        if trainCategory[i] == 1:
            p1Num += trainMartix[i]
            p1Denom += np.sum(trainMartix[i])
        elif trainCategory[i] == 0:
            p0Num += trainMartix[i]
            p0Denom += np.sum(trainMartix[i])
    p1Vect = np.log(p1Num / p1Denom) 
    p0Vect = np.log(p0Num / p0Denom)
    return p0Vect, p1Vect, pAbusive

def classifyNB(vec2Classify, p0Vect, p1Vect, pAbusive):
    p1 = np.sum(vec2Classify * p1Vect) + np.log(pAbusive)
    p0 = np.sum(vec2Classify * p0Vect) + np.log(1.0 - pAbusive)
    if p1 > p0:
        return 1
    else:
        return 0

def testingNB():
    listOPosts, listClasses = loadDataSet()
    myVocablist = creatVocablist(listOPosts)
    trainMat = []
    for postinDoc in listOPosts:
        trainMat.append(setOfwords2vec(myVocablist, postinDoc))
    p0vec, p1vec, pAb = trainNB(np.array(trainMat), np.array(listClasses))
    testEntry = ['stupid', 'garbage']
    thisDoc = np.array(setOfwords2vec(myVocablist, testEntry))
    print("the classify is {}".format(classifyNB(thisDoc, p0vec, p1vec, pAb)))

if __name__ == '__main__':
    testingNB()