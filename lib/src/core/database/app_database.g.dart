// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WorkRecordsTable extends WorkRecords
    with TableInfo<$WorkRecordsTable, WorkRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workDateMeta = const VerificationMeta(
    'workDate',
  );
  @override
  late final GeneratedColumn<DateTime> workDate = GeneratedColumn<DateTime>(
    'work_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkInMinutesMeta = const VerificationMeta(
    'checkInMinutes',
  );
  @override
  late final GeneratedColumn<int> checkInMinutes = GeneratedColumn<int>(
    'check_in_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkOutMinutesMeta = const VerificationMeta(
    'checkOutMinutes',
  );
  @override
  late final GeneratedColumn<int> checkOutMinutes = GeneratedColumn<int>(
    'check_out_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _breakMinutesMeta = const VerificationMeta(
    'breakMinutes',
  );
  @override
  late final GeneratedColumn<int> breakMinutes = GeneratedColumn<int>(
    'break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dayTypeMeta = const VerificationMeta(
    'dayType',
  );
  @override
  late final GeneratedColumn<String> dayType = GeneratedColumn<String>(
    'day_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _extraOtHoursMeta = const VerificationMeta(
    'extraOtHours',
  );
  @override
  late final GeneratedColumn<double> extraOtHours = GeneratedColumn<double>(
    'extra_ot_hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _travelAllowanceMeta = const VerificationMeta(
    'travelAllowance',
  );
  @override
  late final GeneratedColumn<double> travelAllowance = GeneratedColumn<double>(
    'travel_allowance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _specialAllowanceMeta = const VerificationMeta(
    'specialAllowance',
  );
  @override
  late final GeneratedColumn<double> specialAllowance = GeneratedColumn<double>(
    'special_allowance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _expenseMeta = const VerificationMeta(
    'expense',
  );
  @override
  late final GeneratedColumn<double> expense = GeneratedColumn<double>(
    'expense',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isDemoMeta = const VerificationMeta('isDemo');
  @override
  late final GeneratedColumn<bool> isDemo = GeneratedColumn<bool>(
    'is_demo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_demo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workDate,
    checkInMinutes,
    checkOutMinutes,
    breakMinutes,
    dayType,
    extraOtHours,
    travelAllowance,
    specialAllowance,
    expense,
    note,
    isDemo,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('work_date')) {
      context.handle(
        _workDateMeta,
        workDate.isAcceptableOrUnknown(data['work_date']!, _workDateMeta),
      );
    } else if (isInserting) {
      context.missing(_workDateMeta);
    }
    if (data.containsKey('check_in_minutes')) {
      context.handle(
        _checkInMinutesMeta,
        checkInMinutes.isAcceptableOrUnknown(
          data['check_in_minutes']!,
          _checkInMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_checkInMinutesMeta);
    }
    if (data.containsKey('check_out_minutes')) {
      context.handle(
        _checkOutMinutesMeta,
        checkOutMinutes.isAcceptableOrUnknown(
          data['check_out_minutes']!,
          _checkOutMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_checkOutMinutesMeta);
    }
    if (data.containsKey('break_minutes')) {
      context.handle(
        _breakMinutesMeta,
        breakMinutes.isAcceptableOrUnknown(
          data['break_minutes']!,
          _breakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('day_type')) {
      context.handle(
        _dayTypeMeta,
        dayType.isAcceptableOrUnknown(data['day_type']!, _dayTypeMeta),
      );
    }
    if (data.containsKey('extra_ot_hours')) {
      context.handle(
        _extraOtHoursMeta,
        extraOtHours.isAcceptableOrUnknown(
          data['extra_ot_hours']!,
          _extraOtHoursMeta,
        ),
      );
    }
    if (data.containsKey('travel_allowance')) {
      context.handle(
        _travelAllowanceMeta,
        travelAllowance.isAcceptableOrUnknown(
          data['travel_allowance']!,
          _travelAllowanceMeta,
        ),
      );
    }
    if (data.containsKey('special_allowance')) {
      context.handle(
        _specialAllowanceMeta,
        specialAllowance.isAcceptableOrUnknown(
          data['special_allowance']!,
          _specialAllowanceMeta,
        ),
      );
    }
    if (data.containsKey('expense')) {
      context.handle(
        _expenseMeta,
        expense.isAcceptableOrUnknown(data['expense']!, _expenseMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('is_demo')) {
      context.handle(
        _isDemoMeta,
        isDemo.isAcceptableOrUnknown(data['is_demo']!, _isDemoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}work_date'],
      )!,
      checkInMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}check_in_minutes'],
      )!,
      checkOutMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}check_out_minutes'],
      )!,
      breakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}break_minutes'],
      )!,
      dayType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_type'],
      )!,
      extraOtHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}extra_ot_hours'],
      )!,
      travelAllowance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}travel_allowance'],
      )!,
      specialAllowance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}special_allowance'],
      )!,
      expense: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}expense'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      isDemo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_demo'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WorkRecordsTable createAlias(String alias) {
    return $WorkRecordsTable(attachedDatabase, alias);
  }
}

class WorkRecord extends DataClass implements Insertable<WorkRecord> {
  final String id;
  final DateTime workDate;
  final int checkInMinutes;
  final int checkOutMinutes;
  final int breakMinutes;
  final String dayType;
  final double extraOtHours;
  final double travelAllowance;
  final double specialAllowance;
  final double expense;
  final String note;
  final bool isDemo;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WorkRecord({
    required this.id,
    required this.workDate,
    required this.checkInMinutes,
    required this.checkOutMinutes,
    required this.breakMinutes,
    required this.dayType,
    required this.extraOtHours,
    required this.travelAllowance,
    required this.specialAllowance,
    required this.expense,
    required this.note,
    required this.isDemo,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['work_date'] = Variable<DateTime>(workDate);
    map['check_in_minutes'] = Variable<int>(checkInMinutes);
    map['check_out_minutes'] = Variable<int>(checkOutMinutes);
    map['break_minutes'] = Variable<int>(breakMinutes);
    map['day_type'] = Variable<String>(dayType);
    map['extra_ot_hours'] = Variable<double>(extraOtHours);
    map['travel_allowance'] = Variable<double>(travelAllowance);
    map['special_allowance'] = Variable<double>(specialAllowance);
    map['expense'] = Variable<double>(expense);
    map['note'] = Variable<String>(note);
    map['is_demo'] = Variable<bool>(isDemo);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorkRecordsCompanion toCompanion(bool nullToAbsent) {
    return WorkRecordsCompanion(
      id: Value(id),
      workDate: Value(workDate),
      checkInMinutes: Value(checkInMinutes),
      checkOutMinutes: Value(checkOutMinutes),
      breakMinutes: Value(breakMinutes),
      dayType: Value(dayType),
      extraOtHours: Value(extraOtHours),
      travelAllowance: Value(travelAllowance),
      specialAllowance: Value(specialAllowance),
      expense: Value(expense),
      note: Value(note),
      isDemo: Value(isDemo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WorkRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkRecord(
      id: serializer.fromJson<String>(json['id']),
      workDate: serializer.fromJson<DateTime>(json['workDate']),
      checkInMinutes: serializer.fromJson<int>(json['checkInMinutes']),
      checkOutMinutes: serializer.fromJson<int>(json['checkOutMinutes']),
      breakMinutes: serializer.fromJson<int>(json['breakMinutes']),
      dayType: serializer.fromJson<String>(json['dayType']),
      extraOtHours: serializer.fromJson<double>(json['extraOtHours']),
      travelAllowance: serializer.fromJson<double>(json['travelAllowance']),
      specialAllowance: serializer.fromJson<double>(json['specialAllowance']),
      expense: serializer.fromJson<double>(json['expense']),
      note: serializer.fromJson<String>(json['note']),
      isDemo: serializer.fromJson<bool>(json['isDemo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workDate': serializer.toJson<DateTime>(workDate),
      'checkInMinutes': serializer.toJson<int>(checkInMinutes),
      'checkOutMinutes': serializer.toJson<int>(checkOutMinutes),
      'breakMinutes': serializer.toJson<int>(breakMinutes),
      'dayType': serializer.toJson<String>(dayType),
      'extraOtHours': serializer.toJson<double>(extraOtHours),
      'travelAllowance': serializer.toJson<double>(travelAllowance),
      'specialAllowance': serializer.toJson<double>(specialAllowance),
      'expense': serializer.toJson<double>(expense),
      'note': serializer.toJson<String>(note),
      'isDemo': serializer.toJson<bool>(isDemo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WorkRecord copyWith({
    String? id,
    DateTime? workDate,
    int? checkInMinutes,
    int? checkOutMinutes,
    int? breakMinutes,
    String? dayType,
    double? extraOtHours,
    double? travelAllowance,
    double? specialAllowance,
    double? expense,
    String? note,
    bool? isDemo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WorkRecord(
    id: id ?? this.id,
    workDate: workDate ?? this.workDate,
    checkInMinutes: checkInMinutes ?? this.checkInMinutes,
    checkOutMinutes: checkOutMinutes ?? this.checkOutMinutes,
    breakMinutes: breakMinutes ?? this.breakMinutes,
    dayType: dayType ?? this.dayType,
    extraOtHours: extraOtHours ?? this.extraOtHours,
    travelAllowance: travelAllowance ?? this.travelAllowance,
    specialAllowance: specialAllowance ?? this.specialAllowance,
    expense: expense ?? this.expense,
    note: note ?? this.note,
    isDemo: isDemo ?? this.isDemo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WorkRecord copyWithCompanion(WorkRecordsCompanion data) {
    return WorkRecord(
      id: data.id.present ? data.id.value : this.id,
      workDate: data.workDate.present ? data.workDate.value : this.workDate,
      checkInMinutes: data.checkInMinutes.present
          ? data.checkInMinutes.value
          : this.checkInMinutes,
      checkOutMinutes: data.checkOutMinutes.present
          ? data.checkOutMinutes.value
          : this.checkOutMinutes,
      breakMinutes: data.breakMinutes.present
          ? data.breakMinutes.value
          : this.breakMinutes,
      dayType: data.dayType.present ? data.dayType.value : this.dayType,
      extraOtHours: data.extraOtHours.present
          ? data.extraOtHours.value
          : this.extraOtHours,
      travelAllowance: data.travelAllowance.present
          ? data.travelAllowance.value
          : this.travelAllowance,
      specialAllowance: data.specialAllowance.present
          ? data.specialAllowance.value
          : this.specialAllowance,
      expense: data.expense.present ? data.expense.value : this.expense,
      note: data.note.present ? data.note.value : this.note,
      isDemo: data.isDemo.present ? data.isDemo.value : this.isDemo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkRecord(')
          ..write('id: $id, ')
          ..write('workDate: $workDate, ')
          ..write('checkInMinutes: $checkInMinutes, ')
          ..write('checkOutMinutes: $checkOutMinutes, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('dayType: $dayType, ')
          ..write('extraOtHours: $extraOtHours, ')
          ..write('travelAllowance: $travelAllowance, ')
          ..write('specialAllowance: $specialAllowance, ')
          ..write('expense: $expense, ')
          ..write('note: $note, ')
          ..write('isDemo: $isDemo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workDate,
    checkInMinutes,
    checkOutMinutes,
    breakMinutes,
    dayType,
    extraOtHours,
    travelAllowance,
    specialAllowance,
    expense,
    note,
    isDemo,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkRecord &&
          other.id == this.id &&
          other.workDate == this.workDate &&
          other.checkInMinutes == this.checkInMinutes &&
          other.checkOutMinutes == this.checkOutMinutes &&
          other.breakMinutes == this.breakMinutes &&
          other.dayType == this.dayType &&
          other.extraOtHours == this.extraOtHours &&
          other.travelAllowance == this.travelAllowance &&
          other.specialAllowance == this.specialAllowance &&
          other.expense == this.expense &&
          other.note == this.note &&
          other.isDemo == this.isDemo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorkRecordsCompanion extends UpdateCompanion<WorkRecord> {
  final Value<String> id;
  final Value<DateTime> workDate;
  final Value<int> checkInMinutes;
  final Value<int> checkOutMinutes;
  final Value<int> breakMinutes;
  final Value<String> dayType;
  final Value<double> extraOtHours;
  final Value<double> travelAllowance;
  final Value<double> specialAllowance;
  final Value<double> expense;
  final Value<String> note;
  final Value<bool> isDemo;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WorkRecordsCompanion({
    this.id = const Value.absent(),
    this.workDate = const Value.absent(),
    this.checkInMinutes = const Value.absent(),
    this.checkOutMinutes = const Value.absent(),
    this.breakMinutes = const Value.absent(),
    this.dayType = const Value.absent(),
    this.extraOtHours = const Value.absent(),
    this.travelAllowance = const Value.absent(),
    this.specialAllowance = const Value.absent(),
    this.expense = const Value.absent(),
    this.note = const Value.absent(),
    this.isDemo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkRecordsCompanion.insert({
    required String id,
    required DateTime workDate,
    required int checkInMinutes,
    required int checkOutMinutes,
    this.breakMinutes = const Value.absent(),
    this.dayType = const Value.absent(),
    this.extraOtHours = const Value.absent(),
    this.travelAllowance = const Value.absent(),
    this.specialAllowance = const Value.absent(),
    this.expense = const Value.absent(),
    this.note = const Value.absent(),
    this.isDemo = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workDate = Value(workDate),
       checkInMinutes = Value(checkInMinutes),
       checkOutMinutes = Value(checkOutMinutes),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<WorkRecord> custom({
    Expression<String>? id,
    Expression<DateTime>? workDate,
    Expression<int>? checkInMinutes,
    Expression<int>? checkOutMinutes,
    Expression<int>? breakMinutes,
    Expression<String>? dayType,
    Expression<double>? extraOtHours,
    Expression<double>? travelAllowance,
    Expression<double>? specialAllowance,
    Expression<double>? expense,
    Expression<String>? note,
    Expression<bool>? isDemo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workDate != null) 'work_date': workDate,
      if (checkInMinutes != null) 'check_in_minutes': checkInMinutes,
      if (checkOutMinutes != null) 'check_out_minutes': checkOutMinutes,
      if (breakMinutes != null) 'break_minutes': breakMinutes,
      if (dayType != null) 'day_type': dayType,
      if (extraOtHours != null) 'extra_ot_hours': extraOtHours,
      if (travelAllowance != null) 'travel_allowance': travelAllowance,
      if (specialAllowance != null) 'special_allowance': specialAllowance,
      if (expense != null) 'expense': expense,
      if (note != null) 'note': note,
      if (isDemo != null) 'is_demo': isDemo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkRecordsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? workDate,
    Value<int>? checkInMinutes,
    Value<int>? checkOutMinutes,
    Value<int>? breakMinutes,
    Value<String>? dayType,
    Value<double>? extraOtHours,
    Value<double>? travelAllowance,
    Value<double>? specialAllowance,
    Value<double>? expense,
    Value<String>? note,
    Value<bool>? isDemo,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorkRecordsCompanion(
      id: id ?? this.id,
      workDate: workDate ?? this.workDate,
      checkInMinutes: checkInMinutes ?? this.checkInMinutes,
      checkOutMinutes: checkOutMinutes ?? this.checkOutMinutes,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      dayType: dayType ?? this.dayType,
      extraOtHours: extraOtHours ?? this.extraOtHours,
      travelAllowance: travelAllowance ?? this.travelAllowance,
      specialAllowance: specialAllowance ?? this.specialAllowance,
      expense: expense ?? this.expense,
      note: note ?? this.note,
      isDemo: isDemo ?? this.isDemo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workDate.present) {
      map['work_date'] = Variable<DateTime>(workDate.value);
    }
    if (checkInMinutes.present) {
      map['check_in_minutes'] = Variable<int>(checkInMinutes.value);
    }
    if (checkOutMinutes.present) {
      map['check_out_minutes'] = Variable<int>(checkOutMinutes.value);
    }
    if (breakMinutes.present) {
      map['break_minutes'] = Variable<int>(breakMinutes.value);
    }
    if (dayType.present) {
      map['day_type'] = Variable<String>(dayType.value);
    }
    if (extraOtHours.present) {
      map['extra_ot_hours'] = Variable<double>(extraOtHours.value);
    }
    if (travelAllowance.present) {
      map['travel_allowance'] = Variable<double>(travelAllowance.value);
    }
    if (specialAllowance.present) {
      map['special_allowance'] = Variable<double>(specialAllowance.value);
    }
    if (expense.present) {
      map['expense'] = Variable<double>(expense.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isDemo.present) {
      map['is_demo'] = Variable<bool>(isDemo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkRecordsCompanion(')
          ..write('id: $id, ')
          ..write('workDate: $workDate, ')
          ..write('checkInMinutes: $checkInMinutes, ')
          ..write('checkOutMinutes: $checkOutMinutes, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('dayType: $dayType, ')
          ..write('extraOtHours: $extraOtHours, ')
          ..write('travelAllowance: $travelAllowance, ')
          ..write('specialAllowance: $specialAllowance, ')
          ..write('expense: $expense, ')
          ..write('note: $note, ')
          ..write('isDemo: $isDemo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('default'),
  );
  static const VerificationMeta _monthlySalaryMeta = const VerificationMeta(
    'monthlySalary',
  );
  @override
  late final GeneratedColumn<double> monthlySalary = GeneratedColumn<double>(
    'monthly_salary',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(15000),
  );
  static const VerificationMeta _dailyWageMeta = const VerificationMeta(
    'dailyWage',
  );
  @override
  late final GeneratedColumn<double> dailyWage = GeneratedColumn<double>(
    'daily_wage',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(500),
  );
  static const VerificationMeta _normalWorkHoursMeta = const VerificationMeta(
    'normalWorkHours',
  );
  @override
  late final GeneratedColumn<double> normalWorkHours = GeneratedColumn<double>(
    'normal_work_hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _otRate1Meta = const VerificationMeta(
    'otRate1',
  );
  @override
  late final GeneratedColumn<double> otRate1 = GeneratedColumn<double>(
    'ot_rate1',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _otRate15Meta = const VerificationMeta(
    'otRate15',
  );
  @override
  late final GeneratedColumn<double> otRate15 = GeneratedColumn<double>(
    'ot_rate15',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.5),
  );
  static const VerificationMeta _otRate2Meta = const VerificationMeta(
    'otRate2',
  );
  @override
  late final GeneratedColumn<double> otRate2 = GeneratedColumn<double>(
    'ot_rate2',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _otRate3Meta = const VerificationMeta(
    'otRate3',
  );
  @override
  late final GeneratedColumn<double> otRate3 = GeneratedColumn<double>(
    'ot_rate3',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _normalDayMultiplierMeta =
      const VerificationMeta('normalDayMultiplier');
  @override
  late final GeneratedColumn<double> normalDayMultiplier =
      GeneratedColumn<double>(
        'normal_day_multiplier',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(1),
      );
  static const VerificationMeta _weekendDayMultiplierMeta =
      const VerificationMeta('weekendDayMultiplier');
  @override
  late final GeneratedColumn<double> weekendDayMultiplier =
      GeneratedColumn<double>(
        'weekend_day_multiplier',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(3),
      );
  static const VerificationMeta _holidayDayMultiplierMeta =
      const VerificationMeta('holidayDayMultiplier');
  @override
  late final GeneratedColumn<double> holidayDayMultiplier =
      GeneratedColumn<double>(
        'holiday_day_multiplier',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(3),
      );
  static const VerificationMeta _normalOtMultiplierMeta =
      const VerificationMeta('normalOtMultiplier');
  @override
  late final GeneratedColumn<double> normalOtMultiplier =
      GeneratedColumn<double>(
        'normal_ot_multiplier',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(1.5),
      );
  static const VerificationMeta _weekendOtMultiplierMeta =
      const VerificationMeta('weekendOtMultiplier');
  @override
  late final GeneratedColumn<double> weekendOtMultiplier =
      GeneratedColumn<double>(
        'weekend_ot_multiplier',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(3),
      );
  static const VerificationMeta _holidayOtMultiplierMeta =
      const VerificationMeta('holidayOtMultiplier');
  @override
  late final GeneratedColumn<double> holidayOtMultiplier =
      GeneratedColumn<double>(
        'holiday_ot_multiplier',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(3),
      );
  static const VerificationMeta _nightOtMultiplierMeta = const VerificationMeta(
    'nightOtMultiplier',
  );
  @override
  late final GeneratedColumn<double> nightOtMultiplier =
      GeneratedColumn<double>(
        'night_ot_multiplier',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(2),
      );
  static const VerificationMeta _mealAllowanceDefaultMeta =
      const VerificationMeta('mealAllowanceDefault');
  @override
  late final GeneratedColumn<double> mealAllowanceDefault =
      GeneratedColumn<double>(
        'meal_allowance_default',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _travelAllowanceDefaultMeta =
      const VerificationMeta('travelAllowanceDefault');
  @override
  late final GeneratedColumn<double> travelAllowanceDefault =
      GeneratedColumn<double>(
        'travel_allowance_default',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _otherAllowanceDefaultMeta =
      const VerificationMeta('otherAllowanceDefault');
  @override
  late final GeneratedColumn<double> otherAllowanceDefault =
      GeneratedColumn<double>(
        'other_allowance_default',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _socialSecurityDeductionMeta =
      const VerificationMeta('socialSecurityDeduction');
  @override
  late final GeneratedColumn<double> socialSecurityDeduction =
      GeneratedColumn<double>(
        'social_security_deduction',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(750),
      );
  static const VerificationMeta _taxDeductionMeta = const VerificationMeta(
    'taxDeduction',
  );
  @override
  late final GeneratedColumn<double> taxDeduction = GeneratedColumn<double>(
    'tax_deduction',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nightShiftStartMinutesMeta =
      const VerificationMeta('nightShiftStartMinutes');
  @override
  late final GeneratedColumn<int> nightShiftStartMinutes = GeneratedColumn<int>(
    'night_shift_start_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1320),
  );
  static const VerificationMeta _nightShiftEndMinutesMeta =
      const VerificationMeta('nightShiftEndMinutes');
  @override
  late final GeneratedColumn<int> nightShiftEndMinutes = GeneratedColumn<int>(
    'night_shift_end_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(300),
  );
  static const VerificationMeta _defaultBreakMinutesMeta =
      const VerificationMeta('defaultBreakMinutes');
  @override
  late final GeneratedColumn<int> defaultBreakMinutes = GeneratedColumn<int>(
    'default_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _companyNameMeta = const VerificationMeta(
    'companyName',
  );
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
    'company_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _employeeNameMeta = const VerificationMeta(
    'employeeName',
  );
  @override
  late final GeneratedColumn<String> employeeName = GeneratedColumn<String>(
    'employee_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    monthlySalary,
    dailyWage,
    normalWorkHours,
    otRate1,
    otRate15,
    otRate2,
    otRate3,
    normalDayMultiplier,
    weekendDayMultiplier,
    holidayDayMultiplier,
    normalOtMultiplier,
    weekendOtMultiplier,
    holidayOtMultiplier,
    nightOtMultiplier,
    mealAllowanceDefault,
    travelAllowanceDefault,
    otherAllowanceDefault,
    socialSecurityDeduction,
    taxDeduction,
    nightShiftStartMinutes,
    nightShiftEndMinutes,
    defaultBreakMinutes,
    companyName,
    employeeName,
    employeeId,
    themeMode,
    onboardingCompleted,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('monthly_salary')) {
      context.handle(
        _monthlySalaryMeta,
        monthlySalary.isAcceptableOrUnknown(
          data['monthly_salary']!,
          _monthlySalaryMeta,
        ),
      );
    }
    if (data.containsKey('daily_wage')) {
      context.handle(
        _dailyWageMeta,
        dailyWage.isAcceptableOrUnknown(data['daily_wage']!, _dailyWageMeta),
      );
    }
    if (data.containsKey('normal_work_hours')) {
      context.handle(
        _normalWorkHoursMeta,
        normalWorkHours.isAcceptableOrUnknown(
          data['normal_work_hours']!,
          _normalWorkHoursMeta,
        ),
      );
    }
    if (data.containsKey('ot_rate1')) {
      context.handle(
        _otRate1Meta,
        otRate1.isAcceptableOrUnknown(data['ot_rate1']!, _otRate1Meta),
      );
    }
    if (data.containsKey('ot_rate15')) {
      context.handle(
        _otRate15Meta,
        otRate15.isAcceptableOrUnknown(data['ot_rate15']!, _otRate15Meta),
      );
    }
    if (data.containsKey('ot_rate2')) {
      context.handle(
        _otRate2Meta,
        otRate2.isAcceptableOrUnknown(data['ot_rate2']!, _otRate2Meta),
      );
    }
    if (data.containsKey('ot_rate3')) {
      context.handle(
        _otRate3Meta,
        otRate3.isAcceptableOrUnknown(data['ot_rate3']!, _otRate3Meta),
      );
    }
    if (data.containsKey('normal_day_multiplier')) {
      context.handle(
        _normalDayMultiplierMeta,
        normalDayMultiplier.isAcceptableOrUnknown(
          data['normal_day_multiplier']!,
          _normalDayMultiplierMeta,
        ),
      );
    }
    if (data.containsKey('weekend_day_multiplier')) {
      context.handle(
        _weekendDayMultiplierMeta,
        weekendDayMultiplier.isAcceptableOrUnknown(
          data['weekend_day_multiplier']!,
          _weekendDayMultiplierMeta,
        ),
      );
    }
    if (data.containsKey('holiday_day_multiplier')) {
      context.handle(
        _holidayDayMultiplierMeta,
        holidayDayMultiplier.isAcceptableOrUnknown(
          data['holiday_day_multiplier']!,
          _holidayDayMultiplierMeta,
        ),
      );
    }
    if (data.containsKey('normal_ot_multiplier')) {
      context.handle(
        _normalOtMultiplierMeta,
        normalOtMultiplier.isAcceptableOrUnknown(
          data['normal_ot_multiplier']!,
          _normalOtMultiplierMeta,
        ),
      );
    }
    if (data.containsKey('weekend_ot_multiplier')) {
      context.handle(
        _weekendOtMultiplierMeta,
        weekendOtMultiplier.isAcceptableOrUnknown(
          data['weekend_ot_multiplier']!,
          _weekendOtMultiplierMeta,
        ),
      );
    }
    if (data.containsKey('holiday_ot_multiplier')) {
      context.handle(
        _holidayOtMultiplierMeta,
        holidayOtMultiplier.isAcceptableOrUnknown(
          data['holiday_ot_multiplier']!,
          _holidayOtMultiplierMeta,
        ),
      );
    }
    if (data.containsKey('night_ot_multiplier')) {
      context.handle(
        _nightOtMultiplierMeta,
        nightOtMultiplier.isAcceptableOrUnknown(
          data['night_ot_multiplier']!,
          _nightOtMultiplierMeta,
        ),
      );
    }
    if (data.containsKey('meal_allowance_default')) {
      context.handle(
        _mealAllowanceDefaultMeta,
        mealAllowanceDefault.isAcceptableOrUnknown(
          data['meal_allowance_default']!,
          _mealAllowanceDefaultMeta,
        ),
      );
    }
    if (data.containsKey('travel_allowance_default')) {
      context.handle(
        _travelAllowanceDefaultMeta,
        travelAllowanceDefault.isAcceptableOrUnknown(
          data['travel_allowance_default']!,
          _travelAllowanceDefaultMeta,
        ),
      );
    }
    if (data.containsKey('other_allowance_default')) {
      context.handle(
        _otherAllowanceDefaultMeta,
        otherAllowanceDefault.isAcceptableOrUnknown(
          data['other_allowance_default']!,
          _otherAllowanceDefaultMeta,
        ),
      );
    }
    if (data.containsKey('social_security_deduction')) {
      context.handle(
        _socialSecurityDeductionMeta,
        socialSecurityDeduction.isAcceptableOrUnknown(
          data['social_security_deduction']!,
          _socialSecurityDeductionMeta,
        ),
      );
    }
    if (data.containsKey('tax_deduction')) {
      context.handle(
        _taxDeductionMeta,
        taxDeduction.isAcceptableOrUnknown(
          data['tax_deduction']!,
          _taxDeductionMeta,
        ),
      );
    }
    if (data.containsKey('night_shift_start_minutes')) {
      context.handle(
        _nightShiftStartMinutesMeta,
        nightShiftStartMinutes.isAcceptableOrUnknown(
          data['night_shift_start_minutes']!,
          _nightShiftStartMinutesMeta,
        ),
      );
    }
    if (data.containsKey('night_shift_end_minutes')) {
      context.handle(
        _nightShiftEndMinutesMeta,
        nightShiftEndMinutes.isAcceptableOrUnknown(
          data['night_shift_end_minutes']!,
          _nightShiftEndMinutesMeta,
        ),
      );
    }
    if (data.containsKey('default_break_minutes')) {
      context.handle(
        _defaultBreakMinutesMeta,
        defaultBreakMinutes.isAcceptableOrUnknown(
          data['default_break_minutes']!,
          _defaultBreakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('company_name')) {
      context.handle(
        _companyNameMeta,
        companyName.isAcceptableOrUnknown(
          data['company_name']!,
          _companyNameMeta,
        ),
      );
    }
    if (data.containsKey('employee_name')) {
      context.handle(
        _employeeNameMeta,
        employeeName.isAcceptableOrUnknown(
          data['employee_name']!,
          _employeeNameMeta,
        ),
      );
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      monthlySalary: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monthly_salary'],
      )!,
      dailyWage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}daily_wage'],
      )!,
      normalWorkHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}normal_work_hours'],
      )!,
      otRate1: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ot_rate1'],
      )!,
      otRate15: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ot_rate15'],
      )!,
      otRate2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ot_rate2'],
      )!,
      otRate3: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ot_rate3'],
      )!,
      normalDayMultiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}normal_day_multiplier'],
      )!,
      weekendDayMultiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weekend_day_multiplier'],
      )!,
      holidayDayMultiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}holiday_day_multiplier'],
      )!,
      normalOtMultiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}normal_ot_multiplier'],
      )!,
      weekendOtMultiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weekend_ot_multiplier'],
      )!,
      holidayOtMultiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}holiday_ot_multiplier'],
      )!,
      nightOtMultiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}night_ot_multiplier'],
      )!,
      mealAllowanceDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}meal_allowance_default'],
      )!,
      travelAllowanceDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}travel_allowance_default'],
      )!,
      otherAllowanceDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}other_allowance_default'],
      )!,
      socialSecurityDeduction: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}social_security_deduction'],
      )!,
      taxDeduction: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_deduction'],
      )!,
      nightShiftStartMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}night_shift_start_minutes'],
      )!,
      nightShiftEndMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}night_shift_end_minutes'],
      )!,
      defaultBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_break_minutes'],
      )!,
      companyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_name'],
      )!,
      employeeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_name'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String id;
  final double monthlySalary;
  final double dailyWage;
  final double normalWorkHours;
  final double otRate1;
  final double otRate15;
  final double otRate2;
  final double otRate3;
  final double normalDayMultiplier;
  final double weekendDayMultiplier;
  final double holidayDayMultiplier;
  final double normalOtMultiplier;
  final double weekendOtMultiplier;
  final double holidayOtMultiplier;
  final double nightOtMultiplier;
  final double mealAllowanceDefault;
  final double travelAllowanceDefault;
  final double otherAllowanceDefault;
  final double socialSecurityDeduction;
  final double taxDeduction;
  final int nightShiftStartMinutes;
  final int nightShiftEndMinutes;
  final int defaultBreakMinutes;
  final String companyName;
  final String employeeName;
  final String employeeId;
  final String themeMode;
  final bool onboardingCompleted;
  final DateTime updatedAt;
  const AppSetting({
    required this.id,
    required this.monthlySalary,
    required this.dailyWage,
    required this.normalWorkHours,
    required this.otRate1,
    required this.otRate15,
    required this.otRate2,
    required this.otRate3,
    required this.normalDayMultiplier,
    required this.weekendDayMultiplier,
    required this.holidayDayMultiplier,
    required this.normalOtMultiplier,
    required this.weekendOtMultiplier,
    required this.holidayOtMultiplier,
    required this.nightOtMultiplier,
    required this.mealAllowanceDefault,
    required this.travelAllowanceDefault,
    required this.otherAllowanceDefault,
    required this.socialSecurityDeduction,
    required this.taxDeduction,
    required this.nightShiftStartMinutes,
    required this.nightShiftEndMinutes,
    required this.defaultBreakMinutes,
    required this.companyName,
    required this.employeeName,
    required this.employeeId,
    required this.themeMode,
    required this.onboardingCompleted,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['monthly_salary'] = Variable<double>(monthlySalary);
    map['daily_wage'] = Variable<double>(dailyWage);
    map['normal_work_hours'] = Variable<double>(normalWorkHours);
    map['ot_rate1'] = Variable<double>(otRate1);
    map['ot_rate15'] = Variable<double>(otRate15);
    map['ot_rate2'] = Variable<double>(otRate2);
    map['ot_rate3'] = Variable<double>(otRate3);
    map['normal_day_multiplier'] = Variable<double>(normalDayMultiplier);
    map['weekend_day_multiplier'] = Variable<double>(weekendDayMultiplier);
    map['holiday_day_multiplier'] = Variable<double>(holidayDayMultiplier);
    map['normal_ot_multiplier'] = Variable<double>(normalOtMultiplier);
    map['weekend_ot_multiplier'] = Variable<double>(weekendOtMultiplier);
    map['holiday_ot_multiplier'] = Variable<double>(holidayOtMultiplier);
    map['night_ot_multiplier'] = Variable<double>(nightOtMultiplier);
    map['meal_allowance_default'] = Variable<double>(mealAllowanceDefault);
    map['travel_allowance_default'] = Variable<double>(travelAllowanceDefault);
    map['other_allowance_default'] = Variable<double>(otherAllowanceDefault);
    map['social_security_deduction'] = Variable<double>(
      socialSecurityDeduction,
    );
    map['tax_deduction'] = Variable<double>(taxDeduction);
    map['night_shift_start_minutes'] = Variable<int>(nightShiftStartMinutes);
    map['night_shift_end_minutes'] = Variable<int>(nightShiftEndMinutes);
    map['default_break_minutes'] = Variable<int>(defaultBreakMinutes);
    map['company_name'] = Variable<String>(companyName);
    map['employee_name'] = Variable<String>(employeeName);
    map['employee_id'] = Variable<String>(employeeId);
    map['theme_mode'] = Variable<String>(themeMode);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      monthlySalary: Value(monthlySalary),
      dailyWage: Value(dailyWage),
      normalWorkHours: Value(normalWorkHours),
      otRate1: Value(otRate1),
      otRate15: Value(otRate15),
      otRate2: Value(otRate2),
      otRate3: Value(otRate3),
      normalDayMultiplier: Value(normalDayMultiplier),
      weekendDayMultiplier: Value(weekendDayMultiplier),
      holidayDayMultiplier: Value(holidayDayMultiplier),
      normalOtMultiplier: Value(normalOtMultiplier),
      weekendOtMultiplier: Value(weekendOtMultiplier),
      holidayOtMultiplier: Value(holidayOtMultiplier),
      nightOtMultiplier: Value(nightOtMultiplier),
      mealAllowanceDefault: Value(mealAllowanceDefault),
      travelAllowanceDefault: Value(travelAllowanceDefault),
      otherAllowanceDefault: Value(otherAllowanceDefault),
      socialSecurityDeduction: Value(socialSecurityDeduction),
      taxDeduction: Value(taxDeduction),
      nightShiftStartMinutes: Value(nightShiftStartMinutes),
      nightShiftEndMinutes: Value(nightShiftEndMinutes),
      defaultBreakMinutes: Value(defaultBreakMinutes),
      companyName: Value(companyName),
      employeeName: Value(employeeName),
      employeeId: Value(employeeId),
      themeMode: Value(themeMode),
      onboardingCompleted: Value(onboardingCompleted),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<String>(json['id']),
      monthlySalary: serializer.fromJson<double>(json['monthlySalary']),
      dailyWage: serializer.fromJson<double>(json['dailyWage']),
      normalWorkHours: serializer.fromJson<double>(json['normalWorkHours']),
      otRate1: serializer.fromJson<double>(json['otRate1']),
      otRate15: serializer.fromJson<double>(json['otRate15']),
      otRate2: serializer.fromJson<double>(json['otRate2']),
      otRate3: serializer.fromJson<double>(json['otRate3']),
      normalDayMultiplier: serializer.fromJson<double>(
        json['normalDayMultiplier'],
      ),
      weekendDayMultiplier: serializer.fromJson<double>(
        json['weekendDayMultiplier'],
      ),
      holidayDayMultiplier: serializer.fromJson<double>(
        json['holidayDayMultiplier'],
      ),
      normalOtMultiplier: serializer.fromJson<double>(
        json['normalOtMultiplier'],
      ),
      weekendOtMultiplier: serializer.fromJson<double>(
        json['weekendOtMultiplier'],
      ),
      holidayOtMultiplier: serializer.fromJson<double>(
        json['holidayOtMultiplier'],
      ),
      nightOtMultiplier: serializer.fromJson<double>(json['nightOtMultiplier']),
      mealAllowanceDefault: serializer.fromJson<double>(
        json['mealAllowanceDefault'],
      ),
      travelAllowanceDefault: serializer.fromJson<double>(
        json['travelAllowanceDefault'],
      ),
      otherAllowanceDefault: serializer.fromJson<double>(
        json['otherAllowanceDefault'],
      ),
      socialSecurityDeduction: serializer.fromJson<double>(
        json['socialSecurityDeduction'],
      ),
      taxDeduction: serializer.fromJson<double>(json['taxDeduction']),
      nightShiftStartMinutes: serializer.fromJson<int>(
        json['nightShiftStartMinutes'],
      ),
      nightShiftEndMinutes: serializer.fromJson<int>(
        json['nightShiftEndMinutes'],
      ),
      defaultBreakMinutes: serializer.fromJson<int>(
        json['defaultBreakMinutes'],
      ),
      companyName: serializer.fromJson<String>(json['companyName']),
      employeeName: serializer.fromJson<String>(json['employeeName']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'monthlySalary': serializer.toJson<double>(monthlySalary),
      'dailyWage': serializer.toJson<double>(dailyWage),
      'normalWorkHours': serializer.toJson<double>(normalWorkHours),
      'otRate1': serializer.toJson<double>(otRate1),
      'otRate15': serializer.toJson<double>(otRate15),
      'otRate2': serializer.toJson<double>(otRate2),
      'otRate3': serializer.toJson<double>(otRate3),
      'normalDayMultiplier': serializer.toJson<double>(normalDayMultiplier),
      'weekendDayMultiplier': serializer.toJson<double>(weekendDayMultiplier),
      'holidayDayMultiplier': serializer.toJson<double>(holidayDayMultiplier),
      'normalOtMultiplier': serializer.toJson<double>(normalOtMultiplier),
      'weekendOtMultiplier': serializer.toJson<double>(weekendOtMultiplier),
      'holidayOtMultiplier': serializer.toJson<double>(holidayOtMultiplier),
      'nightOtMultiplier': serializer.toJson<double>(nightOtMultiplier),
      'mealAllowanceDefault': serializer.toJson<double>(mealAllowanceDefault),
      'travelAllowanceDefault': serializer.toJson<double>(
        travelAllowanceDefault,
      ),
      'otherAllowanceDefault': serializer.toJson<double>(otherAllowanceDefault),
      'socialSecurityDeduction': serializer.toJson<double>(
        socialSecurityDeduction,
      ),
      'taxDeduction': serializer.toJson<double>(taxDeduction),
      'nightShiftStartMinutes': serializer.toJson<int>(nightShiftStartMinutes),
      'nightShiftEndMinutes': serializer.toJson<int>(nightShiftEndMinutes),
      'defaultBreakMinutes': serializer.toJson<int>(defaultBreakMinutes),
      'companyName': serializer.toJson<String>(companyName),
      'employeeName': serializer.toJson<String>(employeeName),
      'employeeId': serializer.toJson<String>(employeeId),
      'themeMode': serializer.toJson<String>(themeMode),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSetting copyWith({
    String? id,
    double? monthlySalary,
    double? dailyWage,
    double? normalWorkHours,
    double? otRate1,
    double? otRate15,
    double? otRate2,
    double? otRate3,
    double? normalDayMultiplier,
    double? weekendDayMultiplier,
    double? holidayDayMultiplier,
    double? normalOtMultiplier,
    double? weekendOtMultiplier,
    double? holidayOtMultiplier,
    double? nightOtMultiplier,
    double? mealAllowanceDefault,
    double? travelAllowanceDefault,
    double? otherAllowanceDefault,
    double? socialSecurityDeduction,
    double? taxDeduction,
    int? nightShiftStartMinutes,
    int? nightShiftEndMinutes,
    int? defaultBreakMinutes,
    String? companyName,
    String? employeeName,
    String? employeeId,
    String? themeMode,
    bool? onboardingCompleted,
    DateTime? updatedAt,
  }) => AppSetting(
    id: id ?? this.id,
    monthlySalary: monthlySalary ?? this.monthlySalary,
    dailyWage: dailyWage ?? this.dailyWage,
    normalWorkHours: normalWorkHours ?? this.normalWorkHours,
    otRate1: otRate1 ?? this.otRate1,
    otRate15: otRate15 ?? this.otRate15,
    otRate2: otRate2 ?? this.otRate2,
    otRate3: otRate3 ?? this.otRate3,
    normalDayMultiplier: normalDayMultiplier ?? this.normalDayMultiplier,
    weekendDayMultiplier: weekendDayMultiplier ?? this.weekendDayMultiplier,
    holidayDayMultiplier: holidayDayMultiplier ?? this.holidayDayMultiplier,
    normalOtMultiplier: normalOtMultiplier ?? this.normalOtMultiplier,
    weekendOtMultiplier: weekendOtMultiplier ?? this.weekendOtMultiplier,
    holidayOtMultiplier: holidayOtMultiplier ?? this.holidayOtMultiplier,
    nightOtMultiplier: nightOtMultiplier ?? this.nightOtMultiplier,
    mealAllowanceDefault: mealAllowanceDefault ?? this.mealAllowanceDefault,
    travelAllowanceDefault:
        travelAllowanceDefault ?? this.travelAllowanceDefault,
    otherAllowanceDefault: otherAllowanceDefault ?? this.otherAllowanceDefault,
    socialSecurityDeduction:
        socialSecurityDeduction ?? this.socialSecurityDeduction,
    taxDeduction: taxDeduction ?? this.taxDeduction,
    nightShiftStartMinutes:
        nightShiftStartMinutes ?? this.nightShiftStartMinutes,
    nightShiftEndMinutes: nightShiftEndMinutes ?? this.nightShiftEndMinutes,
    defaultBreakMinutes: defaultBreakMinutes ?? this.defaultBreakMinutes,
    companyName: companyName ?? this.companyName,
    employeeName: employeeName ?? this.employeeName,
    employeeId: employeeId ?? this.employeeId,
    themeMode: themeMode ?? this.themeMode,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      monthlySalary: data.monthlySalary.present
          ? data.monthlySalary.value
          : this.monthlySalary,
      dailyWage: data.dailyWage.present ? data.dailyWage.value : this.dailyWage,
      normalWorkHours: data.normalWorkHours.present
          ? data.normalWorkHours.value
          : this.normalWorkHours,
      otRate1: data.otRate1.present ? data.otRate1.value : this.otRate1,
      otRate15: data.otRate15.present ? data.otRate15.value : this.otRate15,
      otRate2: data.otRate2.present ? data.otRate2.value : this.otRate2,
      otRate3: data.otRate3.present ? data.otRate3.value : this.otRate3,
      normalDayMultiplier: data.normalDayMultiplier.present
          ? data.normalDayMultiplier.value
          : this.normalDayMultiplier,
      weekendDayMultiplier: data.weekendDayMultiplier.present
          ? data.weekendDayMultiplier.value
          : this.weekendDayMultiplier,
      holidayDayMultiplier: data.holidayDayMultiplier.present
          ? data.holidayDayMultiplier.value
          : this.holidayDayMultiplier,
      normalOtMultiplier: data.normalOtMultiplier.present
          ? data.normalOtMultiplier.value
          : this.normalOtMultiplier,
      weekendOtMultiplier: data.weekendOtMultiplier.present
          ? data.weekendOtMultiplier.value
          : this.weekendOtMultiplier,
      holidayOtMultiplier: data.holidayOtMultiplier.present
          ? data.holidayOtMultiplier.value
          : this.holidayOtMultiplier,
      nightOtMultiplier: data.nightOtMultiplier.present
          ? data.nightOtMultiplier.value
          : this.nightOtMultiplier,
      mealAllowanceDefault: data.mealAllowanceDefault.present
          ? data.mealAllowanceDefault.value
          : this.mealAllowanceDefault,
      travelAllowanceDefault: data.travelAllowanceDefault.present
          ? data.travelAllowanceDefault.value
          : this.travelAllowanceDefault,
      otherAllowanceDefault: data.otherAllowanceDefault.present
          ? data.otherAllowanceDefault.value
          : this.otherAllowanceDefault,
      socialSecurityDeduction: data.socialSecurityDeduction.present
          ? data.socialSecurityDeduction.value
          : this.socialSecurityDeduction,
      taxDeduction: data.taxDeduction.present
          ? data.taxDeduction.value
          : this.taxDeduction,
      nightShiftStartMinutes: data.nightShiftStartMinutes.present
          ? data.nightShiftStartMinutes.value
          : this.nightShiftStartMinutes,
      nightShiftEndMinutes: data.nightShiftEndMinutes.present
          ? data.nightShiftEndMinutes.value
          : this.nightShiftEndMinutes,
      defaultBreakMinutes: data.defaultBreakMinutes.present
          ? data.defaultBreakMinutes.value
          : this.defaultBreakMinutes,
      companyName: data.companyName.present
          ? data.companyName.value
          : this.companyName,
      employeeName: data.employeeName.present
          ? data.employeeName.value
          : this.employeeName,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('monthlySalary: $monthlySalary, ')
          ..write('dailyWage: $dailyWage, ')
          ..write('normalWorkHours: $normalWorkHours, ')
          ..write('otRate1: $otRate1, ')
          ..write('otRate15: $otRate15, ')
          ..write('otRate2: $otRate2, ')
          ..write('otRate3: $otRate3, ')
          ..write('normalDayMultiplier: $normalDayMultiplier, ')
          ..write('weekendDayMultiplier: $weekendDayMultiplier, ')
          ..write('holidayDayMultiplier: $holidayDayMultiplier, ')
          ..write('normalOtMultiplier: $normalOtMultiplier, ')
          ..write('weekendOtMultiplier: $weekendOtMultiplier, ')
          ..write('holidayOtMultiplier: $holidayOtMultiplier, ')
          ..write('nightOtMultiplier: $nightOtMultiplier, ')
          ..write('mealAllowanceDefault: $mealAllowanceDefault, ')
          ..write('travelAllowanceDefault: $travelAllowanceDefault, ')
          ..write('otherAllowanceDefault: $otherAllowanceDefault, ')
          ..write('socialSecurityDeduction: $socialSecurityDeduction, ')
          ..write('taxDeduction: $taxDeduction, ')
          ..write('nightShiftStartMinutes: $nightShiftStartMinutes, ')
          ..write('nightShiftEndMinutes: $nightShiftEndMinutes, ')
          ..write('defaultBreakMinutes: $defaultBreakMinutes, ')
          ..write('companyName: $companyName, ')
          ..write('employeeName: $employeeName, ')
          ..write('employeeId: $employeeId, ')
          ..write('themeMode: $themeMode, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    monthlySalary,
    dailyWage,
    normalWorkHours,
    otRate1,
    otRate15,
    otRate2,
    otRate3,
    normalDayMultiplier,
    weekendDayMultiplier,
    holidayDayMultiplier,
    normalOtMultiplier,
    weekendOtMultiplier,
    holidayOtMultiplier,
    nightOtMultiplier,
    mealAllowanceDefault,
    travelAllowanceDefault,
    otherAllowanceDefault,
    socialSecurityDeduction,
    taxDeduction,
    nightShiftStartMinutes,
    nightShiftEndMinutes,
    defaultBreakMinutes,
    companyName,
    employeeName,
    employeeId,
    themeMode,
    onboardingCompleted,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.monthlySalary == this.monthlySalary &&
          other.dailyWage == this.dailyWage &&
          other.normalWorkHours == this.normalWorkHours &&
          other.otRate1 == this.otRate1 &&
          other.otRate15 == this.otRate15 &&
          other.otRate2 == this.otRate2 &&
          other.otRate3 == this.otRate3 &&
          other.normalDayMultiplier == this.normalDayMultiplier &&
          other.weekendDayMultiplier == this.weekendDayMultiplier &&
          other.holidayDayMultiplier == this.holidayDayMultiplier &&
          other.normalOtMultiplier == this.normalOtMultiplier &&
          other.weekendOtMultiplier == this.weekendOtMultiplier &&
          other.holidayOtMultiplier == this.holidayOtMultiplier &&
          other.nightOtMultiplier == this.nightOtMultiplier &&
          other.mealAllowanceDefault == this.mealAllowanceDefault &&
          other.travelAllowanceDefault == this.travelAllowanceDefault &&
          other.otherAllowanceDefault == this.otherAllowanceDefault &&
          other.socialSecurityDeduction == this.socialSecurityDeduction &&
          other.taxDeduction == this.taxDeduction &&
          other.nightShiftStartMinutes == this.nightShiftStartMinutes &&
          other.nightShiftEndMinutes == this.nightShiftEndMinutes &&
          other.defaultBreakMinutes == this.defaultBreakMinutes &&
          other.companyName == this.companyName &&
          other.employeeName == this.employeeName &&
          other.employeeId == this.employeeId &&
          other.themeMode == this.themeMode &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> id;
  final Value<double> monthlySalary;
  final Value<double> dailyWage;
  final Value<double> normalWorkHours;
  final Value<double> otRate1;
  final Value<double> otRate15;
  final Value<double> otRate2;
  final Value<double> otRate3;
  final Value<double> normalDayMultiplier;
  final Value<double> weekendDayMultiplier;
  final Value<double> holidayDayMultiplier;
  final Value<double> normalOtMultiplier;
  final Value<double> weekendOtMultiplier;
  final Value<double> holidayOtMultiplier;
  final Value<double> nightOtMultiplier;
  final Value<double> mealAllowanceDefault;
  final Value<double> travelAllowanceDefault;
  final Value<double> otherAllowanceDefault;
  final Value<double> socialSecurityDeduction;
  final Value<double> taxDeduction;
  final Value<int> nightShiftStartMinutes;
  final Value<int> nightShiftEndMinutes;
  final Value<int> defaultBreakMinutes;
  final Value<String> companyName;
  final Value<String> employeeName;
  final Value<String> employeeId;
  final Value<String> themeMode;
  final Value<bool> onboardingCompleted;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.monthlySalary = const Value.absent(),
    this.dailyWage = const Value.absent(),
    this.normalWorkHours = const Value.absent(),
    this.otRate1 = const Value.absent(),
    this.otRate15 = const Value.absent(),
    this.otRate2 = const Value.absent(),
    this.otRate3 = const Value.absent(),
    this.normalDayMultiplier = const Value.absent(),
    this.weekendDayMultiplier = const Value.absent(),
    this.holidayDayMultiplier = const Value.absent(),
    this.normalOtMultiplier = const Value.absent(),
    this.weekendOtMultiplier = const Value.absent(),
    this.holidayOtMultiplier = const Value.absent(),
    this.nightOtMultiplier = const Value.absent(),
    this.mealAllowanceDefault = const Value.absent(),
    this.travelAllowanceDefault = const Value.absent(),
    this.otherAllowanceDefault = const Value.absent(),
    this.socialSecurityDeduction = const Value.absent(),
    this.taxDeduction = const Value.absent(),
    this.nightShiftStartMinutes = const Value.absent(),
    this.nightShiftEndMinutes = const Value.absent(),
    this.defaultBreakMinutes = const Value.absent(),
    this.companyName = const Value.absent(),
    this.employeeName = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.monthlySalary = const Value.absent(),
    this.dailyWage = const Value.absent(),
    this.normalWorkHours = const Value.absent(),
    this.otRate1 = const Value.absent(),
    this.otRate15 = const Value.absent(),
    this.otRate2 = const Value.absent(),
    this.otRate3 = const Value.absent(),
    this.normalDayMultiplier = const Value.absent(),
    this.weekendDayMultiplier = const Value.absent(),
    this.holidayDayMultiplier = const Value.absent(),
    this.normalOtMultiplier = const Value.absent(),
    this.weekendOtMultiplier = const Value.absent(),
    this.holidayOtMultiplier = const Value.absent(),
    this.nightOtMultiplier = const Value.absent(),
    this.mealAllowanceDefault = const Value.absent(),
    this.travelAllowanceDefault = const Value.absent(),
    this.otherAllowanceDefault = const Value.absent(),
    this.socialSecurityDeduction = const Value.absent(),
    this.taxDeduction = const Value.absent(),
    this.nightShiftStartMinutes = const Value.absent(),
    this.nightShiftEndMinutes = const Value.absent(),
    this.defaultBreakMinutes = const Value.absent(),
    this.companyName = const Value.absent(),
    this.employeeName = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : updatedAt = Value(updatedAt);
  static Insertable<AppSetting> custom({
    Expression<String>? id,
    Expression<double>? monthlySalary,
    Expression<double>? dailyWage,
    Expression<double>? normalWorkHours,
    Expression<double>? otRate1,
    Expression<double>? otRate15,
    Expression<double>? otRate2,
    Expression<double>? otRate3,
    Expression<double>? normalDayMultiplier,
    Expression<double>? weekendDayMultiplier,
    Expression<double>? holidayDayMultiplier,
    Expression<double>? normalOtMultiplier,
    Expression<double>? weekendOtMultiplier,
    Expression<double>? holidayOtMultiplier,
    Expression<double>? nightOtMultiplier,
    Expression<double>? mealAllowanceDefault,
    Expression<double>? travelAllowanceDefault,
    Expression<double>? otherAllowanceDefault,
    Expression<double>? socialSecurityDeduction,
    Expression<double>? taxDeduction,
    Expression<int>? nightShiftStartMinutes,
    Expression<int>? nightShiftEndMinutes,
    Expression<int>? defaultBreakMinutes,
    Expression<String>? companyName,
    Expression<String>? employeeName,
    Expression<String>? employeeId,
    Expression<String>? themeMode,
    Expression<bool>? onboardingCompleted,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (monthlySalary != null) 'monthly_salary': monthlySalary,
      if (dailyWage != null) 'daily_wage': dailyWage,
      if (normalWorkHours != null) 'normal_work_hours': normalWorkHours,
      if (otRate1 != null) 'ot_rate1': otRate1,
      if (otRate15 != null) 'ot_rate15': otRate15,
      if (otRate2 != null) 'ot_rate2': otRate2,
      if (otRate3 != null) 'ot_rate3': otRate3,
      if (normalDayMultiplier != null)
        'normal_day_multiplier': normalDayMultiplier,
      if (weekendDayMultiplier != null)
        'weekend_day_multiplier': weekendDayMultiplier,
      if (holidayDayMultiplier != null)
        'holiday_day_multiplier': holidayDayMultiplier,
      if (normalOtMultiplier != null)
        'normal_ot_multiplier': normalOtMultiplier,
      if (weekendOtMultiplier != null)
        'weekend_ot_multiplier': weekendOtMultiplier,
      if (holidayOtMultiplier != null)
        'holiday_ot_multiplier': holidayOtMultiplier,
      if (nightOtMultiplier != null) 'night_ot_multiplier': nightOtMultiplier,
      if (mealAllowanceDefault != null)
        'meal_allowance_default': mealAllowanceDefault,
      if (travelAllowanceDefault != null)
        'travel_allowance_default': travelAllowanceDefault,
      if (otherAllowanceDefault != null)
        'other_allowance_default': otherAllowanceDefault,
      if (socialSecurityDeduction != null)
        'social_security_deduction': socialSecurityDeduction,
      if (taxDeduction != null) 'tax_deduction': taxDeduction,
      if (nightShiftStartMinutes != null)
        'night_shift_start_minutes': nightShiftStartMinutes,
      if (nightShiftEndMinutes != null)
        'night_shift_end_minutes': nightShiftEndMinutes,
      if (defaultBreakMinutes != null)
        'default_break_minutes': defaultBreakMinutes,
      if (companyName != null) 'company_name': companyName,
      if (employeeName != null) 'employee_name': employeeName,
      if (employeeId != null) 'employee_id': employeeId,
      if (themeMode != null) 'theme_mode': themeMode,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? id,
    Value<double>? monthlySalary,
    Value<double>? dailyWage,
    Value<double>? normalWorkHours,
    Value<double>? otRate1,
    Value<double>? otRate15,
    Value<double>? otRate2,
    Value<double>? otRate3,
    Value<double>? normalDayMultiplier,
    Value<double>? weekendDayMultiplier,
    Value<double>? holidayDayMultiplier,
    Value<double>? normalOtMultiplier,
    Value<double>? weekendOtMultiplier,
    Value<double>? holidayOtMultiplier,
    Value<double>? nightOtMultiplier,
    Value<double>? mealAllowanceDefault,
    Value<double>? travelAllowanceDefault,
    Value<double>? otherAllowanceDefault,
    Value<double>? socialSecurityDeduction,
    Value<double>? taxDeduction,
    Value<int>? nightShiftStartMinutes,
    Value<int>? nightShiftEndMinutes,
    Value<int>? defaultBreakMinutes,
    Value<String>? companyName,
    Value<String>? employeeName,
    Value<String>? employeeId,
    Value<String>? themeMode,
    Value<bool>? onboardingCompleted,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      monthlySalary: monthlySalary ?? this.monthlySalary,
      dailyWage: dailyWage ?? this.dailyWage,
      normalWorkHours: normalWorkHours ?? this.normalWorkHours,
      otRate1: otRate1 ?? this.otRate1,
      otRate15: otRate15 ?? this.otRate15,
      otRate2: otRate2 ?? this.otRate2,
      otRate3: otRate3 ?? this.otRate3,
      normalDayMultiplier: normalDayMultiplier ?? this.normalDayMultiplier,
      weekendDayMultiplier: weekendDayMultiplier ?? this.weekendDayMultiplier,
      holidayDayMultiplier: holidayDayMultiplier ?? this.holidayDayMultiplier,
      normalOtMultiplier: normalOtMultiplier ?? this.normalOtMultiplier,
      weekendOtMultiplier: weekendOtMultiplier ?? this.weekendOtMultiplier,
      holidayOtMultiplier: holidayOtMultiplier ?? this.holidayOtMultiplier,
      nightOtMultiplier: nightOtMultiplier ?? this.nightOtMultiplier,
      mealAllowanceDefault: mealAllowanceDefault ?? this.mealAllowanceDefault,
      travelAllowanceDefault:
          travelAllowanceDefault ?? this.travelAllowanceDefault,
      otherAllowanceDefault:
          otherAllowanceDefault ?? this.otherAllowanceDefault,
      socialSecurityDeduction:
          socialSecurityDeduction ?? this.socialSecurityDeduction,
      taxDeduction: taxDeduction ?? this.taxDeduction,
      nightShiftStartMinutes:
          nightShiftStartMinutes ?? this.nightShiftStartMinutes,
      nightShiftEndMinutes: nightShiftEndMinutes ?? this.nightShiftEndMinutes,
      defaultBreakMinutes: defaultBreakMinutes ?? this.defaultBreakMinutes,
      companyName: companyName ?? this.companyName,
      employeeName: employeeName ?? this.employeeName,
      employeeId: employeeId ?? this.employeeId,
      themeMode: themeMode ?? this.themeMode,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (monthlySalary.present) {
      map['monthly_salary'] = Variable<double>(monthlySalary.value);
    }
    if (dailyWage.present) {
      map['daily_wage'] = Variable<double>(dailyWage.value);
    }
    if (normalWorkHours.present) {
      map['normal_work_hours'] = Variable<double>(normalWorkHours.value);
    }
    if (otRate1.present) {
      map['ot_rate1'] = Variable<double>(otRate1.value);
    }
    if (otRate15.present) {
      map['ot_rate15'] = Variable<double>(otRate15.value);
    }
    if (otRate2.present) {
      map['ot_rate2'] = Variable<double>(otRate2.value);
    }
    if (otRate3.present) {
      map['ot_rate3'] = Variable<double>(otRate3.value);
    }
    if (normalDayMultiplier.present) {
      map['normal_day_multiplier'] = Variable<double>(
        normalDayMultiplier.value,
      );
    }
    if (weekendDayMultiplier.present) {
      map['weekend_day_multiplier'] = Variable<double>(
        weekendDayMultiplier.value,
      );
    }
    if (holidayDayMultiplier.present) {
      map['holiday_day_multiplier'] = Variable<double>(
        holidayDayMultiplier.value,
      );
    }
    if (normalOtMultiplier.present) {
      map['normal_ot_multiplier'] = Variable<double>(normalOtMultiplier.value);
    }
    if (weekendOtMultiplier.present) {
      map['weekend_ot_multiplier'] = Variable<double>(
        weekendOtMultiplier.value,
      );
    }
    if (holidayOtMultiplier.present) {
      map['holiday_ot_multiplier'] = Variable<double>(
        holidayOtMultiplier.value,
      );
    }
    if (nightOtMultiplier.present) {
      map['night_ot_multiplier'] = Variable<double>(nightOtMultiplier.value);
    }
    if (mealAllowanceDefault.present) {
      map['meal_allowance_default'] = Variable<double>(
        mealAllowanceDefault.value,
      );
    }
    if (travelAllowanceDefault.present) {
      map['travel_allowance_default'] = Variable<double>(
        travelAllowanceDefault.value,
      );
    }
    if (otherAllowanceDefault.present) {
      map['other_allowance_default'] = Variable<double>(
        otherAllowanceDefault.value,
      );
    }
    if (socialSecurityDeduction.present) {
      map['social_security_deduction'] = Variable<double>(
        socialSecurityDeduction.value,
      );
    }
    if (taxDeduction.present) {
      map['tax_deduction'] = Variable<double>(taxDeduction.value);
    }
    if (nightShiftStartMinutes.present) {
      map['night_shift_start_minutes'] = Variable<int>(
        nightShiftStartMinutes.value,
      );
    }
    if (nightShiftEndMinutes.present) {
      map['night_shift_end_minutes'] = Variable<int>(
        nightShiftEndMinutes.value,
      );
    }
    if (defaultBreakMinutes.present) {
      map['default_break_minutes'] = Variable<int>(defaultBreakMinutes.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (employeeName.present) {
      map['employee_name'] = Variable<String>(employeeName.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('monthlySalary: $monthlySalary, ')
          ..write('dailyWage: $dailyWage, ')
          ..write('normalWorkHours: $normalWorkHours, ')
          ..write('otRate1: $otRate1, ')
          ..write('otRate15: $otRate15, ')
          ..write('otRate2: $otRate2, ')
          ..write('otRate3: $otRate3, ')
          ..write('normalDayMultiplier: $normalDayMultiplier, ')
          ..write('weekendDayMultiplier: $weekendDayMultiplier, ')
          ..write('holidayDayMultiplier: $holidayDayMultiplier, ')
          ..write('normalOtMultiplier: $normalOtMultiplier, ')
          ..write('weekendOtMultiplier: $weekendOtMultiplier, ')
          ..write('holidayOtMultiplier: $holidayOtMultiplier, ')
          ..write('nightOtMultiplier: $nightOtMultiplier, ')
          ..write('mealAllowanceDefault: $mealAllowanceDefault, ')
          ..write('travelAllowanceDefault: $travelAllowanceDefault, ')
          ..write('otherAllowanceDefault: $otherAllowanceDefault, ')
          ..write('socialSecurityDeduction: $socialSecurityDeduction, ')
          ..write('taxDeduction: $taxDeduction, ')
          ..write('nightShiftStartMinutes: $nightShiftStartMinutes, ')
          ..write('nightShiftEndMinutes: $nightShiftEndMinutes, ')
          ..write('defaultBreakMinutes: $defaultBreakMinutes, ')
          ..write('companyName: $companyName, ')
          ..write('employeeName: $employeeName, ')
          ..write('employeeId: $employeeId, ')
          ..write('themeMode: $themeMode, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReportExportHistoriesTable extends ReportExportHistories
    with TableInfo<$ReportExportHistoriesTable, ReportExportHistory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportExportHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
    'format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exportedAtMeta = const VerificationMeta(
    'exportedAt',
  );
  @override
  late final GeneratedColumn<DateTime> exportedAt = GeneratedColumn<DateTime>(
    'exported_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, format, exportedAt, fileName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'report_export_histories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReportExportHistory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
      );
    } else if (isInserting) {
      context.missing(_formatMeta);
    }
    if (data.containsKey('exported_at')) {
      context.handle(
        _exportedAtMeta,
        exportedAt.isAcceptableOrUnknown(data['exported_at']!, _exportedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_exportedAtMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReportExportHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportExportHistory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      format: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format'],
      )!,
      exportedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}exported_at'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
    );
  }

  @override
  $ReportExportHistoriesTable createAlias(String alias) {
    return $ReportExportHistoriesTable(attachedDatabase, alias);
  }
}

class ReportExportHistory extends DataClass
    implements Insertable<ReportExportHistory> {
  final String id;
  final String format;
  final DateTime exportedAt;
  final String fileName;
  const ReportExportHistory({
    required this.id,
    required this.format,
    required this.exportedAt,
    required this.fileName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['format'] = Variable<String>(format);
    map['exported_at'] = Variable<DateTime>(exportedAt);
    map['file_name'] = Variable<String>(fileName);
    return map;
  }

  ReportExportHistoriesCompanion toCompanion(bool nullToAbsent) {
    return ReportExportHistoriesCompanion(
      id: Value(id),
      format: Value(format),
      exportedAt: Value(exportedAt),
      fileName: Value(fileName),
    );
  }

  factory ReportExportHistory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportExportHistory(
      id: serializer.fromJson<String>(json['id']),
      format: serializer.fromJson<String>(json['format']),
      exportedAt: serializer.fromJson<DateTime>(json['exportedAt']),
      fileName: serializer.fromJson<String>(json['fileName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'format': serializer.toJson<String>(format),
      'exportedAt': serializer.toJson<DateTime>(exportedAt),
      'fileName': serializer.toJson<String>(fileName),
    };
  }

  ReportExportHistory copyWith({
    String? id,
    String? format,
    DateTime? exportedAt,
    String? fileName,
  }) => ReportExportHistory(
    id: id ?? this.id,
    format: format ?? this.format,
    exportedAt: exportedAt ?? this.exportedAt,
    fileName: fileName ?? this.fileName,
  );
  ReportExportHistory copyWithCompanion(ReportExportHistoriesCompanion data) {
    return ReportExportHistory(
      id: data.id.present ? data.id.value : this.id,
      format: data.format.present ? data.format.value : this.format,
      exportedAt: data.exportedAt.present
          ? data.exportedAt.value
          : this.exportedAt,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportExportHistory(')
          ..write('id: $id, ')
          ..write('format: $format, ')
          ..write('exportedAt: $exportedAt, ')
          ..write('fileName: $fileName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, format, exportedAt, fileName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportExportHistory &&
          other.id == this.id &&
          other.format == this.format &&
          other.exportedAt == this.exportedAt &&
          other.fileName == this.fileName);
}

class ReportExportHistoriesCompanion
    extends UpdateCompanion<ReportExportHistory> {
  final Value<String> id;
  final Value<String> format;
  final Value<DateTime> exportedAt;
  final Value<String> fileName;
  final Value<int> rowid;
  const ReportExportHistoriesCompanion({
    this.id = const Value.absent(),
    this.format = const Value.absent(),
    this.exportedAt = const Value.absent(),
    this.fileName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReportExportHistoriesCompanion.insert({
    required String id,
    required String format,
    required DateTime exportedAt,
    required String fileName,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       format = Value(format),
       exportedAt = Value(exportedAt),
       fileName = Value(fileName);
  static Insertable<ReportExportHistory> custom({
    Expression<String>? id,
    Expression<String>? format,
    Expression<DateTime>? exportedAt,
    Expression<String>? fileName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (format != null) 'format': format,
      if (exportedAt != null) 'exported_at': exportedAt,
      if (fileName != null) 'file_name': fileName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReportExportHistoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? format,
    Value<DateTime>? exportedAt,
    Value<String>? fileName,
    Value<int>? rowid,
  }) {
    return ReportExportHistoriesCompanion(
      id: id ?? this.id,
      format: format ?? this.format,
      exportedAt: exportedAt ?? this.exportedAt,
      fileName: fileName ?? this.fileName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(format.value);
    }
    if (exportedAt.present) {
      map['exported_at'] = Variable<DateTime>(exportedAt.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportExportHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('format: $format, ')
          ..write('exportedAt: $exportedAt, ')
          ..write('fileName: $fileName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkRecordsTable workRecords = $WorkRecordsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $ReportExportHistoriesTable reportExportHistories =
      $ReportExportHistoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workRecords,
    appSettings,
    reportExportHistories,
  ];
}

typedef $$WorkRecordsTableCreateCompanionBuilder =
    WorkRecordsCompanion Function({
      required String id,
      required DateTime workDate,
      required int checkInMinutes,
      required int checkOutMinutes,
      Value<int> breakMinutes,
      Value<String> dayType,
      Value<double> extraOtHours,
      Value<double> travelAllowance,
      Value<double> specialAllowance,
      Value<double> expense,
      Value<String> note,
      Value<bool> isDemo,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$WorkRecordsTableUpdateCompanionBuilder =
    WorkRecordsCompanion Function({
      Value<String> id,
      Value<DateTime> workDate,
      Value<int> checkInMinutes,
      Value<int> checkOutMinutes,
      Value<int> breakMinutes,
      Value<String> dayType,
      Value<double> extraOtHours,
      Value<double> travelAllowance,
      Value<double> specialAllowance,
      Value<double> expense,
      Value<String> note,
      Value<bool> isDemo,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$WorkRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkRecordsTable> {
  $$WorkRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get workDate => $composableBuilder(
    column: $table.workDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get checkInMinutes => $composableBuilder(
    column: $table.checkInMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get checkOutMinutes => $composableBuilder(
    column: $table.checkOutMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayType => $composableBuilder(
    column: $table.dayType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get extraOtHours => $composableBuilder(
    column: $table.extraOtHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get travelAllowance => $composableBuilder(
    column: $table.travelAllowance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get specialAllowance => $composableBuilder(
    column: $table.specialAllowance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get expense => $composableBuilder(
    column: $table.expense,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkRecordsTable> {
  $$WorkRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get workDate => $composableBuilder(
    column: $table.workDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get checkInMinutes => $composableBuilder(
    column: $table.checkInMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get checkOutMinutes => $composableBuilder(
    column: $table.checkOutMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayType => $composableBuilder(
    column: $table.dayType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get extraOtHours => $composableBuilder(
    column: $table.extraOtHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get travelAllowance => $composableBuilder(
    column: $table.travelAllowance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get specialAllowance => $composableBuilder(
    column: $table.specialAllowance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get expense => $composableBuilder(
    column: $table.expense,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkRecordsTable> {
  $$WorkRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get workDate =>
      $composableBuilder(column: $table.workDate, builder: (column) => column);

  GeneratedColumn<int> get checkInMinutes => $composableBuilder(
    column: $table.checkInMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get checkOutMinutes => $composableBuilder(
    column: $table.checkOutMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dayType =>
      $composableBuilder(column: $table.dayType, builder: (column) => column);

  GeneratedColumn<double> get extraOtHours => $composableBuilder(
    column: $table.extraOtHours,
    builder: (column) => column,
  );

  GeneratedColumn<double> get travelAllowance => $composableBuilder(
    column: $table.travelAllowance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get specialAllowance => $composableBuilder(
    column: $table.specialAllowance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get expense =>
      $composableBuilder(column: $table.expense, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isDemo =>
      $composableBuilder(column: $table.isDemo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WorkRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkRecordsTable,
          WorkRecord,
          $$WorkRecordsTableFilterComposer,
          $$WorkRecordsTableOrderingComposer,
          $$WorkRecordsTableAnnotationComposer,
          $$WorkRecordsTableCreateCompanionBuilder,
          $$WorkRecordsTableUpdateCompanionBuilder,
          (
            WorkRecord,
            BaseReferences<_$AppDatabase, $WorkRecordsTable, WorkRecord>,
          ),
          WorkRecord,
          PrefetchHooks Function()
        > {
  $$WorkRecordsTableTableManager(_$AppDatabase db, $WorkRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> workDate = const Value.absent(),
                Value<int> checkInMinutes = const Value.absent(),
                Value<int> checkOutMinutes = const Value.absent(),
                Value<int> breakMinutes = const Value.absent(),
                Value<String> dayType = const Value.absent(),
                Value<double> extraOtHours = const Value.absent(),
                Value<double> travelAllowance = const Value.absent(),
                Value<double> specialAllowance = const Value.absent(),
                Value<double> expense = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkRecordsCompanion(
                id: id,
                workDate: workDate,
                checkInMinutes: checkInMinutes,
                checkOutMinutes: checkOutMinutes,
                breakMinutes: breakMinutes,
                dayType: dayType,
                extraOtHours: extraOtHours,
                travelAllowance: travelAllowance,
                specialAllowance: specialAllowance,
                expense: expense,
                note: note,
                isDemo: isDemo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime workDate,
                required int checkInMinutes,
                required int checkOutMinutes,
                Value<int> breakMinutes = const Value.absent(),
                Value<String> dayType = const Value.absent(),
                Value<double> extraOtHours = const Value.absent(),
                Value<double> travelAllowance = const Value.absent(),
                Value<double> specialAllowance = const Value.absent(),
                Value<double> expense = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WorkRecordsCompanion.insert(
                id: id,
                workDate: workDate,
                checkInMinutes: checkInMinutes,
                checkOutMinutes: checkOutMinutes,
                breakMinutes: breakMinutes,
                dayType: dayType,
                extraOtHours: extraOtHours,
                travelAllowance: travelAllowance,
                specialAllowance: specialAllowance,
                expense: expense,
                note: note,
                isDemo: isDemo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkRecordsTable,
      WorkRecord,
      $$WorkRecordsTableFilterComposer,
      $$WorkRecordsTableOrderingComposer,
      $$WorkRecordsTableAnnotationComposer,
      $$WorkRecordsTableCreateCompanionBuilder,
      $$WorkRecordsTableUpdateCompanionBuilder,
      (
        WorkRecord,
        BaseReferences<_$AppDatabase, $WorkRecordsTable, WorkRecord>,
      ),
      WorkRecord,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> id,
      Value<double> monthlySalary,
      Value<double> dailyWage,
      Value<double> normalWorkHours,
      Value<double> otRate1,
      Value<double> otRate15,
      Value<double> otRate2,
      Value<double> otRate3,
      Value<double> normalDayMultiplier,
      Value<double> weekendDayMultiplier,
      Value<double> holidayDayMultiplier,
      Value<double> normalOtMultiplier,
      Value<double> weekendOtMultiplier,
      Value<double> holidayOtMultiplier,
      Value<double> nightOtMultiplier,
      Value<double> mealAllowanceDefault,
      Value<double> travelAllowanceDefault,
      Value<double> otherAllowanceDefault,
      Value<double> socialSecurityDeduction,
      Value<double> taxDeduction,
      Value<int> nightShiftStartMinutes,
      Value<int> nightShiftEndMinutes,
      Value<int> defaultBreakMinutes,
      Value<String> companyName,
      Value<String> employeeName,
      Value<String> employeeId,
      Value<String> themeMode,
      Value<bool> onboardingCompleted,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> id,
      Value<double> monthlySalary,
      Value<double> dailyWage,
      Value<double> normalWorkHours,
      Value<double> otRate1,
      Value<double> otRate15,
      Value<double> otRate2,
      Value<double> otRate3,
      Value<double> normalDayMultiplier,
      Value<double> weekendDayMultiplier,
      Value<double> holidayDayMultiplier,
      Value<double> normalOtMultiplier,
      Value<double> weekendOtMultiplier,
      Value<double> holidayOtMultiplier,
      Value<double> nightOtMultiplier,
      Value<double> mealAllowanceDefault,
      Value<double> travelAllowanceDefault,
      Value<double> otherAllowanceDefault,
      Value<double> socialSecurityDeduction,
      Value<double> taxDeduction,
      Value<int> nightShiftStartMinutes,
      Value<int> nightShiftEndMinutes,
      Value<int> defaultBreakMinutes,
      Value<String> companyName,
      Value<String> employeeName,
      Value<String> employeeId,
      Value<String> themeMode,
      Value<bool> onboardingCompleted,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monthlySalary => $composableBuilder(
    column: $table.monthlySalary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dailyWage => $composableBuilder(
    column: $table.dailyWage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get normalWorkHours => $composableBuilder(
    column: $table.normalWorkHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get otRate1 => $composableBuilder(
    column: $table.otRate1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get otRate15 => $composableBuilder(
    column: $table.otRate15,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get otRate2 => $composableBuilder(
    column: $table.otRate2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get otRate3 => $composableBuilder(
    column: $table.otRate3,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get normalDayMultiplier => $composableBuilder(
    column: $table.normalDayMultiplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weekendDayMultiplier => $composableBuilder(
    column: $table.weekendDayMultiplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get holidayDayMultiplier => $composableBuilder(
    column: $table.holidayDayMultiplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get normalOtMultiplier => $composableBuilder(
    column: $table.normalOtMultiplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weekendOtMultiplier => $composableBuilder(
    column: $table.weekendOtMultiplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get holidayOtMultiplier => $composableBuilder(
    column: $table.holidayOtMultiplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get nightOtMultiplier => $composableBuilder(
    column: $table.nightOtMultiplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get mealAllowanceDefault => $composableBuilder(
    column: $table.mealAllowanceDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get travelAllowanceDefault => $composableBuilder(
    column: $table.travelAllowanceDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get otherAllowanceDefault => $composableBuilder(
    column: $table.otherAllowanceDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get socialSecurityDeduction => $composableBuilder(
    column: $table.socialSecurityDeduction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxDeduction => $composableBuilder(
    column: $table.taxDeduction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nightShiftStartMinutes => $composableBuilder(
    column: $table.nightShiftStartMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nightShiftEndMinutes => $composableBuilder(
    column: $table.nightShiftEndMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultBreakMinutes => $composableBuilder(
    column: $table.defaultBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeName => $composableBuilder(
    column: $table.employeeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monthlySalary => $composableBuilder(
    column: $table.monthlySalary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dailyWage => $composableBuilder(
    column: $table.dailyWage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get normalWorkHours => $composableBuilder(
    column: $table.normalWorkHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get otRate1 => $composableBuilder(
    column: $table.otRate1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get otRate15 => $composableBuilder(
    column: $table.otRate15,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get otRate2 => $composableBuilder(
    column: $table.otRate2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get otRate3 => $composableBuilder(
    column: $table.otRate3,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get normalDayMultiplier => $composableBuilder(
    column: $table.normalDayMultiplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weekendDayMultiplier => $composableBuilder(
    column: $table.weekendDayMultiplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get holidayDayMultiplier => $composableBuilder(
    column: $table.holidayDayMultiplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get normalOtMultiplier => $composableBuilder(
    column: $table.normalOtMultiplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weekendOtMultiplier => $composableBuilder(
    column: $table.weekendOtMultiplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get holidayOtMultiplier => $composableBuilder(
    column: $table.holidayOtMultiplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get nightOtMultiplier => $composableBuilder(
    column: $table.nightOtMultiplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get mealAllowanceDefault => $composableBuilder(
    column: $table.mealAllowanceDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get travelAllowanceDefault => $composableBuilder(
    column: $table.travelAllowanceDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get otherAllowanceDefault => $composableBuilder(
    column: $table.otherAllowanceDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get socialSecurityDeduction => $composableBuilder(
    column: $table.socialSecurityDeduction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxDeduction => $composableBuilder(
    column: $table.taxDeduction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nightShiftStartMinutes => $composableBuilder(
    column: $table.nightShiftStartMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nightShiftEndMinutes => $composableBuilder(
    column: $table.nightShiftEndMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultBreakMinutes => $composableBuilder(
    column: $table.defaultBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeName => $composableBuilder(
    column: $table.employeeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get monthlySalary => $composableBuilder(
    column: $table.monthlySalary,
    builder: (column) => column,
  );

  GeneratedColumn<double> get dailyWage =>
      $composableBuilder(column: $table.dailyWage, builder: (column) => column);

  GeneratedColumn<double> get normalWorkHours => $composableBuilder(
    column: $table.normalWorkHours,
    builder: (column) => column,
  );

  GeneratedColumn<double> get otRate1 =>
      $composableBuilder(column: $table.otRate1, builder: (column) => column);

  GeneratedColumn<double> get otRate15 =>
      $composableBuilder(column: $table.otRate15, builder: (column) => column);

  GeneratedColumn<double> get otRate2 =>
      $composableBuilder(column: $table.otRate2, builder: (column) => column);

  GeneratedColumn<double> get otRate3 =>
      $composableBuilder(column: $table.otRate3, builder: (column) => column);

  GeneratedColumn<double> get normalDayMultiplier => $composableBuilder(
    column: $table.normalDayMultiplier,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weekendDayMultiplier => $composableBuilder(
    column: $table.weekendDayMultiplier,
    builder: (column) => column,
  );

  GeneratedColumn<double> get holidayDayMultiplier => $composableBuilder(
    column: $table.holidayDayMultiplier,
    builder: (column) => column,
  );

  GeneratedColumn<double> get normalOtMultiplier => $composableBuilder(
    column: $table.normalOtMultiplier,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weekendOtMultiplier => $composableBuilder(
    column: $table.weekendOtMultiplier,
    builder: (column) => column,
  );

  GeneratedColumn<double> get holidayOtMultiplier => $composableBuilder(
    column: $table.holidayOtMultiplier,
    builder: (column) => column,
  );

  GeneratedColumn<double> get nightOtMultiplier => $composableBuilder(
    column: $table.nightOtMultiplier,
    builder: (column) => column,
  );

  GeneratedColumn<double> get mealAllowanceDefault => $composableBuilder(
    column: $table.mealAllowanceDefault,
    builder: (column) => column,
  );

  GeneratedColumn<double> get travelAllowanceDefault => $composableBuilder(
    column: $table.travelAllowanceDefault,
    builder: (column) => column,
  );

  GeneratedColumn<double> get otherAllowanceDefault => $composableBuilder(
    column: $table.otherAllowanceDefault,
    builder: (column) => column,
  );

  GeneratedColumn<double> get socialSecurityDeduction => $composableBuilder(
    column: $table.socialSecurityDeduction,
    builder: (column) => column,
  );

  GeneratedColumn<double> get taxDeduction => $composableBuilder(
    column: $table.taxDeduction,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nightShiftStartMinutes => $composableBuilder(
    column: $table.nightShiftStartMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nightShiftEndMinutes => $composableBuilder(
    column: $table.nightShiftEndMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultBreakMinutes => $composableBuilder(
    column: $table.defaultBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get employeeName => $composableBuilder(
    column: $table.employeeName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> monthlySalary = const Value.absent(),
                Value<double> dailyWage = const Value.absent(),
                Value<double> normalWorkHours = const Value.absent(),
                Value<double> otRate1 = const Value.absent(),
                Value<double> otRate15 = const Value.absent(),
                Value<double> otRate2 = const Value.absent(),
                Value<double> otRate3 = const Value.absent(),
                Value<double> normalDayMultiplier = const Value.absent(),
                Value<double> weekendDayMultiplier = const Value.absent(),
                Value<double> holidayDayMultiplier = const Value.absent(),
                Value<double> normalOtMultiplier = const Value.absent(),
                Value<double> weekendOtMultiplier = const Value.absent(),
                Value<double> holidayOtMultiplier = const Value.absent(),
                Value<double> nightOtMultiplier = const Value.absent(),
                Value<double> mealAllowanceDefault = const Value.absent(),
                Value<double> travelAllowanceDefault = const Value.absent(),
                Value<double> otherAllowanceDefault = const Value.absent(),
                Value<double> socialSecurityDeduction = const Value.absent(),
                Value<double> taxDeduction = const Value.absent(),
                Value<int> nightShiftStartMinutes = const Value.absent(),
                Value<int> nightShiftEndMinutes = const Value.absent(),
                Value<int> defaultBreakMinutes = const Value.absent(),
                Value<String> companyName = const Value.absent(),
                Value<String> employeeName = const Value.absent(),
                Value<String> employeeId = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                monthlySalary: monthlySalary,
                dailyWage: dailyWage,
                normalWorkHours: normalWorkHours,
                otRate1: otRate1,
                otRate15: otRate15,
                otRate2: otRate2,
                otRate3: otRate3,
                normalDayMultiplier: normalDayMultiplier,
                weekendDayMultiplier: weekendDayMultiplier,
                holidayDayMultiplier: holidayDayMultiplier,
                normalOtMultiplier: normalOtMultiplier,
                weekendOtMultiplier: weekendOtMultiplier,
                holidayOtMultiplier: holidayOtMultiplier,
                nightOtMultiplier: nightOtMultiplier,
                mealAllowanceDefault: mealAllowanceDefault,
                travelAllowanceDefault: travelAllowanceDefault,
                otherAllowanceDefault: otherAllowanceDefault,
                socialSecurityDeduction: socialSecurityDeduction,
                taxDeduction: taxDeduction,
                nightShiftStartMinutes: nightShiftStartMinutes,
                nightShiftEndMinutes: nightShiftEndMinutes,
                defaultBreakMinutes: defaultBreakMinutes,
                companyName: companyName,
                employeeName: employeeName,
                employeeId: employeeId,
                themeMode: themeMode,
                onboardingCompleted: onboardingCompleted,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> monthlySalary = const Value.absent(),
                Value<double> dailyWage = const Value.absent(),
                Value<double> normalWorkHours = const Value.absent(),
                Value<double> otRate1 = const Value.absent(),
                Value<double> otRate15 = const Value.absent(),
                Value<double> otRate2 = const Value.absent(),
                Value<double> otRate3 = const Value.absent(),
                Value<double> normalDayMultiplier = const Value.absent(),
                Value<double> weekendDayMultiplier = const Value.absent(),
                Value<double> holidayDayMultiplier = const Value.absent(),
                Value<double> normalOtMultiplier = const Value.absent(),
                Value<double> weekendOtMultiplier = const Value.absent(),
                Value<double> holidayOtMultiplier = const Value.absent(),
                Value<double> nightOtMultiplier = const Value.absent(),
                Value<double> mealAllowanceDefault = const Value.absent(),
                Value<double> travelAllowanceDefault = const Value.absent(),
                Value<double> otherAllowanceDefault = const Value.absent(),
                Value<double> socialSecurityDeduction = const Value.absent(),
                Value<double> taxDeduction = const Value.absent(),
                Value<int> nightShiftStartMinutes = const Value.absent(),
                Value<int> nightShiftEndMinutes = const Value.absent(),
                Value<int> defaultBreakMinutes = const Value.absent(),
                Value<String> companyName = const Value.absent(),
                Value<String> employeeName = const Value.absent(),
                Value<String> employeeId = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                monthlySalary: monthlySalary,
                dailyWage: dailyWage,
                normalWorkHours: normalWorkHours,
                otRate1: otRate1,
                otRate15: otRate15,
                otRate2: otRate2,
                otRate3: otRate3,
                normalDayMultiplier: normalDayMultiplier,
                weekendDayMultiplier: weekendDayMultiplier,
                holidayDayMultiplier: holidayDayMultiplier,
                normalOtMultiplier: normalOtMultiplier,
                weekendOtMultiplier: weekendOtMultiplier,
                holidayOtMultiplier: holidayOtMultiplier,
                nightOtMultiplier: nightOtMultiplier,
                mealAllowanceDefault: mealAllowanceDefault,
                travelAllowanceDefault: travelAllowanceDefault,
                otherAllowanceDefault: otherAllowanceDefault,
                socialSecurityDeduction: socialSecurityDeduction,
                taxDeduction: taxDeduction,
                nightShiftStartMinutes: nightShiftStartMinutes,
                nightShiftEndMinutes: nightShiftEndMinutes,
                defaultBreakMinutes: defaultBreakMinutes,
                companyName: companyName,
                employeeName: employeeName,
                employeeId: employeeId,
                themeMode: themeMode,
                onboardingCompleted: onboardingCompleted,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$ReportExportHistoriesTableCreateCompanionBuilder =
    ReportExportHistoriesCompanion Function({
      required String id,
      required String format,
      required DateTime exportedAt,
      required String fileName,
      Value<int> rowid,
    });
typedef $$ReportExportHistoriesTableUpdateCompanionBuilder =
    ReportExportHistoriesCompanion Function({
      Value<String> id,
      Value<String> format,
      Value<DateTime> exportedAt,
      Value<String> fileName,
      Value<int> rowid,
    });

class $$ReportExportHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ReportExportHistoriesTable> {
  $$ReportExportHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get exportedAt => $composableBuilder(
    column: $table.exportedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReportExportHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportExportHistoriesTable> {
  $$ReportExportHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get exportedAt => $composableBuilder(
    column: $table.exportedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReportExportHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportExportHistoriesTable> {
  $$ReportExportHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<DateTime> get exportedAt => $composableBuilder(
    column: $table.exportedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);
}

class $$ReportExportHistoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReportExportHistoriesTable,
          ReportExportHistory,
          $$ReportExportHistoriesTableFilterComposer,
          $$ReportExportHistoriesTableOrderingComposer,
          $$ReportExportHistoriesTableAnnotationComposer,
          $$ReportExportHistoriesTableCreateCompanionBuilder,
          $$ReportExportHistoriesTableUpdateCompanionBuilder,
          (
            ReportExportHistory,
            BaseReferences<
              _$AppDatabase,
              $ReportExportHistoriesTable,
              ReportExportHistory
            >,
          ),
          ReportExportHistory,
          PrefetchHooks Function()
        > {
  $$ReportExportHistoriesTableTableManager(
    _$AppDatabase db,
    $ReportExportHistoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportExportHistoriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ReportExportHistoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ReportExportHistoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> format = const Value.absent(),
                Value<DateTime> exportedAt = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportExportHistoriesCompanion(
                id: id,
                format: format,
                exportedAt: exportedAt,
                fileName: fileName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String format,
                required DateTime exportedAt,
                required String fileName,
                Value<int> rowid = const Value.absent(),
              }) => ReportExportHistoriesCompanion.insert(
                id: id,
                format: format,
                exportedAt: exportedAt,
                fileName: fileName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReportExportHistoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReportExportHistoriesTable,
      ReportExportHistory,
      $$ReportExportHistoriesTableFilterComposer,
      $$ReportExportHistoriesTableOrderingComposer,
      $$ReportExportHistoriesTableAnnotationComposer,
      $$ReportExportHistoriesTableCreateCompanionBuilder,
      $$ReportExportHistoriesTableUpdateCompanionBuilder,
      (
        ReportExportHistory,
        BaseReferences<
          _$AppDatabase,
          $ReportExportHistoriesTable,
          ReportExportHistory
        >,
      ),
      ReportExportHistory,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkRecordsTableTableManager get workRecords =>
      $$WorkRecordsTableTableManager(_db, _db.workRecords);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$ReportExportHistoriesTableTableManager get reportExportHistories =>
      $$ReportExportHistoriesTableTableManager(_db, _db.reportExportHistories);
}
