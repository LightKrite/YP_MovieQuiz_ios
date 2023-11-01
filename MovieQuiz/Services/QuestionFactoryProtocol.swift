//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Egor Partenko on 01.11.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
}
