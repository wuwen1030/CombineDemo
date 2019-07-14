import Combine
import Foundation

public func printExampleHeader(_ description: String) {
    print("\n--- \(description) example ---")
}

public func example(_ description: String, action: () -> Void) {
    printExampleHeader(description)
    action()
}


example("empty") {
    Publishers.Empty<Any, Error>().sink(receiveCompletion: { completion in
        print("completed")
    }) { (_) in
        
    }
    .cancel()
}

example("just") {
    Publishers.Just("🍎").sink(receiveCompletion: { completion in
        print("completed")
    }) { value in
        print("\(value)")
    }
    .cancel()
}

example("sequence1") {
    Publishers.Sequence<[String], Never>(sequence: ["🐶", "🐱", "🐭", "🐹"]).sink(receiveCompletion: { completion in
        print("completed")
    }) { value in
        print("\(value)")
    }
    .cancel()
}

example("sequence2") {
    ["🐶", "🐱", "🐭", "🐹"].publisher().sink(receiveCompletion: { completion in
        print("completed")
    }) { value in
        print("\(value)")
    }
    .cancel()
}

example("key-path") {
    
    // TODO: key - value
    class Student: NSObject  {
        var id: Int
        var name: String

        init(_ id: Int, _ name: String) {
            self.id = id
            self.name = name
        }
    }

    var student = Student(1, "Jack")
    
    student.name = "Pony"
}
