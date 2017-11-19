require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'song-seeds.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
u = User.find_by(username: "RZ")
line_count = 0
failed_taggings_file = File.open(Rails.root.join('log', 'failed_taggings_file.txt'), "w")
csv.each do |row|

  line_count += 1

  a = Song.find_by(title: row['title'], artist: row['artist'])
  b = Tag.find_by(name: row['tag'])

  if a
    unless b
      t = u.tags.build
      t.name = row['tag'].downcase
      t.save ? b = Tag.find_by(name: row['tag']) : puts("#{t} FAILED: #{t.errors.full_messages}")
    end

    unless Tagging.find_by(song: a, tag: b, category: "tag")
      conn = u.taggings.build
      conn.song = a
      conn.tag = b
      conn.category = "tag"
      conn.save || puts("#{conn} FAILED: #{conn.errors.full_messages}")
    end

  else
    failed_taggings_file.puts("#{row['tag']} | #{row['title']} | #{row['artist']} | Failed")
  end

  puts "Processed line ##{line_count}."
end

puts "Database seeded."
