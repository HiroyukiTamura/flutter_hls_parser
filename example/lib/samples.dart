const PLAYLIST_URI = 'https://example.com/test.m3u8';

const SAMPLE_MASTER = '''
#EXTM3U

#EXT-X-STREAM-INF:BANDWIDTH=1280000,CODECS="mp4a.40.2,avc1.66.30",RESOLUTION=304x128
http://example.com/low.m3u8

#EXT-X-STREAM-INF:BANDWIDTH=1280000,CODECS="mp4a.40.2 , avc1.66.30 "
http://example.com/spaces_in_codecs.m3u8

#EXT-X-STREAM-INF:BANDWIDTH=2560000,FRAME-RATE=25,RESOLUTION=384x160
http://example.com/mid.m3u8

#EXT-X-STREAM-INF:BANDWIDTH=7680000,FRAME-RATE=29.997
http://example.com/hi.m3u8

#EXT-X-STREAM-INF:BANDWIDTH=65000,CODECS="mp4a.40.5"
http://example.com/audio-only.m3u8
''';


const SAMPLE_MEDIA = '''
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-PLAYLIST-TYPE:VOD
#EXT-X-START:TIME-OFFSET=-25
#EXT-X-TARGETDURATION:8
#EXT-X-MEDIA-SEQUENCE:2679
#EXT-X-DISCONTINUITY-SEQUENCE:4
#EXT-X-ALLOW-CACHE:YES

#EXTINF:7.975,
#EXT-X-BYTERANGE:51370@0
https://priv.example.com/fileSequence2679.ts

#EXT-X-KEY:METHOD=AES-128,URI="https://priv.example.com/key.php?r=2680",IV=0x1566B
#EXTINF:7.975,segment title
#EXT-X-BYTERANGE:51501@2147483648
https://priv.example.com/fileSequence2680.ts

#EXT-X-KEY:METHOD=NONE
#EXTINF:7.941,segment title .,:/# with interesting chars
#EXT-X-BYTERANGE:51501
https://priv.example.com/fileSequence2681.ts

#EXT-X-DISCONTINUITY
#EXT-X-KEY:METHOD=AES-128,URI="https://priv.example.com/key.php?r=2682"
#EXTINF:7.975
#EXT-X-BYTERANGE:51740
https://priv.example.com/fileSequence2682.ts

#EXTINF:7.975,
https://priv.example.com/fileSequence2683.ts
#EXT-X-ENDLIST
''';