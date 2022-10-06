import UIKit

enum TimerState {
    case start, pause, resume
}

enum TimerType {
    case long, short, work
}

class TimerViewController: UIViewController {
    @IBOutlet weak var pauseStartButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var currentModeLabel: UILabel!
    
    var timerState = TimerState.start
    
    var pomodoroTime: Int!
    var shortBreakTime: Int!
    var longBreakTime: Int!
    var pomodorosUntilLongBreak: Int?
    var autoStartPomodoro: Bool!
    var autoStartBreak: Bool!
    
    let shortBreakColor = UIColor.blue.cgColor
    let longBreakColor = UIColor.purple.cgColor
    let pomodoroColor = UIColor.green.cgColor
            
    var timer: Timer?
    var timerType: TimerType?
    var pomodoroCounter = 0
    var totalTime: Int!
    var currentTime: Int!
    
    var circularProgressBarView: CircularProgressBarView!
    
    var loops = 0
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDefaults()
        setupTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUserDefaults()
        if timer == nil {
            totalTime = timerType == .work ? pomodoroTime : timerType == .short ? shortBreakTime : longBreakTime
            currentTime = totalTime
            timeLabel.text = formatTime(time: totalTime)
        }
    }
        
    func getUserDefaults() {
        pomodoroTime = defaults.integer(forKey: "workTime")
        shortBreakTime = defaults.integer(forKey: "shortBreak")
        longBreakTime = defaults.integer(forKey: "longBreak")
        pomodorosUntilLongBreak = defaults.integer(forKey: "pomodorosUntilLongBreak")
        autoStartPomodoro = defaults.bool(forKey: "autoStartPomodoro")
        autoStartBreak = defaults.bool(forKey: "autoStartBreak")
    }
    
    func setupTimer() {
        pauseStartButton.setTitle("Começar", for: .normal)
        timerType = .work
        currentModeLabel.text = "Hora de focar!"
        cancelButton.alpha = 0
        cancelButton.isHidden = true
        
        totalTime = pomodoroTime
        currentTime = totalTime
        timeLabel.text = formatTime(time: totalTime)
        circularProgressBarView = CircularProgressBarView(frame: .zero)
        circularProgressBarView.changeColor(pomodoroColor)
        circularProgressBarView.center = view.center
        view.addSubview(circularProgressBarView)
    }
    
    func toggleCancelButton() {
        cancelButton.alpha = cancelButton.alpha == 1 ? 0 : 1
        UIView.transition(with: cancelButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.cancelButton.isHidden = !self.cancelButton.isHidden
        })
    }
    
    func showCurrentModeLabel(_ state: Bool) {
        UIView.transition(with: currentModeLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.currentModeLabel.isHidden = !state
        })
    }
    
    @IBAction func pauseStartAction(_ sender: UIButton) {
        if timerState == .pause {
            pauseTimer()
            timerState = .resume
        }
        else {
            if timerState == .start {
                toggleCancelButton()
            }
            startTimer()
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        resetButtons()
        resetTimer()
        totalTime = timerType == .work ? pomodoroTime : timerType == .short ? shortBreakTime : longBreakTime
        currentTime = totalTime
        timeLabel.text = formatTime(time: totalTime)
        showCurrentModeLabel(false)
    }

    func startTimer() {
        timerState = .pause
        showCurrentModeLabel(true)
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        pauseStartButton.setTitle("Pausar", for: .normal)
        pauseStartButton.setTitleColor(UIColor.orange, for: .normal)
        circularProgressBarView.activateAnimation(time: currentTime)
    }
    
    func pauseTimer() {
        timer!.invalidate()
        pauseStartButton.setTitle("Continuar", for: .normal)
        pauseStartButton.setTitleColor(UIColor.systemGreen, for: .normal)
        circularProgressBarView.pauseAnimation()
    }
    
    @objc func updateTimer() {
        if loops < 1000 {
            loops += 1
            return
        }
        
        if currentTime < 1 {
            resetTimer()
            timerCompletedHandler()
            timeLabel.text = formatTime(time: totalTime)
        }
        else {
            currentTime -= 1
            timeLabel.text = formatTime(time: currentTime)
        }
        
        loops = 0
    }

    func timerCompletedHandler() {
        var autoStart: Bool!
        
        if timerType == .work {
            defaults.set(defaults.integer(forKey: "completedPomodoros") + 1, forKey: "completedPomodoros")
            pomodoroCounter += 1
            
            if pomodoroCounter == pomodorosUntilLongBreak {
                pomodoroCounter = 0
                timerType = .long
                currentModeLabel.text = "Descanso longo"
                totalTime = longBreakTime
                circularProgressBarView.changeColor(longBreakColor)
            }
            else {
                timerType = .short
                currentModeLabel.text = "Descanso curto"
                totalTime = shortBreakTime
                circularProgressBarView.changeColor(shortBreakColor)
            }
            
            autoStart = autoStartBreak
        }
        else {
            timerType = .work
            currentModeLabel.text = "Hora de focar!"
            totalTime = pomodoroTime
            circularProgressBarView.changeColor(pomodoroColor)

            autoStart = autoStartPomodoro
        }
        
        currentTime = totalTime
        autoStart ? startTimer() : resetButtons()
    }
    
    func resetButtons() {
        toggleCancelButton()
        pauseStartButton.setTitle("Começar", for: .normal)
        pauseStartButton.setTitleColor(UIColor.link, for: .normal)
        timerState = .start
    }
    
    func resetTimer() {
        timer!.invalidate()
        circularProgressBarView.removeAnimation()
        timer = nil
    }

    func formatTime(time: Int) -> String {
        let minutes = time / 60 % 60
        let seconds = time % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
