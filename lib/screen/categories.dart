// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:to_do/components/drawer_menu.dart';
import 'package:to_do/models/category.dart';
import 'package:to_do/service/categories_service.dart';

class Categories extends StatefulWidget {
  const Categories({Key key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();

  List<Category> _categoryList = List<Category>();
  @override
  initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(230, 253, 252, 252),
            title: const Text(
              'New Category',
              style: TextStyle(
                color: Color.fromARGB(246, 81, 199, 128),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(3),
                    elevation: 3,
                    child: TextField(
                      controller: _categoryNameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Category',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(3),
                    elevation: 3,
                    child: TextField(
                      controller: _categoryDescriptionController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Description',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color.fromARGB(246, 110, 110, 110),
                    fontSize: 16,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  _category.name = _categoryNameController.text;
                  _category.description = _categoryDescriptionController.text;
                  var result = await _categoryService.saveCategory(_category);
                  print(result);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Color.fromARGB(246, 81, 199, 128),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(230, 253, 252, 252),
      drawer: DrawerMenu(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Color.fromARGB(213, 81, 199, 128),
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'CATEGORIES',
          style: TextStyle(color: Color.fromARGB(246, 81, 199, 128)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ListView.builder(
          itemCount: _categoryList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: Card(
                elevation: 6.0,
                child: ListTile(
                  leading: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Color.fromARGB(246, 81, 199, 128),
                    ),
                    onPressed: () {},
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _categoryList[index].name,
                        style: TextStyle(fontSize: 20.0),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Color.fromARGB(230, 66, 148, 99),
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
                  subtitle: Text(_categoryList[index].description),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(246, 81, 199, 128),
        child: const Icon(Icons.add),
        onPressed: () {
          _showFormDialog(context);
        },
      ),
    );
  }
}
