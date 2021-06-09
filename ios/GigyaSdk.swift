//
//  GigyaSdk.swift
//  DoubleConversion
//
//  Created by Shmuel, Sagi on 22/12/2019.
//

import Foundation
import Gigya
import React

@objc(GigyaSdk)
public class GigyaSdk: NSObject {
    static var gigya: GigyaSdkWrapperProtocol?

    var promise = PromiseWrapper()

    override init() {
        super.init()
    }

    public static func setSchema<T: GigyaAccountProtocol>(_ schema: T.Type) {
        let gigya = GigyaSdkWrapper(accountSchema: schema)

         GigyaSdk.gigya = gigya
    }

    @objc(initFor:apiDomain:)
    init(apiKey: String, apiDomain: String) {
        GigyaSdk.gigya?.initFor(apiKey: apiKey, domain: apiDomain)
    }

    @objc(isLoggedIn)
    func isLoggedIn() -> Any {
        return GigyaSdk.gigya?.isLoggedIn() ?? false
    }

    @objc(send:params:resolver:rejecter:)
    func send(_ api: String, params: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        promise.set(promiseResolve: resolve, promiseReject: reject)

        let newParams: [String : Any] = ["api": api, "params": params];
        GigyaSdk.gigya?.sendEvent(.send, params: newParams, promise: promise)
    }

    @objc(register:password:params:resolver:rejecter:)
    func register(_ email: String, password: String, params: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        promise.set(promiseResolve: resolve, promiseReject: reject)

        let newParams: [String : Any] = ["email": email, "password": password, "params": params];
        GigyaSdk.gigya?.sendEvent(.register, params: newParams, promise: promise)
    }

    @objc(login:password:params:resolver:rejecter:)
    func login(_ loginId: String, password: String, params: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        promise.set(promiseResolve: resolve, promiseReject: reject)

        let jsonToParams = GigyaSdk.toJson(data: params)
        let newParams: [String : Any] = ["loginId": loginId, "password": password, "params": jsonToParams];
        GigyaSdk.gigya?.sendEvent(.login, params: newParams, promise: promise)
    }

    @objc(getAccount:resolver:rejecter:)
    func getAccount(_ params: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        promise.set(promiseResolve: resolve, promiseReject: reject)

        let newParams: [String : Any] = ["params": params];
        GigyaSdk.gigya?.sendEvent(.getAccount, params: newParams, promise: promise)
    }

    @objc(setAccount:resolver:rejecter:)
    func setAccount(_ params: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        promise.set(promiseResolve: resolve, promiseReject: reject)

        let newParams: [String : Any] = ["params": params];
        GigyaSdk.gigya?.sendEvent(.setAccount, params: newParams, promise: promise)
    }

    @objc(socialLogin:params:resolver:rejecter:)
    func socialLogin(_ provider: String, params: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        promise.set(promiseResolve: resolve, promiseReject: reject)

        let newParmas: [String: Any] = ["provider": provider, "params": params]
        GigyaSdk.gigya?.sendEvent(.socialLogin, params: newParmas, promise: promise)
    }

    @objc(addConnection:resolver:rejecter:)
    func addConnection(_ params: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        promise.set(promiseResolve: resolve, promiseReject: reject)

        let newParams: [String : Any] = ["params": params];
        GigyaSdk.gigya?.sendEvent(.addConnection, params: newParams, promise: promise)
    }

    @objc(removeConnection:resolver:rejecter:)
    func removeConnection(_ params: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        promise.set(promiseResolve: resolve, promiseReject: reject)

        let newParams: [String : Any] = ["params": params];
        GigyaSdk.gigya?.sendEvent(.removeConnection, params: newParams, promise: promise)
    }

    @objc(showScreenSet:params:)
    func showScreenSet(name: String, params: [String: Any]) {
        GigyaSdk.gigya?.showScreenSet(name: name, params: params)
    }

    @objc(logout:rejecter:)
    func logout(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        promise.set(promiseResolve: resolve, promiseReject: reject)

        GigyaSdk.gigya?.sendEvent(.logout, params: [:], promise: promise)
    }

    @objc(resolve:params:resolver:rejecter:)
    func resolve(method: String, params: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        promise.set(promiseResolve: resolve, promiseReject: reject)

        GigyaSdk.gigya?.useResolver(method: method, params: params)
    }

    static func toJson(data: String) -> [String: Any] {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(data)
            let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: [])
                as? [String: Any]
            return dictionary ?? [:]
        } catch {
            // TODO: Add to logger
        }

        return [:]
    }

    static func toJsonString(data: [String: Any]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            let decoded = String(data: jsonData, encoding: .utf8)
            return decoded ?? ""
        } catch let error {
            return "{}"
        }
    }

}