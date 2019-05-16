//
//  FriendsModel.swift
//  myVK
//
//  Created by Дмитрий Яровой on 02/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import Foundation

var text1 = """
📢Внимание ❗Внимание!❗ Работают все радиостанции! Передаем важное правительственное сообщение.…
📢Граждане мотолюбители и неравнодушные к двухколесному транспорту под своим седалищем❗
📢Пора избавиться от мототоксикоза! Марш в гараж или где там зимовал ваш железный конь, и провести подготовку друга к новому сезону.
"""
var text2 = "Ты пускаешь его в свою душу... и ещё ни разу об этом не пожалел."
var text3 = "5 часов нон стоп😊🤘🏻"
var text4 = """
Для многих представителей молодого поколения, Ермен стал одной из культовых и ключевых фигур.
Песни Ермена - это дыхание юности, а "Адаптация" из тех групп, которые были близки во времена, "когда все начиналось", и тембр Ермена всякий раз возвращает к светлой такой ностальгии. И, конечно, бешеная энергетика и убежденность - это его козырь.
Чистый и мощный протест, сгусток живой энергии. Это голос совести, безапелляционный, резкий, местами жесткий и злой. Не позволяй заглушить его! Позволь ему прозвучать В ТЕБЕ.
"""
var text5 = "А если дым чёрный, значит, прибор при жизни грешил погрешностью."

struct FriendsModel {
    
    var nameFriend: String
    var fotoFriend: String
    var fotoAlbom: [String]?
    var friendStartChar: String {
        get {
            let startChar = String(secondName.prefix(1))
            return startChar
        }
    }
    var secondName: String {
        get {
            let array = nameFriend.components(separatedBy: " ")
            return array[array.count - 1]
        }
    }
    
    static var sectionName: [String] {
        get {
            var array = [String]()
            for char in FriendsModel.userFriendsArray {
                if !array.contains(char.friendStartChar) {
                    array.append(char.friendStartChar)
                }
            }
            array.sort()
            return array
        }
    }
    
    static var filterFriendsArray = [FriendsModel]()
    
    static var userFriendsArray: [FriendsModel] = [
        FriendsModel(nameFriend: "Михаил Приходько",    fotoFriend: "1", fotoAlbom: ["1", "22", "23"]),
        FriendsModel(nameFriend: "Роман Мотрохов",      fotoFriend: "2", fotoAlbom: ["2", "15", "19"]),
        FriendsModel(nameFriend: "Майя Гёссен",         fotoFriend: "3", fotoAlbom: ["3", "17", "24"]),
        FriendsModel(nameFriend: "Евгения Яровая",      fotoFriend: "4", fotoAlbom: ["4", "13", "21", "34", "35", "36", "37", "38", "39", "40"]),
        FriendsModel(nameFriend: "Валерий Коротков",    fotoFriend: "5", fotoAlbom: ["5", "28", "29"]),
        FriendsModel(nameFriend: "Александр Сергеевич", fotoFriend: "6", fotoAlbom: ["6", "18", "25"]),
        FriendsModel(nameFriend: "Александр Ильин",     fotoFriend: "7", fotoAlbom: ["7", "26", "27"]),
        FriendsModel(nameFriend: "Виктория Рыхлова",    fotoFriend: "8", fotoAlbom: ["8", "12", "16"]),
        FriendsModel(nameFriend: "Ольга Бережнова",     fotoFriend: "9", fotoAlbom: ["9", "32", "33"]),
        FriendsModel(nameFriend: "Сергей Вилков",       fotoFriend: "10", fotoAlbom: ["10", "14", "20"]),
        FriendsModel(nameFriend: "Арина Горожанова",    fotoFriend: "11", fotoAlbom: ["11", "30", "31"])
    ]
    
    var likeCount: Int = 0
    var text: String?
    var newsPhotoName: [String]?
    var creationTime: String?
    var viewedCount: Int = 0
    
    static var newsArray = [
        FriendsModel(nameFriend: "Михаил Приходько",
                fotoFriend: "1",
                text: text1,
                newsPhotoName: ["newsFoto2"],
                like: 32,
                creationTime: "сегодня в 14:55",
                viewedCount: 231),
        FriendsModel(nameFriend: "Евгения Яровая",
                fotoFriend: "4",
                text: text2,
                newsPhotoName: ["newsFoto3"],
                like: 77,
                creationTime: "сегодня в 16:13",
                viewedCount: 333),
        FriendsModel(nameFriend: "Майя Гёссен",
                fotoFriend: "3",
                text: text3,
                newsPhotoName: ["newsFoto1"],
                like: 40,
                creationTime: "сегодня в 20:37",
                viewedCount: 23),
        FriendsModel(nameFriend: "Виктория Рыхлова",
                fotoFriend: "8",
                text: text4,
                newsPhotoName: ["newsFoto4"],
                like: 15,
                creationTime: "вчера в 11:55",
                viewedCount: 277),
        FriendsModel(nameFriend: "Роман Мотрохов",
                fotoFriend: "2",
                text: text5,
                newsPhotoName: ["newsFoto5"],
                like: 2,
                creationTime: "14 мар в 17:28",
                viewedCount: 777),
    ]
    
    init(nameFriend: String, fotoFriend: String, fotoAlbom: [String]) {
        self.nameFriend = nameFriend
        self.fotoFriend = fotoFriend
        self.fotoAlbom = fotoAlbom
    }
    
    init(nameFriend: String, fotoFriend: String, text: String, newsPhotoName: [String], like: Int, creationTime: String, viewedCount: Int) {
        self.nameFriend = nameFriend
        self.fotoFriend = fotoFriend
        self.text = text
        self.newsPhotoName = newsPhotoName
        self.likeCount = like
        self.creationTime = creationTime
        self.viewedCount = viewedCount
    }
    
}
