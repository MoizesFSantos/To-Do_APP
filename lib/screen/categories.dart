// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:to_do/components/colors.dart';
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

  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();

  List<Category> _categoryList = List<Category>();

  var category;

  @override
  initState() {
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

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

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name'] ?? 'No Name';
      _editCategoryDescriptionController.text =
          category[0]['description'] ?? 'No Description';
    });
    _editFormDialog(context);
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
                  Navigator.pop(context);
                  print(result);
                  getAllCategories();
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

  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(230, 253, 252, 252),
            title: const Text(
              'Edit Category',
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
                      controller: _editCategoryNameController,
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
                      controller: _editCategoryDescriptionController,
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
                  _category.id = category[0]['id'];
                  _category.name = _editCategoryNameController.text;
                  _category.description =
                      _editCategoryDescriptionController.text;
                  var result = await _categoryService.updateCategory(_category);
                  if (result > 0) {
                    print(result);
                    Navigator.pop(context);
                    getAllCategories();
                    _showSuccessSnackBar(Text('Updated'));
                  }
                },
                child: const Text(
                  'Update',
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

  _deleteFormDialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(230, 253, 252, 252),
            title: const Text(
              'Are you sure you want to delete this?',
              style: TextStyle(
                color: Color.fromARGB(246, 81, 199, 128),
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
                  var result =
                      await _categoryService.deleteCategory(categoryId);
                  if (result > 0) {
                    print(result);
                    Navigator.pop(context);
                    getAllCategories();
                    _showSuccessSnackBar(Text('Deleted'));
                  }
                },
                child: const Text(
                  'Delete',
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

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: bgColor,
      drawer: DrawerMenu(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: pColor,
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
          style: TextStyle(color: pColor),
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
                      color: pColor,
                    ),
                    onPressed: () {
                      _editCategory(context, _categoryList[index].id);
                    },
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
                          color: sColor,
                        ),
                        onPressed: () {
                          _deleteFormDialog(context, _categoryList[index].id);
                        },
                      )
                    ],
                  ),
                  subtitle: Text(_categoryList[index].description),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: pColor,
        child: const Icon(Icons.add),
        onPressed: () {
          _showFormDialog(context);
        },
      ),
    );
  }
}
