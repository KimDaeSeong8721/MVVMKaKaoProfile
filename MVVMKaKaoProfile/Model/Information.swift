//
//  Information.swift
//  MVVMKaKaoProfile
//
//  Created by DaeSeong on 2022/09/30.
//

import UIKit


struct Information {

    var imageName: String
    var name: String
    var subTitle: String

    func makeImage() -> UIImage? {
        return UIImage(named: imageName)
    }

}
