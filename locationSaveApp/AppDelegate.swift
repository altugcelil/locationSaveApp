//
//  AppDelegate.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 16.08.2024.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

       lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "PlaceModel")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()

       func saveContext () {
           let context = persistentContainer.viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyBKeJxea0-ramsRN9mxuVfpASCeXSml_XA")
        GMSPlacesClient.provideAPIKey("AIzaSyDt_UIM9JrEr0vX_l_NUjGquIEZC5WW_Uo")
        setLanguage()

        return true
    }
    
    func setLanguage() {
        let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "tr"
        Bundle.setLanguage(selectedLanguage)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        windowScene.windows.first?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
extension Bundle {
    private static var bundle: Bundle!

    public static func setLanguage(_ language: String) {
        objc_setAssociatedObject(Bundle.main, &bundle, language, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        let isLanguageRTL = Locale.characterDirection(forLanguage: language) == .rightToLeft
        UIView.appearance().semanticContentAttribute = isLanguageRTL ? .forceRightToLeft : .forceLeftToRight
        
        object_setClass(Bundle.main, BundleEx.self)
    }
    
    @objc class BundleEx: Bundle {
        override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
            guard let bundleIdentifier = objc_getAssociatedObject(self, &Bundle.BundleEx.bundle) as? String,
                  let bundlePath = Bundle.main.path(forResource: bundleIdentifier, ofType: "lproj"),
                  let bundle = Bundle(path: bundlePath) else {
                print("Hata: Belirtilen dil dosyası bulunamadı - \(bundleIdentifier)")
                return super.localizedString(forKey: key, value: value, table: tableName)
            }
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}
