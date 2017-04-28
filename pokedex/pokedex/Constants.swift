//
//  Constants.swift
//  pokedex
//
//  Created by Ari Mendelow on 4/23/17.
//  Copyright © 2017 Ari Mendelow. All rights reserved.
//

import Foundation

let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/"

typealias DownloadComplete = () -> () //we're creating a closure to help with the downloading asyncrity 
