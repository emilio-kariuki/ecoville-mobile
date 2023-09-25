import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoville_bloc/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/app_functionality/authentication_bloc/authentication_bloc.dart';
import 'blocs/app_functionality/location/location_cubit.dart';
import 'blocs/app_functionality/user/user_cubit.dart';
import 'blocs/minimal_functionality/network_observer/network_bloc.dart';
import 'route_config/route_generator.dart';
import 'utilities/common_widgets/no_internet.dart';
import 'utilities/common_widgets/splash_page.dart';
import 'views/authentication/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChannels.textInput.invokeMethod('TextInput.hide');
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => NetworkBloc()..add(NetworkObserve()),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => AuthenticationBloc()..add(AppStarted()),
        ),
        BlocProvider(lazy: false, create: (context) => UserCubit()..getUser()),
        // BlocProvider(lazy: true, create: (context) => ProductCubit()..fetchProducts()),

        BlocProvider(
          lazy: false,
          create: (context) => LocationCubit()..getCurrentLocation(),
        ),
       
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        onGenerateRoute: (settings) {
          return RouteGenerator.generateRoute(settings);
        },
        home: BlocBuilder<NetworkBloc, NetworkState>(
          builder: (context, state) {
            if (state is NetworkFailure) {
              return NoInternet();
            } else if (state is NetworkSuccess) {
              return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is AuthenticationAuthenticated) {
                    return const SplashPage();
                  } else if (state is AuthenticationUnauthenticated) {
                    return LoginPage();
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
