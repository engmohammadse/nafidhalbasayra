//
//  CoreDataNotificationViewModel.swift
//  nafidhalbasayra
//
//  Created by muhammad on 15/04/2025.
//

import CoreData

class CoreDataNotificationViewModel: ObservableObject {
    static let shared = CoreDataNotificationViewModel()

    let container: NSPersistentContainer
    @Published var savedEntitiesNotification: [Notification] = []

    private init() {
        container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { _, _ in }
        fetchNotifications()
    }

    func fetchNotifications() {
        let request = NSFetchRequest<Notification>(entityName: "Notification")
        do {
            savedEntitiesNotification = try container.viewContext.fetch(request)
        } catch {
            // تجاهل الخطأ بصمت أو أضف معالجة لاحقًا إن احتجت
        }
    }

    func addNotification(from model: NotificationModel) {
        let newNotification = Notification(context: container.viewContext)
        newNotification.id = UUID()
        newNotification.title = model.title
        newNotification.body = model.body
        newNotification.sender = model.sender
        newNotification.date = model.createdAt
        newNotification.idFromServer = model._id

        saveContext()
    }

    func deleteAllNotifications() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Notification")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try container.viewContext.execute(batchDeleteRequest)
            try container.viewContext.save()
            savedEntitiesNotification.removeAll()
        } catch {
            // تجاهل الخطأ بصمت أو أضف معالجة لاحقًا إن احتجت
        }
    }

    func saveContext() {
        do {
            try container.viewContext.save()
            fetchNotifications()
        } catch {
            // تجاهل الخطأ بصمت أو أضف معالجة لاحقًا إن احتجت
        }
    }
}
