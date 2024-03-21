


import 'dart:convert';
import 'dart:typed_data';


getBytes(int id,   value) {
  int datas = value.length;
  Uint8List va = Uint8List(2+datas);
  va[0] = id;
  va[1] = value.length;

  for (var i = 0; i < value.length; i++) {
    va[2+i]= value[i];
  }
  return va;
}
b64Qrcode(customer,vatNumber,dateTime,invoiceTotal,vatTotal){

  List<int> newList1 = [];
  var data = [utf8.encode(customer),utf8.encode(vatNumber),utf8.encode(dateTime),utf8.encode(invoiceTotal),utf8.encode(vatTotal)];
  print(data.runtimeType);
  for(var i = 0;i<data.length ;i++){
    List<int> dat = List.from(getBytes(i+1, data[i]));
    newList1 = newList1+dat;
  }

  var res = base64Encode(newList1);
  print(res);
  return res;

}
