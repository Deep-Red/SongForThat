# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



require 'csv'
require 'open-uri'

def create_tag(name, user)
  tag = Tag.find_or_create_by(name: "#{name}")
  tag.added_by ||= user
  tag.save
  return tag
end

def create_tagging(tag, song, category, user)
  tagging = Tagging.find_or_create_by(tag: tag, song: song, category: "#{category}")
  tagging.created_by ||= user
  tagging.save
  return tagging
end

@line_count = 0
@user = User.find_by(username: "RobotZero")
@user ||= User.create(username: "RobotZero", password: "aaaaaaa", email: "fake@example.com")
@user2 = User.find_by(username: "RobotOne")
@user2 ||= User.create(username: "RobotOne", password: "bbbbbbb", email: "fake2@example.com")
@songs = []
@failed_songs_file = File.open(Rails.root.join('log', 'failed_songs_file.txt'), "w")
@failed_tags_file = File.open(Rails.root.join('log', 'failed_tags_file.txt'), "w")
@failed_taggings_file = File.open(Rails.root.join('log', 'failed_taggings_file.txt'), "w")


CSV.foreach(open("https://s3.amazonaws.com/asft/song_release_data.txt"), { :col_sep => "|", :quote_char => "\x00" }) do |line|
  linetype = @line_count % 5
  @line_count += 1
  if @line_count > 0 #103800 #2797220 #2452705 1320910
#    puts line.inspect
    line_info = line#.chomp.split("|")

    case linetype
    when 0
      puts "Line count: #{@line_count}"
      @songs = []
      line_info.each do |title|
        new_song = @user.songs.build
        new_song.title = title
        @songs << new_song
      end
    when 1
      @songs.map! do |song|
        song.artist = line_info.join(", ")
        song.save unless Song.find_by(title: "#{song.title}", artist: "#{song.artist}")
        Song.find_by(title: "#{song.title}", artist: "#{song.artist}")
      end
    when 2
      line_info.each do |genre|
        new_tag = create_tag(genre, @user)
        @songs.each do |song|
          create_tagging(new_tag, song, "genre", @user)
        end
      end
    when 3
      line_info.each do |style|
        new_tag = create_tag(style, @user)
        @songs.each do |song|
          create_tagging(new_tag, song, "style", @user)
        end
      end
    when 4
      @songs.each do |song|
        song.year = line_info[0][0..3].to_i if line_info && line_info[0] && line_info[0][0..3]
        unless song.save
          puts "Song #{song} #{song.title} has errors:"
          puts song.errors.full_messages
        end
      end
      puts "Processed release ##{@line_count / 5}" if @line_count % 50 == 0
    else
      raise "line_count (#{@line_count}) % 5 not in 0..4"
    end
  end
end

puts "out.txt processed!"



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

puts "Database seeded."
