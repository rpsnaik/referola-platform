import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:referola/ui-components/buttons/longButton.dart';
import 'package:http/http.dart' as http;

class CheckOutPage extends StatefulWidget {
  final firestore.DocumentSnapshot campaignData;
  final String isRefferedByUser;
  final int packageSelected;
  CheckOutPage({@required this.campaignData, @required this.isRefferedByUser, @required this.packageSelected});
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {

  final String tokenizationKey = 'sandbox_7b7n2kqf_zrpj7sdq8mmvryvv';

  double finalPrice = 0;

  void showNonce(BraintreePaymentMethodNonce nonce) async{
    
    print("Clod fun");
    var url = 'https://us-central1-referola-production.cloudfunctions.net/app/checkout?nonce=${nonce.nonce}&amount=$finalPrice';
    print(url);
    var response = await http.get(url);
    print(response.body);



    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Payment method nonce:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Nonce: ${nonce.nonce}'),
            SizedBox(height: 16),
            Text('Type label: ${nonce.typeLabel}'),
            SizedBox(height: 16),
            Text('Description: ${nonce.description}'),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    finalPrice = ( widget.campaignData.data['packages'][widget.packageSelected]['packageAmount'] - ((widget.campaignData.data['packages'][widget.packageSelected]['packageDiscount']*widget.campaignData.data['packages'][widget.packageSelected]['packageAmount'])/100) );
    setState(() {
      
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check out', style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                
                Text("Service Item : ", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0
                ),),
                SizedBox(
                  height: 10.0,
                ),
                Text(widget.campaignData.data['campainTitle'], style: TextStyle(
                  fontSize: 20.0
                ),),
                SizedBox(
                  height: 5.0,
                ),
                Text(widget.campaignData.data['campainSubTitle']),
                SizedBox(
                  height: 15.0,
                ),
                Text("Package", style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold
                ),),

                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.campaignData.data['packages'][widget.packageSelected]['packageTitle'])
                  ],
                ),

                SizedBox(
                  height: 20.0,
                ),
                Text("Pricing Information", style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold
                ),),
                SizedBox(
                  height: 10.0,
                ),
                ListTile(
                  title: Text("Actual Amount", style: TextStyle(
                    fontWeight: FontWeight.w400
                  ),),
                  trailing: Text(widget.campaignData.data['packages'][widget.packageSelected]['packageAmount'].toString()+" USD"),
                ),
                ListTile(
                  title: Text("Discount", style: TextStyle(
                    fontWeight: FontWeight.w400
                  ),),
                  trailing: Text("-"+ ( (widget.campaignData.data['packages'][widget.packageSelected]['packageDiscount']*widget.campaignData.data['packages'][widget.packageSelected]['packageAmount'])/100 ).toString() +" USD"),
                ),
                Divider(
                  color: Colors.blueGrey,
                ),
                ListTile(
                  title: Text("Check out Amount", style: TextStyle(
                    fontWeight: FontWeight.w400
                  ),),
                  trailing: Text(finalPrice.toString() +" USD"),
                ),
                Divider(
                  color: Colors.blueGrey,
                ),


                SizedBox(
                  height: 20.0,
                ),





                CustomLongButton().loadButton(context, "Place Order", ()async{
                    var request = BraintreeDropInRequest(
                      tokenizationKey: tokenizationKey,
                      collectDeviceData: true,
                      amount: finalPrice.toString(),
                      venmoEnabled: true,

                      googlePaymentRequest: BraintreeGooglePaymentRequest(
                        totalPrice: finalPrice.toString(),
                        currencyCode: 'USD',
                        billingAddressRequired: false,
                      ),
                      paypalRequest: BraintreePayPalRequest(
                        amount: finalPrice.toString(),
                        currencyCode: "USD",
                        displayName: 'TechnoPark LLC',
                      ),
                    );
                    BraintreeDropInResult result =
                        await BraintreeDropIn.start(request);
                    if (result != null) {
                      showNonce(result.paymentMethodNonce);
                    }
                }),
                


                // RaisedButton(
                //   onPressed: () async {
                //     final request = BraintreeCreditCardRequest(
                //       cardNumber: '4111111111111111',
                //       expirationMonth: '12',
                //       expirationYear: '2021',
                //     );
                //     BraintreePaymentMethodNonce result =
                //         await Braintree.tokenizeCreditCard(
                //       tokenizationKey,
                //       request,
                //     );
                //     if (result != null) {
                //       showNonce(result);
                //     }
                //   },
                //   child: Text('TOKENIZE CREDIT CARD'),
                // ),
                // RaisedButton(
                //   onPressed: () async {
                //     final request = BraintreePayPalRequest(
                //       billingAgreementDescription:
                //           'I hearby agree that flutter_braintree is great.',
                //       displayName: 'TechnoPark LLC',
                //     );
                //     BraintreePaymentMethodNonce result =
                //         await Braintree.requestPaypalNonce(
                //       tokenizationKey,
                //       request,
                //     );
                //     if (result != null) {
                //       showNonce(result);
                //     }
                //   },
                //   child: Text('PAYPAL VAULT FLOW'),
                // ),
                // RaisedButton(
                //   onPressed: () async {
                //     final request = BraintreePayPalRequest(amount: '13.37', currencyCode: "usd");
                //     BraintreePaymentMethodNonce result =
                //         await Braintree.requestPaypalNonce(
                //       tokenizationKey,
                //       request,
                //     );
                //     if (result != null) {
                //       showNonce(result);
                //     }
                //   },
                //   child: Text('PAYPAL CHECKOUT FLOW'),
                // ),


              ],
            ),
          ),
        ],
      )
    );
  }
}