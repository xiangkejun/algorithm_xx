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
    queue.append(s) # "A"
    seen = set() # 集合
    seen.add(s) # A BC 
    while (len(queue)>0 ) :
        vertex = queue.pop(0) # 头顶元素 "A"
        nodes = graph[vertex] # "B""C" |
        for w in nodes:
            if w not in seen:
                queue.append(w) # B C |D
                seen.add(w) # B C |D
        print(vertex) # A

print(BFS(graph,"A")) # A B C D E F
print(BFS(graph,"E")) # E C D A B F