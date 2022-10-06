import UIKit

class StatisticsViewController: UIViewController {
    @IBOutlet weak var completedTasksTextField: UITextField!
    @IBOutlet weak var pendingTasksTextField: UITextField!
    @IBOutlet weak var percentageTextField: UITextField!
    @IBOutlet weak var completedPomodorosTextField: UITextField!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let pendingTasks = defaults.integer(forKey: "pendingTasks")
        let completedTasks = defaults.integer(forKey: "completedTasks")
        let percentage: Float = pendingTasks == 0 ? 100 : ((Float(completedTasks) / (Float(pendingTasks) + Float(completedTasks))) * 100)
        let completedPomodoros = defaults.integer(forKey: "completedPomodoros")
        
        pendingTasksTextField.text = String(pendingTasks)
        completedTasksTextField.text = String(completedTasks)
        percentageTextField.text = String(format: "%.0f%%", percentage)
        completedPomodorosTextField.text = String(completedPomodoros)
    }
}
