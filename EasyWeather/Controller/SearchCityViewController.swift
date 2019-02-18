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
    
    var cityName: String!
    var cityID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCityTextField.inputAccessoryView = Bundle.main.loadNibNamed("CustomAccessoryView", owner: self, options: nil)?.first as! UIView?
        searchCityTextField.theme.font = UIFont(name: "AvenirNext-Regular", size: 15)!
        searchCityTextField.theme.fontColor = #colorLiteral(red: 0.4509803922, green: 0.4, blue: 0.6823529412, alpha: 1)
        searchCityTextField.theme.borderColor = #colorLiteral(red: 0.4509803922, green: 0.4, blue: 0.6823529412, alpha: 1)
        searchCityTextField.theme.separatorColor = #colorLiteral(red: 0.4509803922, green: 0.4, blue: 0.6823529412, alpha: 1)
        searchCityTextField.maxNumberOfResults = 5
        searchCityTextField.minCharactersNumberToStartFiltering = 3
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
    
}
