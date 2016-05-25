# 最短路徑搜尋法（Shortest Path - Unweighted Graph）

目標：找到圖中由一節點到另一節點的最短距離。

假設我們有下例圖，想從中找到由節點`A`到節點`F`的最短路徑：

![Example graph](/gitBook/pics/Graph.png)

如果圖沒有權重的那其實很簡單：可以使用廣度優先搜尋演算法（breadth-first search, BFS）很快找到。對有權重的圖，可利用Dijkstra演算法。

## 無權重圖：廣度優先搜尋

廣度優先搜尋法（Breadth-First Search, BFS）是一種樹（Tree）或圖（Graph）資料結構的搜索演算法，從圖的某一節點(vertex, node) 開始走訪，接著走訪此一節點所有相鄰且未拜訪過的節點，才進一步走訪下一層級的節點。這樣的走訪方式自動地計算得到圖中來源節點到其他節點的最短路徑。廣度優先搜尋法的結果可以樹來描述：

![The BFS tree](/gitBook/pics/TraversalTree.png)

樹的跟節點就是開始廣度優先搜尋法（Breadth-First Search）的節點，要計算從節點`A`到其他節點的距離只要計算樹的邊數即可。所以`A`到`F`節點的距離是2。數不僅可以告訴我們距離也告知了如何由`A`到`F`或其他節點的路徑。在實作前我們先練習運用廣度優先搜尋法遍歷所有節點，首先我們由節點`A`出發，將其加入佇列與標示距離`0`

`queue.enqueue(A)`

`A.distance = 0`

佇列現為`[ A ]`，取出`A`然後加入他們的鄰居`B`和`C`，標記距離`1`。

`queue.dequeue()   // A`

`queue.enqueue(B)`

`B.distance = A.distance + 1   // result: 1`

`queue.enqueue(C)`

`C.distance = A.distance + 1   // result: 1`

佇列現為`[ B, C ]`，接著佇列移出`B`並新增`B`的鄰居`D`與`E`，標記距離`2`。

`queue.dequeue()   // B`

`queue.enqueue(D)`

`D.distance = B.distance + 1   // result: 2`

`queue.enqueue(E)`

`E.distance = B.distance + 1   // result: 2`

佇列現為`[ C, D, E ]`，接著佇列移出`C`並新增`C`的鄰居`F`與`G`，也是標示距離`2`。

`queue.dequeue()   // C`

`queue.enqueue(F)`

`F.distance = C.distance + 1   // result: 2`

`queue.enqueue(G)`

`G.distance = C.distance + 1   // result: 2`

持續過程到佇列為空，每次發現一個新節點就將其距離標示為父結點距離再加`1`，如同所練習的過程，就跟廣度搜尋演算法的過程相同，只是多增加了距離的追蹤。

以下為實作：

```swift
func breadthFirstSearchShortestPath(graph: Graph, source: Node) -> Graph {
	let shortestPathGraph = graph.duplicate()
	
	var queue = Queue<Node>()
	let sourceInShortestPathsGraph = shortestPathGraph.findNodeWithLabel(source.label)
	queue.enqueue(sourceInShortestPathsGraph)
	sourceInShortestPathsGraph.distance = 0
	
	while let current = queue.dequeue() {
		for edge in current.neighbors {
			let neighborNode = edge.neighbor
			if !neighborNode.hasDistance {
				queue.enqueue(neighborNode)
				neighborNode.distance = current.distance! + 1
			}
		}
	}
	
	return shortestPathGraph
}
let graph = Graph()

let nodeA = graph.addNode("a")
let nodeB = graph.addNode("b")
let nodeC = graph.addNode("c")
let nodeD = graph.addNode("d")
let nodeE = graph.addNode("e")
let nodeF = graph.addNode("f")
let nodeG = graph.addNode("g")
let nodeH = graph.addNode("h")

graph.addEdge(nodeA, neighbor: nodeB)
graph.addEdge(nodeA, neighbor: nodeC)
graph.addEdge(nodeB, neighbor: nodeD)
graph.addEdge(nodeB, neighbor: nodeE)
graph.addEdge(nodeC, neighbor: nodeF)
graph.addEdge(nodeC, neighbor: nodeG)
graph.addEdge(nodeE, neighbor: nodeH)

let shortestPathGraph = breadthFirstSearchShortestPath(graph, source: nodeA)
print(shortestPathGraph.nodes)
```

輸出是：

	Node(label: a, distance: 0), Node(label: b, distance: 1), Node(label: c, distance: 1),
	Node(label: d, distance: 2), Node(label: e, distance: 2), Node(label: f, distance: 2),
	Node(label: g, distance: 2), Node(label: h, distance: 3)

> **注意：** 這個 `breadthFirstSearchShortestPath()`實作並不會產生樹，僅是計算距離。請參閱[最小生成樹（minimum spanning tree）](Minimum Spanning Tree)由圖轉換成樹。
