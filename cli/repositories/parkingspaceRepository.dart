import '../Models/parkingspaceModel.dart';
import '../Repositories/dataRespository.dart';

class ParkingspaceRepository extends DataRepository<Parkingspace>{
ParkingspaceRepository([super.filePath = 'storage/parkingspace.json']);

@override
  Parkingspace fromJson(Map<String, dynamic> json) => Parkingspace.fromJson(json);
  
  @override
  Map<String, dynamic> toJson(Parkingspace item) => item.toJson();

  Parkingspace? getSpaceById(String id){
    final parkingspaces = getAll();

    for(var parkingspace in parkingspaces){
      if(parkingspace.parkingSpaceId.trim().toLowerCase() == id.trim().toLowerCase()){
        return parkingspace;
      }
    }
    return null;
  }

  @override
  String getId(Parkingspace parkingspace){
    return parkingspace.parkingSpaceId;
  }
}