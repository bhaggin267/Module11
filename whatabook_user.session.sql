import sys
import mysql.connector
from mysql.connector import errorcode

DROP USER IF EXISTS 'whatabook_user_user_user'@'localhost';

CREATE USER 'whatabook_user_user_user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Hubcapsb109$!';

GRANT ALL PRIVILEGES ON whatabook_user_user_user.* TO'whatabook_user_user'@'localhost';

ALTER TABLE wishlist DROP FOREIGN KEY fk_user;
ALTER TABLE wishlist DROP FOREIGN KEY fk_book;

DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS store;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS wishlist;

CREATE TABLE user (
    user_id         INT         NOT NULL    AUTO_INCREMENT,
    first_name      VARCHAR(75) NOT NULL,
    last_name       VARCHAR(75) NOT NULL,
    PRIMARY KEY(user_id) 
);

CREATE TABLE store (
    store_id    INT             NOT NULL    AUTO_INCREMENT,
    locale      VARCHAR(500)    NOT NULL,
    PRIMARY KEY(store_id)
);

CREATE TABLE book (
    book_id     INT             NOT NULL    AUTO_INCREMENT,
    book_name   VARCHAR(200)    NOT NULL,
    author      VARCHAR(200)    NOT NULL,
    details     VARCHAR(500),
    PRIMARY KEY(book_id)
);

CREATE TABLE wishlist (
    wishlist_id     INT         NOT NULL    AUTO_INCREMENT,
    user_id         INT         NOT NULL,
    book_id         INT         NOT NULL,
    PRIMARY KEY (wishlist_id),
    CONSTRAINT fk_book
    FOREIGN KEY (book_id)
        REFERENCES book(book_id),
    CONSTRAINT fk_user
    FOREIGN KEY (user_id)
        REFERENCES user(user_Id)
);

SELECT user.user_id, user.first_name, user.last_name, book.book_id, book.book_name, book.author
FROM wishlist
    INNER JOIN user ON wishlist.user_id = user.user_id
    INNER JOIN book ON wishlist.book_id = book.book_id
WHERE user.user_id = 1;

SELECT store_id, locale from store;
SELECT book_id, book_name, author, details from book;

SELECT book_id, book_name, author, details
FROM book
WHERE book_id NOT IN (SELECT book_id FROM wishlist WHERE user_id = 1);

INSERT INTO wishlist(user_id, book_id)
    VALUES(1, 9)

DELETE FROM wishlist WHERE user_id = 1 AND book_id = 9;

INSERT INTO store(locale)
    VALUES('1000 Galvin Rd S, Bellevue, NE 68005');


INSERT INTO book(book_name, author, details)
    VALUES('The Return of the King', 'J.R.Tolkien', 'The third part of The Lord of the Rings');

INSERT INTO book(book_name, author, details)
    VALUES('The Fellowship of the Ring', 'J.R.Tolkien', 'The first part of The Lord of the Rings');

INSERT INTO book(book_name, author, details)
    VALUES('The Two Towers', 'J.R.Tolkien', "The second part of The Lord of The Rings");

INSERT INTO book(book_name, author)
    VALUES('The Hobbit or There and Back Again', 'J.R.Tolkien');

INSERT INTO book(book_name, author)
    VALUES('Dune: Deluxe Edition', 'Frank Herbert');

INSERT INTO book(book_name, author)
    VALUES("Charlotee's Web", 'E.B. White');

INSERT INTO book(book_name, author)
    VALUES('The Great Gatsby', 'F. Scott Fitzgerald');

INSERT INTO book(book_name, author)
    VALUES('The Lion, the Witch, and the Wardrobe', 'C.S. Lewis');

INSERT INTO book(book_name, author)
    VALUES('The Catcher and the Rye', 'J.D. Salinger');

 
INSERT INTO user(first_name, last_name) 
    VALUES('Thorin', 'Oakenshield');

INSERT INTO user(first_name, last_name)
    VALUES('Bilbo', 'Baggins');

INSERT INTO user(first_name, last_name)
    VALUES('Frodo', 'Baggins');

INSERT INTO wishlist(user_id, book_id) 
    VALUES (
        (SELECT user_id FROM user WHERE first_name = 'Thorin'), 
        (SELECT book_id FROM book WHERE book_name = 'The Hobbit or There and Back Again')
    );

INSERT INTO wishlist(user_id, book_id)
    VALUES (
        (SELECT user_id FROM user WHERE first_name = 'Bilbo'),
        (SELECT book_id FROM book WHERE book_name = 'The Fellowship of the Ring')
    );

INSERT INTO wishlist(user_id, book_id)
    VALUES (
        (SELECT user_id FROM user WHERE first_name = 'Frodo'),
        (SELECT book_id FROM book WHERE book_name = 'The Return of the King')
    );
