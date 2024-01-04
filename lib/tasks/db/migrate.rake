# frozen_string_literal: true

SCHEMA_PATH = 'db/schema.rb'

namespace :db do
  def lint
    content = File.read(SCHEMA_PATH)

    File.open(SCHEMA_PATH, 'w') do |file|
      file.puts('# frozen_string_literal: true')
      file.puts(content)
    end

    sh 'rubocop -a db/schema.rb'
  end

  desc 'Runs rubocop on db/schema.rb after migration'
  task migrate: :environment do
    lint
  end

  desc 'Runs rubocop on db/schema.rb after rollback'
  task rollback: :environment do
    lint
  end
end
