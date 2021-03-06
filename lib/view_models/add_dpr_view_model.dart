import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stemcon/app/app.locator.dart';
import 'package:stemcon/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/api_service.dart';
import '../services/file_selector_service.dart';
import '../utils/color/color_pallets.dart';

class AddNewDprViewModel extends BaseViewModel {
  final _navservice = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _apiService = locator<ApiService>();
  final _imagePicker = locator<FileSelectorService>();
  String? dateTime;
  File? imageSelected;

  Future<void> picImage() async {
    final data = await _imagePicker.pickFile();
    if (data != null) {
      imageSelected = File(data.path);
      notifyListeners();
    }
  }

  void onChanged({String? text}) {
    dateTime = text;
    notifyListeners();
    return;
  }

  void back() {
    _navservice.back();
  }

  Future<void> addDpr({
    required String projectId,
    required String dprDescription,
    required int? token,
    required int? userId,
  }) async {
    if (projectId.isEmpty ||
        dprDescription.isEmpty ||
        imageSelected == null ||
        token == null ||
        userId == null ||
        dateTime!.isEmpty) {
      _snackbarService.registerSnackbarConfig(SnackbarConfig(
        messageColor: whiteColor,
      ));
      _snackbarService.showSnackbar(message: 'Entry can\'t be empty');
    } else {
      setBusy(true);
      try {
        final response = await _apiService.addDpr(
          userId: userId,
          token: token,
          dprTime: dateTime!,
          dprPdf: imageSelected!,
          dprDescription: dprDescription,
          projectId: projectId,
        );
        if (response.statusCode == 200) {
          final data = response.data;
          print(data);
          if (data['res_code'] == "1") {
            setBusy(false);
            _navservice.replaceWith(
              Routes.dprView,
              arguments: DprViewArguments(token: token, userId: userId, projectId: projectId,),
            );
            return;
          } else {
            setBusy(false);
            _snackbarService.registerSnackbarConfig(SnackbarConfig(
              messageColor: whiteColor,
            ));
            _snackbarService.showSnackbar(message: 'Error occurred!');
            return;
          }
        } else {
          setBusy(false);
          return;
        }
      } on DioError catch (e) {
        setBusy(false);
        debugPrint(e.message);
        return;
      }
    }
  }
}
