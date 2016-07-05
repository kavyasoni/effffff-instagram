A Game of Tags
==============
I'm releasing the code for an Instagram hashtag finding application that I spent a few months building. I no longer have any use for it because [I have completely quit using Instagram](https://inbound.org/discuss/why-im-forced-to-quit-instagram).

![A Game of Tags]([https://www.filepicker.io/api/file/ALHgFM4TyCmDMDbimsn3])

Codebase
========
If you know how to navigate through a rails codebase, this should be fairly straight-forward. I'm pretty sure that to get going, all you need to do is add your IG API keys to `config/initializers/constants.rb` and then:

* `bundle install`
* `rails s`

You'll also need to be running a redis-server instance as well as Sidekiq for the background processing.

If you want email, you'll need to add your credentials to `config/sendgrid.yml.example` and rename that to `config/sendgrid.yml`

License
=======
Do what you want with this, commercially or otherwise.

PS
==
You're free to use this code but I'd recommend against using it in production with Instagram. You'll just be setting yourself for a constant uphill battle against a company that does not give a single fuck.
