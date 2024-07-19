-- 1. User Authentication
SELECT * FROM user_ WHERE username = %s AND password = %s;

-- 2. Search movie:
SELECT movie.*, STRING_AGG(DISTINCT actor.name, ', ') AS actors, 
	STRING_AGG(DISTINCT genre.genre_name, ', ') AS genres, language.language_name AS language,
	STRING_AGG(DISTINCT review.review, ' | ') AS reviews FROM movie LEFT JOIN casting ON movie.movie_id = casting.movie_id 
	LEFT JOIN actor ON casting.actor_id = actor.actor_id LEFT JOIN movie_genre ON movie.movie_id = movie_genre.movie_id 
	LEFT JOIN genre ON movie_genre.genre_id = genre.genre_id LEFT JOIN movie_language ON movie.movie_id = movie_language.movie_id 
	LEFT JOIN language ON movie_language.language_id = language.language_id LEFT JOIN review ON movie.movie_id = review.movie_id 
	WHERE LOWER(movie.title) LIKE %s GROUP BY movie.movie_id, language.language_name;

-- 3. Add movie
INSERT INTO movie (movie_id, title, description, release_year, rating, rank, language) VALUES (%s, %s, %s, %s, %s, %s, %s);

-- 4. Update movie
UPDATE movie SET {column} = %s WHERE movie_id = %s;

-- 5. Add review
INSERT INTO review (review_id, user_id, movie_id, rating, review) VALUES (%s, %s, %s, %s, %s);

-- 6. Change user's password
UPDATE user_ SET password = %s WHERE username = %s;

-- 7. Top 10 highest movie ratings
SELECT m.movie_id, m.title,.release_year,(r.rating) AS average_rating, STRING_AGG(DISTINCT g.genre_name, ', ') 
	AS genres FROM movie m LEFT JOIN review r ON m.movie_id = r.movie_id LEFT JOIN movie_genre mg 
	ON m.movie_id = mg.movie_id LEFT JOIN genre g ON mg.genre_id = g.genre_id 
	GROUP BY m.movie_id, m.title, m.release_year HAVING AVG(r.rating) IS NOT NULL 
	ORDER BY average_rating DESC LIMIT 10;

-- 8. User profile
SELECT username, email, password FROM user_ WHERE username = %s
