# Temporary debugging - remove after fixing connection issue
puts "=" * 60
puts "DATABASE DEBUG INFO"
puts "=" * 60
puts "RAILS_ENV: #{ENV['RAILS_ENV'].inspect}"
puts "DATABASE_URL set: #{!ENV['DATABASE_URL'].to_s.empty?}"
if ENV['DATABASE_URL']
  # Show URL with password redacted
  url = ENV['DATABASE_URL'].gsub(/:[^:@]+@/, ':***@')
  puts "DATABASE_URL: #{url}"
end
puts "DATABASE_HOST: #{ENV['DATABASE_HOST'].inspect}"
puts "All DB-related env vars:"
ENV.each do |k, v|
  if k =~ /DB|DATABASE|MYSQL/i
    val = k =~ /PASS|URL/i ? '[REDACTED]' : v
    puts "  #{k}: #{val}"
  end
end
puts "=" * 60
