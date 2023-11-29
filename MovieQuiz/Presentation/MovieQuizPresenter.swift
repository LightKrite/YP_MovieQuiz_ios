//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Egor Partenko on 29.11.2023.
//

import UIKit


final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StaticticServiceProtocol!
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticServiceImpl()
        questionFactory = QuestionFactoryImpl(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
        }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
        }
        
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
        }
    
    func yesButtonClicked() {
        answerGived(answer: true)
        viewController?.buttonsDisabled()
    }
    
    func noButtonClicked() {
        answerGived(answer: false)
        viewController?.buttonsDisabled()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
               return QuizStepViewModel(
                image: UIImage(data: model.image) ?? UIImage() ,
                   question: model.text,
                   questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
           }
    
    func isLastQuestion() -> Bool {
            currentQuestionIndex == questionsAmount - 1
        }
        
        func restartGame() {
            currentQuestionIndex = 0
            correctAnswers = 0
            questionFactory?.requestNextQuestion()
        }
        
        func switchToNextQuestion() {
            currentQuestionIndex += 1
        }
        
        func didAnswer(isCorrectAnswer: Bool) {
            if (isCorrectAnswer) {
                correctAnswers += 1
            }
        }

    func makeResultsMessage() -> String {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let bestGame = statisticService.bestGame
            
            let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
            let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
            let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
            + " (\(bestGame.date.dateTimeString))"
            let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            let resultMessage = [
                currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
            ].joined(separator: "\n")
            
            return resultMessage
        }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
            guard let question = question else {
                return
            }
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.show(quiz: viewModel)
            }
        }
    
    private func proceedWithAnswer(isCorrect: Bool){
           
           didAnswer(isCorrectAnswer: isCorrect)
           
           viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
               guard let self = self else { return }
               self.viewController?.buttonsEnabled()
               self.viewController?.removeImageBorder()
               self.proceedToNextQuestionOrResults()
           }
       }

    private func proceedToNextQuestionOrResults() {
            if self.isLastQuestion() {
                let text = "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
                
                
                let viewModel = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    text: text,
                    buttonText: "Сыграть ещё раз")
                    viewController?.showResult(quiz: viewModel)
            } else {
                self.switchToNextQuestion()
                questionFactory?.requestNextQuestion()
            }
        }
    
    private func answerGived(answer: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = answer
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
