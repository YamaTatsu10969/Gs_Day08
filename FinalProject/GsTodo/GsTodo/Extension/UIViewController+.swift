//
//  UIViewController+.swift
//  GsTodo
//
//  Created by yamamototatsuya on 2020/01/28.
//  Copyright © 2020 yamamototatsuya. All rights reserved.
//

import UIKit

// UIViewController の機能を拡張しているイメージ
// extension は拡張という意味
extension UIViewController {
    // OKを選択させるエラーアラートを表示する
    func showErrorAlert(text: String){
        let alertController = UIAlertController(title: "エラー", message: text , preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
