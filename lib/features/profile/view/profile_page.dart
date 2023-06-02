import 'package:biti_test/common/shared/theme/color_palette.dart';
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

          final availableWidth = screenWidth - horizontalPadding * 2;
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
                        _SettingsBox(
                            child: AttributeSettings(constraints: constraints)),
                        SizedBox(height: verticalSpacing),
                        _SettingsBox(
                          child: RulesSettings(constraints: constraints),
                        ),
                        SizedBox(height: verticalSpacing),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProfileHeadline(title: 'Kalender'),
                            CalenderPageController()
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: horizontalPadding - 65,
                        right: horizontalPadding,
                        top: verticalSpacing / 2),
                    child: CalendarWidget(availableWidth: availableWidth - 45),
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

class CalenderPageController extends StatelessWidget {
  const CalenderPageController({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          splashRadius: 16,
          padding: EdgeInsets.zero,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('not implemented'),
              ),
            );
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 16,
          ),
        ),
        const Text(
          'Vecka 9',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        ),
        FittedBox(
          child: IconButton(
            splashRadius: 16,
            padding: EdgeInsets.zero,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('not implemented'),
                ),
              );
            },
            icon: const Icon(
              Icons.chevron_right,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsBox extends StatelessWidget {
  const _SettingsBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: ColorPalette.lightGrey,
      ),
      child: child,
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
            _ColorPicker(color: ColorPalette.avatarGrey, state: state),
            _ColorPicker(color: ColorPalette.avatarGreen, state: state),
            _ColorPicker(color: ColorPalette.avatarRedAccent, state: state),
            _ColorPicker(color: ColorPalette.avatarBeige, state: state),
            _ColorPicker(color: ColorPalette.avatarBlue, state: state),
            _ColorPicker(color: ColorPalette.avatarPurple, state: state),
            _ColorPicker(color: ColorPalette.avatarCyan, state: state),
            _ColorPicker(color: ColorPalette.avatarRed, state: state),
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
                  ? Border.all(color: ColorPalette.avatarSelected, width: 3)
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
