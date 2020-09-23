resultList = [0,1,2,3,4,5,6,7,8,9]
    testfile = imgVector('./testDigits/0_1.txt')
    result = classfiy(testfile, trainMat, label, 3)
    print("the number is:", resultList[int(result-1)])