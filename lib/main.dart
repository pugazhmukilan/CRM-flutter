import 'package:crm_app/bloc/campaign_bloc.dart';
import 'package:crm_app/bloc/data_ingestion_bloc.dart';
import 'package:crm_app/pages/campaign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';
import 'repositories/auth_repository.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'package:crm_app/backend.dart' as backend;

void main() {
  var backendBase =backend.BACKEND_URL; // match your FastAPI
  final repo = AuthRepository(backendBase: backendBase);

  runApp(App(repo: repo));
}

class App extends StatelessWidget {
  final AuthRepository repo;
  const App({Key? key, required this.repo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(repo: repo)..add(AppStarted()),
        ),
        BlocProvider(
          create: (_) => DataIngestionBloc(),
        ),

        BlocProvider(
          create:  (_) => CampaignBloc()..add(FetchCampaignsEvent())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Mini CRM",
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.isAuthenticated) {
              return const HomePage();
            } else {
              return LoginPage(repo: repo);
            }
          },
        ),
        //home:HomePage(),
      ),
    );
  }
}
