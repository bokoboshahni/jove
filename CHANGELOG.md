# Jove Changelog

# [1.6.0](https://github.com/bokoboshahni/jove/compare/v1.5.0...v1.6.0) (2022-06-21)


### Bug Fixes

* cascade corporation/alliance sync from repository ([34d2db8](https://github.com/bokoboshahni/jove/commit/34d2db8bd1c9e567ccdeabd6cb6f3000087778d7))
* create market order source for structure ([346cb4b](https://github.com/bokoboshahni/jove/commit/346cb4b32a82f627924760a4b2d9825d1defc2a9))
* env var name ([7ae3a76](https://github.com/bokoboshahni/jove/commit/7ae3a76c0a47eec754985affec2f5b3260c0a084))
* make redis url env vars consistent ([bf052a7](https://github.com/bokoboshahni/jove/commit/bf052a7c5204064ea9284e89b558bfb6a8975aae))
* no-op when schema has not been loaded ([5e1efbe](https://github.com/bokoboshahni/jove/commit/5e1efbecea5f7af5f9bd8ac7d895fc60b5306805))
* openssl 3 incompatibility ([3321f98](https://github.com/bokoboshahni/jove/commit/3321f986beee851f0fb18c5909717dd2e88b5768))
* redis url env ([8cacdc0](https://github.com/bokoboshahni/jove/commit/8cacdc0dc8b476c01d273c706134abbfd505693e))
* remove pg_stat_statements extension from structure.sql ([2ce6917](https://github.com/bokoboshahni/jove/commit/2ce6917e82ba6b21ca07ee4da3ed86de094a964f))
* specify repository for corporation model ([cabff09](https://github.com/bokoboshahni/jove/commit/cabff096a48f225dc48d1c874daedb08678aeba7))
* sync corporation alliance ([915732e](https://github.com/bokoboshahni/jove/commit/915732e51c6d5925a50b2637d00cfe01f3c7a8f7))
* temporary hack for ruby/openssl[#369](https://github.com/bokoboshahni/jove/issues/369) ([6d4a054](https://github.com/bokoboshahni/jove/commit/6d4a054ff55bc47fbf0a94f95a1cee02ea9b120a))
* use asset host if configured ([3c800fb](https://github.com/bokoboshahni/jove/commit/3c800fb1a38a8f4b49afaa83a1b8424f57c39ce0))
* use REDIS_QUEUE_URL env ([5c1990d](https://github.com/bokoboshahni/jove/commit/5c1990d57956eb7542220ae73a88bb2a91efa83a))


### Features

* add capistrano for deployment ([c93c7b9](https://github.com/bokoboshahni/jove/commit/c93c7b94fb93277597a245a286d3eb5c3940ffc9))
* add feature flag for markets ([0af4520](https://github.com/bokoboshahni/jove/commit/0af4520bbdf4e52ac35404280438134d0d7e0616))

# [1.6.0-beta.3](https://github.com/bokoboshahni/jove/compare/v1.6.0-beta.2...v1.6.0-beta.3) (2022-06-20)


### Bug Fixes

* cascade corporation/alliance sync from repository ([34d2db8](https://github.com/bokoboshahni/jove/commit/34d2db8bd1c9e567ccdeabd6cb6f3000087778d7))
* specify repository for corporation model ([cabff09](https://github.com/bokoboshahni/jove/commit/cabff096a48f225dc48d1c874daedb08678aeba7))
* sync corporation alliance ([915732e](https://github.com/bokoboshahni/jove/commit/915732e51c6d5925a50b2637d00cfe01f3c7a8f7))

# [1.6.0-beta.2](https://github.com/bokoboshahni/jove/compare/v1.6.0-beta.1...v1.6.0-beta.2) (2022-06-19)

# [1.6.0-beta.1](https://github.com/bokoboshahni/jove/compare/v1.5.1-beta.1...v1.6.0-beta.1) (2022-06-18)


### Bug Fixes

* env var name ([7ae3a76](https://github.com/bokoboshahni/jove/commit/7ae3a76c0a47eec754985affec2f5b3260c0a084))
* openssl 3 incompatibility ([3321f98](https://github.com/bokoboshahni/jove/commit/3321f986beee851f0fb18c5909717dd2e88b5768))
* redis url env ([8cacdc0](https://github.com/bokoboshahni/jove/commit/8cacdc0dc8b476c01d273c706134abbfd505693e))
* temporary hack for ruby/openssl[#369](https://github.com/bokoboshahni/jove/issues/369) ([6d4a054](https://github.com/bokoboshahni/jove/commit/6d4a054ff55bc47fbf0a94f95a1cee02ea9b120a))
* use asset host if configured ([3c800fb](https://github.com/bokoboshahni/jove/commit/3c800fb1a38a8f4b49afaa83a1b8424f57c39ce0))
* use REDIS_QUEUE_URL env ([5c1990d](https://github.com/bokoboshahni/jove/commit/5c1990d57956eb7542220ae73a88bb2a91efa83a))


### Features

* add capistrano for deployment ([c93c7b9](https://github.com/bokoboshahni/jove/commit/c93c7b94fb93277597a245a286d3eb5c3940ffc9))

## [1.5.1-beta.1](https://github.com/bokoboshahni/jove/compare/v1.5.0...v1.5.1-beta.1) (2022-06-18)


### Bug Fixes

* make redis url env vars consistent ([bf052a7](https://github.com/bokoboshahni/jove/commit/bf052a7c5204064ea9284e89b558bfb6a8975aae))
* no-op when schema has not been loaded ([5e1efbe](https://github.com/bokoboshahni/jove/commit/5e1efbecea5f7af5f9bd8ac7d895fc60b5306805))
* remove pg_stat_statements extension from structure.sql ([2ce6917](https://github.com/bokoboshahni/jove/commit/2ce6917e82ba6b21ca07ee4da3ed86de094a964f))

# [1.5.0](https://github.com/bokoboshahni/jove/compare/v1.4.0...v1.5.0) (2022-06-18)


### Bug Fixes

* add retention policy for market order snapshots ([cf3c7b1](https://github.com/bokoboshahni/jove/commit/cf3c7b1d414336edee7b84f8cefb9f552199ebbc))
* database consistency ([3506c90](https://github.com/bokoboshahni/jove/commit/3506c9004e3d448a44a06b4e5ecec500b9fa33cc))
* remove janky descendants lookup ([3923357](https://github.com/bokoboshahni/jove/commit/39233575be4e35af1488c97160bf8499b9ba98d0))
* remove redundant indexes ([a2d9bbb](https://github.com/bokoboshahni/jove/commit/a2d9bbba1186c35b895685f9452d4caba3f47ed5))
* retry on mismatched etags ([7f3d969](https://github.com/bokoboshahni/jove/commit/7f3d969104769efc5831f4331067dea304330c49))
* status color key ([8fc08fc](https://github.com/bokoboshahni/jove/commit/8fc08fcfd34a9ce65819268e69ed065c305361dd))


### Features

* charts for market order source snapshots ([15121db](https://github.com/bokoboshahni/jove/commit/15121dbe5626b6bf06175cf2ae2a5f7cafe46521))

# [1.5.0-beta.1](https://github.com/bokoboshahni/jove/compare/v1.4.0...v1.5.0-beta.1) (2022-06-17)


### Bug Fixes

* add retention policy for market order snapshots ([cf3c7b1](https://github.com/bokoboshahni/jove/commit/cf3c7b1d414336edee7b84f8cefb9f552199ebbc))
* database consistency ([3506c90](https://github.com/bokoboshahni/jove/commit/3506c9004e3d448a44a06b4e5ecec500b9fa33cc))
* remove janky descendants lookup ([3923357](https://github.com/bokoboshahni/jove/commit/39233575be4e35af1488c97160bf8499b9ba98d0))
* remove redundant indexes ([a2d9bbb](https://github.com/bokoboshahni/jove/commit/a2d9bbba1186c35b895685f9452d4caba3f47ed5))
* retry on mismatched etags ([7f3d969](https://github.com/bokoboshahni/jove/commit/7f3d969104769efc5831f4331067dea304330c49))
* status color key ([8fc08fc](https://github.com/bokoboshahni/jove/commit/8fc08fcfd34a9ce65819268e69ed065c305361dd))


### Features

* charts for market order source snapshots ([15121db](https://github.com/bokoboshahni/jove/commit/15121dbe5626b6bf06175cf2ae2a5f7cafe46521))

# [1.4.0](https://github.com/bokoboshahni/jove/compare/v1.3.1...v1.4.0) (2022-06-15)


### Features

* market order sync ([61ccc66](https://github.com/bokoboshahni/jove/commit/61ccc660bc1d5dedc503f4970ded6737b127c1ec))

# [1.4.0-beta.1](https://github.com/bokoboshahni/jove/compare/v1.3.1...v1.4.0-beta.1) (2022-06-15)


### Features

* market order sync ([61ccc66](https://github.com/bokoboshahni/jove/commit/61ccc660bc1d5dedc503f4970ded6737b127c1ec))

## [1.3.1](https://github.com/bokoboshahni/jove/compare/v1.3.0...v1.3.1) (2022-06-04)

# [1.3.0](https://github.com/bokoboshahni/jove/compare/v1.2.0...v1.3.0) (2022-06-04)


### Bug Fixes

* don't create static data versions with empty checksums ([14e3df2](https://github.com/bokoboshahni/jove/commit/14e3df29c99fd71fbad51b02d6be4ecf89646e17))


### Features

* esi requests for structure discovery ([bc3b863](https://github.com/bokoboshahni/jove/commit/bc3b86378254de31b4b8b04656f31a9df8a70617))
* refresh esi tokens periodically ([370bd04](https://github.com/bokoboshahni/jove/commit/370bd048211cec306299610bf0cfc1c583629f20))

# [1.3.0-beta.2](https://github.com/bokoboshahni/jove/compare/v1.3.0-beta.1...v1.3.0-beta.2) (2022-06-04)


### Bug Fixes

* don't create static data versions with empty checksums ([14e3df2](https://github.com/bokoboshahni/jove/commit/14e3df29c99fd71fbad51b02d6be4ecf89646e17))


### Features

* refresh esi tokens periodically ([370bd04](https://github.com/bokoboshahni/jove/commit/370bd048211cec306299610bf0cfc1c583629f20))

# [1.3.0-beta.1](https://github.com/bokoboshahni/jove/compare/v1.2.0...v1.3.0-beta.1) (2022-06-03)


### Features

* esi requests for structure discovery ([bc3b863](https://github.com/bokoboshahni/jove/commit/bc3b86378254de31b4b8b04656f31a9df8a70617))

# [1.2.0](https://github.com/bokoboshahni/jove/compare/v1.1.8...v1.2.0) (2022-05-31)


### Bug Fixes

* add faction and wormhole class to constellations ([48b396c](https://github.com/bokoboshahni/jove/commit/48b396c89b2d4457199acc2c53b6d7c78b90907a))
* add source to planet schematic relations ([eb029f7](https://github.com/bokoboshahni/jove/commit/eb029f7cd39de55f74aa039ad29b6602dca3aef2))


### Features

* add dogma columns to types ([fbeda4d](https://github.com/bokoboshahni/jove/commit/fbeda4dab2e3fc5816e9d4ca33c61de90c9c3fde))
* add model for static data versions ([7f1bb32](https://github.com/bokoboshahni/jove/commit/7f1bb327f1700d88e79ad3e79e075bebc3010d07))
* add paper_trail for model versioning ([be25c59](https://github.com/bokoboshahni/jove/commit/be25c593b20717860a9b27c8cf9af00d30efb5f8))
* add policy for static data versions ([fa6dc4b](https://github.com/bokoboshahni/jove/commit/fa6dc4b30860ed03006ad6b2978b81f8b8fb5eb5))
* add static data admin ui and jobs ([4a4824a](https://github.com/bokoboshahni/jove/commit/4a4824a5d5f165a6e43102e3121c658d67d4e3d0))
* add trait column to types ([cecfb46](https://github.com/bokoboshahni/jove/commit/cecfb467993d8bf5f3cc36e1b5abae83f10396f3))
* audit changes to static data versions ([e71f688](https://github.com/bokoboshahni/jove/commit/e71f688ed71aad4929b2e4c9db85859bbdfc9a7e))
* check daily for new sde version ([93a7fdb](https://github.com/bokoboshahni/jove/commit/93a7fdbb416a5d01c9edcc344f238af124e6430d))
* create schema for active_storage ([fd694a5](https://github.com/bokoboshahni/jove/commit/fd694a55dd8747927b8760874b2cb117fca0d2c3))
* generate truncated sde fixtures ([fbf7bf7](https://github.com/bokoboshahni/jove/commit/fbf7bf73aa621a55b431210b550650a15f314fff))
* import bloodlines from sde ([323bcf9](https://github.com/bokoboshahni/jove/commit/323bcf904e5031e71870a9649e9781dcb1b162c3))
* import blueprints from sde ([fb174fb](https://github.com/bokoboshahni/jove/commit/fb174fb3947de53b76ad25fe7b7acdc63430ccdb))
* import categories from sde ([37cf7e0](https://github.com/bokoboshahni/jove/commit/37cf7e0bc0a98c0f7bc0b1911dc438a4825d1724))
* import celestials from sde ([ae9feb4](https://github.com/bokoboshahni/jove/commit/ae9feb458d90771e811535d14adfd15af85528b2))
* import constellations from sde ([852efc5](https://github.com/bokoboshahni/jove/commit/852efc516a33bcf2866a94f643eae5a230dc1c1c))
* import dogma attributes from sde ([7159205](https://github.com/bokoboshahni/jove/commit/7159205f79b3d82a3dbed0047be686aef473475f))
* import dogma categories from sde ([0e9ee7f](https://github.com/bokoboshahni/jove/commit/0e9ee7fda4eef0539a64c318c8d867ccbbdf4a08))
* import dogma effects from sde ([ccbef5a](https://github.com/bokoboshahni/jove/commit/ccbef5a3387b6bc33a2bfbb410a2400f24f8998e))
* import factions from sde ([2ae3906](https://github.com/bokoboshahni/jove/commit/2ae3906e92e119ccd53324d92edd8de13436a0bc))
* import graphics from sde ([7656d24](https://github.com/bokoboshahni/jove/commit/7656d241d772c6cdeb4594bdf946876732b6c4dc))
* import groups from sde ([8cafba8](https://github.com/bokoboshahni/jove/commit/8cafba804a91e9442b82626740f2a0bcb8710afa))
* import icons from sde ([2e20a22](https://github.com/bokoboshahni/jove/commit/2e20a22d7351a9a102348b43b15f926ca12d8493))
* import inventory flags from sde ([a01833c](https://github.com/bokoboshahni/jove/commit/a01833cc19e809966d45e97b1491075095622479))
* import market groups from sde ([4e10ea4](https://github.com/bokoboshahni/jove/commit/4e10ea45f1f3c45f1b34bea601615890618c057b))
* import meta groups from sde ([70522a6](https://github.com/bokoboshahni/jove/commit/70522a6f5181d9aae0af5c6637c8f038ac498684))
* import npc corporations from sde ([50fc3f2](https://github.com/bokoboshahni/jove/commit/50fc3f2f4e4b63bf27acb5f358a3ed6ad528c891))
* import planet schematics from sde ([f41bee8](https://github.com/bokoboshahni/jove/commit/f41bee86403f81e08590ff2f71579ff4b3696296))
* import races from sde ([08a7221](https://github.com/bokoboshahni/jove/commit/08a7221f9bb0d0ed5367058f90083846d4285702))
* import regions from sde ([1c0591c](https://github.com/bokoboshahni/jove/commit/1c0591cc983cab2f7526b6b64a2aa0595d37f9d8))
* import solar systems from sde ([49215f8](https://github.com/bokoboshahni/jove/commit/49215f852db06f74f281068c3b0f3893a0e414ea))
* import stargates from sde ([29fe515](https://github.com/bokoboshahni/jove/commit/29fe5156fb4d73ebebc455a79a78d5c9d2cb4a76))
* import station operations ([c25f1ef](https://github.com/bokoboshahni/jove/commit/c25f1ef3661107fde15b22a4f436fecca7510feb))
* import station services from sde ([d48b2d5](https://github.com/bokoboshahni/jove/commit/d48b2d55048b2bf1efe91cbb8b610264e844fdf4))
* import stations from sde ([8369abb](https://github.com/bokoboshahni/jove/commit/8369abb48e92b0d92d6e37f35d81613e869066d6))
* import type materials from sde ([928ae61](https://github.com/bokoboshahni/jove/commit/928ae61bd466684b9c34151485d80d6c85432980))
* import types from sde ([75301d6](https://github.com/bokoboshahni/jove/commit/75301d67c334f966c0020fde19eb42139d1f4562))
* import units from sde ([b7bd1a4](https://github.com/bokoboshahni/jove/commit/b7bd1a48fe802dd2fd514c6eae1050cdd3bab1d2))
* index models for full text search ([fbbcc7f](https://github.com/bokoboshahni/jove/commit/fbbcc7f8dbdb0b055542dd721c044b96c934c153))
* log changes to sde models ([e578d9e](https://github.com/bokoboshahni/jove/commit/e578d9e5836393cfe4961025505ab01fc1f93951))
* move dogma effect modifiers to dogma effects table ([a854d0c](https://github.com/bokoboshahni/jove/commit/a854d0c1ba219b73bf9ac4fb5853df9ca8a666cf))
* set up logidze for static data versioning ([da5b3b5](https://github.com/bokoboshahni/jove/commit/da5b3b514786e9396754290788b71a1592c258d2))
* set up sidekiq for background jobs ([e213d69](https://github.com/bokoboshahni/jove/commit/e213d69a9e48dc531c95b4666118e2883d673ea9))
* use data from hoboleaks ([fe8f536](https://github.com/bokoboshahni/jove/commit/fe8f536efb87645a3797dc76dfbf63faaf7f2d9d))


### Performance Improvements

* optimize memory usage for sde importers ([27e7e4c](https://github.com/bokoboshahni/jove/commit/27e7e4c2e32788f62da33729728e5ae7c858fad0))

# [1.2.0-beta.14](https://github.com/bokoboshahni/jove/compare/v1.2.0-beta.13...v1.2.0-beta.14) (2022-05-31)


### Features

* index models for full text search ([fbbcc7f](https://github.com/bokoboshahni/jove/commit/fbbcc7f8dbdb0b055542dd721c044b96c934c153))

# [1.2.0-beta.13](https://github.com/bokoboshahni/jove/compare/v1.2.0-beta.12...v1.2.0-beta.13) (2022-05-31)


### Features

* move dogma effect modifiers to dogma effects table ([a854d0c](https://github.com/bokoboshahni/jove/commit/a854d0c1ba219b73bf9ac4fb5853df9ca8a666cf))

# [1.2.0-beta.12](https://github.com/bokoboshahni/jove/compare/v1.2.0-beta.11...v1.2.0-beta.12) (2022-05-31)


### Features

* import inventory flags from sde ([a01833c](https://github.com/bokoboshahni/jove/commit/a01833cc19e809966d45e97b1491075095622479))

# [1.2.0-beta.11](https://github.com/bokoboshahni/jove/compare/v1.2.0-beta.10...v1.2.0-beta.11) (2022-05-31)


### Features

* use data from hoboleaks ([fe8f536](https://github.com/bokoboshahni/jove/commit/fe8f536efb87645a3797dc76dfbf63faaf7f2d9d))

# [1.2.0-beta.10](https://github.com/bokoboshahni/jove/compare/v1.2.0-beta.9...v1.2.0-beta.10) (2022-05-31)


### Features

* add model for static data versions ([7f1bb32](https://github.com/bokoboshahni/jove/commit/7f1bb327f1700d88e79ad3e79e075bebc3010d07))
* add policy for static data versions ([fa6dc4b](https://github.com/bokoboshahni/jove/commit/fa6dc4b30860ed03006ad6b2978b81f8b8fb5eb5))
* add static data admin ui and jobs ([4a4824a](https://github.com/bokoboshahni/jove/commit/4a4824a5d5f165a6e43102e3121c658d67d4e3d0))
* audit changes to static data versions ([e71f688](https://github.com/bokoboshahni/jove/commit/e71f688ed71aad4929b2e4c9db85859bbdfc9a7e))
* check daily for new sde version ([93a7fdb](https://github.com/bokoboshahni/jove/commit/93a7fdbb416a5d01c9edcc344f238af124e6430d))
* log changes to sde models ([e578d9e](https://github.com/bokoboshahni/jove/commit/e578d9e5836393cfe4961025505ab01fc1f93951))
* set up logidze for static data versioning ([da5b3b5](https://github.com/bokoboshahni/jove/commit/da5b3b514786e9396754290788b71a1592c258d2))
* set up sidekiq for background jobs ([e213d69](https://github.com/bokoboshahni/jove/commit/e213d69a9e48dc531c95b4666118e2883d673ea9))


### Performance Improvements

* optimize memory usage for sde importers ([27e7e4c](https://github.com/bokoboshahni/jove/commit/27e7e4c2e32788f62da33729728e5ae7c858fad0))

# [1.2.0-beta.9](https://github.com/bokoboshahni/jove/compare/v1.2.0-beta.8...v1.2.0-beta.9) (2022-05-26)


### Features

* add trait column to types ([cecfb46](https://github.com/bokoboshahni/jove/commit/cecfb467993d8bf5f3cc36e1b5abae83f10396f3))

# [1.2.0-beta.8](https://github.com/bokoboshahni/jove/compare/v1.2.0-beta.7...v1.2.0-beta.8) (2022-05-26)


### Features

* add dogma columns to types ([fbeda4d](https://github.com/bokoboshahni/jove/commit/fbeda4dab2e3fc5816e9d4ca33c61de90c9c3fde))
* import dogma attributes from sde ([7159205](https://github.com/bokoboshahni/jove/commit/7159205f79b3d82a3dbed0047be686aef473475f))
* import dogma categories from sde ([0e9ee7f](https://github.com/bokoboshahni/jove/commit/0e9ee7fda4eef0539a64c318c8d867ccbbdf4a08))
* import dogma effects from sde ([ccbef5a](https://github.com/bokoboshahni/jove/commit/ccbef5a3387b6bc33a2bfbb410a2400f24f8998e))
* import units from sde ([b7bd1a4](https://github.com/bokoboshahni/jove/commit/b7bd1a48fe802dd2fd514c6eae1050cdd3bab1d2))

# [1.2.0-beta.7](https://github.com/bokoboshahni/jove/compare/v1.2.0-beta.6...v1.2.0-beta.7) (2022-05-26)


### Bug Fixes

* add source to planet schematic relations ([eb029f7](https://github.com/bokoboshahni/jove/commit/eb029f7cd39de55f74aa039ad29b6602dca3aef2))

# [1.2.0-beta.6](https://github.com/bokoboshahni/jove/compare/v1.2.0-beta.5...v1.2.0-beta.6) (2022-05-26)


### Features

* import blueprints from sde ([fb174fb](https://github.com/bokoboshahni/jove/commit/fb174fb3947de53b76ad25fe7b7acdc63430ccdb))
* import planet schematics from sde ([f41bee8](https://github.com/bokoboshahni/jove/commit/f41bee86403f81e08590ff2f71579ff4b3696296))
* import type materials from sde ([928ae61](https://github.com/bokoboshahni/jove/commit/928ae61bd466684b9c34151485d80d6c85432980))

# [1.2.0-beta.5](https://github.com/bokoboshahni/jove/compare/v1.2.0-beta.4...v1.2.0-beta.5) (2022-05-25)


### Features

* import station operations ([c25f1ef](https://github.com/bokoboshahni/jove/commit/c25f1ef3661107fde15b22a4f436fecca7510feb))
* import station services from sde ([d48b2d5](https://github.com/bokoboshahni/jove/commit/d48b2d55048b2bf1efe91cbb8b610264e844fdf4))
* import stations from sde ([8369abb](https://github.com/bokoboshahni/jove/commit/8369abb48e92b0d92d6e37f35d81613e869066d6))

# [1.2.0-beta.4](https://github.com/bokoboshahni/jove/compare/v1.2.0-beta.3...v1.2.0-beta.4) (2022-05-25)


### Features

* import categories from sde ([37cf7e0](https://github.com/bokoboshahni/jove/commit/37cf7e0bc0a98c0f7bc0b1911dc438a4825d1724))
* import graphics from sde ([7656d24](https://github.com/bokoboshahni/jove/commit/7656d241d772c6cdeb4594bdf946876732b6c4dc))
* import groups from sde ([8cafba8](https://github.com/bokoboshahni/jove/commit/8cafba804a91e9442b82626740f2a0bcb8710afa))
* import icons from sde ([2e20a22](https://github.com/bokoboshahni/jove/commit/2e20a22d7351a9a102348b43b15f926ca12d8493))
* import market groups from sde ([4e10ea4](https://github.com/bokoboshahni/jove/commit/4e10ea45f1f3c45f1b34bea601615890618c057b))
* import meta groups from sde ([70522a6](https://github.com/bokoboshahni/jove/commit/70522a6f5181d9aae0af5c6637c8f038ac498684))
* import types from sde ([75301d6](https://github.com/bokoboshahni/jove/commit/75301d67c334f966c0020fde19eb42139d1f4562))

# [1.2.0-beta.3](https://github.com/bokoboshahni/jove/compare/v1.2.0-beta.2...v1.2.0-beta.3) (2022-05-25)


### Bug Fixes

* add faction and wormhole class to constellations ([48b396c](https://github.com/bokoboshahni/jove/commit/48b396c89b2d4457199acc2c53b6d7c78b90907a))


### Features

* import bloodlines from sde ([323bcf9](https://github.com/bokoboshahni/jove/commit/323bcf904e5031e71870a9649e9781dcb1b162c3))
* import celestials from sde ([ae9feb4](https://github.com/bokoboshahni/jove/commit/ae9feb458d90771e811535d14adfd15af85528b2))
* import constellations from sde ([852efc5](https://github.com/bokoboshahni/jove/commit/852efc516a33bcf2866a94f643eae5a230dc1c1c))
* import factions from sde ([2ae3906](https://github.com/bokoboshahni/jove/commit/2ae3906e92e119ccd53324d92edd8de13436a0bc))
* import npc corporations from sde ([50fc3f2](https://github.com/bokoboshahni/jove/commit/50fc3f2f4e4b63bf27acb5f358a3ed6ad528c891))
* import races from sde ([08a7221](https://github.com/bokoboshahni/jove/commit/08a7221f9bb0d0ed5367058f90083846d4285702))
* import solar systems from sde ([49215f8](https://github.com/bokoboshahni/jove/commit/49215f852db06f74f281068c3b0f3893a0e414ea))
* import stargates from sde ([29fe515](https://github.com/bokoboshahni/jove/commit/29fe5156fb4d73ebebc455a79a78d5c9d2cb4a76))

# [1.2.0-beta.2](https://github.com/bokoboshahni/jove/compare/v1.2.0-beta.1...v1.2.0-beta.2) (2022-05-24)


### Features

* generate truncated sde fixtures ([fbf7bf7](https://github.com/bokoboshahni/jove/commit/fbf7bf73aa621a55b431210b550650a15f314fff))
* import regions from sde ([1c0591c](https://github.com/bokoboshahni/jove/commit/1c0591cc983cab2f7526b6b64a2aa0595d37f9d8))



# [1.2.0-beta.1](https://github.com/bokoboshahni/jove/compare/v1.1.4-beta.4...v1.2.0-beta.1) (2022-05-24)


### Features

* add paper_trail for model versioning ([be25c59](https://github.com/bokoboshahni/jove/commit/be25c593b20717860a9b27c8cf9af00d30efb5f8))
* create schema for active_storage ([fd694a5](https://github.com/bokoboshahni/jove/commit/fd694a55dd8747927b8760874b2cb117fca0d2c3))


## [1.1.8](https://github.com/bokoboshahni/jove/compare/v1.1.7...v1.1.8) (2022-05-30)

## [1.1.7](https://github.com/bokoboshahni/jove/compare/v1.1.6...v1.1.7) (2022-05-30)

## [1.1.6](https://github.com/bokoboshahni/jove/compare/v1.1.5...v1.1.6) (2022-05-25)

## [1.1.5](https://github.com/bokoboshahni/jove/compare/v1.1.4...v1.1.5) (2022-05-24)

## [1.1.4](https://github.com/bokoboshahni/jove/compare/v1.1.3...v1.1.4) (2022-05-24)


## [1.1.4-beta.4](https://github.com/bokoboshahni/jove/compare/v1.1.4-beta.3...v1.1.4-beta.4) (2022-05-23)

## [1.1.4-beta.3](https://github.com/bokoboshahni/jove/compare/v1.1.4-beta.2...v1.1.4-beta.3) (2022-05-23)


## [1.1.4-beta.2](https://github.com/bokoboshahni/jove/compare/v1.1.4-beta.1...v1.1.4-beta.2) (2022-05-23)

## [1.1.4-beta.1](https://github.com/bokoboshahni/jove/compare/v1.1.3...v1.1.4-beta.1) (2022-05-21)


## [1.1.3](https://github.com/bokoboshahni/jove/compare/v1.1.2...v1.1.3) (2022-05-21)

## [1.1.3-beta.1](https://github.com/bokoboshahni/jove/compare/v1.1.2...v1.1.3-beta.1) (2022-05-21)


## [1.1.2](https://github.com/bokoboshahni/jove/compare/v1.1.1...v1.1.2) (2022-05-21)

## [1.1.1](https://github.com/bokoboshahni/jove/compare/v1.1.0...v1.1.1) (2022-05-21)

# [1.1.0](https://github.com/bokoboshahni/jove/compare/v1.0.0...v1.1.0) (2022-05-21)


### Features

* add jove version link to user menu ([fd901ce](https://github.com/bokoboshahni/jove/commit/fd901ce21e8953975c7b46f382f9a79f2bbdc2d4))



# [1.0.0](https://github.com/bokoboshahni/jove/compare/4cd22b5d86b7db8d7b63720edf032036dd6336ec...v1.0.0) (2022-05-21)


### Features

* initial commit with rails skeleton ([4cd22b5](https://github.com/bokoboshahni/jove/commit/4cd22b5d86b7db8d7b63720edf032036dd6336ec))
* log error for invalid admin character id ([414d40a](https://github.com/bokoboshahni/jove/commit/414d40a072d3c07b7501b3da503658d99d95f73d))
* user identity management ([3aecce8](https://github.com/bokoboshahni/jove/commit/3aecce854ea802a5223c17d79277ef1db0ed3be6))
