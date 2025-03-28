create database lms_db;

use lms_db;

CREATE TABLE tbl_books (
    book_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    publication_year YEAR NOT NULL,
    availability ENUM('AVAILABLE', 'BORROWED', 'RESERVED') DEFAULT 'AVAILABLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    reserved_by BIGINT,
    FOREIGN KEY (reserved_by) REFERENCES tbl_user(user_id)
);

ALTER TABLE tbl_books MODIFY COLUMN availability ENUM('AVAILABLE', 'BORROWED', 'RESERVED') NOT NULL DEFAULT 'AVAILABLE';
ALTER TABLE tbl_books MODIFY book_id BIGINT AUTO_INCREMENT;
SELECT * FROM tbl_books WHERE book_id = 50006;
SELECT * FROM tbl_books WHERE isbn = '9780456789101';
DESC tbl_books;
ALTER TABLE tbl_books DROP COLUMN available;
ALTER TABLE tbl_books ALTER COLUMN available SET DEFAULT b'1';


USE lms_db;
SELECT COUNT(*) FROM tbl_books;

SHOW TABLES LIKE 'tbl_books';




DROP TABLE IF EXISTS tbl_books;
DROP TABLE IF EXISTS tbl_user;
DROP TABLE IF EXISTS tbl_borrowed_books;
DROP TABLE IF EXISTS tbl_borrowings;
DROP TABLE IF EXISTS password_reset_tokens;



INSERT INTO tbl_books (book_id, title, author, category, isbn, publication_year, availability) VALUES 
(50001, 'Onyx Storm', 'Rebecca Yarros', 'Fantasy', '9781649374164', 2025, 'AVAILABLE'),
(50002, 'The Crash', 'Freida McFadden', 'Thriller', '9781538740727', 2025, 'AVAILABLE'),
(50003, 'Blood Moon', 'Sandra Brown', 'Mystery', '9781538740728', 2025, 'AVAILABLE'),
(50004, 'The Let Them Theory', 'Mel Robbins', 'Self-Help', '9780063207884', 2025, 'AVAILABLE'),
(50005, 'Take Care', 'Lindsey Burrow', 'Fiction', '9781982185677', 2025, 'AVAILABLE'),
(50006, 'The Midnight Library', 'Matt Haig', 'Fantasy', '9780525559474', 2020, 'AVAILABLE'),
(50007, 'Project Hail Mary', 'Andy Weir', 'Science Fiction', '9780593135204', 2021, 'AVAILABLE'),
(50008, 'Fourth Wing', 'Rebecca Yarros', 'Fantasy Romance', '9781649374042', 2023, 'AVAILABLE'),
(50009, 'Atomic Habits', 'James Clear', 'Self-Help', '9780735211292', 2018, 'AVAILABLE'),
(50010, 'A Court of Thorns and Roses', 'Sarah J. Maas', 'Fantasy', '9781635575569', 2020, 'AVAILABLE');

UPDATE tbl_user
SET user_password = '$2a$10$rTtA9V0QUGH2102ZWGuiY.EaVA0j/uVDlzkTuXrwfPf470DYwklZW'
WHERE user_id IN (90001, 90002, 90003);

CREATE TABLE tbl_user (
    user_id BIGINT PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    user_email VARCHAR(100) UNIQUE NOT NULL,
    user_password VARCHAR(255) NOT NULL,
    user_role ENUM('LIBRARIAN', 'MEMBER') NOT NULL,
    user_status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

ALTER TABLE tbl_user MODIFY user_id BIGINT AUTO_INCREMENT;
DESC tbl_user;
DESC tbl_books;


    
INSERT INTO tbl_user (user_id, user_name, user_email, user_password, user_role, user_status) VALUES
    (90001, 'Admin Librarian', 'admin@library.com', 'password123', 'LIBRARIAN', 'ACTIVE'),
    (90002, 'Taylor Swift', 'tswift@example.com', 'password123', 'MEMBER', 'ACTIVE'),
    (90003, 'Cassandra Liew', 'cliew@example.com', 'password123', 'MEMBER', 'ACTIVE');

    
	ALTER TABLE tbl_user MODIFY COLUMN user_id BIGINT AUTO_INCREMENT;
    
    ALTER TABLE tbl_books MODIFY COLUMN book_id BIGINT AUTO_INCREMENT;

CREATE TABLE tbl_borrowed_books (
    borrow_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    book_id BIGINT NOT NULL,
    borrow_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    return_date TIMESTAMP NULL,
    status ENUM('BORROWED', 'RETURNED') DEFAULT 'BORROWED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES tbl_user(user_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES tbl_books(book_id) ON DELETE CASCADE
);

CREATE TABLE tbl_borrowings (
    borrowing_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    book_id BIGINT NOT NULL,
    borrowed_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    return_date TIMESTAMP NULL,
    status ENUM('BORROWED', 'RETURNED') DEFAULT 'BORROWED',
    FOREIGN KEY (user_id) REFERENCES tbl_user(user_id),
    FOREIGN KEY (book_id) REFERENCES tbl_books(book_id)
);

CREATE TABLE password_reset_tokens (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    token VARCHAR(255) NOT NULL,
    expiry_date TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES tbl_user(user_id)
);

SELECT * FROM tbl_books;

UPDATE tbl_user
SET user_email = 'deejah@example.com'
WHERE user_email = 'deejah.com';

INSERT INTO tbl_borrowed_books (user_id, book_id, borrow_date, due_date, status)
VALUES (90001, 50001, NOW(), DATE_SUB(NOW(), INTERVAL 10 DAY), 'BORROWED');

INSERT INTO tbl_borrowed_books (user_id, book_id, borrow_date, due_date, status)
VALUES (90002, 50001, NOW(), DATE_SUB(NOW(), INTERVAL 10 DAY), 'BORROWED');

SELECT * FROM tbl_borrowed_books WHERE due_date < NOW() AND status = 'BORROWED';

UPDATE tbl_books 
SET availability = 'AVAILABLE' 
WHERE book_id = 50001;

DELETE FROM tbl_borrowed_books 
WHERE book_id = 50001;

SELECT book_id, title, availability FROM tbl_books WHERE book_id = 50002;

SELECT * FROM tbl_borrowed_books WHERE book_id = 50002;

INSERT INTO tbl_borrowed_books (user_id, book_id, borrow_date, due_date, status)
VALUES (90001, 50002, NOW(), DATE_ADD(NOW(), INTERVAL 14 DAY), 'BORROWED');

SELECT * FROM tbl_borrowed_books;

SELECT user_email, reset_token FROM tbl_user WHERE user_email = 'tswift@example.com';

DELETE FROM tbl_user;

UPDATE tbl_user
SET user_password = '$2a$10$e2VVHIxZg4atc2Kn7.cQ3enOKatnPyg6Ph0Wzjks0d4WYXqtvVkYu'
WHERE user_id = 90001;

UPDATE tbl_user
SET user_password = '$2a$10$e2VVHIxZg4atc2Kn7.cQ3enOKatnPyg6Ph0Wzjks0d4WYXqtvVkYu'
WHERE user_id = 90002;

UPDATE tbl_user
SET user_password = '$2a$10$e2VVHIxZg4atc2Kn7.cQ3enOKatnPyg6Ph0Wzjks0d4WYXqtvVkYu'
WHERE user_id = 90003;

ALTER TABLE tbl_books ADD COLUMN reserved_by BIGINT; ALTER TABLE tbl_books ADD CONSTRAINT fk_reserved_by FOREIGN KEY (reserved_by) REFERENCES tbl_user(user_id);

SELECT book_id, title, availability FROM tbl_books WHERE book_id = 50001;

ALTER TABLE tbl_books MODIFY COLUMN availability ENUM('AVAILABLE', 'BORROWED', 'RESERVED');

INSERT INTO tbl_books (title, author, category, isbn, publication_year, availability)
VALUES
('Iron Flame', 'Rebecca Yarros', 'Fantasy', '9781649374172', 2023, 'AVAILABLE'),
('The Housemaid\'s Secret', 'Freida McFadden', 'Thriller', '9781538725168', 2023, 'AVAILABLE'),
('The Seven Husbands of Evelyn Hugo', 'Taylor Jenkins Reid', 'Fiction', '9781501161933', 2017, 'AVAILABLE'),
('Tomorrow, and Tomorrow, and Tomorrow', 'Gabrielle Zevin', 'Fiction', '9780593321201', 2022, 'AVAILABLE'),
('Verity', 'Colleen Hoover', 'Romantic Thriller', '9781538724734', 2021, 'AVAILABLE'),
('Happy Place', 'Emily Henry', 'Romance', '9780593441275', 2023, 'AVAILABLE'),
('Lessons in Chemistry', 'Bonnie Garmus', 'Historical Fiction', '9780385547345', 2022, 'AVAILABLE'),
('Spare', 'Prince Harry', 'Memoir', '9780593593806', 2023, 'AVAILABLE'),
('Reminders of Him', 'Colleen Hoover', 'Romance', '9781542025607', 2022, 'AVAILABLE'),
('The Paris Library', 'Janet Skeslien Charles', 'Historical Fiction', '9781982134194', 2021, 'AVAILABLE'),
('The Ballad of Songbirds and Snakes', 'Suzanne Collins', 'Dystopian', '9781339016573', 2020, 'AVAILABLE'),
('It Ends with Us', 'Colleen Hoover', 'Romance', '9781501110368', 2016, 'AVAILABLE'),
('The Invisible Life of Addie LaRue', 'V.E. Schwab', 'Fantasy', '9780765387561', 2020, 'AVAILABLE'),
('A Court of Mist and Fury', 'Sarah J. Maas', 'Fantasy Romance', '9781619634466', 2016, 'AVAILABLE'),
('The Silent Patient', 'Alex Michaelides', 'Thriller', '9781250301697', 2019, 'AVAILABLE'),
('Book Lovers', 'Emily Henry', 'Romantic Comedy', '9780593334836', 2022, 'AVAILABLE'),
('Before We Were Strangers', 'Renée Carlino', 'Romance', '9781501105777', 2015, 'AVAILABLE'),
('The Love Hypothesis', 'Ali Hazelwood', 'Romantic Comedy', '9780593336823', 2021, 'AVAILABLE'),
('The Measure', 'Nikki Erlick', 'Speculative Fiction', '9780063204203', 2022, 'AVAILABLE'),
('The Paper Palace', 'Miranda Cowley Heller', 'Drama', '9780593329825', 2021, 'AVAILABLE');
















