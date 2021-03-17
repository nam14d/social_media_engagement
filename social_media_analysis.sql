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
    photo_id INT NOT NULL,
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
    photo_url VARCHAR(1000) NOT NULL,
    vader_score FLOAT(2) NOT NULL,
    vader_sentiment VARCHAR(8) NOT NULL
);

-- 5. Sentiment --
CREATE TABLE sentiment(
    sentiment_id INT IDENTITY(74000,1) PRIMARY KEY,
    sentiment_name VARCHAR(100) NOT NULL
);

--6. Photo_Sentiment -- 
CREATE TABLE photo_sentiment(
    photo_id INT NOT NULL,
    sentiment_id INT NOT NULL,
    PRIMARY KEY (photo_id, sentiment_id),
    CONSTRAINT photo_id FOREIGN KEY (photo_id) REFERENCES photo(photo_id),
    CONSTRAINT sentiment_id FOREIGN KEY (sentiment_id) REFERENCES sentiment(sentiment_id)
);

-- 7. Trends --
CREATE TABLE trends(
    trend_id INT IDENTITY(4300,1),
    trend_name VARCHAR(40)
);
-----------------------------------------------------------------------------------------------------
-- Temporary Helper Tables --

-- User_Profile Helper --
CREATE TABLE temp(
    temp_id INT IDENTITY(100, 1) PRIMARY KEY,
    profile_name VARCHAR(1000) NOT NULL,
    photo_url VARCHAR(1000) NOT NULL,
    post_date DATETIME NOT NULL,
    tweet_text VARCHAR(1000) NOT NULL,
    like_count INT NOT NULL,
    retweet_count INT NOT NULL
);

-- Post_Hashtag Helper --
CREATE TABLE temp(
    temp_id INT IDENTITY(100,1) PRIMARY KEY,
    tweet VARCHAR(1000) NOT NULL,
    hashtag VARCHAR(200) NOT NULL
);

CREATE TABLE temp(
    temp_id INT IDENTITY(100,1) PRIMARY KEY,
    photo_url VARCHAR(1000) NOT NULL,
    label VARCHAR(200) NOT NULL
);
----------------------------------------------------------------------------------------------------
-- Filling an Existing Table with values Brought Together by a Helper Table --

-- Filling post table with appropriate values
INSERT INTO dbo.post(profile_id, photo_id, post_date, tweet_text, like_count, retweet_count)
SELECT 
    p.profile_id,
    ph.photo_id,
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
JOIN 
    dbo.photo ph
ON
    ph.photo_url = t.photo_url;

-- Filling post_hashtag --
INSERT INTO dbo.post_hashtag(post_id, hashtag_id)
SELECT DISTINCT
    post_id,
    hashtag_id 
FROM 
    dbo.hashtag h 
JOIN 
    dbo.temp t 
ON 
    h.hashtag_text = t.hashtag 
JOIN 
    dbo.post p 
ON 
    p.tweet_text = t.tweet;

-- Photo - Sentiment -- 
INSERT INTO dbo.photo_sentiment(photo_id, sentiment_id)
SELECT DISTINCT
    p.photo_id,
    s.sentiment_id
FROM 
    dbo.photo p
JOIN 
    dbo.temp t
ON 
    p.photo_url = t.photo_url
JOIN 
    dbo.senitment s
ON 
    s.sentiment_name = t.label


-- Indices and Procedures/Functions --

 -- Nonclustered Index on profile_name
-- CREATE NONCLUSTERED INDEX IX_profile_name
-- ON dbo.user_profile(profile_name)
-- GO

 -- Nonclustered Index on hashtag_text
-- CREATE NONCLUSTERED INDEX IX_hashtag_text
-- ON dbo.hashtag(hashtag_text)
-- GO

 -- Procedures -- 

 -- Adding new values -- 

-- Adding a new post --
IF OBJECT_ID('dbo.insertPost','P') IS NOT NULL
    DROP PROCEDURE dbo.insertPost;
GO
--Create Procedure
-- Create insertPost -- 
CREATE PROCEDURE dbo.insertPost
    @profile_id INT, 
    @photo_id INT, 
    @post_date DATETIME, 
    @tweet_text VARCHAR(1000), 
    @like_count INT, 
    @retweet_count INT
AS
    BEGIN TRAN T1
        INSERT INTO [dbo].[post](profile_id, photo_id, post_date, tweet_text, like_count, retweet_count)
        VALUES(@profile_id, @photo_id, @post_date, @tweet_text, @like_count, @retweet_count)
    IF @@ERROR <> 0
        ROLLBACK TRAN T1
    ELSE
        COMMIT TRAN T1
GO
-- Create insertUser -- 
CREATE PROCEDURE dbo.insertUser
    @profile_name VARCHAR(1000), 
    @follower_count INT
AS
    BEGIN TRAN T1
        INSERT INTO [dbo].[user_profile](profile_name, follower_count)
        VALUES(@profile_name, @follower_count)
    IF @@ERROR <> 0
        ROLLBACK TRAN T1
    ELSE
        COMMIT TRAN T1
GO

-- Create insertUser -- 
CREATE PROCEDURE dbo.insertUser
    @profile_name VARCHAR(1000), 
    @follower_count INT
AS
    BEGIN TRAN T1
        INSERT INTO [dbo].[user_profile](profile_name, follower_count)
        VALUES(@profile_name, @follower_count)
    IF @@ERROR <> 0
        ROLLBACK TRAN T1
    ELSE
        COMMIT TRAN T1
GO

-- Create insertHashtag -- 
CREATE PROCEDURE dbo.insertHashtag
    @hashtag_text VARCHAR(200)
AS
    BEGIN TRAN T1
        INSERT INTO [dbo].[hashtag](hashtag_text)
        VALUES(@hashtag_text)
    IF @@ERROR <> 0
        ROLLBACK TRAN T1
    ELSE
        COMMIT TRAN T1
GO
-- Create insertPhoto --
CREATE PROCEDURE dbo.insertPhoto
    @photo_url VARCHAR(1000),
    @vader_score FLOAT(2),
    @vader_sentiment VARCHAR(8)
AS
    BEGIN TRAN T1
        INSERT INTO [dbo].[photo](photo_url, vader_score, vader_sentiment)
        VALUES(@photo_url, @vader_score, @vader_sentiment)
    IF @@ERROR <> 0
        ROLLBACK TRAN T1
    ELSE
        COMMIT TRAN T1
GO