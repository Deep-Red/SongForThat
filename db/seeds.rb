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

def seed_releases(start_line, finish_line)
  @start_line = start_line
  @finish_line = finish_line
  @line_count = 0
  @user = User.find_by(username: "RobotZero")
  @user ||= User.create(username: "RobotZero", password: "aaaaaaa", email: "fake@example.com")
  @songs = []
  #@failed_songs_file = File.open(Rails.root.join('log', 'failed_songs_file.txt'), "w")
  #@failed_tags_file = File.open(Rails.root.join('log', 'failed_tags_file.txt'), "w")
  #@failed_taggings_file = File.open(Rails.root.join('log', 'failed_taggings_file.txt'), "w")
  puts "Seeding lines #{@start_line} to #{@finish_line}."

  if Rails.env.production?
    song_release_data = "https://s3.amazonaws.com/asft/song_release_data.txt"
  else
    song_release_data = Rails.root.join('lib', 'seeds', 'song_release_data.txt')
  end
  @start_time = Time.now

  CSV.foreach(open(song_release_data), { :col_sep => "|", :quote_char => "\x00" }) do |line|
    linetype = @line_count % 5
    @line_count += 1
#    puts "Line _count #{@line_count}"
    if @line_count > @start_line && @line_count <= @finish_line

      case linetype
      when 0
        @release_titles = []
        @release_artist = nil
        @release_styles = []
        @release_genres = []
        @release_year = nil

        line.each { |title| @release_titles << title }
  #      puts "Titles"

      when 1
        @release_artist = line.join(", ")
  #      puts "Artists"

      when 2
        line.each { |genre| @release_styles << genre if genre }
  #      puts "genres"

      when 3
        line.each { |style| @release_styles << style if style }

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
          puts "New song: #{new_song.title}"
        end

        unless Rails.env.production?
          puts "Processed release ##{@line_count / 5} in #{Time.now - @start_time}" if @line_count % 500 == 0
        end
      else
        raise "line_count (#{@line_count}) % 5 not in 0..4"
      end
    end
  end

  puts "Processed releases #{(start_line + 5) / 5} through #{(finish_line + 5) / 5}!"
end

number_of_releases_to_seed = 1
number_of_lines_to_process = number_of_releases_to_seed * 5
number_of_cores_to_use = 2

startpoints = Array.new(number_of_cores_to_use + 1) { |index| index * number_of_lines_to_process}
puts startpoints.inspect

results = Parallel.map(0...number_of_cores_to_use) do |core|
    puts "Starting to seed section #{core}."
    seed_releases(startpoints[core], startpoints[core + 1])
end
