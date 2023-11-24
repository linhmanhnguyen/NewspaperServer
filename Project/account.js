const express = require('express');
const app = express();
const port = 3300;
const db = require('./connect');

const nodemailer = require('nodemailer');
const passport = require('passport');

var bodyParser = require('body-parser');

var md5 = require('md5');

app.use(bodyParser.json())

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

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
})