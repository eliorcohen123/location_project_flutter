import 'dart:io';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:locationprojectflutter/presentation/pages/page_chat_screen.dart';
import 'package:locationprojectflutter/presentation/pages/page_chat_settings.dart';
import 'package:locationprojectflutter/presentation/pages/page_custom_map_list.dart';
import 'package:locationprojectflutter/presentation/pages/page_favorite_places.dart';
import 'package:locationprojectflutter/presentation/pages/page_full_photo.dart';
import 'package:locationprojectflutter/presentation/pages/page_home_chat.dart';
import 'package:locationprojectflutter/presentation/pages/page_list_map.dart';
import 'package:locationprojectflutter/presentation/pages/page_list_settings.dart';
import 'package:locationprojectflutter/presentation/pages/page_live_chat.dart';
import 'package:locationprojectflutter/presentation/pages/page_live_favorite_places.dart';
import 'package:locationprojectflutter/presentation/pages/page_map_list.dart';
import 'package:locationprojectflutter/presentation/pages/page_register_email_firebase.dart';
import 'package:locationprojectflutter/presentation/pages/page_sign_in_firebase.dart';
import 'package:locationprojectflutter/presentation/pages/page_simple_image_crop.dart';
import 'package:locationprojectflutter/presentation/pages/page_video_call.dart';
import 'package:locationprojectflutter/presentation/pages/page_phone_sms_auth.dart';

class ShowerPages {
  static void pushPageChatScreen(
      BuildContext context, String peerId, String peerAvatar) {
    if (kIsWeb) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PageChatScreen(
                peerId: peerId,
                peerAvatar: peerAvatar,
              )));
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PageChatScreen(
                  peerId: peerId,
                  peerAvatar: peerAvatar,
                )));
      } else {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => PageChatScreen(
                  peerId: peerId,
                  peerAvatar: peerAvatar,
                )));
      }
    }
  }

  static void pushPageChatSettings(BuildContext context) {
    if (kIsWeb) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PageChatSettings()));
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PageChatSettings()));
      } else {
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (context) => PageChatSettings()));
      }
    }
  }

  static void pushPageCustomMapList(BuildContext context) {
    if (kIsWeb) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PageCustomMapList()));
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PageCustomMapList()));
      } else {
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => PageCustomMapList()));
      }
    }
  }

  static void pushPageFavoritePlaces(BuildContext context) {
    if (kIsWeb) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PageFavoritePlaces()));
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PageFavoritePlaces()));
      } else {
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => PageFavoritePlaces()));
      }
    }
  }

  static void pushPageFullPhoto(BuildContext context, String url) {
    if (kIsWeb) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PageFullPhoto(url: url)));
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PageFullPhoto(url: url)));
      } else {
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => PageFullPhoto(url: url)));
      }
    }
  }

  static void pushPageHomeChat(BuildContext context) {
    if (kIsWeb) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PageHomeChat()));
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PageHomeChat()));
      } else {
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (context) => PageHomeChat()));
      }
    }
  }

  static void pushPageListMap(BuildContext context) {
    if (kIsWeb) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PageListMap()));
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PageListMap()));
      } else {
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (context) => PageListMap()));
      }
    }
  }

  static void pushPageListSettings(BuildContext context) {
    if (kIsWeb) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PageListSettings()));
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PageListSettings()));
      } else {
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (context) => PageListSettings()));
      }
    }
  }

  static void pushPageLiveChat(BuildContext context) {
    if (kIsWeb) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PageLiveChat()));
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PageLiveChat()));
      } else {
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (context) => PageLiveChat()));
      }
    }
  }

  static void pushPageLiveFavoritePlaces(BuildContext context) {
    if (kIsWeb) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PageLiveFavoritePlaces()));
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PageLiveFavoritePlaces()));
      } else {
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => PageLiveFavoritePlaces()));
      }
    }
  }

  static void pushPageMapList(BuildContext context, String nameList,
      String vicinityList, double latList, double lngList) {
    if (kIsWeb) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PageMapList(
                nameList: nameList,
                vicinityList: vicinityList,
                latList: latList,
                lngList: lngList,
              )));
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PageMapList(
                  nameList: nameList,
                  vicinityList: vicinityList,
                  latList: latList,
                  lngList: lngList,
                )));
      } else {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => PageMapList(
                  nameList: nameList,
                  vicinityList: vicinityList,
                  latList: latList,
                  lngList: lngList,
                )));
      }
    }
  }

  static void pushPageRegisterEmailFirebase(BuildContext context) {
    if (kIsWeb) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PageRegisterEmailFirebase()));
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PageRegisterEmailFirebase()));
      } else {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => PageRegisterEmailFirebase()));
      }
    }
  }

  static void pushPageSignInFirebase(BuildContext context) {
    if (kIsWeb) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PageSignInFirebase()));
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PageSignInFirebase()));
      } else {
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => PageSignInFirebase()));
      }
    }
  }

  static void pushRemoveReplacementPageSignInFirebase(BuildContext context) {
    if (kIsWeb) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => PageSignInFirebase()),
          (Route<dynamic> route) => false);
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => PageSignInFirebase()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (context) => PageSignInFirebase()),
            (Route<dynamic> route) => false);
      }
    }
  }

  static void pushPageVideoCall(
      BuildContext context, String channelName, ClientRole role) {
    if (kIsWeb) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PageVideoCall(
                channelName: channelName,
                role: role,
              )));
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PageVideoCall(
                  channelName: channelName,
                  role: role,
                )));
      } else {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => PageVideoCall(
                  channelName: channelName,
                  role: role,
                )));
      }
    }
  }

  static Future pushPageSimpleImageCrop(
      BuildContext context, File image) async {
    if (kIsWeb) {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PageSimpleImageCrop(image: image)));
    } else {
      if (Platform.isAndroid) {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PageSimpleImageCrop(image: image)));
      } else {
        await Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => PageSimpleImageCrop(image: image)));
      }
    }
    return image;
  }

  static void pushPagePhoneSmsAuth(BuildContext context) {
    if (kIsWeb) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PagePhoneSMSAuth()));
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PagePhoneSMSAuth()));
      } else {
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (context) => PagePhoneSMSAuth()));
      }
    }
  }

  static void pushDrawerTotal(BuildContext context, cls) {
    if (kIsWeb) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => cls));
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => cls));
      } else {
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (context) => cls));
      }
    }
  }
}
