INSERT INTO songs (title, mb_recording, mb_work, artist, mb_artist_credit, created_at, updated_at, added_by_id)
SELECT DISTINCT ON (title, artist) a.*
FROM dblink('dbname=musicbrainz_db', 'SELECT DISTINCT ON(musicbrainz.artist_credit.id, musicbrainz.recording.id) musicbrainz.recording.name, musicbrainz.recording.id, musicbrainz.work.id, musicbrainz.artist_credit.name, musicbrainz.artist_credit.id,
current_timestamp, current_timestamp, 1
FROM musicbrainz.recording
INNER JOIN musicbrainz.artist_credit ON (musicbrainz.recording.artist_credit = musicbrainz.artist_credit.id)
INNER JOIN musicbrainz.l_recording_work ON (musicbrainz.recording.id = musicbrainz.l_recording_work.entity0)
INNER JOIN musicbrainz.work ON (musicbrainz.l_recording_work.entity1 = musicbrainz.work.id)
;') AS a(title citext, recording_id integer, work_id integer, artist citext, artist_id integer, created_at timestamp, updated_at timestamp, added_by_id bigint);




INSERT INTO songs (title, mb_recording, mb_work, artist, mb_artist_credit, created_at, updated_at, added_by_id)
SELECT DISTINCT ON (title, artist) a.*
FROM dblink('dbname=musicbrainz_db', 'SELECT DISTINCT ON(musicbrainz.artist_credit.id, musicbrainz.recording.id) musicbrainz.recording.name, musicbrainz.recording.id, musicbrainz.work.id, musicbrainz.artist_credit.name, musicbrainz.artist_credit.id,
current_timestamp, current_timestamp, 1
FROM musicbrainz.recording
INNER JOIN musicbrainz.artist_credit ON (musicbrainz.recording.artist_credit = musicbrainz.artist_credit.id)
LEFT JOIN musicbrainz.l_recording_work ON (musicbrainz.recording.id = musicbrainz.l_recording_work.entity0)
LEFT JOIN musicbrainz.work ON (musicbrainz.l_recording_work.entity1 = musicbrainz.work.id)
;') AS a(title citext, recording_id integer, work_id integer, artist citext, artist_id integer, created_at timestamp, updated_at timestamp, added_by_id bigint)
ON CONFLICT DO NOTHING;
