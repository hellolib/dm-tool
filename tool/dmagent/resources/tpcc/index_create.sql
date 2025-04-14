create index ndx_customer_name on tpcc.customer (c_w_id, c_d_id, c_last, c_first);

create or replace procedure tpcc.createsequence 
as
 n int;
 stmt1 varchar(200);
 begin 
   select count(*)+1 into n from tpcc.history;
   if(n != 1) then
      select max(hist_id) + 1 into n from tpcc.history;
   end if;
   PRINT n;
   stmt1:='create sequence tpcc.hist_id_seq start with '||n||' MAXVALUE 9223372036854775807 CACHE 50000;';
   EXECUTE IMMEDIATE stmt1;
end;

call tpcc.createsequence;

alter table tpcc.history modify hist_id integer default (tpcc.hist_id_seq.nextval);