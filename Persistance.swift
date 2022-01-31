//
//  Persistance.swift
//  Realm ToDoList
//
//  Created by Vladimir Polinskiy on 31.01.2022.
//

import Foundation
import RealmSwift


class Tasks: Object {
    @objc dynamic var name = ""
    @objc dynamic var createdAt = Date()
}


class Persistance {
    
    static let shared = Persistance()
    private let realm = try! Realm()
   
    
    private let kUserFirstNameKey = "Persistance.kUserFirstNameKey"
    
    var userLastName: String? {
            set {UserDefaults.standard.set(newValue, forKey: kUserFirstNameKey)}
            get { return UserDefaults.standard.string(forKey: kUserFirstNameKey)}
        }
    
    private let kUserLastNameKey = "Persistance.kUserLastNameKey"
    
    var userFirstName: String? {
        set { UserDefaults.standard.set(newValue,forKey: kUserLastNameKey) }
        get { return UserDefaults.standard.string(forKey: kUserLastNameKey)}
    }
    
    
    func addTask(name: String) {
        let task = Tasks()
        task.name = name
        task.createdAt = Date()
        writeRealm(object: task)
    }
    
    func writeRealm(object: Tasks) {
        try! realm.write{
            realm.add(object)
        }
    }
    
    func getAllTasks() -> [Tasks] {
        var allTasks = [Tasks]()
        for task in self.realm.objects(Tasks.self) {
               allTasks.append(task)
        }
        return allTasks
    }
    
    func deleteTask(object: Tasks) {       
        try! realm.write{
            realm.delete(object)
        }
    }
    
    
    func updateTask(object: Tasks, name: String){
        try! realm.write{
            object.name = name
        }
    }
   
}
