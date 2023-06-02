import 'package:biti_test/common/shared/theme/color_palette.dart';
import 'package:biti_test/features/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RulesSettings extends StatelessWidget {
  const RulesSettings({
    super.key,
    required this.constraints,
  });

  final BoxConstraints constraints;

  final double horizontalPadding = 16;
  @override
  Widget build(BuildContext context) {
    final verticalSpacing = constraints.maxHeight * 0.015;
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          current.rules.length != previous.rules.length,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Rules updated')));
      },
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileHeadline(
                title: 'Regler',
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: verticalSpacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.link,
                            size: 18,
                            color: ColorPalette.green,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Denna individ maste kopplas ihop med följande:',
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorPalette.green,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(),
                      ),
                      Row(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                state.rules.length,
                                (index) => _RuleTag(
                                  title: state.rules[index],
                                  state: state,
                                ),
                              ),
                            ),
                          ),
                          CustomAddButton(
                              color: ColorPalette.green,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      _AddRuleDialog(cubit: cubit),
                                );
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddRuleDialog extends StatelessWidget {
  const _AddRuleDialog({
    required this.cubit,
  });

  final ProfileCubit cubit;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return BlocProvider.value(
      value: cubit,
      child: AlertDialog(
        title: const Text('Add Rule'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Rule'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                cubit.addRule(controller.text);
                Navigator.pop(context);
              },
              child: const Text('Submit'))
        ],
      ),
    );
  }
}

class _RuleTag extends StatelessWidget {
  const _RuleTag({
    required this.title,
    required this.state,
  });
  final String title;
  final ProfileState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8),
        decoration: const BoxDecoration(
          color: ColorPalette.lightGreen,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => context.read<ProfileCubit>().deleteRule(title),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    height: 12,
                    width: 12,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: const Padding(
                      padding: EdgeInsets.all(1),
                      child: Icon(
                        Icons.close,
                        color: ColorPalette.lightGreen,
                        size: 9,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
