import 'package:cloud_firestore/cloud_firestore.dart';

class GulItem {
  // 기존의 필드들
  final String label_id;
  final String image_url;
  final String description;
  final String location;

  // MappingTable에서 가져올 추가 필드
  String category;
  String subcategory;
  String type;
  String yolo_label;


  GulItem({
    required this.label_id,
    required this.image_url,
    required this.description,
    required this.location,

    required this.category,
    required this.subcategory,
    required this.type,
    required this.yolo_label
  });

  // Firestore 문서에서 PostItem 객체를 생성하는 팩토리 생성자
  factory GulItem.fromDocument(DocumentSnapshot doc) {
    return GulItem(
      // 기존의 필드들
      label_id: doc['label_id'],
      image_url: doc['image_url'],
      description: doc['description'],
      location: doc['location'],
      category: doc['category'] ?? '',
      subcategory: doc['subcategory'] ?? '',
      type: doc['type'] ?? '',
      yolo_label: doc['yolo_label'] ?? '',

    );
  }
}
