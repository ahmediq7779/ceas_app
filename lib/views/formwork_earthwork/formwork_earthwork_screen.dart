import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/haptic_service.dart';
import '../../core/widgets/custom_app_bar.dart';
import 'tabs/formwork_contact_tab.dart';
import 'tabs/excavation_backfill_tab.dart';

class FormworkEarthworkScreen extends StatelessWidget {
  const FormworkEarthworkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppStrings.formworkModule,
          subtitle: 'حساب مسطح الشدات الخشبية وأعمال الحفر والردم والتربة',
          bottom: TabBar(
            onTap: (_) => HapticService.selection(),
            tabs: const [
              Tab(
                icon: Icon(Icons.square_foot_rounded, size: 18),
                text: AppStrings.formworkArea,
              ),
              Tab(
                icon: Icon(Icons.terrain_rounded, size: 18),
                text: AppStrings.excavationBackfill,
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FormworkContactTab(),
            ExcavationBackfillTab(),
          ],
        ),
      ),
    );
  }
}
