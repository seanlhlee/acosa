# 最小生成樹（Minimum Spanning Tree - Unweighted Graph）

最小生成樹（Minimum Spanning Tree - Unweighted Graph）對無權重圖來說，是描述在一張圖中遍歷所有節點最短路徑的樹。對有權重圖，最小生成樹其實是最小權重生成樹的簡稱。請參考下圖：

![Graph](/gitBook/pics/Graph.png)

從節點`a`要訪問其他所有節點，怎麼樣的路徑是最有效率的呢？可以利用最小生成樹（Minimum Spanning Tree - Unweighted Graph）演算法的計算來求得。

下圖為以圖來表現的最小生成樹，分支以粗體線代表：

![Minimum spanning tree](/gitBook/pics/MinimumSpanningTree.png)

畫為一般的樹看起來像下圖：

![An actual tree](/gitBook/pics/Tree.png)

要計算一個無權重圖的最小生成樹，可以使用廣度優先演算法（[BFS](Breadth-First Search)）由一個起始節點展開走訪。如果調整該算法選擇性地去除邊，那麼它可以將圖形轉換成最小生成樹。一步步來看一下這個例子：從`a`節點開始，將它加入佇列並標示為已訪問

`queue.enqueue(a)`

`a.visited = true`


佇列現為`[ a ]`，從佇列取出`a`然後加入他的鄰居`b`和`h`，並標記為已訪問。

`queue.dequeue()   // a`

`queue.enqueue(b)`

`b.visited = true`

`queue.enqueue(h)`

`h.visited = true`

佇列現為`[ b, h ]`，佇列移出`b`並新增鄰居`c`，標示已訪問。移除`b`到`h`的邊，因為`h`已訪問。

`queue.dequeue()   // b`

`queue.enqueue(c)`

`c.visited = true`

`b.removeEdgeTo(h)`

佇列現為[ h, c ]`. 佇列移出`h`並新增鄰居`g`與`i`標示為已訪問。

`queue.dequeue()   // h`

`queue.enqueue(g)`

`g.visited = true`

`queue.enqueue(i)`

`i.visited = true`

佇列現為`[ c, g, i ]`，佇列移出`c`並新增鄰居`d`與`f`，標注為已訪問，並移除`c`到`i`的邊，因為`i`已訪問。


`queue.dequeue()   // c`

`queue.enqueue(d)`

`d.visited = true`

`queue.enqueue(f)`

`f.visited = true`

`c.removeEdgeTo(i)`


佇列現為`[ g, i, d, f ]`，佇列移出`g`，他所有的鄰居都已訪問所以不需要新增進佇列移除`g`到`f`和`g`到`i`的邊，因為`f`與`i`都訪問過了。

`queue.dequeue()   // g`

`g.removeEdgeTo(f)`

`g.removeEdgeTo(i)`

佇列現為`[ i, d, f ]`，佇列移出`i`，對此節點沒有動作進行。


`queue.dequeue()   // i`

佇列現為`[ d, f ]`，佇列移出`d`並新增鄰居`e`，標示已訪問並移除`d`到`f`的邊，因為`f`已訪問。

`queue.dequeue()   // d`

`queue.enqueue(e)`

`e.visited = true`

`d.removeEdgeTo(f)`

佇列現為`[ f, e ]`，佇列移出`f`，移除`f`到`e`的邊，因為`e`已訪問。

`queue.dequeue()   // f`

`f.removeEdgeTo(e)`

佇列現為`[ e ]`，佇列移出`e`。

`queue.dequeue()   // e`

至此，佇列已經空了，最小生成樹已被計算。

## 實作：

```swift
func breadthFirstSearchMinimumSpanningTree(graph: Graph, source: Node) -> Graph {
	let minimumSpanningTree = graph.duplicate()
	
	var queue = Queue<Node>()
	let sourceInMinimumSpanningTree = minimumSpanningTree.findNodeWithLabel(source.label)
	queue.enqueue(sourceInMinimumSpanningTree)
	sourceInMinimumSpanningTree.visited = true
	
	while let current = queue.dequeue() {
		for edge in current.neighbors {
			let neighborNode = edge.neighbor
			if !neighborNode.visited {
				neighborNode.visited = true
				queue.enqueue(neighborNode)
			} else {
				current.remove(edge)
			}
		}
	}
	
	return minimumSpanningTree
}
```

`breadthFirstSearchMinimumSpanningTree`函式回傳一個新的圖`Graph`物件即為最小生成樹。事實上，其為前述例圖僅包含粗線的圖。

可在playground中測試：

```swift
let graph = Graph()

let nodeA = graph.addNode("a")
let nodeB = graph.addNode("b")
let nodeC = graph.addNode("c")
let nodeD = graph.addNode("d")
let nodeE = graph.addNode("e")
let nodeF = graph.addNode("f")
let nodeG = graph.addNode("g")
let nodeH = graph.addNode("h")
let nodeI = graph.addNode("i")

graph.addEdge(nodeA, neighbor: nodeB)
graph.addEdge(nodeA, neighbor: nodeH)
graph.addEdge(nodeB, neighbor: nodeA)
graph.addEdge(nodeB, neighbor: nodeC)
graph.addEdge(nodeB, neighbor: nodeH)
graph.addEdge(nodeC, neighbor: nodeB)
graph.addEdge(nodeC, neighbor: nodeD)
graph.addEdge(nodeC, neighbor: nodeF)
graph.addEdge(nodeC, neighbor: nodeI)
graph.addEdge(nodeD, neighbor: nodeC)
graph.addEdge(nodeD, neighbor: nodeE)
graph.addEdge(nodeD, neighbor: nodeF)
graph.addEdge(nodeE, neighbor: nodeD)
graph.addEdge(nodeE, neighbor: nodeF)
graph.addEdge(nodeF, neighbor: nodeC)
graph.addEdge(nodeF, neighbor: nodeD)
graph.addEdge(nodeF, neighbor: nodeE)
graph.addEdge(nodeF, neighbor: nodeG)
graph.addEdge(nodeG, neighbor: nodeF)
graph.addEdge(nodeG, neighbor: nodeH)
graph.addEdge(nodeG, neighbor: nodeI)
graph.addEdge(nodeH, neighbor: nodeA)
graph.addEdge(nodeH, neighbor: nodeB)
graph.addEdge(nodeH, neighbor: nodeG)
graph.addEdge(nodeH, neighbor: nodeI)
graph.addEdge(nodeI, neighbor: nodeC)
graph.addEdge(nodeI, neighbor: nodeG)
graph.addEdge(nodeI, neighbor: nodeH)

let minimumSpanningTree = breadthFirstSearchMinimumSpanningTree(graph, source: nodeA)

print(minimumSpanningTree)
```
其結果為：
```
[node: a edges: ["b", "h"]]
[node: b edges: ["c"]]
[node: c edges: ["d", "f"]]
[node: d edges: ["e"]]
[node: h edges: ["g", "i"]]
```

> **注意：** 對無權重圖而言，任一生成樹都是最小生成樹，意即也可以利用深度優先搜尋法（[DFS](Depth-First Search)來計算最小生成樹。

