
###Install

mkdir teamxrtc
cd teamxrtc

git clone XMPPFramework
git clone XEP-0166
git clone XEP-0327

git clone MeetRTCSDK_objc

cd MeetRTCSDK_objc
cd MeetRTCSDK_ios
pod install

open MeetRTCSDK_ios.xcworkspace