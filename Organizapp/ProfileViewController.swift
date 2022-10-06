import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var workTimeTF: UITextField!
    @IBOutlet weak var shortBreakTF: UITextField!
    @IBOutlet weak var longBreakTF: UITextField!
    @IBOutlet weak var pomodorosUntilLongBreakTF: UITextField!
    @IBOutlet weak var autoStartPomodoroSwitch: UISwitch!
    @IBOutlet weak var autoStartBreakSwitch: UISwitch!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))

        workTimeTF.delegate = self
        shortBreakTF.delegate = self
        longBreakTF.delegate = self

        workTimeTF.keyboardType = UIKeyboardType.numberPad
        shortBreakTF.keyboardType = UIKeyboardType.numberPad
        longBreakTF.keyboardType = UIKeyboardType.numberPad

        workTimeTF.addTarget(self, action: #selector(workTimeDidChange(_:)), for: .editingChanged)
        shortBreakTF.addTarget(self, action: #selector(shortBreakDidChange(_:)), for: .editingChanged)
        longBreakTF.addTarget(self, action: #selector(longBreakDidChange(_:)), for: .editingChanged)
        pomodorosUntilLongBreakTF.addTarget(self, action: #selector(pomodorosUntilLongBreakDidChange(_:)), for: .editingChanged)

        setUpSettings()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func toggleAutoStartPomodoro(_ sender: Any) {
        let state = autoStartPomodoroSwitch.isOn
        defaults.set(state, forKey: "autoStartPomodoro")
    }
    
    @IBAction func toggleAutoStartBreak(_ sender: Any) {
        let state = autoStartBreakSwitch.isOn
        defaults.set(state, forKey: "autoStartBreak")
    }
    
    @objc func workTimeDidChange(_ textField: UITextField) {
        let value = Int(workTimeTF.text!)
        defaults.set(value, forKey: "workTime")
    }
    
    @objc func shortBreakDidChange(_ textField: UITextField) {
        let value = Int(shortBreakTF.text!)
        defaults.set(value, forKey: "shortBreak")
    }
    
    @objc func longBreakDidChange(_ textField: UITextField) {
        let value = Int(longBreakTF.text!)
        defaults.set(value, forKey: "longBreak")
    }
    
    @objc func pomodorosUntilLongBreakDidChange(_ textField: UITextField) {
        let value = Int(pomodorosUntilLongBreakTF.text!)
        defaults.set(value, forKey: "pomodorosUntilLongBreak")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func setUpSettings() {
        autoStartPomodoroSwitch.setOn(defaults.bool(forKey: "autoStartPomodoro"), animated: false)
        autoStartBreakSwitch.setOn(defaults.bool(forKey: "autoStartBreak"), animated: false)
        workTimeTF.text = defaults.string(forKey: "workTime")
        shortBreakTF.text = defaults.string(forKey: "shortBreak")
        longBreakTF.text = defaults.string(forKey: "longBreak")
        pomodorosUntilLongBreakTF.text = defaults.string(forKey: "pomodorosUntilLongBreak")
    }
        
}
