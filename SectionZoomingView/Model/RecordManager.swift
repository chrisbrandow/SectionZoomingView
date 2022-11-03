//
//  RecordManager.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 11/1/22.
//

import Foundation
import CloudKit

enum FetchError {
    case fetchingError
    case noRecords
    case addingError
    case none
}

struct OrderManager {

    static let shared = OrderManager()
    private let RecordType = "DinerOrder"

    func fetchDinerOrders(forDinerIDs dinerIds: [String], completion: @escaping ([CKRecord]?, FetchError) -> Void) {
        let publicDatabase = CKContainer(identifier: "iCloud.com.cbrandow.betterMenu").publicCloudDatabase
        // we *could* do a predicate based on a list of diner ids, but easier just to fetch them all and then filter locally for MVP
        let query = CKQuery(recordType: RecordType, predicate: NSPredicate(value: true))
        publicDatabase.perform(query, inZoneWith: nil, completionHandler: { record, error in
            self.processQueryResponseWith(records: record, error: error as NSError?) { fRecords, fError in
                completion(fRecords, fError)
            }
        })
    }


    private func processQueryResponseWith(records: [CKRecord]?, error: NSError?, completion: @escaping ([CKRecord]?, FetchError) -> Void) {
        guard error == nil else {
            completion(nil, .fetchingError)
            return
        }

        guard let records = records, records.count > 0 else {
            completion(nil, .noRecords)
            return
        }

        completion(records, .none)
    }

    func addDinerOrder(_ dinerID: String, completionHandler: @escaping (CKRecord?, FetchError) -> Void) {
        let publicDatabase = CKContainer(identifier: "com.cbrandow.betterMenu.database").publicCloudDatabase
        let record = CKRecord(recordType: RecordType)

        record.setObject(dinerID as __CKRecordObjCValue, forKey: "dinerId")
        // we will forgo a formal diner object. i htink that initials could suffice
        record.setObject("CB" as __CKRecordObjCValue, forKey: "dinerInitials")

        // need to recall how to make references to other objects, in this case the course to be added to a dictionary
        // the course in turn will have a reference to a list of references for the menu item ids
        publicDatabase.save(record) { record, error in
            guard let _ = error else {
                completionHandler(record, .none)
                return
            }
            completionHandler(nil, .addingError)

        }
    }
}
