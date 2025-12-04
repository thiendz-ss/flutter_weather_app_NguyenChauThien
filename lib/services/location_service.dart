import 'package:geolocator/geolocator.dart';

class LocationService {
  // Kiểm tra quyền truy cập GPS
  Future<bool> checkPermission() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Lấy tọa độ hiện tại
  Future<Position> getCurrentPosition() async {
    bool allowed = await checkPermission();
    if (!allowed) throw Exception("Location permission denied.");

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
