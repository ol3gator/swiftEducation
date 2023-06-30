//
//  ViewController.swift
//  BirthdayApp
//
//  Created by Maxim on 25.01.2023.
//


import UIKit
import SnapKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var birthdays = [Birthday]()
    let dateFormatter = DateFormatter()
    let tableView: UITableView = {
        let table = UITableView()
        table.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarSetup()
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = Birthday.fetchRequest() as NSFetchRequest<Birthday>
        
        let sortDescriptor1 = NSSortDescriptor(key: "lastName", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "firstName", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        do {
            birthdays = try context.fetch(fetchRequest)
        } catch let erorr {
            print("Saving error: \(erorr)")
        }
        
        tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birthdays.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier,
            for: indexPath)
        
        let birthday = birthdays[indexPath.row]
        let firstName = birthday.firstName ?? ""
        let lastName = birthday.lastName ?? ""
    
        cell.textLabel?.text = firstName + " " + lastName
        
        if let date = birthday.birthDate {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        } else {
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if birthdays.count > indexPath.row {
            let birtday = birthdays[indexPath.row]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
    
            context.delete(birtday)
            birthdays.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        
            do {
                try context.save()
            } catch let error {
                print("Saving error: \(error)")
            }
        }
    }
    
    
    func navigationBarSetup() {
        navigationItem.title = "Birthday List"
        let addNavigationBarButton = UIBarButtonItem(title: "Add", style: .plain, target: self,
                                                     action: #selector(addBarButtonPressed))
        navigationItem.rightBarButtonItem = addNavigationBarButton
        
    }
    
    @objc func addBarButtonPressed() {
        print("Add button works")
        let addViewController = AddViewController()

        addViewController.modalPresentationStyle = .fullScreen
        addViewController.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(addViewController, animated: true)
    }
}

