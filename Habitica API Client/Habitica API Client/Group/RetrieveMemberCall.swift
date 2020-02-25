//
//  RetrieveMemberCall.swift
//  Habitica API Client
//
//  Created by Phillip Thelen on 11.04.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models
import ReactiveSwift

public class RetrieveMemberCall: ResponseObjectCall<MemberProtocol, APIMember> {
    public init(userID: String, stubHolder: StubHolderProtocol? = StubHolder(responseCode: 200, stubFileName: "member.json")) {
        if let uuid = UUID(uuidString: userID) {
            super.init(httpMethod: .GET, endpoint: "members/\(uuid)", stubHolder: stubHolder)
        } else {
            super.init(httpMethod: .GET, endpoint: "members/username/\(userID)", stubHolder: stubHolder)
        }
    }
}
