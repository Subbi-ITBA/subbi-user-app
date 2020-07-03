import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/models/profile/profile.dart';
import 'package:subbi/models/profile/profile_rating.dart';
import 'package:subbi/models/user.dart';
import 'package:subbi/screens/unauthenticated_box.dart';
import 'package:subbi/widgets/cross_shrinked_listview.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Profile profile;
    profile = Profile(
      name: 'Fulano Mengano',
      location: 'Buenos Aires, Argentina',
      profilePicURL:
          'https://cdn.cienradios.com/wp-content/uploads/sites/4/2020/04/fulano.jpg',
      uid: "1",
      user: Provider.of<User>(context),
      following: true,
      ratings: [
        ProfileRating(
          ratingUserProfile: Profile(
            name: 'Josefo Fino',
            user: null,
            uid: null,
            profilePicURL: null,
            location: null,
            following: null,
          ),
          ratedUserProfile: profile,
          rate: 3,
          date: DateTime.now(),
          comment: 'Meh... Normal',
        ),
        ProfileRating(
          ratingUserProfile: Profile(
            name: 'Ana Banana',
            user: null,
            uid: null,
            profilePicURL: null,
            location: null,
            following: null,
          ),
          ratedUserProfile: profile,
          rate: 4,
          date: DateTime.now(),
          comment: 'Muy buen vendedor',
        ),
        ProfileRating(
          ratingUserProfile: Profile(
            name: 'Ana Banana',
            user: null,
            uid: null,
            profilePicURL: null,
            location: null,
            following: null,
          ),
          ratedUserProfile: profile,
          rate: 2,
          date: DateTime.now(),
          comment: 'Pésimo',
        ),
        ProfileRating(
          ratingUserProfile: Profile(
            name: 'Ana Banana',
            user: null,
            uid: null,
            profilePicURL: null,
            location: null,
            following: null,
          ),
          ratedUserProfile: profile,
          rate: 4,
          date: DateTime.now(),
          comment: 'Muy buen vendedor',
        ),
        ProfileRating(
          ratingUserProfile: Profile(
            name: 'Ana Banana',
            user: null,
            uid: null,
            profilePicURL: null,
            location: null,
            following: null,
          ),
          ratedUserProfile: profile,
          rate: 4,
          date: DateTime.now(),
          comment: 'Muy buen vendedor',
        ),
        ProfileRating(
          ratingUserProfile: Profile(
            name: 'Ana Banana',
            user: null,
            uid: null,
            profilePicURL: null,
            location: null,
            following: null,
          ),
          ratedUserProfile: profile,
          rate: 4,
          date: DateTime.now(),
          comment: 'Muy buen vendedor',
        ),
        ProfileRating(
          ratingUserProfile: Profile(
            name: 'Ana Banana',
            user: null,
            uid: null,
            profilePicURL: null,
            location: null,
            following: null,
          ),
          ratedUserProfile: profile,
          rate: 4,
          date: DateTime.now(),
          comment: 'Muy buen vendedor',
        ),
      ],
    );

    var user = Provider.of<User>(context);

    if (!user.isSignedIn()) return UnauthenticatedBox();

    return Column(
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
                          child: FollowButton(
                            following: profile.following,
                          ),
                        ),
                      ]),
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
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          profile.location,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Reputación',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
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
                          onPressed: () => {},
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
                FutureBuilder<List<ProfileRating>>(
                    future: profile.ratings,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done)
                        return CircularProgressIndicator();

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              buildOpinionsResume(context, snapshot.data),
                              snapshot.data.length > 0
                                  ? buildOpinionDetail(
                                      context, snapshot.data[0], true)
                                  : Container(),
                              snapshot.data.length > 1
                                  ? buildOpinionDetail(
                                      context, snapshot.data[1], true)
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
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildOpinionsResume(
      BuildContext context, List<ProfileRating> ratings) {
    var averageRating =
        ratings.map((r) => r.rate).reduce((r1, r2) => r1 + r2) / ratings.length;
    var freq = Map.fromIterable(ratings.map((r) => r.rate),
        value: (rate) => ratings.where((r) => r.rate == rate).length);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(children: [
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${ratings.length} en total',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ]),
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
                    value: (freq[rate + 1] ?? 0) / ratings.length,
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
                "${rating.ratingUserProfile.name} - ${rating.date.day}/${rating.date.month}/${rating.date.year}",
              ),
            ),
          ]),
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
  final bool following;

  const FollowButton({@required this.following});

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool following;

  @override
  void initState() {
    following = widget.following;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return following
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
  }

  void follow() {
    setState(() {
      following = true;
    });
  }

  void unfollow() {
    setState(() {
      following = false;
    });
  }
}
