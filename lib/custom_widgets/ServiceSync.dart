import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:flutter/services.dart';

class ServiceSync extends StatelessWidget {
  ServiceSync({
    Key key,
    this.thumbnail,
    this.title,
    this.subtitle,
    this.screen,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context){
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        return screen;
      }));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: kHighlightColorGrey,
                      blurRadius: 6.0, // has the effect of softening the shadow
                      spreadRadius: 1.0, // has the effect of extending the shadow
                      offset: Offset(
                        1.0, // horizontal, move right 10
                        1.0, // vertical, move down 10
                      ),
                    )
                  ],
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: thumbnail,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$title',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                          Text(
                            '$subtitle',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ...

/*
Widget build(BuildContext context) {
  return ListView(
    padding: const EdgeInsets.all(10.0),
    children: <Widget>[
      CustomListItemTwo(
        thumbnail: Container(
          decoration: const BoxDecoration(color: Colors.pink),
        ),
        title: 'Flutter 1.0 Launch',
        subtitle:
        'Flutter continues to improve and expand its horizons.'
            'This text should max out at two lines and clip',
        author: 'Dash',
        publishDate: 'Dec 28',
        readDuration: '5 mins',
      ),
      CustomListItemTwo(
        thumbnail: Container(
          decoration: const BoxDecoration(color: Colors.blue),
        ),
        title: 'Flutter 1.2 Release - Continual updates to the framework',
        subtitle: 'Flutter once again improves and makes updates.',
        author: 'Flutter',
        publishDate: 'Feb 26',
        readDuration: '12 mins',
      ),
    ],
  );
}*/
