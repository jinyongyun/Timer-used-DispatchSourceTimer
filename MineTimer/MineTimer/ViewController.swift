//
//  ViewController.swift
//  MineTimer
//
//  Created by jinyong yun on 2022/11/01.
//

import UIKit
import AudioToolbox

enum TimerStatus {
    case start
    case pause
    case end
}


class ViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var commentView: UITextView!
    
    @IBOutlet weak var commentText: UITextField!
    
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
   
    @IBOutlet weak var contentCommentView: UITextView!
    
    var duration = 60
    
    var content: String = ""
    
    var timerStatus: TimerStatus = .end
    
    var timer: DispatchSourceTimer?
    
    
    var currentSeconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
        // Do any additional setup after loading the view.
    }

    func setTimerInfoViewVisible(isHidden: Bool){
        self.timerLabel.isHidden = isHidden
        
    }
    
    func startTimer(){
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: { [weak self] in
                guard let self = self else { return } //Self를 Strong reference으로
                self.currentSeconds -= 1
                let hour = self.currentSeconds / 3600 //시
                let minutes = (self.currentSeconds % 3600) / 60 //분
                let seconds = (self.currentSeconds % 3600) % 60 //초
                self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, minutes, seconds)
                self.turnColorView()
                
                
                if self.currentSeconds <= 0 {
                    self.stopTimer()
                    self.view.backgroundColor = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
                    AudioServicesPlaySystemSound(1024)
                }
                
            })
            self.timer?.resume()
        }
    }
    
    func configureToggleButton(){
        self.startButton.setTitle("시작", for: .normal)
        self.startButton.setTitle("일시정지", for: .selected)
    }
    
    
    @IBAction func tapRegisterButton(_ sender: UIButton) {
        if(commentText.text != ""){
            self.content = contentCommentView.text
            content.append("\n" + commentText.text!)
            contentCommentView.text = content
        }
    }
    
    @IBAction func tapStartButton(_ sender: UIButton) {
        self.duration = Int(self.datePicker.countDownDuration)
        switch self.timerStatus {
        case .end:
            self.currentSeconds = self.duration
            self.timerStatus = .start
            self.setTimerInfoViewVisible(isHidden: false)
            self.datePicker.isHidden = true
            self.startButton.isSelected = true
            self.stopButton.isEnabled = true
            self.startTimer()
        case .start:
            self.timerStatus = .pause
            self.startButton.isSelected = false
            self.timer?.suspend()
        case .pause:
            self.timerStatus = .start
            self.startButton.isSelected = true
            self.timer?.resume()
            
        }
    }
    
    func turnColorView(){
        if(currentSeconds >= 60){
            debugPrint(currentSeconds)
            self.view.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        if(currentSeconds < 60 && currentSeconds >= 40){
            debugPrint(currentSeconds)
            self.view.backgroundColor = UIColor(red: 1.0, green: 0.749, blue: 0.749, alpha: 1.0)
        }
        
        if(currentSeconds < 40 && currentSeconds >= 20){
            debugPrint(currentSeconds)
            self.view.backgroundColor = UIColor(red: 1.0, green: 0.5294, blue: 0.5294, alpha: 1.0)
        }
        if(currentSeconds < 20 && currentSeconds >= 10){
            debugPrint(currentSeconds)
            self.view.backgroundColor = UIColor(red: 1.0, green: 0.3696, blue: 0.3686, alpha: 1.0)
        }
        if(currentSeconds < 10 && currentSeconds >= 5){
            debugPrint(currentSeconds)
            self.view.backgroundColor = UIColor(red: 1.0, green: 0.1882, blue: 0.1882, alpha: 1.0)
        }
        if(currentSeconds < 5 && currentSeconds > 0){
            debugPrint(currentSeconds)
            self.view.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
       
       
      
       
    }
    
    
    func stopTimer() {
        if self.timerStatus == .pause {
            self.timer?.resume()
        }
        self.timerStatus = .end
        self.stopButton.isEnabled = false
        self.setTimerInfoViewVisible(isHidden: true)
        self.datePicker.isHidden = false
        self.startButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil //타이머 메모리 해제
        
    }
    
    @IBAction func tapStopButton(_ sender: UIButton) {
        switch self.timerStatus {
            case .start, .pause:
            self.stopTimer()
            
        default:
            break
            
        }
    }
}

