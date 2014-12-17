# PGPAuth for iOS

This is PGPAuth for iOS. This is currently work-in-progress and not yet usable.

Below you can find the current status, where "current" means "the last time I updated this readme", which hasn't the highest priority. Just check the commits.


## Features:
- mutliple servers can be defined
- servers are serialized on app-exit and deserialized on start
- OpenPGP operations are working if you manually import key into keyring (before deploying to device)
- keys can be selected for a server, they are loaded from keyring

## To be done:
- need a way to import keys from iCloud or something.
- currently working on a way to generate keys on device
- need a way to share public key (to administrator of server)
- implement server-configuration URLs (compatible with the android version)
- clean the sources (especially KeyFactory.m)
- server-deletion is completely missing yet

## Known bugs:
- don't try generate a key without having a breakpoint before the key is imported into ObjectivePGP as ObjectivePGP currently enters a "while(true) malloc(MANY_BYTES);" (or something similiar ;) )
