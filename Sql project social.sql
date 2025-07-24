CREATE DATABASE SocialMediaAnalytics;
USE SocialMediaAnalytics;
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    user_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    user_id INT,
    comment TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


INSERT INTO Users (username, email) VALUES
('alice', 'alice@email.com'),
('bob', 'bob@email.com'),
('charlie', 'charlie@email.com');


INSERT INTO Posts (user_id, content) VALUES
(1, 'Hello World!'),
(2, 'My first post'),
(1, 'Happy to be here!');


INSERT INTO Likes (post_id, user_id) VALUES
(1, 2), (1, 3), (2, 1), (3, 2);


INSERT INTO Comments (post_id, user_id, comment) VALUES
(1, 2, 'Nice post!'),
(1, 3, 'Welcome!'),
(2, 1, 'Good luck!');

CREATE VIEW PostEngagement AS
SELECT 
    p.post_id,
    u.username,
    p.content,
    COUNT(DISTINCT l.like_id) AS like_count,
    COUNT(DISTINCT c.comment_id) AS comment_count
FROM Posts p
JOIN Users u ON p.user_id = u.user_id
LEFT JOIN Likes l ON p.post_id = l.post_id
LEFT JOIN Comments c ON p.post_id = c.post_id
GROUP BY p.post_id;

SELECT * FROM PostEngagement ORDER BY like_count DESC;

SELECT *,
       RANK() OVER (ORDER BY (like_count + comment_count) DESC) AS ranks
FROM PostEngagement;

DELIMITER //
CREATE TRIGGER update_like_count
AFTER INSERT ON Likes
FOR EACH ROW
BEGIN
    UPDATE Posts
    SET total_likes = total_likes + 1
    WHERE post_id = NEW.post_id;
END;
//
DELIMITER ;





