 /*
 *Name: Dalton, Matthew
 *Date: 12/14/2022
 *Description: In qrReader we create a widget that utilizes the camera of the device. 
     using the camera we can read qr codes. We get the info from the qr("userid") and send the user to the matching profile page
 *Bugs: If someone wants to use this for scanning some other way and scan a random qr code not from the app,
   its likely to still send to a blank profile or crash. But at that point they weren't trying to use the app for its
   intended purpose anyways.
 *Reflection: 
    Time was spent on this trying to make sure that the qr wasn't scanning multiple times.
    or that it wasnt scanning in the background. There were times it wouldn't open at all.
    This is a great feature to add to mainline the process of finding friends who are near you, or
    even some you just met that might also have the app. 
*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:getgroovy/pages/profile_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool validQr = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  // Makes sure we know which device we are running on 

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    //always watching to see if we scan a qe
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        result = scanData;
        String userid = result!.code ?? '';
        //make sure the scan acually gives a value and the thing scanned is a qr
        if(userid != '' && validQr == false){
          validQr = true;
          Future clickBack = Navigator.of(context).push<bool>(MaterialPageRoute(builder: (BuildContext context) => Scaffold(appBar: AppBar(),body: ProfilePage(userID: userid))));
          clickBack.then((value) => validQr = false);
          
        }
      });
    });
  }

  //pretty self explanatory
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}