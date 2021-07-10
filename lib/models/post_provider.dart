import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:ttt_project_003/constant/firestore_keys.dart';
import 'package:ttt_project_003/models/gallery_state.dart';
import 'package:ttt_project_003/models/user_provider.dart';

class PostProvider with ChangeNotifier {
  static String _currentDocId;
  static String _rootPostDID;
  static String _parentPostDID;
  String _title;
  String _content;
  String _uid;
  String _unm;
  String _imageURL;
  String _postTime;
  int _numOfLikes;
  int _numOfComments;
  bool _displayAllPost = true;
  static List<dynamic> _homePostList = [];
  static Map<String, dynamic> _currentPostMap;
  static List<dynamic> _childPostList = [];
  static List<dynamic> _myPostList = [];

  String get currentDocId => _currentDocId;

  String get rootPostDID => _rootPostDID;

  String get parentPostDID => _parentPostDID;

  String get title => _title;

  String get content => _content;

  String get uid => _uid;

  String get unm => _unm;

  String get imageURL => _imageURL;

  String get postTime => _postTime;

  int get numOfLikes => _numOfLikes;

  int get numOfComments => _numOfComments;

  bool get displayAllPost => _displayAllPost;

  List<dynamic> get homePostList => _homePostList;

  Map<String, dynamic> get currentPostMap => _currentPostMap;

  List<dynamic> get childPostList => _childPostList;

  List<dynamic> get myPostList => _myPostList;

  CollectionReference posts =
      FirebaseFirestore.instance.collection(COLLECTION_POSTS);

  void changeDisplay() {
    _displayAllPost = !_displayAllPost;
    getHomePostList();
    if (_displayAllPost == true) {
      print('you can see all Post now');
    } else {
      print('you can see root Post now');
    }
  }

  void setCurrentDocId(String currentDocId) {
    _currentDocId = currentDocId;
    print("set document id to $_currentDocId");

    notifyListeners();
  }

  void removeDocId() {
    _currentDocId = null;
    _rootPostDID = null;
    print("set currentDocument id to $_currentDocId");
    print("set rootDocument id to $_rootPostDID");
  }

  Future<void> createPost(String title, String content, var postTime) async {
    UserProvider _userProvider = UserProvider();
    String imgUrl = await GalleryState().uploadAndDownloadPostImg(postTime);

    DocumentReference ref = posts.doc('${postTime}_${_userProvider.uid}');
    String rootPostDID = _rootPostDID == null ? ref.id : _rootPostDID;
    String parentPostDID = _currentDocId;
    ref
        .set({
          KEY_AUTHORUNM: _userProvider.username,
          KEY_AUTHORUID: _userProvider.uid,
          KEY_TITLE: title,
          KEY_CONTENT: content,
          KEY_POSTIMG: imgUrl,
          KEY_ROOTPOSTDID: rootPostDID,
          KEY_PARENTPOSTDID: parentPostDID,
          KEY_NUMOFLIKES: 0,
          KEY_NUMOFCOMMENTS: 0,
          KEY_POSTTIME: postTime
        })
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add post: $error"));
  }

  Future getPostData(String currentDocId) async {
    setCurrentDocId(currentDocId);
    await posts
        .doc(currentDocId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formattedPostTime =
      formatter.format(data[KEY_POSTTIME].toDate());

      if (documentSnapshot.exists) {
        _currentPostMap = data;
        _rootPostDID = data[KEY_ROOTPOSTDID];
        _parentPostDID = data[KEY_PARENTPOSTDID];
        _title = data[KEY_TITLE];
        _content = data[KEY_CONTENT];
        _uid = data[KEY_AUTHORUID];
        _unm = data[KEY_AUTHORUNM];
        _numOfLikes = data[KEY_NUMOFLIKES];
        _numOfComments = data[KEY_NUMOFCOMMENTS];
        _imageURL = data[KEY_POSTIMG];
        _postTime = formattedPostTime;
        print('get data!');
        print(_currentPostMap);
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  Future<void> updatePost(String title, String content) async {
    Timestamp time = _currentPostMap[KEY_POSTTIME];
    var date = DateTime.fromMicrosecondsSinceEpoch(time.millisecondsSinceEpoch);
    String imgUrl = await GalleryState().uploadAndDownloadPostImg(date);

    _imageURL = imgUrl;
    _title = title;
    _content = content;
    posts
        .doc(_currentDocId)
        .update({KEY_CONTENT: content, KEY_TITLE: title, KEY_POSTIMG: imgUrl})
        .then((value) => print("Post Updated"))
        .catchError((error) => print("Failed to update post: $error"));

    notifyListeners();
  }

  void deletePost() {
    posts
        .doc(_currentDocId)
        .delete()
        .then((value) => print("Post Delete"))
        .catchError((error) => print("Failed to delete post: $error"));

    setCurrentDocId(null);
  }

  void anonymizationPost() {
    posts
        .doc(_currentDocId)
        .update({'unm': '익명'})
        .then((value) => print("Post Anonymized"))
        .catchError((error) => print("Failed to Anonymize post: $error"));
  }

  Future getHomePostList() async {
    if (_displayAllPost == true) {
      var snapshot = await posts.get();
      _homePostList = _getPostList(snapshot);
    } else {
      var snapshot = await posts.where(KEY_PARENTPOSTDID, isNull: true).get();
      _homePostList = _getPostList(snapshot);
    }
    print('HomePostList: $_homePostList');

    notifyListeners();
  }

  Future getChildPostList() async {
    var snapshot =
        await posts.where(KEY_PARENTPOSTDID, isEqualTo: _currentDocId).get();
    _childPostList = _getPostList(snapshot);

    print('ChildPostList: $_childPostList');

    notifyListeners();
  }

  //2차원 데이터 _postList (id, title, content) 반환
  List<dynamic> _getPostList(snapshot) {
    List<dynamic> postList = [];
    List<dynamic> tmpList = [];

    if (snapshot != null) {
      List<QueryDocumentSnapshot> docs = snapshot.docs.toList();

      for (int i = 0; i < docs.length; i++) {
        Map<String, dynamic> data = docs[i].data() as Map<String, dynamic>;
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formattedPostTime =
            formatter.format(data[KEY_POSTTIME].toDate());

        tmpList = [];

        tmpList.add(docs[i].id);
        tmpList.add(data[KEY_AUTHORUID]);
        tmpList.add(data[KEY_POSTIMG]);
        tmpList.add(formattedPostTime);
        tmpList.add(data[KEY_NUMOFLIKES]);
        tmpList.add(data[KEY_AUTHORUNM]);
        tmpList.add(data[KEY_TITLE]);

        String cont = data[KEY_CONTENT];
        if (cont.length > 25) {
          cont = cont.substring(0, 25) + '...';
        }
        tmpList.add(cont);
        postList.add(tmpList);
      }
      return postList;
    }
    return null;
  }

  Future getMyPostList(String currentUid) async {
    List<dynamic> myPostList = [];
    List<String> myTmpList = [];

    var snapshot = await posts.where("uid", isEqualTo: currentUid).get();

    if (snapshot != null) {
      List<QueryDocumentSnapshot> docs = snapshot.docs.toList();
      for (int i = 0; i < docs.length; i++) {
        Map<String, dynamic> data = docs[i].data() as Map<String, dynamic>;
        myTmpList = [];

        myTmpList.add(docs[i].id);
        myTmpList.add(data['title']);

        String myCont = data['content'];
        if (myCont.length > 25) {
          myCont = myCont.substring(0, 25) + '...';
        }
        myTmpList.add(myCont);

        myPostList.add(myTmpList);
      }
    }
    _myPostList = myPostList;
    print('MyPostList: $_myPostList');

    notifyListeners();
  }

  void liked() {
    _numOfLikes += 1;
    posts
        .doc(_currentDocId)
        .update({'num_of_likes': _numOfLikes})
        .then((value) => print("post is liked"))
        .catchError((error) => print("Failed to like: $error"));

    notifyListeners();
  }

  void unliked() {
    _numOfLikes -= 1;
    posts
        .doc(_currentDocId)
        .update({'num_of_likes': _numOfLikes})
        .then((value) => print("post is unliked"))
        .catchError((error) => print("Failed to unlike: $error"));

    notifyListeners();
  }
}
