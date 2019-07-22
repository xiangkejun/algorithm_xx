# 深度优先搜索
graph = {
    "A":["B","C"],
    "B":["A","C","D"],
    "C":["A","B","D","E"],
    "D":["B","C","E","F"],
    "E":["C","D"],
    "F":["D"]
}
# print(graph["A"])
def DFS(graph,s):
    stack = []
    stack.append(s)
    seen = set() # 集合
    seen.add(s)
    while (len(stack)>0 ) :
        vertex = stack.pop() # 最后的那个元素
        nodes = graph[vertex]
        for w in nodes:
            if w not in seen:
                stack.append(w)
                seen.add(w)
        print(vertex)

print(DFS(graph,"A")) # ACEDFB
print(DFS(graph,"E")) # EDFBAC