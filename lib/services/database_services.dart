import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tm_todoapp/model/todo.dart';

class DatabaseService {
  CollectionReference todosCollections =
      FirebaseFirestore.instance.collection('Todos');

  Future createNewTodo(String title) async {
    return await todosCollections.add({
      'title': title,
      'isComplet': false,
    });
  }

  Future completTask(uid) async {
    await todosCollections.doc(uid).update({'isComplet': true});
  }

  Future removeTodo(uid) async {
    await todosCollections.doc(uid).delete();
  }

  List<Todo> todoFromFirestore(QuerySnapshot snapshot) {
    if (snapshot != null) {
      return snapshot.docs.map((e) {
        return Todo(
          isComplet: (e.data() as Map<String, dynamic>)['isComplet'],
          title: (e.data() as Map<String, dynamic>)['title'],
          uid: e.id,
        );
      }).toList();
    } else {
      return null;
    }
  }

  Stream<List<Todo>> listTodos() {
    return todosCollections.snapshots().map(todoFromFirestore);
  }
}
