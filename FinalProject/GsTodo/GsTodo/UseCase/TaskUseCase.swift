//
//  TaskUseCase.swift
//  GsTodo
//
//  Created by Tatsuya Yamamoto on 2020/02/07.
//  Copyright © 2020 yamamototatsuya. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage

class TaskUseCase {
    // Firestore へのアクセスに使う
    let db = Firestore.firestore()
    // Storage へのアクセスに使う
    let storage = Storage.storage()

    //MARK: Firestore
    private func getCollectionRef () -> CollectionReference {
        guard let uid = Auth.auth().currentUser?.uid else {
            fatalError ("Uidを取得出来ませんでした。") //本番環境では使わない
        }
        return self.db.collection("users").document(uid).collection("tasks")
    }
    
    func createTaskId() -> String {
        let id = self.getCollectionRef().document().documentID
        print("taskIdは",id)
        return id
    }
    
    func addTask(_ task: Task){
        let documentRef = getCollectionRef().document(task.id)
        let encodeTask = try! Firestore.Encoder().encode(task)
        documentRef.setData(encodeTask) { (err) in
            if let _err = err {
                print("データ追加失敗",_err)
            } else {
                print("データ追加成功")
            }
        }
    }
    
    func editTask(_ task: Task){
        let documentRef = getCollectionRef().document(task.id)
        let encodeTask = try! Firestore.Encoder().encode(task)
        documentRef.updateData(encodeTask) { (err) in
            if let _err = err {
                print("データ修正失敗",_err)
            } else {
                print("データ修正成功")
            }
        }
    }
    
    func removeTask(_ task: Task){
        let documentRef = getCollectionRef().document(task.id)
        documentRef.delete { (err) in
            if let _err = err {
                print("データ取得",_err)
            } else {
                self.deleteImage(imageName: task.imageName)
                print("データ削除成功")
            }
        }
    }
    
    func fetchTaskDocuments(callback: @escaping ([Task]?) -> Void){
        let collectionRef = getCollectionRef()
        collectionRef.getDocuments(source: .default) { (snapshot, err) in
            guard err == nil, let snapshot = snapshot,!snapshot.isEmpty else {
                print("データ取得失敗",err.debugDescription)
                callback(nil)
                return
            }
            
            print("データ取得成功")
            let tasks = snapshot.documents.compactMap { snapshot in
                return try? Firestore.Decoder().decode(Task.self, from: snapshot.data())
            }
            callback(tasks)
        }
    }

    //MARK: Storage

    func getStorageReference() -> StorageReference? {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        return storage.reference().child("users").child(uid)
    }

    func getImageRef(imageName: String) -> StorageReference? {
        return getStorageReference()?.child(imageName)
    }

    func saveImage(image: UIImage?, callback: @escaping ((String?) -> Void)) {
        // オプショナルを外したり、 iamgeData を作成
        guard let image = image,
            let imageData = image.jpegData(compressionQuality: 0.5),
            let imageRef = getStorageReference() else {
            callback(nil)
            return
        }

        // 保存に必要なものを作成
        let imageName = NSUUID().uuidString
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"

        // 保存する
        let ref = imageRef.child(imageName)
        ref.putData(imageData, metadata: metaData) { (metaData, error) in
            guard let _ = metaData else {
                print("画像の保存に失敗しました。。。😭")
                callback(nil)
                return
            }
            print("画像の保存が成功した！！！！！！")
            callback(imageName)
        }
    }

    func deleteImage(imageName: String?) {
        guard let imageName = imageName, let ref = getImageRef(imageName: imageName) else { return }
        ref.delete { (error) in
            if let error = error {
                print("画像の削除に失敗しました。。。😭", error)
            } else {
                print("画像の削除が成功した！！！！！！")
            }
        }
    }

}
