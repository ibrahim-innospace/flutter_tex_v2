// To parse this JSON data, do
//
//     final testQuestionModel = testQuestionModelFromJson(jsonString);

import 'dart:convert';

TestQuestionModel testQuestionModelFromJson(String str) =>
    TestQuestionModel.fromJson(json.decode(str));

String testQuestionModelToJson(TestQuestionModel data) =>
    json.encode(data.toJson());

class TestQuestionModel {
  List<Datum>? data;
  Pagination? pagination;

  TestQuestionModel({
    this.data,
    this.pagination,
  });

  factory TestQuestionModel.fromJson(Map<String, dynamic> json) =>
      TestQuestionModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Datum {
  String? id;
  String? createdBy;
  String? updatedBy;
  bool? isActive;
  bool? isDeleted;
  String? questionText;
  List<Option>? options;
  String? explanation;
  String? difficulty;
  String? questionType;
  AssociatedWithClass? associatedWithClass;
  AssociatedWithCourse? associatedWithCourse;
  AssociatedWithSubject? associatedWithSubject;
  AssociatedWithChapter? associatedWithChapter;
  AssociatedWithTopic? associatedWithTopic;
  List<dynamic>? appearedInInstitutions;
  List<dynamic>? tags;
  bool? isLearnMode;
  bool? isTestMode;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Datum({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.isActive,
    this.isDeleted,
    this.questionText,
    this.options,
    this.explanation,
    this.difficulty,
    this.questionType,
    this.associatedWithClass,
    this.associatedWithCourse,
    this.associatedWithSubject,
    this.associatedWithChapter,
    this.associatedWithTopic,
    this.appearedInInstitutions,
    this.tags,
    this.isLearnMode,
    this.isTestMode,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isActive: json["isActive"],
        isDeleted: json["isDeleted"],
        questionText: json["questionText"],
        options: json["options"] == null
            ? []
            : List<Option>.from(
                json["options"]!.map((x) => Option.fromJson(x))),
        explanation: json["explanation"],
        difficulty: json["difficulty"],
        questionType: json["questionType"],
        associatedWithClass: json["associatedWithClass"] == null
            ? null
            : AssociatedWithClass.fromJson(json["associatedWithClass"]),
        associatedWithCourse: json["associatedWithCourse"] == null
            ? null
            : AssociatedWithCourse.fromJson(json["associatedWithCourse"]),
        associatedWithSubject: json["associatedWithSubject"] == null
            ? null
            : AssociatedWithSubject.fromJson(json["associatedWithSubject"]),
        associatedWithChapter: json["associatedWithChapter"] == null
            ? null
            : AssociatedWithChapter.fromJson(json["associatedWithChapter"]),
        associatedWithTopic: json["associatedWithTopic"] == null
            ? null
            : AssociatedWithTopic.fromJson(json["associatedWithTopic"]),
        appearedInInstitutions: json["appearedInInstitutions"] == null
            ? []
            : List<dynamic>.from(json["appearedInInstitutions"]!.map((x) => x)),
        tags: json["tags"] == null
            ? []
            : List<dynamic>.from(json["tags"]!.map((x) => x)),
        isLearnMode: json["isLearnMode"],
        isTestMode: json["isTestMode"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "isActive": isActive,
        "isDeleted": isDeleted,
        "questionText": questionText,
        "options": options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toJson())),
        "explanation": explanation,
        "difficulty": difficulty,
        "questionType": questionType,
        "associatedWithClass": associatedWithClass?.toJson(),
        "associatedWithCourse": associatedWithCourse?.toJson(),
        "associatedWithSubject": associatedWithSubject?.toJson(),
        "associatedWithChapter": associatedWithChapter?.toJson(),
        "associatedWithTopic": associatedWithTopic?.toJson(),
        "appearedInInstitutions": appearedInInstitutions == null
            ? []
            : List<dynamic>.from(appearedInInstitutions!.map((x) => x)),
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "isLearnMode": isLearnMode,
        "isTestMode": isTestMode,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class AssociatedWithChapter {
  String? chapterName;
  String? id;

  AssociatedWithChapter({
    this.chapterName,
    this.id,
  });

  factory AssociatedWithChapter.fromJson(Map<String, dynamic> json) =>
      AssociatedWithChapter(
        chapterName: json["chapterName"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "chapterName": chapterName,
        "_id": id,
      };
}

class AssociatedWithClass {
  String? className;
  String? id;

  AssociatedWithClass({
    this.className,
    this.id,
  });

  factory AssociatedWithClass.fromJson(Map<String, dynamic> json) =>
      AssociatedWithClass(
        className: json["className"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "className": className,
        "_id": id,
      };
}

class AssociatedWithCourse {
  String? courseName;
  String? id;

  AssociatedWithCourse({
    this.courseName,
    this.id,
  });

  factory AssociatedWithCourse.fromJson(Map<String, dynamic> json) =>
      AssociatedWithCourse(
        courseName: json["courseName"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "courseName": courseName,
        "_id": id,
      };
}

class AssociatedWithSubject {
  String? subjectName;
  String? id;

  AssociatedWithSubject({
    this.subjectName,
    this.id,
  });

  factory AssociatedWithSubject.fromJson(Map<String, dynamic> json) =>
      AssociatedWithSubject(
        subjectName: json["subjectName"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "subjectName": subjectName,
        "_id": id,
      };
}

class AssociatedWithTopic {
  String? topicName;
  String? id;

  AssociatedWithTopic({
    this.topicName,
    this.id,
  });

  factory AssociatedWithTopic.fromJson(Map<String, dynamic> json) =>
      AssociatedWithTopic(
        topicName: json["topicName"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "topicName": topicName,
        "_id": id,
      };
}

class Option {
  String? text;
  bool? isCorrect;
  String? id;

  Option({
    this.text,
    this.isCorrect,
    this.id,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        text: json["text"],
        isCorrect: json["isCorrect"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "isCorrect": isCorrect,
        "_id": id,
      };
}

class Pagination {
  int? totalItems;
  int? itemsPerPage;
  int? currentPage;
  int? totalPages;

  Pagination({
    this.totalItems,
    this.itemsPerPage,
    this.currentPage,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalItems: json["totalItems"],
        itemsPerPage: json["itemsPerPage"],
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "itemsPerPage": itemsPerPage,
        "currentPage": currentPage,
        "totalPages": totalPages,
      };
}
