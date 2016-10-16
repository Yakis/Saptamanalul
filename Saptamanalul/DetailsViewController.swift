//
//  DetailsViewController.swift
//  Saptamanalul
//
//  Created by yakis on 21/04/16.
//  Copyright © 2016 yakis. All rights reserved.
//

import UIKit
import Social
import Kingfisher
import Firebase

class DetailsViewController: UIViewController {

    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var titleValue = ""
    var imageName: URL?
    var bodyValue = ""
    var pubImageName: URL?
    var pubUrl: URL?
    
    var runTimer: Timer!
    var stopTimer: Timer!
    var comments = [Comment]()
    var ref = FIRDatabase.database().reference()
    
    
    
    func shareTapped () {
//        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//        vc?.add(detailsImageView.image!)
//        vc?.setInitialText("\(detailsTitleLabel.text!)\n\n\(detailsBodyLabel.text!)")
//        present(vc!, animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if pubImageName?.absoluteString != "" {
        runTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        stopTimer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(stopTimedCode), userInfo: nil, repeats: true)
    }
    }
    
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
        tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.register(UINib(nibName: "BodyCell", bundle: nil), forCellReuseIdentifier: "BodyCell")
        tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(DetailsViewController.shareTapped))
        tableView.dataSource = self
        tableView.delegate = self
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(DetailsViewController.imageTapped))
//        imageView?.isUserInteractionEnabled = true
//        imageView?.addGestureRecognizer(tapGestureRecognizer)
        
        
        let firstComment = Comment(userName: "Attila", text: "Un comentariu destul de urat la adresa primarelui din Vatra Moldovitei, care se pare ca a fost gasit in stare de ebrietate impreuna cu seful de post chiar in ziua de hram. Modarfakar de primare, ce bulangiu, nu putea sa bea si el noaptea ca tot omu, ca sa nu-l vada nimeni prin sat, iaca acuma are probleme in campanie!", autoID: "123444", userID: "123444")
        let secondComment = Comment(userName: "Bulgaras2016", text: "Bai! voi nu vedeti ca asta fura??? Cine naiba l-a pus pe asta in functie, ca din 2004 si-a umplut buzunarele cu bani si nu a facut nimic pentru comuna noastra, parca e tampit!!!", autoID: "123442", userID: "123442")
        let thirdComment = Comment(userName: "Yakis", text: "La WWDC, s-au prezentat articole interesanta care mai de care, in special despre interface builder si navigation controller. Mai mult de atat, au fost prezentate toate modificarile in trecerea la de Swift 2 la Swift 3.", autoID: "123447", userID: "123447")
        
        comments.append(firstComment)
        comments.append(secondComment)
        comments.insert(thirdComment, at: 1)
        getComments()
    }
    
    
    func getComments () {
        let commentsRef = ref.child("comments")
        commentsRef.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            guard let value = snapshot.value as? NSDictionary else {return}
            guard let userName = value["userName"] as? String else {return}
            guard let text = value["text"] as? String else {return}
            let autoID = snapshot.key
            guard let userID = value["userID"] as? String else {return}
            let commentFour = Comment(userName: userName, text: text, autoID: autoID, userID: userID)
            self.comments.insert(commentFour, at: 0)
        })
    }
    
    
    
    
    func imageTapped () {
        guard let url = self.pubUrl else {return}
        UIApplication.shared.openURL(url)
    }

    
    func runTimedCode() {
//        if let pubImage = self.pubImageName {
//            detailsImageView.kf.setImage(with: pubImage)
//        }
//        runTimer.invalidate()
    }
    
    func stopTimedCode () {
//        if let image = imageName {
//            detailsImageView.kf.setImage(with: image)
//        
//
//        stopTimer.invalidate()
//        }
    }
    

    
    func commentButtonTapped () {
        let screenSize = UIScreen.main.bounds.size
        let width = screenSize.width - 40
        let height = screenSize.height / 2
        let xOrigin = (screenSize.width - width) / 2
        let yOrigin = (screenSize.height - height) / 2
        let frame = CGRect(x: xOrigin, y: yOrigin, width: width, height: height)
        let newComment = NewCommentVC(nibName: "NewCommentVC", bundle: nil)
        guard let newCommentView = newComment.view else {return}
        newCommentView.frame = frame
        self.view.addSubview(newCommentView)
        print("Write, motherfucker!")
    }
    
    
    
}


extension DetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if comments.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
        return 2
        } else {
            return comments.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        if indexPath.row == 0 {
        let titleCell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
            return titleCell
        } else if indexPath.row == 1 {
            let bodyCell = tableView.dequeueReusableCell(withIdentifier: "BodyCell", for: indexPath) as! BodyCell
            return bodyCell
        }
        } else if indexPath.section == 1 {
            let commentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            let comment = comments[indexPath.row]
            commentCell.userName.text = comment.userName
            commentCell.bodyLabel.text = comment.text
            return commentCell
        }
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Comentarii"
        } else {
            return nil
        }
    }
    
    
    
}


extension DetailsViewController: UITableViewDelegate {
    
    
    func setupCommentsHeader () -> UIView {
        let frame: CGRect = UIScreen.main.bounds
        let doneButton: UIButton = UIButton(frame: CGRect(x: frame.width-40, y: 5, width: 30, height: 30))
        doneButton.setImage(UIImage(named: "newComment"), for: .normal)
        doneButton.addTarget(self, action: #selector(DetailsViewController.commentButtonTapped), for: .touchUpInside)
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        headerView.backgroundColor = blueSaptamanalul
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: 40))
        label.text = "Comentarii"
        label.textColor = UIColor.white
        headerView.addSubview(label)
        headerView.addSubview(doneButton)
        return headerView
    }
    
    
    func setupPostHeader () -> UIView {
        let imageView = UIImageView()
        let image = UIImage(named: "h")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
        return setupPostHeader()
        } else {
           return setupCommentsHeader()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 200
        } else {
            return 40
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 200
        } else {
            return 70
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 240
        } else {
            return 40
        }
    }
    
    
}


