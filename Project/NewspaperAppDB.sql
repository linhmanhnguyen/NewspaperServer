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
    ID INT AUTO_INCREMENT PRIMARY KEY,
	avatar VARCHAR(1000),
	title VARCHAR(100),
    content TEXT,
    category VARCHAR(100)
);

insert into posts (avatar, title, content, category) values
('https://static-images.vnncdn.net/files/publish/2023/7/18/anh-chup-man-hinh-2023-07-18-luc-190940-1300.png', 'Bão số 1 suy yếu thành áp thấp nhiệt đới, miền Bắc mưa to', 'Chiều nay (18/7), sau khi đi sâu vào đất liền khu vực phía Nam tỉnh Quảng Tây (Trung Quốc) bão số 1 đã suy yếu thành áp thấp nhiệt đới. Khu vực Đông Bắc, Việt Bắc có mưa to đến rất to.
Theo cập nhật từ Trung tâm Dự báo Khí tượng Thủy văn Quốc gia, hồi 16h, vị trí tâm áp thấp nhiệt đới ở vào khoảng 22,3 độ Vĩ Bắc; 107,0 độ Kinh Đông, trên đất liền khu vực phía Tây Nam tỉnh Quảng Tây (Trung Quốc). Sức gió mạnh nhất vùng gần tâm áp thấp nhiệt đới mạnh cấp 6 (39-49km/giờ), giật cấp 8.', 'Tin tức'),
('https://media1.nguoiduatin.vn/thumb_x992x595/media/nguyen-thu-huyen/2023/07/18/nha-may-thuy-dien-song-ba.jpg', 'Thuỷ điện Sông Ba “khát nước”, báo lãi quý II/2023 giảm sâu', 'Lượng nước về hồ thuỷ điện trong quý II/2023 giảm mạnh kéo theo sản lượng điện phát sụt giảm, dẫn đến kết quả kinh doanh của Sông Ba không mấy khả quan.', 'Tin tức'),
('https://media1.nguoiduatin.vn/media/le-manh-quoc/2023/07/18/chu-xuan-dung-8.jpg', 'Cựu Phó Chủ tịch UBND Tp.Hà Nội xin được "rộng lượng, khoan hồng"', 'Ông Dũng cho biết mình có 26 năm làm công tác giảng dạy và quản lý về giáo dục trước khi được bầu trở thành Phó Chủ tịch UBND Tp.Hà Nội vào tháng 12/2020. Ngay khi được bổ nhiệm, ông Dũng được phân công làm Trưởng ban sau đó là Phó Ban Chỉ đạo phòng chống dịch bệnh Covid-19 của Thủ đô.', 'Tin tức'),
('https://media1.nguoiduatin.vn/thumb_x992x595/media/nguyen-thanh-xuan/2023/07/13/02-bi-can-tuan-va-hoang.jpg', 'Mang súng đi đòi nợ thuê 2 người đàn ông lãnh án', 'Theo kết luận giám định của Phân viện Khoa học hình sự Bộ Công an, 2 khẩu súng của Hoàng và Tuấn là vũ khí quân dụng.
Ngày 13/7, Tòa án nhân dân tỉnh Kiên Giang đã mở phiên xét xử vụ án hình sự sơ thẩm đối với 2 bị cáo là Lê Văn Tuấn (SN 1988), ngụ huyện Mỏ Cày Nam, tỉnh Bến Tre và Vũ Đức Hoàng (SN 1975), ngụ Tp.Thủ Đức, Tp.Hồ Chí Minh về tội tàng trữ trái phép vũ khí quân dụng.', 'Tin tức'),
('https://media1.nguoiduatin.vn/media/nguyen-huu-thang/2023/07/18/nguyen-duy-ngoc00.jpeg', 'Đảm bảo dữ liệu dân cư “đúng, đủ, sạch, sống”', 'UBND Tp.Hà Nội vừa tổ chức hội nghị trực tuyến sơ kết 6 tháng đầu năm 2023 về cải cách hành chính, chuyển đổi số và Đề án 06 của Chính phủ trên địa bàn Thành phố.
Tại hội nghị, các đơn vị của Hà Nội đã tham luận về những giá trị, cách làm mới trong chuyển đổi số, cải cách hành chính, thực hiện Đề án 06 của Chính phủ.', 'Tin tức'),

('https://photo-baomoi.bmcdn.me/w700_r1/2023_07_18_101_46393342/17f539209c6d75332c7c.jpg', 'World Cup 2023: Đội bóng Đức đề nghị thời gian đàm phán với tuyển thủ Việt Nam', 'Cách đây ít ngày, đội bóng chủ quản của tiền vệ Thanh Nhã là CLB Hà Nội I vừa chia sẻ rằng họ chưa nhận được lời đề nghị chính thức nào từ châu Âu. Tuy nhiên, những nguồn tin mới nhất cho biết một CLB tại Đức đã bày tỏ sự quan tâm đến chân sút 21 tuổi.', 'Thể thao'),
('https://media1.nguoiduatin.vn/thumb_x992x595/media/nguyen-thu-huyen/2023/07/18/nha-may-thuy-dien-song-ba.jpg', 'Bất ngờ trước cơ hội vượt qua vòng bảng World Cup của tuyển nữ Việt Nam', 'Theo lịch, đội tuyển nữ Việt Nam sẽ đá trận ra quân gặp Mỹ vào lúc 8h ngày 22/7.

Ở trận đấu này, siêu máy tính dự đoán Huỳnh Như cùng đồng đội có 1,23% thắng và 3,03% hòa trước nhà đương kim vô địch giải đấu.

Sau cuộc đọ sức với Mỹ, các cô gái áo đỏ sẽ lần lượt chạm trán Bồ Đào Nha (27/7) và Hà Lan (1/8).', 'Thể thao'),
('https://static-images.vnncdn.net/files/publish/2023/7/18/mbappe-psg-870.jpg', 'Tương lai Mbappe: Khi PSG cảm thấy bị phản bội', 'Tương lai của Mbappe là một câu hỏi lớn. PSG cảm thấy bị phản bội và không muốn để đội trưởng đội tuyển Pháp ra đi tự do vào năm sau.
Chủ tịch của Paris Saint-Germain, Nasser Al-Khelaifi, gặp người đồng cấp Daniel Levy của Tottenham vài ngày trước và nhận xét họ có chung một tình huống bị tổn hại: ngôi sao lớn nhất của hai CLB bước vào năm cuối hợp đồng mà không gia hạn.', 'Thể thao'),
('https://static-images.vnncdn.net/files/publish/2023/7/18/hakim-ziyech-1107.jpg', 'Pochettino loại thẳng tay 4 ông kễnh ăn bám Chelsea', 'Mbappe trở lại luyện tập vào thứ Hai, trước khi PSG có chuyến du đấu hè.

Chủ tịch PSG, Al-Khelaifi trước đó đã ra tối hậu thư cho Mbappe: hoặc gia hạn hợp đồng trước khi tháng 7 khép lại, hoặc anh sẽ được bán ngay hè này.

PSG khẳng định sẽ không có chuyện để Mbappe tự do rời Paris vào năm sau. Trường hợp tiền đạo này vẫn từ chối kích hoạt mở rộng hợp đồng đến hè 2025, nhà vô địch Ligue 1 sẽ làm mọi cách để ép anh ra đi.', 'Thể thao'),
('https://static-images.vnncdn.net/files/publish/2023/7/17/leon-goretzka-1-1304.jpg', 'MU lấy hàng thải Bayern Munich, Mbappe chấp cả PSG', 'Tờ Mail cho hay, nhà vô địch Bundesliga muốn 34 triệu bảng cho tuyển thủ Đức, khi họ đang tìm cách huy động nguồn tài chính để ký Harry Kane từ Tottenham.

Leon Goretzka không có trong kế hoạch mùa tới của HLV Thomas Tuchel ở Allianz Arena. Do vậy, ông muốn bán anh để mua sắm mới.', 'Thể thao'),

('https://static-images.vnncdn.net/files/publish/2023/7/18/anh-chup-man-hinh-2023-07-18-luc-190940-1300.png', 'Bão số 1 suy yếu thành áp thấp nhiệt đới, miền Bắc mưa to', 'Chiều nay (18/7), sau khi đi sâu vào đất liền khu vực phía Nam tỉnh Quảng Tây (Trung Quốc) bão số 1 đã suy yếu thành áp thấp nhiệt đới. Khu vực Đông Bắc, Việt Bắc có mưa to đến rất to.
Theo cập nhật từ Trung tâm Dự báo Khí tượng Thủy văn Quốc gia, hồi 16h, vị trí tâm áp thấp nhiệt đới ở vào khoảng 22,3 độ Vĩ Bắc; 107,0 độ Kinh Đông, trên đất liền khu vực phía Tây Nam tỉnh Quảng Tây (Trung Quốc). Sức gió mạnh nhất vùng gần tâm áp thấp nhiệt đới mạnh cấp 6 (39-49km/giờ), giật cấp 8.', 'Văn hoá'),
('https://media1.nguoiduatin.vn/thumb_x992x595/media/nguyen-thu-huyen/2023/07/18/nha-may-thuy-dien-song-ba.jpg', 'Thuỷ điện Sông Ba “khát nước”, báo lãi quý II/2023 giảm sâu', 'Lượng nước về hồ thuỷ điện trong quý II/2023 giảm mạnh kéo theo sản lượng điện phát sụt giảm, dẫn đến kết quả kinh doanh của Sông Ba không mấy khả quan.', 'Văn hoá'),
('https://media1.nguoiduatin.vn/media/le-manh-quoc/2023/07/18/chu-xuan-dung-8.jpg', 'Cựu Phó Chủ tịch UBND Tp.Hà Nội xin được "rộng lượng, khoan hồng"', 'Ông Dũng cho biết mình có 26 năm làm công tác giảng dạy và quản lý về giáo dục trước khi được bầu trở thành Phó Chủ tịch UBND Tp.Hà Nội vào tháng 12/2020. Ngay khi được bổ nhiệm, ông Dũng được phân công làm Trưởng ban sau đó là Phó Ban Chỉ đạo phòng chống dịch bệnh Covid-19 của Thủ đô.', 'Văn hoá'),
('https://media1.nguoiduatin.vn/thumb_x992x595/media/nguyen-thanh-xuan/2023/07/13/02-bi-can-tuan-va-hoang.jpg', 'Mang súng đi đòi nợ thuê 2 người đàn ông lãnh án', 'Theo kết luận giám định của Phân viện Khoa học hình sự Bộ Công an, 2 khẩu súng của Hoàng và Tuấn là vũ khí quân dụng.
Ngày 13/7, Tòa án nhân dân tỉnh Kiên Giang đã mở phiên xét xử vụ án hình sự sơ thẩm đối với 2 bị cáo là Lê Văn Tuấn (SN 1988), ngụ huyện Mỏ Cày Nam, tỉnh Bến Tre và Vũ Đức Hoàng (SN 1975), ngụ Tp.Thủ Đức, Tp.Hồ Chí Minh về tội tàng trữ trái phép vũ khí quân dụng.', 'Văn hoá'),
('https://media1.nguoiduatin.vn/media/nguyen-huu-thang/2023/07/18/nguyen-duy-ngoc00.jpeg', 'Đảm bảo dữ liệu dân cư “đúng, đủ, sạch, sống”', 'UBND Tp.Hà Nội vừa tổ chức hội nghị trực tuyến sơ kết 6 tháng đầu năm 2023 về cải cách hành chính, chuyển đổi số và Đề án 06 của Chính phủ trên địa bàn Thành phố.
Tại hội nghị, các đơn vị của Hà Nội đã tham luận về những giá trị, cách làm mới trong chuyển đổi số, cải cách hành chính, thực hiện Đề án 06 của Chính phủ.', 'Văn hoá'),

('https://static-images.vnncdn.net/files/publish/2023/7/18/anh-chup-man-hinh-2023-07-18-luc-190940-1300.png', 'Bão số 1 suy yếu thành áp thấp nhiệt đới, miền Bắc mưa to', 'Chiều nay (18/7), sau khi đi sâu vào đất liền khu vực phía Nam tỉnh Quảng Tây (Trung Quốc) bão số 1 đã suy yếu thành áp thấp nhiệt đới. Khu vực Đông Bắc, Việt Bắc có mưa to đến rất to.
Theo cập nhật từ Trung tâm Dự báo Khí tượng Thủy văn Quốc gia, hồi 16h, vị trí tâm áp thấp nhiệt đới ở vào khoảng 22,3 độ Vĩ Bắc; 107,0 độ Kinh Đông, trên đất liền khu vực phía Tây Nam tỉnh Quảng Tây (Trung Quốc). Sức gió mạnh nhất vùng gần tâm áp thấp nhiệt đới mạnh cấp 6 (39-49km/giờ), giật cấp 8.', 'Du lịch'),
('https://media1.nguoiduatin.vn/thumb_x992x595/media/nguyen-thu-huyen/2023/07/18/nha-may-thuy-dien-song-ba.jpg', 'Thuỷ điện Sông Ba “khát nước”, báo lãi quý II/2023 giảm sâu', 'Lượng nước về hồ thuỷ điện trong quý II/2023 giảm mạnh kéo theo sản lượng điện phát sụt giảm, dẫn đến kết quả kinh doanh của Sông Ba không mấy khả quan.', 'Du lịch'),
('https://media1.nguoiduatin.vn/media/le-manh-quoc/2023/07/18/chu-xuan-dung-8.jpg', 'Cựu Phó Chủ tịch UBND Tp.Hà Nội xin được "rộng lượng, khoan hồng"', 'Ông Dũng cho biết mình có 26 năm làm công tác giảng dạy và quản lý về giáo dục trước khi được bầu trở thành Phó Chủ tịch UBND Tp.Hà Nội vào tháng 12/2020. Ngay khi được bổ nhiệm, ông Dũng được phân công làm Trưởng ban sau đó là Phó Ban Chỉ đạo phòng chống dịch bệnh Covid-19 của Thủ đô.', 'Du lịch'),
('https://media1.nguoiduatin.vn/thumb_x992x595/media/nguyen-thanh-xuan/2023/07/13/02-bi-can-tuan-va-hoang.jpg', 'Mang súng đi đòi nợ thuê 2 người đàn ông lãnh án', 'Theo kết luận giám định của Phân viện Khoa học hình sự Bộ Công an, 2 khẩu súng của Hoàng và Tuấn là vũ khí quân dụng.
Ngày 13/7, Tòa án nhân dân tỉnh Kiên Giang đã mở phiên xét xử vụ án hình sự sơ thẩm đối với 2 bị cáo là Lê Văn Tuấn (SN 1988), ngụ huyện Mỏ Cày Nam, tỉnh Bến Tre và Vũ Đức Hoàng (SN 1975), ngụ Tp.Thủ Đức, Tp.Hồ Chí Minh về tội tàng trữ trái phép vũ khí quân dụng.', 'Du lịch'),
('https://media1.nguoiduatin.vn/media/nguyen-huu-thang/2023/07/18/nguyen-duy-ngoc00.jpeg', 'Đảm bảo dữ liệu dân cư “đúng, đủ, sạch, sống”', 'UBND Tp.Hà Nội vừa tổ chức hội nghị trực tuyến sơ kết 6 tháng đầu năm 2023 về cải cách hành chính, chuyển đổi số và Đề án 06 của Chính phủ trên địa bàn Thành phố.
Tại hội nghị, các đơn vị của Hà Nội đã tham luận về những giá trị, cách làm mới trong chuyển đổi số, cải cách hành chính, thực hiện Đề án 06 của Chính phủ.', 'Du lịch');


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
