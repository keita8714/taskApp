//
//  InputViewController.swift
//  taskApp
//
//  Created by Keita Munekawa on 2020/07/04.
//  Copyright © 2020 KM. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    
    @IBOutlet var titleTextField: UITextField!
    
    @IBOutlet var contentsTextView: UITextView!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var categoryPickerview: UIPickerView!
    
    @IBOutlet var categoryLabel: UIView!
    let realm = try! Realm()
    var task : Task!
    var list = ["仕事","プライベート","勉強"]
    
    var selctedCategory = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
            self.view.addGestureRecognizer(tapGesture)

            titleTextField.text = task.title
            contentsTextView.text = task.contents
            datePicker.date = task.date
        categoryPickerview.dataSource = self
        categoryPickerview.delegate = self
        if !task.category.isEmpty{
                   categoryPickerview.selectRow(list.firstIndex(of: task.category)!, inComponent: 0, animated: false)
               }
               selctedCategory = list[categoryPickerview.selectedRow(inComponent: 0)]
        
        
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.task.category = selctedCategory
            self.realm.add(self.task, update: .modified)
        }
        setNotification(task: task)
        super.viewWillDisappear(animated)
    }
    
    // タスクのローカル通知を登録する
       func setNotification(task: Task) {
           let content = UNMutableNotificationContent()
           // タイトルと内容を設定(中身がない場合メッセージ無しで音だけの通知になるので「(xxなし)」を表示する)
           if task.title == "" {
               content.title = "(タイトルなし)"
           } else {
               content.title = task.title
           }
           if task.contents == "" {
               content.body = "(内容なし)"
           } else {
               content.body = task.contents
           }
           content.sound = UNNotificationSound.default

           // ローカル通知が発動するtrigger（日付マッチ）を作成
           let calendar = Calendar.current
           let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
           let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

           // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
           let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)

           // ローカル通知を登録
           let center = UNUserNotificationCenter.current()
           center.add(request) { (error) in
               print(error ?? "ローカル通知登録 OK")  // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
           }

           // 未通知のローカル通知一覧をログ出力
           center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
               for request in requests {
                   print("/---------------")
                   print(request)
                   print("---------------/")
               }
           }
       }

        @objc func dismissKeyboard(){
            // キーボードを閉じる
            view.endEditing(true)
        }
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    selctedCategory = list[row] as String
     
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    }
