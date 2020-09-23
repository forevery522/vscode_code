### First day: 
*** 
 I learned KNN, and I knowed how to calculate the Euclidean Distance, and I tried to achive the first basic project. I want to say, I feel so interesting now!  

 *everyday sharing: True mastery of any skill takes a lifetime.*  

### Second day:
***
Today, I finished the first basic project --- dating prediction. And I have learned that the kernel of KNN is the distance, sorting and filtering. KNN is one kind of lazy learning, so it doesn't have the process of training. kernel code follows bellow:   
```python
def classify(testData, dataSet, label, k):
    '''
    calculate Euclidean Distance
    '''
    xlength = dataSet.shape[0]
    diffData = tile(testData,(xlength,1)) - dataSet
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
```
the return value is the closed value.  

*everyday sharing: Do one thing at one time, and do well!*