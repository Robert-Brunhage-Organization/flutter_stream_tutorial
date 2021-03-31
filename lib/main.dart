import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

Future<void> main() async {
  const apiKey = "3u9cdranjdmg";
  const userToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicm9iZXJ0YnJ1bmhhZ2UifQ.5bYlaBFJ8w-_zSh3pgFPUVVlJNtiVKdz8F1clUhF8Dg";

  final client = StreamChatClient(
    apiKey,
    logLevel: Level.INFO,
  );

  await client.connectUser(
    User(
      id: 'robertbrunhage',
      extraData: {
        'image': 'https://robertbrunhage.com/logo.png',
      },
    ),
    userToken,
  );

  /// Creates a channel using the type `messaging` and `coolkids`.
  /// Channels are containers for holding messages between different members. To
  /// learn more about channels and some of our predefined types, checkout our
  /// our channel docs: https://getstream.io/chat/docs/initialize_channel/?language=dart
  final channel = client.channel(
    'messaging',
    id: 'coolkids',
    extraData: {
      "name": "Cool Kids",
      "image": "https://robertbrunhage.com/logo.png",
    },
  );

  /// `.watch()` is used to create and listen to the channel for updates. If the
  /// channel already exists, it will simply listen for new events.
  channel.watch();

  runApp(MyApp(client, channel));
}

class MyApp extends StatelessWidget {
  /// Instance of [StreamChatClient] we created earlier. This contains information about
  /// our application and connection state.
  final StreamChatClient client;

  /// The channel we'd like to observe and participate.
  final Channel channel;

  /// To initialize this example, an instance of [client] and [channel] is required.
  MyApp(this.client, this.channel);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData.dark().copyWith(
      accentColor: Color(0xffc34c4c),
    );
    return MaterialApp(
      builder: (context, widget) {
        return StreamChat(
          child: widget,
          client: client,
          streamChatThemeData: StreamChatThemeData.fromTheme(theme),
        );
      },
      home: StreamChannel(
        channel: channel,
        child: ChannelPage(),
      ),
    );
  }
}

/// Displays the list of messages inside the channel
class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChannelHeader(
        showBackButton: false,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(),
          ),
          MessageInput(),
        ],
      ),
    );
  }
}
