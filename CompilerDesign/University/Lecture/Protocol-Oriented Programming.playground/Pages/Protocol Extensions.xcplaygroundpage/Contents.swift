/*:
 ### [POP Approach](@previous)
 
 ---
 
 # Protocol Extensions:
 */
protocol Vehicle {
    var speed: Double { get }
    func drive()
}
/*:
 One of the most powerful features of Swift is **protocol extensions**. They allow you to provide *default implementations* for any method or property defined in a protocol.
 
 This feature can dramatically reduce code duplication.
 */
extension Vehicle {
    func drive() {
        print("Driving at \(speed) mph")
    }
}
//: Protocols can also composite from other protocols, allowing you to build complex requirements incrementally.
protocol Flying {
    func fly()
}

protocol FlyingVehicle: Vehicle, Flying {}

struct Airplane: FlyingVehicle {
    var speed: Double
    
    func fly() {
        print("Flying at \(speed) mph")
    }
}

