

class PostRepo{
  List _postList = [
    ['테스트1', '내용입니다.', '백동호', '2021-07-02', 120, 'https://picsum.photos/300/300'],
    ['테스트2', '내용입니다.', '나르', '2021-07-02', 103, 'https://picsum.photos/300/300'],
    ['테스트3', '내용입니다.', '럭스', '2021-07-02', 60, 'https://picsum.photos/300/300'],
    ['테스트4', '내용입니다.', '가렌', '2021-07-02', 74, 'https://picsum.photos/300/300'],
    ['테스트5', '내용입니다.', '오징어', '2021-07-02', 108, 'https://picsum.photos/300/300'],
  ];

  List _recommendPostList = [
    ['테스트1', '내용입니다.', '백동호', '2021-07-02', 120, 'https://picsum.photos/3000/3000'],
    ['테스트2', '내용입니다.', '나르', '2021-07-02', 103, 'https://picsum.photos/3000/3000'],
    ['테스트3', '내용입니다.', '럭스', '2021-07-02', 60, 'https://picsum.photos/3000/3000'],
    ['테스트4', '내용입니다.', '가렌', '2021-07-02', 74, 'https://picsum.photos/3000/3000'],
    ['테스트5', '내용입니다.', '오징어', '2021-07-02', 108, 'https://picsum.photos/3000/3000'],
  ];

  List get postList => _postList;
  List get recommendPostList => _recommendPostList;
}