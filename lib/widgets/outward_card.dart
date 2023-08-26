import 'package:flutter/material.dart';
import 'package:task_easy/screens/popup_edit_outward_page.dart';
import 'package:task_easy/screens/popup_detail_outward_page.dart';
import 'package:task_easy/screens/popup_dispatch_page.dart';

class OutwardCard extends StatelessWidget {
  final int index;
  final Map item;
  //final String flag;
  final Function(int) outDeleteById;
  final Function() changeStateCallback;
  //final Function(int, Map) receivedProdcuts;
  //final Function(int, Map) dispatchedProducts;
  final Function(int, Map) bookedDispatch;
  final String userGroupName;
  //final Function(Map) taskDetail;
  const OutwardCard(
      {Key? key,
      required this.index,
      required this.item,
      //required this.flag,
      required this.outDeleteById,
      required this.changeStateCallback,
      //required this.receivedProdcuts,
      //required this.dispatchedProducts,
      required this.bookedDispatch,
      required this.userGroupName
      //required this.taskDetail,
      })
      : super(key: key);
  final bool checkedReceived = false;
  final bool checkedDispatched = false;

  @override
  Widget build(BuildContext context) {
    final id = item['id'];

    return Card(
      color: Colors.grey[200],
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        dense: true,
        tileColor: item['person_dispatched'] == null ? Colors.grey[200] : Colors.green[200],
        visualDensity: const VisualDensity(vertical: -3),
        leading: CircleAvatar(
          maxRadius: 17,
          backgroundColor: Colors.deepPurple,
          child: Text(
            // customer
            //item['person_dispatched'] == null ? item["etd"].substring(5,10) : item["etd"].substring(5,10),
            item["etd"].substring(8, 10) + "/" + item["etd"].substring(5, 7),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                item["customer"],
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              child: Text(
                //"${" (" + item["product_type"]})",
                " (" + item["product_type"] + ")",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: Text(
                //"${" (" + item["product_type"]})",
                item["outward_type"] == 'PICKUP'
                    ? " " + item["outward_type"]
                    : item["outward_type"] == 'RETURN'
                        ? " " + item["outward_type"]
                        : "",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: item['outward_type'] == 'PICKUP'
                        ? Colors.redAccent
                        : item['outward_type'] == 'RETURN'
                            ? Colors.blueAccent
                            : null,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            //const Flexible(child: Text('F.D.: ')),
            Flexible(
              child: Text(item['pallet_space'] + ' (' + item['freight_company'] + ")",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: MediaQuery.of(context).viewInsets.left,
                    right: MediaQuery.of(context).viewInsets.right),
                child: PopUpDetailInOutward(
                  //flag: flag,
                  item: item,
                ),
              ),
            ),
          );
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            item["memo"] == "" ? const Text("") : const Icon(Icons.note, color: Colors.blueAccent),
            item["memo_dispatcher"] == "" ? const Text("") : const Icon(Icons.note, color: Colors.deepOrangeAccent),
            PopupMenuButton(
              onSelected: (value) {
                if (value == 'edit') {
                  if (((userGroupName == 'office') || (userGroupName == 'admin')) && item['dispatched_date'] == null) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                              left: MediaQuery.of(context).viewInsets.left,
                              right: MediaQuery.of(context).viewInsets.right),
                          child: PopUpEditOutward(
                            //flag: flag,
                            item: item,
                            changeStateCallback: changeStateCallback,
                          ),
                        ),
                      ),
                    );
                  }
                } else if (value == 'delete') {
                  if (((userGroupName == 'office') || (userGroupName == 'admin')) && item['dispatched_date'] == null) {
                    outDeleteById(id);
                  }
                } else if (value == 'dispatch') {
                  if (item['dispatched_date'] == null) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                              left: MediaQuery.of(context).viewInsets.left,
                              right: MediaQuery.of(context).viewInsets.right),
                          child: PopUpDispatch(
                            //flag: flag,
                            id: id,
                            item: item,
                            //changeStateCallback: changeStateCallback,
                          ),
                        ),
                      ),
                    );
                    //dispatchedProducts(id, item);
                  }
                } else if (value == 'book') {
                  if (item['dispatched_date'] == null) {
                    bookedDispatch(id, item);
                  }
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        Text(
                          '  Edit',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete),
                        Text('  Delete',
                            style: TextStyle(
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    child: Column(
                      children: [
                        Divider(
                          color: Colors.grey,
                          thickness: 2,
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'book',
                    child: Row(
                      children: [
                        Icon(Icons.book_online),
                        Text(
                          '  Prepare',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'dispatch',
                    child: Row(
                      children: [
                        Icon(Icons.send),
                        Text(
                          '  Dispatch',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}
