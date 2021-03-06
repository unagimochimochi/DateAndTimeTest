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
    @IBOutlet weak var countdownView: UIView!
    @IBOutlet weak var countdownViewHeight: NSLayoutConstraint!
    
    var datePicker: UIDatePicker = UIDatePicker()
    var estimatedTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textField.delegate = self
        
        countdownViewHeight.constant = 0
        
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
            // UIDatePickerで出力された日時の秒を0にする
            let estimatedTimeReset = resetTime(date: estimatedTime)
            
            // 表示する時刻の設定
            let calendar = Calendar(identifier: .japanese)
            let components = calendar.dateComponents([.year, .day, .hour, .minute, .second], from: now, to: estimatedTimeReset)
            
            // 出力した時刻まで1時間以上のとき、カウントダウンを非表示
            if components.hour! >= 1 {
                countdownLabel.isHidden = true
                countdownViewHeight.constant = 0
            }
                
            // 1時間未満のとき、カウントダウンを表示
            else {
                countdownLabel.isHidden = false
                countdownViewHeight.constant = 200

                // 時間と分と秒を表示
                countdownLabel.text = String(format: "%02d:%02d", components.minute!, components.second!)
                
                if components.hour! <= 0 && components.minute! <= 0 && components.second! <= 0 {
                    countdownLabel.text = "00:00"
                    countdownView.backgroundColor = UIColor(hue: 0.03, saturation: 0.95, brightness: 0.85, alpha: 1.0)
                }
            }
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
    
    // 秒を0にする
    func resetTime(date: Date) -> Date {
        let calendar: Calendar = Calendar(identifier: .japanese)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

        components.second = 0

        return calendar.date(from: components)!
    }

}

