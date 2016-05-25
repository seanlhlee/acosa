/*:
[Previous](@previous) | [Next](@next)
***

# 廣度優先搜尋法（Breadth-First Search）

廣度優先搜尋法（Breadth-First Search, BFS）是一種樹（Tree）或圖（Graph）資料結構的搜索演算法，從圖的某一節點(vertex, node) 開始走訪，接著走訪此一節點所有相鄰且未拜訪過的節點，才進一步走訪下一層級的節點。可應用於有向圖與無向圖的搜尋。

## 動畫實例

這邊是一個說明廣度優先搜尋法（Breadth-First Search）的動畫：

![Animated example of a breadth-first search](AnimatedExample.gif)

當走訪一個節點後，顏色變黑並將其鄰居節點放進佇列（queue）中，已放入佇列尚未走訪的呈現灰色。由`A`節點開始，一開始`A`變灰。

`queue.enqueue(A)`

佇列現為`[ A ]`，當有節點在佇列中，我們就依先進先出的方式走訪，並在過程中將為走訪過的鄰居的鄰居也加入佇列，開始時，我們將第一個節點`A`加入佇列走仿後標記為黑，然後加入他的鄰居`B`和`C`著灰色。

`queue.dequeue()   // A`

`queue.enqueue(B)`

`queue.enqueue(C)`

佇列現為`[ B, C ]`，接著佇列移出`B`並新增`B`的鄰居`D`與`E`

`queue.dequeue()   // B`

`queue.enqueue(D)`

`queue.enqueue(E)`

佇列現為`[ C, D, E ]`，接著佇列移出`C`並新增`C`的鄰居`F`與`G`

`queue.dequeue()   // C`

`queue.enqueue(F)`

`queue.enqueue(G)`

佇列現為`[ D, E, F, G ]`，接著佇列移出`D`，沒有鄰居

`queue.dequeue()   // D`

佇列現為`[ E, F, G ]`，接著佇列移出`E`並新增鄰居`H`。注意到`B`也是`E`的鄰居，因為已訪問我們並不將其加入佇列

`queue.dequeue()  // E`

`queue.enqueue(H)`

佇列現為`[ F, G, H ]`，移出`F`，沒有鄰居

`queue.dequeue()   // F`

佇列現為`[ G, H ]`，移出`G`，沒有鄰居

`queue.dequeue()   // G`

佇列現為`[ H ]`，移出`H`，沒有鄰居

`queue.dequeue()   // H`

現在佇列已經空了，也就是所有節點都走訪完畢，整個走訪的次序是`A`, `B`, `C`, `D`, `E`, `F`, `G`, `H`，可以數來呈現：

![The BFS tree](TraversalTree.png)

樹的跟節點就是開始廣度優先搜尋法（Breadth-First Search）的節點，每個節點的父節點（parent）為發現他們的節點。對沒有權重的圖，樹定義了一個從根節點到樹上每個節點的最短路徑。所以廣度優先搜尋法（Breadth-First Search）也是一種找到圖中兩節點最短路徑的方法之一。

## 實作：

用佇列來實作廣度優先搜尋法（Breadth-First Search）：

*/
func breadthFirstSearch(graph: Graph, source: Node) -> [String] {
	var queue = Queue<Node>()
	queue.enqueue(source)
	
	var nodesExplored = [source.label]
	source.visited = true
	
	while let node = queue.dequeue() {
		for edge in node.neighbors {
			let neighborNode = edge.neighbor
			if !neighborNode.visited {
				queue.enqueue(neighborNode)
				neighborNode.visited = true
				nodesExplored.append(neighborNode.label)
			}
		}
	}
	
	return nodesExplored
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
graph.addEdge(nodeE, neighbor: nodeF)
graph.addEdge(nodeF, neighbor: nodeG)

let nodesExplored = breadthFirstSearch(graph, source: nodeA)
print(nodesExplored)
/*:

最後輸出是：`["a", "b", "c", "d", "e", "f", "g", "h"]`

## 使用廣度優先搜尋法的好處？

廣度優先搜索可以用來解決很多問題。例如：

* 計算無權重圖的起點節點與每個其它節點之間的[最短路徑](Shortest Path)。
* 計算無權重的[最小生成樹](Minimum Spanning Tree)。

***
[Previous](@previous) | [Next](@next)
*/
