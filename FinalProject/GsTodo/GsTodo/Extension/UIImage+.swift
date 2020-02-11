//
//  UIImage+.swift
//  GsTodo
//
//  Created by Tatsuya Yamamoto on 2020/02/11.
//  Copyright © 2020 yamamototatsuya. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false , scale)
        defer { UIGraphicsEndImageContext()}
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
