//
//  InfoPageViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 23.08.2024.
//

import UIKit
import MessageUI

class InfoPageViewController: UIViewController {
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var linkedinLabel: UILabel!
    @IBOutlet weak var selectLanguageView: UIView!
    @IBOutlet weak var linkedinView: UIView!
    @IBOutlet weak var sendMailView: UIView!
    @IBOutlet weak var sendMailLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFontSize()
    }
    
    private func setupUI() {
        setupTexts()
        
        addBorder(to: linkedinView, color: UIColor(named: "DarkModeBlack")!, width: 0.7)
        addBorder(to: sendMailView, color: UIColor(named: "DarkModeBlack")!, width: 0.7)
        addBorder(to: selectLanguageView, color: UIColor(named: "DarkModeBlack")!, width: 0.7)
    }
    
    private func setupFontSize() {
        sendMailLabel.font = BaseFont.adjustFontSize(of: sendMailLabel.font, to: 14)
        languageLabel.font = BaseFont.adjustFontSize(of: sendMailLabel.font, to: 14)
        linkedinLabel.font = BaseFont.adjustFontSize(of: sendMailLabel.font, to: 14)
        infoLabel.font = BaseFont.adjustFontSize(of: infoLabel.font, to: 16)
    }
    
    private func setupTexts() {
        infoLabel.text = NSLocalizedString("info_label_text", comment: "Info label text")
        sendMailLabel.text = NSLocalizedString("send_mail_label_text", comment: "Send mail label text")
        linkedinLabel.text = NSLocalizedString("linkedin_label_text", comment: "LinkedIn label text")
    }
    
    private func addBorder(to view: UIView, color: UIColor, width: CGFloat) {
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = width
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
    }
    
    @IBAction func selectLanguageClicked(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "Dil Seç / Select Language", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Türkçe", style: .default, handler: { _ in
            self.setLanguage("tr")
        }))
        alertController.addAction(UIAlertAction(title: "English", style: .default, handler: { _ in
            self.setLanguage("en")
        }))
        
        if let popoverController = alertController.popoverPresentationController {
               popoverController.sourceView = self.view // Popover'ın hangi view'dan gösterileceğini belirtin
               popoverController.sourceRect = CGRect(x: sender.location(in: self.view).x, y: sender.location(in: self.view).y, width: 1, height: 1) // Popover'ın gösterileceği nokta
               popoverController.permittedArrowDirections = .any
           }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setLanguage(_ language: String) {
        UserDefaults.standard.set(language, forKey: "selectedLanguage")
        UserDefaults.standard.synchronize()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.setLanguage()
        }
    }
    
    @IBAction func sendMailClick(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            
            let device = UIDevice.current
            let deviceInfo = """
            Model: \(device.model)
            System Name: \(device.systemName)
            System Version: \(device.systemVersion)
            Name: \(device.name)
            Identifier for Vendor: \(device.identifierForVendor?.uuidString ?? "N/A")
            """
            
            mailComposeVC.setToRecipients(["altugcelil@gmail.com"])
            mailComposeVC.setSubject("Uygulama Hakkında")
            mailComposeVC.setMessageBody("Mesaj gövdesi\n\nCihaz Bilgileri:\n\(deviceInfo)", isHTML: false)
            
            present(mailComposeVC, animated: true, completion: nil)
        } else {
            print("Mail gönderme özelliği mevcut değil.")
        }
    }
    
    @IBAction func goToLinkedin(_ sender: UITapGestureRecognizer) {
        openUrl(url: URL(string: "linkedin://in/altugcelil/")!)
    }
    
    private func openUrl(url: URL) {
        let application = UIApplication.shared
        
        if application.canOpenURL(url) {
            application.open(url)
        } else {
            let linkedinUrl = URL(string: "https://www.linkedin.com/in/altugcelil/")!
            application.open(linkedinUrl)
        }
    }
}

extension InfoPageViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
