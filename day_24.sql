/*
	Find the most popular song with the most plays and least skips, in that order.
	A skip is when the song hasn't been played the whole way through.
	Submit the song name.
*/

select
	songs.song_title,
	count(case when (songs.song_duration - user_plays.duration = 0) then 1 end) as full_play,
	count(case when (songs.song_duration - user_plays.duration > 0) then 1 end) as skipped
from songs
join user_plays 
	on user_plays.song_id = songs.song_id
group by songs.song_title
order by full_play desc, skipped 

