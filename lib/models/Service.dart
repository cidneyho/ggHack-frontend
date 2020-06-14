class Service {
  String name;
  String address;
  String contact;
  String photo;
  String url;

  Service ({
    this.name,
    this.address,
    this.contact,
    this.photo,
    this.url
  });

  factory Service.fromJson(Map<String, dynamic> json){
    return new Service (
        name: json['name'],
        address: json['address'],
        contact: json ['contact'],
        photo: json['photo'],
        url: json['url']
    );
  }
}