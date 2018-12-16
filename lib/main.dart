import 'package:taskshare/app.dart';
import 'package:taskshare/bloc/account_bloc.dart';
import 'package:taskshare/model/authenticator.dart';
import 'package:taskshare/model/service_provider.dart';
import 'package:taskshare/util/logger.dart';
import 'package:taskshare/widgets/widgets.dart';

void main() {
  configureLogger(Level.trace);
  runApp(
    ServiceProvider(
      authenticator: GoogleAuthenticator(),
      child: App(),
    ),
  );
}
