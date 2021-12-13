//
//  ChatViewController.swift
//  ChatNow
//
//  Created by ZhenYu Niu on 2021-06-17.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message: MessageType {
    public var sender: SenderType
    
    public var messageId: String
    
    public var sentDate: Date
    
    public var kind: MessageKind
    
 
}
extension MessageKind{
    var messageKindString : String{
        switch self {
        
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "vidio"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .custom(_):
            return "custom"
        }
    }
    
}
struct Sender: SenderType {
    public var photoURL: String
    public var senderId: String
    public var displayName: String
    
   
}

class ChatViewController: MessagesViewController {
    
    public static let dateFormatter: DateFormatter = {
        let formattre = DateFormatter()
        formattre.dateStyle = .medium
        formattre.timeStyle = .long
        formattre.locale = .current
        return formattre
    }()
    
    public let otherUserEmail: String
    
    private let conversationId: String?

    public var isNewConversation = false
    
    private var messages = [Message]()
    
    private var selfSender : Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email")as? String else{
            return nil
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        return Sender(photoURL: "",
                      senderId: safeEmail,
                      displayName: "Tom Joy")
        
    }
    
//    private func listenForMessages(){
//
//    }
    
    init(with email: String, id: String?){
        self.conversationId = id
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        messages.append(Message(sender: selfSender,
//                                messageId: "1",
//                                sentDate: Date(),
//                                kind: .text("Hello World")))
//
//        messages.append(Message(sender: selfSender,
//                                messageId: "1",
//                                sentDate: Date(),
//                                kind: .text("Hello World Hello World Hello World")))
        
        view.backgroundColor = .red
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
       // listenForMessages()
    }
    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
        DatabaseManager.shared.getAllMessagesForCoversation(with: id, completion: { [weak self]result in
            switch result{
            case .success(let messages):
                print("success in getting message")
                guard !messages.isEmpty else {
                    return
                }
                self?.messages = messages
                
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                    if shouldScrollToBottom{
                        self?.messagesCollectionView.reloadData()

                    }else{
                       

                    }
                }
                
            case .failure(let error):
                print("failed to get messages: \(error)")
            }
        })
    }
    
    
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
        
        if let conversationId = conversationId{
            listenForMessages(id: conversationId, shouldScrollToBottom: true)
        }
    }
    
}


extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text:String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let selfSender = self.selfSender,
              let messageId = createMessageId() else {
            
            return
        }
        print("Sending: \(text)")
        // send Message
        
        let message = Message(sender: selfSender,
                              messageId: messageId,
                              sentDate: Date(),
                              kind: .text(text))
        if isNewConversation{
             
            // create conversation
            
            
            DatabaseManager.shared.createNewConversation(
                with: otherUserEmail,
                name: self.title ?? "User",
                firstMessage: message,                
                completion: {[weak self]success in
                if success{
                    print("send message")
                    self?.isNewConversation = false
                    
                }else{
                    print("faield to send")
                }
                
                
            })
        }else{
            guard let conversationId = conversationId,
                  let name = self.title else {
                return
            }
            
            // append to existing conversation data
            DatabaseManager.shared.sendMessage(to: conversationId,
                                               //otherUserEmail: <#String#>,
                                               name: name,
                                               newMessage: message,
                                               completion:  { success in
                                                if success{
                                                    print("send message")
                                                }else{
                                                    print("faield to send")
                                                }
                                             })
        }
        
    }
    
    
    private func createMessageId() -> String? {
        
        guard  let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let safeCurrentEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
        let dataString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dataString)"
        
        return newIdentifier
    }
}






extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        
        fatalError("Self Sender is nil, email should be cached")
        //return Sender(photoURL: "", senderId: "12", displayName: "")
             
        
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
}
