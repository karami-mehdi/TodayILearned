/*:
 ### [Design Pattern](@previous)
 
 ---
 
 # Delegate Pattern:
 */
class PostDriver {
    protocol Delegate: AnyObject {
        func didReceivePockets()
        func didFail()
    }
    
    weak var delegate: Delegate?
    
    func getPockets() {
        if Bool.random() {
            print("Getting Pockets Successful 💌")
            delegate?.didReceivePockets()
        } else {
            print("Getting Pockets Failed 😰")
            delegate?.didFail()
        }
    }
}

class User: PostDriver.Delegate {
    let postDriver = PostDriver()
    
    func requestPockets() {
        postDriver.delegate = self
        postDriver.getPockets()
    }
    
    func didReceivePockets() {
        print("Driver received my pockets 🥳")
    }
    
    func didFail() {
        print("I won't get my pockets 😡")
    }
}

let user = User()
//user.requestPockets()

/*:
 ### Benefits of POP
 
 * **Protocol Definition**
    * We define a protocol to outline the methods that the delegate must implement.
 
 * **Weak Delegate Property**
    * We use a weak reference for the delegate property to avoid *retain cycles*, ensuring proper *memory management*.
 
 * **Protocol Conformance**
    * The User class conforms to the `PostDriver.Delegate` protocol and provides concrete implementations for the protocol's methods.
 
 * **Loose Coupling**
    * The PostDriver class does not need to know about the specifics of the User class, promoting loose coupling and better separation of concerns.
 */
