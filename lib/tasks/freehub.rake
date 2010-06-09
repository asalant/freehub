namespace :models do
  desc "Updates model annotations with database fields"
  task :annotate do
    system 'annotate --position before --exclude tests,fixtures'
  end
end