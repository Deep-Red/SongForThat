# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'musicthemetime-first-pass.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

u = User.find_by(username: "mtt" )
csv.each do |row|

  a = Song.find_by(title: row['title'], artist: row['artist'])
  b = Tag.find_by(name: row['theme'])

  unless a
    s = u.songs.build
    s.artist = row['artist']
    s.title = row['title']
    s.save
    a = Song.find_by(title: row['title'], artist: row['artist'])
  end

  unless b
    t = u.tags.build
    t.name = row['theme']
    t.save
    b = Tag.find_by(name: row['theme'])
  end


  unless Tagging.find_by(song: a, tag: b)
    conn = u.taggings.build
    conn.song = a
    conn.tag = b
    conn.save
  end
end
