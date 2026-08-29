# CEAS (Civil Engineering Application Suite)
## منظومة الهندسة المدنية المتكاملة وحصر الكميات الذكي

A complete, production-ready, AI-native Flutter application built with Clean Architecture, Riverpod state management, RTL Arabic UI, and ACI 318 / EC2 compliant engineering calculation engines.

---

## Key Features & Modules

### 1. Concrete & Masonry Module (الخرسانة وأعمال البناء)
- **Concrete Mix Design**: Volume calculations for Slabs, Footings, Rectangular/Circular Columns, Piers, or Direct Volume.
- **Mix Presets**: C25 ($1:1.5:3$), C20 ($1:2:4$), C30 ($1:1:2$), C15 ($1:3:6$), and Custom ratio $1:S:G$.
- **Material Proportions**: Cement (kg & $50\text{ kg}$ bags based on $1.54$ dry volume coefficient and $1440\text{ kg/m}^3$ density), Sand ($m^3$), Gravel ($m^3$), and Water (Liters based on W/C ratio).
- **Masonry & Blocks**: Standard sizes ($40\times20\times20\text{ cm}$, $40\times20\times15\text{ cm}$, $40\times20\times10\text{ cm}$, Custom), opening deductions (doors & windows), mortar thickness ($1-2\text{ cm}$), and wastage factor ($5-10\%$).

### 2. Advanced Steel Rebar Module (حديد التسليح المتقدم)
- **Rebar Weight Calculator**: Standard metric diameters ($\Phi 6$ to $\Phi 40\text{ mm}$), unit weight formula ($w = \frac{D^2}{162.28}\text{ kg/m}$), commercial $12\text{m}$ stock bars count, and scrap waste percentage.
- **Lap Splice & Development Length ($L_d$ & $L_s$)**: ACI 318 compliant calculations for Tension Class A ($1.0 L_d$), Tension Class B ($1.3 L_d$), Compression ($0.071 f_y d_b$), top-cast bar modifiers ($\psi_t = 1.3$), and epoxy modifiers ($\psi_e = 1.2$).
- **Stirrups & Ties (الكانات والأساور)**: Clear concrete cover, $\Phi 8/\Phi 10/\Phi 12$ stirrups, $135^\circ$ seismic hook ($10d_b$) vs $90^\circ$ hook ($6d_b$), spacing, cut length per stirrup, total count, and total weight.

### 3. Formwork & Earthwork Module (الشدات الخشبية والأعمال الترابية)
- **Formwork Contact Area**: Slabs, Columns, Beams, Footings, and Retaining Walls contact surface area in $m^2$, standard $1.22\text{m} \times 2.44\text{m}$ ($2.977\text{ m}^2$) plywood sheets calculation, and reuse cycle factor.
- **Earthwork**: Excavation bank volume ($m^3$), Soil Bulking/Swell factor ($10-30\%$), truck haulage trips ($10, 16, 20, 25\text{ m}^3$ trucks), backfill compaction shrinkage factor ($15-25\%$), and required borrow material volume.

### 4. Unit Rates & Cost Estimation (أسعار المواد والوحدات)
- Persistent local storage (`SharedPreferences`) for material unit prices (Cement, Sand, Gravel, Ready-mix, Blocks, Steel, Formwork, Excavation, Backfill, and Currency SAR/EGP/AED/USD/etc.).
- Integrated "Add to BOQ" in every module multiplying calculated quantities by saved rates.

### 5. BOQ Aggregator & PDF Report Engine (جدول الكميات والتصدير)
- Aggregates all structural items with category, description, unit, quantity, unit rate, and total cost.
- Item editing and deletion.
- On-device vector PDF generator (`pdf` & `printing`) with RTL Arabic Cairo font, project metadata, executive KPIs, itemized BOQ table, and engineering sign-off stamps.
- Native sharing via `share_plus` / `printing`.

---

## Design System & UI/UX

- **Color Palette**: Dark Slate Grey (`#0F172A`, `#1E293B`), Safety Orange (`#F97316`), Crisp White (`#F8FAFC`).
- **Iconography**: 100% Vector Material Icons (Strictly NO emojis anywhere in the application).
- **Haptic & Sound**: Tactile feedback (`HapticFeedback.lightImpact()`, `mediumImpact()`) and system click sounds on all interactive elements.
- **Localization**: Arabic (RTL) with standard English engineering symbols ($f'_c, f_y, \Phi, \text{BOQ}$).

---

## Architecture & Project Structure

```
ceas/
├── pubspec.yaml
├── analysis_options.yaml
└── lib/
    ├── main.dart
    ├── core/
    │   ├── constants/ (app_colors.dart, app_strings.dart, app_styles.dart)
    │   ├── theme/     (app_theme.dart)
    │   ├── utils/     (haptic_service.dart, number_formatter.dart, validators.dart)
    │   └── widgets/   (custom_app_bar.dart, custom_text_field.dart, custom_button.dart, result_card.dart, section_card.dart, unit_selector.dart, empty_state_view.dart)
    ├── models/        (rate_settings_model.dart, boq_item_model.dart, concrete_mix_model.dart, masonry_model.dart, steel_rebar_model.dart, formwork_earthwork_model.dart)
    ├── services/      (storage_service.dart, concrete_service.dart, steel_service.dart, formwork_service.dart, earthwork_service.dart, pdf_report_service.dart)
    ├── providers/     (rate_settings_provider.dart, boq_provider.dart, concrete_calculator_provider.dart, steel_calculator_provider.dart, formwork_calculator_provider.dart, earthwork_calculator_provider.dart, theme_provider.dart)
    └── views/
        ├── dashboard/ (dashboard_screen.dart, widgets/...)
        ├── concrete/  (concrete_calculator_screen.dart, tabs/...)
        ├── steel/     (steel_calculator_screen.dart, tabs/...)
        ├── formwork_earthwork/ (formwork_earthwork_screen.dart, tabs/...)
        ├── boq/       (boq_screen.dart, project_details_dialog.dart, widgets/...)
        └── settings/  (unit_rates_screen.dart, widgets/...)
```

---

## How to Run

1. Ensure Flutter SDK ($3.10+$) is installed on your system.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```
