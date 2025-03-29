//
//  ViewController.swift
//  hw7
//
//  Created by Rory on 2025/3/29.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var currentIndex = 0
    var switchItems: [String] = ["beach", "forest", "rain"]
    var backgroundColors: [UIColor] = [
        UIColor(red: 0.87, green: 0.93, blue: 0.98, alpha: 1.0),
        UIColor(red: 0.56, green: 0.74, blue: 0.56, alpha: 1.0),
        UIColor(red: 0.66, green: 0.66, blue: 0.76, alpha: 1.0)
    ]
    
    var imageBorderColors: [UIColor] = [
        UIColor(red: 0.5, green: 0.8, blue: 0.9, alpha: 1.0),
        UIColor(red: 0.4, green: 0.6, blue: 0.3, alpha: 1.0),
        UIColor(red: 0.4, green: 0.4, blue: 0.6, alpha: 1.0)
    ]
    
    var audioPlayer: AVAudioPlayer?

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainSegment: UISegmentedControl!
    @IBOutlet weak var mainPage: UIPageControl!
    @IBOutlet weak var randomButten: UIButton!
    @IBOutlet weak var volnumSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        volnumSlider.value = 0.7
        
        styleImageView()
        setSwitchItems(currentIndex)
    }
    
    private func styleImageView() {
        mainImageView.layer.cornerRadius = 15
        mainImageView.layer.borderWidth = 3.0
        mainImageView.layer.borderColor = UIColor.white.cgColor
        mainImageView.clipsToBounds = true
        mainImageView.contentMode = .scaleAspectFill
    }
    
    private func setSwitchItems(_ index: Int) {
        currentIndex = index
        mainImageView.image = UIImage(named: switchItems[index])
        mainSegment.selectedSegmentIndex = index
        mainPage.currentPage = index
        
        playAudio(named: switchItems[index])
        
        UIView.animate(withDuration: 1.0) {
            self.view.backgroundColor = self.backgroundColors[index]
            self.mainImageView.layer.borderColor = self.imageBorderColors[index].cgColor
            self.volnumSlider.tintColor = self.imageBorderColors[index]
            self.mainSegment.selectedSegmentTintColor = self.imageBorderColors[index]
            self.randomButten.tintColor = self.imageBorderColors[index]
            self.volnumSlider.thumbTintColor = self.imageBorderColors[index]
        }
    }
    
    private func playAudio(named fileName: String) {
        // Stop any currently playing audio
        audioPlayer?.stop()
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("Could not find audio file named \(fileName).mp3")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1  // -1 無限循環
            
            // Set volume from slider
            audioPlayer?.volume = volnumSlider.value
            
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    @IBAction func mainSegmentChange(_ sender: UISegmentedControl) {
        setSwitchItems(sender.selectedSegmentIndex)
    }
    
    @IBAction func mainPageChange(_ sender: UIPageControl) {
        setSwitchItems(sender.currentPage)
    }
    
    
    @IBAction func swipeRight(_ sender: Any) {
        currentIndex += 1
        if currentIndex >= switchItems.count {
            currentIndex = 0
        }
        setSwitchItems(currentIndex)
    }
    
    @IBAction func swipeLeft(_ sender: Any) {
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = switchItems.count - 1
        }
        setSwitchItems(currentIndex)
    }
    
    @IBAction func randomButton(_ sender: Any) {
        while true {
            let randomIndex = Int.random(in: 0..<switchItems.count)
            if randomIndex != currentIndex {
                setSwitchItems(randomIndex)
                break
            }
        }
    }
    
    @IBAction func VolumeSliderValueChange(_ sender: UISlider) {
        audioPlayer?.volume = sender.value
    }
}


#Preview {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateInitialViewController()!
}
