db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'orders', 'indexes': [{'key': {'o_orderdate': 1}, 'name': 'idx_orders_a', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'orders',
    'indexes': [{
        'key': {'o_custkey': 1, 'o_orderkey': 1, 'o_shippriority': 1},
        'name': 'idx_orders_i',
        'unique': false
    }]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'lineitem',
    'indexes': [{'key': {'l_shipdate': 1, 'l_discount': 1}, 'name': 'idx_lineitem_b', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'customer', 'indexes': [{'key': {'c_phone': 1}, 'name': 'idx_customer_f', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'customer',
    'indexes': [{
        'key': {'c_custkey': 1, 'c_nationkey': 1, 'c_mktsegment': 1},
        'name': 'idx_customer_l',
        'unique': false
    }]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'orders', 'indexes': [{'key': {'o_orderpriority': 1}, 'name': 'idx_orders_f', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'lineitem', 'indexes': [{'key': {'l_partkey': 1}, 'name': 'idx_lineitem_s', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'lineitem', 'indexes': [{'key': {'l_shipinstruct': 1}, 'name': 'idx_lineitem_m', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'lineitem', 'indexes': [{'key': {'l_commitdate': 1}, 'name': 'idx_lineitem_k', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'lineitem', 'indexes': [{'key': {'l_returnflag': 1}, 'name': 'idx_lineitem_q', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'orders', 'indexes': [{'key': {'o_clerk': 1}, 'name': 'idx_orders_g', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'customer', 'indexes': [{'key': {'c_acctbal': 1}, 'name': 'idx_customer_e', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'customer', 'indexes': [{'key': {'c_name': 1}, 'name': 'idx_customer_h', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'lineitem',
    'indexes': [{'key': {'l_orderkey': 1, 'l_suppkey': 1}, 'name': 'idx_lineitem_i', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'lineitem', 'indexes': [{'key': {'l_tax': 1}, 'name': 'idx_lineitem_n', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'lineitem', 'indexes': [{'key': {'l_receiptdate': 1}, 'name': 'idx_lineitem_j', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'lineitem', 'indexes': [{'key': {'l_linestatus': 1}, 'name': 'idx_lineitem_r', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'orders', 'indexes': [{'key': {'o_orderstatus': 1}, 'name': 'idx_orders_b', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'lineitem', 'indexes': [{'key': {'l_quantity': 1}, 'name': 'idx_lineitem_h', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'lineitem', 'indexes': [{'key': {'_id.l_orderkey': 1}, 'name': 'idx_lineitem_u', 'unique': false}]
});
db.getSiblingDB("tpch_mongo_3c").runCommand({
    'createIndexes': 'lineitem', 'indexes': [{'key': {'l_shipmode': 1}, 'name': 'idx_lineitem_l', 'unique': false}]
});