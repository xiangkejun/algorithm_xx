  ## """快速排序"""
# 方法一：
# def quickSort(arr):
#     if len(arr) <= 1:
#         return arr
#     pivot =  arr[len(arr)//2]
#     left = [value for value in arr if value < pivot]
#     middle = [value for value in arr if value == pivot]
#     right = [value for value in arr if value > pivot]
#     return quickSort(left)+middle+quickSort(right)

# print(quickSort([3,1,5,7,2,2,4]))  # [1, 2, 2, 3, 4, 5, 7]

# 方法二：一句实现(高逼格)
# quick_sort = lambda array: array if len(array) <= 1 else quick_sort([
#     item for item in array[1:] if item <= array[0]
# ]) + [array[0]] + quick_sort([item for item in array[1:] if item > array[0]])

# print(quick_sort([2,5,9,3,7,1,5]))

# 方法三：
def quick_sort(b):
    """快速排序"""
    if len(b) < 2:
        return b
    # 选取基准，随便选哪个都可以，选中间的便于理解
    mid = b[len(b) // 2]
    # 定义基准值左右两个数列
    left, right = [], []
    # 从原始数组中移除基准值
    b.remove(mid)
    for item in b:
        # 大于基准值放右边
        if item >= mid:
            right.append(item)
        else:
            # 小于基准值放左边
            left.append(item)
    # 使用迭代进行比较
    return quick_sort(left) + [mid] + quick_sort(right)

b = [11, 99, 33, 69, 77, 88, 55, 11, 33, 36, 39, 66, 44, 22]
print(quick_sort(b))