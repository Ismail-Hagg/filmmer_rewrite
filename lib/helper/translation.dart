import 'package:get/get.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'Year': 'Year',
          'country': 'Country',
          'length': 'Length',
          'seasons': 'Seasons',
          'cast': 'Cast',
          'recommendations': 'Recommendation',
          'upcoming': 'Upcoming Movies',
          'popularMovies': 'Popular Movies',
          'popularShows': 'Popular Shows',
          'topMovies': 'Top Rated Movies',
          'topShowa': 'Top Rated Shows',
          'watchList': 'My WatchList',
          'favourite': 'My Favorites',
          'settings': 'Settings',
          'internet': 'No Internet connection',
          'watchadd': 'Added to Watchlist',
          'watchalready': 'Already in Watchlist',
          'favadd': 'Added to Favorites',
          'favalready': 'Deleted From Favorites',
          'trailer': 'No Trailer',
          'movies': 'Movies',
          'shows': 'Shows',
          'changepic': 'Change Photo',
          'changelanguage': 'Change Language',
          'logout': 'LogOut',
          'logoutq': 'Do You Want To LougOut ?',
          'answer': 'yes',
          'lans': 'Languages',
          'en': 'English',
          'ar': 'Arabic',
          'search': 'Search for a movie or a show',
          'forgot': 'Forgot Password',
          'account': 'Dont Have An Account ?',
          'make': 'Register',
          'emailuse': 'Or Use Your Email Adress',
          'email': 'Email',
          'pass': 'Password',
          'login': 'LOGIN',
          'already': 'Already Have An Account ?',
          'Login': 'Login',
          'name': 'Name',
          'otherSocial': 'Unsupported For Now',
          'age': 'Age',
          'nobio': 'No Biography Available',
          'bio': 'Biography',
          'years': 'Years Old',
          'res': 'No Results',
          'error': 'Error',
          'moreres': 'No More Results',
          'nopage': 'No More Pages',
          'wrong': 'Something Went Wrong',
          'abort': 'Canceled',
          'connect': 'Connection Problem',
          'google': 'Sign up with Google',
          'adduser': 'Add A Username',
          'firealready': 'Email Already Used',
          'firewrong': 'Wrong email/password combination',
          'fireuser': 'No user found with this email',
          'firedis': 'User disabled',
          'firetoo': 'Too many requests to log into this account',
          'fireserver': 'Server error, please try again later',
          'fireemail': 'Email address is invalid',
          'firelogin': 'Login failed. Please try again',
          'imageerror':
              'Profile image was not uploaded to the server, go to settings page',
          'loaderror': 'Error, Refresh the page',
          'keeping': 'Episode Keeping',
          'myaccount': 'My Account',
          'genre': 'Genre',
          'comments': 'Add a comment',
          'deletecomment': 'Delete Comment',
          'deletecommentsure': 'Do you want to delete this comment ?',
          'deletereply': 'Do you want to delete this reply ?',
          'delrep': 'Delete reply',
          'sure': 'Are You Sure ?',
          'delete': 'Delete',
          'noimage': 'No Images Found',
          'changeuser': 'Change Username',
          'about': 'About',
          'dev': 'Developer',
          'devname': 'Ismail Alhagg',
          'filmmer':
              'Filmmer is a movie app made using flutter and the movie database api (tmdb) and firebase in the backend',
          'enter': 'No Entries',
          'newuser': 'New Username',
          'replies': 'replies',
          'watching': 'Watching',
          'favs': 'Favorites',
          'wlist': 'Watchlist',
          'chats': 'Chats',
          'randomMovie': 'Random Movie',
          'randomShow': 'Random Show',
          'filter': 'Genres',
          'random': 'Random',
          'episode': 'Episode',
          'season': 'Season',
          'lastepisode': 'Last Episode To Air',
          'nextepisode': 'Next Episode To Air',
          'nextepisodedate': 'Next Episode',
          'status': 'Status',
          'edit': 'Edit',
          'addtowatch': 'Add to Watchlist',
          'addkeep': 'Add To Episode Keeping',
          'readykeep': 'Already In Episode Keeping',
          'keepadd': 'added to Episode Keeping',
          'unknown': 'Unknown',
          'ended': 'Ended',
          'return': 'Returning Series',
          'message': ' new message from ',
          'commentmessage': ' replied on your comment ',
          'ok': 'ok',
          'complete': 'Complete Your Info',
          'cancel': 'cancel'
        },
        'ar_SA': {
          'Year': 'السنه',
          'country': 'الدوله',
          'length': 'المده',
          'seasons': 'المواسم',
          'cast': 'الممثلين',
          'recommendations': 'التوصيات',
          'upcoming': 'الأفلام القادمة',
          'popularMovies': 'افلام شائعه',
          'popularShows': 'مسلسلات شائعه',
          'topMovies': 'الأفلام الأعلى تقيما',
          'topShowa': 'المسلسلات الأعلى تقيما',
          'watchList': 'قائمة المشاهده',
          'favourite': 'المفضله',
          'settings': 'اعدادات',
          'internet': 'لايوجد انترنت',
          'watchadd': 'تمت الإضافة إلى قائمة المشاهده',
          'watchalready': 'بالفعل في قائمةالمشاهده',
          'favadd': 'تمت الإضافةالى المفضله',
          'favalready': 'تمت الازالة من المفضله',
          'trailer': 'لايوجد اعلان',
          'movies': 'افلام',
          'shows': 'مسلسلات',
          'changepic': 'تغيير الصوره',
          'changelanguage': 'تغيير اللغه',
          'logout': 'تسجيل خروج',
          'logoutq': 'هل تريد تسجيل الخروج ؟',
          'answer': 'نعم',
          'lans': 'اللغات',
          'en': 'انجليزي',
          'ar': 'عربي',
          'search': 'ابحث عن فلم او مسلسل',
          'forgot': 'نسيت كلمة المرور',
          'account': 'ليس لديك حساب ؟',
          'make': 'سجل',
          'emailuse': 'او استخدم بريدك الالكتروني',
          'email': 'البريد الالكتروني',
          'pass': 'كلمة المرور',
          'login': 'تسجيل الدخول',
          'already': 'لديك حساب ؟',
          'Login': 'تسجيل الدخول',
          'name': 'الاسم',
          'otherSocial': 'غير مدعوم الان',
          'age': 'العمر',
          'nobio': 'لاتوجد سيرة ذاتيه',
          'bio': 'السيرة الذاتيه',
          'years': 'سنه',
          'res': 'لا توجد نتائج',
          'error': 'هناك خلل',
          'moreres': 'لايوجد مزيد من النتائج',
          'nopage': 'لايوجد المزيد من الصفحات',
          'wrong': 'هناك خلل',
          'abort': 'الغيت العمليه',
          'connect': 'مشكله في الاتصال',
          'google': 'الدخول باستعمال قوقل',
          'adduser': 'قم باضافة اسم مستخدم',
          'firealready': 'هذا البريد مستخدم بالفعل',
          'firewrong': 'البريد او كلمة المرور خاطئ',
          'fireuser': 'لايوجد مستخدم بهذا البريد',
          'firedis': 'هذا المستخدم موقوف',
          'firetoo': 'معلومات كثيره',
          'fireserver': 'خطا في السيرفر حاول مره اخرى',
          'fireemail': 'البريد لايصلح',
          'firelogin': 'فشل في تسجيل الدخول حاول مره اخرى',
          'imageerror':
              'صورة الملف الشخصي لم ترفع الا السيرفر , اذهب الا صفحه الاعدادات',
          'loaderror': 'خطا,حدث الصفحه',
          'keeping': 'متابعة الحلقات',
          'myaccount': 'حسابي',
          'genre': 'تصنيف',
          'comments': 'اضف تعليقك',
          'deletecomment': 'حذف التعليق',
          'deletecommentsure': 'هل تريد حذف هذا التعليق ؟',
          'deletereply': 'هل تريد حذف هذا الرد ؟',
          'delrep': 'حذف الرد',
          'sure': 'هل انت متاكد ؟',
          'delete': 'حذف',
          'noimage': 'لاتوجد صور',
          'changeuser': 'تغيير اسم المستخدم',
          'about': 'عن التطبيق',
          'dev': 'المطور',
          'devname': 'اسماعيل الحاج',
          'filmmer': 'فيلمر تطبيق افلام و مسلسلات',
          'enter': 'لاتوجد نتائج',
          'newuser': 'اسم المستخدم الجديد',
          'replies': 'ردود',
          'watching': 'يشاهد',
          'favs': 'المفضله',
          'wlist': 'قائمة المشاهده',
          'chats': 'المحادثات',
          'randomMovie': 'فلم عشوائي',
          'randomShow': 'مسلسل عشوائي',
          'filter': 'تصنيف',
          'random': 'عشوائي',
          'episode': 'حلقه',
          'season': 'موسم',
          'lastepisode': 'اخر حلقه اصدرت',
          'nextepisode': 'الحلقه القادمه',
          'nextepisodedate': 'الحلقه القادمه',
          'status': 'الحاله',
          'edit': 'تعديل',
          'addtowatch': 'اضافه الى قائمة المشاهدة',
          'addkeep': 'اضافه الى متابعة الحلقات',
          'readykeep': 'موجود في متابعة الحلقات',
          'keepadd': 'تمت الاضافه الى متابعة الحلقات',
          'unknown': 'غير معروف',
          'ended': 'منتهي',
          'return': 'مستمر',
          'message': 'رساله جديده من ',
          'commentmessage': ' قام بالرد على تعليقك ',
          'ok': 'حسنا',
          'complete': 'اكمل بياناتك',
          'cancel': 'الغاء'
        }

        // add translation fot other english speaking countries
      };
}
