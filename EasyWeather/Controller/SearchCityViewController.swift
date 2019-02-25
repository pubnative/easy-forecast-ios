//
//  Copyright © 2019 EasyNaps. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

class SearchCityViewController: UIViewController {

    @IBOutlet weak var searchCityTextField: CustomTextField!
    @IBOutlet weak var mRectContainerView: UIView!
    
    var adPlacement = AdPlacement()
    var cityName: String!
    var cityID: String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCityTextField.inputAccessoryView = Bundle.main.loadNibNamed("CustomAccessoryView", owner: self, options: nil)?.first as! UIView?
        searchCityTextField.theme.font = UIFont(name: "AvenirNext-Regular", size: 15)!
        searchCityTextField.theme.fontColor = #colorLiteral(red: 0.4509803922, green: 0.4, blue: 0.6823529412, alpha: 1)
        searchCityTextField.theme.borderColor = #colorLiteral(red: 0.4509803922, green: 0.4, blue: 0.6823529412, alpha: 1)
        searchCityTextField.theme.separatorColor = #colorLiteral(red: 0.4509803922, green: 0.4, blue: 0.6823529412, alpha: 1)
        searchCityTextField.maxNumberOfResults = 5
        searchCityTextField.minCharactersNumberToStartFiltering = 3
        loadAd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(searchButtonPressed), name: Notification.Name("SearchPressed"), object: nil)
        DispatchQueue.main.async {
            self.searchCityTextField.filterStrings(getCityNames())
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("SearchPressed"), object: nil)
    }
    
    @objc func searchButtonPressed() {
        cityName = searchCityTextField.text
        if let cityID = getCityID(forCityName: cityName) {
            guard let summaryWeatherViewController = navigationController?.viewControllers.first as? SummaryWeatherViewController else { return }
            summaryWeatherViewController.cityName = cityName
            summaryWeatherViewController.cityID = cityID
            summaryWeatherViewController.fetchWeather(forCityID: cityID)
            navigationController?.popViewController(animated: true)
        } else {
            cityName = nil
            searchCityTextField.text = nil
            let alert = UIAlertController(title: "Oopps...", message: "We couldn't find that city in our database... 😢", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(dismissAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func textFieldTextHasChanged(_ sender: CustomTextField) {
        guard let city = sender.text,!city.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            searchCityTextField.inputAccessoryView?.isHidden = true
            return
        }
        searchCityTextField.inputAccessoryView?.isHidden = false
    }
    
    func loadAd() {
        mRectContainerView.isHidden = true
        guard let adNetwork = AdManager.sharedInstance.getNextNetwork(withPlacement: MRECT_PLACEMENT) else { return }
        guard let placement = MRectPlacementFactory().createAdPlacement(withAdNetwork: adNetwork, withViewController: self, withAdPlacementDelegate: self) else { return }
        adPlacement = placement
        adPlacement.loadAd()
    }
    
    func removeAllSubviews(from view: UIView) {
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
    }
    
}

extension SearchCityViewController: AdPlacementDelegate {
    
    func adPlacementDidLoad() {
        removeAllSubviews(from: mRectContainerView)
        guard let adView = adPlacement.adView() else { return }
        mRectContainerView.addSubview(adView)
        mRectContainerView.isHidden = false
    }
    
    func adPlacementDidFail(withError error: Error) {
        mRectContainerView.isHidden = true
    }
    
    func adPlacementDidTrackImpression() {
        
    }
    
    func adPlacementDidTrackClick() {
        removeAllSubviews(from: mRectContainerView)
        mRectContainerView.isHidden = true
    }
    
}
