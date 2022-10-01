import UIKit
import RxSwift
import RxCocoa



let c = BehaviorSubject(value: 0)

let b = Observable<Int>.create { observer in
    observer.onNext(Int.random(in: 0..<100))
    return Disposables.create()
}
let d = BehaviorSubject(value: Int.random(in: 0..<100))

d
    .asObservable()
    .asDriver(onErrorJustReturn: 0)
    .drive {
        print($0)
    }



