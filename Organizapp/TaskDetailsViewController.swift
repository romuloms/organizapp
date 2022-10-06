import UIKit

class TaskDetailsViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var enablePrioritySwitch: UISwitch!
    @IBOutlet weak var priorityGradeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var submitButton: UIButton!
    
    var newTask: Task!
    var priority: Priority = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTaskManager()
    }
    
    func setupTaskManager() {
        if newTask == nil {
            newTask = Task("", "", .none)
        }
        
        enablePrioritySwitch.isOn = false
        priorityGradeSegmentedControl.isEnabled = false

        if let task = newTask {
            titleTextField.text = task.title
            descriptionTextField.text = task.description
            enablePrioritySwitch.isOn = true
            priorityGradeSegmentedControl.isEnabled = true
            priority = task.priority
            
            switch priority {
                case .none:
                    enablePrioritySwitch.isOn = false
                    priorityGradeSegmentedControl.isEnabled = false
                default:
                    priorityGradeSegmentedControl.selectedSegmentIndex = priority.rawValue
            }
        }
    }
    
    @IBAction func handlePrioritySegmentControl(_ sender: UISegmentedControl) {
        priority = Priority(rawValue: sender.selectedSegmentIndex)!
    }
    
    @IBAction func handlePrioritySwitch(_ sender: UISwitch) {
        if sender.isOn {
            priorityGradeSegmentedControl.isEnabled = true
            handlePrioritySegmentControl(priorityGradeSegmentedControl)
        }
        else {
            priorityGradeSegmentedControl.isEnabled = false
            priority = .none
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let title = titleTextField.text {
            newTask?.title = title
            newTask?.description = descriptionTextField.text ?? ""
            newTask?.priority = priority
        }
    }
}
