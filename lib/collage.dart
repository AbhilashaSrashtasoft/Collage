import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as IMG;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zoomer/zoomer.dart';

class CollageScreen extends StatefulWidget {
  const CollageScreen({Key key}) : super(key: key);

  @override
  _CollageScreenState createState() => _CollageScreenState();
}

class _CollageScreenState extends State<CollageScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Asset> images = <Asset>[];

  final transformController = TransformationController();
  final transformController1 = TransformationController();
  final transformController2 = TransformationController();

  TapDownDetails doubleTapDetails;
  TapDownDetails doubleTapDetails1;
  TapDownDetails doubleTapDetails2;

  ZoomerController _zoomerController = ZoomerController(initialScale: 1.0);
  ZoomerController _zoomerController1 = ZoomerController(initialScale: 1.0);
  ZoomerController _zoomerController2 = ZoomerController(initialScale: 1.0);

  double image1Top = 20;
  double image2Top = 110;
  bool isFirstUp = true;
  bool isSecondUp = true;

  handleDoubleTapDown(TapDownDetails details) {
    doubleTapDetails = details;
  }

  handleDoubleTapDown1(TapDownDetails details) {
    doubleTapDetails1 = details;
  }

  handleDoubleTapDown2(TapDownDetails details) {
    doubleTapDetails2 = details;
  }

  handleDoubleTap() {
    if (transformController.value != Matrix4.identity()) {
      transformController.value = Matrix4.identity();
    } else {
      final position = doubleTapDetails.localPosition;
      transformController.value = Matrix4.identity()
        ..translate(-position.dx, -position.dy)
        ..scale(2.0);
    }
  }

  handleDoubleTap1() {
    if (transformController1.value != Matrix4.identity()) {
      transformController1.value = Matrix4.identity();
    } else {
      final position1 = doubleTapDetails1.localPosition;
      transformController1.value = Matrix4.identity()
        ..translate(-position1.dx, -position1.dy)
        ..scale(2.0);
    }
  }

  handleDoubleTap2() {
    if (transformController2.value != Matrix4.identity()) {
      transformController2.value = Matrix4.identity();
    } else {
      final position2 = doubleTapDetails2.localPosition;
      transformController2.value = Matrix4.identity()
        ..translate(-position2.dx, -position2.dy)
        ..scale(2.0);
    }
  }

  double verticalDrag = 0;
  var scr = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    _zoomerController.onZoomUpdate(() {
      setState(() {});
    });
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Collage"),
        actions: [
          IconButton(
              icon: Icon(Icons.download_rounded),
              onPressed: () {
                takeScreenShot();
              })
        ],
      ),
      body: scaffoldBody(),
    );
  }

  Widget scaffoldBody() {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        SingleChildScrollView(
          child: RepaintBoundary(
            key: scr,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Column(
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                          ),
                          Zoomer(
                            enableTranslation: true,
                            enableRotation: true,
                            clipRotation: false,
                            maxScale: 2,
                            minScale: 1,
                            background: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.blue)),
                            height: 230,
                            width: MediaQuery.of(context).size.width / 2.5,
                            controller: _zoomerController,
                            child: Container(
                              height: 230,
                              width: 150,
                              child: ListView.builder(
                                itemCount:
                                    images.length < 1 ? images.length : 1,
                                itemBuilder: (BuildContext context, index) {
                                  Asset asset1 = images[0];
                                  return Container(
                                    height: 300,
                                    width: 100,
                                    child: AssetThumb(
                                        asset: asset1,
                                        width: 1080,
                                        height: 1080),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 230,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                            ),
                            Zoomer(
                              enableTranslation: true,
                              enableRotation: true,
                              clipRotation: false,
                              maxScale: 2,
                              minScale: 1,
                              background: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.blue)),
                              height: 230,
                              width: MediaQuery.of(context).size.width / 1.67,
                              controller: _zoomerController1,
                              child: Container(
                                height: 230,
                                //width: 210,
                                child: ListView.builder(
                                    itemCount:
                                        images.length < 1 ? images.length : 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Asset asset2 = images[1];
                                      return Container(
                                        height: 300,
                                        width: 210,
                                        child: AssetThumb(
                                            asset: asset2,
                                            width: 1080,
                                            height: 1080),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    //height: 138,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                        ),
                        Zoomer(
                          enableTranslation: true,
                          enableRotation: true,
                          clipRotation: false,
                          maxScale: 2,
                          minScale: 1,
                          background: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.blue)),
                          height: 138,
                          width: MediaQuery.of(context).size.width,
                          controller: _zoomerController2,
                          child: Container(
                            //height: 138,
                            child: ListView.builder(
                                itemCount:
                                    images.length < 1 ? images.length : 1,
                                itemBuilder: (BuildContext context, int index) {
                                  Asset asset3 = images[2];
                                  return AssetThumb(
                                      asset: asset3, width: 1080, height: 1080);
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        MaterialButton(
          onPressed: () {
            _showPicker();
          },
          child: Text("Image"),
          color: Colors.blue,
        )
      ],
    );
  }

  void _showPicker() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No error detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        selectedAssets: images,
        materialOptions: MaterialOptions(
            actionBarTitle: "Collage",
            actionBarColor: "#abcdef",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000"),
      );
    } on Exception catch (e) {
      error.toString();
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
    }); //
  }

  takeScreenShot() async {
    RenderRepaintBoundary boundary = scr.currentContext.findRenderObject();
    debugPrint("boundary: $boundary");
    var image = await boundary.toImage(pixelRatio: 10);
    debugPrint("image: $image");
    var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    debugPrint("canvas: $canvas");
    IMG.Image image2 = IMG.decodeImage(pngBytes);
    IMG.Image thumbnail = IMG.copyResize(image2, width: 1280, height: 1280);
    final ui.Codec frameImageCode =
        await ui.instantiateImageCodec(IMG.encodePng(thumbnail));
    final ui.Image finalFrameImage =
        (await frameImageCode.getNextFrame()).image;
    canvas.drawImage(finalFrameImage, Offset(0.0, 0.0), ui.Paint());
    final image1 = await pictureRecorder.endRecording().toImage(1280, 1280);
    final data = await image1.toByteData(format: ui.ImageByteFormat.png);
    final path = (await getTemporaryDirectory()).path + "${DateTime.now()}.png";
    File(path).writeAsBytesSync(data.buffer.asUint8List());
    await ImageGallerySaver.saveFile(path);
    debugPrint("path: $path");
    Fluttertoast.showToast(msg: "Done");
  }
}
