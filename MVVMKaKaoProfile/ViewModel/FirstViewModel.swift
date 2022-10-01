//
//  FirstViewModel.swift
//  MVVMKaKaoProfile
//
//  Created by DaeSeong on 2022/09/30.
//

import Foundation
import RxSwift
import RxCocoa

class FirstViewModel: ViewModelType {

    var disposeBag = DisposeBag()

    struct Input {
        let tableItemsSelected: ControlEvent<IndexPath>
        let tableModelSelected: ControlEvent<Information>
    }

    struct Output {
        let InfoList: Observable<[Information]>
        let tappedProfile: Observable<(IndexPath,Information)>
    }

    func transform(input: Input) -> Output {

        let infoList = Observable.of(DummyData.profileList)

        let selected = Observable.zip(input.tableItemsSelected, input.tableModelSelected)
            .map { indexPath, info in
                (indexPath, info)
            }

        return Output(InfoList: infoList
                      ,tappedProfile: selected)
    }
}

extension FirstViewModel {
    
}
