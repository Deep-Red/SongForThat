# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



require 'csv'

def create_tagging(name, category)
    tag = Tag.find_or_create_by(name: "#{name}")
    tag.added_by ||= @user

    tagging = Tagging.find_or_create_by(tag: tag, song: @song, category: "#{category}")
    tagging.created_by ||= @user

    tag.save
    tagging.save

end

@line_count = 0
@user = User.find_by(username: "RobotZero")
@user ||= User.create(username: "RobotZero", password: "aaaaaaa", email: "fake@example.com")
@user2 = User.find_by(username: "RobotOne")
@user2 ||= User.create(username: "RobotOne", password: "bbbbbbb", email: "fake@example.com")
@song = nil

File.open(Rails.root.join('lib', 'seeds', 'out.txt')).each do |line|
  linetype = @line_count % 5
  @line_count += 1
  if @line_count > 0 #2797220 #2452705 1320910
    line_info = line.chomp.split("|")

    case linetype
    when 0
      @song = @user.songs.build
      @song.title = line_info[0]
    when 1
      @song.artist = line_info.join(", ")
      duplicate = Song.find_by(title: "#{@song.title}", artist: "#{@song.artist}")
      @song = duplicate if duplicate
    when 2
      line_info.each do |genre|
        create_tagging(genre, "genre")
      end
    when 3
      line_info.each do |style|
        create_tagging(style, "style")
      end
    when 4
      @song.year = line_info[0].to_i
      if @song.save
        puts "Created song ##{@line_count / 5}"
      else
        puts "Song #{@song} #{@song.title} has errors:"
        puts @song.errors.full_messages
      end
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
    s = @user2.songs.build
    s.artist = row['artist']
    s.title = row['title']
    s.save
    a = Song.find_by(title: row['title'], artist: row['artist'])
  end

  unless b
    t = @user2.tags.build
    t.name = row['tag']
    t.save
    b = Tag.find_by(name: row['tag'])
  end

  unless Tagging.find_by(song: a, tag: b, category: "content")
    conn = @user2.taggings.build
    conn.song = a
    conn.tag = b
    conn.category = "content"
    conn.save
  end

  puts "Processed line ##{@line_count}."
end

puts "Database seeded."
