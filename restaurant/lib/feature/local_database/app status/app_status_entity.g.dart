// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_status_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppStatusEntityCollection on Isar {
  IsarCollection<AppStatusEntity> get appStatusEntitys => this.collection();
}

const AppStatusEntitySchema = CollectionSchema(
  name: r'AppStatusEntity',
  id: -1993357841247766867,
  properties: {
    r'cartVersion': PropertySchema(
      id: 0,
      name: r'cartVersion',
      type: IsarType.long,
    ),
    r'menuVersion': PropertySchema(
      id: 1,
      name: r'menuVersion',
      type: IsarType.long,
    ),
    r'userVersion': PropertySchema(
      id: 2,
      name: r'userVersion',
      type: IsarType.long,
    )
  },
  estimateSize: _appStatusEntityEstimateSize,
  serialize: _appStatusEntitySerialize,
  deserialize: _appStatusEntityDeserialize,
  deserializeProp: _appStatusEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appStatusEntityGetId,
  getLinks: _appStatusEntityGetLinks,
  attach: _appStatusEntityAttach,
  version: '3.1.0+1',
);

int _appStatusEntityEstimateSize(
  AppStatusEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _appStatusEntitySerialize(
  AppStatusEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.cartVersion);
  writer.writeLong(offsets[1], object.menuVersion);
  writer.writeLong(offsets[2], object.userVersion);
}

AppStatusEntity _appStatusEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppStatusEntity();
  object.cartVersion = reader.readLong(offsets[0]);
  object.id = id;
  object.menuVersion = reader.readLong(offsets[1]);
  object.userVersion = reader.readLong(offsets[2]);
  return object;
}

P _appStatusEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appStatusEntityGetId(AppStatusEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appStatusEntityGetLinks(AppStatusEntity object) {
  return [];
}

void _appStatusEntityAttach(
    IsarCollection<dynamic> col, Id id, AppStatusEntity object) {
  object.id = id;
}

extension AppStatusEntityQueryWhereSort
    on QueryBuilder<AppStatusEntity, AppStatusEntity, QWhere> {
  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppStatusEntityQueryWhere
    on QueryBuilder<AppStatusEntity, AppStatusEntity, QWhereClause> {
  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AppStatusEntityQueryFilter
    on QueryBuilder<AppStatusEntity, AppStatusEntity, QFilterCondition> {
  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterFilterCondition>
      cartVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cartVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterFilterCondition>
      cartVersionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cartVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterFilterCondition>
      cartVersionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cartVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterFilterCondition>
      cartVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cartVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterFilterCondition>
      menuVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'menuVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterFilterCondition>
      menuVersionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'menuVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterFilterCondition>
      menuVersionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'menuVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterFilterCondition>
      menuVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'menuVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterFilterCondition>
      userVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterFilterCondition>
      userVersionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterFilterCondition>
      userVersionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterFilterCondition>
      userVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AppStatusEntityQueryObject
    on QueryBuilder<AppStatusEntity, AppStatusEntity, QFilterCondition> {}

extension AppStatusEntityQueryLinks
    on QueryBuilder<AppStatusEntity, AppStatusEntity, QFilterCondition> {}

extension AppStatusEntityQuerySortBy
    on QueryBuilder<AppStatusEntity, AppStatusEntity, QSortBy> {
  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterSortBy>
      sortByCartVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cartVersion', Sort.asc);
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterSortBy>
      sortByCartVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cartVersion', Sort.desc);
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterSortBy>
      sortByMenuVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuVersion', Sort.asc);
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterSortBy>
      sortByMenuVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuVersion', Sort.desc);
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterSortBy>
      sortByUserVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userVersion', Sort.asc);
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterSortBy>
      sortByUserVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userVersion', Sort.desc);
    });
  }
}

extension AppStatusEntityQuerySortThenBy
    on QueryBuilder<AppStatusEntity, AppStatusEntity, QSortThenBy> {
  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterSortBy>
      thenByCartVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cartVersion', Sort.asc);
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterSortBy>
      thenByCartVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cartVersion', Sort.desc);
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterSortBy>
      thenByMenuVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuVersion', Sort.asc);
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterSortBy>
      thenByMenuVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuVersion', Sort.desc);
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterSortBy>
      thenByUserVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userVersion', Sort.asc);
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QAfterSortBy>
      thenByUserVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userVersion', Sort.desc);
    });
  }
}

extension AppStatusEntityQueryWhereDistinct
    on QueryBuilder<AppStatusEntity, AppStatusEntity, QDistinct> {
  QueryBuilder<AppStatusEntity, AppStatusEntity, QDistinct>
      distinctByCartVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cartVersion');
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QDistinct>
      distinctByMenuVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'menuVersion');
    });
  }

  QueryBuilder<AppStatusEntity, AppStatusEntity, QDistinct>
      distinctByUserVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userVersion');
    });
  }
}

extension AppStatusEntityQueryProperty
    on QueryBuilder<AppStatusEntity, AppStatusEntity, QQueryProperty> {
  QueryBuilder<AppStatusEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppStatusEntity, int, QQueryOperations> cartVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cartVersion');
    });
  }

  QueryBuilder<AppStatusEntity, int, QQueryOperations> menuVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'menuVersion');
    });
  }

  QueryBuilder<AppStatusEntity, int, QQueryOperations> userVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userVersion');
    });
  }
}
