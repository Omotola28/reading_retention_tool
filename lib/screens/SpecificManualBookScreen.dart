import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'package:reading_retention_tool/custom_widgets/CustomHighlightTile.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/screens/ManualHighlightBookShelfScreen.dart';
import 'package:reading_retention_tool/utils/manageHighlightsController.dart';

class SpecificManualBookScreen extends StatefulWidget {

  Map<String, dynamic> bookData;

  SpecificManualBookScreen(this.bookData);


  @override
  _SpecificManualBookScreenState createState() => _SpecificManualBookScreenState();
}

class _SpecificManualBookScreenState extends State<SpecificManualBookScreen> {

  final _store = Firestore.instance;
  var notes = [];
  final manageHighlight = new ManageHighlightsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget> [
                  SliverAppBar(
                    iconTheme: IconThemeData(
                      color: Colors.black, //change your color here
                    ),
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    leading: IconButton(
                         icon: Icon( Icons.arrow_back_ios,
                                     color: kDarkColorBlack
                          ),
                          onPressed: () => Navigator.of(context).popAndPushNamed(ManualHighlightBookShelfRoute),
                     ),
                    flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text(widget.bookData['bookname'],
                            style: TextStyle(
                              color: kDarkColorBlack,
                              fontSize: 15.0,
                            )),
                        background: Image.network(widget.bookData['url'] ?? kBookPlaceHolder,
                          fit: BoxFit.cover,
                        )),
                  ),

                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        labelColor: kDarkColorBlack,
                        unselectedLabelColor: kHighlightColorDarkGrey,
                        indicatorColor: kPrimaryColor,
                        tabs: [
                          Tab(text: "Notes"),
                          Tab(text: "Thoughts"),
                        ],
                      ),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  Container(
                    color: kLightYellowBG,
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: _store.collection('hmq')
                            .document(Provider.of<AppData>(context).userData.id)
                            .collection('books')
                            .document(widget.bookData['bookname'])
                            .snapshots(),
                        builder: (context, snapshot){
                          List<Widget> widgetHighlights = [];
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            notes = snapshot.data['textList'];

                            if(notes.length == 0){
                              return Center(child: Text('No notes yet'),);
                            }

                            for (var index = 0; index < notes.length; index++) {

                              final highlightWidget =
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Card(
                                  color: Color.fromRGBO(250, 249, 242, 1),

                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      CustomHighlightTile(
                                        //icon: Icon(CustomIcons.circle, size: 8.0, color: HexColor(highlights[index]['color'])),
                                        text: notes[index]['text'],

                                        popMenu: PopupMenuButton(
                                            onSelected: (selectedDropDownItem) =>
                                                manageHighlight.handlePopUpMenuAction(
                                                    selectedDropDownItem,
                                                    context,
                                                    index,
                                                    notes,
                                                    widget.bookData['bookname'],
                                                    'hmq'
                                                ),
                                            itemBuilder: (BuildContext context) => manageHighlight.popMenu
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );

                              widgetHighlights.add(highlightWidget);
                            }

                          }

                          return ListView.builder(
                              itemCount: snapshot.data['textList'].length == null ? 0 : snapshot.data['textList'].length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: widgetHighlights[index],
                                );
                              });
                        }),
                  ),
                  Icon(Icons.directions_transit),
                ],
              ),
          )
      ),
    );
  }
}



class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
