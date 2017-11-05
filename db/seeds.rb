require 'csv'
require 'open-uri'

def create_song(title, artist, year)
  song = Song.find_or_create_by(title: "#{title}", artist: "#{artist}")
  song.added_by ||= @user
  song.year ||= year
  song.save
  return song
end

def create_tag(name)
  tag = Tag.find_or_create_by(name: "#{name}")
  tag.added_by ||= @user
  tag.save
  return tag
end

def create_tagging(tag_name, song, category)
  tag = Tag.find_by(name: "#{tag_name}")
  tagging = Tagging.find_or_create_by(tag: tag, song: song, category: "#{category}")
  tagging.created_by ||= @user
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


if Rails.env.production?
  song_release_data = "https://s3.amazonaws.com/asft/song_release_data.txt"
else
  song_release_data = Rails.root.join('lib', 'seeds', 'song_release_data.txt')
end
@start_time = Time.now

CSV.foreach(open(song_release_data), { :col_sep => "|", :quote_char => "\x00" }) do |line|
  linetype = @line_count % 5
  @line_count += 1
  if @line_count > 0

    case linetype
    when 0
      @release_titles = []
      @release_artist = nil
      @release_styles = []
      @release_genres = []
      @release_year = nil

      line.each { |title| @release_titles << title }

    when 1
      @release_artist = line.join(", ")

    when 2
      line.each { |genre| @release_styles << genre }

    when 3
      line.each { |style| @release_styles << style }

    when 4
      @release_year = line[0][0..3].to_i if line && line[0] && line[0][0..3]

      @release_styles.each do |style|
        create_tag(style)
      end

      @release_titles.each do |title|
        new_song = create_song(title, @release_artist, @release_year)

        @release_styles.each do |style|
          create_tagging(style, new_song, "style")
        end

      end

      unless Rails.env.production?
        puts "Processed release ##{@line_count / 5} in #{Time.now - @start_time}" if @line_count % 500 == 0
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
