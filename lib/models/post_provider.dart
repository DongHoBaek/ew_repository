import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ttt_project_003/constant/firestore_keys.dart';
import 'package:ttt_project_003/models/gallery_state.dart';
import 'package:ttt_project_003/models/user_provider.dart';

class PostProvider with ChangeNotifier {
  String _currentDocId;
  String _rootPostDocID;
  bool _displayAllPost = true;
  static Map<String, dynamic> _currentPostMap;
  static List<Map<String, dynamic>> _homePosts = [];
  static List<Map<String, dynamic>> _childPosts = [];
  static List<Map<String, dynamic>> _myPosts = [];
  static List<Map<String, dynamic>> _otherUserPosts = [];

  String get currentDocId => _currentDocId;

  bool get displayAllPost => _displayAllPost;

  Map<String, dynamic> get currentPostMap => _currentPostMap;

  List<Map<String, dynamic>> get homePosts => _homePosts;

  List<Map<String, dynamic>> get childPostList => _childPosts;

  List<Map<String, dynamic>> get myPosts => _myPosts;

  List<Map<String, dynamic>> get otherUserPosts => _otherUserPosts;

  CollectionReference posts =
      FirebaseFirestore.instance.collection(COLLECTION_POSTS);

  void changeDisplay() {
    _displayAllPost = !_displayAllPost;
    getHomePosts();
    if (_displayAllPost == true) {
      print('you can see all Post now');
    } else {
      print('you can see root Post now');
    }
  }

  void setCurrentDocId(String dId) {
    _currentDocId = dId;
    print("set document id to $_currentDocId");
  }

  void removeDocId() {
    _currentDocId = null;
    _rootPostDocID = null;
    print("set currentDocument id to $_currentDocId");
    print("set rootDocument id to $_rootPostDocID");
  }

  Future<void> createPost(String title, String content, var postTime) async {
    UserProvider _userProvider = UserProvider();
    String imgUrl = await GalleryState().uploadAndDownloadPostImg(postTime);
    String documentId = '${postTime}_${_userProvider.userDataMap[KEY_USERUID]}';

    DocumentReference ref = posts.doc(documentId);

    String rootPostDID = ref.id;
    String parentPostDID = _currentDocId;

    ref
        .set({
          KEY_AUTHORUNM: _userProvider.userDataMap[KEY_USERNAME],
          KEY_AUTHORUID: _userProvider.userDataMap[KEY_USERUID],
          KEY_TITLE: title,
          KEY_CONTENT: content,
          KEY_COMMENTS: [],
          KEY_POSTIMG: imgUrl,
          KEY_ROOTPOSTDID: rootPostDID,
          KEY_PARENTPOSTDID: parentPostDID,
          KEY_NUMOFLIKES: 0,
          KEY_NUMOFCOMMENTS: 0,
          KEY_POSTTIME: postTime
        })
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add post: $error"));
    _userProvider.addUserPost(documentId);
    getHomePosts();
    getMyPostList();
  }

  Future getPostData(String dId) async {
    setCurrentDocId(dId);

    await posts.doc(dId).get().then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      if (documentSnapshot.exists) {
        _currentPostMap = data;
        print('get data!');
        print(_currentPostMap);
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  Future<void> updatePost(String title, String content) async {
    String imgUrl = await GalleryState().updatePostImg(_currentDocId);

    posts
        .doc(_currentDocId)
        .update({KEY_CONTENT: content, KEY_TITLE: title, KEY_POSTIMG: imgUrl})
        .then((value) => print("Post Updated"))
        .catchError((error) => print("Failed to update post: $error"));

    getHomePosts();
    getMyPostList();
  }

  void deletePost() {
    posts
        .doc(_currentDocId)
        .delete()
        .then((value) => print("Post Deleted"))
        .catchError((error) => print("Failed to delete post: $error"));
    GalleryState().deletePostImg(_currentDocId);

    getHomePosts();
    getMyPostList();
  }

  // void anonymizationPost() {
  //   posts
  //       .doc(_currentDocId)
  //       .update({'unm': '익명'})
  //       .then((value) => print("Post Anonymized"))
  //       .catchError((error) => print("Failed to Anonymize post: $error"));
  // }

  Future getOtherUserPosts() async {
    List otherUserDids = UserProvider().otherUserDataMap[KEY_MYPOSTS];

    List<Map<String, dynamic>> tmpList = [];

    if (otherUserDids != null) {
      for (var i in otherUserDids) {
        await posts.doc(i).get().then((DocumentSnapshot documentSnapshot) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          tmpList.add(data);
        });
      }

      print('succeed to get other user posts');
    } else {
      print('user don\'t have any post');
    }

    _otherUserPosts = tmpList;
  }

  Future getMyPostList() async {
    List myDids = UserProvider().userDataMap[KEY_MYPOSTS];

    List<Map<String, dynamic>> tmpList = [];

    if (myDids != null) {
      for (var i in myDids) {
        await posts.doc(i).get().then((DocumentSnapshot documentSnapshot) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          tmpList.add(data);
        });
      }

      print('succeed to get your posts');
    } else {
      print('you don\'t have any post');
    }

    _myPosts = tmpList;
  }

  Future getHomePosts() async {
    if (_displayAllPost == true) {
      var snapshot = await posts.get();
      _homePosts = _getPostList(snapshot);
      print('succeed to get all posts');
    } else {
      var snapshot = await posts.where(KEY_PARENTPOSTDID, isNull: true).get();
      _homePosts = _getPostList(snapshot);
      print('succeed to get root posts');
    }

    notifyListeners();
  }

  Future getChildPosts() async {
    var snapshot =
        await posts.where(KEY_PARENTPOSTDID, isEqualTo: _currentDocId).get();
    _childPosts = _getPostList(snapshot);

    print('succeed to get child posts');

    notifyListeners();
  }

  //2차원 데이터 _postList (id, title, content) 반환
  List<Map<String, dynamic>> _getPostList(snapshot) {
    List<Map<String, dynamic>> tmpList = [];

    if (snapshot != null) {
      List<QueryDocumentSnapshot> docs = snapshot.docs.toList();

      for (var i in docs) {
        Map<String, dynamic> data = i.data() as Map<String, dynamic>;

        data[KEY_POSTDID] = i.id.toString();

        tmpList.add(data);
      }

      return tmpList;
    }

    return null;
  }

  void liked() {
    posts
        .doc(_currentDocId)
        .update({KEY_NUMOFLIKES: _currentPostMap[KEY_NUMOFLIKES] + 1})
        .then((value) => print("post is liked"))
        .catchError((error) => print("Failed to like: $error"));

    _currentPostMap.update(KEY_NUMOFLIKES, (value) => value + 1);

    notifyListeners();
  }

  void unliked() {
    posts
        .doc(_currentDocId)
        .update({KEY_NUMOFLIKES: _currentPostMap[KEY_NUMOFLIKES] - 1})
        .then((value) => print("post is liked"))
        .catchError((error) => print("Failed to like: $error"));

    _currentPostMap.update(KEY_NUMOFLIKES, (value) => value - 1);

    notifyListeners();
  }
}
