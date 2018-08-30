//
//  RatingViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 30/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var posterCoverView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    let step: Float = 0.5
    
    var id: Int!
    var imagePath: String!
    var ratedValue: Float!
    var queryType: APIRequest!
    
    
    var callBack: ((Bool, Float?) -> Void)!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateView()
        Helpers.isStatusBarHidden(isHidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Helpers.isStatusBarHidden(isHidden: false)
    }
    
    func updateView() {
        
        self.questionLabel.text = "Do you like this \(queryType.rawValue == "tv" ? "tv show" : "movie")?"
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = Constants.cornerRadius
        coverImageView.kf.setImage(with: URL(string: imagePath), placeholder: Constants.placeholderImage)
        
        posterCoverView.dropShadow(radius: Constants.cornerRadius)
        
        self.minValueLabel.text = String(ratedValue)
        self.slider.setValue(ratedValue, animated: false)
        
        buttonView.layer.cornerRadius = Constants.cornerRadius
        buttonView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    
    }
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        let currentValue = round(sender.value / step) * step
        
        sender.setValue(currentValue, animated: true)
        
        self.minValueLabel.text = "\(currentValue)"
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
        let sliderValue = Float(self.slider.value)
        
        AccountService.instanceAccount.rateMovieOrTVShow(id: id, value: sliderValue, type: queryType, endPoint: .Rating) { (response) in
            
            if let response = response {
                
                if response.status_code == 1 || response.status_code == 12 {
                    self.callBack(true, sliderValue)
                    self.dismiss(animated: true, completion: nil)
                    
                } else {
                    Helpers.alertWindow(title: "Error", message: response.status_message!)
                }
                
            } else {
                self.callBack(false, nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
 
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
