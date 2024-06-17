/*:
 ### [OOP Approach](@previous)
 
 ---
 
 # POP Approach:
*/
import Foundation

protocol Shape {
    var name: String { get }
}

protocol AreaCalculable {
    func area() -> Double
}

protocol VolumeCalculable {
    func volume() -> Double
}

struct Rectangle: Shape, AreaCalculable {
    var name: String
    var width: Double
    var height: Double
    
    func area() -> Double {
        width * height
    }
}

struct Circle: Shape, AreaCalculable {
    var name: String
    var radius: Double
    
    func area() -> Double {
        .pi * radius * radius
    }
}

struct Sphere: Shape, AreaCalculable, VolumeCalculable {
    var name: String
    var radius: Double
    
    func area() -> Double {
        4 * .pi * pow(radius, 2)
    }
    
    func volume() -> Double {
        (4/3) * .pi * pow(radius, 3)
    }
}
/*:
 * Modularity:
    * Each protocol defines a specific capability (i.e., AreaCalculable, VolumeCalculable), making the code more modular and easier to extend.
 * Decoupling:
    * The behavior is decoupled from the types, allowing different types to adopt behaviors without requiring a deep inheritance hierarchy.
 * Flexibility:
    * Adding new shapes or behaviors
 */

/*:
 ---
 
 # [Protocol Extensions](@next)
 */
