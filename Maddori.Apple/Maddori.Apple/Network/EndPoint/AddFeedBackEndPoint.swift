//
//  AddFeedBackEndPoint.swift
//  Maddori.Apple
//
//  Created by Mingwan Choi on 2022/11/17.
//

import Foundation

import Alamofire

enum AddFeedBackEndPoint<T: Encodable> {
    case fetchCurrentTeamMember
    case dispatchAddFeedBack(reflectionId: Int, T)
    
    var address: String {
        switch self {
        case .fetchCurrentTeamMember:
            return "\(UrlLiteral.baseUrl)/teams/\(UserDefaultStorage.teamId)/members"
        case .dispatchAddFeedBack(let reflectionId, _):
            return "\(UrlLiteral.baseUrl)/teams/\(UserDefaultStorage.teamId)/reflections/\(reflectionId)/feedbacks"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchCurrentTeamMember:
            return .get
        case .dispatchAddFeedBack:
            return .post
        }
    }
    
    var body: T? {
        switch self {
        case .fetchCurrentTeamMember:
            return nil
        case .dispatchAddFeedBack(_, let body):
            return body
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchCurrentTeamMember:
            let headers = ["user_id": "\(UserDefaultStorage.userId)"]
            return HTTPHeaders(headers)
        case .dispatchAddFeedBack:
            let headers = ["user_id": "\(UserDefaultStorage.userId)"]
            return HTTPHeaders(headers)
        }
    }
}
