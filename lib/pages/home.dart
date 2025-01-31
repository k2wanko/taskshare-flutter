import 'package:provider/provider.dart';
import 'package:taskshare/bloc/account_bloc.dart';
import 'package:taskshare/widgets/widgets.dart';

import 'task/task_page.dart';
import 'welcome.dart';

class Home extends StatelessWidget {
  const Home();

  
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final accountBloc = Provider.of<AccountBloc>(context);
    return StreamBuilder<AccountState>(
      initialData: accountBloc.state.value,
      stream: accountBloc.state,
      builder: (context, snapshot) {
        switch (snapshot.data) {
          case AccountState.loading:
            return const AppProgressIndicator();
          case AccountState.signedOut:
          case AccountState.signingIn:
            return const Welcome();
          case AccountState.signedIn:
          case AccountState.singingOut:
            return TaskScreen.withDependencies();
        }
        assert(false);
        return Container();
      },
    );
  }
}
