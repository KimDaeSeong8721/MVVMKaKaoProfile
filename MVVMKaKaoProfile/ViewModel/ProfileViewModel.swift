//
//  ProfileViewModel.swift
//  MVVMKaKaoProfile
//
//  Created by DaeSeong on 2022/10/01.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class ProfileViewModel: ViewModelType {

    var disposeBag: DisposeBag = DisposeBag()

    var info : Information
    let infoObservable: BehaviorRelay<Information>

    struct Input {
        let dismissTapped: ControlEvent<Void>
        let secondButtonTapped: ControlEvent<UITapGestureRecognizer>
    }

    struct Output {
        let dismissTapped: Observable<Void>
        let secondButtonTapped: Observable<Void>
        let information: Observable<Information>
    }
    
    init(info: Information) {
        self.info = info
        self.infoObservable = BehaviorRelay(value: self.info)
    }

    func transform(input: Input) -> Output {

        let dismissObservable = PublishRelay<Void>()
        let secondObservable = PublishRelay<Void>()

        input.dismissTapped
            .bind(to: dismissObservable)
            .disposed(by: disposeBag)

        input.secondButtonTapped
            .map{ _ in}
            .bind(to: secondObservable)
            .disposed(by: disposeBag)

        return Output(dismissTapped: dismissObservable.asObservable()
                      ,secondButtonTapped: secondObservable.asObservable()
                      ,information: infoObservable.asObservable())
    }

    func changeSubTitle(subTitle: String?) {
        let newInfo = Information(imageName: self.info.imageName
                                  , name: self.info.name
                                  , subTitle: subTitle ?? "")
        infoObservable.accept(newInfo)
    }
    
    
}
