-- -1: Create Database --
--CREATE DATABASE Team1;

-- 0: Profile --
CREATE TABLE user_profile (
    profile_id INT IDENTITY(25000, 1) PRIMARY KEY,
    profile_name VARCHAR(1000) NOT NULL,
    follower_count INT NOT NULL
);

-- 1: Post -- 
CREATE TABLE post(
    post_id INT IDENTITY(30000,1) PRIMARY KEY,
    profile_id INT NOT NULL,
    post_date DATETIME NOT NULL,
    tweet_text VARCHAR(1000) NOT NULL,
    like_count INT NOT NULL,
    retweet_count INT NOT NULL,
    CONSTRAINT profiles FOREIGN KEY (profile_id) REFERENCES user_profile(profile_id)
);

-- 2. Hashtag --
CREATE TABLE hashtag(
    hashtag_id INT IDENTITY(53000,1) PRIMARY KEY,
    hashtag_text VARCHAR(200) NOT NULL
);

-- 3. Post_Hashtag --
CREATE TABLE post_hashtag(
    post_id INT NOT NULL,
    hashtag_id INT NOT NULL,
    PRIMARY KEY (post_id, hashtag_id),
    CONSTRAINT post_id FOREIGN KEY (post_id) REFERENCES post(post_id),
    CONSTRAINT hashtag_id FOREIGN KEY (hashtag_id) REFERENCES hashtag(hashtag_id)
);

--4. Photo -- 
CREATE TABLE photo(
    photo_id INT IDENTITY(64000,1) PRIMARY KEY,
    photo_url VARCHAR(1000)
);

-- 5. Photo_Post -- 
CREATE TABLE photo_post(
    photo_id INT NOT NULL,
    post_id INT NOT NULL,
    PRIMARY KEY (photo_id, post_id),
    CONSTRAINT photo_id FOREIGN KEY (photo_id) REFERENCES photo(photo_id),
    CONSTRAINT post_id FOREIGN KEY (post_id) REFERENCES post(post_id)
);

-- 6. Sentiment --
CREATE TABLE sentiment(
    sentiment_id INT IDENTITY(74000,1) PRIMARY KEY,
    sentiment_name VARCHAR(100)
);

--7. Photo_Sentiment -- 
CREATE TABLE photo_sentiment(
    photo_id INT NOT NULL,
    sentiment_id INT NOT NULL,
    PRIMARY KEY (photo_id, sentiment_id),
    CONSTRAINT photo_id FOREIGN KEY (photo_id) REFERENCES photo(photo_id),
    CONSTRAINT sentiment_id FOREIGN KEY (sentiment_id) REFERENCES sentiment(sentiment_id)
);

-- 8. Trends --
CREATE TABLE trends(
    trend_id INT IDENTITY(4300,1),
    trend_name VARCHAR(40)
)
-----------------------------------------------------------------------------------------------------
-- Temporary Helper Tables --

-- User_Profile Helper --
CREATE TABLE temp(
    temp_id INT IDENTITY(100, 1) PRIMARY KEY,
    profile_name VARCHAR(100) NOT NULL,
    post_date DATETIME NOT NULL,
    tweet_text VARCHAR(1000) NOT NULL,
    like_count INT NOT NULL,
    retweet_count INT NOT NULL
)

-- Post_Profile Helper --
CREATE TABLE temp(
    temp_id INT IDENTITY(100,1) PRIMARY KEY,
    tweet VARCHAR(1000) NOT NULL,
    hashtag VARCHAR(200) NOT NULL
)

-- Photo_Post Helper --
CREATE TABLE temp(
    temp_id INT IDENTITY(100,1) PRIMARY KEY,
    tweet VARCHAR(1000) NOT NULL,
    photo_url VARCHAR(1000) NOT NULL
)
----------------------------------------------------------------------------------------------------
-- Filling an Existing Table with values Brought Together by a Helper Table --

-- Filling post table with appropriate values
INSERT INTO dbo.post(profile_id, post_date, tweet_text, like_count, retweet_count)
SELECT 
    p.profile_id, 
    post_date, 
    tweet_text, 
    like_count, 
    retweet_count 
FROM 
    dbo.temp t 
JOIN 
    dbo.user_profile p
ON 
    t.profile_name = p.profile_name

-- Filling post_hashtag --
INSERT INTO dbo.post_hashtag(post_id, hashtag_id)
SELECT DISTINCT
    post_id,hashtag_id 
FROM 
    dbo.hashtag h 
JOIN 
    dbo.temp t 
ON 
    h.hashtag_text = t.hashtag 
JOIN 
    dbo.post p 
ON 
    p.tweet_text = t.tweet

-- Filling Photo_Post --
INSERT INTO dbo.photo_post(photo_id, post_id)
SELECT 
    photo_id,post_id
FROM 
    dbo.photo p 
JOIN 
    dbo.temp t 
ON 
    p.photo_url = t.photo_url 
JOIN 
    dbo.post post 
ON 
    post.tweet_text = t.tweet