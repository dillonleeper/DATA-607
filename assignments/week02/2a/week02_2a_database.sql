-- Week 2A: SQL and R -- Movie Ratings
-- Dillon Leeper, DATA 607
-- ------------------------------------------------------------

-- Source data: Google Form responses
-- 7 respondents, collected 2026-09-10
-- Source spreadsheet URL omitted from the public repository.

-- Movie genre/runtime verified against Wikipedia (2026-09-13):
-- Everything Everywhere All at Once:
-- https://en.wikipedia.org/wiki/Everything_Everywhere_All_at_Once
--
-- The Batman:
-- https://en.wikipedia.org/wiki/The_Batman_(film)
--
-- Hereditary:
-- https://en.wikipedia.org/wiki/Hereditary_(film)
--
-- Obsession (2025):
-- https://en.wikipedia.org/wiki/Obsession_(2025_film)
--
-- The Odyssey (2026):
-- https://en.wikipedia.org/wiki/The_Odyssey_(2026_film)
--
-- Mean Girls (2024):
-- https://en.wikipedia.org/wiki/Mean_Girls_(2024_film)

-- "Haven't seen it" and blank/unanswered form responses
-- are stored as SQL NULL, never as 0.


-- ============================================================
-- Remove existing tables
-- ============================================================

-- ratings must be dropped first because it references
-- both users and movies through foreign keys.

DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS users;


-- ============================================================
-- Table definitions
-- ============================================================

CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);


CREATE TABLE movies (
    movie_id INTEGER PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    genre VARCHAR(50) NOT NULL,
    duration INTEGER NOT NULL,
    release_year INTEGER NOT NULL
);


CREATE TABLE ratings (
    rating_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    movie_id INTEGER NOT NULL REFERENCES movies(movie_id),
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    UNIQUE (user_id, movie_id)
);


-- ============================================================
-- Users
-- One row per respondent, in form submission order
-- ============================================================

INSERT INTO users (user_id, name) VALUES
    (1, 'Respondent 1'),
    (2, 'Respondent 2'),
    (3, 'Respondent 3'),
    (4, 'Respondent 4'),
    (5, 'Respondent 5'),
    (6, 'Respondent 6'),
    (7, 'Respondent 7');


-- ============================================================
-- Movies
-- Genre, runtime in minutes, and release year
-- ============================================================

INSERT INTO movies (
    movie_id,
    title,
    genre,
    duration,
    release_year
) VALUES
    (1, 'Everything Everywhere All at Once', 'Sci-Fi Comedy', 139, 2022),
    (2, 'The Batman', 'Action/Crime', 176, 2022),
    (3, 'Hereditary', 'Horror', 127, 2018),
    (4, 'Obsession', 'Horror', 109, 2025),
    (5, 'The Odyssey', 'Action/Fantasy', 172, 2026),
    (6, 'Mean Girls', 'Musical Comedy', 112, 2024);


-- ============================================================
-- Ratings
-- 42 person/movie combinations
-- 7 respondents x 6 movies
--
-- movie_id:
-- 1 = Everything Everywhere All at Once
-- 2 = The Batman
-- 3 = Hereditary
-- 4 = Obsession
-- 5 = The Odyssey
-- 6 = Mean Girls
--
-- NULL = respondent has not seen the movie or did not answer
-- ============================================================

INSERT INTO ratings (user_id, movie_id, rating) VALUES

    -- Respondent 1 (user_id 1)
    (1, 1, 4),
    (1, 2, 3),
    (1, 3, NULL),
    (1, 4, NULL),
    (1, 5, 5),
    (1, 6, NULL),

    -- Respondent 2 (user_id 2)
    (2, 1, 4),
    (2, 2, 3),
    (2, 3, NULL),
    (2, 4, NULL),
    (2, 5, NULL),
    (2, 6, 5),

    -- Respondent 3 (user_id 3)
    (3, 1, 2),
    (3, 2, 2),
    (3, 3, NULL),
    (3, 4, NULL),
    (3, 5, 4),
    (3, 6, 3),

    -- Respondent 4 (user_id 4)
    (4, 1, NULL),
    (4, 2, NULL),
    (4, 3, NULL),
    (4, 4, 5),
    (4, 5, 4),
    (4, 6, NULL),

    -- Respondent 5 (user_id 5)
    (5, 1, 5),
    (5, 2, NULL),
    (5, 3, 3),
    (5, 4, 5),
    (5, 5, NULL),
    (5, 6, 5),

    -- Respondent 6 (user_id 6)
    (6, 1, NULL),
    (6, 2, 4),
    (6, 3, NULL),
    (6, 4, NULL),
    (6, 5, 4),
    (6, 6, 3),

    -- Respondent 7 (user_id 7)
    (7, 1, 1),
    (7, 2, NULL),
    (7, 3, NULL),
    (7, 4, NULL),
    (7, 5, 4),
    (7, 6, 4);


-- ============================================================
-- Basic verification
-- ============================================================

-- Confirm expected row counts.
SELECT COUNT(*) AS user_count
FROM users;

SELECT COUNT(*) AS movie_count
FROM movies;

SELECT COUNT(*) AS rating_row_count
FROM ratings;


-- View the complete joined dataset.
SELECT
    u.user_id,
    u.name,
    m.movie_id,
    m.title,
    m.genre,
    m.duration,
    m.release_year,
    r.rating
FROM ratings AS r
JOIN users AS u
    ON r.user_id = u.user_id
JOIN movies AS m
    ON r.movie_id = m.movie_id
ORDER BY
    u.user_id,
    m.movie_id;