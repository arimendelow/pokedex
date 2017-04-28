//
//  Pokemon.swift
//  pokedex
//
//  Created by Ari Mendelow on 4/16/17.
//  Copyright © 2017 Ari Mendelow. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexID: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonURL: String!
    
    var nextEvolutionLvl: String {
        
        if _nextEvolutionLvl == nil {
            
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    var nextEvolutionID: String {
        
        if _nextEvolutionID == nil {
            
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
    
    var nextEvolutionName: String {
        
        if _nextEvolutionName == nil {
            
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var description: String {
        
        if _description == nil {
            
            _description = "na"
        }
        
        return _description
    }
    
    var type: String {
        
        if _type == nil {
            
            _type = "na"
        }
        
        return _type
    }
    
    var defense: String {
        
        if _defense == nil {
            
            _defense = "na"
        }
        
        return _defense
    }
    
    var height: String {
        
        if _height == nil {
            
            _height = "na"
        }
        
        return _height
    }
    
    var weight: String {
        
        if _weight == nil {
            
            _weight = "na"
        }
        
        return _weight
    }
    
    var attack: String {
        
        if self._attack == nil {
            
            _attack = "na"
        }
        
        return _attack
    }
    
    var nextEvolutionTxt: String {
        
        if _nextEvolutionTxt == nil {
            
            _nextEvolutionTxt = "na"
        }
        
        return _nextEvolutionTxt
    }
    
    var name: String {
        
        return _name
    }
    
    var pokedexID: Int {
        
        return _pokedexID
    }
    
    //initializer for all new pokemon objects
    init(name: String, pokedexID: Int) {
        
        self._name = name
        self._pokedexID = pokedexID
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexID)/"
        
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            //all the date we're going to get back will be in response
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    
                    self._defense = "\(defense)"
                }
                
                print(self.weight)
                print(self.height)
                print(self.attack)
                print(self.defense)
                
                //types
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                    
                    if let name = types[0]["name"] { //if there is at least one type, do this with the first type
                        
                        self._type = name.capitalized
                        
                    }
                    
                    if types.count > 1 { //if there's more than one tpye, do this with the rest of the types
                        
                        for x in 1..<types.count {
                            
                            if let name = types[x]["name"] {
                                
                                self._type! += "/\(name.capitalized)" //add type n with a slash
                            }
                        }
                    }
                    
                } else {
                    
                    self._type = "" //no type
                }
                
                //description
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>], descArr.count > 0 {
                    
                    if let URL = descArr[0]["resource_uri"] { //not a typo, that's an i
                        
                        let descURL = "\(URL_BASE)\(URL)"
                        
                        Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                            
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon") //for some reason, in some of the descriptions it says POKMON instead of pokemon
                                    
                                    self._description = newDescription
                                    print(newDescription)
                                }
                            }
                            
                            completed()
                        })
                    } else {
                        
                        self._description = "" //in case no description
                        
                    }
                    
                    //evolutions
                    if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                        
                        if let nextEvo = evolutions[0]["to"] as? String {
                            
                            //make sure that we're only using evolutions that arent "mega"
                            if nextEvo.range(of: "mega") == nil {
                                
                                self._nextEvolutionName = nextEvo
                                
                                if let uri = evolutions[0]["resource_uri"] as? String {
                                    
                                    let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon", with: "")
                                    let nextEvoID = newStr.replacingOccurrences(of: "/", with: "")
                                    
                                    self._nextEvolutionID = nextEvoID
                                    
                                    print("next evo ID: \(self._nextEvolutionID)")
                                    
                                    if let lvlExists = evolutions[0]["level"] {
                                        
                                        if let lvl = lvlExists as? Int {
                                            
                                            self._nextEvolutionLvl = "\(lvl)"
                                        }
                                        
                                    } else {
                                        
                                        self._nextEvolutionLvl = ""
                                    }
                                }
                                
                            }
                            
                        }
                    }
                    
                }
                
                print(self._type)
                
            }
            
            completed()
        }

    }
    
}
