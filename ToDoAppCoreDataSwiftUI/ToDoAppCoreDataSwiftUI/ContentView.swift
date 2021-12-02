//
//  ContentView.swift
//  ToDoAppCoreDataSwiftUI
//
//  Created by 石井滋 on 2021/11/09.
//

import SwiftUI
import CoreData
import  UserNotifications
 
struct ContentView: View {
    
    init() {
            UITextView.appearance().backgroundColor = .clear
        }
    
    @StateObject var viewModel = ViewModel() // viewModel.swift
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)],animation: .spring()) var results : FetchedResults<Task>
    @Environment(\.managedObjectContext) var context
    
    func registerForPushNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge, .provisional]) {granted, error in
            if error == nil {
                center.getNotificationSettings { settings in
                    guard (settings.authorizationStatus == .authorized) || (settings.authorizationStatus == .provisional) else { return }

                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
    }
    
    //通知関係メソッド
    func makeNotification(){
        //通知タイミングを指定
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //通知コンテンツの作成
        let content = UNMutableNotificationContent()
        content.title = "ローカル通知"
        content.body = "ローカル通知です"
        content.sound = UNNotificationSound.default
        
        let date = Date()
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date + 5) //<- 現在時刻から10秒後
        print(dateComponent)
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        //通知リクエストを作成
        let request = UNNotificationRequest(identifier: "notification001", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom), content: {
            NavigationView{
                VStack(spacing:0){
                    if results.isEmpty{
                        Spacer()
                        Text("No Tasks")
                            .font(.title)
                            .foregroundColor(.primary)
                            .fontWeight(.heavy)
                        Spacer()
                    }else{
                   
                        ScrollView(.vertical,showsIndicators: false, content:{
                            LazyVStack(alignment: .leading, spacing: 20){
                                ForEach(results){task in
                                    VStack(alignment: .leading, spacing: 5, content: {
                                        HStack{
                                            if task.imageData?.count ?? 0 != 0{
                                                Image(uiImage: UIImage(data: task.imageData ?? Data.init())!)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 80, height: 80)
                                                    .cornerRadius(10)
                                                    .rotation3DEffect(.degrees(90), axis: (x: 0, y: 0, z: 1))
                                            }
                                            VStack{
//                                                Text(task.date ?? Date(),style: .date)
                                                Text(dateFormat1.string(from: task.date ??  Date()))
                                                    .fontWeight(.bold)
                                                Text("通知期間：\(task.priority)")
                                                    .fontWeight(.bold)
                                            }
                                        }
                                        .padding(.horizontal)
 
                                        Text(task.content ?? "")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .padding(.horizontal)
                                        Divider()
                                    })
                                    .foregroundColor(.primary)
                                    .contextMenu{
                                        Button(action: {
                                            viewModel.EditItem(item: task)
                                        }, label: {
                                            Text("Edit")
                                        })
                                        Button(action: {
                                            context.delete(task)
                                            try! context.save()
                                        }, label: {
                                            Text("Delete")
                                        })
                                    }
                                }
                            }
                            .padding()
                        })
                    }
                }
                .navigationBarTitle("通知一覧", displayMode: .inline)
            }
            Button(action: {viewModel.isNewData.toggle()}, label: {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.green	)
                    .clipShape(Rectangle())
                    .padding()
//                    .overlay(
//                        Text("追加").foregroundColor(.black).font(.subheadline))
            })
        })
        .ignoresSafeArea(.all, edges: .top)
        .background(Color.primary.opacity(0.06).ignoresSafeArea(.all, edges: .all))
        .sheet(isPresented: $viewModel.isNewData,
               onDismiss:{
                viewModelValueReset()
               },
               content: {
            NewDataSheet(viewModel: viewModel)
        })
    }
    
  
    var dateFormat1: DateFormatter {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.calendar = Calendar(identifier: .japanese)
        df.dateFormat = "令和yy年M月dd日(E)"
//        df.dateFormat = "令和yy(YYYY)年M月dd日(E)"

        return df
    }
    
    func viewModelValueReset(){
        viewModel.updateItem = nil
        viewModel.content = ""
        viewModel.date = Date()
        viewModel.priority = 0
        viewModel.imageData = Data.init()
    }
}



//struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
//    }
//
//private func addItem() {
//    withAnimation {
//        let newItem = Item(context: viewContext)
//        newItem.timestamp = Date()
//
//        do {
//            try viewContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//    }
//}
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//}
//
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}

