import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'presentation/pages/page_sign_in_firebase.dart';
import 'presentation/state_management/provider/provider_favorites_places.dart';
import 'presentation/state_management/provider/provider_chat_screen.dart';
import 'presentation/state_management/provider/provider_custom_map_list.dart';
import 'presentation/state_management/provider/provider_home_chat.dart';
import 'presentation/state_management/provider/provider_list_map.dart';
import 'presentation/state_management/provider/provider_live_chat.dart';
import 'presentation/state_management/provider/provider_live_favorite_places.dart';
import 'presentation/state_management/provider/provider_map_list.dart';
import 'presentation/state_management/provider/provider_phone_sms_auth.dart';
import 'presentation/state_management/provider/provider_register_email_firebase.dart';
import 'presentation/state_management/provider/provider_list_settings.dart';
import 'presentation/state_management/provider/provider_chat_settings.dart';
import 'presentation/state_management/provider/provider_sign_in_firebase.dart';
import 'presentation/state_management/provider/provider_video_call.dart';
import 'data/models/model_stream_location/user_location.dart';
import 'core/services/location_service.dart';
//import 'core/services/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    //  setupLocator();
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserLocation>(
          create: (context) => LocationService().locationStream,
        ),
        ChangeNotifierProvider<ProviderFavoritesPlaces>(
          create: (context) => ProviderFavoritesPlaces(),
        ),
        ChangeNotifierProvider<ProviderChatScreen>(
          create: (context) => ProviderChatScreen(),
        ),
        ChangeNotifierProvider<ProviderCustomMapList>(
          create: (context) => ProviderCustomMapList(),
        ),
        ChangeNotifierProvider<ProviderHomeChat>(
          create: (context) => ProviderHomeChat(),
        ),
        ChangeNotifierProvider<ProviderListMap>(
          create: (context) => ProviderListMap(),
        ),
        ChangeNotifierProvider<ProviderLiveChat>(
          create: (context) => ProviderLiveChat(),
        ),
        ChangeNotifierProvider<ProviderLiveFavoritePlaces>(
          create: (context) => ProviderLiveFavoritePlaces(),
        ),
        ChangeNotifierProvider<ProviderMapList>(
          create: (context) => ProviderMapList(),
        ),
        ChangeNotifierProvider<ProviderPhoneSMSAuth>(
          create: (context) => ProviderPhoneSMSAuth(),
        ),
        ChangeNotifierProvider<ProviderRegisterEmailFirebase>(
          create: (context) => ProviderRegisterEmailFirebase(),
        ),
        ChangeNotifierProvider<ProviderListSettings>(
          create: (context) => ProviderListSettings(),
        ),
        ChangeNotifierProvider<ProviderSettingsChat>(
          create: (context) => ProviderSettingsChat(),
        ),
        ChangeNotifierProvider<ProviderSignInFirebase>(
          create: (context) => ProviderSignInFirebase(),
        ),
        ChangeNotifierProvider<ProviderVideoCall>(
          create: (context) => ProviderVideoCall(),
        ),
      ],
      child: MaterialApp(
        home: PageSignInFirebase(),
      ),
    );
  }
}
