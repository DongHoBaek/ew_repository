import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ttt_project_003/constant/firestore_keys.dart';
import 'package:ttt_project_003/models/gallery_state.dart';
import 'package:ttt_project_003/models/user_provider.dart';

class PostProvider with ChangeNotifier {
  bool _displayAllPost = true;
  static List<String> _currentDocIdStack = [];
  static List<String> _rootDocIdStack = [];
  static Map<String, dynamic> _currentPostMap;
  static List<Map<String, dynamic>> _homePosts = [];
  static List<Map<String, dynamic>> _childPosts = [];
  static List<Map<String, dynamic>> _myPosts = [];
  static List<Map<String, dynamic>> _otherUserPosts = [];
  static List<Map<String, dynamic>> _bookmarkPosts = [];

  bool get displayAllPost => _displayAllPost;

  List<String> get currentDocIdStack => _currentDocIdStack;

  List<String> get rootDocIdStack => _rootDocIdStack;

  Map<String, dynamic> get currentPostMap => _currentPostMap;

  List<Map<String, dynamic>> get homePosts => _homePosts;

  List<Map<String, dynamic>> get childPosts => _childPosts;

  List<Map<String, dynamic>> get myPosts => _myPosts;

  List<Map<String, dynamic>> get otherUserPosts => _otherUserPosts;

  List<Map<String, dynamic>> get bookmarkPosts => _bookmarkPosts;

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

  void removeLastDocId() {
    if (_rootDocIdStack.isNotEmpty && _currentDocIdStack.isNotEmpty) {
      _currentDocIdStack.removeLast();
      _rootDocIdStack.removeLast();
      getPostData(_currentDocIdStack.last);
    }

    if (_rootDocIdStack.isNotEmpty && _currentDocIdStack.isNotEmpty) {
      print(
          'remove last doc Id, current doc Id: ${_currentDocIdStack.last}, root Id: ${_rootDocIdStack.last}');
    } else {
      print('all DocIdStack are null');
    }
  }

  Future<void> createPost(String title, String content, var postTime) async {
    UserProvider _userProvider = UserProvider();
    String imgUrl = await GalleryState().uploadAndDownloadPostImg(postTime);
    String documentId = '${postTime}_${_userProvider.userDataMap[KEY_USERUID]}';

    DocumentReference ref = posts.doc(documentId);

    String rootPostDID =
        _rootDocIdStack.isEmpty ? ref.id : _rootDocIdStack.last;
    String parentPostDID =
        _currentDocIdStack.isEmpty ? null : _currentDocIdStack.last;

    if (_currentDocIdStack.isNotEmpty) {
      addChildPost(documentId);
    }

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
    getMyPosts();
  }

  Future getPostData(String did) async {
    await posts.doc(did).get().then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      if (documentSnapshot.exists) {
        data[KEY_POSTDID] = did;

        _currentPostMap = data;

        _currentDocIdStack.add(did);

        _rootDocIdStack.add(data[KEY_ROOTPOSTDID]);

        print('get current post data!');
        print(
            'currentDocIdStack: $_currentDocIdStack, rootDocIdStack: $_rootDocIdStack');
        print(
            'set last doc Id, current doc Id: ${_currentDocIdStack.last}, root Id: ${_rootDocIdStack.last}');
      } else {
        print('Document does not exist on the database');
      }
    });

    await getChildPosts();
  }

  Future<void> updatePost(String title, String content) async {
    String imgUrl = await GalleryState().updatePostImg(_currentDocIdStack.last);

    posts
        .doc(_currentDocIdStack.last)
        .update({KEY_CONTENT: content, KEY_TITLE: title, KEY_POSTIMG: imgUrl})
        .then((value) => print("Post Updated"))
        .catchError((error) => print("Failed to update post: $error"));

    _currentDocIdStack = [];
    _rootDocIdStack = [];
    getHomePosts();
    getMyPosts();
  }

  void deletePost() {
    UserProvider _userProvider = UserProvider();

    posts
        .doc(_currentDocIdStack.last)
        .delete()
        .then((value) => print("Post Deleted"))
        .catchError((error) => print("Failed to delete post: $error"));
    GalleryState().deletePostImg(_currentDocIdStack.last);
    _userProvider.removeUserPost(_currentDocIdStack.last);

    _currentDocIdStack = [];
    _rootDocIdStack = [];
    getHomePosts();
    getMyPosts();
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

          data[KEY_POSTDID] = i;

          tmpList.add(data);
        });
      }

      print('succeed to get other user posts');
    } else {
      print('user don\'t have any post');
    }

    _otherUserPosts = tmpList;

    notifyListeners();
  }

  Future getBookmarkPosts() async {
    List bookmarkDids = UserProvider().userDataMap[KEY_BOOKMARKEDPOSTS];

    List<Map<String, dynamic>> tmpList = [];

    if (bookmarkDids.isNotEmpty) {
      for (var i in bookmarkDids) {
        await posts.doc(i).get().then((DocumentSnapshot documentSnapshot) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;

          data[KEY_POSTDID] = i;

          tmpList.add(data);
        });
      }

      print('succeed to get your bookmarked posts');
    } else {
      print('user don\'t have any post');
    }

    _bookmarkPosts = tmpList;

    notifyListeners();
  }

  Future getMyPosts() async {
    List myDids = UserProvider().userDataMap[KEY_MYPOSTS];

    List<Map<String, dynamic>> tmpList = [];

    if (myDids != null) {
      for (var i in myDids) {
        await posts.doc(i).get().then((DocumentSnapshot documentSnapshot) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;

          data[KEY_POSTDID] = i;

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
    List childDids = _currentPostMap[KEY_COMMENTS];
    List<Map<String, dynamic>> tmpList = [];

    if (childDids != null) {
      for (var i in childDids) {
        await posts.doc(i).get().then((DocumentSnapshot documentSnapshot) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;

          data[KEY_POSTDID] = i;

          tmpList.add(data);
        });
      }

      print('succeed to get comment posts');
    } else {
      print('you don\'t have any post');
    }

    _childPosts = tmpList;
  }

  Future<void> addChildPost(did) async {
    _currentPostMap[KEY_COMMENTS].add(did);

    posts
        .doc(_currentDocIdStack.last)
        .update({KEY_COMMENTS: _currentPostMap[KEY_COMMENTS]})
        .then((value) => print("Post Updated"))
        .catchError((error) => print("Failed to update post: $error"));

    getChildPosts();
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

  Future<void> liked() async {
    await posts
        .doc(_currentDocIdStack.last)
        .update({KEY_NUMOFLIKES: _currentPostMap[KEY_NUMOFLIKES] + 1})
        .then((value) => print("post is liked"))
        .catchError((error) => print("Failed to like: $error"));

    _currentPostMap.update(KEY_NUMOFLIKES, (value) => value + 1);

    notifyListeners();
  }

  Future<void> unliked() async {
    await posts
        .doc(_currentDocIdStack.last)
        .update({KEY_NUMOFLIKES: _currentPostMap[KEY_NUMOFLIKES] - 1})
        .then((value) => print("post is unliked"))
        .catchError((error) => print("Failed to unlike: $error"));

    _currentPostMap.update(KEY_NUMOFLIKES, (value) => value - 1);

    notifyListeners();
  }
}
