
import UIKit

class ViewController: UIViewController{
    
   private var models = [ToDoList]()
   private var dataManager = DataManager()
        
   private lazy var tableView: UITableView = {
       let view = UITableView()
       view.translatesAutoresizingMaskIntoConstraints = false
       view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
       return view
   }()
        

    override func viewDidLoad(){
        super.viewDidLoad()
        title = "Yapılacaklar Listesi".localized()
        view.addSubview(tableView)
        models = dataManager.getAllItem()
      
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
       
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        configureNavBar()
        tableView.reloadData()
    }
    
    
    
    func configureNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemIndigo
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]


        navigationController?.navigationBar.tintColor = UIColor.white

  
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc private func addNewItem() {
        let alertController = UIAlertController(title: "Yeni Liste".localized(), message: "Yeni bir liste ekleyin".localized(), preferredStyle: .alert)
        alertController.addTextField()

        let saveAction = UIAlertAction(title: "Ekle".localized(), style: .default) { [weak self, weak alertController] _ in
            guard let self = self, let textField = alertController?.textFields?.first, let text = textField.text, !text.isEmpty else { return }
            
            self.dataManager.createItem(name: text)
            self.models = self.dataManager.getAllItem()
            self.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "İptal".localized(), style: .cancel)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    }
    
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Sil".localized()) { [weak self] (_, _, completionHandler) in
                guard let self = self else { return }
                let itemToRemove = self.models[indexPath.row]
                self.dataManager.deleteItem(item: itemToRemove)
                self.models.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                completionHandler(true)
            }
        
        
        let edit = UIContextualAction(style: .normal, title: "Düzenle".localized()) { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            let itemToEdit = self.models[indexPath.row]
            let alertController = UIAlertController(title: "Düzenle".localized(), message: "Yapılacaklar listenizi düzenleyin".localized(), preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.text = itemToEdit.name
            }
            
            let saveAction = UIAlertAction(title: "Kaydet".localized(), style: .default) { [weak self, weak alertController] _ in
                guard let self = self, let textField = alertController?.textFields?.first, let newName = textField.text, !newName.isEmpty else { return }
                dataManager.updateItem(item: itemToEdit, newName: newName)
                completionHandler(true)
                self.models = self.dataManager.getAllItem()
                tableView.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: "İptal".localized(), style: .cancel) { _ in
                completionHandler(false)
            }
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
        edit.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }

    
}

extension String {
   func localized() -> String {
       return NSLocalizedString(self, tableName: "Localizable", comment: self)
   }
}
