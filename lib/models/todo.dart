class Todo {
  late String body;
  late bool done  ;

  late String user_id;

  Todo(this.body, this.user_id , this.done);
  Todo.fromJson(Map<String, dynamic> jsonObject) {
    this.body = jsonObject['body'];
    this.user_id = jsonObject['user_id'];
    this.done = jsonObject['done'] ;

  }
  Map<String, dynamic> toMap() {
    return {
      'body': this.body,
      'user_id': this.user_id,
    };
  }



}
