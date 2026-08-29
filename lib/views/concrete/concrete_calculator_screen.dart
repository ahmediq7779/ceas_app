import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/haptic_service.dart';
import '../../core/widgets/custom_app_bar.dart';
import 'tabs/concrete_mix_tab.dart';
import 'tabs/masonry_block_tab.dart';

class ConcreteCalculatorScreen extends StatelessWidget {
  const ConcreteCalculatorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppStrings.concreteModule,
          subtitle: 'حساب خلطات الخرسانة وحصر البلوك والمونة الإنشائية',
          bottom: TabBar(
            onTap: (_) => HapticService.selection(),
            tabs: const [
              Tab(
                icon: Icon(Icons.grain_rounded, size: 18),
                text: AppStrings.concreteMix,
              ),
              Tab(
                icon: Icon(Icons.view_comfy_alt_outlined, size: 18),
                text: AppStrings.masonryBlocks,
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ConcreteMixTab(),
            MasonryBlockTab(),
          ],
        ),
      ),
    );
  }
}
