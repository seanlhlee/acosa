# 二維陣列（Array2D）

使用C語言或Objective-C語言可使用下式來定義一二維陣列，

```swift
int cookies[9][7];
```

來建立一9x7的二維陣列。可利用下式來存取第三行（row 3）第六列（column 6）:

```swift
myCookie = cookies[3][6];
```

在Swift中，這樣寫的程式碼是不可行的。使用Swift語言建立多維度陣列的方式類似下列：
```swift
var cookies = [[Int]]()
for _ in 1...9 {
	var row = [Int]()
	for _ in 1...7 {
		row.append(0)
	}
	cookies.append(row)
}
```
存取特定位置則是，

```swift
let myCookie = cookies[3][6]
```

也可以以單行來建立二維陣列，

```swift
var cookies = [[Int]](count: 9, repeatedValue: [Int](count: 7, repeatedValue: 0))
```

這實在不是好的程式碼寫法。藉由另一個如下函式所示的輔助可以讓語意更清晰，：
```swift
func dim<T>(count: Int, _ value: T) -> [T] {
	return [T](count: count, repeatedValue: value)
}

var cookies = dim(9, dim(7, 0))
```

因為給定的預設元素值為`0`，Swift會推斷陣列中元素的型態為`Int`，如果是一個字串的二維陣列，就會像是，

```swift
var cookies = dim(9, dim(7, "yum"))
```

使用輔助`dim()`函式也很容易可以建立更高維度的陣列：


```swift
var threeDimensions = dim(2, dim(3, dim(4, 0)))
```



這樣做，陣列內容是多層的，有一個壞處是不容易追蹤行與列代表的意義。因此，可以創建一個新的類別來取代這樣的做法，同時更容易使用，以下為`Array2D`類別的實作：

```swift
public struct Array2D<T> {
	public let columns: Int
	public let rows: Int
	private var array: [T]
	
	public init(rows: Int, columns: Int, initialValue: T) {
		self.columns = columns
		self.rows = rows
		array = .init(count: rows*columns, repeatedValue: initialValue)
	}
	func indexIsValidForRow(row: Int, column: Int) -> Bool {
		return row >= 0 && row < rows && column >= 0 && column < columns
	}
	func indexIsValid(row: Int, range: Range<Int>) -> Bool {
		return _indexIsValid(row...row, colRange: range)
	}
	func indexIsValid(range: Range<Int>, column: Int) -> Bool {
		return _indexIsValid(range, colRange: column...column)
	}
	func _indexIsValid(rowRange: Range<Int>? ,colRange: Range<Int>?) -> Bool {
		let rows: Range<Int> = rowRange != nil ? rowRange! : rowIndices
		let cols: Range<Int> = colRange != nil ? colRange! : colIndices
		return rows.startIndex >= 0 && rows.endIndex <= self.rows && cols.startIndex >= 0 && cols.endIndex <= self.columns
	}
	
	public subscript(row: Int,column: Int) -> T {
		get {
			assert(indexIsValidForRow(row, column: column), "Index out of range")
			return array[row*columns + column]
		}
		set {
			assert(indexIsValidForRow(row, column: column), "Index out of range")
			array[row*columns + column] = newValue
		}
	}
}

public extension Array2D {
	var colIndices: Range<Int> {
		return 0..<self.columns
	}
	var rowIndices: Range<Int> {
		return 0..<self.rows
	}
	/// get elements in a row
	public subscript(row: Int,range: Range<Int>?) -> [T] {
		let r: Range<Int> = range != nil ? range! : colIndices
		guard indexIsValid(row, range: r) else {
			fatalError("Index out of range")
		}
		var array = [T]()
		r.forEach{ array.append(self[row, $0]) }
		return array
	}
	/// get elements in a column
	public subscript(range: Range<Int>?, column: Int) -> [T] {
		let r: Range<Int> = range != nil ? range! : rowIndices
		guard indexIsValid(r, column: column) else {
			fatalError("Index out of range")
		}
		var array = [T]()
		r.forEach{ array.append(self[$0, column]) }
		return array
	}
}


extension Array2D: CustomStringConvertible {
	public var description: String {
		var matrixStyle_description = ""
		for row in rowIndices {
			matrixStyle_description += "\n" + self[row, nil].description
		}
		return "Array2D: \(rows) x \(columns)\t" + array.description + matrixStyle_description
	}
}

extension Array2D {
	func getIndices(row row: Int) -> [Int]  {
		return _getIndices(row...row, colRange: nil)
	}
	func getIndices(column col: Int) -> [Int]  {
		return _getIndices(nil, colRange: col...col)
	}
	func getIndices(row row: Int, col: Int) -> [Int]  {
		return _getIndices(row...row, colRange: col...col)
	}
	private func _getIndices(rowRange: Range<Int>? ,colRange: Range<Int>?) -> [Int] {
		guard _indexIsValid(rowRange, colRange: colRange) else { fatalError("Index out of range") }
		let rows: Range<Int> = rowRange != nil ? rowRange! : rowIndices
		let cols: Range<Int> = colRange != nil ? colRange! : colIndices
		var array = [Int]()
		for row in rows {
			for col in cols {
				array.append(row * columns + col)
			}
		}
		return array
	}
}
```

`Array2D`的關聯型別為泛型(generic)，元素型別可為任何型別物件，建立一個`Array2D`物件很容易：

```swift
var cookies = Array2D(rows: 9, columns: 7, initialValue: 0)
```

其中實作了`subscript`函式，因此可以下角標方式來存取陣列中特定位置儲存資料：

```swift
let myCookie = cookies[row, column]
cookies[row, column] = newCookie
```

在`Array2D`內部使用的是一維的陣列來儲存資料，透過索引值轉換，物件在該一維陣列中的索引值為`(row x numberOfColumns) + column`，實際使用上，只要使用"column"與"row"，這是使用此列別的一個優勢。

# 測試
```swift
var a = Array2D(rows: 3, columns: 5, initialValue: 0)
for i in a.rowIndices {
	for j in a.colIndices {
		a[i,j] = i*a.columns + j
	}
}

print(a)

let colIndices = a.colIndices
let rowIndices = a.rowIndices
a[0, colIndices]
a[rowIndices,1]
a[1, 2...4]
a[0..<3, 2]
a[nil, 3]
a[2, nil]

a.getIndices(row: 2)
a.getIndices(column: 4)
```