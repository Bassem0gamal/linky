import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List _allUsers = [];
  List _searchFilter = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchFilterResult);
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchFilterResult);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getUsers();
    super.didChangeDependencies();
  }

  final _searchController = TextEditingController();
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: CupertinoSearchTextField(
          backgroundColor: Colors.white,
          controller: _searchController,
        ),
      ),
      body: ListView.builder(
        itemCount: _searchFilter.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              _searchFilter[index]["user_name"],
            ),
          );
        },
      ),
    );
  }

  getUsers() async {
    var data = await db.collection('users').orderBy('user_name').get();

    setState(() {
      _allUsers = data.docs;
    });
    _searchFilterResult();
  }

  _searchFilterResult() {
    List result = [];
    if(_searchController.text != "") {
      for(var snapshot in _allUsers) {
        var name = snapshot['user_name'].toString().toLowerCase();

        if(name.contains(_searchController.text.toLowerCase())) {
          result.add(snapshot);
        }
      }
    } else {
      result = List.from(_allUsers);
    }
    setState(() {
      _searchFilter = result;
    });
  }
}
