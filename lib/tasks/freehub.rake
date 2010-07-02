namespace :models do
  desc "Updates model annotations with database fields"
  task :annotate do
    system 'annotate --delete'
    system 'annotate --position before --exclude tests'
  end
end