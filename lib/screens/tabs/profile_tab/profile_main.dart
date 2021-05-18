import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:revisit/components/button_full.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/screens/tabs/profile_tab/edit_profile.dart';
import 'package:revisit/screens/tabs/profile_tab/my_article.dart';
import 'package:revisit/screens/tabs/profile_tab/my_story.dart';
import 'package:revisit/service/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileMain extends StatefulWidget {
  @override
  _ProfileMainState createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
  int selected = 0;
  AuthService _authService;
  @override
  Widget build(BuildContext context) {
    _authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: Container(
        child: _childElement,
      ),
    );
  }

  Widget get _childElement {
    final List<Map<String, dynamic>> _listTilesAttribute = [
      {
        "title": "Sunting Profil",
        "icon": Icon(
          Icons.edit,
          color: selected == 1 ? Colors.white : Constant.GRAY_TEXT,
          size: Constant.MINIMUM_FONT_SIZE,
        ),
        "selected": selected == 1 ? true : false,
        "action": _onNavigateToEditProfile,
        "textStyle": TextStyle(
          color: selected == 1 ? Colors.white : Constant.GRAY_TEXT,
          fontSize: Constant.MINIMUM_FONT_SIZE,
        ),
      },
      {
        "title": "Artikel Saya",
        "icon": Icon(
          FontAwesomeIcons.newspaper,
          color: selected == 2 ? Colors.white : Constant.GRAY_TEXT,
          size: Constant.MINIMUM_FONT_SIZE,
        ),
        "selected": selected == 2 ? true : false,
        "action": _onNavigateToMyArticle,
        "textStyle": TextStyle(
          color: selected == 2 ? Colors.white : Constant.GRAY_TEXT,
          fontSize: Constant.MINIMUM_FONT_SIZE,
        ),
      },
      {
        "title": "Cerita Saya",
        "icon": Icon(
          FontAwesomeIcons.paperPlane,
          color: selected == 3 ? Colors.white : Constant.GRAY_TEXT,
          size: Constant.MINIMUM_FONT_SIZE,
        ),
        "selected": selected == 3 ? true : false,
        "action": _onNavigateToMyStory,
        "textStyle": TextStyle(
          color: selected == 3 ? Colors.white : Constant.GRAY_TEXT,
          fontSize: Constant.MINIMUM_FONT_SIZE,
        ),
      },
      {
        "title": "Keluar",
        "icon": Icon(
          Icons.logout,
          color: Constant.GRAY_TEXT,
          size: Constant.MINIMUM_FONT_SIZE,
        ),
        "selected": false,
        "action": _onLogout,
        "textStyle": TextStyle(
          color: Constant.GRAY_TEXT,
          fontSize: Constant.MINIMUM_FONT_SIZE,
        ),
      }
    ];

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: _listTilesAttribute.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: _listTilesAttribute[index]['selected'] ? Constant.blue01 : Colors.white,
                    child: ListTile(
                      leading: _listTilesAttribute[index]['icon'],
                      title: Text(
                        _listTilesAttribute[index]['title'],
                        style: _listTilesAttribute[index]['textStyle'],
                      ),
                      selected: _listTilesAttribute[index]['selected'],
                      onTap: _listTilesAttribute[index]['action'],
                    ),
                  ),
                  Container(
                    height: Constant.MINIMUM_SPACING,
                  )
                ],
              );
            })
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.stretch,
        //   children: [
        //     // Card(
        //     //   child: ListTile(
        //     //     selected: selected == 1 ? true : false,
        //     //     onTap: _onNavigateToEditProfile,
        //     //     selectedTileColor: Constant.blue01,
        //     //     shape: RoundedRectangleBorder(
        //     //       borderRadius: BorderRadius.circular(100),
        //     //     ),
        //     //     leading: Icon(
        //     //       Icons.edit,
        //     //       color: selected == 1 ? Colors.white : Constant.GRAY_TEXT,
        //     //       size: Constant.MINIMUM_FONT_SIZE,
        //     //     ),
        //     //     title: Text(
        //     //       "Sunting profil",
        //     //       style: TextStyle(
        //     //         color: selected == 1 ? Colors.white : Constant.GRAY_TEXT,
        //     //         fontSize: Constant.MINIMUM_FONT_SIZE,
        //     //       ),
        //     //     ),
        //     //   ),
        //     // ),
        //     // Container(
        //     //   height: Constant.MINIMUM_SPACING,
        //     // ),
        //     // Card(
        //     //   child: ListTile(
        //     //     selected: selected == 2 ? true : false,
        //     //     selectedTileColor: Constant.blue01,
        //     //     onTap: _onNavigateToMyArticle,
        //     //     shape: RoundedRectangleBorder(
        //     //       borderRadius: BorderRadius.circular(100),
        //     //     ),
        //     //     leading: Icon(
        //     //       FontAwesomeIcons.newspaper,
        //     //       color: selected == 2 ? Colors.white : Constant.GRAY_TEXT,
        //     //       size: Constant.MINIMUM_FONT_SIZE,
        //     //     ),
        //     //     title: Text(
        //     //       "Artikel saya",
        //     //       style: TextStyle(
        //     //         color: selected == 2 ? Colors.white : Constant.GRAY_TEXT,
        //     //         fontSize: Constant.MINIMUM_FONT_SIZE,
        //     //       ),
        //     //     ),
        //     //   ),
        //     // ),
        //     // Container(
        //     //   height: Constant.MINIMUM_SPACING,
        //     // ),
        //     // Card(
        //     //   child: ListTile(
        //     //     enabled: true,
        //     //     selected: selected == 3 ? true : false,
        //     //     selectedTileColor: Constant.blue01,
        //     //     onTap: _onNavigateToMyStory,
        //     //     shape: RoundedRectangleBorder(
        //     //       borderRadius: BorderRadius.circular(100),
        //     //     ),
        //     //     leading: Icon(
        //     //       FontAwesomeIcons.paperPlane,
        //     //       color: selected == 3 ? Colors.white : Constant.GRAY_TEXT,
        //     //       size: Constant.MINIMUM_FONT_SIZE,
        //     //     ),
        //     //     title: Text(
        //     //       "Cerita saya",
        //     //       style: TextStyle(
        //     //         color: selected == 3 ? Colors.white : Constant.GRAY_TEXT,
        //     //         fontSize: Constant.MINIMUM_FONT_SIZE,
        //     //       ),
        //     //     ),
        //     //   ),
        //     // ),
        //     // Container(
        //     //   height: Constant.MINIMUM_SPACING,
        //     // ),
        //     // Card(
        //     //   child: ListTile(
        //     //     onTap: _onLogout,
        //     //     leading: Icon(
        //     //       Icons.logout,
        //     //       color: Constant.GRAY_TEXT,
        //     //       size: Constant.MINIMUM_FONT_SIZE,
        //     //     ),
        //     //     title: Text(
        //     //       "Keluar",
        //     //       style: TextStyle(
        //     //         color: Constant.GRAY_TEXT,
        //     //         fontSize: Constant.MINIMUM_FONT_SIZE,
        //     //       ),
        //     //     ),
        //     //   ),
        //     // ),
        //   ],
        // ),
        );
  }

  Future<void> _onLogout() async {
    print(_authService.currentUser.id);
    await _authService.logOut(context);
  }

  Future<void> _onNavigateToMyStory() async {
    setState(() {
      selected = 3;
    });
    await MainPlatform.transitionToPage(context, MyStory());
  }

  Future<void> _onNavigateToMyArticle() async {
    setState(() {
      selected = 2;
    });

    await MainPlatform.transitionToPage(context, MyArticle());
  }

  Future<void> _onNavigateToEditProfile() async {
    setState(() {
      selected = 1;
    });
    await MainPlatform.transitionToPage(context, EditProfile());
  }
}
