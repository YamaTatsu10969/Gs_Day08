//
//  SceneDelegate.swift
//  GsTodo
//
//  Created by yamamototatsuya on 2020/01/15.
//  Copyright © 2020 yamamototatsuya. All rights reserved.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        #warning("ここに次の記事のコードを記述する。 参考：http://bit.ly/2uwW1nz")
        window = UIWindow(windowScene: scene)
        if let _ = Auth.auth().currentUser {
            // ここで指定する  ViewController が最初に起動する ViewController になる
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateInitialViewController() else {
                print("viewController がないよ。。。")
                return
            }
            window?.rootViewController = vc
        } else {
            window?.rootViewController = LoginViewController()
        }
        window?.makeKeyAndVisible()
        
//        window = UIWindow(windowScene: scene)
//        // ここで指定する  ViewController が最初に起動する ViewController になる
//        window?.rootViewController = LoginViewController()
//        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

