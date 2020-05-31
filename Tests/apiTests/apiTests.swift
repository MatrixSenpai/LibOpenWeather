import XCTest
import RxSwift
@testable import api

final class apiTests: XCTestCase {
    let api = API("<REPLACE WITH API KEY>")
    let bag = DisposeBag()
    
    func testExample() {
        let await = expectation(description: "API Response")
        
        api.currentWeather(by: "Austin").asObservable().subscribe(onNext: { response in
            print(response)
            
            XCTAssertEqual(-97.74, response.coordinates.longitude)
            XCTAssertEqual(30.27, response.coordinates.latitude)
            
            await.fulfill()
        }, onError: { error in
            print(error)
            XCTFail()
        }).disposed(by: bag)
        
        wait(for: [await], timeout: 5.0, enforceOrder: true)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
