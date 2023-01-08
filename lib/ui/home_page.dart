import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:contacts/controller/contact_controller.dart';
import 'package:contacts/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:contacts/ui/contact_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactController contactController = ContactController();

  List<Contact> contacts = List();

  @override
  void initState() {
    print("INIT");

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contatos",
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _listItemBuilder(context, index);
          }),
    );
  }

  Widget _listItemBuilder(context, index) {
    return GestureDetector(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: contacts[index].img != null
                              ? FileImage(File(contacts[index].img))
                              : AssetImage("images/user_default.png"),
                          fit: BoxFit.cover)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(contacts[index].name ?? "",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold)),
                      Text(contacts[index].email ?? "",
                          style: TextStyle(
                            fontSize: 18.0,
                          )),
                      Text(contacts[index].phone ?? "",
                          style: TextStyle(
                            fontSize: 18.0,
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          _showOptions(context, index);
        });
  }

  void _showContactPage({Contact contact}) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPsge(contact: contact)));

    print("Semua kontak");
    setState(() {
      _getAllContacts();
    });
  }

  void _getAllContacts() {
    contactController.getAllContacts().then((data) {
      // print(data);
      setState(() {
        contacts = data;
      });
    });
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Telepon",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          launch("tel:${contacts[index].phone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Hapus",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          contactController.deleteContact(contacts[index].id);
                          setState(() {
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
