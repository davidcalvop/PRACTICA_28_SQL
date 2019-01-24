--------------- 1 -------------------
create table usuarios (
  id_u number(20) constraint usuarios_pk primary key ,
  usuario varchar2(30) constraint usuarios_uk1 unique
                       constraint usuarios_nn1 not null ,
  e_mail varchar2(60) constraint usuarios_uk2 unique
                      constraint usuarios_nn2 not null ,
  nombre varchar2(30) constraint usuarios_nn3 not null ,
  apellido1 varchar2(30) constraint usuarios_nn4 not null ,
  apellido2 varchar2(30) ,
  passw varchar2(1000) constraint usuarios_nn5 not null
);

create table post (
  id_u number(20) constraint post_nn2 not null
                  constraint post_fk1 references usuarios on delete cascade ,
  pid number(20) constraint post_pk primary key ,
  texto varchar2(1000) constraint post_nn1 not null ,
  pid_rel number(20) constraint post_fk2 references post on delete set null ,
  publicacion date constraint post_nn3 not null ,
  duracion interval day to second constraint post_nn4 not null
);

create table contactos (
  id_u number(20) constraint contactos_fk1 references usuarios on delete cascade ,
  contacto number(20) constraint contactos_fk2 references usuarios on delete cascade ,
  constraint contactos_pk primary key (id_u,contacto)
);

create table ser_visible (
 id_u number(20),
 contacto number(20),
 pid number(20) constraint ser_visible_fk2 references post on delete cascade ,
 constraint ser_visible_pk primary key (id_u,contacto,pid),
 constraint ser_visible_fk1 foreign key (id_u,contacto) references contactos(id_u, contacto)
);

alter table post add constraint post_ck1
  check ( publicacion>to_date ('2/2/2017','dd/mm/yyyy'));
alter table contactos add constraint post_ck2 check ( id_u != contacto );

--------------- 2 -------------------

alter table post add constraint post_ck3 check ( duracion> interval '30' minute );

rename ser_visible to compartir;

alter table usuarios rename constraint usuarios_pk to superclave;

alter table post modify (publicacion default current_date);

alter table usuarios disable constraint usuarios_nn5;

alter table post add (visible char(2) default 'SI',
  constraint post_ck4 check ( visible = 'SI' or visible = 'NO')
  );