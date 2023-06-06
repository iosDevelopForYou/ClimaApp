//
//  WeatherManager.swift
//  Clima
//
//  Created by Marat Guseynov on 30.05.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

// 4a91a0ae012928b2d3a705fcdf5e27e5

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, WeatherManagerDelegate {
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    private let lightBackGroundView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "background")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var gpsButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.addTarget(self, action: #selector(gpsButtonPressed), for: .touchUpInside)
        return button
    }()
    @objc func gpsButtonPressed(_ sender: UIButton) {
        sender.alpha = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1.0
        }
        locationManager.requestLocation()
    }
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        
        return button
    }()
    @objc func searchButtonPressed(_ sender: UIButton) {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        sender.alpha = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1.0
        }
    }
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 25)
        textField.textColor = .label
        textField.delegate = self
        textField.becomeFirstResponder()
        textField.placeholder = "Search"
        textField.textAlignment = .right
        textField.autocapitalizationType = .words
        return textField
    }()
    
    
    private let conditionImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage.init(systemName: "sun.max")
        view.tintColor = UIColor(named: "weatherColor")
        return view
    }()
    
    private let tempValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "21"
        label.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()
    
    private let degreeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "°"
        label.font = UIFont.systemFont(ofSize: 80, weight: .light)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()
    
    private let celsiusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "C"
        label.font = UIFont.systemFont(ofSize: 80, weight: .light)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "London"
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private let clearView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        view.isOpaque = true
        view.autoresizesSubviews = true
        view.clearsContextBeforeDrawing = true
        view.alpha = 1
        return view
    }()
    
    func addViewLayout() {
        view.addSubview(lightBackGroundView)
        view.addSubview(gpsButton)
        view.addSubview(searchButton)
        view.addSubview(searchTextField)
        view.addSubview(conditionImageView)
        view.addSubview(celsiusLabel)
        view.addSubview(degreeLabel)
        view.addSubview(tempValueLabel)
        view.addSubview(cityLabel)
        view.addSubview(clearView)
        
        NSLayoutConstraint.activate([
            lightBackGroundView.topAnchor.constraint(equalTo: view.topAnchor),
            lightBackGroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lightBackGroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lightBackGroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            gpsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gpsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            gpsButton.widthAnchor.constraint(equalToConstant: 40),
            gpsButton.heightAnchor.constraint(equalToConstant: 40),
            
            searchButton.topAnchor.constraint(equalTo: lightBackGroundView.safeAreaLayoutGuide.topAnchor),
            searchButton.trailingAnchor.constraint(equalTo: lightBackGroundView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            searchButton.widthAnchor.constraint(equalToConstant: 40),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            
            searchTextField.topAnchor.constraint(equalTo: lightBackGroundView.safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: gpsButton.trailingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -10),
            
            conditionImageView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 10),
            conditionImageView.trailingAnchor.constraint(equalTo: searchButton.trailingAnchor, constant: 0),
            conditionImageView.widthAnchor.constraint(equalToConstant: 120),
            conditionImageView.heightAnchor.constraint(equalToConstant: 120),
            
            celsiusLabel.topAnchor.constraint(equalTo: conditionImageView.bottomAnchor, constant: 10),
            celsiusLabel.trailingAnchor.constraint(equalTo: conditionImageView.trailingAnchor),
            
            degreeLabel.topAnchor.constraint(equalTo: conditionImageView.bottomAnchor, constant: 10),
            degreeLabel.trailingAnchor.constraint(equalTo: celsiusLabel.leadingAnchor),
            
            tempValueLabel.bottomAnchor.constraint(equalTo: celsiusLabel.bottomAnchor),
            tempValueLabel.trailingAnchor.constraint(equalTo: degreeLabel.leadingAnchor),
            
            cityLabel.topAnchor.constraint(equalTo: celsiusLabel.bottomAnchor, constant: 10),
            cityLabel.trailingAnchor.constraint(equalTo: celsiusLabel.trailingAnchor),
            
            clearView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
            clearView.trailingAnchor.constraint(equalTo: celsiusLabel.trailingAnchor),
            clearView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            clearView.widthAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewLayout()
        weatherManager.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "type smthng"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.tempValueLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
