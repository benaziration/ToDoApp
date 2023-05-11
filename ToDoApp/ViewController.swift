//
//  ViewController.swift
//  ToDoApp
//
//  Created by Benazir Toleubekova on 08.05.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let cellReuseIdentifier = "cell"
    var tasks = [Task]()
    var isActive = false
    var order: Int = 0

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.snp.makeConstraints {
            $0.bottom.top.left.right.equalToSuperview()
        }
        return tableView
    }()
    
    private lazy var textView: UILabel = {
        let text = UILabel()
        view.addSubview(text)
        text.text = "Создайте новую задачу нажав на кнопку плюс"
        text.numberOfLines = 0
        text.textAlignment = .center
        text.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        return text
    }()
    
    
    private lazy var editButtonView: UIButton = {
        let editButton = UIButton(type: .system)
        editButton.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        editButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 50), forImageIn: .normal)
        editButton.tintColor = .systemBlue
        
        view.addSubview(editButton)
        editButton.addTarget(self, action: #selector(editTask), for: .touchUpInside)
        
        editButton.snp.makeConstraints { make in
            make.bottom.equalTo(plusButtonView.snp.bottom).inset(70)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        return editButton
    }()
    
    private lazy var plusButtonView: UIButton = {
        let plusButton = UIButton(type: .system)
        plusButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        plusButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 50), forImageIn: .normal)
        plusButton.tintColor = .systemGreen
        
        view.addSubview(plusButton)
        plusButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        
        plusButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(60)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        return plusButton
    }()
    
    static let add = Notification.Name("Add")
    static let edit = Notification.Name("Edit")
    // merge all UIviews elements in array for display on screen
    private lazy var listOfViews = [tableView, editButtonView, plusButtonView,textView]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let _ = listOfViews.compactMap { $0 }
        
        textView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // recieve data by add observer
        NotificationCenter.default.addObserver(self, selector: #selector(onAdd(notification:)),
                                               name: ViewController.add, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onEdit(notification:)),
                                               name: ViewController.edit, object: nil)
    }
    
   
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    

    @objc func onAdd (notification: Notification) {
        
        if let dict = notification.object as? NSDictionary {
            for (titleReceive, descriptionReceive) in dict {
                guard let titleReceive = titleReceive as? String else { return }
                guard let descriptionReceive = descriptionReceive as? String else { return }
                
                if titleReceive != "" {
                let indexPath = IndexPath(row: 0, section: 0)
                tasks.insert(Task(title: titleReceive, description: descriptionReceive), at: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
   
    @objc func onEdit(notification: Notification) {
        if let dict = notification.object as? NSDictionary {
            for (titleReceive, descriptionReceive) in dict {
                guard let titleReceive = titleReceive as? String else { return }
                guard let descriptionReceive = descriptionReceive as? String else { return }
                tasks[order] = Task(title: titleReceive, description: descriptionReceive)
            }
            tableView.reloadData()
        }
    }
    
    
    @objc func addTask() {
        let vc = AddViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .overCurrentContext
        present(navigationController, animated: true, completion: nil)
    }
   
    @objc func editTask() {
        isActive.toggle()
        if isActive {
            plusButtonView.isHidden = true
            editButtonView.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        } else {
            plusButtonView.isHidden = false
            editButtonView.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        }
        
        self.isEditing = !self.isEditing
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let imgView = tapGestureRecognizer.view as! UIImageView
        
        if imgView.image != UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22))?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal) {
            imgView.image = UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22))?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        } else {
            imgView.image = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22))?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        }
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tasks.count == 0 {
               textView.isHidden = false
               return tasks.count
           } else {
               textView.isHidden = true
               return tasks.count
           }
       }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .detailDisclosureButton
        cell.selectionStyle = .none
        
        cell.imageView?.image = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22))?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.imageView?.addGestureRecognizer(tapGesture)
        cell.imageView?.isUserInteractionEnabled = true
        
        
        cell.textLabel?.text = tasks[indexPath.row].title
        cell.detailTextLabel?.text = tasks[indexPath.row].description
        
        return cell
    }
  
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        order = indexPath.row
        
        let vc = EditViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        
        
        navigationController.modalPresentationStyle = .overCurrentContext
        
        present(navigationController, animated: true, completion: nil)
    }
 
}
