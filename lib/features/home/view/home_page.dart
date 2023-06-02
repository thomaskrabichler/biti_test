import 'package:biti_test/features/home/home.dart';
import 'package:biti_test/features/home/view/placeholder_page.dart';
import 'package:biti_test/features/profile/view/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((HomeCubit cubit) => cubit.state.tabIndex);
    Widget page;

    switch (selectedTab) {
      case 0:
        page = const PlacerHolderPage();
        break;
      case 1:
        page = const PlacerHolderPage();
        break;
      case 2:
        page = const ProfilePage();
        break;
      case 3:
        page = const PlacerHolderPage();
        break;
      default:
        throw UnimplementedError('no ui for $selectedTab');
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: Stack(children: [
              NavigationRail(
                groupAlignment: -0.7,
                backgroundColor: const Color(0XFFf5f3f2),
                key: ValueKey(selectedTab),
                extended: true,
                useIndicator: true,
                indicatorColor: Colors.grey.withOpacity(.2),
                labelType: NavigationRailLabelType.none,
                selectedIconTheme: const IconThemeData(
                  color: Colors.black87,
                ),
                selectedLabelTextStyle: const TextStyle(
                  color: Colors.black87,
                ),
                selectedIndex: selectedTab,
                onDestinationSelected: (val) {
                  context.read<HomeCubit>().setTab(val);
                },
                destinations: const [
                  NavigationRailDestination(
                    indicatorColor: Colors.red,
                    icon: Icon(Icons.event_note),
                    label: Text('Schema'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.description),
                    label: Text('Uppföljning'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.bolt),
                    label: Text(
                      'Resurser',
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text(
                      'Inställningar',
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 73.0,
                  top: MediaQuery.of(context).size.height * 0.04,
                ),
                child: const Text(
                  'Lingon',
                  style: TextStyle(fontSize: 22),
                ),
              )
            ]),
          ),
          Expanded(
            child: Container(
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}
