import Foundation
import RxSwift
import RxCocoa
import MGArchitecture

struct MainViewModel {
    let navigation: UINavigationController
}

extension MainViewModel: ViewModel {
    
    struct Input {
        let selectTrigger: Driver<IndexPath>
    }
    
    struct Output {
        @Property var itemTabbars = ["Home", "Save", "Diet", "Ingre"]
        @Property var selectTabBar = Int()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.selectTrigger
            .map { $0.item }
            .drive(output.$selectTabBar)
            .disposed(by: disposeBag)
        
        return output
    }
}
