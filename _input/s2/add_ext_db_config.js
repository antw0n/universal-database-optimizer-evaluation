db.getSiblingDB('admin').runCommand({'cursorTimeoutMillis': 300000});
db.getSiblingDB('admin').runCommand({'wiredTigerMaxCacheOverflowSizeGB': 2});
db.getSiblingDB('admin').runCommand({'maxIndexBuildMemoryUsageMegabytes': 12000});
db.getSiblingDB('admin').runCommand({'wiredTigerConcurrentReadTransactions': 256});
db.getSiblingDB('admin').runCommand({'wiredTigerEngineRuntimeConfig': 'cache_size=8G'});