const express = require('express');
const app = express();
const port = 3300;
const db = require('./connect');
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
    console.log(req.body)
    console.log(md5(oldPassword))

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