//
//  NewDataSheet.swift
//  ToDoAppCoreDataSwiftUI
//
//  Created by 石井滋 on 2021/11/09.
//

import SwiftUI
 
struct NewDataSheet: View {
    
    
    @ObservedObject var viewModel : ViewModel
    @Environment(\.managedObjectContext) var context
    
    @State var imageData : Data = .init(capacity:0)
    @State var isActionSheet = false
    @State var isImagePicker = false
    @State var source:UIImagePickerController.SourceType = .photoLibrary
    
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
                        .frame(height: 100)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    HStack{
                        Text("通知期間")
                        TextField("", value: $viewModel.priority, formatter: NumberFormatter())
                            .padding()
                            .background(Color.primary.opacity(0.1))
                            .cornerRadius(10)
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
                        Label(title:{Text(viewModel.updateItem == nil ? "Add Now" : "Update")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        },
                        icon: {Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                        })
                        .padding(.vertical)
                        .frame(width:UIScreen.main.bounds.width - 30)
                        .background(Color.orange)
                        .cornerRadius(50)
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
