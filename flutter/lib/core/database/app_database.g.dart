// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FeedsTable extends Feeds with TableInfo<$FeedsTable, Feed> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<int> channelId = GeneratedColumn<int>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tsIsoMeta = const VerificationMeta('tsIso');
  @override
  late final GeneratedColumn<String> tsIso = GeneratedColumn<String>(
    'ts_iso',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tsEpochMeta = const VerificationMeta(
    'tsEpoch',
  );
  @override
  late final GeneratedColumn<int> tsEpoch = GeneratedColumn<int>(
    'ts_epoch',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _field1Meta = const VerificationMeta('field1');
  @override
  late final GeneratedColumn<double> field1 = GeneratedColumn<double>(
    'field1',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _field2Meta = const VerificationMeta('field2');
  @override
  late final GeneratedColumn<double> field2 = GeneratedColumn<double>(
    'field2',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _field3Meta = const VerificationMeta('field3');
  @override
  late final GeneratedColumn<double> field3 = GeneratedColumn<double>(
    'field3',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _field4Meta = const VerificationMeta('field4');
  @override
  late final GeneratedColumn<double> field4 = GeneratedColumn<double>(
    'field4',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _field5Meta = const VerificationMeta('field5');
  @override
  late final GeneratedColumn<double> field5 = GeneratedColumn<double>(
    'field5',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _field6Meta = const VerificationMeta('field6');
  @override
  late final GeneratedColumn<double> field6 = GeneratedColumn<double>(
    'field6',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _field7Meta = const VerificationMeta('field7');
  @override
  late final GeneratedColumn<double> field7 = GeneratedColumn<double>(
    'field7',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _field8Meta = const VerificationMeta('field8');
  @override
  late final GeneratedColumn<double> field8 = GeneratedColumn<double>(
    'field8',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    entryId,
    channelId,
    tsIso,
    tsEpoch,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feeds';
  @override
  VerificationContext validateIntegrity(
    Insertable<Feed> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('ts_iso')) {
      context.handle(
        _tsIsoMeta,
        tsIso.isAcceptableOrUnknown(data['ts_iso']!, _tsIsoMeta),
      );
    } else if (isInserting) {
      context.missing(_tsIsoMeta);
    }
    if (data.containsKey('ts_epoch')) {
      context.handle(
        _tsEpochMeta,
        tsEpoch.isAcceptableOrUnknown(data['ts_epoch']!, _tsEpochMeta),
      );
    } else if (isInserting) {
      context.missing(_tsEpochMeta);
    }
    if (data.containsKey('field1')) {
      context.handle(
        _field1Meta,
        field1.isAcceptableOrUnknown(data['field1']!, _field1Meta),
      );
    }
    if (data.containsKey('field2')) {
      context.handle(
        _field2Meta,
        field2.isAcceptableOrUnknown(data['field2']!, _field2Meta),
      );
    }
    if (data.containsKey('field3')) {
      context.handle(
        _field3Meta,
        field3.isAcceptableOrUnknown(data['field3']!, _field3Meta),
      );
    }
    if (data.containsKey('field4')) {
      context.handle(
        _field4Meta,
        field4.isAcceptableOrUnknown(data['field4']!, _field4Meta),
      );
    }
    if (data.containsKey('field5')) {
      context.handle(
        _field5Meta,
        field5.isAcceptableOrUnknown(data['field5']!, _field5Meta),
      );
    }
    if (data.containsKey('field6')) {
      context.handle(
        _field6Meta,
        field6.isAcceptableOrUnknown(data['field6']!, _field6Meta),
      );
    }
    if (data.containsKey('field7')) {
      context.handle(
        _field7Meta,
        field7.isAcceptableOrUnknown(data['field7']!, _field7Meta),
      );
    }
    if (data.containsKey('field8')) {
      context.handle(
        _field8Meta,
        field8.isAcceptableOrUnknown(data['field8']!, _field8Meta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entryId};
  @override
  Feed map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Feed(
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}channel_id'],
      )!,
      tsIso: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ts_iso'],
      )!,
      tsEpoch: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ts_epoch'],
      )!,
      field1: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}field1'],
      ),
      field2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}field2'],
      ),
      field3: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}field3'],
      ),
      field4: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}field4'],
      ),
      field5: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}field5'],
      ),
      field6: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}field6'],
      ),
      field7: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}field7'],
      ),
      field8: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}field8'],
      ),
    );
  }

  @override
  $FeedsTable createAlias(String alias) {
    return $FeedsTable(attachedDatabase, alias);
  }
}

class Feed extends DataClass implements Insertable<Feed> {
  final int entryId;
  final int channelId;
  final String tsIso;
  final int tsEpoch;
  final double? field1;
  final double? field2;
  final double? field3;
  final double? field4;
  final double? field5;
  final double? field6;
  final double? field7;
  final double? field8;
  const Feed({
    required this.entryId,
    required this.channelId,
    required this.tsIso,
    required this.tsEpoch,
    this.field1,
    this.field2,
    this.field3,
    this.field4,
    this.field5,
    this.field6,
    this.field7,
    this.field8,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entry_id'] = Variable<int>(entryId);
    map['channel_id'] = Variable<int>(channelId);
    map['ts_iso'] = Variable<String>(tsIso);
    map['ts_epoch'] = Variable<int>(tsEpoch);
    if (!nullToAbsent || field1 != null) {
      map['field1'] = Variable<double>(field1);
    }
    if (!nullToAbsent || field2 != null) {
      map['field2'] = Variable<double>(field2);
    }
    if (!nullToAbsent || field3 != null) {
      map['field3'] = Variable<double>(field3);
    }
    if (!nullToAbsent || field4 != null) {
      map['field4'] = Variable<double>(field4);
    }
    if (!nullToAbsent || field5 != null) {
      map['field5'] = Variable<double>(field5);
    }
    if (!nullToAbsent || field6 != null) {
      map['field6'] = Variable<double>(field6);
    }
    if (!nullToAbsent || field7 != null) {
      map['field7'] = Variable<double>(field7);
    }
    if (!nullToAbsent || field8 != null) {
      map['field8'] = Variable<double>(field8);
    }
    return map;
  }

  FeedsCompanion toCompanion(bool nullToAbsent) {
    return FeedsCompanion(
      entryId: Value(entryId),
      channelId: Value(channelId),
      tsIso: Value(tsIso),
      tsEpoch: Value(tsEpoch),
      field1: field1 == null && nullToAbsent
          ? const Value.absent()
          : Value(field1),
      field2: field2 == null && nullToAbsent
          ? const Value.absent()
          : Value(field2),
      field3: field3 == null && nullToAbsent
          ? const Value.absent()
          : Value(field3),
      field4: field4 == null && nullToAbsent
          ? const Value.absent()
          : Value(field4),
      field5: field5 == null && nullToAbsent
          ? const Value.absent()
          : Value(field5),
      field6: field6 == null && nullToAbsent
          ? const Value.absent()
          : Value(field6),
      field7: field7 == null && nullToAbsent
          ? const Value.absent()
          : Value(field7),
      field8: field8 == null && nullToAbsent
          ? const Value.absent()
          : Value(field8),
    );
  }

  factory Feed.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Feed(
      entryId: serializer.fromJson<int>(json['entryId']),
      channelId: serializer.fromJson<int>(json['channelId']),
      tsIso: serializer.fromJson<String>(json['tsIso']),
      tsEpoch: serializer.fromJson<int>(json['tsEpoch']),
      field1: serializer.fromJson<double?>(json['field1']),
      field2: serializer.fromJson<double?>(json['field2']),
      field3: serializer.fromJson<double?>(json['field3']),
      field4: serializer.fromJson<double?>(json['field4']),
      field5: serializer.fromJson<double?>(json['field5']),
      field6: serializer.fromJson<double?>(json['field6']),
      field7: serializer.fromJson<double?>(json['field7']),
      field8: serializer.fromJson<double?>(json['field8']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entryId': serializer.toJson<int>(entryId),
      'channelId': serializer.toJson<int>(channelId),
      'tsIso': serializer.toJson<String>(tsIso),
      'tsEpoch': serializer.toJson<int>(tsEpoch),
      'field1': serializer.toJson<double?>(field1),
      'field2': serializer.toJson<double?>(field2),
      'field3': serializer.toJson<double?>(field3),
      'field4': serializer.toJson<double?>(field4),
      'field5': serializer.toJson<double?>(field5),
      'field6': serializer.toJson<double?>(field6),
      'field7': serializer.toJson<double?>(field7),
      'field8': serializer.toJson<double?>(field8),
    };
  }

  Feed copyWith({
    int? entryId,
    int? channelId,
    String? tsIso,
    int? tsEpoch,
    Value<double?> field1 = const Value.absent(),
    Value<double?> field2 = const Value.absent(),
    Value<double?> field3 = const Value.absent(),
    Value<double?> field4 = const Value.absent(),
    Value<double?> field5 = const Value.absent(),
    Value<double?> field6 = const Value.absent(),
    Value<double?> field7 = const Value.absent(),
    Value<double?> field8 = const Value.absent(),
  }) => Feed(
    entryId: entryId ?? this.entryId,
    channelId: channelId ?? this.channelId,
    tsIso: tsIso ?? this.tsIso,
    tsEpoch: tsEpoch ?? this.tsEpoch,
    field1: field1.present ? field1.value : this.field1,
    field2: field2.present ? field2.value : this.field2,
    field3: field3.present ? field3.value : this.field3,
    field4: field4.present ? field4.value : this.field4,
    field5: field5.present ? field5.value : this.field5,
    field6: field6.present ? field6.value : this.field6,
    field7: field7.present ? field7.value : this.field7,
    field8: field8.present ? field8.value : this.field8,
  );
  Feed copyWithCompanion(FeedsCompanion data) {
    return Feed(
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      tsIso: data.tsIso.present ? data.tsIso.value : this.tsIso,
      tsEpoch: data.tsEpoch.present ? data.tsEpoch.value : this.tsEpoch,
      field1: data.field1.present ? data.field1.value : this.field1,
      field2: data.field2.present ? data.field2.value : this.field2,
      field3: data.field3.present ? data.field3.value : this.field3,
      field4: data.field4.present ? data.field4.value : this.field4,
      field5: data.field5.present ? data.field5.value : this.field5,
      field6: data.field6.present ? data.field6.value : this.field6,
      field7: data.field7.present ? data.field7.value : this.field7,
      field8: data.field8.present ? data.field8.value : this.field8,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Feed(')
          ..write('entryId: $entryId, ')
          ..write('channelId: $channelId, ')
          ..write('tsIso: $tsIso, ')
          ..write('tsEpoch: $tsEpoch, ')
          ..write('field1: $field1, ')
          ..write('field2: $field2, ')
          ..write('field3: $field3, ')
          ..write('field4: $field4, ')
          ..write('field5: $field5, ')
          ..write('field6: $field6, ')
          ..write('field7: $field7, ')
          ..write('field8: $field8')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    entryId,
    channelId,
    tsIso,
    tsEpoch,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Feed &&
          other.entryId == this.entryId &&
          other.channelId == this.channelId &&
          other.tsIso == this.tsIso &&
          other.tsEpoch == this.tsEpoch &&
          other.field1 == this.field1 &&
          other.field2 == this.field2 &&
          other.field3 == this.field3 &&
          other.field4 == this.field4 &&
          other.field5 == this.field5 &&
          other.field6 == this.field6 &&
          other.field7 == this.field7 &&
          other.field8 == this.field8);
}

class FeedsCompanion extends UpdateCompanion<Feed> {
  final Value<int> entryId;
  final Value<int> channelId;
  final Value<String> tsIso;
  final Value<int> tsEpoch;
  final Value<double?> field1;
  final Value<double?> field2;
  final Value<double?> field3;
  final Value<double?> field4;
  final Value<double?> field5;
  final Value<double?> field6;
  final Value<double?> field7;
  final Value<double?> field8;
  const FeedsCompanion({
    this.entryId = const Value.absent(),
    this.channelId = const Value.absent(),
    this.tsIso = const Value.absent(),
    this.tsEpoch = const Value.absent(),
    this.field1 = const Value.absent(),
    this.field2 = const Value.absent(),
    this.field3 = const Value.absent(),
    this.field4 = const Value.absent(),
    this.field5 = const Value.absent(),
    this.field6 = const Value.absent(),
    this.field7 = const Value.absent(),
    this.field8 = const Value.absent(),
  });
  FeedsCompanion.insert({
    this.entryId = const Value.absent(),
    required int channelId,
    required String tsIso,
    required int tsEpoch,
    this.field1 = const Value.absent(),
    this.field2 = const Value.absent(),
    this.field3 = const Value.absent(),
    this.field4 = const Value.absent(),
    this.field5 = const Value.absent(),
    this.field6 = const Value.absent(),
    this.field7 = const Value.absent(),
    this.field8 = const Value.absent(),
  }) : channelId = Value(channelId),
       tsIso = Value(tsIso),
       tsEpoch = Value(tsEpoch);
  static Insertable<Feed> custom({
    Expression<int>? entryId,
    Expression<int>? channelId,
    Expression<String>? tsIso,
    Expression<int>? tsEpoch,
    Expression<double>? field1,
    Expression<double>? field2,
    Expression<double>? field3,
    Expression<double>? field4,
    Expression<double>? field5,
    Expression<double>? field6,
    Expression<double>? field7,
    Expression<double>? field8,
  }) {
    return RawValuesInsertable({
      if (entryId != null) 'entry_id': entryId,
      if (channelId != null) 'channel_id': channelId,
      if (tsIso != null) 'ts_iso': tsIso,
      if (tsEpoch != null) 'ts_epoch': tsEpoch,
      if (field1 != null) 'field1': field1,
      if (field2 != null) 'field2': field2,
      if (field3 != null) 'field3': field3,
      if (field4 != null) 'field4': field4,
      if (field5 != null) 'field5': field5,
      if (field6 != null) 'field6': field6,
      if (field7 != null) 'field7': field7,
      if (field8 != null) 'field8': field8,
    });
  }

  FeedsCompanion copyWith({
    Value<int>? entryId,
    Value<int>? channelId,
    Value<String>? tsIso,
    Value<int>? tsEpoch,
    Value<double?>? field1,
    Value<double?>? field2,
    Value<double?>? field3,
    Value<double?>? field4,
    Value<double?>? field5,
    Value<double?>? field6,
    Value<double?>? field7,
    Value<double?>? field8,
  }) {
    return FeedsCompanion(
      entryId: entryId ?? this.entryId,
      channelId: channelId ?? this.channelId,
      tsIso: tsIso ?? this.tsIso,
      tsEpoch: tsEpoch ?? this.tsEpoch,
      field1: field1 ?? this.field1,
      field2: field2 ?? this.field2,
      field3: field3 ?? this.field3,
      field4: field4 ?? this.field4,
      field5: field5 ?? this.field5,
      field6: field6 ?? this.field6,
      field7: field7 ?? this.field7,
      field8: field8 ?? this.field8,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<int>(channelId.value);
    }
    if (tsIso.present) {
      map['ts_iso'] = Variable<String>(tsIso.value);
    }
    if (tsEpoch.present) {
      map['ts_epoch'] = Variable<int>(tsEpoch.value);
    }
    if (field1.present) {
      map['field1'] = Variable<double>(field1.value);
    }
    if (field2.present) {
      map['field2'] = Variable<double>(field2.value);
    }
    if (field3.present) {
      map['field3'] = Variable<double>(field3.value);
    }
    if (field4.present) {
      map['field4'] = Variable<double>(field4.value);
    }
    if (field5.present) {
      map['field5'] = Variable<double>(field5.value);
    }
    if (field6.present) {
      map['field6'] = Variable<double>(field6.value);
    }
    if (field7.present) {
      map['field7'] = Variable<double>(field7.value);
    }
    if (field8.present) {
      map['field8'] = Variable<double>(field8.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedsCompanion(')
          ..write('entryId: $entryId, ')
          ..write('channelId: $channelId, ')
          ..write('tsIso: $tsIso, ')
          ..write('tsEpoch: $tsEpoch, ')
          ..write('field1: $field1, ')
          ..write('field2: $field2, ')
          ..write('field3: $field3, ')
          ..write('field4: $field4, ')
          ..write('field5: $field5, ')
          ..write('field6: $field6, ')
          ..write('field7: $field7, ')
          ..write('field8: $field8')
          ..write(')'))
        .toString();
  }
}

class $SyncMetasTable extends SyncMetas
    with TableInfo<$SyncMetasTable, SyncMeta> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastEntryIdMeta = const VerificationMeta(
    'lastEntryId',
  );
  @override
  late final GeneratedColumn<int> lastEntryId = GeneratedColumn<int>(
    'last_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<String> lastSyncAt = GeneratedColumn<String>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, lastEntryId, lastSyncAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metas';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMeta> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_entry_id')) {
      context.handle(
        _lastEntryIdMeta,
        lastEntryId.isAcceptableOrUnknown(
          data['last_entry_id']!,
          _lastEntryIdMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncMeta map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMeta(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lastEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_entry_id'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_sync_at'],
      ),
    );
  }

  @override
  $SyncMetasTable createAlias(String alias) {
    return $SyncMetasTable(attachedDatabase, alias);
  }
}

class SyncMeta extends DataClass implements Insertable<SyncMeta> {
  final int id;
  final int lastEntryId;
  final String? lastSyncAt;
  const SyncMeta({
    required this.id,
    required this.lastEntryId,
    this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['last_entry_id'] = Variable<int>(lastEntryId);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<String>(lastSyncAt);
    }
    return map;
  }

  SyncMetasCompanion toCompanion(bool nullToAbsent) {
    return SyncMetasCompanion(
      id: Value(id),
      lastEntryId: Value(lastEntryId),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory SyncMeta.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMeta(
      id: serializer.fromJson<int>(json['id']),
      lastEntryId: serializer.fromJson<int>(json['lastEntryId']),
      lastSyncAt: serializer.fromJson<String?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastEntryId': serializer.toJson<int>(lastEntryId),
      'lastSyncAt': serializer.toJson<String?>(lastSyncAt),
    };
  }

  SyncMeta copyWith({
    int? id,
    int? lastEntryId,
    Value<String?> lastSyncAt = const Value.absent(),
  }) => SyncMeta(
    id: id ?? this.id,
    lastEntryId: lastEntryId ?? this.lastEntryId,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
  );
  SyncMeta copyWithCompanion(SyncMetasCompanion data) {
    return SyncMeta(
      id: data.id.present ? data.id.value : this.id,
      lastEntryId: data.lastEntryId.present
          ? data.lastEntryId.value
          : this.lastEntryId,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMeta(')
          ..write('id: $id, ')
          ..write('lastEntryId: $lastEntryId, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lastEntryId, lastSyncAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMeta &&
          other.id == this.id &&
          other.lastEntryId == this.lastEntryId &&
          other.lastSyncAt == this.lastSyncAt);
}

class SyncMetasCompanion extends UpdateCompanion<SyncMeta> {
  final Value<int> id;
  final Value<int> lastEntryId;
  final Value<String?> lastSyncAt;
  const SyncMetasCompanion({
    this.id = const Value.absent(),
    this.lastEntryId = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  });
  SyncMetasCompanion.insert({
    this.id = const Value.absent(),
    this.lastEntryId = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  });
  static Insertable<SyncMeta> custom({
    Expression<int>? id,
    Expression<int>? lastEntryId,
    Expression<String>? lastSyncAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastEntryId != null) 'last_entry_id': lastEntryId,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
    });
  }

  SyncMetasCompanion copyWith({
    Value<int>? id,
    Value<int>? lastEntryId,
    Value<String?>? lastSyncAt,
  }) {
    return SyncMetasCompanion(
      id: id ?? this.id,
      lastEntryId: lastEntryId ?? this.lastEntryId,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastEntryId.present) {
      map['last_entry_id'] = Variable<int>(lastEntryId.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<String>(lastSyncAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetasCompanion(')
          ..write('id: $id, ')
          ..write('lastEntryId: $lastEntryId, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FeedsTable feeds = $FeedsTable(this);
  late final $SyncMetasTable syncMetas = $SyncMetasTable(this);
  late final FeedDao feedDao = FeedDao(this as AppDatabase);
  late final SyncMetaDao syncMetaDao = SyncMetaDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [feeds, syncMetas];
}

typedef $$FeedsTableCreateCompanionBuilder =
    FeedsCompanion Function({
      Value<int> entryId,
      required int channelId,
      required String tsIso,
      required int tsEpoch,
      Value<double?> field1,
      Value<double?> field2,
      Value<double?> field3,
      Value<double?> field4,
      Value<double?> field5,
      Value<double?> field6,
      Value<double?> field7,
      Value<double?> field8,
    });
typedef $$FeedsTableUpdateCompanionBuilder =
    FeedsCompanion Function({
      Value<int> entryId,
      Value<int> channelId,
      Value<String> tsIso,
      Value<int> tsEpoch,
      Value<double?> field1,
      Value<double?> field2,
      Value<double?> field3,
      Value<double?> field4,
      Value<double?> field5,
      Value<double?> field6,
      Value<double?> field7,
      Value<double?> field8,
    });

class $$FeedsTableFilterComposer extends Composer<_$AppDatabase, $FeedsTable> {
  $$FeedsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tsIso => $composableBuilder(
    column: $table.tsIso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tsEpoch => $composableBuilder(
    column: $table.tsEpoch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get field1 => $composableBuilder(
    column: $table.field1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get field2 => $composableBuilder(
    column: $table.field2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get field3 => $composableBuilder(
    column: $table.field3,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get field4 => $composableBuilder(
    column: $table.field4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get field5 => $composableBuilder(
    column: $table.field5,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get field6 => $composableBuilder(
    column: $table.field6,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get field7 => $composableBuilder(
    column: $table.field7,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get field8 => $composableBuilder(
    column: $table.field8,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FeedsTableOrderingComposer
    extends Composer<_$AppDatabase, $FeedsTable> {
  $$FeedsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tsIso => $composableBuilder(
    column: $table.tsIso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tsEpoch => $composableBuilder(
    column: $table.tsEpoch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get field1 => $composableBuilder(
    column: $table.field1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get field2 => $composableBuilder(
    column: $table.field2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get field3 => $composableBuilder(
    column: $table.field3,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get field4 => $composableBuilder(
    column: $table.field4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get field5 => $composableBuilder(
    column: $table.field5,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get field6 => $composableBuilder(
    column: $table.field6,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get field7 => $composableBuilder(
    column: $table.field7,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get field8 => $composableBuilder(
    column: $table.field8,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FeedsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeedsTable> {
  $$FeedsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get entryId =>
      $composableBuilder(column: $table.entryId, builder: (column) => column);

  GeneratedColumn<int> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get tsIso =>
      $composableBuilder(column: $table.tsIso, builder: (column) => column);

  GeneratedColumn<int> get tsEpoch =>
      $composableBuilder(column: $table.tsEpoch, builder: (column) => column);

  GeneratedColumn<double> get field1 =>
      $composableBuilder(column: $table.field1, builder: (column) => column);

  GeneratedColumn<double> get field2 =>
      $composableBuilder(column: $table.field2, builder: (column) => column);

  GeneratedColumn<double> get field3 =>
      $composableBuilder(column: $table.field3, builder: (column) => column);

  GeneratedColumn<double> get field4 =>
      $composableBuilder(column: $table.field4, builder: (column) => column);

  GeneratedColumn<double> get field5 =>
      $composableBuilder(column: $table.field5, builder: (column) => column);

  GeneratedColumn<double> get field6 =>
      $composableBuilder(column: $table.field6, builder: (column) => column);

  GeneratedColumn<double> get field7 =>
      $composableBuilder(column: $table.field7, builder: (column) => column);

  GeneratedColumn<double> get field8 =>
      $composableBuilder(column: $table.field8, builder: (column) => column);
}

class $$FeedsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FeedsTable,
          Feed,
          $$FeedsTableFilterComposer,
          $$FeedsTableOrderingComposer,
          $$FeedsTableAnnotationComposer,
          $$FeedsTableCreateCompanionBuilder,
          $$FeedsTableUpdateCompanionBuilder,
          (Feed, BaseReferences<_$AppDatabase, $FeedsTable, Feed>),
          Feed,
          PrefetchHooks Function()
        > {
  $$FeedsTableTableManager(_$AppDatabase db, $FeedsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> entryId = const Value.absent(),
                Value<int> channelId = const Value.absent(),
                Value<String> tsIso = const Value.absent(),
                Value<int> tsEpoch = const Value.absent(),
                Value<double?> field1 = const Value.absent(),
                Value<double?> field2 = const Value.absent(),
                Value<double?> field3 = const Value.absent(),
                Value<double?> field4 = const Value.absent(),
                Value<double?> field5 = const Value.absent(),
                Value<double?> field6 = const Value.absent(),
                Value<double?> field7 = const Value.absent(),
                Value<double?> field8 = const Value.absent(),
              }) => FeedsCompanion(
                entryId: entryId,
                channelId: channelId,
                tsIso: tsIso,
                tsEpoch: tsEpoch,
                field1: field1,
                field2: field2,
                field3: field3,
                field4: field4,
                field5: field5,
                field6: field6,
                field7: field7,
                field8: field8,
              ),
          createCompanionCallback:
              ({
                Value<int> entryId = const Value.absent(),
                required int channelId,
                required String tsIso,
                required int tsEpoch,
                Value<double?> field1 = const Value.absent(),
                Value<double?> field2 = const Value.absent(),
                Value<double?> field3 = const Value.absent(),
                Value<double?> field4 = const Value.absent(),
                Value<double?> field5 = const Value.absent(),
                Value<double?> field6 = const Value.absent(),
                Value<double?> field7 = const Value.absent(),
                Value<double?> field8 = const Value.absent(),
              }) => FeedsCompanion.insert(
                entryId: entryId,
                channelId: channelId,
                tsIso: tsIso,
                tsEpoch: tsEpoch,
                field1: field1,
                field2: field2,
                field3: field3,
                field4: field4,
                field5: field5,
                field6: field6,
                field7: field7,
                field8: field8,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FeedsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FeedsTable,
      Feed,
      $$FeedsTableFilterComposer,
      $$FeedsTableOrderingComposer,
      $$FeedsTableAnnotationComposer,
      $$FeedsTableCreateCompanionBuilder,
      $$FeedsTableUpdateCompanionBuilder,
      (Feed, BaseReferences<_$AppDatabase, $FeedsTable, Feed>),
      Feed,
      PrefetchHooks Function()
    >;
typedef $$SyncMetasTableCreateCompanionBuilder =
    SyncMetasCompanion Function({
      Value<int> id,
      Value<int> lastEntryId,
      Value<String?> lastSyncAt,
    });
typedef $$SyncMetasTableUpdateCompanionBuilder =
    SyncMetasCompanion Function({
      Value<int> id,
      Value<int> lastEntryId,
      Value<String?> lastSyncAt,
    });

class $$SyncMetasTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetasTable> {
  $$SyncMetasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastEntryId => $composableBuilder(
    column: $table.lastEntryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetasTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetasTable> {
  $$SyncMetasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastEntryId => $composableBuilder(
    column: $table.lastEntryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetasTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetasTable> {
  $$SyncMetasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get lastEntryId => $composableBuilder(
    column: $table.lastEntryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );
}

class $$SyncMetasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetasTable,
          SyncMeta,
          $$SyncMetasTableFilterComposer,
          $$SyncMetasTableOrderingComposer,
          $$SyncMetasTableAnnotationComposer,
          $$SyncMetasTableCreateCompanionBuilder,
          $$SyncMetasTableUpdateCompanionBuilder,
          (SyncMeta, BaseReferences<_$AppDatabase, $SyncMetasTable, SyncMeta>),
          SyncMeta,
          PrefetchHooks Function()
        > {
  $$SyncMetasTableTableManager(_$AppDatabase db, $SyncMetasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> lastEntryId = const Value.absent(),
                Value<String?> lastSyncAt = const Value.absent(),
              }) => SyncMetasCompanion(
                id: id,
                lastEntryId: lastEntryId,
                lastSyncAt: lastSyncAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> lastEntryId = const Value.absent(),
                Value<String?> lastSyncAt = const Value.absent(),
              }) => SyncMetasCompanion.insert(
                id: id,
                lastEntryId: lastEntryId,
                lastSyncAt: lastSyncAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetasTable,
      SyncMeta,
      $$SyncMetasTableFilterComposer,
      $$SyncMetasTableOrderingComposer,
      $$SyncMetasTableAnnotationComposer,
      $$SyncMetasTableCreateCompanionBuilder,
      $$SyncMetasTableUpdateCompanionBuilder,
      (SyncMeta, BaseReferences<_$AppDatabase, $SyncMetasTable, SyncMeta>),
      SyncMeta,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FeedsTableTableManager get feeds =>
      $$FeedsTableTableManager(_db, _db.feeds);
  $$SyncMetasTableTableManager get syncMetas =>
      $$SyncMetasTableTableManager(_db, _db.syncMetas);
}

mixin _$FeedDaoMixin on DatabaseAccessor<AppDatabase> {
  $FeedsTable get feeds => attachedDatabase.feeds;
  FeedDaoManager get managers => FeedDaoManager(this);
}

class FeedDaoManager {
  final _$FeedDaoMixin _db;
  FeedDaoManager(this._db);
  $$FeedsTableTableManager get feeds =>
      $$FeedsTableTableManager(_db.attachedDatabase, _db.feeds);
}

mixin _$SyncMetaDaoMixin on DatabaseAccessor<AppDatabase> {
  $SyncMetasTable get syncMetas => attachedDatabase.syncMetas;
  SyncMetaDaoManager get managers => SyncMetaDaoManager(this);
}

class SyncMetaDaoManager {
  final _$SyncMetaDaoMixin _db;
  SyncMetaDaoManager(this._db);
  $$SyncMetasTableTableManager get syncMetas =>
      $$SyncMetasTableTableManager(_db.attachedDatabase, _db.syncMetas);
}
