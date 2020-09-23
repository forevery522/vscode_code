from numpy import *
import operator

file = open('./testDigits/0_0.txt')
file_lines = file.readlines()
file = open('./testDigits/0_0.txt')
file_line = file.readline().strip()
x = len(file_lines)
y = len(file_line)
print(x*y)