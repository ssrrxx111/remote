//
//  Response+Any.swift
//  NewUstock
//
//  Created by Kyle on 16/6/23.
//  Copyright © 2016年 ustock. All rights reserved.
//

import Moya

extension Response {

	public func mapAny<T: Any>() throws -> T {

		var json: Any!

		do {
			json = try mapJSON()
		} catch {
			throw(error)
		}

		guard let obj = json as? T else {
			throw Moya.MoyaError.jsonMapping(self)
		}
		return obj
	}

	public func mapAnyArray<T: Any>() throws -> [T] {

		var json: Any!

		do {
			json = try mapJSON()
		} catch {
			throw(error)
		}

		guard let array = json as? [T] else {
			throw Moya.MoyaError.jsonMapping(self)
		}
		return array

	}

}
