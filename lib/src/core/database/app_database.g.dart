// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WorkEntriesTable extends WorkEntries
    with TableInfo<$WorkEntriesTable, WorkEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _otExtraHoursMeta = const VerificationMeta(
    'otExtraHours',
  );
  @override
  late final GeneratedColumn<double> otExtraHours = GeneratedColumn<double>(
    'ot_extra_hours',
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
    otExtraHours,
    specialAllowance,
    expense,
    dayType,
    note,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkEntry> instance, {
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
    if (data.containsKey('ot_extra_hours')) {
      context.handle(
        _otExtraHoursMeta,
        otExtraHours.isAcceptableOrUnknown(
          data['ot_extra_hours']!,
          _otExtraHoursMeta,
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
    if (data.containsKey('day_type')) {
      context.handle(
        _dayTypeMeta,
        dayType.isAcceptableOrUnknown(data['day_type']!, _dayTypeMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
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
  WorkEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkEntry(
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
      otExtraHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ot_extra_hours'],
      )!,
      specialAllowance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}special_allowance'],
      )!,
      expense: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}expense'],
      )!,
      dayType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_type'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
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
  $WorkEntriesTable createAlias(String alias) {
    return $WorkEntriesTable(attachedDatabase, alias);
  }
}

class WorkEntry extends DataClass implements Insertable<WorkEntry> {
  final String id;
  final DateTime workDate;
  final int checkInMinutes;
  final int checkOutMinutes;
  final double otExtraHours;
  final double specialAllowance;
  final double expense;
  final String dayType;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WorkEntry({
    required this.id,
    required this.workDate,
    required this.checkInMinutes,
    required this.checkOutMinutes,
    required this.otExtraHours,
    required this.specialAllowance,
    required this.expense,
    required this.dayType,
    required this.note,
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
    map['ot_extra_hours'] = Variable<double>(otExtraHours);
    map['special_allowance'] = Variable<double>(specialAllowance);
    map['expense'] = Variable<double>(expense);
    map['day_type'] = Variable<String>(dayType);
    map['note'] = Variable<String>(note);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorkEntriesCompanion toCompanion(bool nullToAbsent) {
    return WorkEntriesCompanion(
      id: Value(id),
      workDate: Value(workDate),
      checkInMinutes: Value(checkInMinutes),
      checkOutMinutes: Value(checkOutMinutes),
      otExtraHours: Value(otExtraHours),
      specialAllowance: Value(specialAllowance),
      expense: Value(expense),
      dayType: Value(dayType),
      note: Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WorkEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkEntry(
      id: serializer.fromJson<String>(json['id']),
      workDate: serializer.fromJson<DateTime>(json['workDate']),
      checkInMinutes: serializer.fromJson<int>(json['checkInMinutes']),
      checkOutMinutes: serializer.fromJson<int>(json['checkOutMinutes']),
      otExtraHours: serializer.fromJson<double>(json['otExtraHours']),
      specialAllowance: serializer.fromJson<double>(json['specialAllowance']),
      expense: serializer.fromJson<double>(json['expense']),
      dayType: serializer.fromJson<String>(json['dayType']),
      note: serializer.fromJson<String>(json['note']),
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
      'otExtraHours': serializer.toJson<double>(otExtraHours),
      'specialAllowance': serializer.toJson<double>(specialAllowance),
      'expense': serializer.toJson<double>(expense),
      'dayType': serializer.toJson<String>(dayType),
      'note': serializer.toJson<String>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WorkEntry copyWith({
    String? id,
    DateTime? workDate,
    int? checkInMinutes,
    int? checkOutMinutes,
    double? otExtraHours,
    double? specialAllowance,
    double? expense,
    String? dayType,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WorkEntry(
    id: id ?? this.id,
    workDate: workDate ?? this.workDate,
    checkInMinutes: checkInMinutes ?? this.checkInMinutes,
    checkOutMinutes: checkOutMinutes ?? this.checkOutMinutes,
    otExtraHours: otExtraHours ?? this.otExtraHours,
    specialAllowance: specialAllowance ?? this.specialAllowance,
    expense: expense ?? this.expense,
    dayType: dayType ?? this.dayType,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WorkEntry copyWithCompanion(WorkEntriesCompanion data) {
    return WorkEntry(
      id: data.id.present ? data.id.value : this.id,
      workDate: data.workDate.present ? data.workDate.value : this.workDate,
      checkInMinutes: data.checkInMinutes.present
          ? data.checkInMinutes.value
          : this.checkInMinutes,
      checkOutMinutes: data.checkOutMinutes.present
          ? data.checkOutMinutes.value
          : this.checkOutMinutes,
      otExtraHours: data.otExtraHours.present
          ? data.otExtraHours.value
          : this.otExtraHours,
      specialAllowance: data.specialAllowance.present
          ? data.specialAllowance.value
          : this.specialAllowance,
      expense: data.expense.present ? data.expense.value : this.expense,
      dayType: data.dayType.present ? data.dayType.value : this.dayType,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkEntry(')
          ..write('id: $id, ')
          ..write('workDate: $workDate, ')
          ..write('checkInMinutes: $checkInMinutes, ')
          ..write('checkOutMinutes: $checkOutMinutes, ')
          ..write('otExtraHours: $otExtraHours, ')
          ..write('specialAllowance: $specialAllowance, ')
          ..write('expense: $expense, ')
          ..write('dayType: $dayType, ')
          ..write('note: $note, ')
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
    otExtraHours,
    specialAllowance,
    expense,
    dayType,
    note,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkEntry &&
          other.id == this.id &&
          other.workDate == this.workDate &&
          other.checkInMinutes == this.checkInMinutes &&
          other.checkOutMinutes == this.checkOutMinutes &&
          other.otExtraHours == this.otExtraHours &&
          other.specialAllowance == this.specialAllowance &&
          other.expense == this.expense &&
          other.dayType == this.dayType &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorkEntriesCompanion extends UpdateCompanion<WorkEntry> {
  final Value<String> id;
  final Value<DateTime> workDate;
  final Value<int> checkInMinutes;
  final Value<int> checkOutMinutes;
  final Value<double> otExtraHours;
  final Value<double> specialAllowance;
  final Value<double> expense;
  final Value<String> dayType;
  final Value<String> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WorkEntriesCompanion({
    this.id = const Value.absent(),
    this.workDate = const Value.absent(),
    this.checkInMinutes = const Value.absent(),
    this.checkOutMinutes = const Value.absent(),
    this.otExtraHours = const Value.absent(),
    this.specialAllowance = const Value.absent(),
    this.expense = const Value.absent(),
    this.dayType = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkEntriesCompanion.insert({
    required String id,
    required DateTime workDate,
    required int checkInMinutes,
    required int checkOutMinutes,
    this.otExtraHours = const Value.absent(),
    this.specialAllowance = const Value.absent(),
    this.expense = const Value.absent(),
    this.dayType = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workDate = Value(workDate),
       checkInMinutes = Value(checkInMinutes),
       checkOutMinutes = Value(checkOutMinutes),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<WorkEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? workDate,
    Expression<int>? checkInMinutes,
    Expression<int>? checkOutMinutes,
    Expression<double>? otExtraHours,
    Expression<double>? specialAllowance,
    Expression<double>? expense,
    Expression<String>? dayType,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workDate != null) 'work_date': workDate,
      if (checkInMinutes != null) 'check_in_minutes': checkInMinutes,
      if (checkOutMinutes != null) 'check_out_minutes': checkOutMinutes,
      if (otExtraHours != null) 'ot_extra_hours': otExtraHours,
      if (specialAllowance != null) 'special_allowance': specialAllowance,
      if (expense != null) 'expense': expense,
      if (dayType != null) 'day_type': dayType,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? workDate,
    Value<int>? checkInMinutes,
    Value<int>? checkOutMinutes,
    Value<double>? otExtraHours,
    Value<double>? specialAllowance,
    Value<double>? expense,
    Value<String>? dayType,
    Value<String>? note,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorkEntriesCompanion(
      id: id ?? this.id,
      workDate: workDate ?? this.workDate,
      checkInMinutes: checkInMinutes ?? this.checkInMinutes,
      checkOutMinutes: checkOutMinutes ?? this.checkOutMinutes,
      otExtraHours: otExtraHours ?? this.otExtraHours,
      specialAllowance: specialAllowance ?? this.specialAllowance,
      expense: expense ?? this.expense,
      dayType: dayType ?? this.dayType,
      note: note ?? this.note,
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
    if (otExtraHours.present) {
      map['ot_extra_hours'] = Variable<double>(otExtraHours.value);
    }
    if (specialAllowance.present) {
      map['special_allowance'] = Variable<double>(specialAllowance.value);
    }
    if (expense.present) {
      map['expense'] = Variable<double>(expense.value);
    }
    if (dayType.present) {
      map['day_type'] = Variable<String>(dayType.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
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
    return (StringBuffer('WorkEntriesCompanion(')
          ..write('id: $id, ')
          ..write('workDate: $workDate, ')
          ..write('checkInMinutes: $checkInMinutes, ')
          ..write('checkOutMinutes: $checkOutMinutes, ')
          ..write('otExtraHours: $otExtraHours, ')
          ..write('specialAllowance: $specialAllowance, ')
          ..write('expense: $expense, ')
          ..write('dayType: $dayType, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkEntriesTable workEntries = $WorkEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [workEntries];
}

typedef $$WorkEntriesTableCreateCompanionBuilder =
    WorkEntriesCompanion Function({
      required String id,
      required DateTime workDate,
      required int checkInMinutes,
      required int checkOutMinutes,
      Value<double> otExtraHours,
      Value<double> specialAllowance,
      Value<double> expense,
      Value<String> dayType,
      Value<String> note,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$WorkEntriesTableUpdateCompanionBuilder =
    WorkEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> workDate,
      Value<int> checkInMinutes,
      Value<int> checkOutMinutes,
      Value<double> otExtraHours,
      Value<double> specialAllowance,
      Value<double> expense,
      Value<String> dayType,
      Value<String> note,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$WorkEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkEntriesTable> {
  $$WorkEntriesTableFilterComposer({
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

  ColumnFilters<double> get otExtraHours => $composableBuilder(
    column: $table.otExtraHours,
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

  ColumnFilters<String> get dayType => $composableBuilder(
    column: $table.dayType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
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

class $$WorkEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkEntriesTable> {
  $$WorkEntriesTableOrderingComposer({
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

  ColumnOrderings<double> get otExtraHours => $composableBuilder(
    column: $table.otExtraHours,
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

  ColumnOrderings<String> get dayType => $composableBuilder(
    column: $table.dayType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
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

class $$WorkEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkEntriesTable> {
  $$WorkEntriesTableAnnotationComposer({
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

  GeneratedColumn<double> get otExtraHours => $composableBuilder(
    column: $table.otExtraHours,
    builder: (column) => column,
  );

  GeneratedColumn<double> get specialAllowance => $composableBuilder(
    column: $table.specialAllowance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get expense =>
      $composableBuilder(column: $table.expense, builder: (column) => column);

  GeneratedColumn<String> get dayType =>
      $composableBuilder(column: $table.dayType, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WorkEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkEntriesTable,
          WorkEntry,
          $$WorkEntriesTableFilterComposer,
          $$WorkEntriesTableOrderingComposer,
          $$WorkEntriesTableAnnotationComposer,
          $$WorkEntriesTableCreateCompanionBuilder,
          $$WorkEntriesTableUpdateCompanionBuilder,
          (
            WorkEntry,
            BaseReferences<_$AppDatabase, $WorkEntriesTable, WorkEntry>,
          ),
          WorkEntry,
          PrefetchHooks Function()
        > {
  $$WorkEntriesTableTableManager(_$AppDatabase db, $WorkEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> workDate = const Value.absent(),
                Value<int> checkInMinutes = const Value.absent(),
                Value<int> checkOutMinutes = const Value.absent(),
                Value<double> otExtraHours = const Value.absent(),
                Value<double> specialAllowance = const Value.absent(),
                Value<double> expense = const Value.absent(),
                Value<String> dayType = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkEntriesCompanion(
                id: id,
                workDate: workDate,
                checkInMinutes: checkInMinutes,
                checkOutMinutes: checkOutMinutes,
                otExtraHours: otExtraHours,
                specialAllowance: specialAllowance,
                expense: expense,
                dayType: dayType,
                note: note,
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
                Value<double> otExtraHours = const Value.absent(),
                Value<double> specialAllowance = const Value.absent(),
                Value<double> expense = const Value.absent(),
                Value<String> dayType = const Value.absent(),
                Value<String> note = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WorkEntriesCompanion.insert(
                id: id,
                workDate: workDate,
                checkInMinutes: checkInMinutes,
                checkOutMinutes: checkOutMinutes,
                otExtraHours: otExtraHours,
                specialAllowance: specialAllowance,
                expense: expense,
                dayType: dayType,
                note: note,
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

typedef $$WorkEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkEntriesTable,
      WorkEntry,
      $$WorkEntriesTableFilterComposer,
      $$WorkEntriesTableOrderingComposer,
      $$WorkEntriesTableAnnotationComposer,
      $$WorkEntriesTableCreateCompanionBuilder,
      $$WorkEntriesTableUpdateCompanionBuilder,
      (WorkEntry, BaseReferences<_$AppDatabase, $WorkEntriesTable, WorkEntry>),
      WorkEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkEntriesTableTableManager get workEntries =>
      $$WorkEntriesTableTableManager(_db, _db.workEntries);
}
