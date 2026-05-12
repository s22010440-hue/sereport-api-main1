// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_string_interpolations, avoid_print, unnecessary_import

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:sereports/constants.dart';
import 'package:sereports/repository/auth_repo.dart';
import 'package:sereports/utils/interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiException implements Exception {
  ApiException(this.errorMessage);

  String errorMessage;

  @override
  String toString() => errorMessage;
}

class Api {
  static String companyName = "${baseUrl}user/get-user-details";
  //supplier
  static String getSupplierNameList =
      "${baseUrl}suppliers/get-all-suppliers-name-list";
  static String getSupplierDetails = "${baseUrl}suppliers/supplier-details";

  static String getCreditorDetailsList =
      "${baseUrl}suppliers-creditor/get-creditor-details-list";

  static String getSupplierPayableList = "${baseUrl}suppliers/payable-details";

  //customer
  static String getCustomerDetails =
      "${baseUrl}customers/get-customers-details";

  static String getCustomerDebitors = "${baseUrl}customers/get-debtor-details";
  static String getCustomerRecivables =
      "${baseUrl}receivables/receivable-details";

  //bank
  static String getBankNameList = "${baseUrl}bank-details/get-all-bank-names";
  static String getBankDetails = "${baseUrl}bank-details/get-all-bank-details";
  static String getBankTransactions =
      "${baseUrl}banking/bank-transaction-details";

  //sales
  static String getSalesSummary = "${baseUrl}sales-summary/summary-details";
  static String getSalesDetails = "${baseUrl}sales/sales-details";

  //purchase
  static String getPurchaseSummary =
      "${baseUrl}purchase-summary/summary-details";
  static String getPurchaseDetails = "${baseUrl}purchases/purchase-details";

  static String getIncomeExpensesDetails = "${baseUrl}income-expenses/details";

  static String dashboardSummary = "${baseUrl}dashboards/summary";

  static String getCategoryNameList =
      "${baseUrl}categories/get-all-category-name-list";
  static String getSubCategoryNameList =
      "${baseUrl}sub-categories/get-all-sub-category-name-list";

  static String getProductAll = "${baseUrl}products/get-all-product";

  static String getBankDetailsWithSummary =
      "${baseUrl}banks/bank-details-with-summary";

  static String getBankTransactionDetails =
      "${baseUrl}banks/bank-transaction-details";

  static String getChequeTransactionDetails =
      "${baseUrl}banks/cheque-transaction-details";

  //parameter
  static String searchText = "searchText";
  static String categoryId = "categoryId";

  static Future<Map<String, dynamic>> get(
      {required final String url,
      required final Map<String, dynamic> parameter}) async {
    try {
      final http = InterceptedHttp.build(interceptors: [
        SeReportInterceptor(),
      ]);
      print(url);
      print(parameter);
      final response = await http.get(url.toUri(), params: parameter);

      if (response.statusCode == 200) {
        final responseMap = jsonDecode(response.body);
        print(responseMap);
        return Map<String, dynamic>.from(responseMap);
      } else if (response.statusCode == 404) {
        return Future.error(
          "Error while fetching.",
          StackTrace.fromString("${response.body}"),
        );
      } else {
        return Future.error(
          "Error while fetching. Try again!",
          StackTrace.fromString("${response.body}"),
        );
      }
    } on SocketException {
      return Future.error('No Internet connection 😑');
    } on FormatException {
      return Future.error('Bad response format 👎');
    } on Exception {
      return Future.error('Unexpected error 😢');
    } catch (e, stackTrace) {
      print("Error occurred: $e");
      print("StackTrace: $stackTrace");
      return Future.error('Unexpected error 😢');
    }
  }

  static Future<int> loginCompany(
      String username, String password, String pinnumber) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    AuthRepo authRepo = AuthRepo(preferences);
    try {
      final response = await http.post(
        Uri.parse('$loginUrl'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, Object>{
          "username": username.trim(),
          "password": password.trim(),
          "pinnumber": pinnumber.trim(),
        }),
      );

      if (response.statusCode == 200) {
        String authorization = response.headers['authorization'].toString();
        String token = authorization.split("Bearer ").last.trim();
        await authRepo.saveToken(token);
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } on SocketException {
      return Future.error('No Internet connection 😑');
    } on FormatException {
      return Future.error('Bad response format 👎');
    } on Exception {
      print(Error());
      return Future.error('Unexpected error 😢');
    }
  }

  static test() async {
    final response =
        await http.get("http://192.168.1.15:8081/api/v1/test".toUri());
    print(response.body);
  }
}