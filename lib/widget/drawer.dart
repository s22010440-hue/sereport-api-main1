// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sereports/constants.dart';
import 'package:sereports/repository/auth_repo.dart';
import 'package:sereports/screen/auth_screen/login.dart';
import 'package:sereports/screen/banking/bank.dart';
import 'package:sereports/screen/customers/customer.dart';
import 'package:sereports/screen/dashboard/dashbaord.dart';
import 'package:sereports/screen/income/expences/income_and_expences.dart';
import 'package:sereports/screen/product/product_record.dart';
import 'package:sereports/screen/purchase/purchase.dart';
import 'package:sereports/screen/sales/sales.dart';
import 'package:sereports/screen/supplier/supplier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(radiusValue), // Adjust the radius as needed
        bottomRight: Radius.circular(radiusValue),
      ),
      child: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              // This pushes the bottom section to the bottom
              child: ListView(
                children: [
                  // ListTile(
                  //   leading: Icon(Icons.home),
                  //   title: Text('Home'),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     // Navigate to home screen
                  //   },
                  // ),
                  ListTile(
                    leading: Icon(Icons.dashboard),
                    title: Text('Dashboard'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const DashbaordScreen()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.inventory),
                    title: Text('Products'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ProductRecordsPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.local_shipping),
                    title: Text('Suppliers'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const SupplierPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Customers'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const CustomerPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.trending_up),
                    title: Text('Sales'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const SalesPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text('Purchase'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const PurchasePage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text('Income/Expenses'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const IncomeAndExpences()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.account_balance),
                    title: Text('Banking'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const BankPage()));
                    },
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.receipt),
                  //   title: Text('Cheque Transaction'),
                  //   onTap: () {
                  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //         builder: (context) => const ChequeTransaction()));
                  //   },
                  // ),
                  // ListTile(
                  //   leading: Icon(Icons.book),
                  //   title: Text('Accounts'),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     // Navigate to accounts screen
                  //   },
                  // ),
                  // ListTile(
                  //   leading: Icon(Icons.business),
                  //   title: Text('Company Profile'),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     // Navigate to company profile screen
                  //   },
                  // ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      AuthRepo authRepo = AuthRepo(preferences);

                      authRepo.logout();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                    },
                  ),
                ],
              ),
            ),
            // Bottom Section: Company and User Info
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Column(
            //     children: [
            //       const Text(
            //         'Company: Semicolans E Shop',
            //         style: TextStyle(color: Colors.black, fontSize: 16),
            //       ),
            //       const SizedBox(height: 8),
            //       const Text(
            //         'User: Rimshan Thoufeek',
            //         style: TextStyle(color: Colors.black, fontSize: 14),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
