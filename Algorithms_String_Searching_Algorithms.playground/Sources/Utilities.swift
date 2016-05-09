import UIKit

public extension String {
	subscript(idx: Int) -> Character {
		get {
			let strIdx = self.startIndex.advancedBy(idx, limit: endIndex)
			guard strIdx != endIndex else { fatalError("String index out of bounds") }
			return self[strIdx]
		}
		set {
			self.removeAtIndex(startIndex.advancedBy(idx, limit: endIndex))
			self.insert(newValue, atIndex: startIndex.advancedBy(idx, limit: endIndex))
		}
	}
	subscript(range: Range<Int>) -> String {
		get {
			let strRange = self.startIndex.advancedBy(range.startIndex)..<self.startIndex.advancedBy(range.endIndex)
			return self[strRange]
		}
		set {
			let strRange = self.startIndex.advancedBy(range.startIndex)..<self.startIndex.advancedBy(range.endIndex)
			self.removeRange(strRange)
			self.insertContentsOf(newValue.characters, at: strRange.startIndex)
		}
	}
	public func reverse() -> String {
		let array = self.characters
		var reverse = String.CharacterView()
		for i in 0..<array.count {
			let index = -i - 1
			reverse.append(array[array.endIndex.advancedBy(index)])
		}
		return String(reverse)
	}
	func visualizeView() -> UIView {
		return visualize(self)
	}
	func visualizeView(idx: Int) -> UIView {
		let index = self.startIndex.advancedBy(idx, limit: endIndex)
		return visualize(self, index: index)
	}
	func visualizeView(range: Range<Int>) -> UIView {
		let strRange = self.startIndex.advancedBy(range.startIndex)..<self.startIndex.advancedBy(range.endIndex)
		return visualize(self, range: strRange)
	}
}

private enum Theme {
	enum Color {
		static let border = UIColor(red: 184/255.0, green: 201/255.0, blue: 238/255.0, alpha: 1)
		static let shade = UIColor(red: 227/255.0, green: 234/255.0, blue: 249/255.0, alpha: 1)
		static let highlight = UIColor(red: 14/255.0, green: 114/255.0, blue: 199/255.0, alpha: 1)
	}
	enum Font {
		static let codeVoice = UIFont(name: "Menlo-Regular", size: 14)!
	}
}

private struct StyledString {
	let string: String
	let shaded: Bool
	let highlighted: Bool
	let bordered: Bool
}

private extension UILabel {
	convenience init(styledString: StyledString) {
		self.init()
		text = styledString.string
		textAlignment = .Center
		font = Theme.Font.codeVoice
		textColor = styledString.highlighted ? Theme.Color.highlight : UIColor.blackColor()
		backgroundColor = styledString.shaded ? Theme.Color.shade : UIColor.whiteColor()
		if (styledString.bordered) {
			layer.borderColor = Theme.Color.border.CGColor
			layer.borderWidth = 1.0
		}
	}
}

public func visualize(str: String) -> UIView {
	return _visualize(str, range: nil)
}

public func visualize(str: String, index: String.Index) -> UIView {
	return _visualize(str, range: index...index)
}

public func visualize(str: String, range: Range<String.Index>) -> UIView {
	return _visualize(str, range: range)
}

private func _visualize(str: String, range: Range<String.Index>?) -> UIView {
	let stringIndices = str.characters.indices
	
	let styledCharacters = zip(stringIndices, str.characters).map { (characterIndex, char) -> StyledString in
		let shaded: Bool
		if let range = range where range.contains(characterIndex) {
			shaded = true
		} else {
			shaded = false
		}
		return StyledString(string: String(char), shaded: shaded, highlighted: false, bordered: true)
	}
	
	let characterLabels = styledCharacters.map { UILabel(styledString: $0) }
	
	let styledIndexes = (0..<stringIndices.count).map { index -> StyledString in
		let characterIndex = str.startIndex.advancedBy(index)
		
		let highlighted: Bool
		if let range = range where range.startIndex == characterIndex || range.last == characterIndex {
			highlighted = true
		} else {
			highlighted = false
		}
		
		return StyledString(string: String(index), shaded: false, highlighted: highlighted, bordered: false)
	}
	
	let indexLabels = styledIndexes.map { UILabel(styledString: $0) }
	
	let charStacks: [UIStackView] = zip(characterLabels, indexLabels).map { (charLabel, indexLabel) in
		let stack = UIStackView()
		stack.axis = .Vertical
		stack.distribution = .FillEqually
		stack.addArrangedSubview(indexLabel)
		stack.addArrangedSubview(charLabel)
		return stack
	}
	
	let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 25 * charStacks.count, height: 50))
	stackView.distribution = .FillEqually
	charStacks.forEach(stackView.addArrangedSubview)
	
	return stackView
}

public let messageDates = [
	NSDate().dateByAddingTimeInterval(-2000),
	NSDate().dateByAddingTimeInterval(-1500),
	NSDate().dateByAddingTimeInterval(-500),
	NSDate()
]

private struct StyledArray {
	typealias T = Any
	let array: Array<T>
	let shaded: Bool
	let highlighted: Bool
	let bordered: Bool
}

private extension UILabel {
	convenience init(styledArray: StyledArray) {
		self.init()
		text = styledArray.array.count == 1 ? "\(styledArray.array[0])" : styledArray.array.description
		textAlignment = .Center
		font = Theme.Font.codeVoice
		textColor = styledArray.highlighted ? Theme.Color.highlight : UIColor.blackColor()
		backgroundColor = styledArray.shaded ? Theme.Color.shade : UIColor.whiteColor()
		if (styledArray.bordered) {
			layer.borderColor = Theme.Color.border.CGColor
			layer.borderWidth = 1.0
		}
	}
}

private extension Array{
	func indexIsValid(range: Range<Int>) -> Bool {
		return range.startIndex >= startIndex && range.startIndex <= endIndex && range.endIndex >= startIndex && range.endIndex <= endIndex
	}
}

public func visualize<T>(arr: Array<T>) -> UIView {
	return _visualize(arr, range: nil)
}

public func visualize<T>(arr: Array<T>, index: Int) -> UIView {
	guard arr.indexIsValid(index...index) else { fatalError("Index out of range") }
	return _visualize(arr, range: index...index)
}

public func visualize<T>(arr: Array<T>, range: Range<Int>) -> UIView {
	guard arr.indexIsValid(range) else { fatalError("Index out of range") }
	return _visualize(arr, range: range)
}


private func _visualize<T>(arr: Array<T>, range: Range<Int>?) -> UIView {
	let arrayIndices = arr.indices
	
	let styledElements = zip(arrayIndices, arr).map { (elementIndex, element) -> StyledArray in
		let shaded: Bool
		if let range = range where range.contains(elementIndex) {
			shaded = true
		} else {
			shaded = false
		}
		return StyledArray(array: Array(arrayLiteral: element), shaded: shaded, highlighted: false, bordered: true)
	}
	
	let elementLabels = styledElements.map { UILabel(styledArray: $0) }
	
	let styledIndexes = (0..<arrayIndices.count).map { index -> StyledArray in
		let highlighted: Bool
		if let range = range where range.startIndex == index || range.last == index {
			highlighted = true
		} else {
			highlighted = false
		}
		
		return StyledArray(array: Array(arrayLiteral: index), shaded: false, highlighted: highlighted, bordered: false)
	}
	
	let indexLabels = styledIndexes.map { UILabel(styledArray: $0) }
	
	let elementStacks: [UIStackView] = zip(elementLabels, indexLabels).map { (elementLabel, indexLabel) in
		let stack = UIStackView()
		stack.axis = .Vertical
		stack.distribution = .FillEqually
		stack.addArrangedSubview(indexLabel)
		stack.addArrangedSubview(elementLabel)
		return stack
	}
	
	let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 125 * elementStacks.count, height: 50))
	stackView.distribution = .FillEqually
	elementStacks.forEach(stackView.addArrangedSubview)
	
	return stackView
}

public protocol Visualization {
	associatedtype Index
	func visualizeView() -> UIView
}
