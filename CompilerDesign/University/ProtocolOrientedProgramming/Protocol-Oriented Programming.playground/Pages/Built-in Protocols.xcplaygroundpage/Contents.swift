/*:
 ### [Protocol Extensions](@previous)
 
 ---
 
 # Built-in Protocols:
 */
public struct Stack<Element> {
    
    private var storage: [Element]
    
    init(_ elements: [Element]) {
        storage = elements
    }
    
    mutating func push(_ element: Element) {
        storage.append(element)
    }
    
    mutating func pop() -> Element? {
        storage.popLast()
    }
}

var intStack = Stack<Int>([])
intStack.push(1)
intStack.push(2)
intStack.push(3)
intStack.push(4)

print(intStack)
/*:
 # Custom String Convertible Protocol
 This protocol provides a better debug description for our Stack.
 */
extension Stack: CustomStringConvertible {

    public var description: String {
    """
    ----top----
    \(storage.map { "\($0)" }.reversed().joined(separator: "\n"))
    -----------
    """
  }
}

print(intStack)

if let poppedElement = intStack.pop() {
    print("Popped: \(poppedElement)")
}

print(intStack)

let stringArray = ["A", "B", "C", "D"]
var stringStack = Stack(stringArray)
/*:
 # Expressible By Array Literal
 A type that can be initialized using an array literal.
 */
extension Stack: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: Element...) {
    storage = elements
  }
}

var doubleStack: Stack = [1.0, 2.0, 3.0, 4.0]
print(doubleStack)

var anotherStringStack: Stack = ["a", "b", "c", "d"]
print(anotherStringStack)
/*:
 ---
 
 # [Design Patterns](@next)
 */
