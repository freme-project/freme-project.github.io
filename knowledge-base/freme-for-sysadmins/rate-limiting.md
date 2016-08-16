---
layout: page
title: Rate Limiting
dropdown: Knowledge Base, FREME for System Administrators
pos: 4.15
---
# Rate Limiting
Using the Rate-Limiting filter a server administrator can limit the amount of requests as well as the size of all requests made by one user.
Unauthenticated users are mapped to their IP-Address, Authenticated users to their username.

## Parameters in application.properties

* `ratelimiter.enabled` - When set to `true`, the RateLimitingFilter will be enabled. This parameter defaults to `false`, and when it is not set (or explicitly set to `false`) all other parameters and options regarding this filter will have no effect.
* `ratelimiter.clear.timer` - specifies time in miliseconds until all stored timestamps/sizes of previous requests will be deleted. Defaults to `3600000` which clears the filter once every hour.
* `ratelimiter.yaml` - specifies path to ratelimiter.yaml configuration file used. Defaults to `src/main/resources/ratelimiter.yaml`

## Parameters in ratelimiter.yaml

The `ratelimiter.yaml` file is a configuration file in the [YAML](https://de.wikipedia.org/wiki/YAML) syntax which defines the exact limits for each group of users.
An example `ratelimiter.yaml` could look like this:

```
time-frame: 600   # time period in seconds
rate-limits:
ROLE_ANONYMOUS:
    default:
        - 50
        - 10000 # anomyous user has 50 requests or 1000 kb in the time period
    /e-entity/freme-ner/datasets:
       - 10
        - 1000000 # override for anonymous user to allow 50 requests or 1 000 000 characters in the time period
ROLE_USER:
    default:
        - 100
       - 100000 # anomyous user has 50 requests or 1000 kb in the time period
    /e-entity/freme-ner/datasets:
       - 50
       - 2000000 # override for authenticated users to allow 50 requests or 2 000 000 characters in the time period
ROLE_ADMIN:
    default:
      - 0
       - 0 # admin user has no rate limits configured
henry:
    /e-translation/tilde:
       - 50
       - 100000 # user henry has a special override on tilde
```

Every request will attempt to match one of these properties in the following order:

1. `ratelimits.<username-or-ip>.<requested-endpoint>`
2. `ratelimits.<username-or-ip>.default`
3. `ratelimits.<role-of-caller>.<requested-endpoint>`
4. `ratelimits.<role-of-caller>.default`
5. Throw internal server error `"No identifier found for "+<username-or-ip>+"with role"+ <role-of-caller> + "for resource" + <requested-endpoint>`

To ensure safe behaviour, the usernames `ROLE_ANONYMOUS`, `ROLE_USER`, and `ROLE_ADMIN` are not permitted anymore in the UserController.

This means that the user with the username `henry` can make 50 requests or requests totalling less than 100 000 characters in 600 seconds to `/e-translation/tilde` service. Since `henry` is an authenticated user (and thus has the `ROLE_USER`), he can also make 50 requests totalling less than 2 000 000 characters to `/e-entity/freme-ner/datasets`.
An anonymous user (who will be mapped to his IP-Address) can only make 10 requests to `/e-entity/freme-ner/datasets` totalling 1 000 000 characters in 600 seconds because he has the `ROLE_ANONYMOUS`.
An admin user can make unlimited requests to any e-service, which can be seen that his number of requests and also his size are set to 0.
