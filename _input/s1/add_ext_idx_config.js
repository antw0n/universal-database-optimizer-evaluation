db.getSiblingDB("tpch_mongo_1c").runCommand({
    'createIndexes': 'scale1',
    'indexes': [{'key': {'c_orders.o_orderdate': 1}, 'name': 'idx_customer_c', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_1c").runCommand({
    'createIndexes': 'scale1',
    'indexes': [{'key': {'c_mktsegment': 1}, 'name': 'idx_customer_b', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_1c").runCommand({
    'createIndexes': 'scale1',
    'indexes': [{'key': {'c_acctbal': 1}, 'name': 'idx_customer_a', 'unique': false}]
});