#　https://blog.csdn.net/u010591976/article/details/81809564
# ''''
# 下面采用的是两层for循环编写
# '''
# # 方法一：
# def InsertSort(Lst):
#     for i in range(1, len(Lst)):
#         x = Lst[i]
#         j = i

#         for j in range(i, -1, -1):
#             if Lst[j - 1] > x:
#                 Lst[j] = Lst[j - 1]
#             else:
#                 break
#         Lst[j] = x
# 方法二：
#一层for循环，一层while循环
def InsertSort(Lst):
    for i in range(1, len(Lst)):
        x = Lst[i]
        j = i
        while j > 0 and Lst[j-1] > x: #找合适的插入位置，采用元素后移法，循环结束的时候插入的位置下表为j，元素后移法最后需要将插入的位置放入最小的值，如果不进入循环最小值还是原来的数
            Lst[j] = Lst[j-1]         #元素后移（元素后移法）
            j -= 1
        Lst[j] = x

Lst1 = [1, 4, 4, 2, 55, 44, 66, 77, 66, 66, 88]
print(Lst1)
InsertSort(Lst1)
print(Lst1)
