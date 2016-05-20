
# 聯合搜尋法（Union-Find）

聯合搜尋法是一種將集合中分成互不交集的子集合的一種資料結構，也稱為並查集（disjoint-set data structure）。舉例來說，聯合搜尋法資料結構可以對下列集合保持追蹤以下互不交集的集合:

	[ a, b, f, k ]
	[ e ]
	[ g, d, c ]
	[ i, j ]

聯合搜尋法主要有三種操作：

1. **Find(A)**： 找到哪一個集合中含有元素**A**。例如`find(d)`將會回傳是`[ g, d, c ]`子集合。

2. **Union(A, B)**：合併包含**A**與**B**的子集合成為新集合。例如`union(d, j)`會將`[ g, d, c ]`與`[ i, j ]`合併成`[ g, d, c, i, j ]`。

3. **AddSet(A)**：增加一個僅函**A**元素之子集合。例如，`addSet(h)`會增加`[ h ]`子集合。

這種資料結構最常被應用於追蹤「圖」（graph）中無向的相互連結的元素。也可用于實作Kruskal演算法的有效版本用以找到一個圖形的最小生成樹（the minimum spanning tree）。

## 實作

聯合搜尋法可以已多種方式實作，此處我們介紹最有效率的一種。
```swift
import Foundation

public struct UnionFind<T: Hashable> {
	private var index = [T: Int]()
	private var parent = [Int]()
	private var size = [Int]()
}
```
此處的聯合搜尋法的資料結構事實上是由許多樹的子集合組成的森林。要做到前述功能，需要一個追蹤每個節點的父節點的陣列`parent`，不需紀錄子集點，`parent[i]`為索引值`i`節點的父節點。

例如：`parent`陣列如下

	parent [ 1, 1, 1, 0, 2, 0, 6, 6, 6 ]
		i    0  1  2  3  4  5  6  7  8

則對應了如下兩個樹結構：

	      1              6
	    /   \           / \
	  0       2        7   8
	 / \     /
	3   5   4

此處有兩棵樹，每棵代表了一個數字集合。給定每一個子集合一個獨特的數字來代表，此數字也代表子集合樹的跟節點索引值。如範例中`1`為第一個樹的跟節點，`6`為第二棵樹的根節點。我們以`1`來標註第一子集合，以`6`來標註第二子集合。**Find**的操作結果實際上是回傳子集合的標註而非內容。注意到一個根節點在`parent[]`中會指向自己的索引值，`parent[1] = 1`、`parent[6] = 6`這也是我們可以辨別根節點的方式。

## 增加子集合

接著，介紹幾個基本操作的實作。首先由增加新的子集合開始：
```swift
extension UnionFind {
	public mutating func addSetWith(element: T) {
		index[element] = parent.count  // 1
		parent.append(parent.count)    // 2
		size.append(1)                 // 3
	}
}
```
當增加一個新元素，實際上是增加一個只包含此元素的子集合。

1. 定義此新元素的索引值於`index`字典中，這樣之後能很快的查找到該元素。

2. 之後將父節點的索引值紀錄到`parent`陣列中。此處`parent[i]`指向自己，因為此新增的樹子集合僅有單一元素。

3. `size[i]`代表根節點索引值為`i`的樹中的節點數。對新建的樹，該值為1，之後會在其他的操作中使用到`size`陣列。

## 尋找（Find）

我們經常需要查找是否某一個集合包含尋找的元素。此**Find**操作在聯合查找中為`setOf()`函式:

```swift
extension UnionFind {
	public mutating func setOf(element: T) -> Int? {
		if let indexOfElement = index[element] {
			return setByIndex(indexOfElement)
		} else {
			return nil
		}
	}
}
```

此函式於`index`字典中查找元素的索引值，在使用以下的輔助函式回傳所屬的子集合:

```swift
extension UnionFind {
	private mutating func setByIndex(index: Int) -> Int {
		if parent[index] == index {  // 1
			return index
		} else {
			parent[index] = setByIndex(parent[index])  // 2
			return parent[index]       // 3
		}
	}
}
```

因為我們正在處理的是一個樹狀結構，是一個遞迴的方法

之前提及，每個集合由一個樹代表，其根節點的索引值作為代表子集合的標籤。可以發現，尋找操作即在尋找元素所屬樹的根節點，並返回其索引。

1. 首先，我們確認輸入的索引值是否代表一根節點，若是即回傳該值。

2. 若非，則我們遞迴地找到跟節點索引值。我們做了**非常重要**的動作： 覆寫了當前節點父節點索引值為跟節點的索引值。這樣下次查找時就會非常快。在未更新為根節點索引值前，時間複雜度為**O(n)**，最佳化後可達**O(1)**效率。

3. 回傳根節點索引值

以下圖示說明:

![BeforeFind](/gitBook/pics/BeforeFind.png)

呼叫`setOf(4)`，會先得到索引值`2`接著為`7`。（圖中索引值標示為紅色）

在呼叫`setOf(4)`之後樹結構成為：

![AfterFind](/gitBook/pics/AfterFind.png)

之後，我們在呼叫`setOf(4)`就不用再經過節點`2`來知道根節點。當使用聯合搜尋法，會自動最佳化，還不錯。

以下為另一個輔助函式，用來檢查兩元素是否在同一個子集合中：

```swift
extension UnionFind {
	public mutating func inSameSet(firstElement: T, and secondElement: T) -> Bool {
		if let firstSet = setOf(firstElement), secondSet = setOf(secondElement) {
			return firstSet == secondSet
		} else {
			return false
		}
	}
}
```

此函式亦呼叫`setOf()`函式，同時也會優化樹結構。

## 聯合（Union）

現在介紹**Union**，此操作合併兩子集合成為一個較大的子集合。

```swift
extension UnionFind {
	public mutating func unionSetsContaining(firstElement: T, and secondElement: T) {
		if let firstSet = setOf(firstElement), secondSet = setOf(secondElement) {  // 1
			if firstSet != secondSet {               // 2
				if size[firstSet] < size[secondSet] {  // 3
					parent[firstSet] = secondSet         // 4
					size[secondSet] += size[firstSet]    // 5
				} else {
					parent[secondSet] = firstSet
					size[firstSet] += size[secondSet]
				}
			}
		}
	}
}

extension UnionFind: CustomStringConvertible {
	public var description: String {
		return parent.description
	}
}
```

說明如下：

1. 查找每個元素所屬的子集合，回傳值為兩索引值，分別代表根節點的索引值。

2. 確認是否為不同的兩個子集合。

3. 將較小的樹與較大的樹合併，事先判斷哪個子集合較小。

4. 都過修改根節點，將較小的樹合併到較大的樹。

5. 修改大樹的大小。

下列圖示有助於理解，假設兩子集合有各自所屬的樹結構：

![BeforeUnion](/gitBook/pics/BeforeUnion.png)

呼叫`unionSetsContaining(4, and: 3)`後，較小的樹與較大的樹合併：

![AfterUnion](/gitBook/pics/AfterUnion.png)

因為在執行時，也呼叫了`setOf()`，較大的樹同時也最佳化了結構 -- 節點`3`直接銜接於根節點上。

時間複雜度為**O(1)**。

## 參考資料

[維基百科: Union-Find](https://en.wikipedia.org/wiki/Disjoint-set_data_structure)



