# frozen_string_literal: true

seeds_path = Rails.root.join("db/seeds/*/*_seed.rb")

Dir[seeds_path].sort.each { |seed| load seed }
