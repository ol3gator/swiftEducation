//
//  AddViewController .swift
//  BirthdayApp
//
//  Created by Maxim on 26.01.2023.
//

import UIKit
import SnapKit
import CoreData
import UserNotifications

class AddViewController: UIViewController {
    
    let firstNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "First name:"
        label.textColor = .black
        
        return label
    }()
    
    let lastNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Last name:"
        label.textColor = .black
        
        return label
    }()
    
    let firstNameTextField: UITextField = {
        let textField = UITextField()
        
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    let lastNameTextField: UITextField = {
        let textField = UITextField()
        
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.backgroundColor = .white
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        
        datePicker.maximumDate = Date()
        
        return datePicker
    }()
    
    let firstStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 25
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        return stackView
    }()
    
    let lastStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 25
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationBarSetup()
        objectsLocation()
    }
    
    func objectsLocation(){
    
        firstStackView.addArrangedSubview(firstNameLabel)
        firstStackView.addArrangedSubview(firstNameTextField)
        view.addSubview(firstStackView)

        firstNameLabel.snp.makeConstraints { make in
            make.width.equalTo(85)
        }
        firstStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.leading.equalToSuperview().offset(55)
            make.trailing.equalToSuperview().inset(55)
            make.height.equalTo(25)
        }


        lastStackView.addArrangedSubview(lastNameLabel)
        lastStackView.addArrangedSubview(lastNameTextField)
        view.addSubview(lastStackView)

        lastNameLabel.snp.makeConstraints { make in
            make.width.equalTo(85)
        }

        lastStackView.snp.makeConstraints { make in
            make.top.equalTo(firstStackView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(55)
            make.trailing.equalToSuperview().inset(55)
            make.height.equalTo(25)
        }
        
        
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(lastStackView.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(45)
        }
    }
    
    
    func navigationBarSetup() {
        navigationItem.title = "Add birthday"
        let cancelBarButton = UIBarButtonItem(title: "Back", style: .plain, target: self,
                                              action: #selector(cancelButtonPressed))
        navigationItem.leftBarButtonItem = cancelBarButton
        let saveBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self,
                                            action: #selector(saveButtonPressed))
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    @objc func saveButtonPressed() {
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let birthDate = datePicker.date
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newBirthday = Birthday(context: context)
        newBirthday.firstName = firstName
        newBirthday.lastName = lastName
        newBirthday.birthDate = birthDate
        newBirthday.birthdayID = UUID().uuidString
        
        if let uniqueID = newBirthday.birthdayID {
            print("birthday ID: \(uniqueID)")
        }
        
        do {
            try context.save()
            let message = "Today \(firstName) \(lastName) has a birthday. Don't forget to congratulate!"
    
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            
            var dateComponents = Calendar.current.dateComponents([.month, .day], from: birthDate)
            
            dateComponents.hour = 12
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            if let identifier = newBirthday.birthdayID {
                let requset = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(requset, withCompletionHandler: nil)
            }
            
        } catch let error {
            print("Saving error: \(error)")
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func cancelButtonPressed() {
        navigationController?.popToRootViewController(animated: true)
    }
}
