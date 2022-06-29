//
//  InitView.swift
//  PaceKeeper
//
//  Created by 김동락 on 2022/06/29.
//

import SwiftUI

struct InitView: View {
    @State var isLinkActive: Bool = false
    @FocusState var isFocused: Bool?
    @State var weight: String = ""
    @State var savedWeight = UserDefaults.standard.integer(forKey: "weight")
    
    init() {
        UITextView.appearance().backgroundColor = .clear
        UserDefaults.standard.set(true, forKey: "launchedBefore2")
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("몸무게 입력")
                .font(.system(size: 30, weight: Font.Weight.bold))
                .foregroundColor(Color(hex: "03045E"))
            Text("소모 칼로리 계산을 위해 몸무게를 \n입력해주세요.")
                .font(.system(size: 20, weight: Font.Weight.bold))
                .foregroundColor(Color(hex: "0277B6"))
            HStack {
                Text("Kg").opacity(0)
                TextEditor(text: $weight)
                    .font(.system(size: 30, weight: Font.Weight.bold))
                    .multilineTextAlignment(.center)
                    .frame(width: 100, height: 52)
                    .keyboardType(.numberPad)
                Text("Kg")
            }
            .padding(.horizontal)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.blue, lineWidth: 2)
            )
            Spacer()
                .frame(height: 40)
            NavigationLink(destination: MainView(), isActive: $isLinkActive) {
                Button {
                    UserDefaults.standard.set(Int(weight), forKey: "weight")
                    isLinkActive = true
                } label: {
                    Text("시작하기")
                        .font(.system(size: 25, weight: Font.Weight.bold))
                        .frame(width: 120)
                        .padding()
                        .background(Color(hex: "C9F0F8"))
                        .foregroundColor(Color(hex: "03045E"))
                        .cornerRadius(20)
                }
            }
        }
        .padding(15)
        .focused($isFocused, equals: true)
        .onChange(of: weight) { _ in
            if weight.count > 3 {
                weight = String(weight.prefix(3))
            }
        }
    }
}

struct InitView_Previews: PreviewProvider {
    static var previews: some View {
        InitView()
    }
}
