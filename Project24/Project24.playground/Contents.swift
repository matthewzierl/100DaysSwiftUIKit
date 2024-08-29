import UIKit

let string = "This is a test string"

let attributedString = NSMutableAttributedString(string: string)
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))


extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        } else {
            return "\(self)\(prefix)"
        }
    }
    
    func isNumeric() -> Bool {
        return Double(self) != nil
    }
    
    func splitByLines() -> [String] {
        if self.isEmpty { return [""] }
        var currentIndex = self.startIndex
        var arr = [String]()
        
        while let newLineIndex = self[currentIndex...].firstIndex(of: "\n") {
            arr.append(String(self[currentIndex..<newLineIndex]))
            currentIndex = self.index(after: newLineIndex)
        }
        if currentIndex < self.endIndex {
            arr.append(String(self[currentIndex...]))
        }
        return arr
    }
}

print(string.withPrefix("This"))
print(string.isNumeric())

let test = "this\nis\na\ntest"
var arr = test.splitByLines()
print(test)
for sub in arr {
    print(sub)
}
