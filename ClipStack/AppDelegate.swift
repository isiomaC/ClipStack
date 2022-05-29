//
//  AppDelegate.swift
//  ClipStack
//
//  Created by Chuck on 12/03/2022.
//

import UIKit
import CoreData
import BackgroundTasks


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?
    var coordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        startApp()
        
        cancelAllPandingBGTask()
        registerBackGroundTasks()
        
        let _ = PasteBoardManager.shared //initialize pasteboard changeCount
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        cancelAllPandingBGTask()
        
//        scheduleTask(taskId: BackgroundIds.appRefresh)
        scheduleTask(taskId: BackgroundIds.bgCopy)
        
    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "ClipStack")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveContext (completion: @escaping (Result<Bool, NSError>) -> Void) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(.success(true))
            } catch {
                let nserror = error as NSError
                completion(.failure(nserror))
            }
        }
    }
    
    // MARK: - Start Application Functions
    
    func startApp() {
        
        let launchScreenStoryboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
            
         _ = launchScreenStoryboard.instantiateViewController(withIdentifier: "LaunchScreen")
        
        self.coordinator = MainCoordinator.shared
        self.window = UIWindow(frame: Dimensions.screenSize)
        
//        guard let isAuth = coordinator?.isUserAuthenticated() else {
//            self.window?.rootViewController = coordinator?.getLogin()
//            self.window?.makeKeyAndVisible()
//            return
//        }
        
        self.window?.rootViewController = TabBarController()
        self.window?.makeKeyAndVisible()
        UIView.transition(with: self.window!,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }

        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }

}


//Background tasks
extension AppDelegate {
    
    private func registerBackGroundTasks(){
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: BackgroundIds.bgCopy, using: nil) {
            task in
             self.handleBackgroundCopy(task: task as! BGProcessingTask)
        }
        
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: BackgroundIds.appRefresh, using: nil) { task in
//             self.handleAppRefresh(task: task as! BGAppRefreshTask)
//        }
    }
    
    private func cancelAllPandingBGTask() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
    
    private func handleAppRefresh(task : BGAppRefreshTask){
        
        //schedule another app refresh
        scheduleTask(taskId: BackgroundIds.appRefresh)
        
        // Create an operation that performs the main part of the background task.
        

        // Provide the background task with an expiration handler that cancels the operation.
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

        task.setTaskCompleted(success: true)
    }
    
    private func handleBackgroundCopy(task: BGProcessingTask){
        scheduleTask(taskId: BackgroundIds.bgCopy)
        
        let pasteBoardManager = PasteBoardManager.shared
        
        let pasteboard = pasteBoardManager.mPasteBoard
        
        if pasteboard.changeCount > pasteBoardManager.currentChangeCount{
            
            let presenter = CopyItemsPresenter()
            
            let (type, content) = presenter.prepareDataToSave(pasteboard: pasteboard)
            
            let mDate = Date()
            
            //save data
            let newCopyItem = CopyItemDTO(
                color: "systemBlue",
                content: content,
                dateCreated: mDate,
                dateUpdated: mDate,
                folderId: UUID(),
                id: UUID(),
                keyId: UUID(),
                title: "test_title",
                type: type)
            
            presenter.save(newCopyItem) { [weak self] success in
                guard let saveSuccess = success, let _ = self else{
                    return
                }
                if saveSuccess {
                    print("Save Success")
                }
            }
        }
        
        task.expirationHandler =  { () in
            task.setTaskCompleted(success: false)
        }
       
        task.setTaskCompleted(success: true)
    }
    
    
    //MARK: - Schedule Tasks
    func scheduleTask(taskId: String){
       
        var request: BGProcessingTaskRequest?
        
        if taskId == BackgroundIds.bgCopy{
            request = BGProcessingTaskRequest(identifier: taskId)
            request?.earliestBeginDate = Date(timeIntervalSinceNow: 2 * 60)
            (request)?.requiresNetworkConnectivity = false
            (request)?.requiresExternalPower = false
        }
        
             
        do {
            
            if(taskId == BackgroundIds.bgCopy){
                try BGTaskScheduler.shared.submit(request!)
            }
           
        } catch {
           print("Could not schedule app refresh: \(error)")
        }
    }
    
}
