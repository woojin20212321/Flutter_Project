import 'package:bitracker/screens/menu_screen.dart';
import 'package:bitracker/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:math';
import 'dart:async';
import 'dart:collection';
import 'package:bitracker/theme.dart';

import 'package:shared_preferences/shared_preferences.dart';

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
  double maxSpeed = 0.0;
  double averageSpeed = 0.0;
  double lastAverageSpeed = 0.0;
  Stopwatch stopwatch = Stopwatch();
  Timer? timer;
  Duration elapsedTime = Duration.zero;
  DateTime? startTime;

  // 속도 계산을 위한 이동 평균 변수들 추가
  Queue<double> speedBuffer = Queue<double>();
  static const int SPEED_BUFFER_SIZE = 5;
  static const double MIN_DISTANCE = 2.0; // 최소 2미터 이상 이동했을 때만 계산
  LocationData? previousLocation;
  DateTime? previousTime;

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
      interval: 1000,
      distanceFilter: 1,
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

  // 속도 계산 함수 수정
  double _calculateSpeed(LocationData locationData) {
    if (previousLocation == null || previousTime == null) {
      previousLocation = locationData;
      previousTime = DateTime.now();
      return 0.0;
    }

    final distance = _calculateDistance(
      previousLocation!.latitude!,
      previousLocation!.longitude!,
      locationData.latitude!,
      locationData.longitude!,
    );

    // 최소 이동 거리 체크
    if (distance < MIN_DISTANCE) {
      return currentSpeed;
    }

    final duration = DateTime.now().difference(previousTime!).inSeconds;
    if (duration == 0) return currentSpeed;

    // 속도 계산 (km/h)
    double newSpeed = (distance / duration) * 3.6;

    // 이동 평균 계산
    speedBuffer.add(newSpeed);
    if (speedBuffer.length > SPEED_BUFFER_SIZE) {
      speedBuffer.removeFirst();
    }

    double avgSpeed = speedBuffer.reduce((a, b) => a + b) / speedBuffer.length;

    // 이전 위치와 시간 업데이트
    previousLocation = locationData;
    previousTime = DateTime.now();

    return avgSpeed.roundToDouble();
  }

  // 추적 시작
  void _startLocationTracking() {
    startTime ??= DateTime.now();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        elapsedTime =
            Duration(seconds: DateTime.now().difference(startTime!).inSeconds);
      });
    });
    print("측정 시작");
    stopwatch.start();
    locationSubscription =
        location.onLocationChanged.listen((LocationData locationData) {
      print('위치 업데이트 발생: ${locationData.latitude}, ${locationData.longitude}');
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

        if (distance > MIN_DISTANCE) {
          totalDistance += distance;
          totalDistance = totalDistance.round().toDouble();

          final elapsedTimeInSeconds =
              DateTime.now().difference(startTime!).inSeconds;
          elapsedTime = Duration(seconds: elapsedTimeInSeconds);

          setState(() {
            currentSpeed = _calculateSpeed(locationData);
            maxSpeed = max(maxSpeed, currentSpeed);
            maxSpeed = maxSpeed.round().toDouble();

            if (currentSpeed > 0 && elapsedTimeInSeconds > 0) {
              averageSpeed = (totalDistance / elapsedTimeInSeconds) * 3.6;
              averageSpeed = averageSpeed.roundToDouble();
            }

            myposition = newPosition;
            route.add(newPosition);
          });
        }

        print('현재 상태:');
        print('경과 시간(초): ${elapsedTime.inSeconds}');
        print('총 이동 거리: $totalDistance');
        print('평균 속도: $averageSpeed');
        print('최고 속도: $maxSpeed');
      } else {
        setState(() {
          myposition = newPosition;
          route.add(newPosition);
        });
      }
    });
  }

  // 추적 시작 버튼 함수
  void onStartPressed() {
    setState(() {
      istracking = true;
      startTime = DateTime.now();
    });

    _startLocationTracking();
  }

  // 추적 일시 정지 버튼 함수
  void onPausePressed() {
    setState(() {
      istracking = false;
    });
    stopwatch.stop();
    timer?.cancel();
    print("측정 일시 정지");
    locationSubscription?.cancel();
  }

  // 추적 끝 버튼 함수
  void onStopPressed() async {
    await saveStats();
    setState(() {
      istracking = false;
    });
    stopwatch.stop();
    timer?.cancel();
    locationSubscription?.cancel();
    final elapsedTimeInSeconds =
        DateTime.now().difference(startTime!).inSeconds;
    setState(() {
      elapsedTime = Duration(seconds: elapsedTimeInSeconds);
    });
    print("추적 종료");

    currentSpeed = 0.0;
    elapsedTime = Duration.zero;
    totalDistance = 0.0;
    averageSpeed = 0.0;
  }

  Future<void> saveStats() async {
    // SharedPreferences에 데이터 저장
    final prefs = await SharedPreferences.getInstance();

    print('저장 전 데이터 확인:');
    print('최고 속도: $maxSpeed');
    print('총 이동 거리: $totalDistance');
    print('평균 속도: $averageSpeed');
    print('경과 시간: ${elapsedTime.inSeconds}초');

    maxSpeed.round();
    totalDistance.round();
    averageSpeed.round();
    await prefs.setDouble('maxSpeed', maxSpeed);
    await prefs.setDouble('totalDistance', totalDistance);
    await prefs.setDouble('averageSpeed', averageSpeed);
    await prefs.setString('elapsedTime', elapsedTime.toString());
    print('데이터 저장 완료');
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsedTime = stopwatch.elapsed;
    return MaterialApp(
      theme: ThemeData(colorScheme: appColorScheme()),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 20),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            child: AppBar(
              backgroundColor: const Color.fromARGB(255, 37, 37, 37),
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(builder: (context) {
                    return IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MenuScreen()),
                          );
                        },
                        icon: const Icon(Icons.menu_rounded));
                  }),
                  const SizedBox(),
                  const Text('Bitracker'),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
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
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 170,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Color.fromARGB(255, 37, 37, 37),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "현재 속도 \n ${currentSpeed.toStringAsFixed(2)} km/h",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                width: 100,
                                child: Divider(
                                  thickness: 1,
                                ),
                              ),
                              Text(
                                  "평균 속도 \n ${(averageSpeed).toStringAsFixed(2)} km/h",
                                  textAlign: TextAlign.center),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed:
                                    istracking ? onStopPressed : onStartPressed,
                                icon: istracking
                                    ? const Icon(Icons.stop_circle_outlined)
                                    : const Icon(Icons.play_circle_outline),
                                style: IconButton.styleFrom(
                                  iconSize: 70,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                  "이동 시간 \n ${elapsedTime.toString().split('.').first}"),
                              const SizedBox(
                                width: 100, // 가로선의 너비
                                child: Divider(
                                  thickness: 1,
                                ),
                              ),
                              Text(
                                  "이동 거리 \n ${(totalDistance / 1000).toStringAsFixed(2)} km"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
