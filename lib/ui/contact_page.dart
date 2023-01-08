import 'dart:io';

import 'package:contacts/controller/contact_controller.dart';
import 'package:contacts/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class ContactPsge extends StatefulWidget {
  Contact contact;

  ContactPsge({this.contact});

  @override
  _ContactPsgeState createState() => _ContactPsgeState();
}

class _ContactPsgeState extends State<ContactPsge> {
  Contact _editedContact;
  ContactController contact_controller = ContactController();
  bool _userEdited = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.contact);
    if (widget.contact == null) {
      _editedContact = Contact();
      _userEdited = false;
    } else {
      
      _editedContact = widget.contact;
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(_editedContact.name ?? "Kontak baru"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveChanges();
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 160.0,
                height: 160.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedContact.img != null
                            ? FileImage(File(_editedContact.img))

                            : AssetImage("images/user_default.png"),
                        fit: BoxFit.cover)),
              ),
              onTap: () async {
                 var image = await ImagePicker.pickImage(source: ImageSource.camera);

                  if(image != null){
                    setState(() {
                      _editedContact.img = image.path;
                    });

                  }
              },
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nama"),
              onChanged: (text) {
                _userEdited = true;

                setState(() {
                  _editedContact.name = text;
                });
              },
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
              onChanged: (text) {
                _userEdited = true;

                setState(() {
                  _editedContact.email = text;
                });
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Telepon"),
              onChanged: (text) {
                _userEdited = true;

                setState(() {
                  _editedContact.phone = text;
                });
              },
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() async {
    if (_editedContact.id != null) {
      await contact_controller.updateContact(_editedContact);
    } else {
      await contact_controller.saveContact(_editedContact);
    }

    Navigator.pop(context);
  }
}
