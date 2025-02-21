

import 'package:shared/shared.dart';

class ParkingRepository extends DataRepository<Parking>{
ParkingRepository([super.filePath = 'storage/parking.json']);

@override
  Parking fromJson(Map<String, dynamic> json) => Parking.fromJson(json);
  
  @override
  Map<String, dynamic> toJson(Parking item) => item.toJson();

  Parking? getParkingById(String id){
    final parkings = getAll();

    for(var parking in parkings){
      if(parking.parkingId.trim().toLowerCase() == id.trim().toLowerCase()){
        return parking;
      }
    }
    return null;
  }

  @override
  String getId(Parking parking){
    return parking.parkingId;
  }
}