class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent(
      {required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'محمل الملفات MC',
      image: 'assets/images/logo.png',
      discription: "\nتطبيق التحميل من مواقع التواصل الاجتماعي ومواقع الويب "
          "سريع وخفيف وصغير الحجم مناسب لجميع الأجهزة "
          "سهل الأستخدام  ومرن في التعامل ابداء الأن"),
  UnbordingContent(
      title: 'التصفح أو التحميل',
      image: 'assets/images/logo.png',
      discription: "من خلال هذا التطبيق يمكنك تنزيل المحتوى بشكل مباشر "
          "او البحث عن محتوى وتصفحة, "
          "فقط قم بلصق الرابط في شريط البحث من أجل التحميل أو قم بالكتابة لتصفح المحتوى "
          "فيسبوك ,استجرام,تيك توك,تويتر,مواقع ويب أخرى"),
  UnbordingContent(
      title: 'يدير التنزيلات',
      image: 'assets/images/logo.png',
      discription:
          "يدير التنزيلات بحيث يمكن اعادة استئناف اي تنزيل بعد اي فترة  "
          "امكانية تجديد رابط التحميل والانتقال الى الصفحة الخاصة بالتحميل "
          "القضاء على فشل التحميل بحيث يمكن تحميل ملفات كبيرة الحجم دون الخوف من الفشل "),
];
