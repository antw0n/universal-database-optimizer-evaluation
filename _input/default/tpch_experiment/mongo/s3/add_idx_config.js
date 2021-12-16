db.getSiblingDB("tpch_mongo_2c").getCollection("customer").createIndex( 
    {"c_acctbal": 1},
    {name: "idx_c_acctbal"}
);
db.getSiblingDB("tpch_mongo_2c").getCollection("customer").createIndex( 
    {"c_mktsegment": 1},
    {name: "idx_c_mktsegment"}
);
db.getSiblingDB("tpch_mongo_2c").getCollection("orders-lineitem").createIndex( 
    {"o_custkey": 1},
    {name: "idx_o_custkey"}
);
db.getSiblingDB("tpch_mongo_2c").getCollection("orders-lineitem").createIndex( 
    {"o_orderdate": 1},
    {name: "idx_o_orderdate"}
);
