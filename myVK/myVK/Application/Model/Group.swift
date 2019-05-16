//
//  Group.swift
//  myVK
//
//  Created by Дмитрий Яровой on 14/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import Foundation

struct Group: Hashable {
    
    var nameGroup : String
    var nameIcon : String
    static var userGroupsArray = [Group]()
    static var allGroupsArray = [
        Group(nameGroup: "iOS Developers", nameIcon: "appleIcon"),
        Group(nameGroup: "Free Rider", nameIcon: "freeRiderIcon"),
        Group(nameGroup: "Saratov News", nameIcon: "saratovNewsIcon"),
        Group(nameGroup: "Tattoo", nameIcon: "tattooIcon"),
        Group(nameGroup: "GeekBrains", nameIcon: "geekIcon"),
        Group(nameGroup: "Байкерский журнал СВОБОДНАЯ ДОРОГА", nameIcon: "freeRoadIcon"),
        Group(nameGroup: "Запчасти Geely Запчасти Джили", nameIcon: "geelyIcon"),
        Group(nameGroup: "ФИЛЬМЫ УЖАСОВ", nameIcon: "horrorIcon"),
        Group(nameGroup: "Мой Алабай.", nameIcon: "alabayIcon"),
        Group(nameGroup: "Чоппер или мото без пластмассы", nameIcon: "chopperIcon"),
        Group(nameGroup: "Route 66", nameIcon: "route66Icon"),
        Group(nameGroup: "Читатели Чака Паланика", nameIcon: "palahniukIcon"),
        Group(nameGroup: "Мир Высоких Технологий", nameIcon: "peaceITIcon"),
        Group(nameGroup: "Beard custom studio", nameIcon: "beardIcon"),
        Group(nameGroup: "Falcon Tuning", nameIcon: "falconIcon")
    ]
}
