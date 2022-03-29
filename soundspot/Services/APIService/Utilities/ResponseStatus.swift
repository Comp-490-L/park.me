//
//  ResponseStatus.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/28/22.
//

import Foundation

struct ResponseStatus{
	
	static func translateReponseCode(statusCode : Int) -> StatusResult{
		let successful = 200...299
		let clientError = 400...499
		let serverError = 500...599
		
		if successful.contains(statusCode){
			return StatusResult.Successful
		}
		if clientError.contains(statusCode){
			return StatusResult.ClientError
		}
		if(serverError.contains(statusCode)){
			return StatusResult.ServerError
		}
		return StatusResult.Other
	}
	
	enum StatusResult{
		case Successful
		case ClientError
		case ServerError
		case Other
	}
}
