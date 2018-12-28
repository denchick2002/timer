//
//  ViewController.swift
//  Timer
//
//  Created by Денис Андриевский on 12/14/18.
//  Copyright © 2018 Денис Андриевский. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
  
    var audioPlayer = AVAudioPlayer()
    var enabPlaying = true
    
    // MARK: function to play sound
    func playSound() {
        
        let soundURL = Bundle.main.url(forResource: "sound", withExtension: "mp3")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch {
            print(error)
        }
        
        audioPlayer.play()
        vibrate()
    }
    
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var pickerView1: UIPickerView!
    @IBOutlet weak var pickerView2: UIPickerView!
    @IBOutlet weak var pickerView3: UIPickerView!
    
    // MARK: function to vibrate
    func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        sleep(1)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        sleep(1)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var hrs = Int()
    var mins = Int()
    var secs = Int()
    var seconds = Int()
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView1.delegate = self
        self.pickerView2.delegate = self
        self.pickerView3.delegate = self
        self.pickerView1.dataSource = self
        self.pickerView2.dataSource = self
        self.pickerView3.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(returnToForeGround(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    var diffsecs = 0
    
    
    // MARK: PickerView DataBases
    let pickerDataBase1 = Array(0...23)
    let pickerDataBase2 = Array(0...59)
    let pickerDataBase3 = Array(0...59)
    
    // MARK: Number of Components in PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // MARK: Number of rows in Component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerView1 {
            return pickerDataBase1.count
        }
        if pickerView == pickerView2 {
            return pickerDataBase2.count
        }
        else {
            return pickerDataBase3.count
        }
        
    }
    // MARK: returning the data in PickerView to user
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerView1 {
            return String(pickerDataBase1[row]) + " ч"
        }
        if pickerView == pickerView2 {
            return String(pickerDataBase2[row]) + " мин"
        }
        else {
            return String(pickerDataBase3[row]) + " с"
        }
        
    }
    
    // MARK: collecting SegmentedView data
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex==0{
            enabPlaying = true
        }
        else {
            enabPlaying = false
        }
        
    }
    
    // MARK: returning chosen info
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView1 {
            hrs = pickerDataBase1[row]
        }
        if pickerView == pickerView2 {
            mins = pickerDataBase2[row]
        }
        if pickerView == pickerView3 {
            secs = pickerDataBase3[row]
        }
    }
    

    @IBAction func startBtnPressed(_ sender: UIButton) {
        start()
    }
    
    // MARK: function that starts timer
    func start(){
        seconds = 3600*hrs+60*mins+secs
        if seconds != 0 {
            timeLabel.text = setTime(seconds: seconds)
            if isTimerRunning == false {
                runningTimer()
                
            }
            
        }
        resetBtn.isEnabled = true
        pauseBtn.isEnabled = true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        start()
    }
    
    
    @IBAction func pauseBtnPressed(_ sender: UIButton) {
        
        if seconds>0{
            if self.resumeTapped == false {
                timer.invalidate()
                self.resumeTapped = true
                isTimerRunning = false
            }
            else {
                if isTimerRunning == false {
                    runningTimer()
                }
                self.resumeTapped = false
            }
        }
    }
    
    @IBAction func resetBtnPressed(_ sender: UIButton) {
        
        pauseBtn.isEnabled = false
        isTimerRunning = false
        timer.invalidate()
        seconds = 0
        timeLabel.text = setTime(seconds: seconds)
        resetBtn.isEnabled = false
        
    }
    
    // MARK: functions to run timer
    func runningTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:
            (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
          isTimerRunning = true
    }
    
    @objc func updateTimer(){
        seconds -= 1
        timeLabel.text = setTime(seconds: seconds)
        if seconds == 0 {
            timer.invalidate()
            if enabPlaying {
                playSound()
            }
            
            isTimerRunning = false
            timeLabel.text = setTime(seconds: seconds)
            
        }
        if seconds < 0 {
            timer.invalidate()
            isTimerRunning = false
            seconds = 0
            timeLabel.text = setTime(seconds: seconds)
        }
        
    }
    
    @objc func pauseWhenBackground(noti: Notification) {
        timer.invalidate()
        let shared = UserDefaults.standard
        shared.set(Date(), forKey: "savedTime")
        
    }
    
    @objc func returnToForeGround(noti: Notification) {
        if let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date {
            (diffsecs) = ViewController.getTimeDifference(startDate: savedDate)
            self.refresh(secs: diffsecs)
        }
    }
    
    static func getTimeDifference(startDate: Date) -> Int{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: Date())
        return(components.hour!*3600+components.minute!*60+components.second!)
    }
    
    func refresh(secs: Int) {
        if resumeTapped == false{
                seconds -= secs
            if seconds<=0 {
                timer.invalidate()
                seconds = 0
                timeLabel.text = setTime(seconds: seconds)
            }
            else {
                runningTimer()
            }
        }
       
        
    }
    
    
    
    // MARK: function to return labeltext 
    func setTime(seconds: Int) -> String {
        let hours = Int(seconds/3600)
        let mins = Int((seconds-hours*3600)/60)
        let secs = seconds-hours*3600-mins*60
        if seconds >= 3600 {
            return String(format: "%02i:%02i:%02i", hours, mins, secs)
        }
        else {
            return String(format: "%02i:%02i", mins, secs)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

