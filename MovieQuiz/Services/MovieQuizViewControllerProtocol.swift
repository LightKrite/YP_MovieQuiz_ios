//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Egor Partenko on 29.11.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showResult(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    func removeImageBorder()
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func buttonsEnabled()
    func buttonsDisabled()
    
    func showNetworkError(message: String)
}
