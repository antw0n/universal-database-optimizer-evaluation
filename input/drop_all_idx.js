["tpch_mongo_1c", "tpch_mongo_2c", "tpch_mongo_3c"].forEach(function (db_name) {
  db.getSiblingDB(db_name).getCollectionNames().forEach(function (col_name) {
    db.getSiblingDB(db_name).getCollection(col_name).dropIndexes();
  });
});