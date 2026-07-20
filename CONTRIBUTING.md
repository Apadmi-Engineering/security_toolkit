# Contributing

Want to help? Great! 🙌 Work is driven by GitHub issues so that's the best place to start.

All the sources providing information to implement this package are listed in `docs/SOURCES.md`, 
please update as appropriate.

## Tree Hygiene

If you're contributing code, this project follows a Gitflow feature branching model. Please also 
use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) to help others quickly 
scan the tree and understand the changes being made. Pull requests for feature branches target the 
`develop` branch and once reviewed by a maintainer, will have their commits squashed for tidiness.

## Versioning

This project uses semantic versioning, read [here](https://semver.org/) for more info.

With regards to what counts as a breaking change, anything that changes the API for package 
consumers counts as a breaking change.

## Bridging

This plugin utilises the [pigeon](https://pub.dev/packages/pigeon) package in order to generate
type-safe bindings for platform channels on top of the method channel system offered in the Flutter
SDK. As a rule, **the Pigeon generated bindings should not be exposed in this package's API**.
Instead, a Dart-side interface should be used to provide a layer of abstraction and remove the need
for frequent breaking changes.

Whenever you wish to update the Pigeon bindings, simply run:

```shell
dart run pigeon --input pigeons/security_toolkit_messages.dart
```

Generated pigeon bindings are source-controlled in this package due to it being published 
through Git. Generally, the pigeon bindings don't change often enough to be problematic during
development.

## Tests

Due to the architecture of this project, testing is mostly performed manually however there are a 
couple of unit tests asserting the behaviour of the `SecurityCheckResult` class. These are run on 
CI as part of pull requests.