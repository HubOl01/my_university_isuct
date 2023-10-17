// To parse this JSON data, do
//
//     final ruIsuct = ruIsuctFromJson(jsonString);

import 'dart:convert';

RuIsuct ruIsuctFromJson(String str) => RuIsuct.fromJson(json.decode(str));

String ruIsuctToJson(RuIsuct data) => json.encode(data.toJson());

class RuIsuct {
    final String? name;
    final String? abbr;
    final List<Faculty>? faculties;

    RuIsuct({
        this.name,
        this.abbr,
        this.faculties,
    });

    factory RuIsuct.fromJson(Map<String, dynamic> json) => RuIsuct(
        name: json["name"],
        abbr: json["abbr"],
        faculties: json["faculties"] == null ? [] : List<Faculty>.from(json["faculties"]!.map((x) => Faculty.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "abbr": abbr,
        "faculties": faculties == null ? [] : List<dynamic>.from(faculties!.map((x) => x.toJson())),
    };
}

class Faculty {
    final String? name;
    final List<Group>? groups;

    Faculty({
        this.name,
        this.groups,
    });

    factory Faculty.fromJson(Map<String, dynamic> json) => Faculty(
        name: json["name"],
        groups: json["groups"] == null ? [] : List<Group>.from(json["groups"]!.map((x) => Group.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "groups": groups == null ? [] : List<dynamic>.from(groups!.map((x) => x.toJson())),
    };
}

class Group {
    final String? name;
    final List<Lesson>? lessons;

    Group({
        this.name,
        this.lessons,
    });

    factory Group.fromJson(Map<String, dynamic> json) => Group(
        name: json["name"],
        lessons: json["lessons"] == null ? [] : List<Lesson>.from(json["lessons"]!.map((x) => Lesson.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "lessons": lessons == null ? [] : List<dynamic>.from(lessons!.map((x) => x.toJson())),
    };
}

class Lesson {
    final String? subject;
    final String? type;
    final Time? time;
    final Date? date;
    final List<Audience>? audiences;
    final List<Teacher>? teachers;

    Lesson({
        this.subject,
        this.type,
        this.time,
        this.date,
        this.audiences,
        this.teachers,
    });

    factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        subject: json["subject"],
        type: json["type"],
        time: json["time"] == null ? null : Time.fromJson(json["time"]),
        date: json["date"] == null ? null : Date.fromJson(json["date"]),
        audiences: json["audiences"] == null ? [] : List<Audience>.from(json["audiences"]!.map((x) => Audience.fromJson(x))),
        teachers: json["teachers"] == null ? [] : List<Teacher>.from(json["teachers"]!.map((x) => Teacher.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "subject": subject,
        "type": type,
        "time": time?.toJson(),
        "date": date?.toJson(),
        "audiences": audiences == null ? [] : List<dynamic>.from(audiences!.map((x) => x.toJson())),
        "teachers": teachers == null ? [] : List<dynamic>.from(teachers!.map((x) => x.toJson())),
    };
}

class Audience {
    final String? name;

    Audience({
        this.name,
    });

    factory Audience.fromJson(Map<String, dynamic> json) => Audience(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}

class Teacher {
    final String? name;

    Teacher({
        this.name,
    });

    factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}

class Date {
    final String? start;
    final String? end;
    final int? weekday;
    final int? week;

    Date({
        this.start,
        this.end,
        this.weekday,
        this.week,
    });

    factory Date.fromJson(Map<String, dynamic> json) => Date(
        start: json["start"],
        end: json["end"],
        weekday: json["weekday"],
        week: json["week"],
    );

    Map<String, dynamic> toJson() => {
        "start": start,
        "end": end,
        "weekday": weekday,
        "week": week,
    };
}

class Time {
    final String? start;
    final String? end;

    Time({
        this.start,
        this.end,
    });

    factory Time.fromJson(Map<String, dynamic> json) => Time(
        start: json["start"],
        end: json["end"],
    );

    Map<String, dynamic> toJson() => {
        "start": start,
        "end": end,
    };
}
