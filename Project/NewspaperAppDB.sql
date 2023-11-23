create database Newspaper;
use Newspaper;

CREATE TABLE Users (
  IDUser INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  email CHAR(100),
  full_name CHAR(100),
  date_of_birth DATE
);

CREATE TABLE Accounts (
  account_id INT AUTO_INCREMENT PRIMARY KEY,
  email CHAR(100) NOT NULL UNIQUE,
  IDUser INT,
  password_of_user CHAR(100) NOT NULL,
  status_account CHAR(30),
  CONSTRAINT fk_users FOREIGN KEY (IDUser) REFERENCES Users(IDUser)
);

DELIMITER //
CREATE TRIGGER tr_users_before_insert
BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
  DECLARE user_exists INT;
  
  SELECT COUNT(*) INTO user_exists
  FROM Users
  WHERE IDUser = NEW.IDUser;
  
  IF user_exists > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dữ liệu đã tồn tại.';
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER tr_accounts_before_insert
BEFORE INSERT ON Accounts
FOR EACH ROW
BEGIN
  DECLARE account_exists INT;
  
  SELECT COUNT(*) INTO account_exists
  FROM Accounts
  WHERE email = NEW.email;
  
  IF account_exists > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dữ liệu đã tồn tại.';
  END IF;
END;
//
DELIMITER ;

INSERT INTO Users (email, full_name)
VALUES
('vnexpress@gmail.com', 'EXPRESS VN'),
  ('linhnm@gmail.com', 'Nguyen Manh Linh'),
  ('hungnk@gmail.com', 'Nguyen Khac Hung'),
  ('minhvn@gmail.com', 'Vu Ngoc Minh'),
  ('duanvd@gmail.com', 'Vu Dinh Duan'),
  ('phuonggt@gmail.com', 'Giap Thi Phuong'),
  ('linhld@gmail.com', 'Le Dinh Linh'),
  ('hoangdt@gmail.com', 'Dinh Tien Hoang');
  
INSERT INTO Users (email, full_name)
VALUES
('linhmanhng@gmail.com', 'Nguyen Manh Linh');

INSERT INTO Accounts (email, IDUser, password_of_user, status_account)
VALUES
('vnexpress@gmail.com', (SELECT IDUser FROM Users WHERE email = 'vnexpress@gmail.com'), MD5('VNExpress0000'), 'active'),
  ('linhnm@gmail.com', (SELECT IDUser FROM Users WHERE email = 'linhnm@gmail.com'), MD5('123456'), 'active'),
  ('hungnk@gmail.com', (SELECT IDUser FROM Users WHERE email = 'hungnk@gmail.com'), MD5('123456'), 'active'),
  ('minhvn@gmail.com', (SELECT IDUser FROM Users WHERE email = 'minhvn@gmail.com'), MD5('123456'), 'active'),
  ('duanvd@gmail.com', (SELECT IDUser FROM Users WHERE email = 'duanvd@gmail.com'), MD5('123456'), 'active'),
  ('phuonggt@gmail.com', (SELECT IDUser FROM Users WHERE email = 'phuonggt@gmail.com'),MD5('123456'), 'active'),
  ('linhld@gmail.com', (SELECT IDUser FROM Users WHERE email = 'linhld@gmail.com'), MD5('123456'), 'active'),
  ('hoangdt@gmail.com', (SELECT IDUser FROM Users WHERE email = 'hoangdt@gmail.com'), MD5('123456'), 'active');
  
INSERT INTO Accounts (email, IDUser, password_of_user, status_account)
VALUES
('linhmanhng@gmail.com', (SELECT IDUser FROM Users WHERE email = 'linhmanhng@gmail.com'), MD5('123456'), 'ative');

SELECT *
FROM Users
INNER JOIN Accounts ON Users.email = Accounts.email;

CREATE TABLE Category (
IDCategory INT PRIMARY KEY,
nameCategory VARCHAR(100)
);

INSERT INTO Category VALUES 
(1, 'Mới nhất'),
(2, 'Thế giới'),
(3, 'Thể thao'),
(4, 'Khoa học'),
(5, 'Pháp luật'),
(6, 'Giải trí'),
(7, 'Du lịch');


CREATE TABLE Posts (
IDPosts INT auto_increment PRIMARY KEY,
IDUser INT,
IDCategory INT,
image VARCHAR(1000),
title VARCHAR(100),
link VARCHAR(1000),
pubDate VARCHAR(100),
content TEXT,
contentSnippet TEXT,
guid VARCHAR(1000),
isoDate varchar(100),
foreign key (IDUser) references Users(IDUser),
foreign key (IDCategory) references Category(IDCategory)
);

INSERT INTO Posts VALUES 
(1,1,1,'imgPost1.png','post1','','23/11/2023','abc','','','');


CREATE TABLE Comments(
IDComment INT PRIMARY KEY NOT NULL,
IDUser INT NOT NULL,
IDPost INT NOT NULL,
content TEXT NOT NULL,
pupdate VARCHAR(50) NOT NULL,
foreign key (IDUser) references Users(IDUser),
foreign key (IDPost) references Posts(IDPosts)
);


insert into Comments(IDComment, IDUser, IDPost, content, pupdate) values
(1, 1, 1, 'Làm việc với tỉnh Hậu Giang, Bộ trưởng Huỳnh Thành Đạt đề xuất các giải pháp để khoa học công nghệ 
trở thành động lực, tạo ra những giải pháp đột phá, thúc đẩy phát triển kinh tế.', '2023/07/20'),
(2, 2, 1, 'GS Nguyễn Cửu Khoa dùng công nghệ nano hóa dược chất trong thuốc y học cổ truyền, giúp tăng hiệu quả, 
giảm thời gian điều trị so với thuốc đông y truyền thống.', '2023/07/20'),
(3, 3, 1, 'Đại học quốc gia TP HCM ký hợp tác với tỉnh Hậu Giang nhằm đẩy mạnh hoạt động khoa học công nghệ, đổi mới sáng tạo,
 trong đó chú trọng đào tạo nhân lực.', '2023/07/20');


SELECT * FROM Posts;
SELECT * FROM Category;
SELECT * FROM Comments;
