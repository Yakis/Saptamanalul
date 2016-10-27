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


class DetailsViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {

    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var post: Post!
    
    var runTimer: Timer!
    var stopTimer: Timer!
    var comments = [Comment]() {
        didSet {
            tableView.reloadData()
        }
    }
        
    var newCommentVC: NewCommentVC!
    var textView: UITextView!
    
    private let kTableHeaderHeight: CGFloat = UIScreen.main.bounds.height / 2
    
    
    func shareTapped () {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        guard let imageUrl = URL(string: post.image) else {return}
        imageView?.kf.setImage(with: imageUrl)
        vc?.add(imageView?.image)
        vc?.setInitialText("\(post.title)\n\n\(post.body)")
        present(vc!, animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if post.pubImage != "" {
        runTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        stopTimer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(stopTimedCode), userInfo: nil, repeats: true)
    }
    }
    
    
    override func viewDidLoad() {
        registerCells()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(DetailsViewController.shareTapped))
        tableView.dataSource = self
        tableView.delegate = self
        
        getComments()
        
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        updateHeaderView()
        setupPostHeader()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(DetailsViewController.tapOnImage))
        singleTap.numberOfTouchesRequired = 1
        singleTap.numberOfTapsRequired = 1
        singleTap.delegate = self
        headerView?.isUserInteractionEnabled = true
        headerView?.addGestureRecognizer(singleTap)
        
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: UIScreen.main.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        
        headerView.frame = headerRect
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    
    @IBAction func tapOnImage() {
        guard let url = URL(string: post.pubUrl) else {return}
        UIApplication.shared.openURL(url)
    }
    
    
    func registerCells() {
        tableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
        tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.register(UINib(nibName: "BodyCell", bundle: nil), forCellReuseIdentifier: "BodyCell")
        tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
    }
    
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    
    func getComments() {
        let commentsRef = FIRDatabase.database().reference().child("posts").child(post.autoID).child("comments")
        self.comments = []
        DataRetriever.shared.getData(reference: commentsRef) { (snapshot) in
            let comment = Comment(snapshot: snapshot)
            self.comments.append(comment)
        }
    }

    
    func runTimedCode() {
        if let pubImageUrl = URL(string: post.pubImage) {
            imageView?.kf.setImage(with: pubImageUrl)
        }
        runTimer.invalidate()
    }
    
    func stopTimedCode () {
        if let image = URL(string: post.image) {
            imageView?.kf.setImage(with: image)
        stopTimer.invalidate()
        }
    }
    

    func getSubviewFrame () -> CGRect {
        let screenSize = UIScreen.main.bounds.size
        let width = screenSize.width - 40
        let height = screenSize.height / 2
        let xOrigin = (screenSize.width - width) / 2
        let yOrigin = (screenSize.height - height) / 2
        let frame = CGRect(x: xOrigin, y: yOrigin, width: width, height: height)
        return frame
    }
    
    
    func publishAction () {
        let commentsRef = FIRDatabase.database().reference().child("posts").child(self.post.autoID).child("comments")
        guard let currentUser = FIRAuth.auth()?.currentUser else {return}
        let userName = currentUser.displayName!
        let userID = currentUser.uid as String
        if textView.text != "" {
            let text = textView.text as String
            let post = ["text": text, "userName": userName, "userID": userID] as NSDictionary
            commentsRef.childByAutoId().setValue(post)
            dismissSubviewAnimated()
        } else {
            dismissSubviewAnimated()
        }
    }
    
    
    func newCommentButtonTapped () {
        guard CurrentUser.shared.isLoggedIn() else {
            Utils.showAlert(title: Login.title, message: Login.message, controller: self)
            return
        }
        newCommentVC = NewCommentVC(nibName: "NewCommentVC", bundle: nil)
        newCommentVC.view.frame = getSubviewFrame()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        self.view.addSubview(newCommentVC.view)
        newCommentVC.publishButtonOutlet.addTarget(self, action: #selector(DetailsViewController.publishAction), for: .touchUpInside)
        self.textView = newCommentVC.textView
        
    }
    
    
    
    func hideKeyboard() {
        newCommentVC.view.endEditing(true)
    }
    
    
    func dismissSubviewAnimated () {
        UIView.animateKeyframes(withDuration: 1, delay: 0.0, options: .beginFromCurrentState, animations: {
            self.newCommentVC.view.alpha = 0
            }) { (Bool) in
                self.newCommentVC.view.removeFromSuperview()
        }
    }
    
    
}


extension DetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
        return 2
        } else {
            return comments.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
                let titleCell = tableView.dequeueReusableCell(withIdentifier: DetailsCell.titleIdentifier, for: indexPath) as! TitleCell
                titleCell.titleLabel.text = post.title
                return titleCell
        case (0, 1):
                let bodyCell = tableView.dequeueReusableCell(withIdentifier: DetailsCell.bodyIdentifier, for: indexPath) as! BodyCell
                bodyCell.bodyLabel.text = post.body
                return bodyCell
        case (1, _): let commentCell = tableView.dequeueReusableCell(withIdentifier: DetailsCell.commentIdentifier, for: indexPath) as! CommentCell
                let comment = comments[indexPath.row]
                commentCell.userName.text = comment.userName
                commentCell.bodyLabel.text = comment.text
                return commentCell
        default: return UITableViewCell()
        }
        
    }
    
    
}


extension DetailsViewController: UITableViewDelegate {
    
    
    func setupCommentsHeader () -> UIView {
        let frame: CGRect = UIScreen.main.bounds
        let newCommentButton: UIButton = UIButton(frame: CGRect(x: frame.width-40, y: 5, width: 30, height: 30))
        newCommentButton.setImage(UIImage(named: "newComment"), for: .normal)
        newCommentButton.addTarget(self, action: #selector(DetailsViewController.newCommentButtonTapped), for: .touchUpInside)
        let commentHeader: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        commentHeader.backgroundColor = blueSaptamanalul
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: 40))
        label.text = DetailsCell.commentHeader
        label.textColor = UIColor.white
        commentHeader.addSubview(label)
        commentHeader.addSubview(newCommentButton)
        return commentHeader
    }
    
    
    func setupPostHeader() {
        guard let url = URL(string: post.image) else {return}
        imageView?.kf.setImage(with: url)
        imageView?.contentMode = .scaleAspectFill
        imageView?.clipsToBounds = true
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return headerView
        } else {
            return setupCommentsHeader()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
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
            return 0
        } else {
            return 40
        }
    }
    
    
}


