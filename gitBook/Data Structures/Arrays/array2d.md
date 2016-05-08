# 二維陣列（Array2D）

使用C語言或Objective-C語言可使用下式來定義一二維陣列，

	int cookies[9][7];
	
來建立一9x7的二維陣列。可利用下式來存取第三行（row 3）第六列（column 6）:

	myCookie = cookies[3][6];
	
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

The downside of using multi-dimensional arrays in this fashion -- actually, multiple nested arrays -- is that it's easy to lose track of what dimension represents what.

So instead let's create our own type that acts like a 2-D array and that is more convenient to use. Here it is, short and sweet:

```swift
public struct Array2D<T> {
  public let columns: Int
  public let rows: Int
  private var array: [T]

  public init(columns: Int, rows: Int, initialValue: T) {
    self.columns = columns
    self.rows = rows
    array = .init(count: rows*columns, repeatedValue: initialValue)
  }

  public subscript(column: Int, row: Int) -> T {
    get {
      return array[row*columns + column]
    }
    set {
      array[row*columns + column] = newValue
    }
  }
}
```

`Array2D` is a generic type, so it can hold any kind of object, not just numbers.

To create an instance of `Array2D` you'd write:

```swift
var cookies = Array2D(columns: 9, rows: 7, initialValue: 0)
```

Thanks to the `subscript` function, you can do the following to retrieve an object from the array:

```swift
let myCookie = cookies[column, row]
```

Or change it:

```swift
cookies[column, row] = newCookie
```

Internally, `Array2D` uses a single one-dimensional array to store the data. The index of an object in that array is given by `(row x numberOfColumns) + column`. But as a user of `Array2D` you don't have to worry about that; you only have to think in terms of "column" and "row", and let `Array2D` figure out the details for you. That's the advantage of wrapping primitive types into a wrapper class or struct.

And that's all there is to it.

*Written for Swift Algorithm Club by Matthijs Hollemans*
