//
//  ViewController.swift
//  myLocation
//
//  Created by Boocha on 14.04.17.
//  Copyright © 2017 Boocha. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData
import SystemConfiguration
import AVFoundation





//MARK - VC

class ViewController: UIViewController, CLLocationManagerDelegate{
    

    
    //MARK - Outlets
    @IBAction func fillBtn(_ sender: Any) {
        
        //eatShit()
        //prepareToPlay()
        //player2.play()
        
        vymazStarouDatabazi()
        fillData(csvFileName: "databaze", entityName: "FullEntity")
        
        
        
    }
    
    var player2 = AVPlayer()
    
    
    override func viewDidLoad() {
        //co se stane po loadnutí
        
    
        
        super.viewDidLoad()
    
        
        print(getDocumentsDirectory())
        
        
        
        /// Funkce pro plneni DB///
        //parseCSV(fileName: "databaze210118UTF") //rozparsuje csv do formátu [["key":"value","key":"value"], ["key":"value"]]
        //deleteDB(entityName: "FullEntity")
        
        
        //fillData(csvFileName: "letni_hotova", entityName: "FullEntity")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }


    
    
    //////////// CORE DATA by Swift Guy ///////////
    
    func fillData(csvFileName: String, entityName: String){
        //naplní data z csv do DB
        
        let coreDataStack = CoreDataStack()
        //object ze souboru coredatastack
        let context = coreDataStack.persistentContainer.viewContext
        //objekt contex, na kterej se odvolavam
        
        let hodnoty = parseCSV(fileName: csvFileName)
        
        for hodnota in hodnoty{
            let novaPolozka = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
            
            for (key, value) in hodnota{
                
                if let cislo = Int(value){
                    novaPolozka.setValue(cislo, forKey: key)
                }else{
                    novaPolozka.setValue(value, forKey: key)
                }
            }
        }
        
        do{
            try context.save()
            print("SAVED")
        }catch{
            print("ANI PRD")
        }
    }
    
    // FETCHING RESULTS FROM CORE DATA - Swift Guy
    
    
    
    
    func deleteDB(entityName: String) {
        //Vymaže všechna data v dané položce
        let coreDataStack = CoreDataStack()
        let context = coreDataStack.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do{
            try context.execute(request)
            print("Databáze vymazána")
        }catch{
            print(error)
        }
    }
    
   
    
        
    
    
    
    func parseCSV(fileName: String) -> [Dictionary<String, String>]{
        //rozparsuje SCVecko a vrátí array plnej dictionaries, kde key je název sloupce a value je hodnota
        let path = Bundle.main.path(forResource: fileName, ofType: "csv")
        var rows = [Dictionary<String, String>]()
        do {
            let csv = try CSV(contentsOfURL: path!)
            rows = csv.rows
        }catch{
            print(error)
        }
        return rows
    }
    
    
    func getDocumentsDirectory() -> URL {
        //Vypíše cestu do dokumentu
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        //print("Tohle je cesta dle funkce ve VC:  \(documentsDirectory)")
        return documentsDirectory
    }
    
    func eatShit(){
        let path = Bundle.main.path(forResource: "eat", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        print(url)
        let asset = AVAsset(url: url)
        let eatShit = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: eatShit)
        player.volume = 100
        player.play()
        
    }
    
    func prepareToPlay() {
        let path = Bundle.main.path(forResource: "eat", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        // Create asset to be played
        let asset = AVAsset(url: url)
        
        let assetKeys = [
            "playable",
            "hasProtectedContent"
        ]
        // Create a new AVPlayerItem with the asset and an
        // array of asset keys to be automatically loaded
        let playerItem = AVPlayerItem(asset: asset,
                                  automaticallyLoadedAssetKeys: assetKeys)
        

        
        // Associate the player item with the player
        player2 = AVPlayer(playerItem: playerItem)
    }
    
    
    func vymazStarouDatabazi(){
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let dtbzFileUrlVDokumentech = URL(fileURLWithPath: documentDirectoryPath!).appendingPathComponent("DataBaze")
        
        //CHECK ZDA V TELEFONU NENÍ ZASTARALÁ DATABÁZE
        if FileManager.default.fileExists(atPath: (dtbzFileUrlVDokumentech.path)){
            //Přemazávání starých databázi v telefonu při aktualizaci databáze. Pro případ aktualizace a existence staré dtbz v telefonu
            do{
                try FileManager.default.removeItem(at: dtbzFileUrlVDokumentech)
                print("Mažu starou databázi.")
            }catch{
                print("Nepodařilo se smazat starou databázi v telefonu.")
            }
        }
        
        
    }
    
    
    
    
}

