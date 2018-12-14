
import UIKit
import CoreData

var appDelegate = UIApplication.shared.delegate as! AppDelegate
var managedContext = appDelegate.persistentContainer.viewContext

class ViewController: UIViewController {

    //var people: [NSManagedObject] = []

    var personCounter : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnSaveClicked(_ sender: UIButton) {
        self.saveData()
    }
    
    @IBAction func btnUpdateClicked(_ sender: UIButton) {
        self.updateData()
    }
    
    @IBAction func btnDeleteClicked(_ sender: UIButton) {
        self.deleteData()
    }
    
    @IBAction func btnFetchClicked(_ sender: UIButton) {
        self.fetchData()
    }
    
    
    func saveData(){
        personCounter = personCounter + 1
        let entityDescription = NSEntityDescription.entity(forEntityName: "Users", in: managedContext)
        let newUser = NSManagedObject(entity: entityDescription!, insertInto: managedContext)
        
        
        newUser.setValue("\(NSNumber(integerLiteral: personCounter))", forKey: "userId")

        newUser.setValue("ABCD\(personCounter)", forKey: "name")
        newUser.setValue("ABCD\(personCounter)@gmail.com", forKey: "email")
        
        print("==== Save ====")
        do {
            try managedContext.save()
            //people.append(managedContext)
        } catch {
            print(error)
        }
    }
    
    
    func fetchData(){
        print("fetch data")
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Users")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if ((results.count) > 0) {
                print("result is \(results)")
                let  userArr = results as! [NSManagedObject]
                

                for user in userArr {
                    print("\nUserId : ",user.value(forKey: "userId") as! String)
                    print("\nUserName : ",user.value(forKey: "name") as! String)
                    print("\nEmail : ",user.value(forKey: "email") as! String)
                    
//                    print(user.songId)
//                    print(song.songName)
//                    print(song.songUrl)
                }
            }else{
                print("No users found")
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    
    
    
    func deleteData(){
        //https://cocoacasts.com/how-to-delete-every-record-of-a-core-data-entity/
        
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Users")
        fetchRequest.predicate = NSPredicate.init(format: "userId==1")
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(batchDeleteRequest)
        } catch {
            // Error Handling
        }
        
    }
    
    func updateData(){
        //http://stackoverflow.com/questions/26345189/how-do-you-update-a-coredata-entry-that-has-already-been-saved-in-swift
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Users")
        fetchRequest.predicate = NSPredicate.init(format: "userId==2")
        do{
            if let fetchResults = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count != 0{
                    
                    let managedObject = fetchResults[0]
                    managedObject.setValue("MyUser2", forKey: "name")
                    try managedContext.save()
                    
                    
                }
            }
        }catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }

}

