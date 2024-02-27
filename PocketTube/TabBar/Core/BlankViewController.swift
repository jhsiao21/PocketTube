//
//  BlankViewController.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2023/9/6.
//

import UIKit

class BlankViewController: UIViewController {

    private let reminderButton: CustomButton = {
        let button = CustomButton(frame: CGRect(x: 200, y: 500, width: 75, height: 75))
        let image = UIImage(systemName: "bell.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        
        button.setTitle("提醒我", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12) // 设置文本的字体大小
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.setTitleColor(.label, for: .normal) // 可選：設置按鈕文字的顏色
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Blank"
        view.addSubview(reminderButton)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
