//
//  QuestionsViewController.swift
//  HW-2.08-DY
//
//  Created by Denis Yarets on 15/10/2023.
//

import UIKit

final class QuestionsViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelProgress: UILabel!
    
    @IBOutlet weak var stackSingle: UIStackView!
    @IBOutlet weak var stackMultiple: UIStackView!
    @IBOutlet weak var stackRanged: UIStackView!
    
    @IBOutlet var buttonsCollectionSingle: [UIButton]!
    @IBOutlet var labelsCollectionMultiple: [UILabel]!
    @IBOutlet var switchesCollectionMultiple: [UISwitch]!
    @IBOutlet var labelsCollectionRanged: [UILabel]!
    @IBOutlet weak var sliderRanged: UISlider!
    
    private let questions = Question.getQuestions()
    private var questionIndex = 0
    private var answersChosen = [Answer]()
    private var answersCurrent: [Answer] {
        questions[questionIndex].answers
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let answerCount = Float(answersCurrent.count - 1)
        sliderRanged.maximumValue = answerCount
        sliderRanged.minimumValue = answerCount / 2
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultVC = segue.destination as? ResultViewController else { return }
        resultVC.answersChosen = answersChosen
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0: 
            guard let buttonIndex = buttonsCollectionSingle.firstIndex(of: sender) else { return }
            let currentAnswer = answersCurrent[buttonIndex]
            answersChosen.append(currentAnswer)
        case 1:
            for (switchMultiple, answer) in zip (switchesCollectionMultiple, answersCurrent) {
                if switchMultiple.isOn {
                    answersChosen.append(answer)
                }
            }
        case 2:
            let index = lrintf(sliderRanged.value)
            answersChosen.append(answersCurrent[index])
        default: return
        }
        
        questionIndex += 1
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "showResultView", sender: nil)
        }
    }
    
}

private extension QuestionsViewController {
    func updateUI() {
        for stackView in [stackSingle, stackMultiple, stackRanged] {
            stackView?.isHidden = true
        }
        
        let currentQuestion = questions[questionIndex]
        labelProgress.text = currentQuestion.title
        let totalProgress = Float(questionIndex) / Float(questions.count - 1)
        progressView.setProgress(totalProgress, animated: true)
        title = "Question \(questionIndex + 1) of \(questions.count)"
        showCurrentAnswers(for: currentQuestion.type)
    }
    
    func showCurrentAnswers(for type: ResponseType) {
        switch type {
        case .single:
            showStackSingle(answers: answersCurrent)
        case .multiple:
            showStackMultiple(answers: answersCurrent)
        case .ranged:
            showStackRanged(answers: answersCurrent )
        }
    }
    
    func showStackSingle(answers: [Answer]) {
        stackSingle.isHidden = false
        
        for (button, answer) in zip(buttonsCollectionSingle, answers) {
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    func showStackMultiple(answers: [Answer]) {
        stackMultiple.isHidden = false
        
        for (label, answer) in zip(labelsCollectionMultiple, answers) {
            label.text = answer.title
        }
    }
    
    func showStackRanged(answers: [Answer]) {
        stackRanged.isHidden = false
        
        labelsCollectionRanged.first?.text = answers.first?.title
        labelsCollectionRanged.last?.text = answers.last?.title
    }
}
