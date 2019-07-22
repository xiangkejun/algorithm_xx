# https://blog.csdn.net/sinat_38321889/article/details/80390238
#selectSort which is a time-consuming sort algorithm.Its Time-complexity is O(N**2)
#1、we just use the simple sort algorithm to get the smallest number per loop,which the time-consuming is O(n)
#2、next we can define a function that a loop to get the small value every loop,and the append the value into a new Array
#to get the minmum value
# 选择排序
def getmin(arr):
    min = arr[0];
    min_index = 0;
    for i in range(0,len(arr)):
        if arr[i]<min:
            min = arr[i]
            min_index = i
    return min_index

#SelectSort
def selectSort(arr):
    newArr = [];
    for i in range(0,len(arr)):
        min = getmin(arr);
        newArr.append(arr.pop(min))
    return newArr;

#test the output
a = [4,6,9,1,3,87,41,5]
print(selectSort(a))  # [1, 3, 4, 5, 6, 9, 41, 87]