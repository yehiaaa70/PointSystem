class NewClient {
  String? name;
  String? personVendorName;
  int? personsCount;
  int? personQuantity;
  String? idNumber;
  String? supplyingCard;

  NewClient(
      {this.name,
        this.personVendorName,
        this.personsCount,
        this.personQuantity,
        this.idNumber,
        this.supplyingCard});

  NewClient.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    personVendorName = json['PersonVendorName'];
    personsCount = json['PersonsCount'];
    personQuantity = json['PersonQuantity'];
    idNumber = json['IdNumber'];
    supplyingCard = json['SupplyingCard'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['Name'] = name;
    data['PersonVendorName'] = personVendorName;
    data['PersonsCount'] = personsCount;
    data['PersonQuantity'] = personQuantity;
    data['IdNumber'] = idNumber;
    data['SupplyingCard'] = supplyingCard;
    return data;
  }

  @override
  String toString() {
    return 'NewClient{ Name: $name, PersonVendorName: $personVendorName, PersonsCount: $personsCount, PersonQuantity: $personQuantity, IdNumber: $idNumber, SupplyingCard: $supplyingCard}';
  }
}