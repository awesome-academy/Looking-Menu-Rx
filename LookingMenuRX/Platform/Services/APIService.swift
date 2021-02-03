import Foundation
import RxSwift
import Alamofire
import ObjectMapper

struct APIService {
    
    static let share = APIService()
    private var headers : HTTPHeaders
    private var alamofireManager = Alamofire.Session.default
    
    init() {
        headers = [
            "x-rapidapi-key": Instances.rapidapiKey,
            "x-rapidapi-host": Instances.rapidapiHost
        ]
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        alamofireManager = Alamofire.Session(configuration: configuration)
    }
    
    func request<T: BaseModel>(input: BaseRequest) -> Observable<T> {
        return Observable.create { observer in
            self.alamofireManager.request(input.url,
                                          method: input.requestType,
                                          encoding: input.encoding,
                                          headers: headers)
                .validate(statusCode: 200..<500)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                if let object = Mapper<T>().map(JSONObject: value) {
                                    observer.onNext(object)
                                    observer.onCompleted()
                                }
                            } else {
                                if let error = Mapper<ErrorResponse>().map(JSONObject: value) {
                                    observer.onError(BaseError.apiFailure(error: error))
                                } else {
                                    observer.onError(BaseError.httpError(httpCode: statusCode))
                                }
                            }
                        } else {
                            observer.onError(BaseError.unexpectedError)
                        }
                    case .failure:
                        observer.onError(BaseError.networkError)
                    }
                }
            return Disposables.create()
        }
    }
    
    func requestArray<T: BaseModel>(input: BaseRequest) -> Observable<[T]> {
        return Observable.create { observer in
            self.alamofireManager.request(input.url,
                                          method: input.requestType,
                                          encoding: input.encoding,
                                          headers: headers)
                .validate(statusCode: 200..<500)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                if let object = Mapper<T>().map(JSONObject: value) {
                                    observer.onNext(object as! [T])
                                    observer.onCompleted()
                                }
                            } else {
                                if let error = Mapper<ErrorResponse>().map(JSONObject: value) {
                                    observer.onError(BaseError.apiFailure(error: error))
                                } else {
                                    observer.onError(BaseError.httpError(httpCode: statusCode))
                                }
                            }
                        } else {
                            observer.onError(BaseError.unexpectedError)
                        }
                    case .failure:
                        observer.onError(BaseError.networkError)
                    }
                }
            return Disposables.create()
        }
    }
}
