import Foundation
/// A collection type that supports 2 dimensional subscription function.
public struct Array2D<T> {
	public let columns: Int
	public let rows: Int
	public var array: [T]
	
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