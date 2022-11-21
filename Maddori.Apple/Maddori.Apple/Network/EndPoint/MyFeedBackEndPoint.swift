//
//  MyFeedBackEndPoint.swift
//  Maddori.Apple
//
//  Created by Mingwan Choi on 2022/11/17.
//

import Alamofire

enum MyFeedBackEndPoint<T: Encodable> {
    case fetchCurrentTeamMember
    case fetchCertainMemberFeedBack(memberId: Int)
    case deleteFeedBack(teamId: Int, reflectionId: Int, feedBackId: Int, userId: Int)
    case putEditFeedBack(reflectionId: Int, feedBackId: Int, T)
    
    var address: String {
        switch self {
        case .fetchCurrentTeamMember:
            return "\(UrlLiteral.baseUrl)/teams/\(UserDefaultStorage.teamId)/members"
        case .fetchCertainMemberFeedBack(let memberId):
            return "\(UrlLiteral.baseUrl)/teams/\(UserDefaultStorage.teamId)/reflections/current/feedbacks/from-me?members=\(memberId)"
        case .deleteFeedBack(let teamId, let reflectionId, let feedBackId, _):
            return "\(UrlLiteral.baseUrl)/teams/\(teamId)/reflections/\(reflectionId)/feedbacks/\(feedBackId)"
        case .putEditFeedBack(let reflectionId, let feedBackId, _):
            return "\(UrlLiteral.baseUrl)/teams/\(UserDefaultStorage.teamId)/reflections/\(reflectionId)/feedbacks/\(feedBackId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchCurrentTeamMember:
            return .get
        case .fetchCertainMemberFeedBack:
            return .get
        case .deleteFeedBack:
            return .delete
        case .putEditFeedBack:
            return .put
        }
    }
    
    var body: T? {
        switch self {
        case .fetchCurrentTeamMember:
            return nil
        case .fetchCertainMemberFeedBack:
            return nil
        case .deleteFeedBack:
            return nil
        case .putEditFeedBack(_, _, let body):
            return body
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchCurrentTeamMember:
            let headers = ["user_id": "\(UserDefaultStorage.userId)"]
            return HTTPHeaders(headers)
        case .fetchCertainMemberFeedBack:
            let headers = ["user_id": "\(UserDefaultStorage.userId)"]
            return HTTPHeaders(headers)
        case .deleteFeedBack(_, _, _, let userId):
            let headers = ["user_id": "\(userId)"]
            return HTTPHeaders(headers)
        case .putEditFeedBack(_, _, _):
            let headers = ["user_id": "\(UserDefaultStorage.userId)"]
            return HTTPHeaders(headers)
        }
    }
}
