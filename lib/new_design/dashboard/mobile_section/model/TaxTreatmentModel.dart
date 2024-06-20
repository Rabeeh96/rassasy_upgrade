class TaxTreatmentModelClass {

  String treatmentValue, treatmentName;

  TaxTreatmentModelClass({
    required this.treatmentValue,
    required this.treatmentName,
  });

  factory TaxTreatmentModelClass.fromJson(Map<dynamic, dynamic> json) {
    return TaxTreatmentModelClass(
      treatmentValue: json['value'],
      treatmentName: json['name'],
    );
  }
}