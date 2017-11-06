require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'song-seeds.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

csv.each do |row|

  @line_count += 1

  a = Song.find_by(title: row['title'], artist: row['artist'])
  b = Tag.find_by(name: row['tag'])

  unless a
    @failed_songs_file.puts("#{row['title']} #{row['artist']}")
  end

  unless b
    t = @user2.tags.build
    t.name = row['tag']
    t.save ? b = Tag.find_by(name: row['tag']) : @failed_tags_file.puts("#{t} FAILED: #{t.errors.full_messages}")
  end

  unless Tagging.find_by(song: a, tag: b, category: "content")
    conn = @user2.taggings.build
    conn.song = a
    conn.tag = b
    conn.category = "content"
    conn.save || @failed_taggings_file.puts("#{conn} FAILED: #{conn.errors.full_messages}")
  end

  puts "Processed line ##{@line_count}."
end

puts "Processed song-seeds.csv!"
