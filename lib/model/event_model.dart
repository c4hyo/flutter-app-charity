class EventModel {
  int id;
  String title;
  String thumbnail;
  String dateEvent;
  String place;
  String description;
  String createdAt;
  String updatedAt;

  EventModel(
      {this.id,
      this.title,
      this.thumbnail,
      this.dateEvent,
      this.place,
      this.description,
      this.createdAt,
      this.updatedAt});

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    thumbnail = json['thumbnail'];
    dateEvent = json['date_event'];
    place = json['place'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['thumbnail'] = this.thumbnail;
    data['date_event'] = this.dateEvent;
    data['place'] = this.place;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
