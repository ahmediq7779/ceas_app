/// Localized Arabic strings and engineering terms for CEAS
class AppStrings {
  AppStrings._();

  // App Identity
  static const String appName = 'CEAS';
  static const String appFullName = 'منظومة الهندسة المدنية المتكاملة';
  static const String appTagline = 'حسابات إنشائية دقيقة وجداول كميات متطورة';

  // Navigation & Modules
  static const String dashboard = 'لوحة التحكم';
  static const String concreteModule = 'الخرسانة والبناء';
  static const String steelModule = 'حديد التسليح';
  static const String formworkModule = 'الشدات والأعمال الترابية';
  static const String boqModule = 'جدول الكميات';
  static const String unitRates = 'أسعار المواد';
  static const String settings = 'الإعدادات';

  // Sub-tabs
  static const String concreteMix = 'خلطة الخرسانة';
  static const String masonryBlocks = 'أعمال البلوك والطوب';
  static const String rebarWeight = 'أوزان حديد التسليح';
  static const String lapSplice = 'أطوال التراكب والرباط';
  static const String stirrupsTies = 'الكانات والأساور';
  static const String formworkArea = 'مساحة الشدات الخشبية';
  static const String excavationBackfill = 'الحفر والردم والتربة';

  // Common Actions
  static const String calculate = 'احسب الآن';
  static const String addToBoq = 'إضافة إلى جدول الكميات';
  static const String saveChanges = 'حفظ التعديلات';
  static const String reset = 'إعادة تعيين';
  static const String delete = 'حذف';
  static const String clearAll = 'مسح الكل';
  static const String exportPdf = 'تصدير تقرير PDF';
  static const String sharePdf = 'مشاركة التقرير';
  static const String close = 'إغلاق';
  static const String cancel = 'إلغاء';
  static const String confirm = 'تأكيد';

  // Units
  static const String unitM = 'م';
  static const String unitCm = 'سم';
  static const String unitMm = 'مم';
  static const String unitM2 = 'م²';
  static const String unitM3 = 'م³';
  static const String unitKg = 'كجم';
  static const String unitTon = 'طن';
  static const String unitBags = 'كيس';
  static const String unitBlocks = 'بلوكة';
  static const String unitSheets = 'لوح';
  static const String unitTrips = 'نقلة';

  // Concrete & Mix Labels
  static const String concreteShape = 'نوع العنصر الإنشائي';
  static const String slabOrFooting = 'بلاطة أو قاعدة (مستطيلة)';
  static const String rectColumn = 'عمود أو كمرة مستطيلة';
  static const String circColumn = 'عمود أو خازوق دائري';
  static const String directVolume = 'حجم خرسانة مباشر';
  static const String length = 'الطول (L)';
  static const String width = 'العرض (W)';
  static const String heightOrDepth = 'الارتفاع أو السمك (H/T)';
  static const String diameter = 'القطر (D)';
  static const String countOrRepeats = 'العدد أو مرات التكرار';
  static const String mixRatio = 'نسبة الخلطة الخرسانية';
  static const String dryFactor = 'معامل الحجم الجاف (1.54)';
  static const String waterCementRatio = 'نسبة الماء للأسمنت (W/C)';
  static const String resultsConcrete = 'نتائج كميات الخرسانة';
  static const String totalVolume = 'الحجم الإجمالي للخرسانة';
  static const String cementQuantity = 'كمية الأسمنت';
  static const String cementBags = 'عدد أكياس الأسمنت (50 كجم)';
  static const String sandVolume = 'حجم الرمل المطلوب';
  static const String gravelVolume = 'حجم الحصى/الزلط';
  static const String waterVolume = 'كمية الماء المطلوبة';
  static const String estimatedCost = 'التكلفة التقديرية للمواد';

  // Masonry Labels
  static const String wallDimensions = 'أبعاد الجدار';
  static const String wallLength = 'طول الجدار (م)';
  static const String wallHeight = 'ارتفاع الجدار (م)';
  static const String blockSize = 'مقاس البلوك (طول×ارتفاع×عرض)';
  static const String mortarThickness = 'سمك مونة اللحام (سم)';
  static const String wastePercentage = 'نسبة الهالك (%)';
  static const String openingsDeduction = 'خصم الفتحات (أبواب وشبابيك)';
  static const String addOpening = 'إضافة فتحة خصم';
  static const String netWallArea = 'صافي مساحة الجدار';
  static const String totalBlocksNeeded = 'إجمالي عدد البلوك المطلوب';
  static const String mortarVolume = 'حجم مونة البناء';
  static const String mortarCement = 'أسمنت المونة';
  static const String mortarSand = 'رمل المونة';

  // Steel Rebar Labels
  static const String rebarDiameter = 'قطر السيخ (Φ)';
  static const String barLength = 'طول السيخ الواحد (م)';
  static const String barCount = 'عدد الأسياخ';
  static const String totalRebarLength = 'إجمالي أطوال الأسياخ';
  static const String unitWeight = 'الوزن المتر الطولي';
  static const String totalWeightKg = 'إجمالي الوزن (كجم)';
  static const String totalWeightTon = 'إجمالي الوزن (طن)';
  static const String stockBarsCount = 'عدد الأسياخ القياسية (12م)';
  static const String scrapPercent = 'نسبة الفاقد من التقطيع';

  // Lap Splice Labels
  static const String concreteStrength = 'مقاومة الخرسانة المميزة (f\'c)';
  static const String steelYield = 'إجهاد خضوع الحديد (fy)';
  static const String spliceType = 'نوع وصلة التراكب';
  static const String tensionClassA = 'شد - الفئة أ (Tension Class A)';
  static const String tensionClassB = 'شد - الفئة ب (Tension Class B)';
  static const String compression = 'ضغط (Compression)';
  static const String topBarFactor = 'أسياخ علوية (صب أعلى من 30 سم)';
  static const String epoxyFactor = 'حديد مكسو بالإيبوكسي';
  static const String devLength = 'طول التماسك الإنشائي (Ld)';
  static const String lapLength = 'طول التراكب والوصل (Ls)';
  static const String barMultiple = 'مضاعف قطر السيخ (db)';

  // Stirrups Labels
  static const String beamColumnWidth = 'عرض المقطع (B)';
  static const String beamColumnHeight = 'ارتفاع المقطع (H)';
  static const String memberLength = 'طول العنصر الإنشائي (L)';
  static const String clearCover = 'الغطاء الخرساني الصافي (Cover)';
  static const String stirrupDiameter = 'قطر سيخ الكانة (Φ)';
  static const String hookType = 'نوع القفل والجنش';
  static const String hook135 = 'قفل زلزالي 135° (10db)';
  static const String hook90 = 'قفل قياسي 90° (6db)';
  static const String stirrupSpacing = 'المسافة بين الكانات (s)';
  static const String stirrupCutLength = 'طول قطع سيخ الكانة الواحدة';
  static const String totalStirrupCount = 'إجمالي عدد الكانات المطلوبة';
  static const String totalStirrupWeight = 'إجمالي وزن حديد الكانات';

  // Formwork & Earthwork Labels
  static const String elementCategory = 'نوع العنصر الإنشائي للشدة';
  static const String slabFormwork = 'بلاطة سقف (قاع + حواف)';
  static const String columnFormwork = 'أعمدة مستطيلة';
  static const String beamFormwork = 'كمرات (قاع + جوانب)';
  static const String footingFormwork = 'قواعد وميد خرسانية';
  static const String retainingWallFormwork = 'جدران استنادية / قص';
  static const String totalContactArea = 'إجمالي مساحة الشدة الملامسة';
  static const String plywoodBoards = 'عدد ألواح البلايوود (1.22×2.44م)';
  static const String formworkReuse = 'عدد مرات إعادة استخدام الخشب';

  // Earthwork Labels
  static const String excavation = 'أعمال الحفر';
  static const String backfilling = 'أعمال الردم';
  static const String excLength = 'طول موقع الحفر (م)';
  static const String excWidth = 'عرض موقع الحفر (م)';
  static const String excDepth = 'عمق الحفر (م)';
  static const String soilBulkingFactor = 'معامل انتفاش التربة المفككة (%)';
  static const String truckCapacity = 'سعة القلاب/الشاحنة (م³)';
  static const String compactedVolume = 'حجم الحفر الموضعي (In-situ)';
  static const String looseVolume = 'حجم ناتج الحفر المفكك (Loose)';
  static const String truckTripsNeeded = 'عدد نقلات الشاحنات لنقل الحفر';
  static const String compactionFactor = 'معامل الانضغاط والهبوط (%)';
  static const String requiredBorrowVolume = 'حجم مواد الردم الموردة المطلوبة';

  // BOQ Labels
  static const String boqTitle = 'جدول حصر الكميات والتكاليف (BOQ)';
  static const String boqEmpty = 'جدول الكميات فارغ حالياً';
  static const String boqEmptyDesc = 'قم بإجراء الحسابات من الأقسام واضغط على "إضافة إلى جدول الكميات" لتجميعها هنا.';
  static const String projectName = 'اسم المشروع';
  static const String engineerName = 'المهندس المسؤول';
  static const String clientName = 'اسم المالك / العميل';
  static const String location = 'موقع المشروع';
  static const String totalEstimate = 'إجمالي التقدير المالي للمشروع';
  static const String totalItemsCount = 'إجمالي البنود المسجلة';
  static const String itemCategory = 'القسم الإنشائي';
  static const String itemDescription = 'بيان البند والمواصفة';
  static const String itemUnit = 'الوحدة';
  static const String itemQuantity = 'الكمية';
  static const String itemRate = 'سعر الوحدة';
  static const String itemTotal = 'الإجمالي';
  static const String projectDetails = 'بيانات المشروع والتقرير';
  static const String generateReport = 'توليد ومشاركة التقرير الرسمي';

  // Unit Rates Screen
  static const String ratesSettingsTitle = 'أسعار المواد والوحدات الإنشائية';
  static const String ratesSettingsSubtitle = 'تُستخدم هذه الأسعار تلقائياً لحساب التكاليف في كافة النماذج';
  static const String currency = 'العملة';
  static const String cementBagPrice = 'سعر شيكارة الأسمنت (50 كجم)';
  static const String sandPrice = 'سعر متر الرمل (م³)';
  static const String gravelPrice = 'سعر متر الحصى/الزلط (م³)';
  static const String readyMixPrice = 'سعر متر الخرسانة الجاهزة (م³)';
  static const String blockThousandPrice = 'سعر 1000 بلوكة / طوبة';
  static const String steelTonPrice = 'سعر طن حديد التسليح';
  static const String formworkM2Price = 'سعر متر مسطح الشدات (م²)';
  static const String excavationM3Price = 'سعر متر مكعب الحفر (م³)';
  static const String backfillM3Price = 'سعر متر مكعب الردم (م³)';
  static const String ratesSavedSuccessfully = 'تم حفظ جدول الأسعار بنجاح';

  // Validation & Errors
  static const String invalidNumber = 'يرجى إدخال رقم صحيح وموجب';
  static const String fieldRequired = 'هذا الحقل إجباري';
  static const String addedToBoqSuccess = 'تمت إضافة البند إلى جدول الكميات بنجاح';
  static const String itemDeleted = 'تم حذف البند';
  static const String boqCleared = 'تم تفريغ جدول الكميات';
  static const String pdfGenerated = 'تم إنشاء ملف التقرير بنجاح';
  static const String pdfError = 'حدث خطأ أثناء إنشاء ملف PDF';
}
