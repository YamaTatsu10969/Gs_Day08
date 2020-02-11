//
//  Task.swift
//  GsTodo
//
//  Created by yamamototatsuya on 2020/01/15.
//  Copyright © 2020 yamamototatsuya. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
// Task のクラス。
// プロパティに title と memo を持っている
class Task: Codable {
    var id: String
    var title: String = ""
    var memo: String = ""
    var imageName: String?
    var createdAt: Timestamp
    var updatedAt: Timestamp
    
    // init とは、Task を作るときに呼ばれるメソッド。(イニシャライザという)
    // 使い方： let task = Task(title: "プログラミング")
  init(id: String) {
    self.id = id
    self.createdAt = Timestamp() // Timestamp は、 Firestore で使用できる便利な時間の方
    self.updatedAt = Timestamp()
  }
}
