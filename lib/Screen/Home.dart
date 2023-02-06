import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ປະກາດໂຕແປ _items ເ
  List<Map<String, dynamic>> _items = [];

  // ປະກາດໂຕແປ ກ້ອນຂໍ້ມູນ
  final _contactBox = Hive.box('contacts_box');

  @override
  void initState() {
    super.initState();
    _refreshItems(); // ທຳການໂຫລດຂໍ້ມູນ ເມື່ອແອ໊ບຖຶກເປີດຂື້ນ
  }

  // ຟັງຊັ່ນໃນການດຶງຂໍ້ມູນ ອັບເດດລ່າສຸດ
  void _refreshItems() {
    // ທຳການດຶງຂໍ້ມູນ ໂຕແປ ແລ້ວຈັດກ້ອນຂໍ້ມູນເຂົ້າເປັນ list
    final data = _contactBox.keys.map((key) {
      final value = _contactBox.get(key);
      return {
        "key": key,
        "name": value["name"],
        "lastname": value["lastname"],
        "gender": value["gender"],
        "address": value['address'],
        "tel": value["tel"],
      };
    }).toList();

    // ທຳການກຳນໄດ ຂໍ້ມູນທີ່ອ່ານມາໄດ້ ໃສ່ໂຕແປ _item
    setState(() {
      _items = data.reversed.toList();
      print(_items);
      // ທຳການລຽງຂໍ້ມູນ ໃໝ່ສຸດຂື້ນກ່ອນໂດຍໃຊ້ reversed
      // we use "reversed" to sort items in order from the latest to the oldest
    });
  }

  // ເພີ່ມຂໍ້ມູນເຂົ້າໄປໃໝ່
  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _contactBox.add(newItem);
    _refreshItems(); // ອັບເດດລາຍການ
  }

  // Retrieve a single item from the database by using its key
  // Our app won't use this function but I put it here for your reference
  // ອ່ານຂໍ້ມູນ 1 ລາຍການ
  Map<String, dynamic> _readItem(int key) {
    final item = _contactBox.get(key);
    return item;
  }

  // ອັບເດດຂໍ້ມູນ
  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _contactBox.put(itemKey, item);
    _refreshItems(); // ອັບເດດລາຍການ
  }

  // ລຶບຂໍ້ມູນ
  Future<void> _deleteItem(int itemKey) async {
    await _contactBox.delete(itemKey);
    _refreshItems(); // ອັບເດດລາຍການໃໝ່

    // ສະແດງ snackbar ສະຖານະ
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('ຂໍ້ມູນໄດ້ຖຶກລຶບສຳເລັດ!')));
  }

  // ສ້າງ input Field controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _telController = TextEditingController();

  void _handleRadioValueChange(value) {
    print(value);
    setState(() {
      _genderController.text = value;
    });
  }

  void _showForm(BuildContext ctx, int? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item

    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      _nameController.text = existingItem['name'];
      _lastnameController.text = existingItem['lastname'];
      _genderController.text = existingItem['gender'];
      _addressController.text = existingItem['address'];
      _telController.text = existingItem['tel'];
    } else {
      // ເຄຼຍຂໍ້ມູນອອກ
      _nameController.text = '';
      _lastnameController.text = '';
      _genderController.text = '';
      _addressController.text = '';
      _telController.text = '';
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                  top: 15,
                  left: 15,
                  right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'ຊື່'),
                  ),
                  TextField(
                    controller: _lastnameController,
                    decoration: const InputDecoration(hintText: 'ນາມສະກຸນ'),
                  ),
                  // TextField(
                  //   controller: _genderController,
                  //   decoration: const InputDecoration(hintText: 'ເພດ'),
                  // ),
                  Row(
                    children: [
                      Text('ເພດ:'),
                      Radio(
                          value: 'male',
                          groupValue: _genderController.text,
                          onChanged: (value) {
                            setState(() {
                              _genderController.text = value!;
                            });
                          }),
                      Text('ຊາຍ'),
                      Radio(
                          value: 'female',
                          groupValue: _genderController.text,
                          onChanged: (value) {
                            setState(() {
                              _genderController.text = value!;
                            });
                          }),
                      Text('ຍິງ'),
                    ],
                  ),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(hintText: 'ທີ່ຢູ່'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _telController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'ເບີໂທ'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // ບັນທຶກຂໍ້ມູນ ເພີ່ມໃໝ່
                      if (itemKey == null) {
                        _createItem({
                          "name": _nameController.text,
                          "lastname": _lastnameController.text,
                          "gender": _genderController.text,
                          "address": _addressController.text,
                          "tel": _telController.text
                        });
                      }

                      // ອັບເດດຂໍ້ມູນ
                      if (itemKey != null) {
                        _updateItem(itemKey, {
                          'name': _nameController.text.trim(),
                          'lastname': _lastnameController.text.trim(),
                          'gender': _genderController.text.trim(),
                          'address': _addressController.text.trim(),
                          'tel': _telController.text.trim()
                        });
                      }

                      // ເຄຼຍຂໍ້ມູນອອກ
                      _nameController.text = '';
                      _lastnameController.text = '';
                      _genderController.text = '';
                      _addressController.text = '';
                      _telController.text = '';

                      Navigator.of(context).pop(); // ປິດ bottom sheet
                    },
                    child: Text(itemKey == null ? 'ສ້າງໃໝ່' : 'ອັບເດດ'),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // ເຮັດໃຫ້ ຄີບອດຕິດຟອມ
      appBar: AppBar(
        title: Text('ແອ໊ບ ບັນທຶກຂໍ້ມູນຕິດຕໍ່'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: _items.isEmpty
            ? const Center(
                child: Text(
                  'ບໍ່ມີຂໍ້ມູນ',
                  style: TextStyle(fontSize: 30),
                ),
              )
            : ListView.builder(
                // the list of items
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final currentItem = _items[index];
                  return Card(
                      color: Color.fromARGB(255, 255, 255, 255),
                      margin: const EdgeInsets.all(10),
                      elevation: 3,
                      child: InkWell(
                        onTap: () {
                          print(currentItem['key']);
                          // ສົ່ງຂໍ້ມູນຂ້າມໝ້າ
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    InfoPage(contactID: currentItem['key'])),
                          );
                        },
                        child: ListTile(
                            title: Row(
                              children: [
                                currentItem['gender'] == 'male'
                                    ? Text('ທ່ານ ')
                                    : Text('ທ່ານ ນ '),
                                Text(currentItem['name'] +
                                    ' ' +
                                    currentItem['lastname'])
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ທີ່ຢູ່: ' + currentItem['address']),
                                Text('ເບີໂທ: ' + currentItem['tel'].toString()),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Edit button
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _showForm(context, currentItem['key']),
                                ),
                                // Delete button
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _deleteItem(currentItem['key']),
                                ),
                              ],
                            )),
                      ));
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget ListContact() => Container(
        decoration: BoxDecoration(),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/male.jpeg'),
          ),
          title: Text('App data2'),
          subtitle: Text('Tel:111'),
          trailing: Column(
            children: [
              Text('data'),
            ],
          ),
        ),
      );
}
