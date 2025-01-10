import 'package:bitracker/screens/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:math';
import 'dart:async';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  LatLng? myposition;
  late GoogleMapController mapController;
  Location location = Location();
  StreamSubscription<LocationData>? locationSubscription;

  List<LatLng> route = [];
  bool istracking = false;
  double currentSpeed = 0.0;
  double totalDistance = 0.0;
  Stopwatch stopwatch = Stopwatch();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    location.changeSettings(
      interval: 3000,
      distanceFilter: 3,
    );

    final locationData = await location.getLocation();
    setState(() {
      myposition = LatLng(
        locationData.latitude ?? 37.5665,
        locationData.longitude ?? 126.9780,
      );
      route.add(myposition!);
    });
  }

  // 이동 거리 계산
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371000;
    final dLat = _degreeToRadian(lat2 - lat1);
    final dLon = _degreeToRadian(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreeToRadian(lat1)) *
            cos(_degreeToRadian(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreeToRadian(double degree) {
    return degree * pi / 180;
  }

  void _startLocationTracking() {
    print("측정 시작");
    stopwatch.start();
    locationSubscription =
        location.onLocationChanged.listen((LocationData locationData) {
      final newPosition = LatLng(
        locationData.latitude ?? 0.0,
        locationData.longitude ?? 0.0,
      );
      if (route.isNotEmpty) {
        final lastPosition = route.last;
        final distance = _calculateDistance(
          lastPosition.latitude,
          lastPosition.longitude,
          newPosition.latitude,
          newPosition.longitude,
        );
        totalDistance += distance;
        currentSpeed = distance / 5;

        setState(() {
          myposition = newPosition;
          route.add(newPosition);
        });
      } else {
        setState(() {
          myposition = newPosition;
          route.add(newPosition);
        });
      }
    });
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        // Stopwatch로 경과 시간 업데이트
      });
    });
  }

  void onStartPressed() {
    setState(() {
      istracking = true;
    });

    _startLocationTracking();
  }

  void onPausePressed() {
    setState(() {
      istracking = false;
    });
    stopwatch.stop();
    timer?.cancel();
    print("측정 일시 정지");
    locationSubscription?.cancel();
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsedTime = stopwatch.elapsed;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(builder: (context) {
                return IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MenuScreen()),
                      );
                    },
                    icon: const Icon(Icons.menu_rounded));
              }),
              const SizedBox(),
              const Text('Bitracker'),
            ],
          ),
        ),
        body: Column(
          children: [
            Flexible(
              flex: 7,
              child: myposition == null
                  ? const Center(child: CircularProgressIndicator())
                  : GoogleMap(
                      onMapCreated: (controller) => mapController = controller,
                      initialCameraPosition: CameraPosition(
                        target: myposition!,
                        zoom: 18,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('current_location'),
                          position: myposition!,
                        ),
                      },
                      polylines: {
                        Polyline(
                          polylineId: const PolylineId('route'),
                          points: route,
                          color: Colors.green,
                          width: 5,
                        ),
                      },
                    ),
            ),
            Flexible(
              flex: 3,
              child: Column(
                children: [
                  IconButton(
                    onPressed: istracking ? onPausePressed : onStartPressed,
                    icon: istracking
                        ? const Icon(Icons.pause_circle_outline)
                        : const Icon(Icons.play_circle_outline),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                                "현재 속도 : ${(currentSpeed * 3.6).toStringAsFixed(2)} km/h"),
                            Text(
                                "평균 속도 : ${(totalDistance / elapsedTime.inSeconds * 3.6).toStringAsFixed(2)} km/h"),
                          ],
                        ),
                        const SizedBox(),
                        Column(
                          children: [
                            Text(
                                "이동 시간 : ${elapsedTime.toString().split('.').first}"),
                            Text(
                                "이동 거리 : ${(totalDistance / 1000).toStringAsFixed(2)} km"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
