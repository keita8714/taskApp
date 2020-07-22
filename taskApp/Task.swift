//
//  Task.swift
//  taskApp
//
//  Created by Keita Munekawa on 2020/07/04.
//  Copyright © 2020 KM. All rights reserved.
//

import RealmSwift

class Task: Object {
    
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0

    // タイトル
    @objc dynamic var title = ""

    // 内容
    @objc dynamic var contents = ""

    // 日時
    @objc dynamic var date = Date()
    
   @objc dynamic var category = String()
    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
