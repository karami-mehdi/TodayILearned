/*: 
 
 ### [Introduction](@previous)

 ---
 
 # OOP Approach:
*/
import Foundation

class Shape {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

class TwoDimensionalShape: Shape {
    func area() -> Double {
        fatalError("Must override")
    }
}

class ThreeDimensionalShape: Shape {
    func area() -> Double {
        fatalError("Must override")
    }
    
    func volume() -> Double {
        fatalError("Must override")
    }
}

class Rectangle: TwoDimensionalShape {
    var width: Double
    var height: Double
    
    init(name: String, width: Double, height: Double) {
        self.width = width
        self.height = height
        super.init(name: name)
    }
    
    override func area() -> Double {
        width * height
    }
}

class Circle: TwoDimensionalShape {
    var radius: Double
    
    init(name: String, radius: Double) {
        self.radius = radius
        super.init(name: name)
    }
    
    override func area() -> Double {
        .pi * radius * radius
    }
}

class Sphere: ThreeDimensionalShape {
    var radius: Double
    
    init(name: String, radius: Double) {
        self.radius = radius
        super.init(name: name)
    }
    
    override func area() -> Double {
        4 * .pi * pow(radius, 2)
    }
    
    override func volume() -> Double {
        (4/3) * .pi * pow(radius, 3)
    }
}
/*:
 ---
 
 # [POP Approach](@next)
 */
