//
//  UiState.swift
//  KsynicSwift
//
//  Created from Kotlin version
//

import Foundation

/**
 * Базовый класс для состояний UI
 */
enum UiState<T> {
    /**
     * Начальное состояние (загрузка еще не началась)
     */
    case idle
    
    /**
     * Состояние загрузки
     */
    case loading
    
    /**
     * Состояние успеха с данными
     */
    case success(T)
    
    /**
     * Состояние ошибки
     */
    case error(message: String?, error: Error?)
}


