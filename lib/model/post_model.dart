class PostModel {
  int id;
  String userId;
  String title;
  String thumbnail;
  String description;
  String createdAt;
  String updatedAt;

  PostModel(
      {this.id,
      this.userId,
      this.title,
      this.thumbnail,
      this.description,
      this.createdAt,
      this.updatedAt});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    thumbnail = json['thumbnail'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['thumbnail'] = this.thumbnail;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
