import Combine
import Foundation

public func printExampleHeader(_ description: String) {
    print("\n--- \(description) example ---")
}

public func example(_ description: String, action: () -> Void) {
    printExampleHeader(description)
    action()
}


//example("empty") {
//    Publishers.Empty<Any, Error>().sink(receiveCompletion: { completion in
//        print("completed")
//    }) { (_) in
//
//    }
//    .cancel()
//}

example("just") {
    Just("🍎").print("Just").sink(receiveCompletion: { completion in
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
}

example("sequence2") {
    ["🐶", "🐱", "🐭", "🐹"].publisher.sink(receiveCompletion: { completion in 
        print("completed")
    }) { value in
        print("\(value)")
    }
}

example("key-path") {

    class Student: NSObject  {
        var id: Int
        @objc dynamic var name: String

        init(_ id: Int, _ name: String) {
            self.id = id
            self.name = name
        }
    }

    let student = Student(1, "Jack")

    let stream = student.publisher(for: \.name).sink { value in
        print("\(value)")
    }

    student.name = "Pony"
    stream.cancel()
    student.name = "Robin"
}

example("PassthroughSubject") {
    let subject = PassthroughSubject<String, Never>()
    subject.print("PassthroughSubject01").sink { value in
        print("01: \(value)")
    }
    subject.send("🐶")
    subject.send("🐱")
    
    subject.print("PassthroughSubject02").sink { value in
        print("02: \(value)")
    }
    subject.send("🅰️")
    subject.send("🅱️")
}
