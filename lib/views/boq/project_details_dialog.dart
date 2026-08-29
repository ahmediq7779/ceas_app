import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_styles.dart';
import '../../core/utils/haptic_service.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../services/pdf_report_service.dart';

class ProjectDetailsDialog extends StatefulWidget {
  final void Function(ProjectMetadata metadata, bool isShare) onConfirm;

  const ProjectDetailsDialog({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<ProjectDetailsDialog> createState() => _ProjectDetailsDialogState();
}

class _ProjectDetailsDialogState extends State<ProjectDetailsDialog> {
  final _formKey = GlobalKey<FormState>();

  final _projectNameCtrl = TextEditingController(text: 'مشروع فيلا سكنية - أعمال العظم');
  final _engineerCtrl = TextEditingController(text: 'م. الاستشاري الإنشائي');
  final _clientCtrl = TextEditingController(text: 'شركة التطوير العقاري');
  final _locationCtrl = TextEditingController(text: 'الرياض - حي النرجس');
  final _notesCtrl = TextEditingController(
    text: 'تمت مراجعة الكميات المذكورة أعلاه وفق المخططات الإنشائية المعتمدة والمواصفات القياسية.',
  );

  @override
  void dispose() {
    _projectNameCtrl.dispose();
    _engineerCtrl.dispose();
    _clientCtrl.dispose();
    _locationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _submit(bool isShare) {
    if (_formKey.currentState?.validate() ?? false) {
      final metadata = ProjectMetadata(
        projectName: _projectNameCtrl.text.trim(),
        engineerName: _engineerCtrl.text.trim(),
        clientName: _clientCtrl.text.trim(),
        location: _locationCtrl.text.trim(),
        notes: _notesCtrl.text.trim(),
      );
      HapticService.success();
      widget.onConfirm(metadata, isShare);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusMedium),
      title: Row(
        children: [
          const Icon(Icons.description_outlined, color: AppColors.primaryOrange, size: 22),
          const SizedBox(width: 10),
          Text(AppStrings.projectDetails, style: AppStyles.heading3),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _projectNameCtrl,
                label: AppStrings.projectName,
                hint: 'اسم المشروع الإنشائي',
                keyboardType: TextInputType.text,
                prefixIcon: Icons.business_rounded,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _engineerCtrl,
                label: AppStrings.engineerName,
                hint: 'اسم المهندس المعد للتقرير',
                keyboardType: TextInputType.text,
                prefixIcon: Icons.engineering_rounded,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _clientCtrl,
                label: AppStrings.clientName,
                hint: 'اسم المالك أو الجهة المطورة',
                keyboardType: TextInputType.text,
                prefixIcon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _locationCtrl,
                label: AppStrings.location,
                hint: 'موقع المشروع / المدينة',
                keyboardType: TextInputType.text,
                prefixIcon: Icons.place_outlined,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _notesCtrl,
                label: 'ملاحظات واعتمادات هندسية',
                hint: 'أي توصيات أو شروط إضافية',
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                prefixIcon: Icons.notes_rounded,
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'طباعة / معاينة',
                type: ButtonType.outline,
                icon: Icons.print_outlined,
                onPressed: () => _submit(false),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomButton(
                text: 'مشاركة PDF',
                type: ButtonType.primary,
                icon: Icons.share_rounded,
                onPressed: () => _submit(true),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
