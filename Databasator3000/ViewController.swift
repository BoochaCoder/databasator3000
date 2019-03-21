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
        vymazStarouDatabazi()
        fillData(csvFileName: "databaze", entityName: "FullEntity")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(getDocumentsDirectory())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }


    
    
    //////////// CORE DATA ///////////
    
    func fillData(csvFileName: String, entityName: String){
        //  Naplní data z csv do DB
        
        let coreDataStack = CoreDataStack()
        let context = coreDataStack.persistentContainer.viewContext
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
            print("CONTEXT NOT SAVED")
        }
    }
    
    func deleteDB(entityName: String) {
        //  Vymaže všechna data v dané položce.
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
        //  Rozparsuje CSVecko a vrátí array plnej dictionaries, kde key je název sloupce a value je hodnota.
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
        //  Vypíše cestu do dokumentů.
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func vymazStarouDatabazi(){
        // Vymaže sqlite file, který by zůstal v dokumentech po předchozím parsování
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let dtbzFileUrlVDokumentech = URL(fileURLWithPath: documentDirectoryPath!).appendingPathComponent("DataBaze")
        
        if FileManager.default.fileExists(atPath: (dtbzFileUrlVDokumentech.path)){
            do{
                try FileManager.default.removeItem(at: dtbzFileUrlVDokumentech)
                print("Mažu starou databázi.")
            }catch{
                print("Nepodařilo se smazat starou databázi v telefonu.")
            }
        }
    }
}

