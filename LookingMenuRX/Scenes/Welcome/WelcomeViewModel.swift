import Foundation
import RxSwift
import RxCocoa
import MGArchitecture

struct WelcomeViewModel {
    let navigator: WelcomeViewNavigatorType
}

extension WelcomeViewModel: ViewModel {
    
    struct Input {
        let btnGoMainView: Driver<Void>
    }
    
    struct Output {
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        input.btnGoMainView
            .do(onNext: { _ in
                UserDefaults.standard.set(true,
                                          forKey: KeyUserDefaults.keyCheckNewUser)
                navigator.toMainView()
            })
            .drive()
            .disposed(by: disposeBag)
        
        return Output()
    }
}
