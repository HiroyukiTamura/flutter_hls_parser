import 'package:flutter/material.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:flutter_hls_parser_example/samples.dart';

void main() => runApp(const _MyApp());

class _MyApp extends StatefulWidget {
  const _MyApp();

  @override
  State<_MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<_MyApp> with SingleTickerProviderStateMixin {
  static const _kTabList = ['master sample', 'media sample'];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _kTabList.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('SAMPLE'),
            bottom: TabBar(
              isScrollable: true,
              tabs: _kTabList.map((it) => Tab(text: it)).toList(),
              controller: _tabController,
              indicatorColor: Colors.white,
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: const Content(),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: const Content2nd(),
                ),
              ],
            ),
          ),
        ),
      );
}

class Content extends StatelessWidget {
  const Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Colors.black12,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(SAMPLE_MASTER),
            ),
          ),
          SizedBox(height: 32),
          Container(
            child: ElevatedButton(
              child: Text('PARSE!', textDirection: TextDirection.ltr),
              onPressed: () async {
                final playList = await HlsPlaylistParser.create()
                    .parseString(Uri.parse(PLAYLIST_URI), SAMPLE_MASTER);
                playList as HlsMasterPlaylist;

                final mediaPlaylistUrls = playList.mediaPlaylistUrls;
                final codecs = playList.variants.map((it) => it.format.codecs);
                final frameRates =
                    playList.variants.map((it) => it.format.frameRate);
                final bandWidth =
                    playList.variants.map((it) => it.format.bitrate);

                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DialogHeading(text: 'media playlist uri'),
                                ...mediaPlaylistUrls.map(
                                  (it) => Text(it.toString()),
                                ),
                                DialogHeading(text: 'codec'),
                                ...codecs.map(
                                  (it) => Text(it.toString()),
                                ),
                                DialogHeading(text: 'frame rate'),
                                ...frameRates.map(
                                  (it) => Text(it.toString()),
                                ),
                                DialogHeading(text: 'band width'),
                                ...bandWidth.map(
                                  (it) => Text(it.toString()),
                                ),
                              ],
                            ),
                          ),
                        ));
              },
            ),
          ),
        ],
      );
}

class Content2nd extends StatelessWidget {
  const Content2nd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Colors.black12,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(SAMPLE_MEDIA),
            ),
          ),
          SizedBox(height: 32),
          Container(
            child: ElevatedButton(
              child: Text('PARSE!', textDirection: TextDirection.ltr),
              onPressed: () async {
                final playList = await HlsPlaylistParser.create()
                    .parseString(Uri.parse(PLAYLIST_URI), SAMPLE_MEDIA);
                playList as HlsMediaPlaylist;

                final mediaPlaylistUrls = playList.segments.map((it) => it.url);
                final titles = playList.segments.map((it) => it.title);
                final fullSegmentEncryptionKeyUri = playList.segments.map((it) => it.fullSegmentEncryptionKeyUri);
                final encryptionIV = playList.segments.map((it) => it.encryptionIV);
                final byterangeLength = playList.segments.map((it) => it.byterangeLength);

                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DialogHeading(text: 'media uri'),
                                ...mediaPlaylistUrls.map(
                                  (it) => Text(it.toString()),
                                ),
                                DialogHeading(text: 'segment title'),
                                ...titles.map(
                                      (it) => Text(it.toString()),
                                ),
                                DialogHeading(text: 'encryption key uri'),
                                ...fullSegmentEncryptionKeyUri.map(
                                      (it) => Text(it.toString()),
                                ),
                                DialogHeading(text: 'encryption IV'),
                                ...encryptionIV.map(
                                      (it) => Text(it.toString()),
                                ),
                                DialogHeading(text: 'byte range length'),
                                ...byterangeLength.map(
                                      (it) => Text(it.toString()),
                                ),
                              ],
                            ),
                          ),
                        ));
              },
            ),
          ),
        ],
      );
}

class DialogHeading extends StatelessWidget {
  const DialogHeading({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline6,
        ),
        padding: EdgeInsets.only(top: 24, bottom: 8),
      );
}
