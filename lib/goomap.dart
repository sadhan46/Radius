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
  // Location
  LocationData _locationData;

  // Maps
  Set<Circle> _circles = HashSet<Circle>();
  List<LatLng> polygonLatLngs = List<LatLng>();
  double radius;

  //ids
  int _circleIdCounter = 1;

  // Type controllers
  bool _isCircle = false;

  @override
  void initState() {
    super.initState();
    // If I want to change the marker icon:
    // _setMarkerIcon();
    _locationData = widget.location;
  }

  // Set circles as points to the map
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
                    //markers: _markers,
                    circles: _circles,
                    //polygons: _polygons,
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
                      //ElevatedButton(onPressed: , child: child)
                    ],
                  ),
            )),
            /*
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  //color: Colors.black54,
                  onPressed: () {
                    _isCircle = true;
                    radius = 50;
                    return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.grey[900],
                          title: Text(
                            'Choose the radius (m)',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          content: Padding(
                              padding: EdgeInsets.all(8),
                              child: Material(
                                color: Colors.black,
                                child: TextField(
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.zoom_out_map),
                                    hintText: 'Ex: 100',
                                    suffixText: 'meters',
                                  ),
                                  keyboardType:
                                  TextInputType.numberWithOptions(),
                                  onChanged: (input) {
                                    setState(() {
                                      radius = double.parse(input);
                                    });
                                  },
                                ),
                              )),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Ok',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,),
                                )),
                          ],
                        ));
                  },
                  child: Text('Circle',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
            )
              */
          ],
        ));
  }
}