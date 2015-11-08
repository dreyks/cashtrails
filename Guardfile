group :red_green_refactor, halt_on_fail: true do
  # guard :rspec, cmd: 'bundle exec spring rspec --format Fuubar --tag ~js' do
  # end

  guard :rubocop, all_on_start: false, notification: false, cli: ['--format', 'fuubar', '-D'] do # , cli: ['--rails'] do
    watch(/.+\.(rb|rake|cap)$/)
    watch(%r{(?:.+/)?\.rubocop.*?\.yml$}) { |m| File.dirname(m[0]) }
  end
end
