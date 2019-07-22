class Note {
    int id;
    String title;
    String content;
    String date;
    int isImportant;

    Note({
        this.id,
        this.title,
        this.content,
        this.date,
        this.isImportant
    });

    factory Note.fromMap(Map<String, dynamic> data) => new Note(
        id: data["id"],
        title: data["title"],
        content: data["content"],
        date: data["date"],
        isImportant: data["isImportant"]
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "content": content,
        "date": date,
        "isImportant": isImportant
    };
}