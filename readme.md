## Sidekiq
To get Sidekiq working as a service, you need to install the [rbenv-vars plugin](https://github.com/rbenv/rbenv-vars).

This not only provides ENV var access at system & app level, but also allows the service to access your credentials inside Ruby.

After installing this, you need to add a `.rbenv-vars` file to your app's directory, with the following vars:

```
RAILS_MASTER_KEY=xxxx
SECRET_KEY_BASE=xxxx
RAILS_ENV=xxxx
RACK_ENV=xxxx
```

Doing this will give Sidekiq the ability to operate as a service.
