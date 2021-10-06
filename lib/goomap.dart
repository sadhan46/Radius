import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GooMap extends StatefulWidget {
  //GooMap({Key key}) : super(key: key);

  final LocationData location;
  GooMap({this.location});

  @override
  _GooMapState createState() => _GooMapState();
}

class _GooMapState extends State<GooMap> {
  LocationData _locationData;

  Set<Circle> _circles = HashSet<Circle>();
  List<LatLng> polygonLatLngs = List<LatLng>();
  double radius;

  int _circleIdCounter = 1;

  bool _isCircle = false;

  @override
  void initState() {
    super.initState();
    _locationData = widget.location;
  }

  void _setCircles(LatLng point) {
    final String circleIdVal = 'circle_id_$_circleIdCounter';
    _circleIdCounter++;
    print(
        'Circle | Latitude: ${point.latitude}  Longitude: ${point.longitude}  Radius: $radius');
    _circles.add(Circle(
        circleId: CircleId(circleIdVal),
        center: LatLng(_locationData.latitude, _locationData.longitude),
        radius: radius,
        fillColor: Colors.teal.withOpacity(0.3),
        strokeWidth: 3,
        strokeColor: Colors.teal));
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      /*appBar: AppBar(
        title: Center(
          child: Text(
            "Map"
          ),
        ),
      ),*/
        body: Stack(
          children: <Widget>[

            Column(
              children: [
                Container(
                  color: Colors.teal,
                  height: 100,
                ),
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_locationData.latitude, _locationData.longitude),
                      zoom: 16,
                    ),
                    mapType: MapType.hybrid,
                    circles: _circles,
                    myLocationEnabled: true,
                    onTap: (point) {if (_isCircle) {
                        setState(() {
                          _circles.clear();
                          _setCircles(point);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            Positioned(
                top: 70,
                left: 120,
                child: Container(
                height: 50,
                width: _width-240,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: _width-240,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Enter Radius"
                            ),
                            keyboardType: TextInputType.numberWithOptions(),
                            onChanged: (value){
                              _isCircle = true;
                              radius = 50.0;
                              setState(() {
                                radius = double.parse(value);
                              });
                            }
                          )),
                    ],
                  ),
            )),
          ],
        ));
  }
}