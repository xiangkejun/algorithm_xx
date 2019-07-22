# BFS
graph = {
    "A":["B","C"],
    "B":["A","C","D"],
    "C":["A","B","D","E"],
    "D":["B","C","E","F"],
    "E":["C","D"],
    "F":["D"]
}
# print(graph["A"])
def BFS(graph,s):
    queue = []
    queue.append(s)
    seen = set() # 集合
    seen.add(s)
    while (len(queue)>0 ) :
        vertex = queue.pop(0) # 头顶元素
        nodes = graph[vertex]
        for w in nodes:
            if w not in seen:
                queue.append(w)
                seen.add(w)
        print(vertex)

print(BFS(graph,"A"))