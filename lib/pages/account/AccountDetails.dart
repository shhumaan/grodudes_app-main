import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grodudes/helper/Constants.dart';
import 'package:grodudes/pages/account/AddressDetails.dart';
import 'package:grodudes/pages/account/Orders.dart';
import 'package:grodudes/state/user_state.dart';
import 'package:provider/provider.dart';

class AccountDetails extends StatelessWidget {
  // final Map<String, dynamic> wpUserInfo;
  // final Map<String, dynamic> wcUserInfo;
  final listTileTextStyle = TextStyle(fontSize: 16);

  // AccountDetails(this.wpUserInfo, this.wcUserInfo);

  Map<String, dynamic> _filterData(Map<String, dynamic> data) {
    Map<String, dynamic> filteredData = {};
    for (final String key in data.keys) {
      if (key == 'email' && data[key] == null || data[key].length == 0)
        continue;
      filteredData[key] = data[key];
    }
    return filteredData;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dataProvider = Provider.of<UserManager>(context, listen: false);
    if (dataProvider.wcUserInfo == null ||
        dataProvider.wcUserInfo['id'] == null)
      return _LoginErrorDescriptionWidget(dataProvider.wpUserInfo);
    if (dataProvider.wpUserInfo == null ||
        dataProvider.wpUserInfo['user_email'] == null)
      return _LoginErrorDescriptionWidget(dataProvider.wpUserInfo);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          SizedBox(height: 13),
          Text(
            'Account Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Image.network(
              dataProvider.wcUserInfo['avatar_url'] ?? '',
              height: 130,
              width: 80,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.person, size: 80),
            ),
          ),
          Text(
            dataProvider.wcUserInfo['username'],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            dataProvider.wcUserInfo['email'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.indigoAccent,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          Divider(
            color: Colors.black45,
          ),
          ListTile(
            title: Text('Orders', style: listTileTextStyle),
            contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            trailing: Icon(
              Icons.chevron_right,
              size: 28,
              color: Colors.indigo,
            ),
            onTap: () => Navigator.push(
                context, CupertinoPageRoute(builder: (context) => Orders())),
          ),
          Divider(
            color: Colors.black45,
          ),
          ListTile(
            title: Text('Billing Address', style: listTileTextStyle),
            contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            trailing: Icon(
              Icons.chevron_right,
              size: 28,
              color: Colors.indigo,
            ),
            onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => AddressDetails(
                    title: 'Billing Address',
                    type: 'billing',
                    updateCb: (Map<String, dynamic> newAddress) async {
                      String msg =
                          await Provider.of<UserManager>(context, listen: false)
                              .updateUser({'billing': _filterData(newAddress)});
                      return msg;
                    },
                  ),
                )),
          ),
          Divider(
            color: Colors.black45,
          ),
          ListTile(
            title: Text('Shipping Address', style: listTileTextStyle),
            contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            trailing: Icon(
              Icons.chevron_right,
              size: 28,
              color: Colors.indigo,
            ),
            onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => AddressDetails(
                    title: 'Shipping Address',
                    type: 'shipping',
                    updateCb: (Map<String, dynamic> newAddress) async {
                      String msg = await Provider.of<UserManager>(context,
                              listen: false)
                          .updateUser({'shipping': _filterData(newAddress)});
                      return msg;
                    },
                  ),
                )),
          ),
          Divider(
            color: Colors.black45,
          ),
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 20),
              width: 200,
              height: 70,
              child: RaisedButton(
                onPressed: () {
                  dataProvider.logOut();
                },
                textColor: Colors.white,
                child: Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginErrorDescriptionWidget extends StatelessWidget {
  final Map<String, dynamic> errorData;
  _LoginErrorDescriptionWidget(this.errorData);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorData == null
                ? 'An Unknown error has occured. Please retry Login'
                : errorData['errMsg'] ??
                    'An Unknown error has occured. Please retry Login',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          RaisedButton(
            onPressed: () {},
            child: Text('Retry Login'),
          )
        ],
      ),
    );
  }
}
