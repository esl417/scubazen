class DiveLogModel {
  final String? siteName;
  final String? vesselShop;
  final String? user;
  final String? note;
  final String? coordinates;
  final String? decoTime;
  final String? safetyStop;
  final String? visUnits;
  final String? tempUnits;
  final String? equipment;
  final String? diveType;

  final int? altitude;
  final int? id;
  final int? visibility;
  final int? nitrogenPercent;
  final int? heliumPercent;
  final int? gasOxygen;
  final int? waterTemp;
  final int? beltWeight;
  final int? startPressure;

  final bool? dayNight;
  final bool? saltFresh;
  final bool? shoreBoat;
  final bool? decoGas;
  final bool? decoDive;

  DiveLogModel({
    this.siteName,
    this.vesselShop,
    this.user,
    this.note,
    this.coordinates,
    this.decoTime,
    this.safetyStop,
    this.visUnits,
    this.tempUnits,
    this.equipment,
    this.diveType,
    this.altitude,
    this.id,
    this.visibility,
    this.nitrogenPercent,
    this.heliumPercent,
    this.gasOxygen,
    this.waterTemp,
    this.beltWeight,
    this.startPressure,
    this.dayNight,
    this.saltFresh,
    this.shoreBoat,
    this.decoGas,
    this.decoDive,
  });

  DiveLogModel copyWith({
    String? siteName,
    String? vesselShop,
    String? user,
    String? note,
    String? coordinates,
    String? decoTime,
    String? safetyStop,
    String? visUnits,
    String? tempUnits,
    String? equipment,
    String? diveType,
    int? altitude,
    int? id,
    int? visibility,
    int? nitrogenPercent,
    int? heliumPercent,
    int? gasOxygen,
    int? waterTemp,
    int? beltWeight,
    int? startPressure,
    bool? dayNight,
    bool? saltFresh,
    bool? shoreBoat,
    bool? decoGas,
    bool? decoDive,
  }) {
    return DiveLogModel(
      siteName: siteName ?? this.siteName,
      vesselShop: vesselShop ?? this.vesselShop,
      user: user ?? this.user,
      note: note ?? this.note,
      coordinates: coordinates ?? this.coordinates,
      decoTime: decoTime ?? this.decoTime,
      safetyStop: safetyStop ?? this.safetyStop,
      visUnits: visUnits ?? this.visUnits,
      tempUnits: tempUnits ?? this.tempUnits,
      equipment: equipment ?? this.equipment,
      diveType: diveType ?? this.diveType,
      altitude: altitude ?? this.altitude,
      id: id ?? this.id,
      visibility: visibility ?? this.visibility,
      nitrogenPercent: nitrogenPercent ?? this.nitrogenPercent,
      heliumPercent: heliumPercent ?? this.heliumPercent,
      gasOxygen: gasOxygen ?? this.gasOxygen,
      waterTemp: waterTemp ?? this.waterTemp,
      beltWeight: beltWeight ?? this.beltWeight,
      startPressure: startPressure ?? this.startPressure,
      dayNight: dayNight ?? this.dayNight,
      saltFresh: saltFresh ?? this.saltFresh,
      shoreBoat: shoreBoat ?? this.shoreBoat,
      decoGas: decoGas ?? this.decoGas,
      decoDive: decoDive ?? this.decoDive,
    );
  }

  factory DiveLogModel.fromMap(Map<String, dynamic> map) {
    return DiveLogModel(
      siteName: map['siteName'],
      vesselShop: map['vesselShop'],
      user: map['user'],
      note: map['note'],
      coordinates: map['coordinates'],
      decoTime: map['decoTime'],
      safetyStop: map['safetyStop'],
      visUnits: map['visUnits'],
      tempUnits: map['tempUnits'],
      equipment: map['equipment'],
      diveType: map['diveType'],
      altitude: map['altitude'],
      id: map['id'],
      visibility: map['visibility'],
      nitrogenPercent: map['nitrogenPercent'],
      heliumPercent: map['heliumPercent'],
      gasOxygen: map['gasOxygen'],
      waterTemp: map['waterTemp'],
      beltWeight: map['beltWeight'],
      startPressure: map['startPressure'],
      dayNight: map['dayNight'],
      saltFresh: map['saltFresh'],
      shoreBoat: map['shoreBoat'],
      decoGas: map['decoGas'],
      decoDive: map['decoDive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'siteName': siteName,
      'vesselShop': vesselShop,
      'user': user,
      'note': note,
      'coordinates': coordinates,
      'decoTime': decoTime,
      'safetyStop': safetyStop,
      'visUnits': visUnits,
      'tempUnits': tempUnits,
      'equipment': equipment,
      'diveType': diveType,
      'altitude': altitude,
      'id': id,
      'visibility': visibility,
      'nitrogenPercent': nitrogenPercent,
      'heliumPercent': heliumPercent,
      'gasOxygen': gasOxygen,
      'waterTemp': waterTemp,
      'beltWeight': beltWeight,
      'startPressure': startPressure,
      'dayNight': dayNight,
      'saltFresh': saltFresh,
      'shoreBoat': shoreBoat,
      'decoGas': decoGas,
      'decoDive': decoDive,
    };
  }
}
