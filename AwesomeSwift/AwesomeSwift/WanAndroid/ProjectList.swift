//
//  WanAndroid.swift
//  AwesomeSwift
//
//  Created by 王守恒 on 2022/11/1.
//

import SwiftUI
//import Rswift
import Foundation

struct ProjectList: View {
    
    @ObservedObject
    private var viewModel: ProjectViewModel = ProjectViewModel()
    @State
    private var scrollToTop: Int = 0
    private let scrollAreaId = "scrollArea"
    @State private var scrollWidth: CGFloat? = 0
    @State private var scrollOffset: CGFloat? = 0
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.statusBarStyle) var statusBarStyle
    @State private var lightStatusBar: Bool? = nil

    private var loadingMoreView: some View {
        Text(NSLocalizedString("wna_android_pull_to_load", comment: ""))
            .onAppear(perform: {
                viewModel.request()
            })
    }
    
    private var projectListView: some View {
        ZStack {
            ScrollViewReader(content: { proxy in
                ScrollView {
                    GeometryReader { proxy in
                        let frame = proxy.frame(in: .named(scrollAreaId))
                        let offset = frame.minY
                        let width = frame.width
                        Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                        Color.clear.preference(key: WidthPreferenceKey.self, value: width)
                    }
                    LazyVStack(spacing: 0) {
                        Image(uiImage: R.image.the_soup()!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .clipped()
                        ForEach(viewModel.projects) { project in
                            NavigationLink(destination: {
                                WebView(url: project.link ?? "")
                                    .navigationTitle(project.title ?? "")
                            }, label: {
                                ProjectRow(project: project)
                            }).id(project.id)
                            let index = viewModel.projects.firstIndex(of: project)
                            if index != viewModel.projects.count - 1 {
                                Divider()
                            }
                        }
                        if viewModel.projects.count > 0 {
                            loadingMoreView
                        }
                    }.onChange(of: scrollToTop, perform: { newValue in
                        proxy.scrollTo(viewModel.projects.first?.id)
                    })
                }
                // 还要加上这个监听的才准确，
                .coordinateSpace(name: scrollAreaId)
                // 属性监听要放到这里才行，放到 scrollview 内部监听不到 ...
                .onPreferenceChange(WidthPreferenceKey.self) { value in
                    self.scrollWidth = value
                }
                .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                    DispatchQueue.main.async {
                        self.scrollOffset = value
                        let _lightStatuBar = (value ?? 0) > -30
                        if self.lightStatusBar != _lightStatuBar {
                            self.lightStatusBar = _lightStatuBar
//                            statusBarStyle.current = _lightStatuBar ? .lightContent : .default
                            // 用这种方式修改状态栏需要在 info 中添加如下属性 View controller-based status bar appearance
                            // 并将值设置为 NO，Xcode 中的设置方式是，Project->Targets->Info->Custom iOS Target Properties
                            UIApplication.shared.statusBarStyle = _lightStatuBar ? .lightContent : .default // invalid
                        }
                    }
                }
            })
            bottomRightFab
        }.onAppear(perform: {
            viewModel.request()
        })
        .background(Rectangle().fill(.white))
        .navigationTitle(R.string.localizable.wan_android())
        .onDisappear { statusBarStyle.current = .default } // 无效
    }
    
    private var bottomRightFab: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.scrollToTop = self.scrollToTop + 1
                }, label: {
                    Image(systemName: "arrow.up.circle")
                        .resizable()
                        .padding(10)
                        .frame(width: 50, height: 50)
                        .background(RoundedRectangle(cornerRadius: 30).fill(.white))
                        .shadow(radius: 0)
                }).shadow(color: .gray, radius: 2, x: 0, y: 3)
            }.padding(.trailing, 8)
        }
    }
    
    private var scrollInfoView: some View {
        VStack {
            HStack {
                Spacer()
                Text("""
                     Scroll info:\nwidth[\(self.scrollWidth ?? 0)]\n
                     offset[\(self.scrollOffset ?? 0)]\n
                     light required[\(String(self.lightStatusBar ?? false))]
                     """)
                    .padding(10)
                    .background(Rectangle().fill(.white))
            }
            Spacer()
        }
    }
    
    private var loadingView: some View {
        Text(NSLocalizedString("wna_android_loading", comment: ""))
    }

    private var emptyView: some View {
        Text(R.string.localizable.wna_android_empty_title())
    }
    
    private func toolbar(proxy: GeometryProxy) -> some View {
        VStack {
            HStack {
                Image(systemName: "chevron.backward")
                    .frame(width: 44, height: 44)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                Spacer()
                // 获取状态栏的高度，用 safeAreaInsets 的信息
            }.frame(height: 44 + proxy.safeAreaInsets.top, alignment: .bottom)
                .background(
                    Rectangle()
                        .fill(.white)
                        .opacity(
                            min(max(-(scrollOffset ?? 0) / 50, 0), 1)
                        )
                )
                .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                    debugPrint("received value \(String(describing: value))")
                }
            Spacer()
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    Color.black.frame(height: 300) // 下拉时露出的黑色背景
                    Spacer() // 避免到底部上拉出现黑色背景
                }
                if viewModel.projects.count == 0 {
                    if viewModel.state == ProjectViewModel.STATE_LOAD_FINISHED {
                        emptyView
                    } else if viewModel.state == ProjectViewModel.STATE_LOADING {
                        loadingView
                    }
                }
                projectListView
                toolbar(proxy: proxy)
                scrollInfoView
//                Button("statusbar", action: {
//                    statusBarStyle.current = .lightContent
//                }).padding(40)
            }.ignoresSafeArea()
        }
        .navigationBarHidden(true)
        // 改变状态栏颜色，可行，但是实际上是改变了整个应用的主题，
        // 返回的时候其他页面会改变，不建议通过这种方式修改状态栏
//        .colorScheme(.light)
//        .preferredColorScheme(lightStatusBar ? .dark : .light)
    }
}

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat? = nil
    
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = value ?? nextValue()
    }
}

struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat? = nil
    
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = nextValue() ?? value
    }
}

struct WanAndroid_Previews: PreviewProvider {
    static var previews: some View {
        ProjectList()
    }
}
