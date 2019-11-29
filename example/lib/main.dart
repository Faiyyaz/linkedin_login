import 'package:example/api_exposer.dart';
import 'package:example/dialog_utils.dart';
import 'package:example/linkedin_share_request.dart' as prefix0;
import 'package:example/linkedin_share_request.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_login/linkedin_login.dart';

import 'loader.dart';

void main() => runApp(MyApp());

// @TODO IMPORTANT - you need to change variable values below
// You need to add your own data from LinkedIn application
// From: https://www.linkedin.com/developers/
// Please read step 1 from this link https://developer.linkedin.com/docs/oauth2
final String redirectUrl = 'https://intro.ooo';
final String clientId = '81jmy8b0ul2415';
final String clientSecret = 'Rhr25MKWs2eRByCq';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter LinkedIn demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.person),
                  text: 'Profile',
                ),
                Tab(icon: Icon(Icons.text_fields), text: 'Auth code')
              ],
            ),
            title: Text('LinkedIn Authorization'),
          ),
          body: TabBarView(
            children: [
              LinkedInProfileExamplePage(),
              LinkedInAuthCodeExamplePage(),
            ],
          ),
        ),
      ),
    );
  }
}

class LinkedInProfileExamplePage extends StatefulWidget {
  @override
  State createState() => _LinkedInProfileExamplePageState();
}

class _LinkedInProfileExamplePageState
    extends State<LinkedInProfileExamplePage> {
  UserObject user;
  bool logoutUser = false;
  bool visibility = false;
  DialogUtils _dialogUtils;
  Loader _loader;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            LinkedInButtonStandardWidget(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LinkedInUserWidget(
                      appBar: AppBar(
                        title: Text('OAuth User'),
                      ),
                      destroySession: logoutUser,
                      redirectUrl: redirectUrl,
                      clientId: clientId,
                      clientSecret: clientSecret,
                      onGetUserProfile: (LinkedInUserModel linkedInUser) {
                        print('Access token ${linkedInUser.token.accessToken}');

                        print('User id: ${linkedInUser.userId}');

                        user = UserObject(
                          firstName: linkedInUser.firstName.localized.label,
                          lastName: linkedInUser.lastName.localized.label,
                          email: linkedInUser
                              .email.elements[0].handleDeep.emailAddress,
                          accessToken: linkedInUser.token.accessToken,
                          id: linkedInUser.userId,
                        );
                        setState(() {
                          logoutUser = false;
                          visibility = true;
                        });

                        Navigator.pop(context);
                      },
                      catchError: (LinkedInErrorObject error) {
                        print('Error description: ${error.description},'
                            ' Error code: ${error.statusCode.toString()}');
                        Navigator.pop(context);
                      },
                    ),
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
            LinkedInButtonStandardWidget(
              onTap: () {
                setState(() {
                  user = null;
                  logoutUser = true;
                });
              },
              buttonText: 'Logout',
            ),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('First: ${user?.firstName} '),
                  Text('Last: ${user?.lastName} '),
                  Text('Email: ${user?.email}'),
                  Visibility(
                      visible: visibility,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 16.0),
                        child: MaterialButton(
                          onPressed: () {
                            _postShare();
                          },
                          height: 52,
                          color: Colors.red,
                          child: Text(
                            'Post Share',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ]),
    );
  }

  _postShare() {
    _loader.show(Colors.red);
    var id = user.id;
    var dateTime = DateTime.now();
    List<prefix0.ContentEntity> contentEntites = [];
    List<prefix0.Thumbnail> thumbnails = [];
    thumbnails.add(prefix0.Thumbnail(
        resolvedUrl: 'https://via.placeholder.com/300x300.png'));
    contentEntites.add(ContentEntity(
        entityLocation: 'https://test-1194.idemo.live',
        thumbnails: thumbnails));

    var body = prefix0.LinkedinShareRequest(
        content: prefix0.Content(
            contentEntities: contentEntites, title: 'Harley davidson'),
        owner: 'urn:li:person:$id',
        subject: 'Bike',
        distribution: prefix0.Distribution(
            linkedInDistributionTarget: prefix0.LinkedInDistributionTarget()),
        text: prefix0.ContentText(
            text: 'A nice harley davidson with a cool background!'));

    var apiExposer = ApiExposer();
    apiExposer.callApi(
        context: context,
        authToken: user.accessToken,
        body: body,
        url: 'https://api.linkedin.com/v2/shares',
        onSuccess: () {
          _loader.hide();
        },
        onError: (String errorMessage) {
          _loader.hide();
        },
        onAuthFailure: (String errorMessage) {
          _loader.hide();
        });
  }

  @override
  void initState() {
    super.initState();
    _dialogUtils = DialogUtils();
    _loader = Loader(context: context, showBackgroundColor: false);
  }
}

class LinkedInAuthCodeExamplePage extends StatefulWidget {
  @override
  State createState() => _LinkedInAuthCodeExamplePageState();
}

class _LinkedInAuthCodeExamplePageState
    extends State<LinkedInAuthCodeExamplePage> {
  AuthCodeObject authorizationCode;
  bool logoutUser = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        LinkedInButtonStandardWidget(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => LinkedInAuthCodeWidget(
                  destroySession: logoutUser,
                  redirectUrl: redirectUrl,
                  clientId: clientId,
                  onGetAuthCode: (AuthorizationCodeResponse response) {
                    print('Auth code ${response.code}');

                    print('State: ${response.state}');

                    authorizationCode = AuthCodeObject(
                      code: response.code,
                      state: response.state,
                    );
                    setState(() {});

                    Navigator.pop(context);
                  },
                  catchError: (LinkedInErrorObject error) {
                    print('Error description: ${error.description},'
                        ' Error code: ${error.statusCode.toString()}');
                    Navigator.pop(context);
                  },
                ),
                fullscreenDialog: true,
              ),
            );
          },
        ),
        LinkedInButtonStandardWidget(
          onTap: () {
            setState(() {
              authorizationCode = null;
              logoutUser = true;
            });
          },
          buttonText: 'Logout user',
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Auth code: ${authorizationCode?.code} '),
              Text('State: ${authorizationCode?.state} '),
            ],
          ),
        ),
      ],
    );
  }
}

class AuthCodeObject {
  String code, state;

  AuthCodeObject({this.code, this.state});
}

class UserObject {
  String firstName, lastName, email, accessToken, id;

  UserObject(
      {this.firstName, this.lastName, this.email, this.accessToken, this.id});
}
