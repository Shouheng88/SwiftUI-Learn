//
//  NotificationView.swift
//  AwesomeSwift
//
//  Created by 王守恒 on 2022/11/3.
//

import SwiftUI
import NotificationBannerSwift
//import Rswift

/// 通知示例
struct NotificationBannerView: View {
    
    @State private var banner: NotificationBanner?
    
    var body: some View {
        VStack {
            Button(R.string.localizable.banner_success_type()) {
                self.banner?.dismiss()
                // 对这样超长的文本的展示并不友好：以跑马灯的形式瞬间转过，根本看不清展示了什么
                self.banner = NotificationBanner(
                    title: "This is a title for the notification banner.",
                    subtitle: "This is a sub title for the notification banner test. What do you think about this feature and the text layout on this view ?? Tell me if you have any question by sending me an email: shouheng2020@gmail.com.",
                    style: .success
                )
                self.banner?.show()
            }.frame(height: 40)
            
            Button(".danger 类型的通知") {
                self.banner?.dismiss()
                self.banner = NotificationBanner(title: "Title", subtitle: "subtitle", style: .danger)
                self.banner?.show()
            }.frame(height: 40)
            
            Button("自定义左侧按钮类型通知") {
                self.banner?.dismiss()
                self.banner = NotificationBanner(
                    title: "Title",
                    subtitle: "subtitle",
                    leftView: UIImageView().then({
                        $0.image = R.image.heart_diamond()!
                    }),
                    style: .danger, colors: CustomBannerColors())
                self.banner?.show()
            }.frame(height: 40)
            
            Button("自定义右侧按钮类型通知") {
                self.banner?.dismiss()
                self.banner = NotificationBanner(
                    title: "Title",
                    subtitle: "subtitle",
                    rightView: UIImageView().then({
                        $0.image = R.image.heart_lock()!
                    }),
                    style: .danger, colors: CustomBannerColors())
                self.banner?.show()
            }.frame(height: 40)
            
            Button("自定义类型通知") {
                self.banner?.dismiss()
                // NotificationBanner 内部会取 customView 的 backgroundColor 作为自己的 backgroundColor
                self.banner = NotificationBanner(customView: UITextView().then({
                    $0.text = "This is a simple custom view."
                    $0.backgroundColor = UIColor(.gray)
                }))
                self.banner?.show()
            }.frame(height: 40)
            
            Button(".info 类型的底部弹出的通知") {
                self.banner?.dismiss()
                self.banner = NotificationBanner(title: "Title", subtitle: "subtitle", style: .info)
                self.banner?.show(bannerPosition: .bottom)
            }.frame(height: 40)
            
            Spacer()
        }.navigationTitle(R.string.localizable.banner_test_entry())
    }
}

class CustomBannerColors: BannerColorsProtocol {
    func color(for style: BannerStyle) -> UIColor {
        return UIColor.gray
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationBannerView()
    }
}
