import 'dart:convert';

import 'package:http/http.dart' as http;

import 'vimeo_error.dart';

class VimeoVideo {
  final bool liveEvent;
  final List<_VimeoQualityFile?> sources;
  final String? uri;
  final String? name;
  final dynamic description;
  final String? type;
  final String? link;
  final String? playerEmbedUrl;
  final int? duration;
  final int? width;
  final dynamic language;
  final int? height;
  final Embed? embed;
  final DateTime? createdTime;
  final DateTime? modifiedTime;
  final DateTime? releaseTime;
  final List<String>? contentRating;
  final String? contentRatingClass;
  final bool? ratingModLocked;
  final dynamic license;
  final Privacy? privacy;
  final Pictures? pictures;
  final List<dynamic>? tags;
  final Stats? stats;
  final List<dynamic>? categories;
  final Uploader? uploader;
  final VimeoVideoMetadata? metadata;
  final String? manageLink;
  final User? user;
  final dynamic parentFolder;
  final DateTime? lastUserActionEventDate;
  final ReviewPage? reviewPage;
  final Play? play;
  final App? app;
  final String? status;
  final String? resourceKey;
  final Upload? upload;
  final Play? transcode;
  final bool? isPlayable;
  final bool? hasAudio;

  VimeoVideo({
    this.liveEvent = false,
    this.width,
    this.height,
    required this.sources,
    this.uri,
    this.name,
    this.description,
    this.type,
    this.link,
    this.playerEmbedUrl,
    this.duration,
    this.language,
    this.embed,
    this.createdTime,
    this.modifiedTime,
    this.releaseTime,
    this.contentRating,
    this.contentRatingClass,
    this.ratingModLocked,
    this.license,
    this.privacy,
    this.pictures,
    this.tags,
    this.stats,
    this.categories,
    this.uploader,
    this.metadata,
    this.manageLink,
    this.user,
    this.parentFolder,
    this.lastUserActionEventDate,
    this.reviewPage,
    this.play,
    this.app,
    this.status,
    this.resourceKey,
    this.upload,
    this.transcode,
    this.isPlayable,
    this.hasAudio,
  });

  static Future<VimeoVideo> fromJsonVideoWithAuth({
    required String videoId,
    required String accessKey,
    required Map<String, dynamic> json,
  }) async {
    if (json.keys.contains("error")) {
      throw VimeoError.fromJsonAuth(json);
    }

    if (json['embed']?['badges']['live']['streaming'] ?? false) {
      Uri uri = Uri.parse("https://api.vimeo.com/me/videos/$videoId/m3u8_playback");
      var response = await http.get(uri, headers: {"Authorization": "Bearer $accessKey"});
      var body = jsonDecode(response.body);

      return VimeoVideo(width: json['width'], height: json['height'], liveEvent: true, sources: [
        _VimeoQualityFile(
          quality: _VimeoQualityFile.hls,
          file: VimeoSource(
            height: json['height'],
            width: json['width'],
            url: Uri.parse(body['m3u8_playback_url']),
          ),
        )
      ]);
    }

    var jsonFiles = (json['files'] ?? []) as List<dynamic>;
    List<_VimeoQualityFile?> files = List<_VimeoQualityFile?>.from(jsonFiles.map<_VimeoQualityFile?>((element) {
      if (element['quality'] != null && element['quality'] != _VimeoQualityFile.hls) {
        return _VimeoQualityFile(
          quality: element['quality'],
          file: VimeoSource(
            height: element['height'],
            width: element['width'],
            fps: element['fps'] is double ? element['fps'] : (element['fps'] as int).toDouble(),
            url: Uri.tryParse(element['link'] as String)!,
          ),
        );
      }
      return null;
    })).toList();

    final vimeoVideo = fromJson(json);
    return vimeoVideo.copyWith(
      liveEvent: json['embed']['badges']['live']['streaming'],
      width: json['width'],
      height: json['height'],
      sources: files,
    );
  }

  VimeoVideo copyWith({
      bool? liveEvent,
      List<_VimeoQualityFile?>? sources,
        String? uri,
        String? name,
        dynamic description,
        String? type,
        String? link,
        String? playerEmbedUrl,
        int? duration,
        int? width,
        dynamic language,
        int? height,
        Embed? embed,
        DateTime? createdTime,
        DateTime? modifiedTime,
        DateTime? releaseTime,
        List<String>? contentRating,
        String? contentRatingClass,
        bool? ratingModLocked,
        dynamic license,
        Privacy? privacy,
        Pictures? pictures,
        List<dynamic>? tags,
        Stats? stats,
        List<dynamic>? categories,
        Uploader? uploader,
        VimeoVideoMetadata? metadata,
        String? manageLink,
        User? user,
        dynamic parentFolder,
        DateTime? lastUserActionEventDate,
        ReviewPage? reviewPage,
        Play? play,
        App? app,
        String? status,
        String? resourceKey,
        Upload? upload,
        Play? transcode,
        bool? isPlayable,
        bool? hasAudio,
    }) => 
        VimeoVideo(
            sources: sources ?? this.sources,
            liveEvent: liveEvent ?? this.liveEvent,
            uri: uri ?? this.uri,
            name: name ?? this.name,
            description: description ?? this.description,
            type: type ?? this.type,
            link: link ?? this.link,
            playerEmbedUrl: playerEmbedUrl ?? this.playerEmbedUrl,
            duration: duration ?? this.duration,
            width: width ?? this.width,
            language: language ?? this.language,
            height: height ?? this.height,
            embed: embed ?? this.embed,
            createdTime: createdTime ?? this.createdTime,
            modifiedTime: modifiedTime ?? this.modifiedTime,
            releaseTime: releaseTime ?? this.releaseTime,
            contentRating: contentRating ?? this.contentRating,
            contentRatingClass: contentRatingClass ?? this.contentRatingClass,
            ratingModLocked: ratingModLocked ?? this.ratingModLocked,
            license: license ?? this.license,
            privacy: privacy ?? this.privacy,
            pictures: pictures ?? this.pictures,
            tags: tags ?? this.tags,
            stats: stats ?? this.stats,
            categories: categories ?? this.categories,
            uploader: uploader ?? this.uploader,
            metadata: metadata ?? this.metadata,
            manageLink: manageLink ?? this.manageLink,
            user: user ?? this.user,
            parentFolder: parentFolder ?? this.parentFolder,
            lastUserActionEventDate: lastUserActionEventDate ?? this.lastUserActionEventDate,
            reviewPage: reviewPage ?? this.reviewPage,
            play: play ?? this.play,
            app: app ?? this.app,
            status: status ?? this.status,
            resourceKey: resourceKey ?? this.resourceKey,
            upload: upload ?? this.upload,
            transcode: transcode ?? this.transcode,
            isPlayable: isPlayable ?? this.isPlayable,
            hasAudio: hasAudio ?? this.hasAudio,
        );

  static VimeoVideo fromJson(Map<String, dynamic> json) => VimeoVideo(
        sources: [],
        liveEvent: false,
        uri: json["uri"],
        name: json["name"],
        description: json["description"],
        type: json["type"],
        link: json["link"],
        playerEmbedUrl: json["player_embed_url"],
        duration: json["duration"],
        width: json["width"],
        language: json["language"],
        height: json["height"],
        embed: json["embed"] == null ? null : Embed.fromJson(json["embed"]),
        createdTime: json["created_time"] == null ? null : DateTime.parse(json["created_time"]),
        modifiedTime: json["modified_time"] == null ? null : DateTime.parse(json["modified_time"]),
        releaseTime: json["release_time"] == null ? null : DateTime.parse(json["release_time"]),
        contentRating: json["content_rating"] == null ? [] : List<String>.from(json["content_rating"]!.map((x) => x)),
        contentRatingClass: json["content_rating_class"],
        ratingModLocked: json["rating_mod_locked"],
        license: json["license"],
        privacy: json["privacy"] == null ? null : Privacy.fromJson(json["privacy"]),
        pictures: json["pictures"] == null ? null : Pictures.fromJson(json["pictures"]),
        tags: json["tags"] == null ? [] : List<dynamic>.from(json["tags"]!.map((x) => x)),
        stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
        categories: json["categories"] == null ? [] : List<dynamic>.from(json["categories"]!.map((x) => x)),
        uploader: json["uploader"] == null ? null : Uploader.fromJson(json["uploader"]),
        metadata: json["metadata"] == null ? null : VimeoVideoMetadata.fromJson(json["metadata"]),
        manageLink: json["manage_link"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        parentFolder: json["parent_folder"],
        lastUserActionEventDate:
            json["last_user_action_event_date"] == null ? null : DateTime.parse(json["last_user_action_event_date"]),
        reviewPage: json["review_page"] == null ? null : ReviewPage.fromJson(json["review_page"]),
        play: json["play"] == null ? null : Play.fromJson(json["play"]),
        app: json["app"] == null ? null : App.fromJson(json["app"]),
        status: json["status"],
        resourceKey: json["resource_key"],
        upload: json["upload"] == null ? null : Upload.fromJson(json["upload"]),
        transcode: json["transcode"] == null ? null : Play.fromJson(json["transcode"]),
        isPlayable: json["is_playable"],
        hasAudio: json["has_audio"],
      );

  static Future<VimeoVideo> fromJsonVideoWithoutAuth(Map<String, dynamic> json) async {
    if (json.keys.contains("message")) {
      throw VimeoError.fromJsonNoneAuth(json);
    }
    late List<_VimeoQualityFile?> files;
    bool isLive = json['video']['live_event'] != null;
    if (isLive) {
      var hls = json['request']['files']['hls'];
      var response = jsonDecode((await http.get(Uri.parse(hls['cdns']['fastly_live']['json_url']))).body);
      Uri url = Uri.parse(response['url'] as String);
      files = [
        _VimeoQualityFile(
            quality: 'hls',
            file: VimeoSource(
                height: json['video']['height'], width: json['video']['width'], fps: json['video']['fps'], url: url))
      ];
    } else {
      files = List<_VimeoQualityFile?>.from(json['request']['files']['progressive'].map<_VimeoQualityFile?>((element) {
        return _VimeoQualityFile(
          quality: element['quality'],
          file: VimeoSource(
            width: element['width'],
            height: element['height'],
            fps: element['fps'] is double ? element['fps'] : (element['fps'] as int).toDouble(),
            url: Uri.parse(element['url']),
          ),
        );
      })).toList();
    }
    return VimeoVideo(
        liveEvent: isLive, width: json['video']['width'], height: json['video']['height'], sources: files);
  }

  factory VimeoVideo.fromJsonLiveEvent(json) {
    var ret = VimeoVideo(
        liveEvent: true,
        height: json[0]['streamable_clip']['height'],
        width: json[0]['streamable_clip']['width'],
        sources: [
          _VimeoQualityFile(
              quality: _VimeoQualityFile.hls,
              file: VimeoSource(
                height: json[0]['streamable_clip']['height'],
                width: json[0]['streamable_clip']['width'],
                url: Uri.parse(json[1]['m3u8_playback_url']),
              ))
        ]);
    return ret;
  }
}

extension ExtensionVimeoVideo on VimeoVideo {
  Uri? get videoUrl {
    return defaultVideo?.url;
  }

  int get size {
    return width! > height! ? width! : height!;
  }

  double get ratio => width! / height!;

  Map<String, String> get resolutions {
    Map<String, String> ret = {};

    for (var q in sources) {
      if (q == null) {
        continue;
      }
      ret.addAll({q.quality: q.file.url.toString()});
    }

    return ret;
  }

  bool get isLive => liveEvent;

  VimeoSource? get defaultVideo {
    VimeoSource? ret = sources.first?.file;
    for (var file in sources) {
      if (file?.file.size == size) {
        ret = file?.file;
        break;
      }
    }
    return ret;
  }
}

class VimeoSource {
  final int? height;
  final int? width;
  final double? fps;
  final Uri url;

  VimeoSource({
    this.height,
    this.width,
    this.fps,
    required this.url,
  });

  factory VimeoSource.fromJson({required bool isLive, required dynamic json}) {
    return VimeoSource(
      height: json['height'],
      width: json['width'],
      fps: json['fps'],
      url: Uri.parse(json['url']),
    );
  }

  int? get size => (height == null || width == null)
      ? null
      : height! > width!
          ? height
          : width;
}

class _VimeoQualityFile {
  static const String qualityLive = "live";
  static const String hd = "hd";
  static const String sd = "sd";
  static const String hls = "hls";
  static const String quality4k = "4k";
  static const String quality8k = "8k";
  static const String quality1440p = "1440p";
  static const String quality1080p = "1080p";
  static const String quality720p = "720p";
  static const String quality540p = "540p";
  static const String quality360p = "360p";
  static const String quality240p = "240p";

  final String quality;
  final VimeoSource file;

  _VimeoQualityFile({
    required this.quality,
    required this.file,
  });
}

class App {
  App({
    this.name,
    this.uri,
  });

  final String? name;
  final String? uri;

  App copyWith({
    String? name,
    String? uri,
  }) =>
      App(
        name: name ?? this.name,
        uri: uri ?? this.uri,
      );

  factory App.fromJson(Map<String, dynamic> json) => App(
        name: json["name"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "uri": uri,
      };
}

class Embed {
  Embed({
    this.html,
    this.badges,
    this.buttons,
    this.logos,
    this.title,
    this.endScreen,
    this.playbar,
    this.pip,
    this.autopip,
    this.volume,
    this.color,
    this.eventSchedule,
    this.interactive,
    this.hasCards,
    this.outroType,
    this.uri,
    this.emailCaptureForm,
    this.speed,
  });

  final String? html;
  final Badges? badges;
  final Buttons? buttons;
  final Logos? logos;
  final Title? title;
  final List<dynamic>? endScreen;
  final bool? playbar;
  final bool? pip;
  final bool? autopip;
  final bool? volume;
  final String? color;
  final bool? eventSchedule;
  final bool? interactive;
  final bool? hasCards;
  final String? outroType;
  final dynamic uri;
  final dynamic emailCaptureForm;
  final bool? speed;

  Embed copyWith({
    String? html,
    Badges? badges,
    Buttons? buttons,
    Logos? logos,
    Title? title,
    List<dynamic>? endScreen,
    bool? playbar,
    bool? pip,
    bool? autopip,
    bool? volume,
    String? color,
    bool? eventSchedule,
    bool? interactive,
    bool? hasCards,
    String? outroType,
    dynamic uri,
    dynamic emailCaptureForm,
    bool? speed,
  }) =>
      Embed(
        html: html ?? this.html,
        badges: badges ?? this.badges,
        buttons: buttons ?? this.buttons,
        logos: logos ?? this.logos,
        title: title ?? this.title,
        endScreen: endScreen ?? this.endScreen,
        playbar: playbar ?? this.playbar,
        pip: pip ?? this.pip,
        autopip: autopip ?? this.autopip,
        volume: volume ?? this.volume,
        color: color ?? this.color,
        eventSchedule: eventSchedule ?? this.eventSchedule,
        interactive: interactive ?? this.interactive,
        hasCards: hasCards ?? this.hasCards,
        outroType: outroType ?? this.outroType,
        uri: uri ?? this.uri,
        emailCaptureForm: emailCaptureForm ?? this.emailCaptureForm,
        speed: speed ?? this.speed,
      );

  factory Embed.fromJson(Map<String, dynamic> json) => Embed(
        html: json["html"],
        badges: json["badges"] == null ? null : Badges.fromJson(json["badges"]),
        buttons: json["buttons"] == null ? null : Buttons.fromJson(json["buttons"]),
        logos: json["logos"] == null ? null : Logos.fromJson(json["logos"]),
        title: json["title"] == null ? null : Title.fromJson(json["title"]),
        endScreen: json["end_screen"] == null ? [] : List<dynamic>.from(json["end_screen"]!.map((x) => x)),
        playbar: json["playbar"],
        pip: json["pip"],
        autopip: json["autopip"],
        volume: json["volume"],
        color: json["color"],
        eventSchedule: json["event_schedule"],
        interactive: json["interactive"],
        hasCards: json["has_cards"],
        outroType: json["outro_type"],
        uri: json["uri"],
        emailCaptureForm: json["email_capture_form"],
        speed: json["speed"],
      );

  Map<String, dynamic> toJson() => {
        "html": html,
        "badges": badges?.toJson(),
        "buttons": buttons?.toJson(),
        "logos": logos?.toJson(),
        "title": title?.toJson(),
        "end_screen": endScreen == null ? [] : List<dynamic>.from(endScreen!.map((x) => x)),
        "playbar": playbar,
        "pip": pip,
        "autopip": autopip,
        "volume": volume,
        "color": color,
        "event_schedule": eventSchedule,
        "interactive": interactive,
        "has_cards": hasCards,
        "outro_type": outroType,
        "uri": uri,
        "email_capture_form": emailCaptureForm,
        "speed": speed,
      };
}

class Badges {
  Badges({
    this.hdr,
    this.live,
    this.staffPick,
    this.vod,
    this.weekendChallenge,
  });

  final bool? hdr;
  final Live? live;
  final StaffPick? staffPick;
  final bool? vod;
  final bool? weekendChallenge;

  Badges copyWith({
    bool? hdr,
    Live? live,
    StaffPick? staffPick,
    bool? vod,
    bool? weekendChallenge,
  }) =>
      Badges(
        hdr: hdr ?? this.hdr,
        live: live ?? this.live,
        staffPick: staffPick ?? this.staffPick,
        vod: vod ?? this.vod,
        weekendChallenge: weekendChallenge ?? this.weekendChallenge,
      );

  factory Badges.fromJson(Map<String, dynamic> json) => Badges(
        hdr: json["hdr"],
        live: json["live"] == null ? null : Live.fromJson(json["live"]),
        staffPick: json["staff_pick"] == null ? null : StaffPick.fromJson(json["staff_pick"]),
        vod: json["vod"],
        weekendChallenge: json["weekend_challenge"],
      );

  Map<String, dynamic> toJson() => {
        "hdr": hdr,
        "live": live?.toJson(),
        "staff_pick": staffPick?.toJson(),
        "vod": vod,
        "weekend_challenge": weekendChallenge,
      };
}

class Live {
  Live({
    this.streaming,
    this.archived,
  });

  final bool? streaming;
  final bool? archived;

  Live copyWith({
    bool? streaming,
    bool? archived,
  }) =>
      Live(
        streaming: streaming ?? this.streaming,
        archived: archived ?? this.archived,
      );

  factory Live.fromJson(Map<String, dynamic> json) => Live(
        streaming: json["streaming"],
        archived: json["archived"],
      );

  Map<String, dynamic> toJson() => {
        "streaming": streaming,
        "archived": archived,
      };
}

class StaffPick {
  StaffPick({
    this.normal,
    this.bestOfTheMonth,
    this.bestOfTheYear,
    this.premiere,
  });

  final bool? normal;
  final bool? bestOfTheMonth;
  final bool? bestOfTheYear;
  final bool? premiere;

  StaffPick copyWith({
    bool? normal,
    bool? bestOfTheMonth,
    bool? bestOfTheYear,
    bool? premiere,
  }) =>
      StaffPick(
        normal: normal ?? this.normal,
        bestOfTheMonth: bestOfTheMonth ?? this.bestOfTheMonth,
        bestOfTheYear: bestOfTheYear ?? this.bestOfTheYear,
        premiere: premiere ?? this.premiere,
      );

  factory StaffPick.fromJson(Map<String, dynamic> json) => StaffPick(
        normal: json["normal"],
        bestOfTheMonth: json["best_of_the_month"],
        bestOfTheYear: json["best_of_the_year"],
        premiere: json["premiere"],
      );

  Map<String, dynamic> toJson() => {
        "normal": normal,
        "best_of_the_month": bestOfTheMonth,
        "best_of_the_year": bestOfTheYear,
        "premiere": premiere,
      };
}

class Buttons {
  Buttons({
    this.watchlater,
    this.share,
    this.embed,
    this.hd,
    this.fullscreen,
    this.scaling,
    this.like,
  });

  final bool? watchlater;
  final bool? share;
  final bool? embed;
  final bool? hd;
  final bool? fullscreen;
  final bool? scaling;
  final bool? like;

  Buttons copyWith({
    bool? watchlater,
    bool? share,
    bool? embed,
    bool? hd,
    bool? fullscreen,
    bool? scaling,
    bool? like,
  }) =>
      Buttons(
        watchlater: watchlater ?? this.watchlater,
        share: share ?? this.share,
        embed: embed ?? this.embed,
        hd: hd ?? this.hd,
        fullscreen: fullscreen ?? this.fullscreen,
        scaling: scaling ?? this.scaling,
        like: like ?? this.like,
      );

  factory Buttons.fromJson(Map<String, dynamic> json) => Buttons(
        watchlater: json["watchlater"],
        share: json["share"],
        embed: json["embed"],
        hd: json["hd"],
        fullscreen: json["fullscreen"],
        scaling: json["scaling"],
        like: json["like"],
      );

  Map<String, dynamic> toJson() => {
        "watchlater": watchlater,
        "share": share,
        "embed": embed,
        "hd": hd,
        "fullscreen": fullscreen,
        "scaling": scaling,
        "like": like,
      };
}

class Logos {
  Logos({
    this.vimeo,
    this.custom,
  });

  final bool? vimeo;
  final Custom? custom;

  Logos copyWith({
    bool? vimeo,
    Custom? custom,
  }) =>
      Logos(
        vimeo: vimeo ?? this.vimeo,
        custom: custom ?? this.custom,
      );

  factory Logos.fromJson(Map<String, dynamic> json) => Logos(
        vimeo: json["vimeo"],
        custom: json["custom"] == null ? null : Custom.fromJson(json["custom"]),
      );

  Map<String, dynamic> toJson() => {
        "vimeo": vimeo,
        "custom": custom?.toJson(),
      };
}

class Custom {
  Custom({
    this.active,
    this.url,
    this.link,
    this.useLink,
    this.sticky,
  });

  final bool? active;
  final dynamic url;
  final dynamic link;
  final bool? useLink;
  final bool? sticky;

  Custom copyWith({
    bool? active,
    dynamic url,
    dynamic link,
    bool? useLink,
    bool? sticky,
  }) =>
      Custom(
        active: active ?? this.active,
        url: url ?? this.url,
        link: link ?? this.link,
        useLink: useLink ?? this.useLink,
        sticky: sticky ?? this.sticky,
      );

  factory Custom.fromJson(Map<String, dynamic> json) => Custom(
        active: json["active"],
        url: json["url"],
        link: json["link"],
        useLink: json["use_link"],
        sticky: json["sticky"],
      );

  Map<String, dynamic> toJson() => {
        "active": active,
        "url": url,
        "link": link,
        "use_link": useLink,
        "sticky": sticky,
      };
}

class Title {
  Title({
    this.name,
    this.owner,
    this.portrait,
  });

  final String? name;
  final String? owner;
  final String? portrait;

  Title copyWith({
    String? name,
    String? owner,
    String? portrait,
  }) =>
      Title(
        name: name ?? this.name,
        owner: owner ?? this.owner,
        portrait: portrait ?? this.portrait,
      );

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        name: json["name"],
        owner: json["owner"],
        portrait: json["portrait"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "owner": owner,
        "portrait": portrait,
      };
}

class VimeoVideoMetadata {
  VimeoVideoMetadata({
    this.connections,
    this.interactions,
    this.isVimeoCreate,
    this.isScreenRecord,
  });

  final PurpleConnections? connections;
  final Interactions? interactions;
  final bool? isVimeoCreate;
  final bool? isScreenRecord;

  VimeoVideoMetadata copyWith({
    PurpleConnections? connections,
    Interactions? interactions,
    bool? isVimeoCreate,
    bool? isScreenRecord,
  }) =>
      VimeoVideoMetadata(
        connections: connections ?? this.connections,
        interactions: interactions ?? this.interactions,
        isVimeoCreate: isVimeoCreate ?? this.isVimeoCreate,
        isScreenRecord: isScreenRecord ?? this.isScreenRecord,
      );

  factory VimeoVideoMetadata.fromJson(Map<String, dynamic> json) => VimeoVideoMetadata(
        connections: json["connections"] == null ? null : PurpleConnections.fromJson(json["connections"]),
        interactions: json["interactions"] == null ? null : Interactions.fromJson(json["interactions"]),
        isVimeoCreate: json["is_vimeo_create"],
        isScreenRecord: json["is_screen_record"],
      );

  Map<String, dynamic> toJson() => {
        "connections": connections?.toJson(),
        "interactions": interactions?.toJson(),
        "is_vimeo_create": isVimeoCreate,
        "is_screen_record": isScreenRecord,
      };
}

class PurpleConnections {
  PurpleConnections({
    this.comments,
    this.credits,
    this.likes,
    this.pictures,
    this.texttracks,
    this.related,
    this.recommendations,
    this.albums,
    this.availableAlbums,
    this.availableChannels,
    this.versions,
  });

  final Albums? comments;
  final Albums? credits;
  final Albums? likes;
  final Albums? pictures;
  final Albums? texttracks;
  final dynamic related;
  final Recommendations? recommendations;
  final Albums? albums;
  final Albums? availableAlbums;
  final Albums? availableChannels;
  final Versions? versions;

  PurpleConnections copyWith({
    Albums? comments,
    Albums? credits,
    Albums? likes,
    Albums? pictures,
    Albums? texttracks,
    dynamic related,
    Recommendations? recommendations,
    Albums? albums,
    Albums? availableAlbums,
    Albums? availableChannels,
    Versions? versions,
  }) =>
      PurpleConnections(
        comments: comments ?? this.comments,
        credits: credits ?? this.credits,
        likes: likes ?? this.likes,
        pictures: pictures ?? this.pictures,
        texttracks: texttracks ?? this.texttracks,
        related: related ?? this.related,
        recommendations: recommendations ?? this.recommendations,
        albums: albums ?? this.albums,
        availableAlbums: availableAlbums ?? this.availableAlbums,
        availableChannels: availableChannels ?? this.availableChannels,
        versions: versions ?? this.versions,
      );

  factory PurpleConnections.fromJson(Map<String, dynamic> json) => PurpleConnections(
        comments: json["comments"] == null ? null : Albums.fromJson(json["comments"]),
        credits: json["credits"] == null ? null : Albums.fromJson(json["credits"]),
        likes: json["likes"] == null ? null : Albums.fromJson(json["likes"]),
        pictures: json["pictures"] == null ? null : Albums.fromJson(json["pictures"]),
        texttracks: json["texttracks"] == null ? null : Albums.fromJson(json["texttracks"]),
        related: json["related"],
        recommendations: json["recommendations"] == null ? null : Recommendations.fromJson(json["recommendations"]),
        albums: json["albums"] == null ? null : Albums.fromJson(json["albums"]),
        availableAlbums: json["available_albums"] == null ? null : Albums.fromJson(json["available_albums"]),
        availableChannels: json["available_channels"] == null ? null : Albums.fromJson(json["available_channels"]),
        versions: json["versions"] == null ? null : Versions.fromJson(json["versions"]),
      );

  Map<String, dynamic> toJson() => {
        "comments": comments?.toJson(),
        "credits": credits?.toJson(),
        "likes": likes?.toJson(),
        "pictures": pictures?.toJson(),
        "texttracks": texttracks?.toJson(),
        "related": related,
        "recommendations": recommendations?.toJson(),
        "albums": albums?.toJson(),
        "available_albums": availableAlbums?.toJson(),
        "available_channels": availableChannels?.toJson(),
        "versions": versions?.toJson(),
      };
}

class Albums {
  Albums({
    this.uri,
    this.options,
    this.total,
  });

  final String? uri;
  final List<Option>? options;
  final int? total;

  Albums copyWith({
    String? uri,
    List<Option>? options,
    int? total,
  }) =>
      Albums(
        uri: uri ?? this.uri,
        options: options ?? this.options,
        total: total ?? this.total,
      );

  factory Albums.fromJson(Map<String, dynamic> json) => Albums(
        uri: json["uri"],
        options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => optionValues.map[x]!)),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "uri": uri,
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => optionValues.reverse[x])),
        "total": total,
      };
}

enum Option { GET, PATCH, POST }

final optionValues = EnumValues({"GET": Option.GET, "PATCH": Option.PATCH, "POST": Option.POST});

class Recommendations {
  Recommendations({
    this.uri,
    this.options,
  });

  final String? uri;
  final List<String>? options;

  Recommendations copyWith({
    String? uri,
    List<String>? options,
  }) =>
      Recommendations(
        uri: uri ?? this.uri,
        options: options ?? this.options,
      );

  factory Recommendations.fromJson(Map<String, dynamic> json) => Recommendations(
        uri: json["uri"],
        options: json["options"] == null ? [] : List<String>.from(json["options"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "uri": uri,
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
      };
}

class Versions {
  Versions({
    this.uri,
    this.options,
    this.total,
    this.currentUri,
    this.resourceKey,
    this.latestIncompleteVersion,
  });

  final String? uri;
  final List<Option>? options;
  final int? total;
  final String? currentUri;
  final String? resourceKey;
  final dynamic latestIncompleteVersion;

  Versions copyWith({
    String? uri,
    List<Option>? options,
    int? total,
    String? currentUri,
    String? resourceKey,
    dynamic latestIncompleteVersion,
  }) =>
      Versions(
        uri: uri ?? this.uri,
        options: options ?? this.options,
        total: total ?? this.total,
        currentUri: currentUri ?? this.currentUri,
        resourceKey: resourceKey ?? this.resourceKey,
        latestIncompleteVersion: latestIncompleteVersion ?? this.latestIncompleteVersion,
      );

  factory Versions.fromJson(Map<String, dynamic> json) => Versions(
        uri: json["uri"],
        options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => optionValues.map[x]!)),
        total: json["total"],
        currentUri: json["current_uri"],
        resourceKey: json["resource_key"],
        latestIncompleteVersion: json["latest_incomplete_version"],
      );

  Map<String, dynamic> toJson() => {
        "uri": uri,
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => optionValues.reverse[x])),
        "total": total,
        "current_uri": currentUri,
        "resource_key": resourceKey,
        "latest_incomplete_version": latestIncompleteVersion,
      };
}

class Interactions {
  Interactions({
    this.watchlater,
    this.report,
    this.viewTeamMembers,
    this.edit,
    this.editContentRating,
    this.editPrivacy,
    this.delete,
    this.canUpdatePrivacyToPublic,
    this.trim,
    this.validate,
  });

  final Watchlater? watchlater;
  final Report? report;
  final Recommendations? viewTeamMembers;
  final Edit? edit;
  final EditContentRating? editContentRating;
  final EditPrivacy? editPrivacy;
  final Recommendations? delete;
  final Recommendations? canUpdatePrivacyToPublic;
  final Recommendations? trim;
  final Recommendations? validate;

  Interactions copyWith({
    Watchlater? watchlater,
    Report? report,
    Recommendations? viewTeamMembers,
    Edit? edit,
    EditContentRating? editContentRating,
    EditPrivacy? editPrivacy,
    Recommendations? delete,
    Recommendations? canUpdatePrivacyToPublic,
    Recommendations? trim,
    Recommendations? validate,
  }) =>
      Interactions(
        watchlater: watchlater ?? this.watchlater,
        report: report ?? this.report,
        viewTeamMembers: viewTeamMembers ?? this.viewTeamMembers,
        edit: edit ?? this.edit,
        editContentRating: editContentRating ?? this.editContentRating,
        editPrivacy: editPrivacy ?? this.editPrivacy,
        delete: delete ?? this.delete,
        canUpdatePrivacyToPublic: canUpdatePrivacyToPublic ?? this.canUpdatePrivacyToPublic,
        trim: trim ?? this.trim,
        validate: validate ?? this.validate,
      );

  factory Interactions.fromJson(Map<String, dynamic> json) => Interactions(
        watchlater: json["watchlater"] == null ? null : Watchlater.fromJson(json["watchlater"]),
        report: json["report"] == null ? null : Report.fromJson(json["report"]),
        viewTeamMembers: json["view_team_members"] == null ? null : Recommendations.fromJson(json["view_team_members"]),
        edit: json["edit"] == null ? null : Edit.fromJson(json["edit"]),
        editContentRating:
            json["edit_content_rating"] == null ? null : EditContentRating.fromJson(json["edit_content_rating"]),
        editPrivacy: json["edit_privacy"] == null ? null : EditPrivacy.fromJson(json["edit_privacy"]),
        delete: json["delete"] == null ? null : Recommendations.fromJson(json["delete"]),
        canUpdatePrivacyToPublic: json["can_update_privacy_to_public"] == null
            ? null
            : Recommendations.fromJson(json["can_update_privacy_to_public"]),
        trim: json["trim"] == null ? null : Recommendations.fromJson(json["trim"]),
        validate: json["validate"] == null ? null : Recommendations.fromJson(json["validate"]),
      );

  Map<String, dynamic> toJson() => {
        "watchlater": watchlater?.toJson(),
        "report": report?.toJson(),
        "view_team_members": viewTeamMembers?.toJson(),
        "edit": edit?.toJson(),
        "edit_content_rating": editContentRating?.toJson(),
        "edit_privacy": editPrivacy?.toJson(),
        "delete": delete?.toJson(),
        "can_update_privacy_to_public": canUpdatePrivacyToPublic?.toJson(),
        "trim": trim?.toJson(),
        "validate": validate?.toJson(),
      };
}

class Edit {
  Edit({
    this.uri,
    this.options,
    this.blockedFields,
  });

  final String? uri;
  final List<Option>? options;
  final List<String>? blockedFields;

  Edit copyWith({
    String? uri,
    List<Option>? options,
    List<String>? blockedFields,
  }) =>
      Edit(
        uri: uri ?? this.uri,
        options: options ?? this.options,
        blockedFields: blockedFields ?? this.blockedFields,
      );

  factory Edit.fromJson(Map<String, dynamic> json) => Edit(
        uri: json["uri"],
        options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => optionValues.map[x]!)),
        blockedFields: json["blocked_fields"] == null ? [] : List<String>.from(json["blocked_fields"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "uri": uri,
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => optionValues.reverse[x])),
        "blocked_fields": blockedFields == null ? [] : List<dynamic>.from(blockedFields!.map((x) => x)),
      };
}

class EditContentRating {
  EditContentRating({
    this.uri,
    this.options,
    this.contentRating,
  });

  final String? uri;
  final List<Option>? options;
  final List<String>? contentRating;

  EditContentRating copyWith({
    String? uri,
    List<Option>? options,
    List<String>? contentRating,
  }) =>
      EditContentRating(
        uri: uri ?? this.uri,
        options: options ?? this.options,
        contentRating: contentRating ?? this.contentRating,
      );

  factory EditContentRating.fromJson(Map<String, dynamic> json) => EditContentRating(
        uri: json["uri"],
        options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => optionValues.map[x]!)),
        contentRating: json["content_rating"] == null ? [] : List<String>.from(json["content_rating"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "uri": uri,
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => optionValues.reverse[x])),
        "content_rating": contentRating == null ? [] : List<dynamic>.from(contentRating!.map((x) => x)),
      };
}

class EditPrivacy {
  EditPrivacy({
    this.uri,
    this.options,
    this.contentType,
    this.properties,
  });

  final String? uri;
  final List<Option>? options;
  final String? contentType;
  final List<Property>? properties;

  EditPrivacy copyWith({
    String? uri,
    List<Option>? options,
    String? contentType,
    List<Property>? properties,
  }) =>
      EditPrivacy(
        uri: uri ?? this.uri,
        options: options ?? this.options,
        contentType: contentType ?? this.contentType,
        properties: properties ?? this.properties,
      );

  factory EditPrivacy.fromJson(Map<String, dynamic> json) => EditPrivacy(
        uri: json["uri"],
        options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => optionValues.map[x]!)),
        contentType: json["content_type"],
        properties:
            json["properties"] == null ? [] : List<Property>.from(json["properties"]!.map((x) => Property.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uri": uri,
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => optionValues.reverse[x])),
        "content_type": contentType,
        "properties": properties == null ? [] : List<dynamic>.from(properties!.map((x) => x.toJson())),
      };
}

class Property {
  Property({
    this.name,
    this.required,
    this.options,
  });

  final String? name;
  final bool? required;
  final List<String>? options;

  Property copyWith({
    String? name,
    bool? required,
    List<String>? options,
  }) =>
      Property(
        name: name ?? this.name,
        required: required ?? this.required,
        options: options ?? this.options,
      );

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        name: json["name"],
        required: json["required"],
        options: json["options"] == null ? [] : List<String>.from(json["options"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "required": required,
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
      };
}

class Report {
  Report({
    this.uri,
    this.options,
    this.reason,
  });

  final String? uri;
  final List<Option>? options;
  final List<String>? reason;

  Report copyWith({
    String? uri,
    List<Option>? options,
    List<String>? reason,
  }) =>
      Report(
        uri: uri ?? this.uri,
        options: options ?? this.options,
        reason: reason ?? this.reason,
      );

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        uri: json["uri"],
        options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => optionValues.map[x]!)),
        reason: json["reason"] == null ? [] : List<String>.from(json["reason"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "uri": uri,
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => optionValues.reverse[x])),
        "reason": reason == null ? [] : List<dynamic>.from(reason!.map((x) => x)),
      };
}

class Watchlater {
  Watchlater({
    this.uri,
    this.options,
    this.added,
    this.addedTime,
  });

  final String? uri;
  final List<String>? options;
  final bool? added;
  final dynamic addedTime;

  Watchlater copyWith({
    String? uri,
    List<String>? options,
    bool? added,
    dynamic addedTime,
  }) =>
      Watchlater(
        uri: uri ?? this.uri,
        options: options ?? this.options,
        added: added ?? this.added,
        addedTime: addedTime ?? this.addedTime,
      );

  factory Watchlater.fromJson(Map<String, dynamic> json) => Watchlater(
        uri: json["uri"],
        options: json["options"] == null ? [] : List<String>.from(json["options"]!.map((x) => x)),
        added: json["added"],
        addedTime: json["added_time"],
      );

  Map<String, dynamic> toJson() => {
        "uri": uri,
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
        "added": added,
        "added_time": addedTime,
      };
}

class Pictures {
  Pictures({
    this.uri,
    this.active,
    this.type,
    this.baseLink,
    this.sizes,
    this.resourceKey,
    this.defaultPicture,
  });

  final String? uri;
  final bool? active;
  final String? type;
  final String? baseLink;
  final List<Size>? sizes;
  final String? resourceKey;
  final bool? defaultPicture;

  Pictures copyWith({
    String? uri,
    bool? active,
    String? type,
    String? baseLink,
    List<Size>? sizes,
    String? resourceKey,
    bool? defaultPicture,
  }) =>
      Pictures(
        uri: uri ?? this.uri,
        active: active ?? this.active,
        type: type ?? this.type,
        baseLink: baseLink ?? this.baseLink,
        sizes: sizes ?? this.sizes,
        resourceKey: resourceKey ?? this.resourceKey,
        defaultPicture: defaultPicture ?? this.defaultPicture,
      );

  factory Pictures.fromJson(Map<String, dynamic> json) => Pictures(
        uri: json["uri"],
        active: json["active"],
        type: json["type"],
        baseLink: json["base_link"],
        sizes: json["sizes"] == null ? [] : List<Size>.from(json["sizes"]!.map((x) => Size.fromJson(x))),
        resourceKey: json["resource_key"],
        defaultPicture: json["default_picture"],
      );

  Map<String, dynamic> toJson() => {
        "uri": uri,
        "active": active,
        "type": type,
        "base_link": baseLink,
        "sizes": sizes == null ? [] : List<dynamic>.from(sizes!.map((x) => x.toJson())),
        "resource_key": resourceKey,
        "default_picture": defaultPicture,
      };
}

class Size {
  Size({
    this.width,
    this.height,
    this.link,
    this.linkWithPlayButton,
  });

  final int? width;
  final int? height;
  final String? link;
  final String? linkWithPlayButton;

  Size copyWith({
    int? width,
    int? height,
    String? link,
    String? linkWithPlayButton,
  }) =>
      Size(
        width: width ?? this.width,
        height: height ?? this.height,
        link: link ?? this.link,
        linkWithPlayButton: linkWithPlayButton ?? this.linkWithPlayButton,
      );

  factory Size.fromJson(Map<String, dynamic> json) => Size(
        width: json["width"],
        height: json["height"],
        link: json["link"],
        linkWithPlayButton: json["link_with_play_button"],
      );

  Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
        "link": link,
        "link_with_play_button": linkWithPlayButton,
      };
}

class Play {
  Play({
    this.status,
  });

  final String? status;

  Play copyWith({
    String? status,
  }) =>
      Play(
        status: status ?? this.status,
      );

  factory Play.fromJson(Map<String, dynamic> json) => Play(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}

class Privacy {
  Privacy({
    this.view,
    this.embed,
    this.download,
    this.add,
    this.comments,
    this.allowShareLink,
  });

  final String? view;
  final String? embed;
  final bool? download;
  final bool? add;
  final String? comments;
  final bool? allowShareLink;

  Privacy copyWith({
    String? view,
    String? embed,
    bool? download,
    bool? add,
    String? comments,
    bool? allowShareLink,
  }) =>
      Privacy(
        view: view ?? this.view,
        embed: embed ?? this.embed,
        download: download ?? this.download,
        add: add ?? this.add,
        comments: comments ?? this.comments,
        allowShareLink: allowShareLink ?? this.allowShareLink,
      );

  factory Privacy.fromJson(Map<String, dynamic> json) => Privacy(
        view: json["view"],
        embed: json["embed"],
        download: json["download"],
        add: json["add"],
        comments: json["comments"],
        allowShareLink: json["allow_share_link"],
      );

  Map<String, dynamic> toJson() => {
        "view": view,
        "embed": embed,
        "download": download,
        "add": add,
        "comments": comments,
        "allow_share_link": allowShareLink,
      };
}

class ReviewPage {
  ReviewPage({
    this.active,
    this.link,
    this.isShareable,
  });

  final bool? active;
  final String? link;
  final bool? isShareable;

  ReviewPage copyWith({
    bool? active,
    String? link,
    bool? isShareable,
  }) =>
      ReviewPage(
        active: active ?? this.active,
        link: link ?? this.link,
        isShareable: isShareable ?? this.isShareable,
      );

  factory ReviewPage.fromJson(Map<String, dynamic> json) => ReviewPage(
        active: json["active"],
        link: json["link"],
        isShareable: json["is_shareable"],
      );

  Map<String, dynamic> toJson() => {
        "active": active,
        "link": link,
        "is_shareable": isShareable,
      };
}

class Stats {
  Stats({
    this.plays,
  });

  final int? plays;

  Stats copyWith({
    int? plays,
  }) =>
      Stats(
        plays: plays ?? this.plays,
      );

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        plays: json["plays"],
      );

  Map<String, dynamic> toJson() => {
        "plays": plays,
      };
}

class Upload {
  Upload({
    this.status,
    this.link,
    this.uploadLink,
    this.completeUri,
    this.form,
    this.approach,
    this.size,
    this.redirectUrl,
  });

  final String? status;
  final dynamic link;
  final dynamic uploadLink;
  final dynamic completeUri;
  final dynamic form;
  final dynamic approach;
  final dynamic size;
  final dynamic redirectUrl;

  Upload copyWith({
    String? status,
    dynamic link,
    dynamic uploadLink,
    dynamic completeUri,
    dynamic form,
    dynamic approach,
    dynamic size,
    dynamic redirectUrl,
  }) =>
      Upload(
        status: status ?? this.status,
        link: link ?? this.link,
        uploadLink: uploadLink ?? this.uploadLink,
        completeUri: completeUri ?? this.completeUri,
        form: form ?? this.form,
        approach: approach ?? this.approach,
        size: size ?? this.size,
        redirectUrl: redirectUrl ?? this.redirectUrl,
      );

  factory Upload.fromJson(Map<String, dynamic> json) => Upload(
        status: json["status"],
        link: json["link"],
        uploadLink: json["upload_link"],
        completeUri: json["complete_uri"],
        form: json["form"],
        approach: json["approach"],
        size: json["size"],
        redirectUrl: json["redirect_url"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "link": link,
        "upload_link": uploadLink,
        "complete_uri": completeUri,
        "form": form,
        "approach": approach,
        "size": size,
        "redirect_url": redirectUrl,
      };
}

class Uploader {
  Uploader({
    this.pictures,
  });

  final Pictures? pictures;

  Uploader copyWith({
    Pictures? pictures,
  }) =>
      Uploader(
        pictures: pictures ?? this.pictures,
      );

  factory Uploader.fromJson(Map<String, dynamic> json) => Uploader(
        pictures: json["pictures"] == null ? null : Pictures.fromJson(json["pictures"]),
      );

  Map<String, dynamic> toJson() => {
        "pictures": pictures?.toJson(),
      };
}

class User {
  User({
    this.uri,
    this.name,
    this.link,
    this.capabilities,
    this.location,
    this.gender,
    this.bio,
    this.shortBio,
    this.createdTime,
    this.pictures,
    this.websites,
    this.metadata,
    this.locationDetails,
    this.skills,
    this.availableForHire,
    this.canWorkRemotely,
    this.preferences,
    this.contentFilter,
    this.uploadQuota,
    this.resourceKey,
    this.account,
  });

  final String? uri;
  final String? name;
  final String? link;
  final Capabilities? capabilities;
  final String? location;
  final String? gender;
  final dynamic bio;
  final dynamic shortBio;
  final DateTime? createdTime;
  final Pictures? pictures;
  final List<dynamic>? websites;
  final UserMetadata? metadata;
  final LocationDetails? locationDetails;
  final List<dynamic>? skills;
  final bool? availableForHire;
  final bool? canWorkRemotely;
  final Preferences? preferences;
  final List<String>? contentFilter;
  final UploadQuota? uploadQuota;
  final String? resourceKey;
  final String? account;

  User copyWith({
    String? uri,
    String? name,
    String? link,
    Capabilities? capabilities,
    String? location,
    String? gender,
    dynamic bio,
    dynamic shortBio,
    DateTime? createdTime,
    Pictures? pictures,
    List<dynamic>? websites,
    UserMetadata? metadata,
    LocationDetails? locationDetails,
    List<dynamic>? skills,
    bool? availableForHire,
    bool? canWorkRemotely,
    Preferences? preferences,
    List<String>? contentFilter,
    UploadQuota? uploadQuota,
    String? resourceKey,
    String? account,
  }) =>
      User(
        uri: uri ?? this.uri,
        name: name ?? this.name,
        link: link ?? this.link,
        capabilities: capabilities ?? this.capabilities,
        location: location ?? this.location,
        gender: gender ?? this.gender,
        bio: bio ?? this.bio,
        shortBio: shortBio ?? this.shortBio,
        createdTime: createdTime ?? this.createdTime,
        pictures: pictures ?? this.pictures,
        websites: websites ?? this.websites,
        metadata: metadata ?? this.metadata,
        locationDetails: locationDetails ?? this.locationDetails,
        skills: skills ?? this.skills,
        availableForHire: availableForHire ?? this.availableForHire,
        canWorkRemotely: canWorkRemotely ?? this.canWorkRemotely,
        preferences: preferences ?? this.preferences,
        contentFilter: contentFilter ?? this.contentFilter,
        uploadQuota: uploadQuota ?? this.uploadQuota,
        resourceKey: resourceKey ?? this.resourceKey,
        account: account ?? this.account,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        uri: json["uri"],
        name: json["name"],
        link: json["link"],
        capabilities: json["capabilities"] == null ? null : Capabilities.fromJson(json["capabilities"]),
        location: json["location"],
        gender: json["gender"],
        bio: json["bio"],
        shortBio: json["short_bio"],
        createdTime: json["created_time"] == null ? null : DateTime.parse(json["created_time"]),
        pictures: json["pictures"] == null ? null : Pictures.fromJson(json["pictures"]),
        websites: json["websites"] == null ? [] : List<dynamic>.from(json["websites"]!.map((x) => x)),
        metadata: json["metadata"] == null ? null : UserMetadata.fromJson(json["metadata"]),
        locationDetails: json["location_details"] == null ? null : LocationDetails.fromJson(json["location_details"]),
        skills: json["skills"] == null ? [] : List<dynamic>.from(json["skills"]!.map((x) => x)),
        availableForHire: json["available_for_hire"],
        canWorkRemotely: json["can_work_remotely"],
        preferences: json["preferences"] == null ? null : Preferences.fromJson(json["preferences"]),
        contentFilter: json["content_filter"] == null ? [] : List<String>.from(json["content_filter"]!.map((x) => x)),
        uploadQuota: json["upload_quota"] == null ? null : UploadQuota.fromJson(json["upload_quota"]),
        resourceKey: json["resource_key"],
        account: json["account"],
      );

  Map<String, dynamic> toJson() => {
        "uri": uri,
        "name": name,
        "link": link,
        "capabilities": capabilities?.toJson(),
        "location": location,
        "gender": gender,
        "bio": bio,
        "short_bio": shortBio,
        "created_time": createdTime?.toIso8601String(),
        "pictures": pictures?.toJson(),
        "websites": websites == null ? [] : List<dynamic>.from(websites!.map((x) => x)),
        "metadata": metadata?.toJson(),
        "location_details": locationDetails?.toJson(),
        "skills": skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
        "available_for_hire": availableForHire,
        "can_work_remotely": canWorkRemotely,
        "preferences": preferences?.toJson(),
        "content_filter": contentFilter == null ? [] : List<dynamic>.from(contentFilter!.map((x) => x)),
        "upload_quota": uploadQuota?.toJson(),
        "resource_key": resourceKey,
        "account": account,
      };
}

class Capabilities {
  Capabilities({
    this.hasLiveSubscription,
    this.hasEnterpriseLihp,
    this.hasSvvTimecodedComments,
    this.hasSimplifiedEnterpriseAccount,
  });

  final bool? hasLiveSubscription;
  final bool? hasEnterpriseLihp;
  final bool? hasSvvTimecodedComments;
  final bool? hasSimplifiedEnterpriseAccount;

  Capabilities copyWith({
    bool? hasLiveSubscription,
    bool? hasEnterpriseLihp,
    bool? hasSvvTimecodedComments,
    bool? hasSimplifiedEnterpriseAccount,
  }) =>
      Capabilities(
        hasLiveSubscription: hasLiveSubscription ?? this.hasLiveSubscription,
        hasEnterpriseLihp: hasEnterpriseLihp ?? this.hasEnterpriseLihp,
        hasSvvTimecodedComments: hasSvvTimecodedComments ?? this.hasSvvTimecodedComments,
        hasSimplifiedEnterpriseAccount: hasSimplifiedEnterpriseAccount ?? this.hasSimplifiedEnterpriseAccount,
      );

  factory Capabilities.fromJson(Map<String, dynamic> json) => Capabilities(
        hasLiveSubscription: json["hasLiveSubscription"],
        hasEnterpriseLihp: json["hasEnterpriseLihp"],
        hasSvvTimecodedComments: json["hasSvvTimecodedComments"],
        hasSimplifiedEnterpriseAccount: json["hasSimplifiedEnterpriseAccount"],
      );

  Map<String, dynamic> toJson() => {
        "hasLiveSubscription": hasLiveSubscription,
        "hasEnterpriseLihp": hasEnterpriseLihp,
        "hasSvvTimecodedComments": hasSvvTimecodedComments,
        "hasSimplifiedEnterpriseAccount": hasSimplifiedEnterpriseAccount,
      };
}

class LocationDetails {
  LocationDetails({
    this.formattedAddress,
    this.latitude,
    this.longitude,
    this.city,
    this.state,
    this.neighborhood,
    this.subLocality,
    this.stateIsoCode,
    this.country,
    this.countryIsoCode,
  });

  final String? formattedAddress;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic city;
  final dynamic state;
  final dynamic neighborhood;
  final dynamic subLocality;
  final dynamic stateIsoCode;
  final dynamic country;
  final dynamic countryIsoCode;

  LocationDetails copyWith({
    String? formattedAddress,
    dynamic latitude,
    dynamic longitude,
    dynamic city,
    dynamic state,
    dynamic neighborhood,
    dynamic subLocality,
    dynamic stateIsoCode,
    dynamic country,
    dynamic countryIsoCode,
  }) =>
      LocationDetails(
        formattedAddress: formattedAddress ?? this.formattedAddress,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        city: city ?? this.city,
        state: state ?? this.state,
        neighborhood: neighborhood ?? this.neighborhood,
        subLocality: subLocality ?? this.subLocality,
        stateIsoCode: stateIsoCode ?? this.stateIsoCode,
        country: country ?? this.country,
        countryIsoCode: countryIsoCode ?? this.countryIsoCode,
      );

  factory LocationDetails.fromJson(Map<String, dynamic> json) => LocationDetails(
        formattedAddress: json["formatted_address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        city: json["city"],
        state: json["state"],
        neighborhood: json["neighborhood"],
        subLocality: json["sub_locality"],
        stateIsoCode: json["state_iso_code"],
        country: json["country"],
        countryIsoCode: json["country_iso_code"],
      );

  Map<String, dynamic> toJson() => {
        "formatted_address": formattedAddress,
        "latitude": latitude,
        "longitude": longitude,
        "city": city,
        "state": state,
        "neighborhood": neighborhood,
        "sub_locality": subLocality,
        "state_iso_code": stateIsoCode,
        "country": country,
        "country_iso_code": countryIsoCode,
      };
}

class UserMetadata {
  UserMetadata({
    this.connections,
  });

  final FluffyConnections? connections;

  UserMetadata copyWith({
    FluffyConnections? connections,
  }) =>
      UserMetadata(
        connections: connections ?? this.connections,
      );

  factory UserMetadata.fromJson(Map<String, dynamic> json) => UserMetadata(
        connections: json["connections"] == null ? null : FluffyConnections.fromJson(json["connections"]),
      );

  Map<String, dynamic> toJson() => {
        "connections": connections?.toJson(),
      };
}

class FluffyConnections {
  FluffyConnections({
    this.albums,
    this.appearances,
    this.categories,
    this.channels,
    this.feed,
    this.followers,
    this.following,
    this.groups,
    this.likes,
    this.membership,
    this.moderatedChannels,
    this.portfolios,
    this.videos,
    this.watchlater,
    this.shared,
    this.pictures,
    this.watchedVideos,
    this.foldersRoot,
    this.folders,
    this.teams,
    this.block,
  });

  final Albums? albums;
  final Albums? appearances;
  final Albums? categories;
  final Albums? channels;
  final Recommendations? feed;
  final Albums? followers;
  final Albums? following;
  final Albums? groups;
  final Albums? likes;
  final Recommendations? membership;
  final Albums? moderatedChannels;
  final Albums? portfolios;
  final Albums? videos;
  final Albums? watchlater;
  final Albums? shared;
  final Albums? pictures;
  final Albums? watchedVideos;
  final Recommendations? foldersRoot;
  final Albums? folders;
  final Albums? teams;
  final Albums? block;

  FluffyConnections copyWith({
    Albums? albums,
    Albums? appearances,
    Albums? categories,
    Albums? channels,
    Recommendations? feed,
    Albums? followers,
    Albums? following,
    Albums? groups,
    Albums? likes,
    Recommendations? membership,
    Albums? moderatedChannels,
    Albums? portfolios,
    Albums? videos,
    Albums? watchlater,
    Albums? shared,
    Albums? pictures,
    Albums? watchedVideos,
    Recommendations? foldersRoot,
    Albums? folders,
    Albums? teams,
    Albums? block,
  }) =>
      FluffyConnections(
        albums: albums ?? this.albums,
        appearances: appearances ?? this.appearances,
        categories: categories ?? this.categories,
        channels: channels ?? this.channels,
        feed: feed ?? this.feed,
        followers: followers ?? this.followers,
        following: following ?? this.following,
        groups: groups ?? this.groups,
        likes: likes ?? this.likes,
        membership: membership ?? this.membership,
        moderatedChannels: moderatedChannels ?? this.moderatedChannels,
        portfolios: portfolios ?? this.portfolios,
        videos: videos ?? this.videos,
        watchlater: watchlater ?? this.watchlater,
        shared: shared ?? this.shared,
        pictures: pictures ?? this.pictures,
        watchedVideos: watchedVideos ?? this.watchedVideos,
        foldersRoot: foldersRoot ?? this.foldersRoot,
        folders: folders ?? this.folders,
        teams: teams ?? this.teams,
        block: block ?? this.block,
      );

  factory FluffyConnections.fromJson(Map<String, dynamic> json) => FluffyConnections(
        albums: json["albums"] == null ? null : Albums.fromJson(json["albums"]),
        appearances: json["appearances"] == null ? null : Albums.fromJson(json["appearances"]),
        categories: json["categories"] == null ? null : Albums.fromJson(json["categories"]),
        channels: json["channels"] == null ? null : Albums.fromJson(json["channels"]),
        feed: json["feed"] == null ? null : Recommendations.fromJson(json["feed"]),
        followers: json["followers"] == null ? null : Albums.fromJson(json["followers"]),
        following: json["following"] == null ? null : Albums.fromJson(json["following"]),
        groups: json["groups"] == null ? null : Albums.fromJson(json["groups"]),
        likes: json["likes"] == null ? null : Albums.fromJson(json["likes"]),
        membership: json["membership"] == null ? null : Recommendations.fromJson(json["membership"]),
        moderatedChannels: json["moderated_channels"] == null ? null : Albums.fromJson(json["moderated_channels"]),
        portfolios: json["portfolios"] == null ? null : Albums.fromJson(json["portfolios"]),
        videos: json["videos"] == null ? null : Albums.fromJson(json["videos"]),
        watchlater: json["watchlater"] == null ? null : Albums.fromJson(json["watchlater"]),
        shared: json["shared"] == null ? null : Albums.fromJson(json["shared"]),
        pictures: json["pictures"] == null ? null : Albums.fromJson(json["pictures"]),
        watchedVideos: json["watched_videos"] == null ? null : Albums.fromJson(json["watched_videos"]),
        foldersRoot: json["folders_root"] == null ? null : Recommendations.fromJson(json["folders_root"]),
        folders: json["folders"] == null ? null : Albums.fromJson(json["folders"]),
        teams: json["teams"] == null ? null : Albums.fromJson(json["teams"]),
        block: json["block"] == null ? null : Albums.fromJson(json["block"]),
      );

  Map<String, dynamic> toJson() => {
        "albums": albums?.toJson(),
        "appearances": appearances?.toJson(),
        "categories": categories?.toJson(),
        "channels": channels?.toJson(),
        "feed": feed?.toJson(),
        "followers": followers?.toJson(),
        "following": following?.toJson(),
        "groups": groups?.toJson(),
        "likes": likes?.toJson(),
        "membership": membership?.toJson(),
        "moderated_channels": moderatedChannels?.toJson(),
        "portfolios": portfolios?.toJson(),
        "videos": videos?.toJson(),
        "watchlater": watchlater?.toJson(),
        "shared": shared?.toJson(),
        "pictures": pictures?.toJson(),
        "watched_videos": watchedVideos?.toJson(),
        "folders_root": foldersRoot?.toJson(),
        "folders": folders?.toJson(),
        "teams": teams?.toJson(),
        "block": block?.toJson(),
      };
}

class Preferences {
  Preferences({
    this.videos,
    this.webinarRegistrantLowerWatermarkBannerDismissed,
  });

  final Videos? videos;
  final List<dynamic>? webinarRegistrantLowerWatermarkBannerDismissed;

  Preferences copyWith({
    Videos? videos,
    List<dynamic>? webinarRegistrantLowerWatermarkBannerDismissed,
  }) =>
      Preferences(
        videos: videos ?? this.videos,
        webinarRegistrantLowerWatermarkBannerDismissed:
            webinarRegistrantLowerWatermarkBannerDismissed ?? this.webinarRegistrantLowerWatermarkBannerDismissed,
      );

  factory Preferences.fromJson(Map<String, dynamic> json) => Preferences(
        videos: json["videos"] == null ? null : Videos.fromJson(json["videos"]),
        webinarRegistrantLowerWatermarkBannerDismissed:
            json["webinar_registrant_lower_watermark_banner_dismissed"] == null
                ? []
                : List<dynamic>.from(json["webinar_registrant_lower_watermark_banner_dismissed"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "videos": videos?.toJson(),
        "webinar_registrant_lower_watermark_banner_dismissed": webinarRegistrantLowerWatermarkBannerDismissed == null
            ? []
            : List<dynamic>.from(webinarRegistrantLowerWatermarkBannerDismissed!.map((x) => x)),
      };
}

class Videos {
  Videos({
    this.rating,
    this.privacy,
  });

  final List<String>? rating;
  final Privacy? privacy;

  Videos copyWith({
    List<String>? rating,
    Privacy? privacy,
  }) =>
      Videos(
        rating: rating ?? this.rating,
        privacy: privacy ?? this.privacy,
      );

  factory Videos.fromJson(Map<String, dynamic> json) => Videos(
        rating: json["rating"] == null ? [] : List<String>.from(json["rating"]!.map((x) => x)),
        privacy: json["privacy"] == null ? null : Privacy.fromJson(json["privacy"]),
      );

  Map<String, dynamic> toJson() => {
        "rating": rating == null ? [] : List<dynamic>.from(rating!.map((x) => x)),
        "privacy": privacy?.toJson(),
      };
}

class UploadQuota {
  UploadQuota({
    this.space,
    this.periodic,
    this.lifetime,
  });

  final Lifetime? space;
  final Periodic? periodic;
  final Lifetime? lifetime;

  UploadQuota copyWith({
    Lifetime? space,
    Periodic? periodic,
    Lifetime? lifetime,
  }) =>
      UploadQuota(
        space: space ?? this.space,
        periodic: periodic ?? this.periodic,
        lifetime: lifetime ?? this.lifetime,
      );

  factory UploadQuota.fromJson(Map<String, dynamic> json) => UploadQuota(
        space: json["space"] == null ? null : Lifetime.fromJson(json["space"]),
        periodic: json["periodic"] == null ? null : Periodic.fromJson(json["periodic"]),
        lifetime: json["lifetime"] == null ? null : Lifetime.fromJson(json["lifetime"]),
      );

  Map<String, dynamic> toJson() => {
        "space": space?.toJson(),
        "periodic": periodic?.toJson(),
        "lifetime": lifetime?.toJson(),
      };
}

class Lifetime {
  Lifetime({
    this.unit,
    this.free,
    this.max,
    this.used,
    this.showing,
  });

  final String? unit;
  final int? free;
  final int? max;
  final int? used;
  final String? showing;

  Lifetime copyWith({
    String? unit,
    int? free,
    int? max,
    int? used,
    String? showing,
  }) =>
      Lifetime(
        unit: unit ?? this.unit,
        free: free ?? this.free,
        max: max ?? this.max,
        used: used ?? this.used,
        showing: showing ?? this.showing,
      );

  factory Lifetime.fromJson(Map<String, dynamic> json) => Lifetime(
        unit: json["unit"],
        free: json["free"],
        max: json["max"],
        used: json["used"],
        showing: json["showing"],
      );

  Map<String, dynamic> toJson() => {
        "unit": unit,
        "free": free,
        "max": max,
        "used": used,
        "showing": showing,
      };
}

class Periodic {
  Periodic({
    this.period,
    this.unit,
    this.free,
    this.max,
    this.used,
    this.resetDate,
  });

  final String? period;
  final String? unit;
  final int? free;
  final int? max;
  final int? used;
  final DateTime? resetDate;

  Periodic copyWith({
    String? period,
    String? unit,
    int? free,
    int? max,
    int? used,
    DateTime? resetDate,
  }) =>
      Periodic(
        period: period ?? this.period,
        unit: unit ?? this.unit,
        free: free ?? this.free,
        max: max ?? this.max,
        used: used ?? this.used,
        resetDate: resetDate ?? this.resetDate,
      );

  factory Periodic.fromJson(Map<String, dynamic> json) => Periodic(
        period: json["period"],
        unit: json["unit"],
        free: json["free"],
        max: json["max"],
        used: json["used"],
        resetDate: json["reset_date"] == null ? null : DateTime.parse(json["reset_date"]),
      );

  Map<String, dynamic> toJson() => {
        "period": period,
        "unit": unit,
        "free": free,
        "max": max,
        "used": used,
        "reset_date": resetDate?.toIso8601String(),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
