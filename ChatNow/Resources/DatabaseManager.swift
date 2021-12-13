//
//  DatabaseManager.swift
//  ChatNow
//
//  Created by ZhenYu Niu on 2021-06-16.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(emailAddress: String) -> String{
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "_")
        return safeEmail
    }
}



// account management

extension DatabaseManager{
    
    public func userExists(with email: String, comletion: @escaping((Bool) -> Void)){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "_")
        database.child(safeEmail).observeSingleEvent(of: .value, with: { DataSnapshot in
            guard DataSnapshot.value as? String != nil else{
                comletion(false)
                return
            }
            comletion(true)
        })
    }
    
    ///creat new new user
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void ){
         database.child(user.safeEmail).setValue([
             "first_name": user.firstName,
             "last_name": user.lastName
         ], withCompletionBlock: {error, _ in
            guard error == nil else{
              
                print("faild to write to database")
                completion(false)
                return
            }
            /*[
                 [ "name": Tom
                   "safe email": 1321@gmail.com
                 ],
                 [ "name": Tom
                   "safe email": 1321@gmail.com
                 ],
                 [ "name": Tom
                   "safe email": 1321@gmail.com
                 ]
             ]
            */
            self.database.child("users").observeSingleEvent(of: .value, with: { snpshot in
                if var usersCollection = snpshot.value as? [[String: String]] {
                    // append to to user dictionary
                    let newElement = [
                        "name": user.firstName + " " + user.lastName,
                        "email": user.safeEmail
                    ]
                    usersCollection.append(newElement)
                    self.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }else{
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail
                        ]
                    ]
                    self.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                            
                        }
                        completion(true)
                    })
                }
            })
            completion(true)
            
         })
    }
    
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void){
        database.child("users").observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
            
        })
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
    }
    
    
}
extension DatabaseManager{
   
    public func productExists(with productID: String, comletion: @escaping((Bool) -> Void)){
        database.child(productID).observeSingleEvent(of: .value, with: { DataSnapshot in
            guard DataSnapshot.value as? [String: Any] != nil else{
                comletion(false)
                return
            }
            comletion(true)
        })
    }
    public func insertProduct(with newProduct: Product, completion: @escaping (Bool) -> Void ){
        database.child(newProduct.productID).setValue([
            "productName": newProduct.productName,
            "productPrice": newProduct.productPrice,
            "productCategory": newProduct.productCategory,
            "productDescription": newProduct.productDescription
        
        ],withCompletionBlock: {error, _ in
            guard error == nil else{
                print("faild to write to database")
                completion(false)
                return
            }
            self.database.child("product").observeSingleEvent(of: .value, with: { snpshot in
                if var usersCollection = snpshot.value as? [[String: String]]{
                    
                    let newElement = [
                        "productID": newProduct.productID,
                        "productName": newProduct.productName,
                        "productPrice": newProduct.productPrice,
                        "productCategory": newProduct.productCategory,
                        "productDescription": newProduct.productDescription
                    ]
                    
                    usersCollection.append(newElement)
                    self.database.child("product").setValue(usersCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }else{
                    let newCollection: [[String: String]] = [[
                        "productID": newProduct.productID,
                        "productName": newProduct.productName,
                        "productPrice": newProduct.productPrice,
                        "productCategory": newProduct.productCategory,
                        "productDescription": newProduct.productDescription
                    ]]
                    self.database.child("product").setValue(newCollection, withCompletionBlock: { error, _ in
                        
                        guard error == nil else {
                            completion(false)
                            return
                            
                        }
                        completion(true)                        
                    })
                }
            })
            completion(true)
        })
    }
    
 ////////////////////
}

extension DatabaseManager{
    public func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void){
        self.database.child("\(path)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
}

// sending messages
extension DatabaseManager {
    /*
     conversation => [
     
     
     
     [
     "coversation_id":
     "other_user_email":
     "latest_message": => {
                           "date":
                           "latest_message":
                           "is read":
     }
     ],
     
     [
     "coversation_id":
     "other_user_email":
     "latest_message": => {
                           "date":
                           "latest_message":
                           "is read":
     }
     ]
     ]
     
     */
    public func createNewConversation(with otherUserEmail: String, name: String, firstMessage: Message, completion: @escaping(Bool) -> Void){
        
        
     
        
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
              let currentName = UserDefaults.standard.value(forKey: "name") as? String
             else { 
                return
        }
       
        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)
       
        let ref = database.child("\(safeEmail)")
        
        ref.observeSingleEvent(of: .value, with: { [weak self]snapshot in
           
            guard var userNode = snapshot.value as? [String: Any] else {
                completion(false)
                print("user not found")
                return
            }
            let messageDate = firstMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            
            var message = ""

            switch firstMessage.kind {
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .custom(_):
                break
            }
            
            let conversationId = "conversation_\(firstMessage.messageId)"
            let newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_email": otherUserEmail,
                "name": name,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            let recipient_newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_email": safeEmail,
                "name": currentName,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            self?.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { [weak self]snapshot in
                if var conversatoins = snapshot.value as? [[String: Any]]{
                    
                    conversatoins.append(recipient_newConversationData)
                    self?.database.child("\(otherUserEmail)/conversations").setValue(conversatoins)
                }else{
                    self?.database.child("\(otherUserEmail)/conversations").setValue([recipient_newConversationData])
                }
            })
            
            
            if var conversatoins = userNode["conversations"] as? [[String: Any]] {
                
                conversatoins.append(newConversationData)
                userNode["conversations"] = conversatoins
                ref.setValue(userNode, withCompletionBlock: {[weak self]error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    //completion(true)
                    self?.finishCreatingConversation(
                        name: name, conversationID: conversationId,
                        firstMessage: firstMessage,
                        completion: completion)
                })
                
            }else{
                userNode["conversations"] = [newConversationData]
                
                ref.setValue(userNode, withCompletionBlock: {[weak self]error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                    
                    self?.finishCreatingConversation(
                        name: name, conversationID: conversationId,
                        firstMessage: firstMessage,
                        completion: completion)
                })
                
            }
        })
        
    }
    private func finishCreatingConversation(name: String, conversationID: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
//        {
//            "id": String,
//            "type": text, photo, video,
//            "content": String,
//            "date": Date(),
//            "sender_email": String,
//            "isRead": true/false,
//        }

        let messageDate = firstMessage.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)

        var message = ""
        switch firstMessage.kind {
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .custom(_):
            break
        }

        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }

        let currentUserEmail = DatabaseManager.safeEmail(emailAddress: myEmail)

        let collectionMessage: [String: Any] = [
            "id": firstMessage.messageId,
            "type":firstMessage.kind.messageKindString,
            "content": message,
            "date": dateString,
            "sender_email": currentUserEmail,
            "is_read": false,
            "name": name
        ]

        let value: [String: Any] = [
            "messages": [
                collectionMessage
            ]
        ]

        print("adding convo: \(conversationID)")

        database.child("\(conversationID)").setValue(value, withCompletionBlock: { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }

    public func getAllConversations(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        database.child("\(email)/conversations").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }

            let conversations: [Conversation] = value.compactMap({ dictionary in
                guard let conversationId = dictionary["id"] as? String,
                    let name = dictionary["name"] as? String,
                    let otherUserEmail = dictionary["other_user_email"] as? String,
                    let latestMessage = dictionary["latest_message"] as? [String: Any],
                    let date = latestMessage["date"] as? String,
                    let message = latestMessage["message"] as? String,
                    let isRead = latestMessage["is_read"] as? Bool else {
                        return nil
                }

                let latestMessageObject = LatestMessage(date: date,
                                                         text: message,
                                                         isRead: isRead)
                return Conversation(id: conversationId,
                                    name: name,
                                    otherUserEmail: otherUserEmail,
                                    latestMessage: latestMessageObject)
            })

            completion(.success(conversations))
        })
    }

    
    public func getAllMessagesForCoversation(with id: String, completion: @escaping (Result<[Message],Error>) -> Void){
        database.child("\(id)/messages").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }

            let messages: [Message] = value.compactMap({ dictionary in
                guard let name = dictionary["name"] as? String,
                    let isRead = dictionary["is_read"] as? Bool,
                    let messageID = dictionary["id"] as? String,
                    let content = dictionary["content"] as? String,
                    let senderEmail = dictionary["sender_email"] as? String,
                    let type = dictionary["type"] as? String,
                    let dateString = dictionary["date"] as? String,
                    let date = ChatViewController.dateFormatter.date(from: dateString)else {
                        
                    return nil
                }
                let sender =  Sender(photoURL: "", senderId: senderEmail, displayName: name)
                
                return Message(sender: sender,
                               messageId: messageID,
                               sentDate: date,
                               kind: .text(content))
            })
           // return nil
            completion(.success(messages))
        })//return nil
    }
    
    public func sendMessage(to conversation: String, name: String, newMessage: Message, completion: @escaping (Bool) -> Void) {
        
       database.child("\(conversation)/messages").observeSingleEvent(of: .value, with: { [weak self] snapshot in
        guard let strongSelf = self else {
            return
        }
            guard var currentMessages = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }
            
            let messageDate = newMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            
            var message = ""
            switch newMessage.kind {
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .custom(_):
                break
            }

            guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
                completion(false)
                return
            }

            let currentUserEmail = DatabaseManager.safeEmail(emailAddress: myEmail)

            let newMessageEntry: [String: Any] = [
                "id": newMessage.messageId,
                "type":newMessage.kind.messageKindString,
                "content": message,
                "date": dateString,
                "sender_email": currentUserEmail,
                "is_read": false,
                "name": name
            ]
            
            currentMessages.append(newMessageEntry)
        strongSelf.database.child("\(conversation)/messages").setValue(currentMessages) { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
        })
    }
}

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail : String {
       var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "_")
        return safeEmail
    }
    
    var profilePictureFileName: String {
        
        return "\(safeEmail)_profile_picture.png"
    }
}

struct Product {
    let productID: String
    let productName: String
    let productCategory: String
    let productPrice: String
    let productDescription: String
    var productPictureFileName: String {
        
        return "\(productID)_picture.png"
    }
}
