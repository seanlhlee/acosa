/*:
[Previous](@previous) | [Next](@next)
***

# 深度優先搜尋法（Depth-First Search）

深度優先搜尋法（Depth-First Search）是一種樹（Tree）或圖（Graph）資料結構的搜索演算法，從圖的某一節點(vertex, node) 開始走訪，盡可能最深入到分支深處再回溯其他節點。可應用於有向圖與無向圖的搜尋。

## 動畫實例

這邊是一個說明深度優先搜尋法（Depth-First Search）的動畫：

![Animated example](AnimatedExample.gif)

假設我們由節點`A`開始走訪，深度優先搜尋法首先由第一個鄰居進行走訪，此例中是`B`節點，然後走訪`B`的第一個鄰居`D`節點，因為`D`節點無未訪問過之鄰居，便從他回溯到`B`節點的另一鄰居節點`E`⋯⋯持續到圖中所有節點均已訪問。

每次拜訪第一鄰居就持續深入，直到無法再深入之後回溯到有位拜訪鄰居節點處繼續深入式走訪，當回溯到A`所有鄰居均走訪，代表圖中所有節點均訪問完成。

此例，整個走訪的次序是`A`, `B`, `D`, `E`, `H`, `F`, `G`, `C`。

深度優先搜尋法（Depth-First Search）的過程也可以用樹來呈現：

![Traversal tree](TraversalTree.png)

樹的跟節點就是開始深度優先搜尋法（Depth-First Search）的節點，樹的分支就是回溯的節點。

## 實作：

使用遞迴來實作深度優先搜尋法（Depth-First Search）：

*/
func depthFirstSearch(graph: Graph, source: Node) -> [String] {
	var nodesExplored = [source.label]
	source.visited = true
	
	for edge in source.neighbors {
		if !edge.neighbor.visited {
			nodesExplored += depthFirstSearch(graph, source: edge.neighbor)
		}
	}
	return nodesExplored
}
/*:

深度優先搜尋法（Depth-First Search）優先訪問分支的最深處，而廣度優先搜尋法（Breadth-First Search）則是優先訪問所有的鄰居節點。以下是可在playground測試的程式碼：

*/
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

let nodesExplored = depthFirstSearch(graph, source: nodeA)
print(nodesExplored)
/*:

最後輸出是：`["a", "b", "d", "e", "h", "f", "g", "c"]`

## 使用深度優先搜尋法的好處？

廣度優先搜索可以用來解決很多問題。例如：

* 找到稀疏圖的連結元件
* 應用於拓撲排序（Topological sorting
* 圖論中的找橋演算法（請參見[維基百科: Bridge-finding_algorithm](https://en.wikipedia.org/wiki/Bridge_(graph_theory)#Bridge-finding_algorithm)）
* 許多其他應用！

***
[Previous](@previous) | [Next](@next)
*/
