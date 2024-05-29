//
//  ImageDemoView.swift
//  swiftdemo (iOS)
//
//  Created by 王守恒 on 2022/9/14.
//

//import Rswift
import SwiftUI
import Kingfisher

/// 图片示例
struct ImageDemoView: View {

    @State private var tip: String = ""
    @State private var playLottie: Int = 0

    private var sampleResourceImageView: some View {
        VStack {
            SampleSectionTitleView(title: "1. 资源图片示例")
            HStack {
                Image(uiImage: R.image.heart_lock()!)
                    .onTapGesture {
                        self.tip = "点击了图片"
                    }
                Image(uiImage: R.image.heart_lock()!)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        self.tip = "点击了 30x 图片"
                    }
                Image(uiImage: R.image.heart_lock()!)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        self.tip = "点击了 50x 图片"
                    }.blur(radius: 3)
            }
        }
    }
    
    private var sampleGradientImageView: some View {
        VStack {
            SampleSectionTitleView(title: "2. 渐变图片 Shape 等")
            ScrollView(.horizontal) {
                HStack {
                    LinearGradient(
                        colors: [.red, .green, .blue],
                        startPoint: .top,
                        endPoint: .bottom
                    ).frame(width: 100, height: 100)
                        .overlay(Text("LinearGradient").foregroundColor(.white))
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(.blue)
                        .frame(width: 100, height: 100)
                        .overlay(Text("RoundedRectangle").foregroundColor(.white))
                    Capsule().fill(.red)
                        .frame(width: 150, height: 100)
                        .overlay(Text("Capsule").foregroundColor(.white))
                    Circle().fill(.green)
                        .frame(width: 100, height: 100)
                        .overlay(Text("Circle").foregroundColor(.white))
                }
            }
        }
    }
    
    private var sampleImageEffectView: some View {
        VStack {
            SampleSectionTitleView(title: "3. 图片效果")
            ScrollView(.horizontal) {
                HStack {
                    Image(uiImage: R.image.the_soup()!)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(.blue, lineWidth: 5)
                                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                        )
                    Image(uiImage: R.image.the_soup()!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(.blue, lineWidth: 2)
                                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                        )
                    Image(uiImage: R.image.the_soup()!)
                        .resizable()
                        .scaleEffect()
                        .frame(width: 100, height: 100)
                    Image(uiImage: R.image.the_soup()!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .top)
                        .overlay(Text("顶部"))
//                        .overlay(content: { // This method is only available on 16.0 and newer
//                            Text("Top alignment")
//                        })
                    Image(uiImage: R.image.the_soup()!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .center)
                        .overlay(Text("中间"))
                    Image(uiImage: R.image.the_soup()!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .bottom)
                        .overlay(Text("底部"))
                    Image(uiImage: R.image.the_soup()!)
                        .resizable()
                        .clipShape(ContainerRelativeShape())
                        .frame(width: 100, height: 100)
                    Image(uiImage: R.image.the_soup()!)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                    Image(uiImage: R.image.the_soup()!)
                        .resizable()
                        .clipShape(Ellipse())
                        .frame(width: 100, height: 100)
                    Image(uiImage: R.image.the_soup()!)
                        .resizable()
                        .clipShape(Capsule())
                        .frame(width: 100, height: 100)
                }
            }
        }
    }
    
    private var sampleSystemImageView: some View {
        VStack {
            SampleSectionTitleView(title: "4. 系统内置图片")
            HStack {
                Image(systemName: "3.circle").imageScale(.large)
                Image(systemName: "13.circle").imageScale(.large)
                Image(systemName: "50.circle").imageScale(.large) // max
            }
        }
    }
    
    private var sampleLottieImageView: some View {
        VStack {
            SampleSectionTitleView(title: "5. Lottie 图片", desc: "点击图片可以重新播放动画")
            LottieView(lottieFile: "thank_you", play: self.$playLottie)
                .frame(width: 200, height: 200)
                .onTapGesture {
                    self.playLottie = self.playLottie + 1
                }
        }
    }
    
    private var sampleNetworkImageView: some View {
        VStack {
            SampleSectionTitleView(title: "6. 网络图片加载", desc: "基于三方控件 Kingfisher")
            let size: CGFloat = 200
            ScrollView(.horizontal) {
                HStack {
                    KFImage(URL(string: Consts.SAMPLE_NETOWRK_IMAGE))
                        .renderingMode(.original)
                        .resizable()
                        .placeholder({ progress in
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(.gray.opacity(0.1))
                                .frame(width: size, height: size)
                                .cornerRadius(size / 10)
                        })
                        .scaledToFit()
                        .padding(size / 10)
                        .frame(width: size, height: size)
                        .clipped()
                        .border(.gray.opacity(0.1))
                    KFImage(URL(string: Consts.SAMPLE_NETOWRK_IMAGE))
                        .renderingMode(.original)
                        .resizable()
                        .fade(duration: 500)
                        .placeholder({ progress in
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(.gray.opacity(0.1))
                                .frame(width: size, height: size)
                                .cornerRadius(size / 10)
                        })
                        .padding(size / 10)
                        .frame(width: size, height: size, alignment: .top)
                        .scaledToFit()
                        .clipped()
                        .border(.gray.opacity(0.1))
                }
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("\(self.tip)").foregroundColor(.gray).font(.system(size: 14))
                sampleResourceImageView
                sampleGradientImageView
                sampleImageEffectView
                sampleSystemImageView
                sampleLottieImageView
                sampleNetworkImageView
            }.padding(15)
        }.navigationTitle(Text("图片示例"))
            .navigationBarHidden(false)
            .navigationBarItems(
                leading: Text("头部"),
                trailing: Text("尾部").onTapGesture {
                    self.tip = "点击了尾部"
                }
            )
    }
}

struct ImageDemoView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDemoView()
    }
}
