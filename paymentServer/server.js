var braintree = require('braintree');
var express = require('express');
var app = express();


var gateway = new braintree.BraintreeGateway({
  environment: braintree.Environment.Sandbox,
  merchantId: 'zrpj7sdq8mmvryvv',
  publicKey: 'wgnjyjcvxp3r3jhb',
  privateKey: 'c7cd44fce8cb1551f8bb1c54b4ee236c'
});

app.get('/', function(req, res){
    res.send('hello world');
});

app.get("/checkout", function (req, res) {
    var nonceId = req.param('nonceId');
    var amount = req.param('amount');
    res.json({
        "Hello": "hello",
        "gv": "hgv"
    })
    gateway.transaction.sale({
        amount: amount,
        paymentMethodNonce: nonceId,
        options: {
          submitForSettlement: true
        }
      }).then(function (result) {
          print(result);
        if (result.success) {
          console.log('Transaction ID: ' + result.transaction.id);
        } else {
          console.error(result.message);
        }
      }).catch(function (err) {
        console.error(err);
      });
});


app.listen(8080);
