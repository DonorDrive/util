# DonorDrive Utilities
A set of general utility components geared toward simplifying common problems

## Getting Started
The `util` package assumes that it will reside in a `lib` directory under the web root, or mapped in the consuming application.

## lib.util.IContainer (and implementations)
ColdFusion natively supports structures, but there is no set of consistent methods for accessing values across different flavors of  collections (native CF-scopes, Ehcache, user-defined objects, etc.). The goal of `IContainer` is to create that consistent set of methods regardless of the underlying collection.

At the time these components were originally written, CF strongly recommended locking persistent scopes. Depending on whose blog you read, that may still be the case, and accommodating that behind an interface becomes a trivial exercise.

### Motivation
DonorDrive uses a whole bunch of CF's native collections, and some not-so-native. Creating a homogeneous interface to interact with all these disparate collections simplifies development and onboarding new hires. It doesn't matter if you're working with a request-scoped collection, cookies, or Ehcache: manipulating the collection is the same.

### Motivation
DonorDrive maintains a fairly complex object graph within persistent scopes. By creating a wrapper for object persistence using established patterns within the product, we can more seamlessly control what gets persisted, where, and for how long.
