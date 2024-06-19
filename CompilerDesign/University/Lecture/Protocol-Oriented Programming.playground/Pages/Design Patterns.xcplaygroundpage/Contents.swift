/*:
 ### [Protocol Extensions](@previous)

 ---
 
 # Design Pattern:
*/
class PostDriver {
    func getPockets() {
        if Bool.random() {
            print("Getting Pockets Successful 💌")
        } else {
            print("Getting Pockets Failed 😰")
        }
    }
}

class User {
    let postDriver = PostDriver()
    
    func requestPockets() {
        postDriver.getPockets()
    }
}

let user = User()
user.requestPockets()
/*:
 ---
 
 # [Delegate Pattern](@next)
 */
