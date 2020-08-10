# DB 세팅
DROP DATABASE IF EXISTS `at`;
CREATE DATABASE `at`;
USE `at`;
# article 테이블 세팅
CREATE TABLE article (
id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
regDate DATETIME, # 날짜에는 입력되는게 없으면 0000-00-00 00:00:00 을 하기 위함으로 NOT NULL을 뺏음
updateDate DATETIME,
delDate DATETIME,
delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
displayStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
title CHAR(200) NOT NULL,
`body` LONGTEXT NOT NULL,
 hit INT(10) UNSIGNED DEFAULT 0 NOT NULL,
 memberId INT(10) UNSIGNED NOT NULL
);
# article 테이블에 테스트 데이터 삽입
INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목1',
`body` = '내용1',
memberId = 1;
INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목2',
`body` = '내용2',
displayStatus = 1,
memberId = 1;


INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목3',
`body` = '내용3',
displayStatus = 1,
memberId = 1;

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목4',
`body` = '내용4',
displayStatus = 1,
memberId = 1;




SELECT *
FROM article;

# 댓글..... 
CREATE TABLE articleReply (
id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
regDate DATETIME, # 날짜에는 입력되는게 없으면 0000-00-00 00:00:00 을 하기 위함으로 NOT NULL을 뺏음
updateDate DATETIME,
delDate DATETIME,
articleId INT(10) UNSIGNED NOT NULL,
delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
memberId INT(10) UNSIGNED NOT NULL,
displayStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
`body` LONGTEXT NOT NULL
);

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
displayStatus = 1,
title = 'db 놓고왔네ㅠㅠㅠㅠㅠㅠ',
`body` = '으아아아아ㅠㅠㅠㅠㅠ',
memberId = 1;

# member 테이블 세팅
CREATE TABLE `member` (
id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT ,
regDate DATETIME,
updateDate DATETIME,
delDate DATETIME,
delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
authStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
loginId CHAR(20) NOT NULL UNIQUE,
loginPw CHAR(100) NOT NULL,
`name` CHAR(20) NOT NULL,
`nickname` CHAR(20) NOT NULL,
`email` CHAR(100) NOT NULL,
`phoneNo` CHAR(20) NOT NULL
);

# member 테이블에 테스트 데이터 삽입
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'admin',
loginPw = SHA2('admin', 256),
`name` = '관리자',
`nickname` = '관리자',
`email` = ' ',
`phoneNo` = ' ' ;

SELECT *
FROM `articleReply`;

DESC article;


# alter table article add column memberId INT(10) UNSIGNED NOT NULL after hit;


SELECT *
FROM articleReply;


SELECT *
FROM `member`;


# member 테이블에 테스트 데이터 삽입
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'hong',
loginPw = SHA2('hong', 256),
`name` = '홍길동',
`nickname` = '홍길동',
`email` = ' ',
`phoneNo` = ' ' ;

# 테이블 명 변경 ( 도구-히스토리-맽 밑에 )  reply 범용 만들기(기존 articleReply를)
# 게시물 댓글을 범용 댓글 테이블로 변경 __ 이렇게하면 사람한테도 댓글을 달 수 있다. 
RENAME TABLE `articleReply` TO `reply`; 


# 범용성을 위해 relTypeCode로 댓글을 어디에 다는지 구분, relId로 article뿐만 아니라 다른 곳들에도 댓글을 달 수 있도록 범용화.
ALTER TABLE `reply` ADD COLUMN `relTypeCode` CHAR(50) NOT NULL AFTER `delDate`, 
CHANGE `articleId` `relId` INT(10) UNSIGNED NOT NULL; 


ALTER TABLE `reply` ADD INDEX (`relId` , `relTypeCode`);

SELECT *
FROM reply;
