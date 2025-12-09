//
//  AnimatedTabView.swift
//  ios-learning
//
//  Created by 彭少林 on 2025/12/8.
//

import SwiftUI

/// Selection protocol
protocol AnimatedTabSelectionProtocol: CaseIterable, Hashable{
    var title: String { get }
    var symbolImage: String { get }
}

struct AnimatedTabView<Selection: AnimatedTabSelectionProtocol, Content: TabContent<Selection>>: View {
    @Binding var selection: Selection
    @TabContentBuilder<Selection> var contet : () -> Content
    
    /// View Properties
    @State private var imageViews: [Selection: UIImageView] = [:]
    
    var effects: (Selection) -> [any DiscreteSymbolEffect & SymbolEffect]
    
    var body: some View{
        TabView(selection: $selection){
            contet()
        }
        .tabViewStyle(.tabBarOnly)
        .background(ExtractImageViewsFromTabView{
            imageViews = $0
        })
        .compositingGroup()
        .onChange(of: selection) { oldValue, newValue in
            let symbolEffects = effects(newValue)
            guard let imageView = imageViews[newValue] else { return }
            
            for effect in symbolEffects {
                imageView.addSymbolEffect(effect, options: .nonRepeating)
            }
        }
    }
}

fileprivate struct ExtractImageViewsFromTabView<Value: AnimatedTabSelectionProtocol>: UIViewRepresentable{
    var result: ([Value: UIImageView]) -> ()
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .red
        view.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            if let compostingGroup = view.superview?.superview{
                guard let tabHostingController = compostingGroup.subviews.last else {return}
                guard let tabController = tabHostingController.subviews.first?.next as?
                        UITabBarController else {return}

                extractImageViews(tabController.tabBar)
            }
        }
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    private func extractImageViews(_ tabBar: UITabBar){
        let imageViews = tabBar.subviews(type: UIImageView.self)
        /// filter out on symbol Images
            .filter({$0.image?.isSymbolImage ?? false})
            .filter({isIOS26 ? ($0.tintColor == tabBar.tintColor) : true})
        
        
        var dict: [Value: UIImageView] = [:]
        for tab in Value.allCases{
            if let imageView = imageViews.first(where: {
                $0.description.contains(tab.symbolImage)
            }){
                dict[tab] = imageView
                
            }
        }
        result(dict)
    }
    
    private var isIOS26: Bool{
        if #available(iOS 26, *){
            return true
        }
        return false
    }
    
}

/// Extracting All subviews with the given type!
fileprivate extension UIView{
    func subviews<T: UIView>(type: T.Type) -> [T]{
        subviews.compactMap {$0 as? T} +
        subviews.flatMap { $0.subviews(type: type)}
    }
}


#Preview {
    ContentView()
}
