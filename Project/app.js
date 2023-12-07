const express = require('express');
const app = express();
const port = 3300;
const db = require('./connect');

const nodemailer = require('nodemailer');
const passport = require('passport');

var bodyParser = require('body-parser');

var md5 = require('md5');

app.use(bodyParser.json())

// Accounts
// Đăng nhập
app.post('/accounts/login', (req, res) => {
    
    const { email, password_of_user } = req.body;
  
    db.query('SELECT * FROM Accounts WHERE email = ? AND password_of_user = ?', [email, md5(password_of_user)], (error, results) => {
      if (error) {
        console.error('Lỗi truy vấn:', error);
        res.status(500).send('Lỗi server');
      } else if (results.length === 0) {
        res.status(401).send('Tên đăng nhập hoặc mật khẩu không chính xác');
      } else {
        res.json(results[0]);
        console.log('Đăng nhập thành công');
      }
    });
});

//Đăng ký
app.post('/accounts/register', (req, res) => {
  const { email, password_of_user, full_name, date_of_birth } = req.body;

  const account = {
      email: email,
      password_of_user: password_of_user,
      status_account: null 
  };

  db.query('INSERT INTO Accounts SET ?', account, (error, accountResult) => {
      if (error) {
          console.error('Lỗi truy vấn Accounts:', error);
          res.status(500).send('Lỗi server');
      } else {
          const accountID = accountResult.insertId; 

          const user = {
              email: email,
              full_name: full_name,
              date_of_birth: date_of_birth,
              IDUser: accountID 
          };
          db.query('INSERT INTO Users SET ?', user, (error, userResult) => {
              if (error) {
                  console.error('Lỗi truy vấn Users:', error);
                  res.status(500).send('Lỗi server');
              } else {
                  const insertedUserId = userResult.insertId;
                  res.json({ IDUser: insertedUserId });

                  db.query('UPDATE Accounts SET IDUser = ? WHERE account_id = ?', [accountID, accountID], (updateError) => {
                    if (updateError) {
                      console.error('Lỗi cập nhật IDUser trong bảng Accounts:', updateError);
                      return;
                    }
                  });     
                  console.log("Đăng ký tài khoản và tạo user thành công");
              }
          });
      }
  });
});

//Đổi mật khẩu
app.put('/accounts/changePassword', (req, res) => {

    const { email, oldPassword, newPassword } = req.body;

    db.query('SELECT * FROM Accounts WHERE email = ? AND password_of_user = ?', [email, md5(oldPassword)], (error, results) => {
        if (error) {
            console.error('Lỗi truy vấn:', error);
            res.status(500).send('Lỗi server');
        } else if (results.length === 0) {
            res.status(401).send('Mật khẩu cũ không chính xác');
        } else {
            db.query('UPDATE Accounts SET password_of_user = ? WHERE email = ?', [md5(newPassword), email], (error, updateResults) => {
                if (error) {
                    console.error('Lỗi truy vấn:', error);
                    res.status(500).send('Lỗi server');
                } else {
                    res.json({ message: 'Mật khẩu đã được cập nhật thành công' });
                    console.log('Cập nhật mật khẩu thành công');
                }
            });
        }
    });
});

// Quên mật khẩu, thay đổi mật khẩu và gửi mật khẩu mới vào gmail người dùng
const transporter = nodemailer.createTransport({
    host: 'smtp.gmail.com',
    port: 587,
    secure: false, 
    auth: {
        user: 'newspaperappdemo@gmail.com',
        pass: 'erdg yukn fbof npxq',
    }
  });
  
  function randomPassword() {
      const length = 10;
      const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
      let newPassword = '';
      for (let i = 0; i < length; i++) {
        newPassword += characters.charAt(Math.floor(Math.random() * characters.length));
      }
      return newPassword;
    }
  
  app.post('/accounts/forgotPassword', (req, res) => {
      const { email } = req.body;
  
      const newPassword = randomPassword();
    
      const mailOptions = {
        from: "Newspaper",
        to: email,
        subject: 'Thông báo mật khẩu mới',
        text: `Mật khẩu mới của bạn là: ${newPassword}`
      };
    
      transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
          console.error('Lỗi khi gửi email:', error);
          res.status(500).send('Lỗi server');
        } else {
          db.query('UPDATE Accounts SET password_of_user = ? WHERE email = ?', [md5(newPassword), email], (updateError, updateResults) => {
            if (updateError) {
              console.error('Lỗi khi cập nhật mật khẩu:', updateError);
              res.status(500).send('Lỗi server khi cập nhật mật khẩu');
            } else {
              res.json({ message: 'Email đã được gửi thành công, vui lòng kiểm tra hộp thư đến của bạn.' });
              console.log(newPassword);
            }
          });
        }
      });
  });

// Lấy ra danh sách tài khoản
app.get('/accounts', (req, res) => {
    db.query('SELECT * FROM Accounts', (error, results) => {
        if (error) {
            console.log('Lỗi truy vấn', error);
            res.status(500).send('Lỗi server')
        } else {
            res.json(results);
        }
    });    
});

// Crawl dữ liệu từ website vnexpress

// const Parser = require('rss-parser');
// const parser = new Parser();

// (async () => {
//   const rssLinks = [
//     'https://vnexpress.net/rss/tin-moi-nhat.rss'
//   ];
//   let IDCategory = 1;
//   for (const rssLink of rssLinks) {
//     try {
//       const feed = await parser.parseURL(rssLink);

//       for (const item of feed.items) {
//         const title = item.title;
//         const link = item.link;
//         const pubDate = item.pubDate;
//         const content = item.content;
//         const contentSnippet = item.contentSnippet;
//         const guid = item.guid;
//         const isoDate = item.isoDate;
    

//         const sqlInsert = 'INSERT INTO Posts(IDUser, IDCategory, image, title, link, pubDate, content, contentSnippet, guid, isoDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
//         const values = [1,IDCategory, 1 , title, link, pubDate, content, contentSnippet, guid, isoDate];

//         db.query(sqlInsert, values, (error, results) => {
//           if (error) {
//             console.error('Lỗi thêm bài viết:', error);
//           } else {
//             console.log('Bài viết đã được thêm thành công');
//           }
//         });
//       }
//       IDCategory++; 
//     } catch (error) {
//       console.error('Lỗi lấy danh sách item:', error);
//     }
//   }
// })();

// lấy ra danh sách bài viết

app.get('/posts', (req, res) => {
  db.query('SELECT * FROM Posts', (error, results) => {
    if (error){
      console.error('Lỗi truy vấn', error);
      res.status(500).send('Lỗi server');
    }else{
      res.json(results);
    }
  })
});


// lấy ra danh sách thể loại bài viết

app.get('/category', (req, res) => {
  db.query('SELECT * FROM Category', (error, results) => {
    if(error){
      console.log('Lỗi truy vấn', error);
      res.status(500).send('Lỗi server');
    }else{
      res.json(results);
    }
  })
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
})