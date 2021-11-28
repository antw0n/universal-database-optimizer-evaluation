db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'orders',
    'indexes': [{'key': {'o_custkey': 1}, 'name': 'idx_orders_c', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'orders',
    'indexes': [{'key': {'o_custkey': 1, 'o_orderkey': 1, 'o_shippriority': 1}, 'name': 'idx_orders_i', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'orders',
    'indexes': [{'key': {'o_orderstatus': 1}, 'name': 'idx_orders_b', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'customer',
    'indexes': [{'key': {'c_nationkey': 1, 'c_custkey': 1}, 'name': 'idx_orders_c', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'customer',
    'indexes': [{'key': {'c_nationkey': 1}, 'name': 'idx_orders_i', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'customer',
    'indexes': [{'key': {'c_phone': 1}, 'name': 'idx_orders_b', 'unique': false}]
});