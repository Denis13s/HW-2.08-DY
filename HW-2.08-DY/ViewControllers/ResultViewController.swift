//
//  ResultViewController.swift
//  HW-2.08-DY
//
//  Created by Denis Yarets on 15/10/2023.
//

import UIKit

final class ResultViewController: UIViewController {
    
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelResult: UILabel!
    @IBOutlet weak var labelPreviousAnswers: UILabel!
    
    var answersChosen: [Answer]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        getResults()
        labelPreviousAnswers.text = returnPreviousAnswers()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonDonePressed() {
        dismiss(animated: true)
    }
    
}

private extension ResultViewController {
    func returnPreviousAnswers() -> String {
        var stroke = "Previous answers:\n"
        var index = 1
        for answer in answersChosen {
            stroke.append("\n\(index). \(answer.title) - \(answer.animal.rawValue)")
            index += 1
        }
        return stroke
    }
    
    func getResults() {
        var results = [Animal: Int]()
        for answer in answersChosen {
            if let currentCount = results[answer.animal] {
                results[answer.animal] = currentCount + 1
            } else {
                results[answer.animal] = 1
            }
        }
        guard let maxResult = results.max(by: { $0.value < $1.value }) else { return }
        
        
        labelResult.text = "You're \(maxResult.key.rawValue)"
        labelDescription.text = "\(maxResult.key.definition)"
    }
}
