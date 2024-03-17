
import Foundation
import GoogleMobileAds

class RewardAdsManager: NSObject, GADFullScreenContentDelegate {
    
    // Properties
    var rewardLoaded: Bool = false
    var rewardAd:GADRewardedAd?
    
    override init() {
        super.init()
    }
    
    // Load reward ads
    func loadReward() async -> GADRewardedAd? {
        do {
            let ad = try await GADRewardedAd.load(withAdUnitID: Bundle.main.adUnitId, request: GADRequest())
            ad.fullScreenContentDelegate = self
            return ad
        } catch {
            print(#function, error)
            return nil
        }
    }
    
    func loadReward(){
        GADRewardedAd.load(withAdUnitID: Bundle.main.adUnitId, request: GADRequest()) { [weak self] add, error in
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
    @discardableResult
    func displayReward() async -> Bool {
        guard let root = await UIApplication.shared.keyWindow?.rootViewController else {
            return false
        }
        
        if let ad = await loadReward() {
            return await withUnsafeContinuation { continuation in
                DispatchQueue.main.async {
                    ad.present(fromRootViewController: root) {
                        continuation.resume(returning: true)
                    }
                }
            }
        }
        
        return false
    }
    
    func displayReward(onReward: @escaping (Bool) -> Void) {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        if let ad = rewardAd{
            ad.present(fromRootViewController: root) {
                print("🟢: Earned a reward")
                //여기서 보상이 주어진다.
                self.rewardLoaded = false
                onReward(true)
            }
        } else {
            print("🔵: Ad wasn't ready")
            self.rewardLoaded = false
            self.loadReward()
        }
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
      func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
      }

      /// Tells the delegate that the ad will present full screen content.
      func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
      }

      /// Tells the delegate that the ad dismissed full screen content.
      func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
      }
}
