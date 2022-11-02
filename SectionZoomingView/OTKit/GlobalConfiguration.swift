import UIKit

public class GlobalConfiguration : NSObject {
    @objc(sharedInstance)
    public static let shared =  GlobalConfiguration()

    // MARK: - Colors
    @objc
    public lazy var appTintColor: UIColor = {
        return OTKit.Color.red
    }()

    public lazy var friendColors: [UIColor] = {
        return [
            OTKit.Color.fuchsia,
            OTKit.Color.teal_light,
            OTKit.Color.red_dark,
            OTKit.Color.green_light,
            OTKit.Color.orange_light,
            OTKit.Color.red,
            OTKit.Color.ash_dark,
            OTKit.Color.aqua
        ]
    }()

    public lazy var inviteFriendBlue: UIColor = {
        return OTKit.Color.teal_lighter
    }()

    public lazy var menuSectionCellStrokeColor: UIColor = {
        return OTKit.Color.ash_lighter
    }()

    public lazy var profilePersonalizerBlueBackround: UIColor = {
        return OTKit.Color.teal_lightest
    }()

    public lazy var profilePersonalizerBlueText: UIColor = {
        return OTKit.Color.blue
    }()

    public var timeslotSelectionColor: UIColor { return OTKit.Color.red_dark_immutable }

    public var appBlueColor: UIColor { return OTKit.Color.teal_lighter }
    public var backgroundColor: UIColor { return OTKit.Color.white }
    public var badgeBackgroundColor: UIColor { return OTKit.Color.red_dark }
    public var bannerFailedBackgroundColor: UIColor { return OTKit.Color.red_lightest }
    public var bannerSucceededBackgroundColor: UIColor { return OTKit.Color.green_lightest }
    public var bannerWarningBackgroundColor: UIColor { return OTKit.Color.yellow_lightest }
    public var bannerWarningColor: UIColor { return OTKit.Color.yellow }
    public var blackColor: UIColor { return OTKit.Color.ash_dark }
    public var borderColor: UIColor { return OTKit.Color.ash_lighter }
    public var carouselCellBackgroundColor: UIColor { return OTKit.Color.ash_lightest }
    public var collectionBannerPlaceholderColor: UIColor { return OTKit.Color.ash_lighter }
    public var collectionBorderColor: UIColor { return OTKit.Color.ash_lighter }
    public var collectionZeroStateHighlight: UIColor { return OTKit.Color.ash }
    public var currentLocationColor: UIColor { return OTKit.Color.blue }
    public var darkTextColor: UIColor { return OTKit.Color.ash_dark }
    public var defaultTextBlueColor: UIColor { return OTKit.Color.blue }
    public var dialogDescriptionTextColor: UIColor { return OTKit.Color.ash }
    public var dtpCellBorderColor: UIColor { return OTKit.Color.ash_lighter }
    public var floatingPillHighlightedColor: UIColor { return OTKit.Color.teal_dark }
    public var floatingPillShadowColor: UIColor { return OTKit.Color.teal }
    public var fullMapBookmarkGray: UIColor { return OTKit.Color.ash_light }
    public var gradientAllRestaurantsEndColor: UIColor { return OTKit.Color.blue_dark }
    public var gradientAllRestaurantsStartColor: UIColor { return OTKit.Color.teal_light }
    public var gradientDinnerTonightEndColor: UIColor { return OTKit.Color.blue_dark }
    public var gradientDinnerTonightStartColor: UIColor { return OTKit.Color.fuchsia_dark }
    public var gradientMostPopularEndColor: UIColor { return OTKit.Color.teal_light }
    public var gradientMostPopularStartColor: UIColor { return OTKit.Color.green_lighter }
    public var gradientMyFavoriteEndColor: UIColor { return OTKit.Color.red }
    public var gradientMyFavoriteStartColor: UIColor { return OTKit.Color.yellow_light }
    public var gradientNearMeNowEndColor: UIColor { return OTKit.Color.fuchsia_dark }
    public var gradientNearMeNowStartColor: UIColor { return OTKit.Color.red }
    public var homeDiscoverDarkGreyColor: UIColor { return OTKit.Color.ash_dark }
    public var homeSearchDiscoverBackgroundColor: UIColor { return OTKit.Color.ash_darker }
    public var lightGrayBorderColor: UIColor { return OTKit.Color.ash_lighter }
    public var maxLimitTextColor: UIColor { return OTKit.Color.red }
    public var navigationBarTintColor: UIColor { return OTKit.Color.white }
    public var noTimeslotBackgroundColor: UIColor { return OTKit.Color.ash_lightest_ash }
    public var placeholderTextColor: UIColor { return OTKit.Color.ash_light }
    public var pointLabelTextColor: UIColor { return OTKit.Color.ash }
    public var promoCampaignColor: UIColor { return OTKit.Color.green_lighter }
    public var promptedTagBackgroundColor: UIColor { return OTKit.Color.ash_lightest }
    public var rewardGoldColor: UIColor { return OTKit.Color.yellow_light }
    public var rewardGrayColor: UIColor { return OTKit.Color.ash_lighter }
    public var rewardTier0BackgroundColor: UIColor { return OTKit.Color.fuchsia_lightest }
    public var rewardTier0RedColor: UIColor { return OTKit.Color.red }
    public var rewardTier0RedColorDarkened: UIColor { return OTKit.Color.red_dark_immutable }
    public var rewardTier1BackgroundColor: UIColor { return OTKit.Color.teal_lightest }
    public var rewardTier1BlueColor: UIColor { return OTKit.Color.teal_lighter }
    public var rewardTier1BlueColorDarkened: UIColor { return OTKit.Color.teal_dark }
    public var rewardTier2BackgroundColor: UIColor { return OTKit.Color.green_lightest }
    public var rewardTier2GreenColor: UIColor { return OTKit.Color.green_lighter }
    public var rewardTier2GreenColorDarkened: UIColor { return OTKit.Color.green }
    public var rewardTier3BackgroundColor: UIColor { return OTKit.Color.red_lightest }
    public var rewardTier3PurpleColor: UIColor { return OTKit.Color.fuchsia_dark }
    public var rewardTier3PurpleColorDarkened: UIColor { return OTKit.Color.purple_darker }
    public var searchHeaderDtpTextColor: UIColor { return OTKit.Color.ash_light }
    public var secondaryAppTintColor: UIColor { return OTKit.Color.blue }
    public var segmentedTextColor: UIColor { return OTKit.Color.ash }
    public var selectionColor: UIColor { return OTKit.Color.ash_lighter }
    public var selectedWaitlistProductColor: UIColor { return OTKit.Color.teal }
    public var separatorColor: UIColor { return OTKit.Color.ash_lighter }
    public var shadowColor: UIColor { return UIColor(red:0, green:0, blue:0, alpha:0.2) }
    public var submissionBannerFailedColor: UIColor { return OTKit.Color.red_dark }
    public var submissionBannerSucceededColor: UIColor { return OTKit.Color.green }
    public var tableHeaderBackColor: UIColor { return OTKit.Color.ash_lightest }
    public var tableHeaderTextColor: UIColor { return OTKit.Color.ash_light }
    public var unifiedDtpHighlightColor: UIColor { return OTKit.Color.red }
    public var unifiedDtpTextColor: UIColor { return OTKit.Color.ash_dark }
    public var waitlistProductColor: UIColor { return OTKit.Color.teal }
    public var whiteColor: UIColor { return OTKit.Color.white }
}
