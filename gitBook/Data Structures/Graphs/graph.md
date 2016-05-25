<<<<<<< HEAD
/*:
[Next](@next)
***

# 圖論（Graph）

在電腦科學的術語來說，圖是一組頂點（*vertices*）配對有一組邊（*edges*）的集合。頂點是圓的東西，而邊則為連接著頂點間的線。一個圖（Grapg）示意如下：

![A graph](/gitBook/pics/Graph.png)


=======
# 圖（Graph）

在電腦科學的術語來說，圖是一組頂點（*vertices*）配對有一組邊（*edges*）的集合。頂點是圓的東西，而邊則為連接著頂點間的線。一個圖（Grapg）示意如下：

![A graph](/gitBook/pics/Graph.png)


>>>>>>> origin/master
> **Note:** 頂點（*vertices*）也經常被稱為節點（*node*），邊也稱為鏈結（*links*）。

舉例來說，圖可以描述一個社群網絡，每個人都是頂點，而互相認識的人們則以邊來彼此連接：
![Social network](/gitBook/pics/SocialNetwork.png)

圖有各種形狀和大小。邊可以具有權重（*weight*）－ 將一個數值分配給一個邊。飛機航線圖可做為例子。城市視為頂點，航班視為邊，然後邊的權重可以描述飛行時間或票價。

![Airplane flights](/gitBook/pics/Flights.png)

上面的例圖顯示，從舊金山飛往莫斯科的航班中，途經紐約是最便宜的。前面介紹的是無向圖，邊也可以有向（*directed*），有向邊（A directed edge）代表一個單向關係。一個由頂點X到頂點Y得有向邊代表X連向Y，但**不**代表Ｙ連向Ｘ。以航線圖說明，從舊金山飛往阿拉斯加的朱諾（Juneau）的有向邊，表示有從舊金山飛往朱諾的航班，但不能從朱諾飛往舊金山。

![One-way flights](/gitBook/pics/FlightsDirected.png)

下例也是圖:

![Tree and linked list](/gitBook/pics/TreeAndList.png)

左邊是樹（**tree**）結構，右邊是鏈結串列（**linked list**），他們都有頂點（節點）與邊（鏈結），屬於簡單形式的圖。若一圖中的由一頂點經一條不重複頂點的路徑可以回到此頂點稱為有環圖（*cycles*），還有一種很常見的類型稱有向無環圖（*directed acyclic graph*, **DAG**）如下圖：

![DAG](/gitBook/pics/DAG.png)

樹是無環的，無論從哪個頂點為起點都沒有不重複頂點的路徑可以回到原點。有向無環圖就像一棵樹，沒有路徑可以回到起點，其邊為有向，但形狀並不像樹有層級關係。
<<<<<<< HEAD

## 為何使用圖？

圖是一種非常有用的數據結構。假設你設計一個程式來解決問題，可以用頂點來代表一些數據，用邊來代表數據間的關係，就可以畫出一個描述問題的圖，再使用眾所周知的圖形算法，如廣度優先（**BFS**）搜尋或深度優先搜尋（**DFS**）等，來找到解決方案。

=======

## 為何使用圖？

圖是一種非常有用的數據結構。假設你設計一個程式來解決問題，可以用頂點來代表一些數據，用邊來代表數據間的關係，就可以畫出一個描述問題的圖，再使用眾所周知的圖形算法，如廣度優先（**BFS**）搜尋或深度優先搜尋（**DFS**）等，來找到解決方案。

>>>>>>> origin/master
例如，假設有依工作清單，一些任務必須等待別人完成才開始，您可以使用有向無環圖將問題模型化如下：

![Tasks as a graph](/gitBook/pics/Tasks.png)

圖中每個頂點代表一項工作，兩個頂點間的有向邊代表完成某項工作後才能進行下一項工作，如例圖任務B與D未完成前任務C無法進行， 任務B與D也必須在任務A完成後開始。已圖來簡化問題，可使用深度優先搜尋法來實行拓樸排序（topological sort），會排出序列來代表任務進行的次序如何可以最快完成，其中一種可能的最佳化次序為A, B, D, E, C, F, G, H, I, J, K。

即便遇到很困難的問題，也可以常自問如何用途來描述問題，圖可以請出描繪數據間的關係，而其技巧在於您如何去定義這個關係。音樂家可能會喜歡這個圖：

![Chord map](/gitBook/pics/ChordMap.png)

頂點是C大調的音階和弦。邊代表和弦之間的關係 - 代表一個和弦跟隨另一個和弦。這是一個有向圖，箭頭的方向表明從一弦到下一個，也是一個加權圖，邊的權重以線的粗細表示兩個和弦之間的關係強烈程度。正如你所看到的，一個G7和弦的後面很可能是C和弦而較少是Am和弦。

其實生活中你可能已經在使用圖來解決各種問題而不自知。數據模型也是一個圖（來源：蘋果公司的 Core Data文檔）：

![Core Data model](/gitBook/pics/recipe_version2.0.jpg)

另一種常見的圖是狀態機，其邊描繪了狀態間的轉換。下圖是一隻貓的狀態機範例：

![State machine](/gitBook/pics/StateMachine.png)

圖是很好的工具。 Facebook利用人們的社交圖從而發了大財。要學習數據結構，不可錯過對圖和標準圖形演算法的學習。

## 頂點（Vertices）與邊（Edges）

簡單來說，圖就只是一堆頂點和邊的物件。但是，我們如何用程式碼來描述呢？有兩種主要的策略：鄰接列表和鄰接矩陣。

鄰接表（**Adjacency List**）: 在鄰接表實做中，每個頂點儲存一個從該頂點發出的邊的列表。例如，如果頂點A有到頂點B，C和D的邊，則頂點A儲存包含這3條邊的列表。

![Adjacency list](/gitBook/pics/AdjacencyList.png)

鄰接表描述出邊（outgoing edges）。 A有一個到B的邊，但B沒有回到A的邊，所以A不出現在B的鄰接表中。

鄰接矩陣（**Adjacency Matrix**）：在鄰接矩陣的實作中，以行和列表示邊及其權重。例如，一權重5.6的由頂點A到頂點B的有向邊，矩陣中行為頂點A，列為頂點B的元素值為5.6：

![Adjacency matrix](/gitBook/pics/AdjacencyMatrix.png)

應該使用哪一個？大多數情況下，鄰接表比較常用。以下是兩者之間的更詳細的比較。

假設* V *是圖中頂點的數目，* E *為邊的數目，我們有：

| Operation       | Adjacency List | Adjacency Matrix |
|-----------------|----------------|------------------|
| Storage Space   | O(V + E)       | O(V^2)           |
| Add Vertex      | O(1)           | O(V^2)           |
| Add Edge        | O(1)           | O(1)             |
| Check Adjacency | O(V)           | O(1)             |

表中"Checking adjacency"表示確認一個頂點是否為另一個頂點的鄰居，在以List實作時，此操作時間複雜度**O(V)**，因為最壞情況是他是每個點的鄰居。
如果圖的每個頂點跟少數頂點相鄰，稱稀疏圖（*sparse graph*），採鄰接表（**Adjacency List**）實作較佳：反之，頂點與圖中大量其他頂點相鄰，稱稀疏圖（*dense graph*），採鄰接矩陣（**Adjacency Matrix**）實作較佳。以下為使用鄰接表與鄰接矩陣實作的程式碼：
<<<<<<< HEAD

## 實作：鄰接表（**Adjacency List**）

頂點的鄰接表包含了`Edge`類別的物件：

*/
private var uniqueIDCounter = 0

public struct Edge<T>: CustomStringConvertible {
public let from: Vertex<T>
public let to: Vertex<T>
public let weight: Double
public var description: String {
return "--\(weight)-->" + to.description
}
}
/*:

這個結構描述了`from`和'to`頂點和權重值。注意，一個`Edge`物件是有向的單向連接。如果連接是雙向的，需要增加一個'Edge`物件到目標頂點的鄰接表。

該`Vertex`如下：

*/


public struct Vertex<T>: CustomStringConvertible {
public var data: T
public let uniqueID: Int

private(set) public var edges: [Edge<T>] = []

// for 鄰接表（**Adjacency List**）實作
public init(data: T) {
self.data = data
uniqueID = uniqueIDCounter
uniqueIDCounter += 1
}

// for 鄰接矩陣（**Adjacency Matrix**）實作
public init(data: T, index: Int) {
self.data = data
uniqueID = index
}


public mutating func connectTo(destinationVertex: Vertex<T>, withWeight weight: Double = 0) {
edges.append(Edge<T>(from: self, to: destinationVertex, weight: weight))
}

public mutating func connectBetween(inout otherVertex: Vertex<T>, withWeight weight: Double = 0) {
connectTo(otherVertex, withWeight: weight)
otherVertex.connectTo(self, withWeight: weight)
}
public func edgeTo(otherVertex: Vertex<T>) -> Edge<T>? {
for e in edges where e.to.uniqueID == otherVertex.uniqueID {
return e
}
return nil
}
public var description: String {
var linksTxt = ""
for edge in edges {
linksTxt += "\t"
linksTxt += edge.description
}

return "V\(uniqueID){\(data)}" + linksTxt
}
=======

## 實作：鄰接表（**Adjacency List**）

頂點的鄰接表包含了`Edge`類別的物件：

*/
private var uniqueIDCounter = 0

public struct Edge<T>: CustomStringConvertible {
	public let from: Vertex<T>
	public let to: Vertex<T>
	public let weight: Double
	public var description: String {
		return "--\(weight)-->" + to.description
	}
}
/*:

這個結構描述了`from`和'to`頂點和權重值。注意，一個`Edge`物件是有向的單向連接。如果連接是雙向的，需要增加一個'Edge`物件到目標頂點的鄰接表。

該`Vertex`如下：

```swift
public struct Vertex<T>: CustomStringConvertible {
	public var data: T
	public let uniqueID: Int
	
	private(set) public var edges: [Edge<T>] = []
	
	// for 鄰接表（**Adjacency List**）實作
	public init(data: T) {
		self.data = data
		uniqueID = uniqueIDCounter
		uniqueIDCounter += 1
	}
	
	// for 鄰接矩陣（**Adjacency Matrix**）實作
	public init(data: T, index: Int) {
		self.data = data
		uniqueID = index
	}
	
	
	public mutating func connectTo(destinationVertex: Vertex<T>, withWeight weight: Double = 0) {
		edges.append(Edge<T>(from: self, to: destinationVertex, weight: weight))
	}
	
	public mutating func connectBetween(inout otherVertex: Vertex<T>, withWeight weight: Double = 0) {
		connectTo(otherVertex, withWeight: weight)
		otherVertex.connectTo(self, withWeight: weight)
	}
	public func edgeTo(otherVertex: Vertex<T>) -> Edge<T>? {
		for e in edges where e.to.uniqueID == otherVertex.uniqueID {
			return e
		}
		return nil
	}
	public var description: String {
		var linksTxt = ""
		for edge in edges {
			linksTxt += "\t"
			linksTxt += edge.description
		}
		
		return "V\(uniqueID){\(data)}" + linksTxt
	}
	
}
```

頂點的關聯型別`T`代表使用泛型。頂點也有一個唯一的標識符，用來實作比較用。`edges`陣列為鄰接表。

使用有向邊`connectTo`來連接兩個頂點，或使用`connectBetween`來連接兩點使其雙向連結。使用`edgeTo`來確認頂點與其他頂點是否相鄰。以下是一簡單範例：
>>>>>>> origin/master

}
/*:

<<<<<<< HEAD
頂點的關聯型別`T`代表使用泛型。頂點也有一個唯一的標識符，用來實作比較用。`edges`陣列為鄰接表。

使用有向邊`connectTo`來連接兩個頂點，或使用`connectBetween`來連接兩點使其雙向連結。使用`edgeTo`來確認頂點與其他頂點是否相鄰。以下是一簡單範例：

![Demo](/gitBook/pics/Demo1.png)

*/
=======
```swift
>>>>>>> origin/master
var v1 = Vertex(data: 1)
var v2 = Vertex(data: 2)
var v3 = Vertex(data: 3)
var v4 = Vertex(data: 4)
var v5 = Vertex(data: 5)

v1.connectTo(v2, withWeight: 1.0)
v2.connectTo(v3, withWeight: 1.0)
v3.connectTo(v4, withWeight: 4.5)
v4.connectTo(v1, withWeight: 2.8)
v2.connectTo(v5, withWeight: 3.2)

// Returns the weight of the edge from v1 to v2 (1.0)
v1.edgeTo(v2)?.weight

// Returns the weight of the edge from v1 to v3 (nil, since there is not an edge)
v1.edgeTo(v3)?.weight

// Returns the weight of the edge from v3 to v4 (4.5)
v3.edgeTo(v4)?.weight

// Returns the weight of the edge from v4 to v1 (2.8)
v4.edgeTo(v1)?.weight
<<<<<<< HEAD

/*:

> **注意：** 有非常多的方式可以實作圖。這邊僅是揭露一種可能的實作方法。你可能要因應希望解決的問題來修改程式碼，例如，您的邊緣可能不需要權重`weight`屬性，或者可能沒有必要區分有向和無向邊。

## 實作: 鄰接矩陣（**Adjacency Matrix**）

接下來將以二維陣列`[[Double?]]`來代表鄰接矩陣，陣列中`nil`表示沒有相連的邊，而有值則代表了邊的權重。
*/
public struct Graph<T>: CustomStringConvertible {
private var adjacencyMatrix: [[Double?]] = []

public mutating func createVertex(data: T) -> Vertex<T> {
let vertex = Vertex(data: data, index: adjacencyMatrix.count)

// Expand each existing row to the right one column.
for i in 0..<adjacencyMatrix.count {
adjacencyMatrix[i].append(nil)
}

// Add one new row at the bottom.
let newRow = [Double?](count: adjacencyMatrix.count + 1, repeatedValue: nil)
adjacencyMatrix.append(newRow)

return vertex
}

public mutating func connect(sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>, withWeight weight: Double = 0) {
adjacencyMatrix[sourceVertex.uniqueID][destinationVertex.uniqueID] = weight
}

public func weightFrom(sourceVertex: Vertex<T>, toDestinationVertex: Vertex<T>) -> Double? {
return adjacencyMatrix[sourceVertex.uniqueID][toDestinationVertex.uniqueID]
}

public var description: String {
return adjacencyMatrix.description
}

}
/*:

若`adjacencyMatrix[i][j]`非`nil`表示有頂點`i`到頂點`j`的邊。為了索引陣列中每個頂點，每個`Vertex`物件都有一個個別的索引值：

在圖中要建立一新的頂點需要更新矩陣大小，矩陣資料建立好，可以很簡易的利用索引值來操作與查詢，測試如下：

*/
var graph = Graph<Int>()
let gv1 = graph.createVertex(1)
let gv2 = graph.createVertex(2)
let gv3 = graph.createVertex(3)
let gv4 = graph.createVertex(4)
let gv5 = graph.createVertex(5)

graph.connect(gv1, to: gv2, withWeight: 1.0)
graph.connect(gv2, to: gv3, withWeight: 1.0)
graph.connect(gv3, to: gv4, withWeight: 4.5)
graph.connect(gv4, to: gv1, withWeight: 2.8)
graph.connect(gv2, to: gv5, withWeight: 3.2)

graph.adjacencyMatrix

// Returns the weight of the edge from v1 to v2 (1.0)
graph.weightFrom(gv1, toDestinationVertex: gv2)

// Returns the weight of the edge from v1 to v3 (nil, since there is not an edge)
graph.weightFrom(gv1, toDestinationVertex: gv3)

// Returns the weight of the edge from v3 to v4 (4.5)
graph.weightFrom(gv3, toDestinationVertex: gv4)

// Returns the weight of the edge from v4 to v1 (2.8)
graph.weightFrom(gv4, toDestinationVertex: gv1)

/*:

此例，鄰接矩陣如下:

[[nil, 1.0, nil, nil, nil]    v1
[nil, nil, 1.0, nil, 3.2]    v2
[nil, nil, nil, 4.5, nil]    v3
[2.8, nil, nil, nil, nil]    v4
[nil, nil, nil, nil, nil]]   v5

v1   v2   v3   v4   v5


## 參考資料

本文介紹了什麼是圖，可以如何實現基本的資料結構。圖還有許多實際應用，請繼續了解！

***
[Next](@next)
*/








=======
```

> **注意：** 有非常多的方式可以實作圖。這邊僅是揭露一種可能的實作方法。你可能要因應希望解決的問題來修改程式碼，例如，您的邊緣可能不需要權重`weight`屬性，或者可能沒有必要區分有向和無向邊。

## 實作: 鄰接矩陣（**Adjacency Matrix**）

接下來將以二維陣列`[[Double?]]`來代表鄰接矩陣，陣列中`nil`表示沒有相連的邊，而有值則代表了邊的權重。
```swift
public struct Graph<T>: CustomStringConvertible {
	private var adjacencyMatrix: [[Double?]] = []
	
	public mutating func createVertex(data: T) -> Vertex<T> {
		let vertex = Vertex(data: data, index: adjacencyMatrix.count)
		
		// Expand each existing row to the right one column.
		for i in 0..<adjacencyMatrix.count {
			adjacencyMatrix[i].append(nil)
		}
		
		// Add one new row at the bottom.
		let newRow = [Double?](count: adjacencyMatrix.count + 1, repeatedValue: nil)
		adjacencyMatrix.append(newRow)
		
		return vertex
	}
	
	public mutating func connect(sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>, withWeight weight: Double = 0) {
		adjacencyMatrix[sourceVertex.uniqueID][destinationVertex.uniqueID] = weight
	}
	
	public func weightFrom(sourceVertex: Vertex<T>, toDestinationVertex: Vertex<T>) -> Double? {
		return adjacencyMatrix[sourceVertex.uniqueID][toDestinationVertex.uniqueID]
	}
	
	public var description: String {
		return adjacencyMatrix.description
	}
	
}
```

若`adjacencyMatrix[i][j]`非`nil`表示有頂點`i`到頂點`j`的邊。為了索引陣列中每個頂點，每個`Vertex`物件都有一個個別的索引值：

在圖中要建立一新的頂點需要更新矩陣大小，矩陣資料建立好，可以很簡易的利用索引值來操作與查詢，測試如下：

```swift
var graph = Graph<Int>()
let gv1 = graph.createVertex(1)
let gv2 = graph.createVertex(2)
let gv3 = graph.createVertex(3)
let gv4 = graph.createVertex(4)
let gv5 = graph.createVertex(5)

graph.connect(gv1, to: gv2, withWeight: 1.0)
graph.connect(gv2, to: gv3, withWeight: 1.0)
graph.connect(gv3, to: gv4, withWeight: 4.5)
graph.connect(gv4, to: gv1, withWeight: 2.8)
graph.connect(gv2, to: gv5, withWeight: 3.2)

graph.adjacencyMatrix

// Returns the weight of the edge from v1 to v2 (1.0)
graph.weightFrom(gv1, toDestinationVertex: gv2)

// Returns the weight of the edge from v1 to v3 (nil, since there is not an edge)
graph.weightFrom(gv1, toDestinationVertex: gv3)

// Returns the weight of the edge from v3 to v4 (4.5)
graph.weightFrom(gv3, toDestinationVertex: gv4)

// Returns the weight of the edge from v4 to v1 (2.8)
graph.weightFrom(gv4, toDestinationVertex: gv1)
```

此例，鄰接矩陣如下:
```
[[nil, 1.0, nil, nil, nil]    v1
 [nil, nil, 1.0, nil, 3.2]    v2
 [nil, nil, nil, 4.5, nil]    v3
 [2.8, nil, nil, nil, nil]    v4
 [nil, nil, nil, nil, nil]]   v5

  v1   v2   v3   v4   v5
```

## 參考資料

本文介紹了什麼是圖，可以如何實現基本的資料結構。圖還有許多實際應用，請繼續了解！









>>>>>>> origin/master





