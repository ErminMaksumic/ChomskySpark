import 'package:flutter/material.dart';
import 'package:chomskyspark/models/word_for_image.dart';
import 'package:chomskyspark/providers/word_for_image_provider.dart';
import 'package:chomskyspark/utils/auth_helper.dart';

class WordForImagePage extends StatefulWidget {
  @override
  _WordForImagePageState createState() => _WordForImagePageState();
}

class _WordForImagePageState extends State<WordForImagePage> {
  final WordForImageProvider _wordForImageProvider = WordForImageProvider();
  List<WordForImage> words = [];
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

      var params = {
        "userId": Authorization.selectedChildId!
      };

      final data = await _wordForImageProvider.get(params);
      setState(() {
        words = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addOrUpdateWord([WordForImage? word]) {
    TextEditingController _controller = TextEditingController(text: word?.name ?? '');
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(word == null ? 'Add New Word' : 'Update Word'),
            content: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: "Enter word name"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(word == null ? 'Add' : 'Update'),
                onPressed: () async {
                  if (word == null) {
                    await _wordForImageProvider.insert(WordForImage(id: 0, name: _controller.text, userId: Authorization.selectedChildId!));
                    await _fetchData();
                  } else {
                    word.name = _controller.text;
                    await _wordForImageProvider.update(word.id, word);
                    await _fetchData();
                  }
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  void _confirmDelete(int id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Are you sure you want to delete this word?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () async {
                  await _wordForImageProvider.delete(id);
                  Navigator.of(context).pop();
                  await _fetchData();
                },
              ),
            ],
          );
        }
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
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white), // Icon color
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Words for AI Image',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
                      ),
                    ),
                    const SizedBox(width: 48), // For symmetry
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                      : words.isEmpty ? const Center(
                  child: Text('No data available.',
                      style: TextStyle(
                          color: Colors.white, fontSize: 18)),
                )
                    : ListView.builder(
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    WordForImage word = words[index];
                    return ListTile(
                      title: Text(word.name, style: TextStyle(color: Colors.white),),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.white,
                            onPressed: () => _addOrUpdateWord(word),
                          ),
                          IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.delete),
                            onPressed: () => _confirmDelete(word.id),
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
        onPressed: () => _addOrUpdateWord(),
        tooltip: 'Add Word',
        child: Icon(Icons.add),
      ),
    );
  }

}