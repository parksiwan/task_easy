import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_easy/services/outward_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopUpDispatch extends StatefulWidget {
  final int id;
  final Map item;
  const PopUpDispatch({
    Key? key,
    required this.id,
    required this.item,
  }) : super(key: key);

  @override
  State<PopUpDispatch> createState() => _PopUpDispatchState();
}

class _PopUpDispatchState extends State<PopUpDispatch> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dispatchController = TextEditingController();

  Map item = {};
  int id = 0;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    item = widget.item;
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
                    'Dispatch',
                    style: TextStyle(color: Colors.deepPurple, fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  'Any notes on outwrd to be shared.',
                  style: GoogleFonts.openSans(fontSize: 15, color: Colors.deepPurple[300]),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: dispatchController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Any note on outward',
                  ),
                  cursorColor: Colors.deepPurple[200],
                  //validator: (value) {
                  //  if (value == null || value.isEmpty) {
                  //    return "Please enter location or any notes";
                  //  }
                  //  return null;
                  //},
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          item['memo_dispatcher'] = dispatchController.text;
                          dispatchProducts(id, item);
                        }
                        Navigator.pop(context);
                      },
                      child: const Text('Dispatch'),
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

  Future<void> dispatchProducts(int id, Map item) async {
    // Get the data from form

    // received date = Datetime.now
    // received person = username
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "customer": item["customer"],
      "product_type": item["product_type"],
      "outward_type": item["outward_type"],
      "pallet_space": item["pallet_space"],
      "etd": item["etd"],
      "freight_company": item["freight_company"],
      "booked_date": item["booked_date"],
      "dispatched_date": DateTime.now().toString(),
      "person_booked": item["person_booked"],
      "person_dispatched": prefs.getString('username').toString(),
      "memo": item["memo"],
      "memo_dispatcher": item["memo_dispatcher"],
    };
    // submit updated data to the server
    final isSuccess = await OutwardService.updateOutward(id, body);

    // show success or fail messages based on status
    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Update Success'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Update Failed'),
      ));
    }
  }
}
