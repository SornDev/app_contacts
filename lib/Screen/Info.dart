// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class InfoPage extends StatefulWidget {
  // ປະກາດໂຕແປ ຮັບຂໍ້ມູນ
  final int contactID;
  InfoPage({super.key, required this.contactID});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final _contactBox = Hive.box('contacts_box');
  late final Map<dynamic, dynamic> items;

  // set state
  @override
  void initState() {
    super.initState();
    //print(widget.contactID);
    // ທຳການໂຫລດຂໍ້ມູນ ເມື່ອແອ໊ບຖຶກເປີດຂື້ນ
    _readItem(widget.contactID);
  }

  // ອ່ານຂໍ້ມູນ 1 ລາຍການ
  void _readItem(int key) {
    final item = _contactBox.get(key);
    setState(() {
      items = item;
    });
    print(item);
    //return item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ຂໍ້ມູນຜູ້ຕິດຕໍ່'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.blue,
            child: const Center(
              child: Icon(
                Icons.person,
                size: 190,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Row(
                        children: [
                          items['gender'] == 'male'
                              ? Text('ທ່ານ ')
                              : Text('ທ່ານ ນ '),
                          Text(items['name'] + ' ' + items['lastname'])
                        ],
                      )),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(items['address']),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.phone),
                    title: Text(items['tel']),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Expanded(
              child: Center(
                  child: Container(
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    _callNumber(items['tel']);
                    // var url = Uri.parse("tel:8562028729723");
                    // if (await canLaunchUrl(url)) {
                    //   await launchUrl(url);
                    // } else {
                    //   throw 'Could not launch $url';
                    // }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.phone),
                      SizedBox(
                        width: 10,
                      ),
                      Text('ໂທທັນທີ'),
                    ],
                  ),
                ),
              )),
            ),
          )
        ],
      ),
    );
  }

  _callNumber(String phoneNumber) async {
    String number = phoneNumber;
    await FlutterPhoneDirectCaller.callNumber(number);
  }
}
