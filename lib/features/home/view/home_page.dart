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
            child: NavigationRail(
              backgroundColor: const Color(0XFFf5f3f2),
              key: ValueKey(selectedTab),
              extended: true,
              useIndicator: true,
              indicatorColor: Colors.grey.withOpacity(.2),
              labelType: NavigationRailLabelType.none,

              selectedIconTheme: const IconThemeData(
                color: Colors.black87,
              ), // Set the icon color for selected item
              selectedLabelTextStyle: const TextStyle(
                color: Colors.black87,
              ), // Set the label text color for selected item
              selectedIndex: selectedTab,
              onDestinationSelected: (val) {
                context.read<HomeCubit>().setTab(val);
              },
              destinations: const [
                NavigationRailDestination(
                  indicatorColor: Colors.red,
                  icon: Icon(Icons.mp),
                  label: Text('Schema'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.schedule),
                  label: Text('Uppföljning'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.light_rounded),
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
