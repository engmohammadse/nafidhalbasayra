//
//  CoreDataNotificationViewModel.swift
//  nafidhalbasayra
//
//  Created by muhammad on 15/04/2025.
//





import CoreData

class CoreDataNotificationViewModel: ObservableObject {
    static let shared = CoreDataNotificationViewModel()
    
    private let coreDataManager = CoreDataManager.shared


    @Published var savedEntitiesNotification: [AppNotification] = []

    private init() {
       
        fetchNotifications()
    }

    func fetchNotifications() {
        let request = NSFetchRequest<AppNotification>(entityName: "AppNotification")
        do {
            savedEntitiesNotification = try coreDataManager.viewContext.fetch(request)
        } catch {
            // تجاهل الخطأ بصمت أو أضف معالجة لاحقًا إن احتجت
        }
    }

    func addNotification(from model: NotificationModel) {
        let newNotification = AppNotification(context: coreDataManager.viewContext)
        newNotification.id = UUID()
        newNotification.title = model.title
        newNotification.body = model.body
        newNotification.sender = model.sender
        newNotification.date = model.createdAt
        newNotification.idFromServer = model._id

        saveContext()
    }

    func deleteAllNotifications() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "AppNotification")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try coreDataManager.viewContext.execute(batchDeleteRequest)
            try coreDataManager.viewContext.save()
            savedEntitiesNotification.removeAll()
        } catch {
            // تجاهل الخطأ بصمت أو أضف معالجة لاحقًا إن احتجت
        }
    }

    func saveContext() {
        do {
            try coreDataManager.viewContext.save()
            fetchNotifications()
        } catch {
            // تجاهل الخطأ بصمت أو أضف معالجة لاحقًا إن احتجت
        }
    }
}
