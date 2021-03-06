db.getSiblingDB("tpch_mongo_2c").runCommand({
    'createIndexes': 'orders-lineitem',
    'indexes': [{'key': {'o_orderdate': 1}, 'name': 'idx_orders-lineitem_b', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_2c").runCommand({
    'createIndexes': 'orders-lineitem',
    'indexes': [{'key': {'o_custkey': 1}, 'name': 'idx_orders-lineitem_a', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_2c").runCommand({
    'createIndexes': 'customer',
    'indexes': [{
        'key': {'c_custkey': 1, 'c_nationkey': 1, 'c_acctbal': 1, 'c_phone': 1},
        'name': 'idx_customer_m',
        'unique': false
    }]
});
db.getSiblingDB("tpch_mongo_2c").runCommand({
    'createIndexes': 'customer', 'indexes': [{'key': {'c_name': 1}, 'name': 'idx_customer_h', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_2c").runCommand({
    'createIndexes': 'customer', 'indexes': [{'key': {'c_mktsegment': 1}, 'name': 'idx_customer_c', 'unique': false}]
});