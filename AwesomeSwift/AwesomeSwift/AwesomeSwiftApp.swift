//
//  AwesomeSwiftApp.swift
//  AwesomeSwift
//
//  Created by 王守恒 on 2022/10/31.
//

import SwiftUI
//import Rswift
import FirebaseCore
import FirebaseCrashlytics

// 路由框架：https://blog.csdn.net/lizitao/article/details/82223468
@main
struct AwesomeSwiftApp: App {

    init() {
        FirebaseApp.configure()
        // Firebase Crashlytics 使用说明：
        // 按照官网的说明，添加 Firebase Crashlytics 依赖
        // 修改 Build Settings，输出 dSYM 文件
        // 修改 Build Phase，添加上传 dSYM 文件的逻辑
        // 添加崩溃，然后测试，测试的时候需要构建完成并 Stop 再测试，因为处于 debug 状态的时候，xcode 会拦截崩溃
        // 参考：https://firebase.google.com/docs/crashlytics/get-started?platform=ios#add-sdk
        Crashlytics.crashlytics().log("App loaded")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: setupNavigationBar)
                .onAppear(perform: setupStatusBar)
        }
    }
    
    private func setupNavigationBar() {
        // Global configuration for navigation bar
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "arrow.backward")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.backward")
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = .green
        UINavigationBar.appearance().barTintColor = .green

        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            
            // 避免 iOS15 增加的列表顶部空白
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }
    
    private func setupStatusBar() {
        guard
            let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first,
            let statusBarManager = window.windowScene?.statusBarManager
        else { return }
        StatusBarStyle.Key.defaultValue.getter = {
            statusBarManager.statusBarStyle
        }
        StatusBarStyle.Key.defaultValue.setter = {
            /// 暂时还没有找到更好的方法
            UIApplication.shared.statusBarStyle = $0
        }
    }
}
