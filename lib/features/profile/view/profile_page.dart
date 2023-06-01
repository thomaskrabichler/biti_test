import 'dart:js_util';

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
          print(constraints.maxWidth);
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
                previous.selectedAttributes != current.selectedAttributes ||
                previous.rules != current.rules ||
                previous.assignments != current.assignments ||
                previous.formStatus != current.formStatus,
            builder: (context, state) {
              return ListView(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                          ),
                          child: AttributeSettings(constraints: constraints),
                        ),
                        SizedBox(height: verticalSpacing),
                        const ProfileHeadline(title: 'Kalender'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: horizontalPadding - 65, right: horizontalPadding),
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

class AttributeSettings extends StatelessWidget {
  const AttributeSettings({
    super.key,
    required this.constraints,
  });

  final BoxConstraints constraints;

  final double horizontalPadding = 16;
  @override
  Widget build(BuildContext context) {
    final state = context.read<ProfileCubit>().state;
    final verticalSpacing = constraints.maxHeight * 0.015;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileHeadline(
            title: 'Attribut',
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.light_sharp),
                      Text(
                        'Attribut',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ],
                  ),
                  AttributeType(
                    title: 'Kön',
                    constraints: constraints,
                  ),
                   Row(
                    children: [
                      _GenderSelector(
                          state: state,
                        title: 'Man',
                      ),
                      _GenderSelector(
                          state: state,
                        title: 'Kvinna',
                      ),
                      _GenderSelector(
                          state: state,
                        title: 'Annat',
                      ),
                    ],
                  ),
                  AttributeType(
                    title: 'Sprak',
                    constraints: constraints,
                  ),
                  AttributeType(
                    title: 'Allergier',
                    constraints: constraints,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderSelector extends StatelessWidget {
  const _GenderSelector({
    super.key,
    required this.title, required this.state,
  });

  final String title;
  final ProfileState state;
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
            print(title);
          cubit.updateGender(title);
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: equal(title, cubit.state.selectedAttributes.gender)
                  ? Colors.black87
                  : Colors.grey[200],
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: equal(title, cubit.state.selectedAttributes.gender)
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AttributeType extends StatelessWidget {
  const AttributeType({
    super.key,
    required this.constraints,
    required this.title,
  });

  final double horizontalPadding = 16;
  final BoxConstraints constraints;
  final String title;

  @override
  Widget build(BuildContext context) {
    final verticalSpacing = constraints.maxHeight * 0.015;
    const headlineStyle = TextStyle(fontWeight: FontWeight.w700, fontSize: 12);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalSpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(title, style: headlineStyle),
          SizedBox(width: horizontalPadding * 2),
          const Expanded(
            child: Divider(),
          ),
        ],
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
