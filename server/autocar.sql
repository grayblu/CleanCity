drop table clean_user;
CREATE TABLE clean_user (
  userid varchar(20) not null primary key, -- ����ھ��̵�
  is_admin number default(0), -- ������ 1, ����� 0
  passwd varchar(20) not null, -- ��й�ȣ
  email varchar(30) not null, -- �̸���
  address varchar(100), -- �ּ�
  ip varchar(30), -- IP
  bin number default(0), -- �������� ��ġ�Ϸ� 1, �̿Ϸ� 0
  cap number default(0), -- �������� �뷮
  lat number default(0.0), -- ����
  lon number default(0.0), -- �浵
  phone varchar(30), -- ��ȭ��ȣ
  condition varchar(30) default('waiting'), -- �������� ��������
  REG_DATE DATE DEFAULT(SYSDATE), -- �����
  UPDATE_DATE DATE DEFAULT(SYSDATE) -- ������
);

drop table garbage_collection;
CREATE TABLE garbage_collection (
  collection_no number primary key, -- ���������� �⺻Ű
  userid varchar(20) not null, -- ����� ���̵�
  cap number default(0), -- �������� �뷮
  address varchar(100), -- �ּ�
  empty_date date default(sysdate) -- �������� ��� ��¥
);
DROP SEQUENCE collection_seq;
CREATE SEQUENCE collection_seq; -- ���������� �⺻Ű�� ���� ������
