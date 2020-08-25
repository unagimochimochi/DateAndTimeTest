//
//  ViewController.swift
//  DateAndTimeTest
//
//  Created by 持田侑菜 on 2020/08/24.
//  Copyright © 2020 持田侑菜. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var datePicker: UIDatePicker = UIDatePicker()
    var estimatedTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textField.delegate = self
        
        // 0.1秒ごとに処理
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        // UIDatePickerの設定
        datePicker.locale = Locale(identifier: "ja_JP")
        datePicker.timeZone = .autoupdatingCurrent
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 42))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spaceItem, doneItem], animated: true)
        
        // UITextFieldをタップしたとき、通常のキーボードではなくUIDatePickerを表示する
        textField.inputView = datePicker
        textField.inputAccessoryView = toolbar
    }
    
    @objc func update() {
        // 表示する時刻の設定
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
        
        let now = Date()
        
        currentTimeLabel.text = dateFormatter.string(from: now)
        
        if let text = textField.text, !text.isEmpty {
            // 表示する時刻の設定
            let calendar = Calendar(identifier: .japanese)
            let timeInterval = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: estimatedTime)
            countdownLabel.text = String(format: "残り" + "%02d日:%02d時間:%02d分:%02d秒",
                                         timeInterval.day!,
                                         timeInterval.hour!,
                                         timeInterval.minute!,
                                         timeInterval.second!)
        }
    }
    
    @objc func done() {
        // キーボードをとじる
        textField.endEditing(true)
        
        // 表示する時刻の設定
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        
        textField.text = dateFormatter.string(from: datePicker.date)
        estimatedTime = datePicker.date
    }

}

