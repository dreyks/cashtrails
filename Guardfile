group :red_green_refactor, halt_on_fail: true do
  guard :rspec, cmd: 'bundle exec rspec --format Fuubar' do
    watch(%r{^spec/.+_spec\.rb$})
    watch('spec/spec_helper.rb')                        { 'spec' }
    watch('config/routes.rb')                           { 'spec/routing' }
    watch('app/controllers/application_controller.rb')  { 'spec/controllers' }
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/feature/#{m[1]}_spec.rb"] }
  end

  guard :rubocop, all_on_start: false, notification: false, cli: ['--format', 'fuubar', '-D'] do # , cli: ['--rails'] do
    watch(/.+\.(rb|rake|cap)$/)
    watch(%r{(?:.+/)?\.rubocop.*?\.yml$}) { |m| File.dirname(m[0]) }
  end
end
