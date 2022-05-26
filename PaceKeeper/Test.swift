//
//  Test.swift
//  PaceKeeper
//
//  Created by 김동락 on 2022/05/26.
//

import SwiftUI
import Combine

//struct TestView: View{
//    @State var testClass = TestClass()
//    let timer = Timer.publish(every: 1.0, on: .main, in: .default).autoconnect()
//    @State var time = ""
//    @State var bbb = 0
//
//    var body: some View{
//        VStack{
//            Button(action:{
//                testClass.start()
//            }){
//                Text("aaa 증가")
//            }
//            Text("aaa: \(testClass.aaa)")
//            Text("bbb: \(bbb)")
//            Text(time)
//                .onReceive(timer) { _ in bbb = testClass.aaa }
//        }
//    }
//}
//
//class TestClass{
//    var aaa = 0
//    func start(){
//        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ timer in
//            self.aaa += 1
//            print("aaa in testclass: \(self.aaa)")
//        }
//    }
//}
//
//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView()
//    }
//}

struct TestView: View{
    @ObservedObject var testClass = TestClass()
    
    var body: some View{
        VStack{
            Button(action:{
                testClass.start()
            }){
                Text("aaa 증가")
            }
            Text("aaa: \(testClass.aaa)")
        }
    }
}

class TestClass: ObservableObject{
    @Published var aaa = 0
    func start(){
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ timer in
            self.aaa += 1
            print("aaa in testclass: \(self.aaa)")
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
