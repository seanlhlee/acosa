/*:
[Previous](@previous) | [Next](@next)
***

# 拓撲排序法（Topological Sort）

拓撲排序（Topological sort）是一種有向圖（directed graph）的排序法，使得每個定向邊* U→V *，*頂點U *排序在* 頂點V*前的演算法。

換言之，一個拓撲排序將有向無環圖（directed acyclic graph，DAG）的頂點排列於一線上，使所有指向邊均從左到右。

考慮以下示例中的圖（graph）：

![Example](Graph.png)

此圖排序後有兩種呈現方式：

![Example](TopologicalSort.png)

其次序為**S, V, W, T, X**與**S, W, V, T, X**。所有的箭頭由左向右指。

下例則非一個有效的拓樸排序圖，因為**頂點X**與**頂點T**不可在**頂點V**之前：

![Example](InvalidSort.png)

## 用在哪裡？

讓我們考慮一個問題：要從網路上學習所有的算法和數據結構，這似乎是一項艱鉅任務，但我們可以用拓撲排序來使學習有組織地進行。現在正在學習拓撲排序，我們以此為例子。你需要什麼先學，才能充分了解拓撲排序？拓撲排序使用到**深度優先搜尋（ＤＦＳ）**與**堆疊（Stack）**，但在此之前，需先了解什麼是**圖（Graph）**，同時了解**樹（Tree）**也會有幫助。反過來說，在學習拓撲排序前，先了解圖和樹將物件連結的想法再進入到深度優先搜尋法等等⋯⋯之後再學習會比較容易充分了解。

如果我們以圖（Graph）來表示，會是下面的形式：

![Example](Algorithms.png)

假設每一個算法是在圖中的頂點（ vertex），可以清楚地看到它們之間的依賴關係。要學習的東西，你可能需要先學習一些其他的知識。這正是拓撲排序的用途—將需要進行的事情排序從而得到路徑的一項方法。

## 運作原理

**第1步：查找入度（In-degree）為0的所有頂點**

一個頂點的*入度*是指向該頂點的邊數，沒有輸入的邊的頂點其入度為0。這些頂點可作為拓撲排序的起點。

在前面的例子中，這些起始頂點表示學習這些算法和數據結構之前，不需要學習其他基礎，因此排序由他們開始。

**第2步：以深度優先搜尋法遍歷整個圖**

深度優先搜尋是以某個頂點啟動，並盡可能探索到最遠的節點，再沿著每個分支回溯的遍歷圖形的演算法。要了解更多關於深度優先搜尋(DFS)，請先參閱深度優先搜尋(DFS)的章節。

我們對每個入度0頂點執行深度優先搜尋，這告訴我們哪些頂點連接到這些起始頂點。

**第3步：記住所有訪問過的頂點**

當我們進行深度優先搜尋，我們紀錄一個已訪問的列表，來避免重複訪問。

**第四步：把它放在一起**

排序的最後一步是結合不同的深度優先搜尋的結果，並把頂點列在排序列表。

## 例子

請看下圖：

![Graph Example](Example.png)

**第1步：** 入度0的節點有：**3, 7, 5**，這些是我們的起點。

**第2步：** 每個起始節點進行深度優先搜尋（不紀錄是否訪問過）：

	Vertex 3: 3, 10, 8, 9
	Vertex 7: 7, 11, 2, 8, 9
	Vertex 5: 5, 11, 2, 9, 10

**第3步：** 將搜尋結果去除重複訪問的節點

	Vertex 3: 3, 10, 8, 9
	Vertex 7: 7, 11, 2
	Vertex 5: 5

**第4步：** 結合這三個深度優先搜尋的結果。最後其次序是**5, 7, 11, 2, 3, 10, 8, 9**。（重要：必須將每一個搜尋結果加到前一個結果之前），其結果如下：

![Result of the sort](GraphResult.png)

> **注意：** 這不是唯一一種拓樸排序的型態。例如，**3, 7, 5, 10, 8, 11, 9, 2**與**3, 7, 5, 8, 11, 2, 9, 10**也可以解，任何箭頭都是由左往右指的序列都可作為解的型態。

## 實作

以下是拓樸排序法（Topological Sort）以Swift語言的實作：

*/
extension Graph {
	public func topologicalSort() -> [Node] {
		// 1
		let startNodes = calculateInDegreeOfNodes().filter({ _, indegree in
			return indegree == 0
		}).map({ node, indegree in
			return node
		})
		
		// 2
		var visited = [Node : Bool]()
		for (node, _) in adjacencyLists {
			visited[node] = false
		}
		
		// 3
		var result = [Node]()
		for startNode in startNodes {
			result = depthFirstSearch(startNode, visited: &visited) + result
		}
		
		// 4
		return result
	}
	
	
	private func depthFirstSearch(source: Node, inout visited: [Node : Bool]) -> [Node] {
		var result = [Node]()
		
		if let adjacencyList = adjacencyList(forNode: source) {
			for nodeInAdjacencyList in adjacencyList {
				if let seen = visited[nodeInAdjacencyList] where !seen {
					result = depthFirstSearch(nodeInAdjacencyList, visited: &visited) + result
				}
			}
		}
		
		visited[source] = true
		return [source] + result
	}
}

/*:

說明：

1. 找到入度0的頂點並將其放入`startNodes`陣列中。在圖（Graph）類別的實作中，頂點被稱為節點，通常這兩個詞都有人使用也是可以互用的。

2. `visited`字典持續追蹤於深度優先搜尋已被訪問的節點，開始前將字典內所有節點設為`false`。

3. 對`startNodes`陣列中的所有節點進行深度優先搜尋，回傳`Node`物件的已排序陣列，我們將其加到`result`陣列之前。

4. `result`陣列包含全部經拓樸排序的頂點。

> **注意：** 還有一種些微不同一樣使用深度優先搜尋法的實作版本，如後實作，使用堆疊來實作，此方式不需先找到入度0的所有節點。

*/
extension Graph {
	public func topologicalSortAlternative() -> [Node] {
		var stack = [Node]()
		
		var visited = [Node: Bool]()
		for (node, _) in adjacencyLists {
			visited[node] = false
		}
		
		func depthFirstSearch(source: Node) {
			if let adjacencyList = adjacencyList(forNode: source) {
				for neighbor in adjacencyList {
					if let seen = visited[neighbor] where !seen {
						depthFirstSearch(neighbor)
					}
				}
			}
			stack.append(source)
			visited[source] = true
		}
		
		for (node, _) in visited {
			if let seen = visited[node] where !seen {
				depthFirstSearch(node)
			}
		}
		
		return stack.reverse()
	}
}

/*:
## 可汗（Kahn）演算法

採用深度優先演算法是典型實作拓樸演算法的方式，也有其他演算法

1. 找到每個頂點的入度。
2. 將每個入度0的頂點放入稱為`leaders`的陣列中。
3. 將`leaders`陣列中的頂點指向移除，即使其不指向其他頂點。
4. 再次尋找圖中仍有鄰居而內度為0的頂點，再將它們放入`leaders`陣列中。
5. 持續到所有頂點都被放入`leaders`陣列，此時陣列即呈排序的狀態。

此演算法時間複雜度**O(n + m)**，其中**n**為頂點數，**m**為連結頂點的邊數。
*/
extension Graph {
	/* Topological sort using Kahn's algorithm. */
	public func topologicalSortKahn() -> [Node] {
		var nodes = calculateInDegreeOfNodes()
		
		// Find vertices with no predecessors and puts them into a new list.
		// These are the "leaders". The leaders array eventually becomes the
		// topologically sorted list.
		var leaders = nodes.filter({ _, indegree in
			return indegree == 0
		}).map({ node, indegree in
			return node
		})
		
		// "Remove" each of the leaders. We do this by decrementing the in-degree
		// of the nodes they point to. As soon as such a node has itself no more
		// predecessors, it is added to the leaders array. This repeats until there
		// are no more vertices left.
		var l = 0
		while l < leaders.count {
			if let edges = adjacencyList(forNode: leaders[l]) {
				for neighbor in edges {
					if let count = nodes[neighbor] {
						nodes[neighbor] = count - 1
						if count == 1 {             // this leader was the last predecessor
							leaders.append(neighbor)  // so neighbor is now a leader itself
						}
					}
				}
			}
			l += 1
		}
		
		// Was there a cycle in the graph?
		if leaders.count != nodes.count {
			print("Error: graphs with cycles are not allowed")
		}
		
		return leaders
	}
}

/*:
***
[Previous](@previous) | [Next](@next)
*/
