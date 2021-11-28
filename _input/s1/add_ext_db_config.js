db.getSiblingDB('admin').runCommand({'cursorTimeoutMillis': 100000});
db.getSiblingDB('admin').runCommand({'wiredTigerMaxCacheOverflowSizeGB': 0});
db.getSiblingDB('admin').runCommand({'maxIndexBuildMemoryUsageMegabytes': 12000});
db.getSiblingDB('admin').runCommand({'wiredTigerConcurrentReadTransactions': 512});
db.getSiblingDB('admin').runCommand({'wiredTigerEngineRuntimeConfig': 'cache_size=12G'});