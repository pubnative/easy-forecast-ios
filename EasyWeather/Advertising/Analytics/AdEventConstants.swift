//
//  Copyright © 2019 EasyNaps. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

let EVENT_START_LOADING = "ad_start_loading";
let EVENT_LOADED = "ad_loaded";
let EVENT_LOAD_ERROR = "ad_load_error";
let EVENT_IMPRESSION = "ad_track_impression";
let EVENT_CLICK = "ad_track_click";
let EVENT_OPENED = "ad_opened";
let EVENT_CLOSED = "ad_closed";
let EVENT_LEFT_APP = "ad_left_app";
let EVENT_INTERSTITIAL_SHOW = "ad_interstitial_show";
let EVENT_INTERSTITIAL_SHOWN = "ad_interstitial_shown";
let EVENT_INTERSTITIAL_SHOW_ERROR = "ad_interstitial_show_error";
let EVENT_INTERSTITIAL_DISMISSED = "ad_interstitial_dismissed";
let EVENT_AUDIO_STARTED = "ad_audio_started";
let EVENT_AUDIO_FINISHED = "ad_audio_finished";
let EVENT_VIDEO_STARTED = "ad_video_started";
let EVENT_VIDEO_FINISHED = "ad_video_finished";
let EVENT_VIDEO_INCOMPLETE = "ad_video_incomplete";
let EVENT_VIDEO_ERROR = "ad_video_error";
let EVENT_REWARD = "ad_reward";
let EVENT_REWARD_REJECTED = "ad_reward_rejected";
let EVENT_DECLINED_TO_VIEW_AD = "ad_declined_to_view";
let EVENT_USER_OVER_QUOTA = "ad_user_over_quota";
let EVENT_VALIDATION_REQUEST_FAILED = "ad_validation_request_failed";

let KEY_AD_TYPE = "ad_type";
let KEY_SDK_NAME = "sdk_name";
let KEY_TIME_ELAPSED = "time_elapsed";
let KEY_CATEGORY = "category";
let CATEGORY_ADVERTISING = "advertising";
