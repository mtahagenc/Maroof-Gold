//
//  DataModel.swift
//  Maroof Gold
//
//  Created by Muhammet Taha Genç on 23.06.2021.
//

import Foundation

struct PriceModel: Codable {
    let meta: Meta?
    let data: Data?
}

struct Meta: Codable {
    let time: Int?
    let time_formatted: String?
    let fiyat_yayini: String?
    let fiyat_guncelleme: Int?
}

struct Data: Codable {
    let USDTRY: USDTRY?
    let EURTRY: EURTRY?
    let ALTIN: ALTIN?
}

struct USDTRY: Codable {
    let code : String?
    let alis : String?
    let satis : String?
    let tarih : String?
//    let dir : Dir?
//    let dusuk : Float?
//    let yuksek : Float?
//    let kapanis : Float?
}

struct EURTRY: Codable {
    let code : String?
    let alis : String?
    let satis : String?
    let tarih : String?
//    let dir : Dir?
//    let dusuk : Float?
//    let yuksek : Float?
//    let kapanis : Float?
}

struct ALTIN: Codable {
    let code : String?
    let alis : String?
    let satis : String?
    let tarih : String?
//    let dir : Dir?
//    let dusuk : Float?
//    let yuksek : Float?
//    let kapanis : Float?
}

struct Dir: Codable {
    let alis_dir : String
    let satis_dir : String
}
