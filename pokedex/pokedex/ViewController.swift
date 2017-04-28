//
//  ViewController.swift
//  pokedex
//
//  Created by Ari Mendelow on 4/16/17.
//  Copyright © 2017 Ari Mendelow. All rights reserved.
//

import UIKit
import AVFoundation //for the music thing

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var pokemon = [Pokemon]() //full pokemon array
    var filteredPokemon = [Pokemon]() //filtered pokemon array for when searching
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done //change from default "search" on keyboard to "done"
        
        parsePokemonCSV()
        initAudio()

    }
    
    //get the audio ready
    func initAudio() {
    
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")
        
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 //loop continuously
//            musicPlayer.play()
            musicPlayer.pause()
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
        
    }
    
    func parsePokemonCSV() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            for row in rows {
                
                let pokeID = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexID: pokeID)
                pokemon.append(poke)
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let poke: Pokemon!
            
            if inSearchMode {
                
                poke = filteredPokemon[indexPath.row]
                
            } else {
                
                poke = pokemon[indexPath.row]
                
            }
            
            cell.configureCell(poke)
            
            return cell
            
        } else {
            
            return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon! //var poke of type Pokemon
        
        if inSearchMode {
            
            poke = filteredPokemon[indexPath.row]
            
        } else {
            
            poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            
            return filteredPokemon.count
            
        }
        
        return pokemon.count
    }
        
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }

    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            
            musicPlayer.pause()
            sender.alpha = 0.2 //fade the button
            
        } else {
            
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //if we click search
        view.endEditing(true) //keyboard go away
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            
            collection.reloadData() //repopulate the collection
            
//            view.endEditing(true) //keyboard go away -> disabled this because having it hear means that if you backspace all the search text it hides the keyboard, which i dont like
            
        } else {
            
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased() //can force unwrap it because we already checked to make sure there was something in it
            
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
                //the filtered pokemon list is going to be equal to the origional pokemon list, but filtered
                //$0 is a placeholder for each item in the array
            
            collection.reloadData() //repopulate the collection
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //happens before segue occurs, where we can setup data to be passed between VCs
        
        if segue.identifier == "PokemonDetailVC" {
            
            if let detailsVC = segue.destination as? PokemonDetailVC { //
                
                if let poke = sender as? Pokemon {
                    
                    detailsVC.pokemon = poke
                    
                }
            }
        }
    }

    
}

