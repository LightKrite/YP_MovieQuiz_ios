//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Egor Partenko on 14.11.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetter(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}
