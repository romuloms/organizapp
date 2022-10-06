import UIKit

class TasksTableViewController: UITableViewController {
    var tasks = [Task]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task Cell", for: indexPath)
        
        if let taskCell = cell as? TaskTableViewCell {
            let task = tasks[indexPath.row]
            
            taskCell.titleLabel.text = task.title
            taskCell.descriptionLabel.text = task.description
            
            return taskCell
        }
        
        return cell
    }
    
    private func remove(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        return UIContextualAction(style: .destructive, title: "Remove") { [weak self] (_, _, _) in
            guard let self = self else { return }
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.defaults.set(self.tasks.count, forKey: "pendingTasks")
        }
    }
    
    private func complete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        return UIContextualAction(style: .normal, title: "Complete") { [weak self] (_, _, _) in
            guard let self = self else { return }
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.defaults.set(
                self.defaults.integer(forKey: "completedTasks") + 1,
                forKey: "completedTasks"
            )
            self.defaults.set(self.tasks.count, forKey: "pendingTasks")
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = self.complete(rowIndexPathAt: indexPath)
        let delete = self.remove(rowIndexPathAt: indexPath)
        
        return UISwipeActionsConfiguration(actions: [complete, delete])
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Manage Task" {
            let indexPath = tableView.indexPathForSelectedRow!
            let newTask = tasks[indexPath.row]
            
            if let taskView = segue.destination as? TaskDetailsViewController {
                taskView.newTask = newTask
            }
        }
        else {
            if let indexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
    }
    
    @IBAction func unwind(_ unwindSegue: UIStoryboardSegue) {
        if let source = unwindSegue.source as? TaskDetailsViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                tasks[indexPath.row] = source.newTask
                tableView.deselectRow(at: indexPath, animated: true)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            else {
                let indexPath = IndexPath(row: tasks.count, section: 0)
                tasks.append(source.newTask)
                defaults.set(tasks.count, forKey: "pendingTasks")
                tableView.insertRows(at: [indexPath], with: .bottom)
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }}
