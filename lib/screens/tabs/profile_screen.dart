import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:subbi/apis/server_api.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/models/profile/profile.dart';
import 'package:subbi/models/profile/profile_rating.dart';
import 'package:subbi/models/user.dart';
import 'package:subbi/screens/tabs/chat_screen.dart';
import 'package:subbi/widgets/cross_shrinked_listview.dart';

class ProfileScreen extends StatelessWidget {
  final Profile profile;

  const ProfileScreen({
    Key key,
    this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              color: Theme.of(context).accentColor,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage(profile.profilePicURL),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            profile.name,
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: user.isSignedIn()
                              ? FollowButton(
                                  user: user,
                                  profile: profile,
                                )
                              : RaisedButton.icon(
                                  onPressed: () {
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Debes iniciar sesión para esto',
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.remove),
                                  label: Text('Follow'),
                                  textColor: Colors.white,
                                  color: Colors.deepPurple[300],
                                ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Ubicación',
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            profile.location,
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Reputación',
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FutureBuilder<List<Auction>>(
                            future: profile.pastAuctions,
                            builder: (context, snapshot) =>
                                snapshot.connectionState == ConnectionState.done
                                    ? Text(
                                        '${snapshot.data.length} subastas',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                              color: Colors.white,
                                            ),
                                      )
                                    : CircularProgressIndicator(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    user: user,
                                    withProfile: profile,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.chat),
                            label: Text('Chat'),
                            textColor: Colors.white,
                            color: Colors.deepPurple[300],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: Theme.of(context).backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                        future: profile.ratings,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState != ConnectionState.done)
                            return Container(
                              width: double.infinity,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                          return Column(
                            children: <Widget>[
                              buildOpinionsResume(
                                context,
                                snapshot.data,
                                profile,
                                user,
                              ),
                              snapshot.data.length > 0
                                  ? buildOpinionDetail(
                                      context,
                                      snapshot.data[0],
                                      true,
                                    )
                                  : Container(),
                              snapshot.data.length > 1
                                  ? buildOpinionDetail(
                                      context,
                                      snapshot.data[1],
                                      true,
                                    )
                                  : Container(),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 16.0, 0, 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    OutlineButton(
                                      onPressed: () => displayOpinionsSheet(
                                          context, snapshot.data),
                                      child: Text('Ver más opiniones'),
                                    ),
                                    OutlineButton(
                                      onPressed: () {},
                                      child: Text('Subastas anteriores'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOpinionsResume(
    BuildContext context,
    List<ProfileRating> ratings,
    Profile profile,
    User user,
  ) {
    var averageRating = ratings.isNotEmpty
        ? ratings.map((r) => r.rate).reduce((r1, r2) => r1 + r2) /
            ratings.length
        : 0.0;

    var freq = ratings.isNotEmpty
        ? Map.fromIterable(
            ratings.map((r) => r.rate.floor()),
            value: (rate) =>
                ratings.where((r) => r.rate.floor() == rate).length,
          )
        : {};

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "${averageRating.toStringAsPrecision(3)}",
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SmoothStarRating(
                starCount: 5,
                rating: averageRating,
                size: 30.0,
                color: Colors.orangeAccent,
                borderColor: Colors.orangeAccent,
                spacing: 0.0,
                onRated: (rating) async {
                  bool sent = await showDialog(
                    context: context,
                    builder: (context) {
                      var textFieldController = TextEditingController(
                        text: '',
                      );

                      return AlertDialog(
                        title: Text(
                            'Calificar a ${profile.name} con $rating estrellas'),
                        content: TextField(
                          controller: textFieldController,
                          maxLines: 5,
                          maxLength: 500,
                          decoration: InputDecoration(hintText: 'Comentario'),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Enviar'),
                            onPressed: () async {
                              profile.rate(
                                comment: textFieldController.text,
                                rate: rating,
                                raterUid: user.getUID(),
                              );
                              Navigator.of(context).pop(true);
                            },
                          )
                        ],
                      );
                    },
                  );
                  if (sent != null) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Enviando'),
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${ratings.length} en total',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ],
        ),
        CrossShrinkedListView(
          alignment: Axis.vertical,
          itemCount: 5,
          itemBuilder: (rate) => Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.star),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text("${rate + 1}"),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: 100,
                  child: LinearProgressIndicator(
                    value: ratings.isNotEmpty
                        ? (freq[rate + 1] ?? 0) / ratings.length
                        : 0.0,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildOpinionDetail(
      BuildContext context, ProfileRating rating, bool withSeparator) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          withSeparator
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Divider(),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.star),
                Text(
                  "${rating.rate}   ${rating.comment}",
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "${rating.date.day}/${rating.date.month}/${rating.date.year}",
            ),
          ),
        ],
      ),
    );
  }

  void displayOpinionsSheet(BuildContext context, List<ProfileRating> ratings) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) => Container(
            constraints: BoxConstraints.loose(
              Size.fromHeight(constraints.maxHeight / 2),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: ratings.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildOpinionDetail(context, ratings[i], false),
                );
              },
              separatorBuilder: (context, i) => Divider(),
            ),
          ),
        ),
      ),
    );
  }
}

class FollowButton extends StatefulWidget {
  final User user;
  final Profile profile;

  const FollowButton({
    @required this.user,
    @required this.profile,
  });

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: ServerApi.instance().isFollowing(
        followerUid: widget.user.getUID(),
        followedUid: widget.profile.profileUid,
      ),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return RaisedButton.icon(
            onPressed: () => follow(),
            icon: Icon(Icons.person_add),
            label: Text('...'),
            textColor: Colors.white,
            color: Colors.deepPurple[300],
          );
        }

        return snap.data
            ? RaisedButton.icon(
                onPressed: () => unfollow(),
                icon: Icon(Icons.remove),
                label: Text('Unfollow'),
                textColor: Colors.white,
                color: Colors.deepPurple[300],
              )
            : RaisedButton.icon(
                onPressed: () => follow(),
                icon: Icon(Icons.person_add),
                label: Text('Follow'),
                textColor: Colors.white,
                color: Colors.deepPurple[300],
              );
      },
    );
  }

  void follow() async {
    await widget.profile.follow();
    setState(() {});
  }

  void unfollow() async {
    await widget.profile.unfollow();
    setState(() {});
  }
}
