import '../models/active_nearby_available_drivers.dart';

class GeoFireAssistant
{
  static List<ActiveNearbyAvailableDrivers> activeNearbyAvailableDriversList = [];

  static void deleteOfflineDriverFromList(String driverId)
  {
    int indexNumber = activeNearbyAvailableDriversList.indexWhere((element) => element.driverId == driverId);
    activeNearbyAvailableDriversList.removeAt(indexNumber);
  }

  static void updateActiveNearbyAvailableDriverLocation(ActiveNearbyAvailableDrivers driverMove)
  {
    int indexNumber = activeNearbyAvailableDriversList.indexWhere((element) => element.driverId == driverMove.driverId);

    activeNearbyAvailableDriversList[indexNumber].locationLatitude = driverMove.locationLatitude;
    activeNearbyAvailableDriversList[indexNumber].locationLongitude = driverMove.locationLongitude;
  }
}