import UIKit

//KVO - Key-Value observing

//KVO is apart of thr observer pattern
//NotificationCenter is also an abserver pattern
// NotificationCenter.postNotification(

// KVO is a one -to many pattern relationship as opposed to delegation which is one-to one


// in the delegation pattern

//class ViewController: UIViewController{}
// eg. tableView.datsource = self

// KVO is Objective -C runtime API
// Along with KVO being on objective-c runtime some essentials are required
// 1. The object being obsewrved  needs to be a class
//2. The class needs to i nherit from NSObject, NSObject is the top abstract class in Objective-c
// 3. Any property being marked for observation needs to be prefixed with @objc dynamic. Dynamic means that the property is being dynamically dispatched(at runtime the compiler verifies the underlying property)
// In swift types are statically dispatched which means they are checked at compile time vs Objective-C which is dynamically dispatched and checked at runtime

// static vs dynamic dispatch
// https://medium.com/flawless-app-stories/static-vs-dynamic-dispatch-in-swift-a-decisive-choice-cece1e872d

// Dog class (class being observed)- will have a property to be observed
@objc class Dog: NSObject { // Dog is KVO complient because @objc and dynamic
    var name: String
    @objc dynamic var age: Int // age is observable property
    
    init(name:String, age: Int) {
        self.name = name
        self.age = age
    }
}

// Observer class one
class DogWalker {
    let dog: Dog
    var birthdayObservation: NSKeyValueObservation? // a handle for the property being observed i.e age property on Dog
    // similar to listener in Firebase
    init(dog: Dog) {
        self.dog = dog
        configureBirthdayObservation()
    }
    private func configureBirthdayObservation() {
        //\.age is keyPath syntax for KVO
        birthdayObservation = dog.observe(\.age, options: [.old, .new], changeHandler: { (dog, change) in
            // update UI accordingly if in a viewController class
            guard let age = change.newValue else { return }
            print("Hey \(dog.name), happy \(age) birthday from the dog wallker")
            print("walker: oldvalue is \(change.oldValue ?? 0)")
            print("walker: newvalue is \(change.newValue ?? 0) ")
        })
    }
}

// Observer class two
class DogGroomer {
    let dog: Dog
    var birthdayObservation: NSKeyValueObservation?
    init(dog: Dog) {
        self.dog = dog
        configureBirthdayObservation()
    }
    private func configureBirthdayObservation() {
        birthdayObservation = dog.observe(\.age, options: [.old, .new], changeHandler: { (dog, change) in
            // uinwrap the newValue propeerty on change as its optional
            guard let age = change.newValue else { return}
            print("Hey \(dog.name), happy \(age) birthday from the dog groomer")
            print("groomer oldvalue: \(change.oldValue ?? 0)")
            print("groomer newvalue: \(change.newValue ?? 0)")
        })
    }
}
// test out KVO observing on the .age property of Dog
//both classes Dogwalker and doggroomer should get .age changes

let snoopy = Dog(name: "Snoopy", age: 5)
// both have reference to snoopy
let dogWalker = DogWalker(dog: snoopy)
let dogGroomer = DogGroomer(dog: snoopy)
snoopy.age += 1 // increment age by 1

