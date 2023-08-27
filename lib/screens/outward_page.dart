import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:task_easy/screens/login_page.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:horizontal_center_date_picker/datepicker_controller.dart';
import 'package:horizontal_center_date_picker/horizontal_date_picker.dart';
//import 'services/inward_services.dart';
import 'package:task_easy/services/outward_services.dart';
import 'package:task_easy/widgets/outward_card.dart';
import 'package:task_easy/models/push_notification.dart';
import 'package:task_easy/widgets/notification_badge.dart';
//import 'package:task_assiatant/task_page.dart';
import 'popup_add_outward_page.dart';

class OutwardPage extends StatefulWidget {
  const OutwardPage({super.key});

  @override
  State<OutwardPage> createState() => _OutwardPageState();
}

class _OutwardPageState extends State<OutwardPage> {
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;
  //List taskItems = [];
  //List inwardItems = [];
  //List outwardItems = [];
  List tempItems = [];
  List items = [];
  //String toggleLabel = "";
  String _userLoggedIn = "";
  String _userGroupName = "";
  int? selectedindex = 0;
  final DateTime _now = DateTime.now();
  final DatePickerController _datePickerController = DatePickerController();
  TextEditingController searchController = TextEditingController();

  void registerNotifiction() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received

        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );
        print(notification.title);
        setState(() {
          _notificationInfo = notification;
        });
        if (_notificationInfo != null) {
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          );
        }
      });
    } else {
      print('User declined');
    }
  }

  void changeStateCallback() {
    setState(() {
      fetchOutward();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchOutward();
    //toggleLabel = " Inward Status";
    fetchUsername();
    registerNotifiction();
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate = _now.subtract(const Duration(days: 7));
    DateTime endDate = _now.add(const Duration(days: 30));

    return Scaffold(
        appBar: AppBar(
          title: const Text('Easy Task'),
          actions: [
            IconButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const OutwardPage()));
              },
              icon: const Icon(Icons.home),
            ),
            CircleAvatar(
              maxRadius: 17,
              backgroundColor: Colors.purple[300],
              child: Text(
                // customer
                _userLoggedIn,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: Container(
            color: Colors.deepPurple[200],
            child: ListView(
              children: [
                const DrawerHeader(
                  child: Center(
                    child: Text(
                      'Easy Task',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text(
                    'Outward',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => const OutwardPage()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                  },
                )
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 5, 0, 0),
                            child: ElevatedButton.icon(
                              // <-- ElevatedButton
                              onPressed: () {
                                fetchOutward();
                                _datePickerController.selectedDate = _now;
                              },
                              icon: Icon(
                                Icons.arrow_circle_right,
                                size: 12.0,
                              ),
                              label: Text('Outward'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          //Flexible(child: Text(toggleLabel, style: TextStyle(color: Colors.purple, fontSize: 17, fontWeight: FontWeight.bold))),
                          Expanded(child: Container()),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 8, 0),
                            child: SizedBox(
                              height: 30,
                              width: 150,
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: const Icon(Icons.search),
                                      onPressed: () {
                                        var input = searchController.text;
                                        List filtered = [];
                                        items = tempItems;
                                        setState(() {
                                          filtered = items
                                              .where((element) =>
                                                  element['customer'].toLowerCase().contains(input.toLowerCase()) ||
                                                  element['freight_company'].toLowerCase().contains(input.toLowerCase()) ||
                                                  (element['person_dispatched'] ?? "").toLowerCase().contains(input.toLowerCase()) ||
                                                  element['memo'].toLowerCase().contains(input.toLowerCase()))
                                              .toList();
                                          items = filtered;
                                        });
                                      }),
                                  Expanded(
                                    child: TextField(
                                      style: const TextStyle(color: Colors.deepPurple, fontSize: 13),
                                      controller: searchController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        contentPadding: const EdgeInsets.fromLTRB(5, 0, 0, 20),
                                        hintStyle: const TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 14,
                                        ),
                                        hintText: 'Search',
                                        suffixIcon: IconButton(
                                          icon: const Icon(Icons.clear, size: 10),
                                          onPressed: () => searchController.clear(),
                                        ),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Container(
                      padding: const EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: HorizontalDatePickerWidget(
                        width: 50,
                        height: 60,
                        monthFontSize: 10,
                        dayFontSize: 15,
                        weekDayFontSize: 10,
                        normalColor: Colors.grey,
                        locale: 'en_EN',
                        startDate: startDate,
                        endDate: endDate,
                        selectedDate: _now,
                        widgetWidth: MediaQuery.of(context).size.width * 1,
                        //widgetWidth: double.infinity,
                        datePickerController: _datePickerController,
                        onValueSelected: (date) {
                          final selectedDate = DateUtils.dateOnly(date);
                          List filtered = [];
                          items = tempItems;
                          setState(() {
                            filtered = items
                                .where((element) =>
                                    DateUtils.dateOnly(DateTime.parse(element['etd'])).isAfter(selectedDate) ||
                                    DateUtils.dateOnly(DateTime.parse(element['etd'])).isAtSameMomentAs(selectedDate))
                                .toList();
                            items = filtered;
                          });
                        },
                      ),
                    ),
                    _notificationInfo != null
                        ? Column(
                            children: [
                              Text(
                                'TITLE: ${_notificationInfo!.title}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'BODY: ${_notificationInfo!.body}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index] as Map;
                          //final id = item['id'];
                          //final flag = toggleLabel;
                          return OutwardCard(
                            index: index,
                            item: item,
                            //flag: flag,
                            outDeleteById: outDeleteById,
                            changeStateCallback: changeStateCallback,
                            //receivedProdcuts: receivedProducts,
                            //dispatchedProducts: dispatchedProducts,
                            bookedDispatch: bookedDispatch,
                            userGroupName: _userGroupName,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey[300],
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
              backgroundColor: Colors.purple[300],
              child: const Icon(Icons.add_card_rounded),
              onPressed: () {
                // Need to check 'group'
                // if not admin or office, can't execute
                if ((_userGroupName == 'office') || (_userGroupName == 'admin')) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            left: MediaQuery.of(context).viewInsets.left,
                            right: MediaQuery.of(context).viewInsets.right),
                        child: PopUpAddOutward(
                          //flag: toggleLabel,
                          changeStateCallback: changeStateCallback,
                        ),
                      ),
                    ),
                  );
                }
              }),
        ));
  }

  Future<void> fetchUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userLoggedIn = prefs.getString('username').toString();
    _userGroupName = prefs.getString('group').toString();
  }

  Future<void> fetchOutward() async {
    final response = await OutwardService.fetchOutward();
    List filtered = [];

    if (response != null) {
      setState(() {
        items = response;
        tempItems = response;
        filtered = items
            .where((element) =>
                DateUtils.dateOnly(DateTime.parse(element['etd'])).isAfter(DateUtils.dateOnly(_now)) ||
                DateUtils.dateOnly(DateTime.parse(element['etd'])).isAtSameMomentAs(DateUtils.dateOnly(_now)))
            .toList();
        //toggleLabel = " Outward Status";
        items = filtered;
      });
    } else {
      //showErrorMessage(context, message:'Something went wrong');
    }
    //setState(() {
    //  isLoading = false;
    //});
  }

  Future<void> outDeleteById(int id) async {
    //print('before delete');
    final isSuccess = await OutwardService.deleteById(id);

    if (isSuccess) {
      fetchOutward();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Deletion Failed'),
      ));
    }
  }

  Future<void> dispatchedProducts(int id, Map item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "customer": item["customer"],
      "product_type": item["product_type"],
      "pallet_space": item["pallet_space"],
      "etd": item["etd"],
      "freight_company": item["freight_company"],
      "booked_date": item['booked_date'],
      "dispatched_date": DateTime.now().toString(),
      "person_booked": item["person_booked"],
      "person_dispatched": prefs.getString('username').toString(),
      "memo": item["memo"],
    };

    // submit updated data to the server
    final isSuccess = await OutwardService.updateOutward(id, body);

    // show success or fail messages based on status
    if (isSuccess) {
      fetchOutward();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Update Success'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Update Failed'),
      ));
    }
  }

  Future<void> bookedDispatch(int id, Map item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "customer": item["customer"],
      "product_type": item["product_type"],
      "pallet_space": item["pallet_space"],
      "etd": item["etd"],
      "freight_company": item["freight_company"],
      "booked_date": DateTime.now().toString(),
      "dispatched_date": item["dispatched_date"],
      "person_booked": prefs.getString('username').toString(),
      "person_dispatched": item["person_dispatched"],
      "memo": item["memo"],
    };
    // submit updated data to the server
    final isSuccess = await OutwardService.updateOutward(id, body);

    // show success or fail messages based on status
    if (isSuccess) {
      fetchOutward();
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
