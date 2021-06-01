import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grodudes/components/CartListItem.dart';
import 'package:grodudes/models/Product.dart';
import 'package:grodudes/pages/checkout/ConfirmationPage.dart';
import 'package:grodudes/state/cart_state.dart';
import 'package:provider/provider.dart';

class CartItems extends StatefulWidget {
  @override
  _CartItemsState createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _calculateCartTotal(List<Product> items) {
    double total = 0;
    items.forEach(
        (item) => total += double.parse(item.data['price']) * item.quantity);
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: Consumer<CartManager>(
        builder: (context, value, child) => value.cartItems.length == 0
            // ? Container(
            //     height: 300,
            //     child: Image.asset(
            //         '/Users/anshuman/Downloads/grodudes_app-main/assets/images/emptycart.png'),
            //   )
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        text: TextSpan(
                      text: 'Your Cart is ',
                      style: DefaultTextStyle.of(context).style,
                      children: const <TextSpan>[
                        TextSpan(
                          text: 'Empty!',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo),
                        ),
                      ],
                    )),
                    Container(
                      margin: EdgeInsets.only(top: 20, right: 30, bottom: 40),
                      height: 250,
                      child: Image.asset('./assets/images/empty-cart.png'),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: value.cartItems.length,
                itemBuilder: (context, index) =>
                    CartListItem(value.cartItems[index]),
              ),
      ),
      bottomNavigationBar: Consumer<CartManager>(
        builder: (context, cart, child) => Container(
          height: 65,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                spreadRadius: 2,
                color: Color(0xffcccccc),
              )
            ],
          ),
          child: Row(
            children: <Widget>[
              SizedBox(width: 10),
              Container(
                margin: EdgeInsets.only(left: 9, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Total   ₹${_calculateCartTotal(cart.cartItems)}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 2.5),
                      child: Text(
                        '${cart.cartItems.length} ${cart.cartItems.length == 1 ? 'item' : 'items'}',
                        style: TextStyle(fontSize: 15, color: Colors.indigo),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Container(
                width: 120,
                margin: EdgeInsets.only(right: 18, bottom: 5),
                child: RaisedButton(
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ConfirmationPage()),
                  ),
                  child: Text('Checkout',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
