db.getSiblingDB("tpch_mongo_1c").getCollection("scale1").createIndex(
    {"c_acctbal": 1},
    {name: "idx_c_acctbal"}
);
db.getSiblingDB("tpch_mongo_1c").getCollection("scale1").createIndex(
    {"c_mktsegment": 1},
    {name: "idx_c_mktsegment"}
);
db.getSiblingDB("tpch_mongo_1c").getCollection("scale1").createIndex(
    {"c_orders.o_orderdate": 1},
    {name: "idx_o_orderdate"}
);
db.getSiblingDB("tpch_mongo_1c").getCollection("scale1").createIndex(
    {"c_acctbal": 1},
    {name: "idx_c_acctbal"}
);
db.getSiblingDB("tpch_mongo_1c").getCollection("scale1").createIndex(
    {"c_mktsegment": 1},
    {name: "idx_c_mktsegment"}
);
db.getSiblingDB("tpch_mongo_1c").getCollection("scale1").createIndex(
    {"c_orders.o_orderdate": 1},
    {name: "idx_o_orderdate"}
);