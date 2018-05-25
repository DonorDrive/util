<ehcache name="mxunitCacheManager">
	<defaultCache
		clearOnFlush="true"
		diskExpiryThreadIntervalSeconds="3600"
		diskPersistent="false"
		diskSpoolBufferSizeMB="30"
		eternal="false"
		maxElementsInMemory="10000"
		maxElementsOnDisk="10000000"
		memoryStoreEvictionPolicy="LRU"
		overflowToDisk="false"
		timeToIdleSeconds="86400"
		timeToLiveSeconds="86400"
		statistics="false" />
	<cache
		name="mxunitCache"
		maxEntriesLocalHeap="10000"
		timeToIdleSeconds="3600"
		timeToLiveSeconds="3600">
		<searchable keys="true" values="true" />
	</cache>
</ehcache>