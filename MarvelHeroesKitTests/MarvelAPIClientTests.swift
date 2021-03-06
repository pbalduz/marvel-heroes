//
//  Created by Pablo Balduz on 07/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import XCTest
@testable import MarvelHeroesKit
import Moya
import RxSwift

class MarvelAPIClientTests: XCTestCase {
    
    let apiClient = MarvelAPIClient(MoyaProvider<MarvelEndpoint>(stubClosure: MoyaProvider.immediatelyStub))
    
    func testFetchHeroesList() {
        guard let sampleData = try? JSONDecoder().decode(MarvelResponse<Hero>.self, from: stubResponse(for: "heroes")) else {
            XCTFail()
            return
        }
        _ = apiClient.fetchHeroes(query: nil).subscribe(onSuccess: { heroes in
            XCTAssert(heroes.count == sampleData.results.count)
            XCTAssert(heroes.first!.id == sampleData.results.first!.id)
            XCTAssert(heroes.first!.name == sampleData.results.first!.name)
            XCTAssert(heroes.first!.description == sampleData.results.first!.description)
        }) { _ in
            XCTFail()
        }
    }
    
    func testFetchHeroDetail() {
        guard let sampleData = try? JSONDecoder().decode(MarvelResponse<HeroDetail>.self, from: stubResponse(for: "hero-detail")) else {
            XCTFail()
            return
        }
        _ = apiClient.fetchHeroDetail(heroID: 0).subscribe(onSuccess: { hero in
            XCTAssert(hero.id == sampleData.results.first!.id)
            XCTAssert(hero.name == sampleData.results.first!.name)
            XCTAssert(hero.description == sampleData.results.first!.description)
        }) { _ in
            XCTFail()
        }
    }
}
