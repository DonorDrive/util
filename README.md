# DonorDrive Utilities
A set of general utility components geared toward simplifying common problems

## util.Container (and implementations)
ColdFusion natively supports structures, but there is no set of consistent methods for accessing values across different flavors of  collections (native CF-scopes, EHCache, user-defined objects, etc.). The goal of `Container` is to create that consistent set of methods regardless of the underlying collection.

At the time these components were originally written, CF strongly recommended locking persistent scopes. Depending on whose blog you read, that may still be the case, and accommodating that behind an interface becomes a trivial exercise.

## util.CacheProxy
A caching strategy that saves the result of an expensive method call for future use based on the incoming arguments. In this case, the result can be stored in any `util.Container` implementation. The goal is to isolate the responsibility of caching from the code doing the actual work.
