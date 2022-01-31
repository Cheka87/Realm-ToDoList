//
//  ViewController.swift
//  Realm ToDoList
//
//  Created by Vladimir Polinskiy on 30.01.2022.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    private var models = [Tasks]()
    private let realm = try! Realm()
    let shared = Persistance.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Realm To Do List"
        getAllItems()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAdd))
    
    }
    
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "Новая задача",
                                      message: "Добавьте задачу",
                                      preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Подтвердить",
                                      style: .cancel, handler: { [weak self] _ in
                                        guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {return}
                                        self?.createItem(name: text)
                                      }))
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        
        let sheet = UIAlertController(title: "Редактирование",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Редактировать", style: .default, handler: { _ in
         
            let alert = UIAlertController(title: "Редактирование задачи",
                                          message: "Отредактируйте задачу",
                                          preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Сохранить",
                                          style: .cancel, handler: { [weak self] _ in
                                            guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {return}
                                            self?.updateTask(item: item, newName: newName)
                                          }))
            
            self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: {[weak self] _ in
            self?.deleteTask(item: item)
        }))
        
        present(sheet, animated: true)
    }
    
    
    func getAllItems(){
        self.models = Persistance.shared.getAllTasks()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func createItem(name: String){
        Persistance.shared.addTask(name: name)
        getAllItems()
    }
    
    func deleteTask(item: Tasks) {
        Persistance.shared.deleteTask(object: item)
        getAllItems()
    }
    
    func updateTask(item: Tasks, newName: String) {
        Persistance.shared.updateTask(object: item, name: newName)
        getAllItems()
    }

}

