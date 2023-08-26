import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_easy/services/outward_services.dart';
import 'package:task_easy/utils/constants.dart';

class PopUpEditOutward extends StatefulWidget {
  //final String? flag;
  final Map item;
  final Function() changeStateCallback;
  const PopUpEditOutward({
    Key? key,
    //required this.flag,
    required this.item,
    required this.changeStateCallback,
  }) : super(key: key);

  @override
  State<PopUpEditOutward> createState() => _PopUpEditOutward();
}

class _PopUpEditOutward extends State<PopUpEditOutward> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController customerController = TextEditingController();
  TextEditingController memoOutController = TextEditingController();
  TextEditingController personOrderedController = TextEditingController();
  TextEditingController personBookedController = TextEditingController();
  TextEditingController etdController = TextEditingController();
  TextEditingController palletSpaceController = TextEditingController();
  TextEditingController freightCompanyController = TextEditingController();
  String supplierName = "";
  String customerName = "";

  String? _dropdownProductTypesValue = "";
  String? _dropdownOutwardTypesValue = "";

  //String flag = "";
  Map item = {};
  //int id = 0;

  @override
  void initState() {
    super.initState();
    //flag = widget.flag.toString();
    item = widget.item;
    //getUsername();
    customerController.text = item['customer'];
    _dropdownProductTypesValue = item['product_type'];
    _dropdownOutwardTypesValue = item['outward_type'];
    palletSpaceController.text = item['pallet_space'];
    etdController.text = item['etd'];
    freightCompanyController.text = item['freight_company'];
    memoOutController.text = item['memo'];
    //id = item['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff616161),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    'Edit Outward',
                    style: TextStyle(color: Colors.deepPurple, fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  'Edit outward details in the form below.',
                  style: GoogleFonts.openSans(fontSize: 15, color: Colors.deepPurple[300]),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: customerController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Customer',
                  ),
                  cursorColor: Colors.deepPurple[200],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Customer";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField(
                  items: productTypes.map((map) {
                    return DropdownMenuItem<String>(
                      value: map['value'],
                      child: Text(map['name']),
                    );
                  }).toList(),
                  value: _dropdownProductTypesValue,
                  onChanged: dropdownProductTypesCallback,
                  decoration: const InputDecoration(
                    labelText: "Product Types",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value == "NO TYPES") {
                      return "Please enter Product Type";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField(
                  items: outwardTypes.map((map) {
                    return DropdownMenuItem<String>(
                      value: map['value'],
                      child: Text(map['name']),
                    );
                  }).toList(),
                  value: _dropdownOutwardTypesValue,
                  onChanged: dropdownOutwardTypesCallback,
                  decoration: const InputDecoration(
                    labelText: "Outward Types",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value == "NO TYPES") {
                      return "Please enter Outward Type";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: palletSpaceController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Quantity',
                  ),
                  cursorColor: Colors.deepPurple[200],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Quantity";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: etdController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'ETD - click for calendar',
                  ),
                  onTap: () async {
                    DateTime? pickedDate =
                        await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime(2050));
                    if (pickedDate != Null) {
                      etdController.text = pickedDate.toString();
                    }
                  },
                  cursorColor: Colors.deepPurple[200],
                ),
                TextFormField(
                  controller: freightCompanyController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Freight Company',
                  ),
                  cursorColor: Colors.deepPurple[200],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Freight Company";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: memoOutController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Memo',
                  ),
                  cursorColor: Colors.deepPurple[200],
                  maxLines: 2,
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            editData(item);
                          });
                          Navigator.pop(context);
                          //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing Data'),));
                        }
                      },
                      child: const Text('Edit'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void dropdownProductTypesCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownProductTypesValue = selectedValue;
      });
    }
  }

  void dropdownOutwardTypesCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownOutwardTypesValue = selectedValue;
      });
    }
  }

  Future<void> editData(Map item) async {
    final id = item['id'];
    final customer = customerController.text;
    final productType = _dropdownProductTypesValue;
    final outwardType = _dropdownOutwardTypesValue;
    final palletSpace = palletSpaceController.text;
    final etd = etdController.text;
    final freightCompany = freightCompanyController.text;
    final personBooked = personBookedController.text;
    final memo = memoOutController.text;
    final bookedDate = item['booked_date'];
    final dispatchedDate = item['dispatch_date'];
    final personDispatched = item['person_dispatched'];

    final body = {
      "customer": customer,
      "product_type": productType,
      "outward_type": outwardType,
      "pallet_space": palletSpace,
      "etd": etd,
      "freight_company": freightCompany,
      "booked_date": bookedDate,
      "dispatched_date": dispatchedDate,
      "person_booked": personBooked,
      "person_dispatched": personDispatched,
      "memo": memo,
    };
    // Submit data to the server
    final isSuccess = await OutwardService.updateOutward(id, body);
    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Outward details edited'),
      ));
      widget.changeStateCallback();
      //HomePageState().fetchOutward();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Something went wrong'),
      ));
    }
  }
}
