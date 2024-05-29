//
//  ThemeDemoView.swift
//  AwesomeSwift
//
//  Created by 王守恒 on 2022/11/23.
//

import SwiftUI
//import Rswift

/// 主题切换示例
struct ThemeDemoView: View {
    
    private var switchThemeView: some View {
        ZStack {
            VStack {
                Button("切换为亮色主题", action: {
                    UIApplication.shared.windows
                        .first { $0.isKeyWindow }?
                        .overrideUserInterfaceStyle = .light
                }).frame(height: 40)
                Button("切换为暗色主题", action: {
                    UIApplication.shared.windows
                        .first { $0.isKeyWindow }?
                        .overrideUserInterfaceStyle = .dark
                }).frame(height: 40)
                Button("跟随系统", action: {
                    UIApplication.shared.windows
                        .first { $0.isKeyWindow }?
                        .overrideUserInterfaceStyle = .unspecified
                }).frame(height: 40)
                HStack {
                    Rectangle()
                        .fill(Color(R.color.dark_light_sample_color()!))
                        .frame(height: 30)
                }.padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
            }
        }
    }
    
    private var uiInfoSampleView: some View {
        VStack {
            Text("UI Style: \(getTranslatedUIStyle())")
            Text("UI Idiom: \(getTranslatedUIIdiom())")
            Text("UI Layout: \(getTranslatedUILayout())")
        }
    }
    
    private func getTranslatedUIStyle() -> String {
        switch UITraitCollection.current.userInterfaceStyle {
            case .light:
                return "light";
            case .unspecified:
                return "unspecified";
            case .dark:
                return "dark";
            @unknown default:
                return "unknown";
        }
    }
    
    private func getTranslatedUIIdiom() -> String {
        switch UITraitCollection.current.userInterfaceIdiom {
            case .unspecified:
                return "unspecified";
            case .phone:
                return "phone";
            case .pad:
                return "pad";
            case .tv:
                return "tv";
            case .carPlay:
                return "carPlay";
            case .mac:
                return "mac";
            @unknown default:
                return "@unknown";
        }
    }
    
    private func getTranslatedUILayout() -> String {
        switch UITraitCollection.current.layoutDirection {
            case .unspecified:
                return "unspecified";
            case .leftToRight:
                return "leftToRight";
            case .rightToLeft:
                return "rightToLeft";
            @unknown default:
                return "@unknown";
        }
    }
    
    var body: some View {
        ScrollView(content: {
            VStack {
                uiInfoSampleView
                switchThemeView
            }.padding(15)
        }).navigationTitle("主题切换示例").navigationBarTitleDisplayMode(.inline)
    }
}

struct ThemeDemoView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeDemoView()
    }
}
