//
//  RouterUtility.swift
//  foodApp
//
//  Created by Batuhan Saygılı on 2.08.2017.
//  Copyright © 2017 batuhansaygili. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import LLSpinner

class RouterUtility {
    static let shared = RouterUtility();
 
//    
//    func summaries(date:String,callback:@escaping(Response<Summaries>)->Void){
//        makeRequest(endpoint: .single(date), callback: { response in
//            callback(response.pass({ commentResponse in
//                return Summaries(json:commentResponse)
//            }))
//        })
//    }
//    
//    
    
    func login(access_token:String,callback:@escaping(Response<JSON>)->Void){
        makeRequest(endpoint: .login(access_token), callback: {
             response in
            callback(response.pass({ res in
                
              
                
                return res
             }))
        })
    }
    
    
    
    func coin(callback:@escaping(Response<[Coin]>)->Void){
            makeRequest(endpoint: .front, callback: {
                response in
                callback(response.pass({response in
    
                let coins : [Coin] = response.arrayValue.map({ element in
                    return Coin(json: element)
    
    
                })
                return coins
                }))
            })
    }
    
    func history(coin:String,callback:@escaping(Response<History>)->Void){
            makeRequest(endpoint: .oneDayHistory(coin), callback: {
                response in
                callback(response.pass({
                    return  History(json:$0)
                }))
            })
        }
    
    
    func coinPage(coin:String,callback:@escaping(Response<CoinPage>)->Void){
        makeRequest(endpoint: .coinPage(coin), callback: {
            response in
            callback(response.pass({
                return  CoinPage(json:$0)
            }))
        })
    }
    
    func kurlar(callback:@escaping(Response<Kurlar>)->Void){
        makeRequest(endpoint: .kurlar, callback: {
            response in
            callback(response.pass({
                return  Kurlar(json:$0)
            }))
        })
    }



    
//    func historyPrice(historyPrice:JSON,coin:String,callback:@escaping(Response<[HistoryPrice]>)->Void){
//        makeRequest(endpoint: .oneDayHistoryPrice(historyPrice,coin), callback: {
//            response in
//            callback(response.pass({response in
//                
//                let histories : [HistoryPrice] = response.arrayValue.map({ element in
//               
//                    return HistoryPrice(json: historyPrice)
//                    
//                    
//                })
//                return histories
//            }))
//        })
//    }
    
    
    
    
//    func video(type:String,callback:@escaping(Response<[Video]>)->Void){
//        makeRequest(endpoint: .video(type), callback: {
//            response in
//            callback(response.pass({response in
//
//            let videos : [Video] = response.arrayValue.map({ element in
//                return Video(json: element)
//
//
//            })
//            return videos
//        }))
//        })
//    }
//
//    func publisher(callback:@escaping(Response<[Publisher]>)->Void){
//        makeRequest(endpoint: .publisher, callback: {
//            response in
//            callback(response.pass({response in
//
//                let publishers : [Publisher] = response.arrayValue.map({ element in
//                    return Publisher(json: element)
//
//
//                })
//                return publishers
//            }))
//        })
//    }
//
//    func games(callback:@escaping(Response<[Games]>)->Void){
//        makeRequest(endpoint: .games, callback: {
//            response in
//            callback(response.pass({response in
//
//                let games : [Games] = response.arrayValue.map({ element in
//                    return Games(json: element)
//
//
//                })
//                return games
//            }))
//        })
//    }
//
//    func singleVideo(id:String,callback:@escaping(Response<Video>)->Void){
//        makeRequest(endpoint: .contentVideo(id), callback: {
//            response in
//            callback(response.pass({
//                return  Video(json:$0)
//            }))
//        })
//    }
//
//    func searchVideo(keyword:String,callback:@escaping(Response<[Video]>)->Void){
//        makeRequest(endpoint: .searchVideo(keyword), callback: {
//            response in
//            callback(response.pass({response in
//                let searchs: [Video] = response.arrayValue.map({element in
//                    return Video(json:element)
//                })
//
//                return searchs
//            }))
//        })
//    }
//
//
//    func searchPublisher(keyword:String,callback:@escaping(Response<[Publisher]>)->Void){
//        makeRequest(endpoint: .searchVideo(keyword), callback: {
//            response in
//            callback(response.pass({response in
//                let Publishers: [Publisher] = response.arrayValue.map({element in
//                    return Publisher(json:element)
//                })
//
//                return Publishers
//            }))
//        })
//    }
//    func userLike(id:String,callback:@escaping(Response<[Video]>)->Void){
//        makeRequest(endpoint: .userLike(id), callback: {
//            response in
//            callback(response.pass({response in
//                let Likes: [Video] = response.arrayValue.map({element in
//                    return Video(json:element)
//                })
//
//                return Likes
//            }))
//        })
//    }
//
//    func userProfile(id:String,callback:@escaping(Response<User>)->Void){
//        makeRequest(endpoint: .profil(id), callback: {
//            response in
//            callback(response.pass({
//                return User(json:$0)
//            }))
//        })
//    }
//
//    func Comments(id:String,callback:@escaping(Response<[Comment]>)->Void){
//        makeRequest(endpoint: .comment(id), callback: {
//            response in
//            callback(response.pass({response in
//                let Comments: [Comment] = response.arrayValue.map({element in
//                    return Comment(json:element)
//                })
//
//                return Comments
//            }))
//        })
//    }
//
//    func publisherVideo(id:String,callback:@escaping(Response<[Video]>)->Void){
//        makeRequest(endpoint: .publisherVideo(id), callback: {
//            response in
//            callback(response.pass({response in
//                let Videos: [Video] = response.arrayValue.map({element in
//                    return Video(json:element)
//                })
//
//                return Videos
//            }))
//        })
//    }
//
//
//    func singlePublisher(id:String,callback:@escaping(Response<Publisher>)->Void){
//        makeRequest(endpoint: .singlePublisher(id), callback: {
//            response in
//            callback(response.pass({
//                return Publisher(json:$0)
//            }))
//        })
//    }
//
//    func gameVideo(id:String,callback:@escaping(Response<[Video]>)->Void){
//        makeRequest(endpoint: .gameVideo(id), callback: {
//            response in
//            callback(response.pass({response in
//                let gameVideos: [Video] = response.arrayValue.map({element in
//                    return Video(json:element)
//                })
//
//                return gameVideos
//            }))
//        })
//    }
//
//    func likeVideo(id:String,user_id:String,callback:@escaping(Response<LikeCount>)->Void){
//        makeRequest(endpoint: .likeVideo(id, user_id), callback: {
//            response in
//            callback(response.pass({
//
//                return LikeCount(json:$0)
//            }))
//        })
//    }
//
//
//    func sendPost(id:String,user_id:String,comment:String,callback:@escaping(Response<JSON>)->Void){
//        makeRequest(endpoint: .sendPost(id, user_id,comment), callback: {
//            response in
//            callback(response.pass({
//
//                return $0
//            }))
//        })
//    }
//
//    func selfDeleteComment(user_id:String,commentid:String,callback:@escaping(Response<JSON>)->Void){
//        makeRequest(endpoint: .selfDeleteComment(user_id,commentid), callback: {
//            response in
//            callback(response.pass({
//
//                return $0
//            }))
//        })
//    }
//
//    func didLike(user_id:String,video_id:String,callback:@escaping(Response<didLiked>)->Void){
//        makeRequest(endpoint:.didLike(user_id,video_id),callback: {
//                response in
//            callback(response.pass({
//                return didLiked(json:$0)
//            }))
//        })
//    }
//
//
//    func register(username:String,name:String,email:String,password:String,bio:String,callback:@escaping(Response<JSON>)->Void){
//        makeRequest(endpoint: .register(username, name, email, password, bio), callback: {
//            response in
//            callback(response.pass({ res in
//
//
//
//                return res
//            }))
//        })
//    }
//
//
//    func defaultLogin(username:String,password:String,callback:@escaping(Response<JSON>)->Void){
//        makeRequest(endpoint: .defaultlogin(username,password), callback: {
//            response in
//            callback(response.pass({ res in
//
//
//
//                return res
//            }))
//        })
//    }
    
    
    private func makeRequest(endpoint: Router, callback: @escaping (Response<JSON>)->Void) {
 
        Alamofire.request(endpoint).validate(statusCode: 200..<400).responseJSON { response in
          
            if response.result.isFailure {
                var error = ErrorMessage();
                if let data = response.data, data.count > 0 {
                    error = ErrorMessage(json:JSON(data));
                }
                callback(Response(error: error))
                return;
            }
            let data = response.data!;
            let json = JSON(data);
            //print(json)
            
            LLSpinner.stop()
            callback(Response(data: json));
            
        }
    }
}

