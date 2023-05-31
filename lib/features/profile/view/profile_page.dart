import 'package:biti_test/features/calendar/calendar.dart';
import 'package:biti_test/features/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..initProfile(),
      child: const ProfileView(),
    );
  }
}

final UniqueKey key = UniqueKey();

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          const paddingPercentage = 0.17;
          final horizontalPadding = screenWidth * paddingPercentage;
          final verticalSpacing = screenHeight * 0.06;
          return BlocConsumer<ProfileCubit, ProfileState>(
            listenWhen: (previous, current) =>
                previous.formStatus != current.formStatus,
            listener: (context, state) {
              if (state.formStatus == FormStatus.clear) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User details cleared!'),
                  ),
                );
              } else if (state.formStatus == FormStatus.save) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User details saved!'),
                  ),
                );
              }
            },
            buildWhen: (previous, current) =>
                previous.avatarColor != current.avatarColor ||
                previous.userAttributes != current.userAttributes ||
                previous.rules != current.rules ||
                previous.assignments != current.assignments ||
                previous.formStatus != current.formStatus,
            builder: (context, state) {
              return ListView(
                  
                children: [
                  Padding(
                 padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: verticalSpacing),
                          child: const NavigationIndicator(),
                        ),
                        _AvatarSelector(state: state),
                        SizedBox(height: verticalSpacing),
                        const ProfileHeadline(title: 'Uppgifter'),
                        const UserDetailsForm(),
                        SizedBox(height: verticalSpacing),
                        const ProfileHeadline(title: 'Kalender'),
                      ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left:horizontalPadding-65, right: horizontalPadding),
                    child: const CalendarWidget(),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}


class _AvatarSelector extends StatelessWidget {
  const _AvatarSelector({required this.state});
  final ProfileState state;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileHeadline(title: 'Avatar'),
        Row(
          children: [
            _ColorPicker(color: Colors.blueGrey, state: state),
            _ColorPicker(color: Colors.redAccent, state: state),
            _ColorPicker(color: Colors.greenAccent, state: state),
          ],
        ),
      ],
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({
    required this.color,
    required this.state,
  });

  final Color color;
  final ProfileState state;
  @override
  Widget build(BuildContext context) {
    final ProfileCubit profileCubit = context.read<ProfileCubit>();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => profileCubit.avatarColorChanged(color),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: profileCubit.state.avatarColor == color
                  ? Border.all(color: Colors.blueAccent, width: 3)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationIndicator extends StatelessWidget {
  const NavigationIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const TextStyle titleStyle =
        TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Resurser', style: titleStyle),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Icon(
            Icons.arrow_forward_ios,
            size: 10,
          ),
        ),
        Text(
          'New Profile',
          style: titleStyle,
        ),
      ],
    );
  }
}
