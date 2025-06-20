import 'package:jsochurch/viewmodels/detailed_view_model.dart';
import 'package:jsochurch/viewmodels/login_view_model.dart';
import 'package:jsochurch/viewmodels/report_view_model.dart';
import 'package:jsochurch/viewmodels/select_church_view_model.dart';
import 'package:jsochurch/viewmodels/select_parish_detail_view_model.dart';
import 'package:jsochurch/viewmodels/splash_view_model.dart';
import 'package:jsochurch/views/select_parish_detail_view.dart';
import 'package:jsochurch/web/view_models/edit_view_model.dart';
import 'package:jsochurch/web/view_models/web_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../viewmodels/clergy_view_model.dart';
import '../viewmodels/home_view_model.dart';
import '../viewmodels/profile_view_model.dart';
import '../viewmodels/select_diocese_view_model.dart';


class AppConstants {
  static AppConstants? _instance;

  static AppConstants get instance {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = AppConstants.init();
      return _instance!;
    }
  }

  AppConstants.init();


  final List<SingleChildWidget> _providers = [
    ChangeNotifierProvider(
      create: (_) => SplashViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => SelectParishDetailViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => SelectDioceseViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => SelectChurchViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => ClergyViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => DetailedViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => EditViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => WebViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => ReportViewModel(),
    ),

  ];

  List<SingleChildWidget> get providers => _providers;
}
