//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Egor Partenko on 01.11.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
