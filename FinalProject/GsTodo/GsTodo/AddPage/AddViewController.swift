//
//  AddViewController.swift
//  GsTodo
//
//  Created by yamamototatsuya on 2020/01/15.
//  Copyright © 2020 yamamototatsuya. All rights reserved.
//

import UIKit
import PKHUD
import FirebaseFirestore

class AddViewController: UIViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!

    // 判定に使用するプロパティ
    var selectIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMemoTextView()
        setupNavigationBar()
        
        // Editかどうかの判定
        if let index = selectIndex {
            title = "編集"
            titleTextField.text = TaskCollection.shared.getTask(at: index).title
            memoTextView.text = TaskCollection.shared.getTask(at: index).memo
        }
    }
    
    // MARK: Setup
    fileprivate func setupMemoTextView() {
        memoTextView.layer.borderWidth = 1
        memoTextView.layer.borderColor = UIColor.lightGray.cgColor
        memoTextView.layer.cornerRadius = 3
    }
    
    fileprivate func setupNavigationBar() {
        title = "Add"
        let rightButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(tapSaveButton))
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    
    // MARK: Other Method
    @objc func tapSaveButton() {
        print("Saveボタンを押したよ！")
        
        guard let title = titleTextField.text else {
            return
        }
        
        if title.isEmpty {
            print(title, "👿titleが空っぽだぞ〜")
            
            HUD.flash(.labeledError(title: nil, subtitle: "👿 タイトルが入力されていません！！！"), delay: 1)
            // showAlert("👿 タイトルが入力されていません！！！")
            return // return を実行すると、このメソッドの処理がここで終了する。
        }
        
        // ここで Edit か Add　かを判定している
        if let index = selectIndex {
            // Edit
            let editTask = TaskCollection.shared.getTask(at: index)
            editTask.title = title
            editTask.memo = memoTextView.text
            editTask.updatedAt = Timestamp()
            TaskCollection.shared.editTask(task: editTask, index: index)
        } else {
            // Add
            let task = TaskCollection.shared.createTask()
            task.title = title
            task.memo = memoTextView.text
            TaskCollection.shared.addTask(task)
        }
        
        HUD.flash(.success, delay: 0.3)
        // 前の画面に戻る
        navigationController?.popViewController(animated: true)
    }

    @IBAction func tapImageView(_ sender: Any) {
        print("🌞 imageView をタップしたよ")
        // アクションシートを表示する
        let alertSheet = UIAlertController(title: nil, message: "選択してください", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { action in
            print("カメラが選択されました")
            self.presentPicker(sourceType: .camera)
        }
        let albumAction = UIAlertAction(title: "アルバムから選択", style: .default) { action in
            print("アルバムが選択されました")
            self.presentPicker(sourceType: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { action in
            print("キャンセルが選択されました")
        }
        alertSheet.addAction(cameraAction)
        alertSheet.addAction(albumAction)
        alertSheet.addAction(cancelAction)

        present(alertSheet, animated: true)
    }

}

extension AddViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func presentPicker(sourceType: UIImagePickerController.SourceType) {
        print("撮影画面かアルバム画面を表示するよ！")
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            present(picker, animated: true)
        } else {
            print("SourceType が見つかりませんでした。。。")
        }
    }

    // 撮影もしくは画像を選択したら呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("撮影もしくは画像を選択したよ！")

        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        // 表示した画面を閉じる処理
        picker.dismiss(animated: true, completion: nil)
    }
}
