//
//  PokeCell.swift
//  pokedex
//
//  Created by Ari Mendelow on 4/16/17.
//  Copyright © 2017 Ari Mendelow. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {

    //be able to modify the image and label, make IBOutlets:
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    //for each pokecell, want to create a class of pokemon that's stored in it
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    //want to make a function that will be called when we're ready to update each collection view cell
    func configureCell(_ pokemon: Pokemon) {
        
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexID)")
        
    }
    

}
