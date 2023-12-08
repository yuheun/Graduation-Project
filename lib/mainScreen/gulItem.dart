
// 파베에서 글작성 변수값 받아올 때 쓸라고 그냥 클래스 선언한거!!

class GulItem {
  final String subcategory; // ex.휴대폰 (종류)
  final String category; // ex. 전자기기 (대분류)
  final String type; // ex. 흰색 (특징)
  final String image_url; // 사진

  GulItem({
    required this.subcategory,
    required this.category,
    required this.type,
    required this.image_url,
  });
}
