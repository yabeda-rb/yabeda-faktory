# Yabeda::[Faktory]

Built-in metrics for monitoring [Faktory worker for Ruby] out of the box! Part of the [yabeda] suite.

## Installation

```ruby
gem 'yabeda-faktory'

# Then add monitoring system adapter, e.g.:
# gem 'yabeda-prometheus'

# If you're using Railsm don't forget to add plugin for it:
# gem 'yabeda-rails'
# But if not then you should run `Yabeda.configure!` manually when your app is ready.
```

And then execute:

    $ bundle

**And that is it!** Faktory metrics are being collected!

Additionally, depending on your adapter, you may want to setup metrics export. E.g. for [yabeda-prometheus]:

```ruby
# config/initializers/faktory or elsewhere
Faktory.configure_worker do |_config|
  Yabeda::Prometheus::Exporter.start_metrics_server!
end
```

## Metrics

 - Total number of executed jobs: `faktory_jobs_executed_total` -  (segmented by `queue`, `worker` job class name, and whether their execution was `success`ful)
 - Time of job run: `faktory_job_execution_runtime` (seconds per job execution, segmented by `queue`, `worker` job class name, and whether their execution was `success`ful)
 - Total number of enqueued jobs: `faktory_jobs_enqueued_total` -  (segmented by `queue`, `worker` job class name, and whether enqueue was `success`ful)
 - Time of job run: `faktory_job_enqueue_runtime` (seconds per job enqueue, segmented by `queue`, `worker` job class name, and whether enqueue was `success`ful

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yabeda-rb/yabeda-faktory.

### Releasing

1. Bump version number in `lib/yabeda/faktory/version.rb`

   In case of pre-releases keep in mind [rubygems/rubygems#3086](https://github.com/rubygems/rubygems/issues/3086) and check version with command like `Gem::Version.new(Yabeda::Faktory::VERSION).to_s`

2. Fill `CHANGELOG.md` with missing changes, add header with version and date.

3. Make a commit:

   ```sh
   git add lib/yabeda/faktory/version.rb CHANGELOG.md
   version=$(ruby -r ./lib/yabeda/faktory/version.rb -e "puts Gem::Version.new(Yabeda::Faktory::VERSION)")
   git commit --message="${version}: " --edit
   ```

4. Create annotated tag:

   ```sh
   git tag v${version} --annotate --message="${version}: " --edit --sign
   ```

5. Fill version name into subject line and (optionally) some description (list of changes will be taken from changelog and appended automatically)

6. Push it:

   ```sh
   git push --follow-tags
   ```

7. GitHub Actions will create a new release, build and push gem into RubyGems! You're done!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[Faktory]: https://contribsys.com/faktory/ "Language-agnostic persistent background job server "
[Faktory worker for Ruby]: https://github.com/contribsys/faktory_worker_ruby "Faktory worker for Ruby"
[yabeda]: https://github.com/yabeda-rb/yabeda
[yabeda-prometheus]: https://github.com/yabeda-rb/yabeda-prometheus
