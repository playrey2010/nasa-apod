//
//  ViewController.swift
//  nasa-apod
//
//  Created by Mercedes Martinez Milantchi on 2/13/23.
//

import UIKit

class ViewController: UIViewController, ApodManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdatePicture(_: ApodManager, apod: ApodModel) {
        DispatchQueue.main.async {
            if let url = URL(string: apod.url) {
                self.apodImageView.load(url: url)
            }
        }
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var apodImageView: UIImageView!
    
    var pictureManager = ApodManager()
    
    @IBAction func dateSelected(_ sender: UIDatePicker) {
        let dateString = getDateString(date: sender.date)
        pictureManager.fetchAPOD(for: dateString)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pictureManager.delegate = self
        
        // Prepare for dismissing calendar on select
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        // Set today as the maximum day bound for Date Picker
        let today = Date()
        datePicker.maximumDate = today
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let result = getDateString(date: today)
//        print(result)
        
        // Reset to current date
        if let url = URL(string: "https://apod.nasa.gov/apod/image/2302/CometZtfMars_Lioce_4229.jpg") {
            apodImageView.load(url: url)
        }
    }
    
    @objc func dateChanged() {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}

func getDateString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: date)
}


// Extension to allow UIImageView to read image from URL
// Source: https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data (contentsOf: url){
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
            
        }
    }
}

