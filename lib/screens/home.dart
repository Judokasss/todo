import 'package:flutter/material.dart';
import 'package:todo/constans/colors.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/widgets/todo_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDarkMode = false;

  final todoList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoConrtoller = TextEditingController();

  @override
  void initState() {
    _foundToDo = todoList;
    _loadTheme();
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Color.fromARGB(255, 32, 32, 32) : tdBGColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor:
            isDarkMode ? Color.fromARGB(255, 32, 32, 32) : tdBGColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.menu,
              color: isDarkMode ? Colors.white : tdBlack,
              size: 30,
            ),
            IconButton(
              icon: Image.asset(
                isDarkMode
                    ? 'assets/image/whitedrago.png'
                    : 'assets/image/drago.png',
                height: 40,
                width: 40,
              ),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                  _saveTheme();
                });
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            // отступ по бокам контейнера
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                // текстовое поле внутренности
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50, bottom: 20),
                        child: Text(
                          'Список дел',
                          // можно убрать(отрентровка по середине)
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'RubikBubbles',
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      if (_foundToDo.isEmpty)
                        Center(
                          child: Text(
                            'В данный момент нет задач',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        )
                      else
                        for (ToDo todoo in _foundToDo.reversed)
                          ToDoItem(
                            todo: todoo,
                            onToDoChacged: _handleToDoChange,
                            onDeleteItem: _deleteToDoItem,
                            showEditModal: _showEditModal,
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Создание нижнего поля ввода добавение записи
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _todoConrtoller,
                      decoration: InputDecoration(
                        hintText: 'Добавить новую задачу',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    child: Text(
                      '+',
                      style: TextStyle(
                          fontSize: 30, color: Color.fromARGB(247, 0, 0, 0)),
                    ),
                    onPressed: () {
                      _addToDoItem(_todoConrtoller.text);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 222, 222, 222),
                        minimumSize: Size(60, 60),
                        elevation: 2,
                        shadowColor: Color.fromARGB(0, 255, 193, 7)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditModal(BuildContext context, ToDo todo) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EditTodoScreen(todo: todo);
      },
    );
  }

// Удаление записи
  void _deleteToDoItem(String id) {
    setState(() {
      todoList.removeWhere((item) => item.id == id);
    });
    _saveData();
  }

// Добавление записи
  void _addToDoItem(String toDo) {
    setState(() {
      todoList.add(ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: toDo));
    });
    _todoConrtoller.clear();
    _saveData();
  }

// Выполнение задачи
  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
    _saveData();
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    // если ввод пустоты то никаких результатов не будет
    if (enteredKeyword.isEmpty) {
      results = todoList;
    } else {
      //поиск
      results = todoList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Поиск',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  // Сохранение данных
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todoListData =
        todoList.map((todo) => json.encode(todo.toMap())).toList();
    prefs.setStringList('todoList', todoListData);
  }

// Загрузка данных
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? todoListData = prefs.getStringList('todoList');

    if (todoListData != null) {
      setState(() {
        todoList.clear();
        todoList.addAll(
            todoListData.map((data) => ToDo.fromMap(json.decode(data))));
      });
    }
  }

  // Сохранение темы
  Future<void> _saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  // Загрузка темы
  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedTheme = prefs.getBool('isDarkMode');
    if (savedTheme != null) {
      setState(() {
        isDarkMode = savedTheme;
      });
    }
  }
}
