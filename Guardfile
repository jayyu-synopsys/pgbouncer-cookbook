guard 'rspec', spec_paths: ['spec'] do
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb') { 'spec' }

  watch(%r{^recipes/(.+)\.rb$}) do |recipe|
    "spec/#{recipe[1]}_spec.rb"
  end
end
