namespace :models do
  desc "Updates model and fixture annotations with database fields"
  task :annotate do
    system 'annotate --delete'
    system 'annotate --position before --exclude tests'
  end
end