import 'package:flutter/foundation.dart';

class AppBarProvider extends ChangeNotifier {
  double offSet = 0.0;

  void setOffSet(double offset) {
    offSet = offset;
    notifyListeners();
  }
}

// class AppBarCubit extends Cubit<double> {
//   AppBarCubit() : super(0.0);

//   void setOffSet(double offSet) {
//     emit(offSet);
//   }
// }
