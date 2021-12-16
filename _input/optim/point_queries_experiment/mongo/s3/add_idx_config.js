db.getSiblingDB("tpch_mongo_2c").runCommand({
    'createIndexes': 'orders-lineitem',
    'indexes': [{'key': {'o_custkey': 1}, 'name': 'idx_orders-lineitem_a', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_2c").runCommand({
    'createIndexes': 'customer',
    'indexes': [{'key': {'c_nationkey': 1, 'c_custkey': 1}, 'name': 'idx_customer_d', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_2c").runCommand({
    'createIndexes': 'customer', 'indexes': [{'key': {'c_mktsegment': 1}, 'name': 'idx_customer_c', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_2c").runCommand({
    'createIndexes': 'orders-lineitem',
    'indexes': [{'key': {'o_orderdate': 1}, 'name': 'idx_orders-lineitem_b', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_2c").runCommand({
    'createIndexes': 'customer', 'indexes': [{'key': {'c_acctbal': 1}, 'name': 'idx_customer_e', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_2c").runCommand({
    'createIndexes': 'customer', 'indexes': [{'key': {'c_phone': 1}, 'name': 'idx_customer_f', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_2c").runCommand({
    'createIndexes': 'customer', 'indexes': [{'key': {'c_name': 1}, 'name': 'idx_customer_h', 'unique': false}]
});