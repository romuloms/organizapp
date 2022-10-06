import UIKit

class OrganizappController: UITabBarController {
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.object(forKey: "autoStartBreak") == nil {
            defaults.set(true, forKey: "autoStartBreak")
        }
        
        if defaults.object(forKey: "autoStartPomodoro") == nil {
            defaults.set(false, forKey: "autoStartPomodoro")
        }
        
        if defaults.object(forKey: "workTime") == nil {
            defaults.set(25, forKey: "workTime")
        }
        
        if defaults.object(forKey: "shortBreak") == nil {
            defaults.set(5, forKey: "shortBreak")
        }
        
        if defaults.object(forKey: "longBreak") == nil {
            defaults.set(15, forKey: "longBreak")
        }
        
        if defaults.object(forKey: "pomodorosUntilLongBreak") == nil {
            defaults.set(4, forKey: "pomodorosUntilLongBreak")
        }
        
        defaults.set(0, forKey: "completedTasks")
        defaults.set(0, forKey: "pendingTasks")
        defaults.set(0, forKey: "completedPomodoros")
    }
}
