//
//  ViewController.swift
//  TimeOnLine
//
//  Created by Amin on 1/29/19.
//  Copyright © 2019 Amin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    private var currentTimeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private var newButton = UIButton(type: UIButton.ButtonType.system)
    private weak var timer: Timer?
    
    private let POINTS_PER_MINUTE = CGFloat(1.5)
    private let PROPORTION = CGFloat(0.4)
    private let RIGHT_OFFSET = CGFloat(40)
    
    private let calendar = Calendar.current
    var onGoingJob: Job? {
        didSet {
            if let onGoingJob = onGoingJob {
                view.backgroundColor = UIColor(red: 197/255, green: 239/255, blue: 247/255, alpha: 1)
                
                onGoingJobView = JobView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                onGoingJobView!.text = onGoingJob.type
                onGoingJobView!.color = .green
                scrollView.addSubview(onGoingJobView!)
                
                newButton.setTitle("🛑", for: .normal)
                newButton.sizeToFit()
            } else {
                view.backgroundColor = .white
                newButton.setTitle("+", for: .normal)
                onGoingJobView?.removeFromSuperview()
                onGoingJobView = nil
            }
            
        }
    }
    private var onGoingJobView: JobView?

    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }
    lazy var jobs: [Job] = [
//        Job(type: "study", description: "biology", start: formatter.date(from: "2019/01/30 06:10")!, duration: 70),
//        Job(type: "doing shit", description: "biology", start: formatter.date(from: "2019/01/30 04:10")!, duration: 120),
//        Job(type: "game", description: "biology", start: formatter.date(from: "2019/01/30 03:20")!, duration: 30),
//        Job(type: "game", description: "biology", start: formatter.date(from: "2019/01/30 16:00")!, duration: 150)
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(currentTimeLabel)
        scrollView.addSubview(newButton)
        currentTimeLabel.font = UIFont.systemFont(ofSize: 30)
        newButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        newButton.setTitle("+", for: .normal)
        newButton.sizeToFit()
        newButton.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
    }
    
    @objc func touchButton(sender: Any?){
        if let onGoingJob = onGoingJob {
            jobs.append(Job(type: onGoingJob.type, description: onGoingJob.description, start: onGoingJob.start, duration: (Date().timeIntervalSince(onGoingJob.start))/60))
            self.onGoingJob = nil
            layoutJobViews()
        } else {
            performSegue(withIdentifier: "New Job", sender: sender)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.subviews.forEach({ view in
            if let jobView = view as? JobView {
                jobView.removeFromSuperview()
            }
            if let label = view as? UILabel {
                if label.textColor == UIColor.gray {
                    label.removeFromSuperview()
                }
            }
        })
        jobs.sort(by: {$0.start < $1.start})
        navigationController?.setNavigationBarHidden(true, animated: false)
        let width = view.bounds.width
        scrollView.contentSize = CGSize(width: width, height: 24 * 60 * POINTS_PER_MINUTE)
        createSideTimeIndicators(origin: jobs.isEmpty ? Date(timeIntervalSinceNow: -3600) : jobs[0].start)
        layoutJobViews()
        self.layoutCurrentTimeLabel(origin: self.jobs.isEmpty ? Date(timeIntervalSinceNow: -3600) : self.jobs[0].start)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            self.layoutCurrentTimeLabel(origin: self.jobs.isEmpty ? Date(timeIntervalSinceNow: -3600) : self.jobs[0].start)
        })
        
        
        
    }
    
    private func layoutJobViews() {
        let width = view.bounds.width
        jobs.sort(by: {$0.start < $1.start})
        for job in jobs {
            let cellHeight = CGFloat(job.duration) * POINTS_PER_MINUTE
            let offset = CGFloat(job.start.timeIntervalSince(jobs[0].start) / 60) * POINTS_PER_MINUTE
            let jobView = JobView(frame: CGRect(x: (1 - PROPORTION) * width - RIGHT_OFFSET, y: offset, width: width * PROPORTION, height: cellHeight))
            jobView.color = .red
            jobView.text = job.type
            scrollView.addSubview(jobView)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func createSideTimeIndicators(origin: Date) {
        let interval = 15 // minutes
        let firstIndicatorFromOrigin = interval - calendar.component(.minute, from: origin) % interval
        var counter = 0
        while counter * interval < 24 * 60 {
            let indicatorFromOrigin = Double(counter * interval + firstIndicatorFromOrigin) // in minutes
            let indicatorDate = Date(timeInterval: indicatorFromOrigin * 60, since: origin)
            let indicatorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            indicatorLabel.text = calendar.component(.minute, from: indicatorDate) == 0 ? getTimeString(hour: calendar.component(.hour, from: indicatorDate), minute: calendar.component(.minute, from: indicatorDate), second: nil) : calendar.component(.minute, from: indicatorDate) == 30 ? "--" : "-"
            indicatorLabel.textColor = UIColor.gray
            indicatorLabel.font = UIFont.systemFont(ofSize: POINTS_PER_MINUTE * 7)
            indicatorLabel.sizeToFit()
            scrollView.addSubview(indicatorLabel)
            indicatorLabel.center = CGPoint(x: scrollView.contentSize.width - (0.4) * RIGHT_OFFSET, y: CGFloat(indicatorFromOrigin) * POINTS_PER_MINUTE)
            counter += 1
        }
        
    }
    func layoutCurrentTimeLabel(origin: Date) {
        let currentDate = Date()
        currentTimeLabel.text = getTimeString(
            hour: calendar.component(.hour, from: currentDate),
            minute: calendar.component(.minute, from: currentDate),
            second: calendar.component(.second, from: currentDate)
        )
        currentTimeLabel.sizeToFit()
        let centerX = (1-PROPORTION) / 2 * scrollView.contentSize.width - RIGHT_OFFSET / 2
        let centerY = CGFloat(currentDate.timeIntervalSince(origin) / 60) * POINTS_PER_MINUTE
        currentTimeLabel.center = CGPoint(x: centerX, y:centerY)
        
        newButton.center = CGPoint(x: centerX, y: centerY + 70)
        
    }

    @IBAction func tapScrollViewHandler(_ sender: Any) {
        let desiredCenter = currentTimeLabel.center
        scrollView.scrollRectToVisible(CGRect(x: 0, y: desiredCenter.y - view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height), animated: true)
    }
}

func getTimeString(hour: Int, minute: Int, second: Int?) -> String {
    var hourString = String(hour)
    var minuteString = String(minute)
    if hour < 10 {
        hourString = "0\(hour)"
    }
    if minute < 10 {
        minuteString = "0\(minute)"
    }
    if second == nil {
        return "\(hourString):\(minuteString)"
    }
    var secondString = String(second!)
    if second! < 10 {
        secondString = "0\(second!)"
    }
    return "\(hourString):\(minuteString):\(secondString)"
}
