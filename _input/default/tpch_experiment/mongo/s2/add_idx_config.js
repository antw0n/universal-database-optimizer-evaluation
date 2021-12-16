db.getSiblingDB("tpch_mongo_3c").getCollection("customer").createIndex( 
    {"c_acctbal": 1},
    {name: "idx_acctbal"}
);
db.getSiblingDB("tpch_mongo_3c").getCollection("customer").createIndex( 
    {"c_mktsegment": 1},
    {name: "idx_c_mktsegment"}
);
db.getSiblingDB("tpch_mongo_3c").getCollection("orders").createIndex( 
    {"o_custkey": 1},
    {name: "idx_o_custkey"}
);
db.getSiblingDB("tpch_mongo_3c").getCollection("orders").createIndex( 
    {"o_orderdate": 1},
    {name: "idx_o_orderdate"}
);
db.getSiblingDB("tpch_mongo_3c").getCollection("lineitem").createIndex( 
    {"_id.l_orderkey": 1},
    {name: "idx_l_orderkey"}
);
