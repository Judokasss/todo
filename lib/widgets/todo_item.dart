import 'package:flutter/material.dart';
import 'package:todo/constans/colors.dart';
import 'package:todo/model/todo.dart';

class ToDoItem extends StatelessWidget {
  const ToDoItem(
      {Key? key,
      required this.todo,
      required this.onToDoChacged,
      required this.onDeleteItem,
      required this.showEditModal}) //делаем обязательынми к исполнению
      : super(key: key);

  final ToDo todo;
  final onToDoChacged;
  final onDeleteItem;
  final Function(BuildContext, ToDo)
      showEditModal; // Объявим функцию для отображения модального окна

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          onToDoChacged(todo);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          // Если сделано задание то значок меняется на check_box выполненный иначе на check_box_outline_blank
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: tdBlue,
        ),
        title: Text(
          todo.todoText!,
          style: TextStyle(
            fontSize: 16,
            color: tdBlack,
            // Строка зачеркнута если выполнено задание
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: tdBlue,
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                color: Colors.white,
                iconSize: 18,
                // Иконка для редактирования (карандаш)
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Обработка нажатия кнопки редактирования
                  // Вызов метода или навигация на экран редактирования
                  showEditModal(context, todo);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.symmetric(vertical: 12),
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: tdRed,
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                color: Colors.white,
                iconSize: 18,
                icon: Icon(Icons.delete),
                onPressed: () {
                  onDeleteItem(todo.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTodoScreen extends StatefulWidget {
  final ToDo todo;

  const EditTodoScreen({Key? key, required this.todo}) : super(key: key);

  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.todo.todoText);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(labelText: 'Редактировать задачу'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Сохранение изменений и закрытие модального окна
                widget.todo.todoText = _textEditingController.text;
                Navigator.of(context)
                    .pop(widget.todo); // Передача обновленной задачи
              },
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
