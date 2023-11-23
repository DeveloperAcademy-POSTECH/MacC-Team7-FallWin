
import Foundation
import GoogleMobileAds

class RewardAdsManager: NSObject,GADFullScreenContentDelegate,ObservableObject{
    
    // Properties
    @Published var rewardLoaded:Bool = false
    var rewardAd:GADRewardedAd?
    
    override init() {
        super.init()
    }
    
    // Load reward ads
    func loadReward(){
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: GADRequest()) { [weak self] add, error in
            guard let self = self else {return}
            if let error  = error {
                print("🔴: \(error.localizedDescription)")
                self.rewardLoaded = false
                return
            }
            print("🟢: Loading succeeded")
            self.rewardLoaded = true
            self.rewardAd = add
            self.rewardAd?.fullScreenContentDelegate = self
        }
    }
    
    // Display reward ads
    func displayReward(){
        guard let root = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        if let ad = rewardAd{
            ad.present(fromRootViewController: root) {
                print("🟢: Earned a reward")
                //여기서 보상이 주어진다.
                self.rewardLoaded = false
            }
        } else {
            print("🔵: Ad wasn't ready")
            self.rewardLoaded = false
            self.loadReward()
        }
    }
}
