//
//  MockUserDefaults.swift
//  places to visit appTests
//
//  Created by Harriette Berndes on 30/07/2021.
//

import Foundation
@testable import places_to_visit_app


class MockUserDefaults: UserDefaultsProtocol {
    var dataWasCalled: Bool = false
    var dataWasCalledUserDefaultsCurrentlyEmpty: Bool = false
    var setValueWasCalled: Bool = false
    
    var saved: Dictionary<String, Data> = [String: Data]()
    var savedBySetValue: Dictionary<String, Any> = [String: Any]()
    var encodedData: Data?
    
    func setValue(_ value: Any?, forKey key: String) {
        if value is Data {
            setValueWasCalled = true
            savedBySetValue[key] = value
        }
    }
    
    func data(forKey defaultName: String) -> Data? {
        if let savedValue = saved[defaultName] {
            dataWasCalled = true
            return savedValue
        }
        return nil
    }
 
}
