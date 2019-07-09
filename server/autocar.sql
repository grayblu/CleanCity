drop table clean_user;
CREATE TABLE clean_user (
  userid varchar(20) not null primary key, -- 사용자아이디
  is_admin number default(0), -- 관리자 1, 사용자 0
  passwd varchar(20) not null, -- 비밀번호
  email varchar(30) not null, -- 이메일
  address varchar(100), -- 주소
  ip varchar(30), -- IP
  bin number default(0), -- 쓰레기통 설치완료 1, 미완료 0
  cap number default(0), -- 쓰레기통 용량
  lat number default(0.0), -- 위도
  lon number default(0.0), -- 경도
  phone varchar(30), -- 전화번호
  condition varchar(30) default('waiting'), -- 쓰레기통 수집상태
  REG_DATE DATE DEFAULT(SYSDATE), -- 등록일
  UPDATE_DATE DATE DEFAULT(SYSDATE) -- 수정일
);

drop table garbage_collection;
CREATE TABLE garbage_collection (
  collection_no number primary key, -- 수집데이터 기본키
  userid varchar(20) not null, -- 사용자 아이디
  cap number default(0), -- 쓰레기통 용량
  address varchar(100), -- 주소
  empty_date date default(sysdate) -- 쓰레기통 비운 날짜
);
DROP SEQUENCE collection_seq;
CREATE SEQUENCE collection_seq; -- 수집데이터 기본키에 대한 시퀀스
