import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  List<String> _pictures = [];
  File? file;
  ImagePicker image = ImagePicker();
  late bool isSave = false;
  String status = "Veuillez scanner un document";

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      isSave = true;
      file = null;

      status = "Document enregistrer avec succès!";
    });
    Future.delayed(Duration(seconds: 2), () {
      end();
    });
  }

  void end() {
    setState(() {
      isSave = false;
    });
    Future.delayed(Duration(seconds: 5), () {
      end2();
    });
  }

  void end2() {
    setState(() {
      status = "Veuillez scanner un document!";
    });
  }

  // void onPressed() async {
  //   List<String> pictures;
  //   try {
  //     pictures = await CunningDocumentScanner.getPictures() ?? [];
  //     print('picture ${pictures}');
  //     if (!mounted) return;
  //     setState(() {
  //       _pictures = pictures;
  //     });
  //   } catch (exception) {
  //     // Handle exception here
  //   }
  // }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.camera);
    setState(() {
      if (img != null) {
        file = File(img.path);
      }
    });
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, file) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    final showimage = pw.MemoryImage(file.readAsBytesSync());

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Center(
            child: pw.Image(showimage, fit: pw.BoxFit.contain),
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isSave
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.purple,
                  ),
                ],
              ),
            )
          : Center(
              child: file == null
                  ? Text(
                      status,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    )
                  : PdfPreview(
                      build: (format) => _generatePdf(format, file),
                    ),
            ),
      floatingActionButton: file != null
          ? FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.check))
          : FloatingActionButton(
              onPressed: getImage,
              tooltip: 'Increment',
              child: const Icon(Icons.camera_alt_outlined),
            ),
    );
  }
}
