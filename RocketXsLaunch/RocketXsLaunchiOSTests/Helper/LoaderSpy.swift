//
//  LoaderSpy.swift
//  RocketXsLaunchiOSTests
//
//  Created by Shad Mazumder on 11/1/22.
//
import RocketXsLaunch

class LoaderSpy: Loader {
    typealias APIModel = String
    typealias LoaderError = RemoteLoader<APIModel>.Error
    
    var completions = [(RemoteLoader<String>.Result)->Void]()
    var callCounter: Int { completions.count }

    func load(completion: @escaping ((RemoteLoader<String>.Result) -> Void)) {
        completions.append(completion)
    }

    func completedLoading(index: Int = 0) {
        completions[index](.success(""))
    }

    func completeLoadingWithSuccess(for string: String, at index: Int = 0) {
        completions[index](.success(string))
    }
}
