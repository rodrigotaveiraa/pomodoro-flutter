import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
class FirebaseService {
  final CollectionReference tasksCollection =
  FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Task task) {
    return tasksCollection.add({
      'name': task.name,
      'description': task.description,
      'duration': task.duration,
      'priority': task.priority,
    });
  }

  Stream<List<Task>> getTasksStream() {
    return tasksCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task(
          name: doc['name'],
          description: doc['description'],
          duration: doc['duration'],
          priority: doc['priority'],
        );
      }).toList();
    });
  }
}
