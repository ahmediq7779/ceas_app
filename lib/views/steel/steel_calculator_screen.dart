import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/haptic_service.dart';
import '../../core/widgets/custom_app_bar.dart';
import 'tabs/rebar_weight_tab.dart';
import 'tabs/lap_splice_tab.dart';
import 'tabs/stirrups_ties_tab.dart';

class SteelCalculatorScreen extends StatelessWidget {
  const SteelCalculatorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppStrings.steelModule,
          subtitle: 'حصر أوزان التسليح، أطوال التراكب والوصل، وتصميم الكانات',
          bottom: TabBar(
            onTap: (_) => HapticService.selection(),
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(
                icon: Icon(Icons.fitness_center_rounded, size: 18),
                text: AppStrings.rebarWeight,
              ),
              Tab(
                icon: Icon(Icons.compare_arrows_rounded, size: 18),
                text: AppStrings.lapSplice,
              ),
              Tab(
                icon: Icon(Icons.border_all_rounded, size: 18),
                text: AppStrings.stirrupsTies,
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            RebarWeightTab(),
            LapSpliceTab(),
            StirrupsTiesTab(),
          ],
        ),
      ),
    );
  }
}
