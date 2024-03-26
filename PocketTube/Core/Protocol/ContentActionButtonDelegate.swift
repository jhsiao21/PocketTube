import UIKit

protocol ContentActionButtonDelegate : AnyObject {
    func didTappedShareBtn(mediaName: String, image: UIImage)
    func didTappedWatchListBtn(uid: String, media: FMedia)
    func didTappedPlayBtn(media: Media)
    func didTappedRemindeMeBtn()
    func didTappedInfoBtn()
}
