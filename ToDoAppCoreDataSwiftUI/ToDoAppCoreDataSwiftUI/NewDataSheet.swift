//
//  NewDataSheet.swift
//  ToDoAppCoreDataSwiftUI
//
//  Created by 石井滋 on 2021/11/09.
//

import SwiftUI
import UserNotifications
 
struct NewDataSheet: View {
    
    
    @ObservedObject var viewModel : ViewModel
    @Environment(\.managedObjectContext) var context
    
    @State var imageData : Data = .init(capacity:0)
    @State var isActionSheet = false
    @State var isImagePicker = false
    @State var source:UIImagePickerController.SourceType = .photoLibrary
    @State var buttonText = "5秒後にローカル通知を発行する"
    
    @State private var image = Image(systemName: "photo")
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    HStack{
                        CameraView(viewModel: viewModel, imageData: $imageData, source: $source, image: $image, isActionSheet: $isActionSheet, isImagePicker: $isImagePicker)
                            .padding(.top,50)
                        NavigationLink(
                            destination: Imagepicker(show: $isImagePicker, image: $imageData, sourceType: source),
                            isActive:$isImagePicker,
                            label: {
                                Text("")
                            })
                    }
                    HStack{
                        Text("名前")
                        TextEditor(text: $viewModel.content)
                            .padding()
                            .background(Color.primary.opacity(0.1))
                            .frame(height: 50)
                        //                            .cornerRadius(10)
                    }
                    .padding()
                    
                    HStack{
                        Text("通知期間")
                        TextField("", value: $viewModel.priority, formatter: NumberFormatter())
                            .padding()
                            .background(Color.primary.opacity(0.1))
                        //                            .cornerRadius(10)
                    }
                    .padding()
                    
                    HStack{
                        Text("登録日")
                        
                        Spacer()
                        DatePicker("", selection:$viewModel.date, displayedComponents:.date)//日付も使用する場合は”displayedComponents:.date”をなくす
                            .labelsHidden()
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                        Spacer()
                        
                    }
                    .padding()
                    
                    Button(action: {viewModel.writeData(context: context)}, label: {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){
                            (granted, error) in
                            if granted {
                                //通知が許可されている場合の処理
                                makeNotification()
                            }else {
                                //通知が拒否されている場合の処理
                                //ボタンの表示を変える
                                buttonText = "通知が拒否されているので発動できません"
                                //1秒後に表示を戻す
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    buttonText = "5秒後にローカル通知を発行する"
                                }
                            }
                        }
                        Label(title:{Text(viewModel.updateItem == nil ? "登録" : "Update")
                                .font(.title)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        },
                              icon: {Image(systemName: "")
                                .font(.title)
                                .foregroundColor(.white)
                        })
                        //                        .padding(.vertical)
                            .frame(width:UIScreen.main.bounds.width - 20)
                            .background(Color.blue)
                        //                        .cornerRadius(10)」
                        
                    })
                        .padding()
                        .disabled(viewModel.content == "" ? true : false)
                        .opacity(viewModel.content == "" ? 0.5 : 1)
                    
                    
                }
            }
        }
        .background(Color.primary.opacity(0.06).ignoresSafeArea(.all, edges: .bottom))
    }
}
