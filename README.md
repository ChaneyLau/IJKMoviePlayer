# IJKMoviePlayer

本框架IJKMoviePlayer (即：IJKMediaFramework)的编译过程来自[官方ijkplayer](https://github.com/bilibili/ijkplayer)。

### 1. 编译说明

* 基于ijkplayer **k0.8.8**；
* 基于ffmpeg **4.0**；

```
IJK_FFMPEG_COMMIT=ff4.0--ijk0.8.8--20201130--001
```

* 编译脚本：[IJKConfig/module-lite.sh](https://github.com/ChaneyLau/IJKMoviePlayer/blob/master/IJKConfig/module-lite.sh)
* 编译的FFmpeg库：[FFmpegLibWithSSL/*.a](https://github.com/ChaneyLau/IJKMoviePlayer/tree/master/FFmpegLibWithSSL)

### 2. 功能特性

* 支持RTMP、HTTP、HLS的直播/点播流媒体播放；
* 支持HTTPS协议；
* 支持多种媒体封装格式(mp4、mov、flv、avi、rmvb、rm、3gp、TS等)；
* 支持VideoToolBox硬件解码；
* 更多功能特性详见[ijkplayer](https://github.com/bilibili/ijkplayer)。

### 3. 运行环境

IJKMoviePlayer可运行于 iPhone/iPod Touch/iPad，支持 iOS 9.0 及以上版本，仅支持**arm64真机**运行。

### 4. 使用SDK

通过Cocoapods下载静态库framework，执行pod install或者pod update后，将SDK加入工程。

```
pod 'IJKMoviePlayer'
```

### 5. 说明

**IJKMoviePlayer**仅为播放器框架，不包含操作UI，可基于本框架自行封装UI。附播放器Demo：[IJKMoviePlayerSample](https://github.com/ChaneyLau/IJKMoviePlayer/tree/master/IJKMoviePlayerSample)
