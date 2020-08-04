# DB 세팅
DROP DATABASE IF EXISTS `at`;
CREATE DATABASE `at`;
USE `at`;
# article 테이블 세팅
CREATE TABLE article (
    id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT, PRIMARY KEY(id),
    regDate DATETIME, # 날짜에는 입력되는게 없으면 0000-00-00 00:00:00 을 하기 위함으로 NOT NULL을 뺏음
    updateDate DATETIME,
    delDate DATETIME,
	delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
	displayStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    title CHAR(200) NOT NULL,
    `body` LONGTEXT NOT NULL,
     hit INT(10) UNSIGNED DEFAULT 0 NOT NULL
);
# article 테이블에 테스트 데이터 삽입
INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목1',
`body` = '내용1';
INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목2',
`body` = '내용2',
displayStatus = 1;
INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목3',
`body` = '내용3',
displayStatus = 1;


SELECT *
FROM article;

DESC article;

UPDATE article
SET updateDate = NOW(),
title = '왜 안되냐 sql',
`body` = '왜 안되냐 sql',
WHERE displayStatus = 1
AND id = 3


UPDATE article
SET delStatus = 1,
delDate = NOW(),
displayStatus = 0,
WHERE id = 4