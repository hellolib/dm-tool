CREATE SCHEMA TPCC;

create table TPCC.CONFIG (
  cfg_name    varchar(30) cluster primary key,
  cfg_value   varchar(50)
);

create table TPCC.WAREHOUSE (
  w_id        integer   not null,
  w_ytd       float,
  w_tax       float,
  w_name      varchar(10),
  w_street_1  varchar(20),
  w_street_2  varchar(20),
  w_city      varchar(20),
  w_state     char(2),
  w_zip       char(9),
  cluster primary key(w_id)
)STORAGE(FILLFACTOR 1);

create table TPCC.DISTRICT (
  d_w_id       integer       not null,
  d_id         integer       not null,
  d_ytd        float,
  d_tax        float,
  d_next_o_id  integer,
  d_name       varchar(10),
  d_street_1   varchar(20),
  d_street_2   varchar(20),
  d_city       varchar(20),
  d_state      char(2),
  d_zip        char(9),
cluster primary key(d_w_id, d_id)
)STORAGE(FILLFACTOR 1);

create table TPCC.CUSTOMER (
  c_w_id         integer        not null,
  c_d_id         integer        not null,
  c_id           integer        not null,
  c_discount     float,
  c_credit       char(2),
  c_last         varchar(16),
  c_first        varchar(16),
  c_credit_lim   float,
  c_balance      float,
  c_ytd_payment  float,
  c_payment_cnt  integer,
  c_delivery_cnt integer,
  c_street_1     varchar(20),
  c_street_2     varchar(20),
  c_city         varchar(20),
  c_state        char(2),
  c_zip          char(9),
  c_phone        char(16),
  c_since        timestamp,
  c_middle       char(2),
  c_data         varchar(500),
  cluster primary key(c_w_id, c_d_id, c_id)
);

create table TPCC.HISTORY (
  hist_id  integer,
  h_c_id   integer,
  h_c_d_id integer,
  h_c_w_id integer,
  h_d_id   integer,
  h_w_id   integer,
  h_date   timestamp,
  h_amount float,
  h_data   varchar(24)
)storage(branch(32,32));
--对于DSC环境，不支持堆表，需要去掉storage子句

create table TPCC.OORDER (
  o_w_id       integer      not null,
  o_d_id       integer      not null,
  o_id         integer      not null,
  o_c_id       integer,
  o_carrier_id integer,
  o_ol_cnt     float,
  o_all_local  float,
  o_entry_d    timestamp,
  cluster primary key(o_w_id, o_d_id, o_id)
)storage(without counter);

create table TPCC.NEW_ORDER (
  no_w_id  integer   not null,
  no_d_id  integer   not null,
  no_o_id  integer   not null,
  cluster primary key(no_w_id, no_d_id, no_o_id)
)storage(without counter);

create table TPCC.ORDER_LINE (
  ol_w_id         integer   not null,
  ol_d_id         integer   not null,
  ol_o_id         integer   not null,
  ol_number       integer   not null,
  ol_i_id         integer   not null,
  ol_delivery_d   timestamp,
  ol_amount       float,
  ol_supply_w_id  integer,
  ol_quantity     float,
  ol_dist_info    char(24),
  cluster primary key(ol_w_id, ol_d_id, ol_o_id, ol_number)
)storage(without counter);

create table TPCC.STOCK (
  s_w_id       integer       not null,
  s_i_id       integer       not null,
  s_quantity   float,
  s_ytd        float,
  s_order_cnt  integer,
  s_remote_cnt integer,
  s_data       varchar(50),
  s_dist_01    char(24),
  s_dist_02    char(24),
  s_dist_03    char(24),
  s_dist_04    char(24),
  s_dist_05    char(24),
  s_dist_06    char(24),
  s_dist_07    char(24),
  s_dist_08    char(24),
  s_dist_09    char(24),
  s_dist_10    char(24),
cluster primary key(s_w_id, s_i_id)
);

create table TPCC.ITEM (
  i_id     integer      not null,
  i_name   varchar(24),
  i_price  float,
  i_data   varchar(50),
  i_im_id  integer,
  cluster primary key(i_id)
);


