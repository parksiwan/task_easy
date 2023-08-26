import 'package:flutter/material.dart';

class PopUpDetailInOutward extends StatelessWidget {
  final TextEditingController customerController = TextEditingController();
  final TextEditingController productTypeController = TextEditingController();
  final TextEditingController outwardTypeController = TextEditingController();
  final TextEditingController palletSpace = TextEditingController();
  final TextEditingController etdController = TextEditingController();
  final TextEditingController palletSpaceController = TextEditingController();
  final TextEditingController personBookedController = TextEditingController();
  final TextEditingController bookedDateController = TextEditingController();
  final TextEditingController personDispatchedController = TextEditingController();
  final TextEditingController dispatchedDateController = TextEditingController();
  final TextEditingController freightCompanyController = TextEditingController();
  final TextEditingController memoOutController = TextEditingController();
  final TextEditingController memoOutDispatchController = TextEditingController();
  //final String? flag;
  final Map item;
  PopUpDetailInOutward({
    Key? key,
    //required this.flag,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    customerController.text = item['customer'];
    productTypeController.text = item['product_type'];
    outwardTypeController.text = item['outward_type'];
    palletSpaceController.text = item['pallet_space'];
    etdController.text = item['etd'].toString().substring(0, 10).replaceAll('T', ' ');
    personBookedController.text = item['person_booked'] == null ? "No" : item['person_booked'];
    bookedDateController.text = item['booked_date'] == null ? "No" : item['booked_date'].toString().substring(0, 10).replaceAll('T', ' ');
    personDispatchedController.text = item['person_dispatched'] == null ? "No" : item['person_dispatched'];
    dispatchedDateController.text = item['dispatched_date'] == null ? "No" : item['dispatched_date'].toString().replaceAll('T', ' ');
    freightCompanyController.text = item['freight_company'];
    memoOutController.text = item['memo'];
    memoOutDispatchController.text = item['memo_dispatcher'];
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: Text(
                  'Outward Details',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: customerController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Customer',
                ),
              ),
              const SizedBox(height: 2),
              TextFormField(
                controller: productTypeController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Product Type',
                ),
              ),
              const SizedBox(height: 2),
              TextFormField(
                controller: outwardTypeController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Outward Type',
                ),
              ),
              const SizedBox(height: 2),
              TextFormField(
                controller: palletSpaceController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Quantity',
                ),
              ),
              const SizedBox(height: 2),
              TextFormField(
                controller: etdController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'ETD',
                ),
              ),
              const SizedBox(height: 2),
              TextFormField(
                controller: freightCompanyController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Forward Company',
                ),
              ),
              const SizedBox(height: 2),
              TextFormField(
                controller: personBookedController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Prepared By',
                ),
              ),
              const SizedBox(height: 2),
              TextFormField(
                controller: bookedDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Prepared date',
                ),
              ),
              const SizedBox(height: 2),
              TextFormField(
                controller: personDispatchedController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Dispatched By',
                ),
              ),
              const SizedBox(height: 2),
              TextFormField(
                controller: dispatchedDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Dispatched date',
                ),
              ),
              const SizedBox(height: 2),
              TextFormField(
                minLines: 1,
                maxLines: 3,
                controller: memoOutController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'memo by Preparer',
                ),
              ),
              const SizedBox(height: 2),
              TextFormField(
                minLines: 1,
                maxLines: 3,
                controller: memoOutDispatchController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'memo by Dispatcher',
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
