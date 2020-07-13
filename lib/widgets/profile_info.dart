import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/profile/profile.dart';
import 'package:subbi/screens/tabs/profile_screen.dart';

class ProfileInfo extends StatelessWidget {
  final String profileId;

  const ProfileInfo({
    Key key,
    @required this.profileId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile>(
        future: Profile.getProfile(
          ofUid: profileId,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          Profile profile = snapshot.data;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            profile: profile,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              profile.profilePicURL,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            profile.name,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
