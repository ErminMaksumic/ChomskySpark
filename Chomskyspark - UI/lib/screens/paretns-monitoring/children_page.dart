import 'package:chomskyspark/models/user_upsert_request.dart';
import 'package:flutter/material.dart';
import 'package:chomskyspark/models/user.dart';
import 'package:chomskyspark/models/language.dart';
import 'package:chomskyspark/providers/user_provider.dart';
import 'package:chomskyspark/providers/language_provider.dart';
import 'package:chomskyspark/utils/auth_helper.dart';

class ChildrenPage extends StatefulWidget {
  @override
  _ChildrenPageState createState() => _ChildrenPageState();
}

class _ChildrenPageState extends State<ChildrenPage> {
  final UserProvider _userProvider = UserProvider();
  final LanguageProvider _languageProvider = LanguageProvider();
  List<User> children = [];
  List<Language> languages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final childrenData = await _userProvider.getChildren(Authorization.user!.id!);
      final languagesData = await _languageProvider.get();
      setState(() {
        children = childrenData;
        languages = languagesData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addOrUpdateChild([User? child]) {
    TextEditingController _firstNameController = TextEditingController(text: child?.firstName ?? '');
    TextEditingController _lastNameController = TextEditingController(text: child?.lastName ?? '');

    Language? _primaryLanguage;
    Language? _foreignLanguage;

    if (child != null) {
      _primaryLanguage = languages.firstWhere(
            (lang) => child.userLanguages!.any(
                (ul) => ul.languageId == lang.id && ul.type == 'Primary'
        ),
      );
      _foreignLanguage = languages.firstWhere(
            (lang) => child.userLanguages!.any(
                (ul) => ul.languageId == lang.id && ul.type == 'Secondary'
        ),
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(child == null ? 'Add New Child' : 'Update Child'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _firstNameController,
                      decoration: InputDecoration(hintText: "First Name"),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _lastNameController,
                      decoration: InputDecoration(hintText: "Last Name"),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<Language>(
                      value: _primaryLanguage,
                      hint: Text('Select Primary Language'),
                      items: languages.map((Language language) {
                        return DropdownMenuItem<Language>(
                          value: language,
                          child: Text(language.name ?? ''),
                        );
                      }).toList(),
                      onChanged: (Language? newValue) {
                        setState(() {
                          _primaryLanguage = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<Language>(
                      value: _foreignLanguage,
                      hint: Text('Select Foreign Language'),
                      items: languages.map((Language language) {
                        return DropdownMenuItem<Language>(
                          value: language,
                          child: Text(language.name ?? ''),
                        );
                      }).toList(),
                      onChanged: (Language? newValue) {
                        setState(() {
                          _foreignLanguage = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(child == null ? 'Add' : 'Update'),
                  onPressed: () async {
                    if (_firstNameController.text.isEmpty ||
                        _lastNameController.text.isEmpty ||
                        _primaryLanguage == null ||
                        _foreignLanguage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all fields'))
                      );
                      return;
                    }

                    final newChild = UserUpsertRequest(
                        id: 0,
                        firstname: _firstNameController.text,
                        lastname: _lastNameController.text,
                        email: Authorization.user!.email!,
                        primaryLanguageId: _primaryLanguage!.id!,
                        secondaryLanguageId: _foreignLanguage!.id!,
                        parentUserId: Authorization.user!.id!
                    );

                    if (child == null) {
                      await _userProvider.insert(newChild);
                    }
                    else {
                      newChild.id = child.id!;
                      await _userProvider.update(child.id!, newChild);
                    }
                    await _fetchData();

                    if (Authorization.selectedChildId == null){
                      Authorization.selectedChildId = children.first.id;
                    }
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this child?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                await _userProvider.delete(id);
                Navigator.of(context).pop();
                await _fetchData();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF6A0DAD), // Page background color
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (Authorization.selectedChildId != null)
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'My Children',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 48), // For symmetry
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : children.isEmpty
                    ? Center(
                        child: Text(
                          'No children added yet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : ListView.builder(
                  itemCount: children.length,
                  itemBuilder: (context, index) {
                    User child = children[index];
                    print(child);
                    final primaryLang = child.userLanguages!.firstWhere(
                            (ul) => ul.type == 'Primary').language?.name;
                    final foreignLang = child.userLanguages!.firstWhere(
                            (ul) => ul.type == 'Secondary').language?.name;

                    return ListTile(
                      title: Text(
                        '${child.firstName} ${child.lastName}',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Primary: $primaryLang | Foreign: $foreignLang',
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.white,
                            onPressed: () => _addOrUpdateChild(child),
                          ),
                          IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.delete),
                            onPressed: () => _confirmDelete(child.id!),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrUpdateChild(),
        tooltip: 'Add Child',
        child: Icon(Icons.add),
      ),
    );
  }
}