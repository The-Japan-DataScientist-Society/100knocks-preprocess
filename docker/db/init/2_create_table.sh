#!/bin/bash
set -e
psql -v ON_ERROR_STOP=1 --username padawan --dbname dsdojo_db <<-EOSQL
    -- customer
    drop table if exists customer;
    create table customer(
      customer_id            VARCHAR(14),
      customer_name          VARCHAR(20),
      gender_cd              VARCHAR(1),
      gender                 VARCHAR(2),
      birth_day              DATE,
      age                    INTEGER,
      postal_cd              VARCHAR(8),
      address                VARCHAR(128),
      application_store_cd   VARCHAR(6),
      application_date       VARCHAR(8),
      status_cd			         VARCHAR(12),
      primary key (customer_id)
    );

    -- category
    drop table if exists category;
    create table category(
      category_major_cd     VARCHAR(2),
      category_major_name   VARCHAR(32),
      category_medium_cd    VARCHAR(4),
      category_medium_name	VARCHAR(32),
      category_small_cd	    VARCHAR(6),
      category_small_name	  VARCHAR(32),
      primary key (category_small_cd)
    );


    -- product
    drop table if exists product;
    create table product(
      product_cd            VARCHAR(10),
      category_major_cd     VARCHAR(2),
      category_medium_cd    VARCHAR(4),
      category_small_cd	    VARCHAR(6),
      unit_price            INTEGER,
      unit_cost             INTEGER,
      primary key (product_cd)
    );

    -- store
    drop table if exists store;
    create table store(
      store_cd      VARCHAR(6),
      store_name    VARCHAR(128),
      prefecture_cd VARCHAR(2),
      prefecture    VARCHAR(5),
      address       VARCHAR(128),
      address_kana  VARCHAR(128),
      tel_no        VARCHAR(20),
      longitude     NUMERIC,
      latitude      NUMERIC,
      floor_area    NUMERIC,
      primary key (store_cd)
    );

    -- receipt
    drop table if exists receipt;
    create table receipt(
      sales_ymd       INTEGER,
      sales_epoch     INTEGER,
      store_cd        VARCHAR(6),
      receipt_no      SMALLINT,
      receipt_sub_no  SMALLINT,
      customer_id     VARCHAR(14),
      product_cd      VARCHAR(10),
      quantity        INTEGER,
      amount          INTEGER,
      primary key (sales_ymd, store_cd, receipt_no, receipt_sub_no)
    );

    -- geocode
    drop table if exists geocode;
    create table geocode(
      postal_cd       VARCHAR(8),
      prefecture      VARCHAR(4),
      city            VARCHAR(30),
      town            VARCHAR(30),
      street          VARCHAR(30),
      address         VARCHAR(30),
      full_address    VARCHAR(80),
      longitude       NUMERIC,
      latitude        NUMERIC
    );
EOSQL
