--
-- PostgreSQL database dump
--


-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.10 (Ubuntu 17.10-0ubuntu0.25.10.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public."Product" DROP CONSTRAINT "Product_productId_fkey";
ALTER TABLE ONLY public."OnSaleProduct" DROP CONSTRAINT "OnSaleProduct_transactionId_fkey";
ALTER TABLE ONLY public."OnSaleProduct" DROP CONSTRAINT "OnSaleProduct_productId_fkey";
ALTER TABLE ONLY public."Debt" DROP CONSTRAINT "Debt_transactionId_fkey";
DROP INDEX public."User_email_key";
DROP INDEX public."Transaction_status_idx";
DROP INDEX public."Transaction_createdAt_idx";
DROP INDEX public."Product_productId_key";
DROP INDEX public."ProductStock_skuManual_key";
DROP INDEX public."ProductStock_name_idx";
DROP INDEX public."ProductStock_brand_masterCategory_idx";
DROP INDEX public."ProductStock_brand_idx";
DROP INDEX public."ProductStock_brand_category_idx";
DROP INDEX public."OnSaleProduct_transactionId_idx";
DROP INDEX public."Expense_createdAt_idx";
DROP INDEX public."Expense_category_idx";
DROP INDEX public."Debt_transactionId_key";
DROP INDEX public."Debt_isPaid_idx";
DROP INDEX public."Debt_customerName_idx";
DROP INDEX public."Debt_createdAt_idx";
DROP INDEX public."Category_name_key";
ALTER TABLE ONLY public._prisma_migrations DROP CONSTRAINT _prisma_migrations_pkey;
ALTER TABLE ONLY public."User" DROP CONSTRAINT "User_username_key";
ALTER TABLE ONLY public."User" DROP CONSTRAINT "User_pkey";
ALTER TABLE ONLY public."Transaction" DROP CONSTRAINT "Transaction_pkey";
ALTER TABLE ONLY public."ShopData" DROP CONSTRAINT "ShopData_pkey";
ALTER TABLE ONLY public."Product" DROP CONSTRAINT "Product_pkey";
ALTER TABLE ONLY public."ProductStock" DROP CONSTRAINT "ProductStock_pkey";
ALTER TABLE ONLY public."OnSaleProduct" DROP CONSTRAINT "OnSaleProduct_productId_transactionId_key";
ALTER TABLE ONLY public."OnSaleProduct" DROP CONSTRAINT "OnSaleProduct_pkey";
ALTER TABLE ONLY public."Expense" DROP CONSTRAINT "Expense_pkey";
ALTER TABLE ONLY public."Debt" DROP CONSTRAINT "Debt_pkey";
ALTER TABLE ONLY public."Category" DROP CONSTRAINT "Category_pkey";
DROP TABLE public._prisma_migrations;
DROP TABLE public."User";
DROP TABLE public."Transaction";
DROP TABLE public."ShopData";
DROP TABLE public."ProductStock";
DROP TABLE public."Product";
DROP TABLE public."OnSaleProduct";
DROP TABLE public."Expense";
DROP TABLE public."Debt";
DROP TABLE public."Category";
DROP TYPE public."UserRole";
DROP TYPE public."TransactionStatus";
DROP TYPE public."ExpenseCategory";
DROP TYPE public."Brand";
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: Brand; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."Brand" AS ENUM (
    'HONDA',
    'YAMAHA',
    'KAWASAKI',
    'SUZUKI'
);


--
-- Name: ExpenseCategory; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ExpenseCategory" AS ENUM (
    'RESTOK',
    'OPERASIONAL',
    'GAJI',
    'LAINNYA'
);


--
-- Name: TransactionStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."TransactionStatus" AS ENUM (
    'SUKSES',
    'RETUR',
    'HUTANG'
);


--
-- Name: UserRole; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."UserRole" AS ENUM (
    'OWNER',
    'WORKER',
    'UNKNOW'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Category" (
    id text NOT NULL,
    name text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: Debt; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Debt" (
    id text NOT NULL,
    "customerName" text NOT NULL,
    amount numeric(15,2) NOT NULL,
    "transactionId" text NOT NULL,
    notes text,
    "isPaid" boolean DEFAULT false NOT NULL,
    "paidAt" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: Expense; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Expense" (
    id text NOT NULL,
    description text NOT NULL,
    amount numeric(15,2) NOT NULL,
    category public."ExpenseCategory" DEFAULT 'LAINNYA'::public."ExpenseCategory" NOT NULL,
    notes text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: OnSaleProduct; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."OnSaleProduct" (
    id text NOT NULL,
    "productId" text NOT NULL,
    quantity integer NOT NULL,
    saledate timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "transactionId" text NOT NULL
);


--
-- Name: Product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Product" (
    id text NOT NULL,
    "productId" text NOT NULL,
    sellprice numeric(15,2) NOT NULL
);


--
-- Name: ProductStock; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ProductStock" (
    id text NOT NULL,
    name text NOT NULL,
    "imageProduct" text,
    stock integer DEFAULT 0 NOT NULL,
    brand public."Brand" NOT NULL,
    "buyPrice" numeric(15,2) DEFAULT 0 NOT NULL,
    category text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "masterCategory" text NOT NULL,
    "sellPrice" numeric(15,2) DEFAULT 0 NOT NULL,
    "skuManual" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    barcode text
);


--
-- Name: ShopData; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ShopData" (
    id text NOT NULL,
    name text
);


--
-- Name: Transaction; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Transaction" (
    "totalAmount" numeric(15,2),
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    id text NOT NULL,
    "isComplete" boolean DEFAULT false NOT NULL,
    "changeAmount" numeric(15,2) DEFAULT 0,
    "paymentAmount" numeric(15,2) DEFAULT 0,
    status public."TransactionStatus" DEFAULT 'SUKSES'::public."TransactionStatus" NOT NULL,
    "discountAmount" numeric(15,2) DEFAULT 0,
    "deletedAt" timestamp(3) without time zone
);


--
-- Name: User; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."User" (
    id text NOT NULL,
    name text NOT NULL,
    username text NOT NULL,
    email text,
    "emailVerified" timestamp(3) without time zone,
    image text,
    password text,
    role public."UserRole" DEFAULT 'UNKNOW'::public."UserRole" NOT NULL
);


--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


--
-- Data for Name: Category; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Category" (id, name, "createdAt") FROM stdin;
cmqjlc4ri0000a8tjoe6l0i0h	BODY PART	2026-06-18 14:24:06.174
cmqjlc4ri0001a8tj0y3wxdo9	LAIN-LAIN	2026-06-18 14:24:06.174
cmqjlc4ri0002a8tjly9pwwqb	KELISTRIKAN	2026-06-18 14:24:06.174
cmqjlc4ri0004a8tjnm2g1pyl	PENGEREMAN	2026-06-18 14:24:06.174
cmqjlc4ri0005a8tjotxo7uba	MESIN & OLI	2026-06-18 14:24:06.174
cmqjlc4ri0006a8tjxx9penwq	KAKI-KAKI	2026-06-18 14:24:06.174
cmqjtg2s20000rnqk7j3h3dm9	MESIN	2026-06-18 18:11:07.155
cmqjtg2s20001rnqki4074xy5	LAINNYA	2026-06-18 18:11:07.155
cmqjlc4ri0003a8tj2rdzrvuc	AKSESORIS	2026-06-18 14:24:06.174
\.


--
-- Data for Name: Debt; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Debt" (id, "customerName", amount, "transactionId", notes, "isPaid", "paidAt", "createdAt", "updatedAt") FROM stdin;
cmqkrwhjz00059naf36w5k3nu	jamal	210000.00	TRS-be0fb001	\N	t	2026-06-19 10:16:02.892	2026-06-19 10:15:39.743	2026-06-19 10:16:02.893
cmqpozv3a0004dlnggo92h57i	Jamal	210000.00	TRS-cb64db83	Test	f	\N	2026-06-22 20:53:09.287	2026-06-22 20:53:09.287
cmqpp0vqu0009dlngfl2wgulj	Jamal	13000.00	TRS-785126c5	123	f	\N	2026-06-22 20:53:56.79	2026-06-22 20:53:56.79
cmqppseg500046txc5g9295bp	Test	210000.00	TRS-d720612f	\N	t	2026-06-22 21:16:43.757	2026-06-22 21:15:20.741	2026-06-22 21:16:43.758
cmqqz61zs000i12t3ye0ye1qi	Qwe	1110000.00	TRS-5803ce2e	123	t	2026-06-23 18:47:07.334	2026-06-23 18:25:40.283	2026-06-23 18:47:07.335
\.


--
-- Data for Name: Expense; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Expense" (id, description, amount, category, notes, "createdAt", "updatedAt") FROM stdin;
cmql9qphv000b9nafbowou1mo	b8uh	100000.00	LAINNYA	\N	2026-06-19 18:35:02.973	2026-06-19 18:35:02.973
\.


--
-- Data for Name: OnSaleProduct; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."OnSaleProduct" (id, "productId", quantity, saledate, "transactionId") FROM stdin;
cmqkrwhb200039nafny66lxey	cmlezxp0j028n39t5q2eupsx9	1	2026-06-19 10:15:39.422	TRS-be0fb001
cmqkt16so00089naf302lylvg	cmlezxogk027639t51tk0jd9s	1	2026-06-19 10:47:18.696	TRS-9568c2b9
cmqlipwi100033uuanjx0op6s	6dd1b8b3-a97c-4273-ac89-073fb6b4ccf3	1	2026-06-19 22:46:22.153	TRS-98ae404c
cmqnp4f7s0002xrj8ltexiyru	858498b2-ad72-4e2d-ba76-ffea984e2c9e	1	2026-06-21 11:21:09.641	TRS-00d93ea6
cmqnp8c0y0005xrj8sb1uxwjf	cmlezxp0j028n39t5q2eupsx9	1	2026-06-21 11:24:12.13	TRS-058b0e8e
cmqpozryo0002dlng7k1fboy3	cmlezxp0j028n39t5q2eupsx9	1	2026-06-22 20:53:05.232	TRS-cb64db83
cmqpp0su90007dlnga0sbhy5j	858498b2-ad72-4e2d-ba76-ffea984e2c9e	1	2026-06-22 20:53:53.026	TRS-785126c5
cmqppsbme00026txcgioj33gd	cmlezxp0j028n39t5q2eupsx9	1	2026-06-22 21:15:17.078	TRS-d720612f
cmqqwt9mv000371vta8u4g0am	cmlezx615016o39t5uf4s001m	1	2026-06-23 17:19:44.648	TRS-bf43e9cd
cmqqz5tcw000412t38ztplhxm	cmlezx615016o39t5uf4s001m	1	2026-06-23 18:25:29.313	TRS-5803ce2e
cmqqz5v31000812t35qykpe68	cmlezxjn001yw39t5cct8wlvz	1	2026-06-23 18:25:31.549	TRS-5803ce2e
cmqqz5wst000c12t3a7jk5xfp	cmlezxo4j026h39t5fhexuhp7	1	2026-06-23 18:25:33.774	TRS-5803ce2e
cmqqz5yig000g12t3nq37hott	cmlezwgaa000q39t5gxoxtinf	1	2026-06-23 18:25:35.993	TRS-5803ce2e
cmqqzvrsg0004f9dlr6mrg3nz	858498b2-ad72-4e2d-ba76-ffea984e2c9e	1	2026-06-23 18:45:40.336	TRS-a6d63ed5
cmqr102lk0005f0amgo37fl9q	cmlezxp0j028n39t5q2eupsx9	1	2026-06-23 19:17:00.584	TRS-c729c220
cmqr102lk0009f0amersdz83j	858498b2-ad72-4e2d-ba76-ffea984e2c9e	1	2026-06-23 19:17:00.584	TRS-c729c220
\.


--
-- Data for Name: Product; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Product" (id, "productId", sellprice) FROM stdin;
cmlezwfzb000739t5zqdu1b1r	cmlezwfzb000639t5nnrwo3iw	1958000.00
cmlezwfzb000539t5mufbg3n6	cmlezwfzb000439t564tu14n6	201000.00
cmlezwg0d000939t5v8lflfsa	cmlezwg0d000839t5ox899wsg	2181000.00
cmlezwg26000d39t5x5g7ujtd	cmlezwg26000c39t5dfiuy12n	1624000.00
cmlezwg26000b39t5fg5y6rq7	cmlezwg26000a39t59el2cb2q	1629000.00
cmlezwg5k000f39t56cyui2tu	cmlezwg5k000e39t5dr3iz2vv	1480000.00
cmlezwg8g000h39t50ovjunyi	cmlezwg8f000g39t5irvaqb12	80000.00
cmlezwg8n000j39t53fvttnb3	cmlezwg8n000i39t57dkmp541	389000.00
cmlezwg91000l39t55vda1eft	cmlezwg90000k39t5mvihfssp	85000.00
cmlezwg9v000p39t5ehjumj4a	cmlezwg9v000o39t53jskxw13	2154000.00
cmlezwg9v000n39t5qdkhsjg1	cmlezwg9v000m39t5vr6ywimv	158000.00
cmlezwgbx000t39t5dqvfuzy3	cmlezwgbx000s39t5i0h6k891	182000.00
cmlezwgen000x39t5gl60blec	cmlezwgen000v39t52dompgsg	195000.00
cmlezwgen000w39t52kczbl5h	cmlezwgen000u39t5dh9khhjv	1624000.00
cmlezwgf0000z39t5d7l9qusp	cmlezwgf0000y39t52qdp4pf0	90000.00
cmlezwgfs001139t5kq83krgm	cmlezwgfs001039t5b21x4joa	135000.00
cmlezwggi001539t50gxnvkqb	cmlezwggi001239t593llncje	200000.00
cmlezwggi001439t5gv0pjv0j	cmlezwggi001339t5okvvkytn	194000.00
cmlezwgho001739t57mvoq714	cmlezwgho001639t5ofbk970k	154000.00
cmlezwgj4001939t5boqek7uz	cmlezwgj4001839t5l9j36fu4	176000.00
cmlezwgkk001b39t5mmezv3v7	cmlezwgkk001a39t55rnnkjcq	217000.00
cmlezwgkk001d39t57uqse1qk	cmlezwgkk001c39t5swp1t3qr	154000.00
cmlezwglv001f39t53oyp1ehs	cmlezwglv001e39t5lwp5rfuc	33000.00
cmlezwgm7001h39t578lbl3pp	cmlezwgm7001g39t5b1bl37nw	211000.00
cmlezwgmq001k39t5mtccvru8	cmlezwgmq001i39t55gpn084u	179000.00
cmlezwgmq001l39t5hotabsn1	cmlezwgmq001j39t50ggys3to	175000.00
cmlezwgob001n39t5p8ugfyr2	cmlezwgob001m39t56hxaqkoo	303000.00
cmlezwgqh001t39t5i5qy28j8	cmlezwgqh001s39t5o53ymleq	319000.00
cmlezwgpk001p39t5ekc76nu3	cmlezwgpk001o39t5sjnrn35t	221000.00
cmlezwgro001v39t59xk4agud	cmlezwgro001u39t5tuhhpoad	179000.00
cmlezwgsg001x39t5uxsvvdw1	cmlezwgsg001w39t5k3llka1s	321000.00
cmlezwgsw001z39t5jq4upmp3	cmlezwgsw001y39t5lopyjgic	118000.00
cmlezwgt4002139t5suxqrpj1	cmlezwgt4002039t538l3b57x	179000.00
cmlezwgpo001r39t55yt97zx6	cmlezwgpo001q39t5cs1g5q1v	212000.00
cmlezwgv3002339t5u74mjq9n	cmlezwgv3002239t5osnbdfak	223000.00
cmlezwgwd002539t5etfc5kqu	cmlezwgwd002439t57mkpd33r	264000.00
cmlezwgwn002739t5e4uhw4k0	cmlezwgwn002639t579tvy10h	329000.00
cmlezwgxl002939t5iu7lgver	cmlezwgxl002839t55v1mm5j9	156000.00
cmlezwgyp002b39t5bc2n89zk	cmlezwgyp002a39t5fztcyegh	319000.00
cmlezwgzf002e39t5o9c5ajpe	cmlezwgzf002c39t5lq7b0m38	214000.00
cmlezwgzf002f39t58tji74cy	cmlezwgzf002d39t5a823y9nq	239000.00
cmlezwh0t002h39t58v49g0us	cmlezwh0t002g39t577bqyytl	223000.00
cmlezwh23002l39t5zr0y19jq	cmlezwh23002k39t5zq67eyao	329000.00
cmlezwh5k002p39t52q5bsu9o	cmlezwh5k002o39t5vn871pvn	328000.00
cmlezwh1n002j39t59fnoyovo	cmlezwh1n002i39t5nx028pgr	212000.00
cmlezwh67002r39t53n331ib9	cmlezwh67002q39t5b0njgs9j	191000.00
cmlezwh70002v39t5mirdr2ky	cmlezwh70002t39t5g0ck03f4	162000.00
cmlezwh70002u39t5mwogqvzv	cmlezwh70002s39t5gi1l6u79	189000.00
cmlezwh8g002x39t5o6lrafne	cmlezwh8g002w39t5s8fh01wv	240000.00
cmlezwh9w002z39t5kkil2ifz	cmlezwh9w002y39t53et9el16	207000.00
cmlezwh3r002n39t51iexl8kh	cmlezwh3r002m39t52rxnnoxa	240000.00
cmlezwhcm003139t5zuc682fl	cmlezwhcm003039t5v6u8eafz	322000.00
cmlezwhdc003339t5h1idtgqc	cmlezwhdc003239t5gh0on1lo	347000.00
cmlezwhed003739t5mz7k7ydb	cmlezwhed003539t5hrtbbw3w	341000.00
cmlezwhed003639t5f2joobxw	cmlezwhed003439t58qkifkeg	240000.00
cmlezwhfs003939t5bp33kxrn	cmlezwhfs003839t5lqqmqmzz	74000.00
cmlezwhhc003d39t5wynazwpu	cmlezwhhc003c39t5y0d82ael	240000.00
cmlezwhkf003f39t5ueyoe4tw	cmlezwhkd003e39t51u4s6fpb	221000.00
cmlezwhhc003b39t5tojigf9k	cmlezwhhc003a39t5zalcf0lu	136000.00
cmlezwhlh003l39t5asphzxpc	cmlezwhlh003k39t5p1twepx6	284000.00
cmlezwhl2003h39t5cuf6g4mi	cmlezwhl2003g39t5cibzomc4	341000.00
cmlezwhm9003o39t5cln8wgpl	cmlezwhm9003m39t53z3vw9he	142000.00
cmlezwhm9003p39t52eqyo1xp	cmlezwhm9003n39t5mo7l1uik	49000.00
cmlezwhqa003r39t5f0ol2osu	cmlezwhqa003q39t5904ttqzr	263000.00
cmlezwhl2003j39t5m9mnp839	cmlezwhl2003i39t517rnpjyp	244000.00
cmlezwhuo003u39t5ol4y9fzr	cmlezwhuo003s39t5ij246iwq	214000.00
cmlezwhvb003z39t5ytq7mvsw	cmlezwhvb003x39t5pvrcidit	269000.00
cmlezwhvb003y39t5ylqd0abh	cmlezwhvb003w39t5zwhjxre2	345000.00
cmlezwhvq004139t5w9tctddb	cmlezwhvq004039t5vqq8fhm2	246000.00
cmlezwhxr004539t5dnaduog6	cmlezwhxr004439t51eh0n3so	178000.00
cmlezwhwy004339t5b1031l04	cmlezwhwy004239t55jnr87ir	177000.00
cmlezwhuo003v39t5kiqwjv08	cmlezwhuo003t39t5pbveytd0	194000.00
cmlezwi2c004b39t5woyge6po	cmlezwi2c004a39t5j6w1jnq0	241000.00
cmlezwi24004939t5g69ftxyc	cmlezwi24004839t50zbn71vh	189000.00
cmlezwi2u004d39t5r54p3ofj	cmlezwi2u004c39t5445evrru	178000.00
cmlezwi3r004g39t5r0rwxz8s	cmlezwi3r004e39t5gw9336k8	177000.00
cmlezwi3r004h39t5f2nfmd3f	cmlezwi3r004f39t50rd51ahp	213000.00
cmlezwi4f004j39t54vr0r6uy	cmlezwi4f004i39t50r533w8c	213000.00
cmlezwhzr004739t52pzysz1f	cmlezwhzr004639t5n4ikd0cl	263000.00
cmlezwi8o004m39t59h9qq3gd	cmlezwi8o004k39t5ucp5o8qf	99000.00
cmlezwi8o004n39t50ltxz4yw	cmlezwi8o004l39t5b7vgu6k9	262000.00
cmlezwiap004r39t5qvfw1qc9	cmlezwiap004p39t5tc4aharz	177000.00
cmlezwiap004q39t5jnahlf7a	cmlezwiap004o39t5ac3xjz3g	193000.00
cmlezwibp004t39t5ot9gdbif	cmlezwibp004s39t5iz3c82b5	177000.00
cmlezwidb004v39t581mrsqsf	cmlezwida004u39t5wv2jivi9	159000.00
cmlezwie0004x39t5iej0gdtg	cmlezwie0004w39t5e2moid0y	193000.00
cmlezwjtw005x39t5bn4hd6yr	cmlezwjtv005v39t56oi6wlul	172000.00
cmlezwk0y006639t5pyuheutn	cmlezwk0y006439t5n0b2qaic	98000.00
cmlezwk91006t39t54b9ds7ru	cmlezwk90006q39t5m62yeep9	156000.00
cmlezwkhb007b39t59li7t153	cmlezwkhb007839t5bgvrmevy	68000.00
cmlezwkvf007x39t51g713iiy	cmlezwkvf007w39t52jb0st3x	145000.00
cmlezwl5c008939t5gsye4mw7	cmlezwl5c008839t5f00n88cu	110000.00
cmlezwlez008t39t5fh2z2zn8	cmlezwlez008s39t59fu2t0dr	133000.00
cmlezwlnj009b39t53q8c33o0	cmlezwlnj009a39t5604kp2fw	81000.00
cmlezwluy009t39t5silqnin2	cmlezwluy009s39t5xut4knj6	82000.00
cmlezwm3h00a339t5xqsfsumq	cmlezwm3h00a239t5ak4f0ivt	98000.00
cmlezwme400aj39t5c98t1zr2	cmlezwme400ai39t5wd31ut2y	89000.00
cmlezwmll00ay39t599u7gddg	cmlezwmll00ax39t5rpuyr2zq	68000.00
cmlezwngc00bb39t5kd30r98p	cmlezwngc00b739t5u5o1g0ig	153000.00
cmlezwnp200bv39t5qa52nh1d	cmlezwnp200bt39t5ajx7wb3t	140000.00
cmlezwnzm00cc39t56retduvp	cmlezwnzm00ca39t50irnlm9w	41000.00
cmlezwo5o00cq39t56ax5dizf	cmlezwo5o00co39t5flev3qkk	86000.00
cmlezwobo00d539t5xy7q7xoa	cmlezwobo00d439t5wd8558mu	86000.00
cmlezwonl00dt39t5jpggrx0s	cmlezwonl00ds39t5mted6v1v	83000.00
cmlezwowf00eb39t533f0q84b	cmlezwowf00ea39t5kelseg2p	129000.00
cmlezwp8a00et39t50fjssrx2	cmlezwp8a00es39t5m79qusox	95000.00
cmlezwqi800fp39t58mewkjx0	cmlezwqi800fo39t5xhfbb9zp	97000.00
cmlezwr0g00gc39t543iid95s	cmlezwr0g00ga39t5e4d3lat0	97000.00
cmlezwrgp00gt39t5dsi9pu0c	cmlezwrgp00gs39t5k5ujy8e7	124000.00
cmlezwrrg00ha39t5ru5nhkm6	cmlezwrrg00h739t5kxu16m5c	95000.00
cmlezwrz800hp39t5tct1t6tw	cmlezwrz800ho39t54krx396h	47000.00
cmlezwsah00i539t53ldg49tn	cmlezwsah00i439t5jfx0t2b8	145000.00
cmlezwsi000ip39t57fuk0cqy	cmlezwsi000io39t51jwrpziq	52000.00
cmlezwsr700j139t5u9n3oo8d	cmlezwsr700j039t5bxtul6nk	31000.00
cmlezwtq900jj39t50tnat5hl	cmlezwtq900ji39t5yli98t5p	51000.00
cmlezwtzg00k139t52854d0xf	cmlezwtzg00k039t5mra2qt01	181000.00
cmlezwudf00kj39t55kflt7nk	cmlezwudf00ki39t52zkz98lc	198000.00
cmlezwulc00l139t5hebekrmo	cmlezwulc00l039t5pl92d43q	59000.00
cmlezwusl00li39t5s9fjbhpo	cmlezwusl00lh39t5mmeivxw4	166000.00
cmlezwv2y00m139t5xunyspmr	cmlezwv2y00m039t51vao3mie	190000.00
cmlezwvmw00me39t5jd07c6j2	cmlezwvmw00m939t52198d3u1	155000.00
cmlezwvw700mt39t5hb3n1cxq	cmlezwvw700ms39t5qu0akacw	179000.00
cmlezww3p00na39t5vvm6rri5	cmlezww3p00n839t5s733jvr7	266000.00
cmlezwwci00np39t5v3ywk0pg	cmlezwwci00no39t5udwh81vk	108000.00
cmlezwwn600ob39t5b2wlnbcf	cmlezwwn500oa39t5eyaijz4w	108000.00
cmlezwwwe00ol39t52wmkbrao	cmlezwwwe00ok39t5qbynagsk	55000.00
cmlezwx4600p239t534hcugq4	cmlezwx4500p039t59tgmj7jh	79000.00
cmlezwxaq00pf39t55gro9z3h	cmlezwxaq00pe39t5slrz698r	174000.00
cmlezwxhm00pt39t5hrqdoi2j	cmlezwxhl00ps39t593oetmxc	53000.00
cmlezwxmy00q739t5ourn0mec	cmlezwxmy00q639t5ppqmuemm	58000.00
cmlezwxsl00ql39t51kyrdwd7	cmlezwxsl00qk39t5w4j673m3	266000.00
cmlezwxzh00qz39t5o5do399b	cmlezwxzh00qy39t5fwxae4a7	103000.00
cmlezwy8900r839t5bfhl0xqb	cmlezwy8900r639t5y9vldajh	108000.00
cmlezwyfv00rp39t5vp9da4pj	cmlezwyfv00ro39t57xvk6ea3	71000.00
cmlezwyqm00s139t5v3zlna93	cmlezwyqm00rx39t5jb99152m	81000.00
cmlezwyww00s939t5fthwno7t	cmlezwyww00s839t57bgt2335	101000.00
cmlezwz5500st39t5ozununfr	cmlezwz5500ss39t5xaf3n3p5	65000.00
cmlezwzaw00tb39t5fkq4dcxs	cmlezwzaw00ta39t59nqnvcvd	165000.00
cmlezwzha00tr39t5un2o4e4w	cmlezwzha00tq39t5exvf84ib	65000.00
cmlezwzmi00u939t5lcg2euhy	cmlezwzmi00u839t53eifb2i6	129000.00
cmlezwzuv00ur39t5t3qx1jm9	cmlezwzuv00uq39t511emgv0z	190000.00
cmlezx02400vb39t56z2q0atl	cmlezx02400va39t5vwjekqut	78000.00
cmlezx08q00vp39t5fctgbnlf	cmlezx08q00vo39t58oc7l2sd	174000.00
cmlezx0ht00w739t5ad51n0e7	cmlezx0ht00w639t504pliwj3	70000.00
cmlezx0q500wp39t50t7cwymy	cmlezx0q500wo39t5m3h8qzvc	69000.00
cmlezx0wk00x739t5y7sco3l5	cmlezx0wk00x639t5a725sdw2	109000.00
cmlezx18k00xr39t5co58avkl	cmlezx18j00xa39t5fgl3j6a6	69000.00
cmlezx1ed00xz39t5ebz0ba2u	cmlezx1ed00xy39t5rg0pgm46	47000.00
cmlezx1k900y339t55d88jaq9	cmlezx1k800y239t59x3t8s5k	52000.00
cmlezx1re00ym39t5669y94w2	cmlezx1re00yi39t595y3utva	44000.00
cmlezx1xa00z539t5gxvs9zfa	cmlezx1xa00z339t5wjqmsxzl	56000.00
cmlezx23m00zp39t5036sk8x5	cmlezx23l00zm39t5sycurinv	36000.00
cmlezx2bq010939t5296iaqzl	cmlezx2bq010839t5rji7qkb1	37000.00
cmlezx2hj010r39t5h0rb477c	cmlezx2hj010q39t57sbebsqt	32000.00
cmlezx2mw011939t5bnejy0sh	cmlezx2mw011839t5ux7d37pd	30000.00
cmlezx2tc011r39t5a4vwo2sr	cmlezx2tc011q39t5d1gpja05	23000.00
cmlezx31z012539t5zr2q1260	cmlezx31z012439t5phybi4rz	25000.00
cmlezx3x6013939t5yjc1i8me	cmlezx3x5013639t5zvm0u1sd	34000.00
cmlezx46i013j39t5jd4t5nr2	cmlezx46i013i39t5ff52h2ht	79000.00
cmlezx4en014239t5cptrum7k	cmlezx4en013y39t5n1kxhj2y	125000.00
cmlezx4no014c39t5bpbswfuq	cmlezx4no014b39t5qzpjiqe8	1012000.00
cmlezx4yp014y39t5jedngvo0	cmlezx4yp014v39t5srmftyoi	200000.00
cmlezx58i015939t582rnk2ol	cmlezx58i015839t5mhqm3pmq	495000.00
cmlezx5gm015r39t5bkly5t0a	cmlezx5gm015p39t5hsqrztji	469000.00
cmlezx5p7016439t5rxc7gna8	cmlezx5p7016239t56wsoqiex	99000.00
cmlezx5yf016i39t5rt6otute	cmlezx5yf016h39t5cuprurg2	57000.00
cmlezx6af017739t5ug3ysma1	cmlezx6af017639t503xfwy7e	66000.00
cmlezx6sk017t39t5cjt5xf5d	cmlezx6sk017s39t5qi2mo2rh	85000.00
cmlezx71b018b39t5xnnfzdvr	cmlezx71b018a39t5974y4560	104000.00
cmlezx7g0018o39t5iea3wgwb	cmlezx7g0018m39t55oof07wk	95000.00
cmlezx7na019739t5cq9dtk17	cmlezx7na019639t5rre08nel	30000.00
cmlezx7uo019o39t5izjb1zzm	cmlezx7un019m39t5ru6mojnu	25000.00
cmlezx82x01a139t5ut2hqdi5	cmlezx82x019z39t5e82rpyvx	37000.00
cmlezwifq004z39t5zahtbe2m	cmlezwifp004y39t5ffc1a8oi	197000.00
cmlezwip1005d39t5337v9cuv	cmlezwip1005c39t54u8b8eby	983000.00
cmlezwjtv005j39t5o9ac4zob	cmlezwjtv005i39t57hpzfmxy	62000.00
cmlezwk4o006f39t526na9vll	cmlezwk4n006e39t5sg3vmyfd	62000.00
cmlezwkhb007739t59wauuzz0	cmlezwkhb007639t5mdrvcqra	189000.00
cmlezwkrz007p39t5dyuq48ar	cmlezwkrz007o39t5chnlaz8n	145000.00
cmlezwl1z008739t5kisx9bgh	cmlezwl1z008639t5r340ixzn	86000.00
cmlezwlco008p39t5y0i3hcvs	cmlezwlco008o39t5e5i0cgdq	91000.00
cmlezwllh009539t59embge6h	cmlezwllh009439t545rxxi8q	82000.00
cmlezwlsy009n39t560ohbdct	cmlezwlsy009m39t58okg9omc	113000.00
cmlezwm5v00a939t5r4o75sz2	cmlezwm5v00a639t5lvwndt6z	98000.00
cmlezwmfp00am39t5pb05hqoe	cmlezwmfp00al39t57ceo2n7r	95000.00
cmlezwngc00bh39t5lap2zp34	cmlezwngc00bg39t51xny6f60	129000.00
cmlezwnqi00bz39t59g84cgfi	cmlezwnqi00bx39t5v5uno8w4	128000.00
cmlezwoc500d839t5kat9qr6h	cmlezwoc500d639t55l03bta4	90000.00
cmlezwokd00dp39t5jb0yl7ck	cmlezwokd00do39t534bmw9mg	81000.00
cmlezwosy00e939t5b0oxe5nc	cmlezwosy00e839t5jn7zgudm	153000.00
cmlezwozt00el39t5o2vx15mx	cmlezwozt00ek39t5ljzcw1wa	101000.00
cmlezwpt200f339t55ceo9b9w	cmlezwpt200f239t5boz4tolu	47000.00
cmlezwqhg00fk39t5s69uqo7s	cmlezwqhg00fi39t5pmq4oety	98000.00
cmlezwqtd00fz39t52mys41ms	cmlezwqtd00fy39t5ziomdhbb	61000.00
cmlezwr2j00gj39t5hir2cb2p	cmlezwr2j00gh39t5hrz3mg8z	81000.00
cmlezwrgo00gp39t5ah3e8gbp	cmlezwrgo00go39t57fp4rd7t	89000.00
cmlezwrrg00hb39t5jsv1es6l	cmlezwrrg00h839t5q14w6wz2	57000.00
cmlezws1c00hs39t50l238fgr	cmlezws1c00hq39t5bpbvmdgd	171000.00
cmlezwsbq00ie39t5lwbrussp	cmlezwsbq00ic39t5onnsd6g0	146000.00
cmlezwsjt00ix39t55a16js8i	cmlezwsjt00iv39t57pyamzz2	249000.00
cmlezwtic00jh39t5g8byx2xv	cmlezwtic00jg39t52dmdki4k	139000.00
cmlezwtw300jz39t5mvwjztj6	cmlezwtw300jx39t5u0da0bls	243000.00
cmlezwua400kh39t5x5aayawa	cmlezwua300kg39t5rp9jbjst	61000.00
cmlezwuik00kt39t55vijnxs6	cmlezwuik00ks39t5tplfhmu9	121000.00
cmlezwurr00lc39t5zvpszcbk	cmlezwurr00la39t5nwxo0298	56000.00
cmlezwuys00lr39t54w5h57r7	cmlezwuys00lq39t5kf3lv7t8	159000.00
cmlezwvmw00md39t552m0478g	cmlezwvmw00m839t564xbpoq1	87000.00
cmlezwvx400my39t5xw383udk	cmlezwvx400mv39t5fpmf7o6j	198000.00
cmlezww4i00nh39t5d2s1v800	cmlezww4i00nc39t5fzze9jdk	108000.00
cmlezwwe400ny39t5p3dhku3e	cmlezwwe400nv39t52xy5q2a0	345000.00
cmlezwwo300of39t5wgjdvib7	cmlezwwo300oc39t5yq4ojwc9	58000.00
cmlezwwye00ow39t5x9gig0cr	cmlezwwye00ou39t5jnum5dwf	56000.00
cmlezwx6z00pd39t5599iui53	cmlezwx6z00pc39t5901e9sfa	65000.00
cmlezwxen00pr39t5lonkk2c5	cmlezwxen00pq39t5hwlagh7k	63000.00
cmlezwxl400q539t5bc2wnvca	cmlezwxl400q439t5w6wqaym5	254000.00
cmlezwxrp00qh39t50z4xziu8	cmlezwxrp00qg39t5u7h4vpln	72000.00
cmlezwxyg00qv39t52ngt76qb	cmlezwxyg00qt39t551meijmx	195000.00
cmlezwy8w00rf39t55nqpa1aj	cmlezwy8w00rc39t5fggakqba	65000.00
cmlezwyqm00s039t52qg242dz	cmlezwyqm00rw39t5hoq0m7o1	92000.00
cmlezwyyi00sg39t5kdtd1rrj	cmlezwyyi00sd39t5uzfynvhc	86000.00
cmlezwz6q00sz39t57pcajq92	cmlezwz6q00sy39t5jbp9gb8h	93000.00
cmlezwzc600td39t5p1jlrpgr	cmlezwzc600tc39t53h4kr0hw	92000.00
cmlezwzi500tx39t52ecoafh0	cmlezwzi500tw39t5lfgp0153	60000.00
cmlezwzov00uf39t51hiba8v0	cmlezwzov00ud39t52q6236fb	94000.00
cmlezwzwk00uv39t5vy5wixlt	cmlezwzwk00uu39t57czikg0t	170000.00
cmlezx02z00ve39t5nnv549mf	cmlezx02z00vd39t536tut3qf	153000.00
cmlezx0bg00w539t55pe1qopp	cmlezx0bg00w439t5yfl2bz1s	82000.00
cmlezx0kx00wj39t5kxsunwq2	cmlezx0kx00wi39t5ktr2s13d	76000.00
cmlezx0st00wz39t51quxfv96	cmlezx0st00wy39t540i46jjf	64000.00
cmlezx18j00xl39t5y647x6s1	cmlezx18j00xj39t59aj81nov	56000.00
cmlezx1lj00ya39t5lpcpasif	cmlezx1lj00y839t5ka6064xe	38000.00
cmlezx1sx00yt39t5vnyuejiw	cmlezx1sx00ys39t5o2kksxmx	13000.00
cmlezx1xv00z939t5m1tk5ewe	cmlezx1xv00z839t5g3xxitij	65000.00
cmlezx24b00zr39t524qt1q3u	cmlezx24b00zq39t54jr1t6wh	52000.00
cmlezx2bn010539t5t4b7ccft	cmlezx2bn010439t5urpi4yuv	35000.00
cmlezx2je010v39t5p6e81l71	cmlezx2je010s39t5vf69hjx8	114000.00
cmlezx2sl011n39t5aq93qeh3	cmlezx2sk011m39t5znkdzum5	60000.00
cmlezx30d012139t55ebwhwye	cmlezx30d012039t5rnbijuzw	27000.00
cmlezx37b012j39t5il3uj1k3	cmlezx37b012i39t58pm65gxl	26000.00
cmlezx3x5013839t5rhueifcu	cmlezx3x5013539t5x6t763sy	51000.00
cmlezx46j013o39t5w7b6jrly	cmlezx46j013l39t5exg9xn6l	59000.00
cmlezx4dk013w39t56fh2naza	cmlezx4dk013u39t5lewp8hnt	162000.00
cmlezx4oq014n39t555i3zfqb	cmlezx4oq014m39t5ahm3dno9	47000.00
cmlezx59p015h39t58ivxqv1h	cmlezx59p015g39t51f7nxwaz	899000.00
cmlezx68w017439t5htu1d3ca	cmlezx68w017339t5r95kjpiy	102000.00
cmlezx6or017h39t5b1fm9sbv	cmlezx6or017g39t5cbpjuoqy	203000.00
cmlezx6x0018139t5b6zd4rxl	cmlezx6x0018039t5qkauombc	111000.00
cmlezx7g0018p39t50brougm5	cmlezx7g0018n39t53y3f1tvd	60000.00
cmlezx7mt018z39t5tw00m4vb	cmlezx7mt018y39t5jrd9nvoo	143000.00
cmlezx7th019h39t5yhi54oye	cmlezx7th019f39t5r28v42jk	29000.00
cmlezx801019v39t59rtnucrc	cmlezx801019t39t560zmbecs	30000.00
cmlezx88k01ab39t5vro0ja4o	cmlezx88j01aa39t59glaqxo2	29000.00
cmlezx8fn01at39t5zsse9hlu	cmlezx8fn01as39t52y5bpi5z	32000.00
cmlezx8l301bd39t5d359xzwo	cmlezx8l301bc39t5hldc9ala	31000.00
cmlezx8r101bv39t5lo18ffey	cmlezx8r001bu39t5mch7d3u4	43000.00
cmlg3mb340001vu8yztfb590d	cmlg3mb340000vu8yv3to3zdt	50000.00
cmlg3mbd50003vu8y2rmgbfb4	cmlg3mbd50002vu8yx8m0qid7	92000.00
cmlg3mbm10005vu8yiwbe1fpv	cmlg3mbm10004vu8yhoje2otr	93000.00
cmlg3mc4k000avu8yluhyvao3	cmlg3mc4k0006vu8y3n86dfyj	77000.00
cmlg4392z0023pv85k5ecfan7	cmlg4392z0021pv85riluq3c3	82000.00
cmlg439cl002dpv857v915mp8	cmlg439cl002cpv85kxn6eb7l	125000.00
cmlezwihj005139t5qpjg0o6y	cmlezwihj005039t548ppfyst	164000.00
cmlezwir4005f39t5ghfobpw6	cmlezwir4005e39t5i989asyt	179000.00
cmlezwjtv005w39t5x1g7sw6x	cmlezwjtv005u39t51xcwe0e7	62000.00
cmlezwjzk005z39t557aav3hy	cmlezwjzk005y39t5oukax9vr	228000.00
cmlezwk6j006l39t5gjhkujtq	cmlezwk6j006h39t5sderiqcw	74000.00
cmlezwkdl006x39t5sxca8a31	cmlezwkdk006v39t5wgy0tcpg	93000.00
cmlezwkn0007h39t5ttmikx8r	cmlezwkn0007f39t5hsb3krdq	145000.00
cmlezwkue007t39t5886mjitj	cmlezwkud007r39t5147gm6z8	251000.00
cmlezwl6f008d39t5o51qwhzf	cmlezwl6f008c39t5kfzkr0yv	124000.00
cmlezwlkl009339t5y9hadbci	cmlezwlkl009239t5ezunedlb	149000.00
cmlezwlsy009l39t5mtv6bqg2	cmlezwlsy009k39t5b7brkes9	119000.00
cmlezwm4700a539t50kli1szl	cmlezwm4700a439t5b8504xpi	82000.00
cmlezwme400ah39t5p8d97g80	cmlezwme400ag39t515xmrtc4	95000.00
cmlezwmll00az39t58kgjjawr	cmlezwmll00aw39t5broev44s	147000.00
cmlezwngc00b939t511hvlz2k	cmlezwngc00b439t5s96pfylq	128000.00
cmlezwnmx00bn39t5tv8x4rqf	cmlezwnmx00bl39t5kvp8qdgq	153000.00
cmlezwnue00c439t51yl4e0z7	cmlezwnue00c139t56dfsba9k	141000.00
cmlezwo2p00cf39t55i04y1im	cmlezwo2p00ce39t5972eg7wy	128000.00
cmlezwo8l00ct39t58cfhybb7	cmlezwo8l00cs39t5fh3cuvtx	103000.00
cmlezwoe100dd39t5dswj03s4	cmlezwoe100dc39t5prq5agus	128000.00
cmlezwol200dr39t5hlheahud	cmlezwol200dq39t5znwk4tpf	85000.00
cmlezwos200e639t5izlgxtfh	cmlezwos200e539t5ukmetyoc	56000.00
cmlezwp0x00er39t592rf2hfb	cmlezwp0x00eq39t5lqqnxsmg	71000.00
cmlezwq1300f739t588iituw8	cmlezwq1300f639t5mh9he0xs	63000.00
cmlezwqi700fn39t53yyh8sa6	cmlezwqi700fm39t5n9ugjr61	95000.00
cmlezwquq00g339t58mf4slok	cmlezwquq00g239t5msyr4g85	84000.00
cmlezwr3b00gl39t51rmf9sa0	cmlezwr3b00gk39t5b9vp25tz	116000.00
cmlezwrgo00gr39t5nznt6dmz	cmlezwrgo00gq39t5vf3x7qae	63000.00
cmlezwrtm00hl39t5l1hzutyj	cmlezwrtm00hk39t5wd0ncg98	81000.00
cmlezws4x00i339t5d4f2vcth	cmlezws4x00i039t5r2zbt414	212000.00
cmlezwsgm00ik39t5x9s51wmb	cmlezwsgm00ii39t52lzoq3f9	145000.00
cmlezwt7w00jc39t5ctawkohz	cmlezwt7w00ja39t5s192bkwv	157000.00
cmlezwttw00ju39t5lpkhcspp	cmlezwttw00js39t5kdfbj8tu	69000.00
cmlezwu7h00kb39t5vqk27k5c	cmlezwu7h00ka39t5edrm0imr	83000.00
cmlezwuhh00kr39t54wxfqf5u	cmlezwuhh00kq39t5zb0ds15t	198000.00
cmlezwuq600l939t5qtk9zxcm	cmlezwuq600l839t57yw5vbhk	56000.00
cmlezwv0v00lx39t5gxm89xdn	cmlezwv0u00lw39t5rpem4xqt	204000.00
cmlezwvmw00mb39t59qan6zbo	cmlezwvmw00m739t598g468vx	197000.00
cmlezww0100n539t5gmjh4b1o	cmlezww0100n339t5pwgws5aw	155000.00
cmlezww7h00nn39t5whuo4yal	cmlezww7h00nl39t5xyicdl83	83000.00
cmlezwwkj00o539t51m4y1pso	cmlezwwkj00o339t5p3cxpk5f	219000.00
cmlezwwxl00or39t5mttjjpj5	cmlezwwxl00oo39t5dpd9clg1	91000.00
cmlezwxpx00qd39t5exvk9a7w	cmlezwxpx00qc39t5t5mlys2i	80000.00
cmlezwxwx00qr39t5oi0zlqbw	cmlezwxwx00qq39t558pe52fi	79000.00
cmlezwy5y00r539t513l2k0a6	cmlezwy5y00r439t5vyffhcnm	88000.00
cmlezwydx00rn39t5oo2slxwo	cmlezwydx00rm39t50a93wt9m	123000.00
cmlezwyqm00rz39t58yclw9jq	cmlezwyqm00rs39t5u7a8v8ms	92000.00
cmlezwyzd00sm39t5xf20qrks	cmlezwyzd00sk39t556h7oega	88000.00
cmlezwz7g00t339t5ns8iolnj	cmlezwz7g00t239t5qsgpotuq	150000.00
cmlezwzdz00tp39t54wz2t8ve	cmlezwzdz00tn39t5rcvhv0xz	78000.00
cmlezwzkh00u339t5a5wh9ji0	cmlezwzkh00u239t5n2n0xccx	170000.00
cmlezwzt100un39t5tcdoaf4u	cmlezwzt100um39t5dc7ixo3y	111000.00
cmlezwzyi00v139t57w9oln3i	cmlezwzyh00v039t5zhj4z55w	78000.00
cmlezx04c00vh39t5e8xtvk05	cmlezx04c00vg39t5zzc93jmi	83000.00
cmlezx0ab00vx39t50xya98uq	cmlezx0ab00vw39t5w4n0u4p4	78000.00
cmlezx0j200wf39t51jcaw2gn	cmlezx0j200we39t5vjz7he4l	121000.00
cmlezx0qd00wr39t5fyoutww9	cmlezx0qd00wq39t5wfv4ojm0	64000.00
cmlezx0xb00x939t5t9b7wypx	cmlezx0xb00x839t50f03ak1o	93000.00
cmlezx18j00xp39t5ka1rt1hf	cmlezx18j00xo39t5xo4r4zkc	32000.00
cmlezx1ed00xx39t54r38ozhp	cmlezx1ed00xw39t5gx6ef69f	52000.00
cmlezx1k900y539t5mfqurip6	cmlezx1k900y439t5azfq0zpe	41000.00
cmlezx1re00yl39t5h8fo0289	cmlezx1re00yj39t5v16bbviy	45000.00
cmlezx1xc00z739t5ylcy814q	cmlezx1xc00z639t5pf183wj8	37000.00
cmlezx23l00zn39t50oin7kuh	cmlezx23l00zl39t56tlqz4ts	123000.00
cmlezx2bv010b39t56nql3jtn	cmlezx2bv010a39t5yaw4r1js	81000.00
cmlezx2hc010p39t52006p3gf	cmlezx2hc010o39t5f2hgq8qt	106000.00
cmlezx2mm011539t5fsgu6y1c	cmlezx2mm011439t5u3irtp11	82000.00
cmlezx2rt011j39t5ldoitfn7	cmlezx2rt011h39t5uv19btuu	32000.00
cmlezx2yv011y39t5lte4crm1	cmlezx2yv011w39t56kqtcx1n	28000.00
cmlezx36j012h39t55ilhm9xl	cmlezx36j012g39t57efp7pmu	24000.00
cmlezx3yf013b39t5wjsd72d4	cmlezx3yf013a39t5qg6dgqtq	34000.00
cmlezx4bz013t39t5j60fzt9e	cmlezx4bz013s39t5lxup26wz	59000.00
cmlezx4no014d39t5gllyu4wv	cmlezx4no014a39t50013m1cr	130000.00
cmlezx54y015339t5n4kuu4mo	cmlezx54y015139t59o0g0bdi	486000.00
cmlezx5cj015j39t52fz2l830	cmlezx5cj015i39t5t0agcs87	98000.00
cmlezx5ka015x39t5cpth3ids	cmlezx5k9015w39t5fafj9oiw	151000.00
cmlezx5s2016b39t5d3qn8ln7	cmlezx5s2016a39t5188j23l9	64000.00
cmlezx67k016y39t5nsqu40c7	cmlezx67k016w39t5z9q5t7nz	60000.00
cmlezx6kd017f39t529pucm6s	cmlezx6kd017c39t541rw0ra1	64000.00
cmlezx6t9017x39t5igbro3w4	cmlezx6t9017u39t55iacwaf8	108000.00
cmlezx7gw018v39t5tit8zya1	cmlezx7gw018u39t5kiiirnqp	279000.00
cmlezx7o0019939t5dtvnd5jy	cmlezx7o0019839t5cpzhp7me	44000.00
cmlezx7vj019r39t516fd4rou	cmlezx7vj019q39t5hsno0ola	31000.00
cmlezx84001a539t5vrc14697	cmlezx83z01a439t52sb7pcix	36000.00
cmlezx8bm01an39t53369i78t	cmlezx8bm01am39t5921nh9mx	30000.00
cmlezx8i001az39t5fhxw3j1p	cmlezx8hz01ay39t58vr48wqg	42000.00
cmlezx8nw01bl39t5w6om0408	cmlezx8nw01bk39t54ll787nv	77000.00
cmlezwik3005539t5iyx4d411	cmlezwik2005439t54cukxel4	221000.00
cmlezwisq005h39t5580kn553	cmlezwisq005g39t5huidcr6e	1121000.00
cmlezwjtv005o39t5m599w6kd	cmlezwjtv005k39t52ul0frgl	36000.00
cmlezwk06006339t5n1r8t96y	cmlezwk06006239t5xr06c8li	193000.00
cmlezwk6j006k39t5z0vp64x9	cmlezwk6j006i39t5dq34kcf0	196000.00
cmlezwkdl006w39t50r9rbco3	cmlezwkdk006u39t5yuw11f50	93000.00
cmlezwkn0007g39t5cdc8bdjy	cmlezwkn0007e39t5dzg2pu0c	231000.00
cmlezwkyv008339t5kui51y5r	cmlezwkyv008239t5tezu010x	113000.00
cmlezwl87008l39t53qt4kud2	cmlezwl87008k39t502qv6osk	93000.00
cmlezwlhx008x39t5fo91q2j7	cmlezwlhx008w39t5f486sqjl	88000.00
cmlezwlpk009d39t575enjukr	cmlezwlpk009c39t5av6i2oek	113000.00
cmlezwlzc009x39t5swi76msi	cmlezwlzc009v39t5hb9d2for	96000.00
cmlezwmag00ad39t53p97n9me	cmlezwmag00ab39t58jlqdr25	91000.00
cmlezwmi500as39t5bm16swmt	cmlezwmi500aq39t5tce67auv	192000.00
cmlezwngc00b839t5cvvozu2z	cmlezwngc00b339t5x1haagc3	138000.00
cmlezwnp200bq39t5ffua7lfv	cmlezwnp200bo39t5hy0v3ntq	133000.00
cmlezwnzm00cd39t5ujx5r1t0	cmlezwnzm00cb39t5crkb63jy	56000.00
cmlezwo5o00cr39t5sn33jp7a	cmlezwo5o00cp39t5twtd57ct	94000.00
cmlezwobn00d339t57iqpq0tv	cmlezwobn00d239t57gpv2lob	57000.00
cmlezwook00dv39t5jkvs63ef	cmlezwook00du39t5z9mfvquq	81000.00
cmlezwoxd00eg39t5rmszbojq	cmlezwoxc00ed39t57qt98ntj	44000.00
cmlezwpbh00ev39t5k9ino4fd	cmlezwpbh00eu39t5zuvst7xb	97000.00
cmlezwqff00ff39t5syl7plb4	cmlezwqff00fe39t5uhughthk	64000.00
cmlezwqqq00fv39t5149jazq2	cmlezwqqq00fu39t5xutv815g	157000.00
cmlezwqzr00g939t5nkotjpa1	cmlezwqzr00g839t5pq5yu929	66000.00
cmlezwrgo00gn39t5d7fhyaz8	cmlezwrgo00gm39t5w68b4rmt	91000.00
cmlezwrsq00hg39t5tvccg17a	cmlezwrsq00hd39t5a1cxdk3i	171000.00
cmlezws3z00hz39t54czf7s16	cmlezws3z00hy39t5luxoc7dx	128000.00
cmlezwscn00ih39t5e0hgj6om	cmlezwscn00ig39t5iwjye77c	145000.00
cmlezwsld00iz39t55icxx6dd	cmlezwsld00iy39t5l58dhbzz	222000.00
cmlezwtgh00jf39t5xvu103gg	cmlezwtgh00je39t5o3jam5nt	222000.00
cmlezwtw300jy39t5en557ply	cmlezwtw300jw39t5x5v7vfgq	179000.00
cmlezwua300kf39t5l13e8t1g	cmlezwua300ke39t53ltunlko	26000.00
cmlezwuj400kx39t5l1qcesc9	cmlezwuj400kv39t56zhilk09	93000.00
cmlezwurr00ld39t550bkuezz	cmlezwurr00lb39t5p0s0zix2	67000.00
cmlezwv0v00lz39t5s97uts88	cmlezwv0v00ly39t5oe2y5a41	173000.00
cmlezwvmw00mj39t5nun9tfo6	cmlezwvmw00mi39t5t02gj9r2	164000.00
cmlezwvx400mz39t5o29ft2ig	cmlezwvx400mx39t50k7ztnav	57000.00
cmlezww4i00ne39t5hxqnto2h	cmlezww4i00nd39t5ownslj6s	93000.00
cmlezwwe400nz39t54gjudm5m	cmlezwwe400nw39t57a2gyhgj	219000.00
cmlezwwo400oh39t5kfk3i4b4	cmlezwwo300og39t5dbck2kj5	164000.00
cmlezwwye00ox39t5cyg38apg	cmlezwwye00ot39t5hlu35qcm	52000.00
cmlezwx5j00p939t5zp5joxv7	cmlezwx5j00p739t503jjli8n	109000.00
cmlezwxdq00pn39t5ry334e3t	cmlezwxdq00pl39t5x63c6c8z	219000.00
cmlezwxkf00q339t5c03smk1m	cmlezwxkf00q039t5zrj9zj3l	56000.00
cmlezwxt500qn39t58j9vrof8	cmlezwxt500qm39t543y93r5t	84000.00
cmlezwxz500qx39t5vb320jmn	cmlezwxz500qw39t5rcbbf8gg	91000.00
cmlezwy8w00rd39t5f17y8i06	cmlezwy8w00rb39t51jar0x7r	191000.00
cmlezwyqm00s539t5ulbngg3d	cmlezwyqm00s339t5fxtxovw6	123000.00
cmlezwyzd00so39t5qq2i3ni3	cmlezwyzd00sl39t5r1pn99tl	101000.00
cmlezwz8300t739t5dh76veev	cmlezwz8300t639t5bkuq2i9w	92000.00
cmlezwzdz00to39t5m9ncjajy	cmlezwzdz00tm39t5ol9oypoz	179000.00
cmlezwzjv00u139t52rzbgnzm	cmlezwzjv00u039t51nq2jlh4	179000.00
cmlezwzq400uj39t5w1b3k06m	cmlezwzq400ui39t58ou2nv3j	129000.00
cmlezwzyk00v339t5cvw93fmz	cmlezwzyk00v239t5jdc7iy0g	179000.00
cmlezx04y00vl39t5x0x1rjzu	cmlezx04y00vi39t5sd4n7w8f	91000.00
cmlezx0ap00w139t56h59k1r5	cmlezx0ap00w039t53susxqxt	98000.00
cmlezx0lj00wl39t55qbagk2i	cmlezx0lj00wk39t5v6bcyrhp	77000.00
cmlezx0to00x539t5bouyuzil	cmlezx0to00x439t5mj9436uc	76000.00
cmlezx18j00xe39t50l03pk1o	cmlezx18j00xb39t5k2t3n3f0	165000.00
cmlezx1e800xv39t5g2brdx7a	cmlezx1e800xu39t5xn7f2lew	40000.00
cmlezx1re00yp39t5q1g2c0am	cmlezx1re00yo39t5e55cu8e7	86000.00
cmlezx1xa00z439t5l6c5mxw6	cmlezx1xa00z239t5hj0e0b9u	46000.00
cmlezx23m00zo39t50i6rx460	cmlezx23l00zk39t5ls4jr8vy	83000.00
cmlezx2b1010339t5dqmxorx0	cmlezx2b1010239t5v5dej6ys	118000.00
cmlezx2g3010j39t5sk7mobfq	cmlezx2g3010h39t5v1ccyctf	82000.00
cmlezx2ln011039t56tw30frv	cmlezx2ln010y39t518nvmi0z	46000.00
cmlezx2r0011f39t5xbvmdjg4	cmlezx2r0011d39t5ms9wjul7	67000.00
cmlezx33k012b39t5jywl16au	cmlezx33k012a39t50f55usnh	26000.00
cmlezx38p012l39t5gsimuebk	cmlezx38o012k39t5581352wg	119000.00
cmlezx3w8012z39t59stbbe6c	cmlezx3w8012x39t5oogdi69v	55000.00
cmlezx450013g39t5ze3j1ocq	cmlezx450013d39t5n9pbskvb	128000.00
cmlezx4dk013x39t5mihkp46b	cmlezx4dk013v39t5223pahhq	104000.00
cmlezx4oq014f39t56za3hnpx	cmlezx4oq014e39t5sdzkpnvi	737000.00
cmlezx4yp014w39t5lmal6mda	cmlezx4yp014t39t56asmqvvv	162000.00
cmlezx57z015739t5h5pxy9mr	cmlezx57z015639t52j0korrc	151000.00
cmlezx5fv015n39t50qcmhoim	cmlezx5fv015m39t5ys9zkx4r	86000.00
cmlezx5o4016139t5c0s3s2h3	cmlezx5o4016039t5rfet8b4q	105000.00
cmlezx5w4016f39t5k5ikf8xj	cmlezx5w4016e39t52lcxzelw	331000.00
cmlezx651016t39t5sw6c0xj6	cmlezx651016s39t5eccsif39	79000.00
cmlezx6f1017939t586rizk81	cmlezx6f1017839t5tpuhnqmz	116000.00
cmlezx6qp017l39t5bkjpjiss	cmlezx6qp017k39t53bcjihsf	219000.00
cmlezx6z4018539t58z1rdm5x	cmlezx6z4018439t5juq4rjya	544000.00
cmlezx7g0018l39t5ot0qdrkv	cmlezx7g0018h39t5rdh87buw	50000.00
cmlezx7my019539t5ztt6aogr	cmlezx7my019339t5kuhxlp9o	218000.00
cmlezx7uo019p39t5t9og6yjj	cmlezx7uo019n39t5wlb278uz	27000.00
cmlezx82x01a339t52cahpyzt	cmlezx82x019x39t5xuqthy5q	31000.00
cmlezx8aw01al39t5mc33fvhn	cmlezx8aw01ak39t5zrhfpy9g	26000.00
cmlezwiku005739t5i1n7vtmc	cmlezwiku005639t5libj63vc	171000.00
cmlezwjtv005t39t5x2onofje	cmlezwjtv005s39t54hw4vcno	217000.00
cmlezwk0y006a39t52op42c0g	cmlezwk0y006839t5urc5e8dj	95000.00
cmlezwk89006p39t59dibcu2l	cmlezwk89006o39t5cd34lfe1	98000.00
cmlezwkf3007339t5o7p0vjk6	cmlezwkf2007139t5sz4jblix	78000.00
cmlezwkp9007l39t5hu1yeh9m	cmlezwkp9007k39t5p7z1f4y3	91000.00
cmlezwkyt008139t559ysh8sm	cmlezwkyt008039t50x3vacqm	89000.00
cmlezwl87008j39t5sqop79q8	cmlezwl87008i39t51hxkig4s	81000.00
cmlezwlhx008z39t52rs4vjaq	cmlezwlhx008y39t5rogglibc	98000.00
cmlezwlqn009h39t5gv4a0ih6	cmlezwlqn009e39t5b11mym4q	145000.00
cmlezwngd00bj39t5mqu7wqsj	cmlezwngc00bi39t56g2tpzh4	95000.00
cmlezwnqi00by39t590cbfdgx	cmlezwnqi00bw39t5ikevsdc6	138000.00
cmlezwoc500d939t5czdc2teq	cmlezwoc500d739t5yhqh87d9	102000.00
cmlezwojr00dm39t5trxg6syq	cmlezwojr00dk39t5uxsjx2wy	133000.00
cmlezwos200e339t5b9h31spt	cmlezwos100e239t574huqwii	55000.00
cmlezwozu00en39t5xqcsgzgp	cmlezwozu00em39t5xvm1nzs3	93000.00
cmlezwq1300f939t5q1b9hq9a	cmlezwq1300f839t5zqzwu7aa	74000.00
cmlezwqju00fr39t524ln66wh	cmlezwqju00fq39t5e64nb7q4	97000.00
cmlezwqvp00g539t51jbqm4t1	cmlezwqvp00g439t51r2pt9rb	166000.00
cmlezwrhk00h339t5miggfqvn	cmlezwrhk00h239t5qzpt3y76	96000.00
cmlezwrsq00hf39t5t2voreor	cmlezwrsq00hc39t5cwbiyjhq	151000.00
cmlezws2q00hv39t5atjot5xf	cmlezws2q00hu39t5hd82bv4v	171000.00
cmlezwsb400ib39t5yeork8va	cmlezwsb400ia39t5tm45r3mp	71000.00
cmlezwsjt00iw39t5779semrl	cmlezwsjt00iu39t5b8fy47o9	249000.00
cmlezwt7w00jd39t5kvh5bt0r	cmlezwt7w00jb39t5be5s7hu3	157000.00
cmlezwttw00jv39t55sspxok0	cmlezwttw00jr39t5sr533w44	73000.00
cmlezwu8f00kd39t5tf5za8vx	cmlezwu8f00kc39t5eco24nkm	179000.00
cmlezwuj400kw39t5113cdy3j	cmlezwuj400ku39t5ppkj9nl3	79000.00
cmlezwusl00lj39t5idom0or9	cmlezwusl00lg39t5f6miwh7d	31000.00
cmlezwuzy00lt39t52x7k6y4t	cmlezwuzx00ls39t5ag6csh5s	121000.00
cmlezwvmw00mc39t5wg1njq3i	cmlezwvmw00m639t5owjcnqcs	197000.00
cmlezww0100n439t5yqpyoj3o	cmlezww0100n239t5r5uvh7lp	276000.00
cmlezww7h00nm39t56fu71hkg	cmlezww7h00nk39t5clwx313t	121000.00
cmlezwwkj00o439t5xjic0tt0	cmlezwwkj00o239t536lq33ll	358000.00
cmlezwwxl00oq39t5dm0w5kxo	cmlezwwxl00on39t5mtogu39a	166000.00
cmlezwx4600p339t5ih4ieilh	cmlezwx4500p139t5slw5858s	165000.00
cmlezwxbl00pj39t5h5jylx5m	cmlezwxbl00ph39t56r8ztdin	42000.00
cmlezwxit00px39t5z8q1ovkr	cmlezwxit00pw39t5k3ofimkt	269000.00
cmlezwxpx00qf39t51dq2k7xw	cmlezwxpx00qe39t54cinwunu	83000.00
cmlezwycn00rl39t5anful7ut	cmlezwycn00ri39t57dl3jq5b	78000.00
cmlezwyqm00ru39t59w90q3du	cmlezwyql00rr39t5ei3kyu08	123000.00
cmlezwyyi00sj39t5mlb284gs	cmlezwyyi00sh39t5p46ofh6c	123000.00
cmlezwz6o00sx39t57gf0laho	cmlezwz6o00su39t51uwq1oxl	108000.00
cmlezwzcf00th39t5o2t1rty7	cmlezwzcf00tg39t5ud6tsqmq	179000.00
cmlezwzj900tz39t5twzemu2r	cmlezwzj900ty39t5hya0emjo	114000.00
cmlezwzph00uh39t56wrjxty7	cmlezwzph00ug39t53vt80cx1	94000.00
cmlezwzyw00v539t5viphi9o6	cmlezwzyv00v439t5i03n4dnk	85000.00
cmlezx04y00vk39t5daabj1by	cmlezx04y00vj39t5t45kxwej	90000.00
cmlezx0av00w339t5utygcypp	cmlezx0av00w239t5xdatjof9	107000.00
cmlezx0iu00wd39t5f26huu5r	cmlezx0iu00wb39t5nkte5ep9	84000.00
cmlezx0r100ww39t5wcetphof	cmlezx0r100wu39t5ocnwurou	65000.00
cmlezx18j00xf39t57uhaz10n	cmlezx18j00xc39t5zukhrc77	70000.00
cmlezx1lj00yb39t5p6peapwl	cmlezx1lj00y939t5ru97qwzd	130000.00
cmlezx1sc00yr39t5k3u95bmf	cmlezx1sc00yq39t5074f7l1b	24000.00
cmlezx20000zh39t5lfgh92zi	cmlezx20000zg39t565ylip6n	43000.00
cmlezx26200zv39t59bf9x61q	cmlezx26200zu39t5hakj325f	91000.00
cmlezx2ct010d39t5751k6y9j	cmlezx2ct010c39t58qmq4u0k	41000.00
cmlezx2hb010n39t5cnc741en	cmlezx2hb010m39t5lbosancc	119000.00
cmlezx2mf011339t5x4wxnijk	cmlezx2mf011239t5amr0vaow	141000.00
cmlezx2sd011l39t5cje9rmam	cmlezx2sd011k39t5204ccw3p	45000.00
cmlezx2y4011v39t5evvkl8cc	cmlezx2y4011u39t5mbsxv0qe	123000.00
cmlezx34s012d39t5x1att1mj	cmlezx34r012c39t5bepg57u1	42000.00
cmlezx3a0012r39t52boyx94q	cmlezx3a0012q39t56rynt3ci	42000.00
cmlezx3wr013139t58412moy7	cmlezx3wr013039t5xh4kc824	27000.00
cmlezx46j013p39t58itpfvh2	cmlezx46j013m39t5kf5cwakb	140000.00
cmlezx4en014339t5i12xm73n	cmlezx4en013z39t5z0j0ckc3	93000.00
cmlezx4oq014l39t5no70fban	cmlezx4oq014j39t5njtifjb5	66000.00
cmlezx4y0014r39t5t55ic0oq	cmlezx4y0014q39t5yjst84zq	165000.00
cmlezx58u015e39t5o935z83b	cmlezx58u015c39t54hwd0cst	87000.00
cmlezx5hp015u39t5upfhfdio	cmlezx5hp015s39t5v08in9d8	168000.00
cmlezx5pw016939t5pbddsbzv	cmlezx5pw016639t5w567kt7b	62000.00
cmlezx5zq016n39t5ou2kgebt	cmlezx5zq016l39t591az4eyi	588000.00
cmlezx68w017539t5h4zct1uj	cmlezx68w017239t567cufulc	232000.00
cmlezx6rb017n39t52wz2yhoy	cmlezx6rb017m39t5hj55dx4n	96000.00
cmlezx6xo018339t5lfs4cnma	cmlezx6xo018239t59o8rip2m	139000.00
cmlezx7g0018k39t5lf6yws6i	cmlezx7g0018i39t5ck58kc46	62000.00
cmlezx7mw019139t5bg1w05ot	cmlezx7mv019039t558sedswz	53000.00
cmlezx7un019j39t52iw9om26	cmlezx7un019i39t5lca5wcz1	48000.00
cmlezx82x01a239t5k8ha610b	cmlezx82x019y39t58wkbcdw4	52000.00
cmlezx8av01af39t5ddmsf1ur	cmlezx8av01ae39t5f19a51zc	40000.00
cmlezx8hz01ax39t5n8zmogla	cmlezx8hz01aw39t5n0stxi63	41000.00
cmlezx8ou01bn39t56fds2xnn	cmlezx8ou01bm39t5zada59ic	36000.00
cmlg3mc5e000dvu8yu3maswqa	cmlg3mc5e000cvu8yfgmkk2bq	50000.00
cmlg439k5002tpv85ldtfwv5i	cmlg439k5002spv85iszkh05e	99000.00
cmlg439rv0031pv85gkmsq9nj	cmlg439rv0030pv85fc95bvl8	131000.00
cmlg439xl0037pv85buzgkpv9	cmlg439xl0036pv854l7legr7	87000.00
cmlg43a33003fpv85jk7qt7kx	cmlg43a33003epv85r5vcpel9	81000.00
cmlg43av80047pv85pfmd359w	cmlg43av80046pv857blyedpp	89000.00
cmlezwij0005339t5nm1u72fa	cmlezwij0005239t5063dik90	173000.00
cmlezwjtv005p39t57a4itc9g	cmlezwjtv005l39t56bxyqdko	36000.00
cmlezwk0y006739t5cgj2fkhl	cmlezwk0y006539t5g7becqat	89000.00
cmlezwk90006s39t50vwlrcis	cmlezwk90006r39t57m450bh8	74000.00
cmlezwkg3007539t5w90j3hw0	cmlezwkg3007439t5r6zrwbgc	78000.00
cmlezwkqn007n39t5pkk7dix7	cmlezwkqn007m39t5gfz43qbe	79000.00
cmlezwl03008539t5v3sybfy0	cmlezwl03008439t5pi4d8pnd	91000.00
cmlezwl9b008n39t55nw09cm6	cmlezwl9b008m39t5jg5u9n92	113000.00
cmlezwliv009139t5tilft3qn	cmlezwliv009039t5p3fyffkt	69000.00
cmlezwlrm009j39t54otzp68q	cmlezwlrm009i39t5vzh4u7ez	98000.00
cmlezwlzc009z39t5unnfmrkm	cmlezwlzc009y39t5q2b4mwjv	90000.00
cmlezwmag00ac39t5xb52iwb1	cmlezwmag00aa39t5pnax8q09	153000.00
cmlezwmi500at39t54njff6a7	cmlezwmi500ar39t51e6s3xqq	80000.00
cmlezwngc00be39t5ahh0ujj9	cmlezwngc00bc39t5p4k8pket	114000.00
cmlezwnp200br39t5apelh4cm	cmlezwnp200bp39t5k5w8nnoo	139000.00
cmlezwny900c739t5thhoddv3	cmlezwny900c639t55is1clla	66000.00
cmlezwo4c00cl39t58ih4y3ol	cmlezwo4c00ck39t5uuyaa0c1	93000.00
cmlezwoav00cz39t5g4yt3vc2	cmlezwoav00cy39t5mgqpjmuy	85000.00
cmlezwoh000df39t55umpa741	cmlezwoh000de39t5ssnnzmvt	86000.00
cmlezwook00dz39t5zpo6wg78	cmlezwook00dx39t57y66d7rb	74000.00
cmlezwoxd00eh39t5461nz32d	cmlezwoxc00ee39t5pv06ndvs	43000.00
cmlezwpbi00ez39t5c3k3g7gb	cmlezwpbi00ey39t5a7uodrii	153000.00
cmlezwqdu00fb39t5umo90fe7	cmlezwqdu00fa39t5xxlgndqi	64000.00
cmlezwqpf00ft39t56qgfgsib	cmlezwqpf00fs39t58n36y361	48000.00
cmlezwr1100gf39t5hd5olubj	cmlezwr1100ge39t5ptikjwhw	133000.00
cmlezwrgp00gx39t5uk56yksy	cmlezwrgp00gw39t5vhh1gqql	100000.00
cmlezwrtm00hj39t5ooqd0d0f	cmlezwrtm00hi39t5xp55bqko	213000.00
cmlezws4x00i239t58c1v4mek	cmlezws4x00i139t5lt1bazq3	128000.00
cmlezwsgm00il39t5ylbet6qg	cmlezwsgm00ij39t5d9d6pc4p	212000.00
cmlezwt1y00j739t5o3ld9dux	cmlezwt1y00j639t5vdsmkuwx	179000.00
cmlezwtt400jp39t5ppop4ive	cmlezwtt400jn39t5z99s8uol	66000.00
cmlezwu5i00k739t5ly08rko1	cmlezwu5i00k639t5ndpw0s98	197000.00
cmlezwujm00kz39t5p4tpff3e	cmlezwujm00ky39t57izx0p4q	121000.00
cmlezwuty00ll39t560ybpc15	cmlezwuty00lk39t5t7efsdpg	138000.00
cmlezwv4300m339t59lo4ugr4	cmlezwv4300m239t5plw35sxf	194000.00
cmlezwvmw00mh39t54erozwho	cmlezwvmw00mf39t5a4iwxl0g	138000.00
cmlezwvw700mq39t5gffd10tw	cmlezwvw700mo39t5e29r2igb	194000.00
cmlezww3p00n739t5gc6obs1p	cmlezww3p00n639t540bpy2vw	280000.00
cmlezwwdb00nt39t5c9b9mw9x	cmlezwwdb00nr39t54wq12uxx	108000.00
cmlezwwn500o939t5x5idzh86	cmlezwwn500o839t53bcn32me	176000.00
cmlezwx4w00p539t5yr7krlny	cmlezwx4w00p439t5234guxcc	108000.00
cmlezwxbl00pi39t5pqvua0br	cmlezwxbl00pg39t5dycfmrht	43000.00
cmlezwxid00pv39t5liqz83pc	cmlezwxid00pu39t5mfjl5tol	104000.00
cmlezwxol00q939t5e8ofhtxz	cmlezwxol00q839t5ntxf9jnm	58000.00
cmlezwxvm00qp39t59iyv247f	cmlezwxvm00qo39t551mv6jnc	78000.00
cmlezwy2q00r339t52ud64xmy	cmlezwy2q00r239t5ys0fo8uc	66000.00
cmlezwycn00rk39t5lj1dh1d3	cmlezwycn00rj39t5mcn4xhgp	327000.00
cmlezwyqm00s739t5ldmb7mwk	cmlezwyqm00s639t5mghtixmg	87000.00
cmlezwyxp00sb39t5iki7vum6	cmlezwyxp00sa39t5epm53voq	65000.00
cmlezwz4200sr39t54yzy99x7	cmlezwz4200sq39t50eeiiyzo	108000.00
cmlezwzae00t939t5uxnt3kuz	cmlezwzae00t839t5ognrtzmd	165000.00
cmlezwzlk00u739t5cfx8xfoi	cmlezwzlj00u639t5i02xody8	129000.00
cmlezwzsc00ul39t5qfqddsuy	cmlezwzsc00uk39t5p0wh4ake	184000.00
cmlezwzxz00uz39t52bkpxxom	cmlezwzxz00uy39t5hshhg1eb	129000.00
cmlezx04z00vn39t5uxo0vjaq	cmlezx04z00vm39t5zihmalsc	107000.00
cmlezx0ao00vz39t5pfivcoib	cmlezx0ao00vy39t5yl4dtoau	78000.00
cmlezx0m200wn39t5k26jeiw0	cmlezx0m200wm39t5uexvwuy5	97000.00
cmlezx0to00x339t5wg6jalgn	cmlezx0to00x239t5237cr62c	63000.00
cmlezx18j00xg39t5jaah6g2c	cmlezx18j00xd39t59d5j7czz	165000.00
cmlezx1ls00yf39t5uf79qy85	cmlezx1ls00ye39t5r3gywhlv	49000.00
cmlezx1sy00yv39t5oyxkoyw9	cmlezx1sy00yu39t5u9m1q8g9	123000.00
cmlezx1zf00zf39t5ics8hlvn	cmlezx1zf00ze39t5olg9chrl	22000.00
cmlezx2ao010039t56r9qgdwb	cmlezx2ao00zy39t5sjxqcffu	45000.00
cmlezx2gn010l39t53a3g5vx5	cmlezx2gn010k39t5a4oxggxt	141000.00
cmlezx2mw011739t5uj8s5qz4	cmlezx2mw011639t5jgpv4sv6	42000.00
cmlezx2t8011p39t59gzrv0ur	cmlezx2t8011o39t5qrfy9qvk	68000.00
cmlezx31z012739t5z633ljlr	cmlezx31z012639t5n50ab1uw	70000.00
cmlezx3ws013339t5m2p30vmw	cmlezx3wr013239t5dho6u7nk	44000.00
cmlezx450013h39t5udgs2cu6	cmlezx450013f39t5lgi876qx	29000.00
cmlezx4km014739t5ytxtngw7	cmlezx4km014639t5a5vltpfr	141000.00
cmlezx4ut014p39t5vv5izcys	cmlezx4ut014o39t5t7k2dx9e	171000.00
cmlezx54y015239t5n4j6cytf	cmlezx54y015039t5vekrjmkv	79000.00
cmlezx5dq015l39t5zavs06ch	cmlezx5dq015k39t5i7qsba7p	77000.00
cmlezx5m1015z39t50qahld8n	cmlezx5m1015y39t5ixdo7qcp	94000.00
cmlezx5um016d39t5lid7pc0g	cmlezx5um016c39t5c5j8gqqk	359000.00
cmlezx64e016r39t5jk88a413	cmlezx64e016q39t5jvo14ugn	48000.00
cmlezx6i6017b39t5t85ob5rf	cmlezx6i6017a39t5l1vayxob	146000.00
cmlezx6sk017r39t5wvjvo3jv	cmlezx6sk017q39t55978mf0i	588000.00
cmlezx70k018939t5ni6p25sy	cmlezx70k018839t5lwkdaci3	2101000.00
cmlezx7g0018g39t5i0berj8l	cmlezx7g0018e39t5welowlfq	344000.00
cmlezx7rd019c39t5fo70pxa4	cmlezx7rd019a39t5pt3fqwfh	99000.00
cmlezx85801a839t5tserhzim	cmlezx85801a739t596xrz1wa	62000.00
cmlezx8cv01ap39t5okivrt1s	cmlezx8cv01ao39t5cuo7iqeb	344000.00
cmlezx8jl01b739t5ba8dq7ve	cmlezx8jl01b639t5iomtkbhr	82000.00
cmlezx8px01bp39t5yv7wt21g	cmlezx8px01bo39t5syujy0re	33000.00
cmlg3mc4k000bvu8yz5pj0eci	cmlg3mc4k0008vu8yp84fptwd	93000.00
cmlg3md5i000hvu8ywyfc1kwr	cmlg3md5i000gvu8ymb2gepfx	98000.00
cmlg3mdts000jvu8yk2k30kzn	cmlg3mdts000ivu8y0aed0gyq	93000.00
cmlezwill005939t5lgm6z9c8	cmlezwill005839t5ehxgeq7n	156000.00
cmlezwjtv005q39t5u1lpaauw	cmlezwjtv005m39t5qtq0mg4h	217000.00
cmlezwk0y006b39t5onbc9wbm	cmlezwk0y006939t58ept7j0z	89000.00
cmlezwk89006n39t5hwiesc50	cmlezwk88006m39t54rop6jcd	95000.00
cmlezwkf2007239t545ixdgej	cmlezwkf2007039t5wbj5tp6k	71000.00
cmlezwkp8007j39t5z7jysn5j	cmlezwkp8007i39t5o30sqjsj	128000.00
cmlezwkxq007z39t54sv0ks6c	cmlezwkxq007y39t5rjfsnopm	111000.00
cmlezwl7a008f39t5r6pava3f	cmlezwl7a008e39t5qztnnbdt	124000.00
cmlezwllh009739t5gzob6f2k	cmlezwllh009639t5zuc1sbp4	113000.00
cmlezwluc009r39t5xa17wmu5	cmlezwluc009q39t5it3kengz	138000.00
cmlezwm3h00a139t58ai3rndr	cmlezwm3h00a039t5chf9fax5	137000.00
cmlezwmce00af39t57fplu07g	cmlezwmce00ae39t5i40rgb14	153000.00
cmlezwmk400av39t5ac7rj84j	cmlezwmk400au39t54c5n97e0	228000.00
cmlezwngc00bf39t5woazsree	cmlezwngc00bd39t5cspkvtn9	138000.00
cmlezwnue00c539t5pe6qhefv	cmlezwnue00c239t5l0zk5qsr	138000.00
cmlezwo2y00ch39t550v8g56d	cmlezwo2y00cg39t5gmchxmek	102000.00
cmlezwo8l00cv39t5257b3awe	cmlezwo8l00cu39t5kzg05ttx	140000.00
cmlezwoe000db39t5sxsv0vur	cmlezwoe000da39t5zu2ge5ar	106000.00
cmlezwojr00dn39t55tecqhzz	cmlezwojr00dl39t5q0a76j5a	95000.00
cmlezwos200e739t5ebrwxdyg	cmlezwos200e439t5ovd6h6dm	128000.00
cmlezwp0x00ep39t5q9taqx1c	cmlezwp0x00eo39t5vs1ukdw7	55000.00
cmlezwq0m00f539t5h3lswoyh	cmlezwq0m00f439t5ppy3f02y	157000.00
cmlezwqgl00fh39t5tfmx3tjp	cmlezwqgl00fg39t53l191z2e	91000.00
cmlezwqzr00g739t5zh4cf3vj	cmlezwqzr00g639t5rygolm1g	55000.00
cmlezwrgq00h139t5us3zuc06	cmlezwrgq00h039t5czae19r8	98000.00
cmlezwrsq00hh39t5ajt2opp3	cmlezwrsq00he39t5wyoyhuyz	181000.00
cmlezws2r00hx39t5dddm76c2	cmlezws2r00hw39t58cmnkm5k	82000.00
cmlezwsbq00if39t5wh4mcl5e	cmlezwsbq00id39t5wax4qf3a	283000.00
cmlezwsjt00it39t5lb9u3c1g	cmlezwsjt00is39t5osyknyv3	146000.00
cmlezwt6q00j939t5bchel3cb	cmlezwt6q00j839t5uapk2c3r	99000.00
cmlezwttw00jt39t55b7ediw4	cmlezwttw00jq39t51kc9eeax	60000.00
cmlezwu7h00k939t51s3wv5cz	cmlezwu7h00k839t5agdarmey	57000.00
cmlezwug800kn39t5wwpqkxsy	cmlezwug800km39t54x6dxddv	174000.00
cmlezwuq600l739t5nh93sdfg	cmlezwuq600l639t5nfbw043z	198000.00
cmlezwuy400lp39t56szdfq5x	cmlezwuy400lm39t5tlpo4ba1	204000.00
cmlezwvmw00ml39t5gtwijxce	cmlezwvmw00mk39t5su4trqp8	198000.00
cmlezwvw700mr39t5vwe1na8u	cmlezwvw700mp39t53hs7k61c	187000.00
cmlezww3p00nb39t5cpvvn4jx	cmlezww3p00n939t52e7ott1j	266000.00
cmlezwwdb00ns39t54i5rr1pk	cmlezwwdb00nq39t5xv4fap4p	296000.00
cmlezwwld00o739t5lkruh5bt	cmlezwwld00o639t5ho8mfwf4	119000.00
cmlezwwxl00op39t5acj37f7p	cmlezwwxl00om39t52hdon6ys	47000.00
cmlezwxpx00qb39t5zqt8h38o	cmlezwxpx00qa39t5iz5tpoqu	62000.00
cmlezwyb800rh39t56ygxivfs	cmlezwyb800rg39t5xmc20yz1	78000.00
cmlezwyqm00rt39t5y6xas6oe	cmlezwyql00rq39t55xeh6dss	123000.00
cmlezwyzd00sp39t56w4hnnlu	cmlezwyzd00sn39t5gzgz49jp	86000.00
cmlezwz8200t539t5qeqsd9lo	cmlezwz8200t439t5lyfv32jt	65000.00
cmlezwzdb00tl39t5023on6s0	cmlezwzdb00tk39t5rzkqzcrl	89000.00
cmlezwzkh00u539t5a52hxuz9	cmlezwzkh00u439t56t8xw8jn	184000.00
cmlezwzt700up39t57f48shtx	cmlezwzt700uo39t55dfwlqkx	181000.00
cmlezx00y00v739t5uru814ot	cmlezx00y00v639t5hx3g1ir1	135000.00
cmlezx09e00vr39t5b63bxtae	cmlezx09e00vq39t5xpe6vy61	78000.00
cmlezx0ig00w939t5yrj03vu2	cmlezx0ig00w839t5o7qjia1u	97000.00
cmlezx0r100wx39t5neys3cwx	cmlezx0r100wv39t5d0oe00eq	65000.00
cmlezx18j00xq39t5ls5nhwoi	cmlezx18j00xn39t5xyorbs1y	31000.00
cmlezx1e200xt39t5ifhqv665	cmlezx1e200xs39t55h78hl0n	25000.00
cmlezx1p800yh39t5cntfidyg	cmlezx1p800yg39t5omt99vvu	60000.00
cmlezx1uq00yz39t5ergszscu	cmlezx1uq00yy39t5584uug2z	123000.00
cmlezx1zf00zd39t5k4cisq9z	cmlezx1zf00zc39t5ecv4v29m	70000.00
cmlezx2ao010139t58y5s1aue	cmlezx2ao00zz39t51juv3vr0	87000.00
cmlezx2g3010i39t5jrjcep4p	cmlezx2g3010g39t5t86nuscg	94000.00
cmlezx2ln011139t52yw5pvf1	cmlezx2ln010z39t5ggs98ty5	106000.00
cmlezx2r0011e39t5hlclprxa	cmlezx2r0011c39t5h4nqyvtl	88000.00
cmlezx31n012339t5keqb8u0f	cmlezx31n012239t5bekwyfi4	66000.00
cmlezx39a012p39t592qnn6cj	cmlezx39a012o39t5ra1ui9vi	63000.00
cmlezx3w8012y39t5vhzh66o9	cmlezx3w8012w39t59kw44hek	162000.00
cmlezx450013e39t50kugr61t	cmlezx450013c39t5d73w7fhk	200000.00
cmlezx4en014439t5cmrbhfha	cmlezx4en014039t5u5x6rqw1	61000.00
cmlezx4oq014i39t5632ajb6v	cmlezx4oq014g39t54hj3nf0z	183000.00
cmlezx4yq014z39t5jj4i62x3	cmlezx4yp014x39t55usit7z4	412000.00
cmlezx58u015b39t57oseztbd	cmlezx58u015a39t5ke9m2tyy	68000.00
cmlezx5hp015v39t5m5scvfle	cmlezx5hp015t39t50tzggx77	101000.00
cmlezx5pw016839t5w37pf4uu	cmlezx5pw016739t5g1juo3o4	101000.00
cmlezx5zq016m39t57ke47oyn	cmlezx5zq016k39t5gjx3xjf3	97000.00
cmlezx68w017139t5f0y6kf3l	cmlezx68v017039t5rmvsr5z6	135000.00
cmlezx6rm017p39t5ryzhhqiz	cmlezx6rm017o39t5jo8nb9ze	115000.00
cmlezx6zp018739t5p3lz06v3	cmlezx6zp018639t5eqq5ubdf	128000.00
cmlezx7g0018j39t5o9acv8f0	cmlezx7g0018f39t5zu7wlg54	68000.00
cmlezx7mt018x39t50s4ag31p	cmlezx7mt018w39t5q1dnyct8	65000.00
cmlezx7th019g39t5ek029u3w	cmlezx7th019e39t5523bv8m3	61000.00
cmlezx801019u39t5az0fq8jk	cmlezx801019s39t53csrna6j	31000.00
cmlezx88k01ad39t5zj2vbe6n	cmlezx88k01ac39t51xhn1otv	43000.00
cmlezx8fn01av39t5cb8wq8e1	cmlezx8fn01au39t5c82ghgtp	53000.00
cmlezx8kp01ba39t5muaporxd	cmlezx8kp01b839t5h79jqu9e	82000.00
cmlezx8qc01bt39t532qln6hn	cmlezx8qc01bs39t52ysqu5kw	30000.00
cmlg3mc4k0009vu8yp53x05gx	cmlg3mc4k0007vu8y4ibk44ql	51000.00
cmlg439es002jpv85m5yh0see	cmlg439es002ipv85jf66z7wi	70000.00
cmlg43a0p003bpv853k16st55	cmlg43a0p003apv85i55qexgk	115000.00
cmlg43a7a003lpv857ry1hoty	cmlg43a7a003kpv85sliffx7g	86000.00
cmlezwimj005b39t57rfl8auq	cmlezwimj005a39t5yyy0tkd1	1174000.00
cmlezwjtv005r39t5rntnq5zi	cmlezwjtv005n39t5b2blio9p	171000.00
cmlezwk06006139t5dur917qw	cmlezwk06006039t532g0knpj	156000.00
cmlezwk6j006j39t5oznfqa61	cmlezwk6j006g39t52bhtven8	91000.00
cmlezwk48006d39t559g6fd63	cmlezwk48006c39t594ih7gao	156000.00
cmlezwkdl006z39t59os24zah	cmlezwkdl006y39t5f4hchj8o	78000.00
cmlezwkhb007a39t5mfsszr90	cmlezwkhb007939t5g4zibpd9	149000.00
cmlezwkn0007d39t5m2nu0gx0	cmlezwkn0007c39t5nkcm16a1	68000.00
cmlezwkve007v39t51uu6ddd7	cmlezwkve007u39t5rvpn0dsy	145000.00
cmlezwkue007s39t5jqe2maoj	cmlezwkud007q39t5kdx3iuu6	86000.00
cmlezwl5c008b39t5bcc8no0z	cmlezwl5c008a39t5ov2y3ufp	91000.00
cmlezwl7a008h39t5gmdbnh1y	cmlezwl7a008g39t5i8bjwmuj	77000.00
cmlezwlez008r39t5w3xbjygz	cmlezwlez008q39t54vg5zlpu	90000.00
cmlezwlgv008v39t56uxriq6j	cmlezwlgv008u39t5whp8hjyu	93000.00
cmlezwln7009939t59q0uojnp	cmlezwln7009839t5s9twxf9s	82000.00
cmlezwlqn009g39t59wqd5j0q	cmlezwlqn009f39t5wtqfklzw	145000.00
cmlezwltp009p39t5g2jcickp	cmlezwltp009o39t5e50mu28t	119000.00
cmlezwm5v00a839t5lr7mo0b0	cmlezwm5v00a739t54sksgov3	113000.00
cmlezwlzc009w39t5ai854djf	cmlezwlzc009u39t5hqy2rwpo	149000.00
cmlezwmfp00an39t5a18t7fhc	cmlezwmfp00ak39t5gidkdukl	153000.00
cmlezwmfp00ap39t5vpnn5838	cmlezwmfp00ao39t5c1by1ydy	91000.00
cmlezwmni00b139t59gr8958o	cmlezwmni00b039t5uqfdd0hq	192000.00
cmlezwngc00ba39t5i9pz5i2r	cmlezwngc00b539t5sh5ihuxe	138000.00
cmlezwngc00b639t59gd6y6oy	cmlezwngc00b239t5235qzaim	123000.00
cmlezwnmx00bm39t5lfvp8m8z	cmlezwnmx00bk39t58n9r2lsh	190000.00
cmlezwnp200bu39t5qb8yp2mw	cmlezwnp200bs39t5zkubbbt2	126000.00
cmlezwnue00c339t5u28vs3d4	cmlezwnue00c039t5rrw7lmpj	138000.00
cmlezwnyx00c939t510aap42l	cmlezwnyx00c839t5sjl84jjs	103000.00
cmlezwo2z00cj39t5fw88ggk6	cmlezwo2z00ci39t5ps7pvweh	78000.00
cmlezwo4z00cn39t5qblroqsr	cmlezwo4z00cm39t5od2rl4bw	100000.00
cmlezwo9a00cx39t5jo7gyahb	cmlezwo9a00cw39t5r3ct2ljl	93000.00
cmlezwobh00d139t5svcz0omz	cmlezwobh00d039t50c566c8m	83000.00
cmlezwoh700dh39t5kosz3qxv	cmlezwoh700dg39t5ia40ic89	96000.00
cmlezwoiw00dj39t54ma90psy	cmlezwoiw00di39t5hhxo8dpo	153000.00
cmlezwook00dy39t5qgegzlnd	cmlezwook00dw39t5cj6uah56	85000.00
cmlezwoqp00e139t5uwa1xl74	cmlezwoqp00e039t5rq1hpw9y	70000.00
cmlezwoxd00ef39t5v32pwd6j	cmlezwoxc00ec39t5fawotzyh	133000.00
cmlezwozt00ej39t5pw6p3qh0	cmlezwozt00ei39t5sjb6df5w	84000.00
cmlezwpig00f139t5o1ucfj3d	cmlezwpig00f039t53gwvpabf	102000.00
cmlezwpbh00ex39t58fhcaxz9	cmlezwpbh00ew39t50oeewf32	113000.00
cmlezwqfe00fd39t55l0ual7p	cmlezwqfe00fc39t5eacael02	65000.00
cmlezwqhg00fl39t5ljltcb0f	cmlezwqhg00fj39t5y1o1g92o	110000.00
cmlezwqqr00fx39t5xwjnt0yu	cmlezwqqr00fw39t5rw9vw90z	91000.00
cmlezwqtd00g139t53fjw2e7h	cmlezwqtd00g039t5lqgd3v3k	85000.00
cmlezwr0g00gd39t5k6q055f6	cmlezwr0g00gb39t5optkopgl	181000.00
cmlezwr2j00gi39t552v6v2ah	cmlezwr2j00gg39t5bfwqz4ea	165000.00
cmlezwrgp00gv39t5fikhf0it	cmlezwrgp00gu39t5krjjl0jp	67000.00
cmlezwrgq00gz39t5rq90a2aj	cmlezwrgq00gy39t54eohrpvp	129000.00
cmlezwrpf00h539t5q6a2gnz8	cmlezwrpf00h439t540hof27d	180000.00
cmlezwrrg00h939t53ubb3as7	cmlezwrrg00h639t5dypshi41	225000.00
cmlezwry500hn39t5s8gs9zen	cmlezwry500hm39t5fpoxv49y	171000.00
cmlezws1c00ht39t5siufgoby	cmlezws1c00hr39t5llx8fk3w	58000.00
cmlezwsai00i739t53r062y0e	cmlezwsai00i639t5mlksvpwq	71000.00
cmlezwsb400i939t5nd59dlgq	cmlezwsb400i839t5708zqghd	54000.00
cmlezwsi000in39t57r6gvh05	cmlezwsi000im39t5zk9i9ww3	78000.00
cmlezwsix00ir39t5upyhg7at	cmlezwsix00iq39t51vxv33te	47000.00
cmlezwstu00j339t5ervvvzpl	cmlezwstu00j239t5nzblapme	194000.00
cmlezwt0i00j539t58eqki4jk	cmlezwt0i00j439t5fjn6j6mi	63000.00
cmlezwtre00jl39t5j4l862f2	cmlezwtre00jk39t5gg267zca	222000.00
cmlezwtt400jo39t5jnljw25r	cmlezwtt400jm39t577fbd9al	69000.00
cmlezwu0900k339t5eck2cbzq	cmlezwu0900k239t57ybedysb	197000.00
cmlezwu5e00k539t5q0ctqldj	cmlezwu5e00k439t5xelw7901	197000.00
cmlezwueq00kl39t52ddr7u5k	cmlezwueq00kk39t5c4us3hhl	198000.00
cmlezwuhh00kp39t5wui4l8wp	cmlezwuhh00ko39t5yhy666oy	59000.00
cmlezwum300l339t5ari1cimk	cmlezwum300l239t5o3clqkjs	121000.00
cmlezwupe00l539t59f67wslp	cmlezwupe00l439t5ndtmljx7	121000.00
cmlezwurr00lf39t567o1aj03	cmlezwurr00le39t5xwbmvdue	97000.00
cmlezwuy400lo39t55rj7ewvd	cmlezwuy400ln39t5cktdwy8l	198000.00
cmlezwuzy00lv39t55x5faxvn	cmlezwuzy00lu39t55jsg0cyr	221000.00
cmlezwv5e00m539t5ttkdw11n	cmlezwv5d00m439t5i23qrv7k	128000.00
cmlezwvmw00mg39t5lltgg3ta	cmlezwvmw00ma39t52epwg8hk	91000.00
cmlezwvo000mn39t5qwuyaomx	cmlezwvo000mm39t5wvh4a99x	73000.00
cmlezwvx400mw39t5b0wakvaq	cmlezwvx400mu39t5edphwjrk	91000.00
cmlezwvxu00n139t5ytfqd929	cmlezwvxu00n039t54l9gwi30	155000.00
cmlezww4j00ng39t5zzt0d2i1	cmlezww4j00nf39t5z6iw9j3s	295000.00
cmlezww5l00nj39t50phu0nyw	cmlezww5l00ni39t50h5sv9lt	219000.00
cmlezwwe400nx39t5upbtr1xa	cmlezwwe400nu39t5o7s4hd1i	350000.00
cmlezwwfd00o139t5tqnhs0l4	cmlezwwfd00o039t5gx2w4nhv	358000.00
cmlezwwo300oe39t5075cu1pe	cmlezwwo300od39t59l87fxaw	236000.00
cmlezwwpj00oj39t5sbbiqqm2	cmlezwwpj00oi39t59rcvaar9	195000.00
cmlezwwye00ov39t5ki7ibedu	cmlezwwye00os39t5mas6n06z	103000.00
cmlezwwzg00oz39t5ic8nt4ch	cmlezwwzg00oy39t5rih9qyg9	36000.00
cmlezwx5j00p839t5e1jobmix	cmlezwx5j00p639t5ow75xg6p	269000.00
cmlezwx6200pb39t5ipr8yzbx	cmlezwx6100pa39t5wo3cudcs	167000.00
cmlezwxdq00pm39t55syool52	cmlezwxdq00pk39t5f9r0ax3v	151000.00
cmlezwxdq00pp39t5kuywpmlq	cmlezwxdq00po39t50bfzctac	84000.00
cmlezwxkf00q239t5eclyl2dn	cmlezwxkf00pz39t5ri6a6th3	85000.00
cmlezwxkf00q139t5g0k3cwtp	cmlezwxkf00py39t50kwfw93j	57000.00
cmlezwxry00qj39t5rrb1bhmq	cmlezwxry00qi39t5ntjppmcp	276000.00
cmlezwxyg00qu39t5b4jsytoe	cmlezwxyg00qs39t5irwmwgwl	71000.00
cmlezwy8w00re39t5erfaowjj	cmlezwy8w00ra39t5uyak6azk	100000.00
cmlezwyqm00s439t5z7jfh9sd	cmlezwyqm00s239t5q8qtwtgn	107000.00
cmlezwyyi00si39t5vjqex1np	cmlezwyyi00sf39t507qf0rqa	65000.00
cmlezwz6o00sw39t5q8sv99ms	cmlezwz6o00sv39t5lcgvqf81	86000.00
cmlezwzcf00tj39t5okftvmvb	cmlezwzcf00ti39t5ihwv1vqq	100000.00
cmlezwzi500tu39t5tnv2sr5w	cmlezwzi500ts39t53wfipw83	85000.00
cmlezwzov00ue39t5c4tlkdud	cmlezwzov00ua39t5vgfsflpt	94000.00
cmlezwzwk00ux39t5y5kjzi8d	cmlezwzwk00uw39t5lzqbz2x8	192000.00
cmlezx02z00vf39t5pq872mx7	cmlezx02z00vc39t5y5setr5y	90000.00
cmlezx09f00vt39t5i0n536cw	cmlezx09f00vs39t59s5r7ils	64000.00
cmlezx0iu00wc39t54ove2gfk	cmlezx0iu00wa39t50r6uy3wn	98000.00
cmlezx0qp00wt39t5qtg28875	cmlezx0qp00ws39t5xkimf2e1	87000.00
cmlezx18j00xi39t56ibcy8f3	cmlezx18j00xh39t5e1hzwo1u	60000.00
cmlezx1lr00yd39t5qrjs7phz	cmlezx1lr00yc39t5fiq4qsg5	40000.00
cmlezx1t300yx39t5rr32fiv2	cmlezx1t300yw39t51j7o6143	33000.00
cmlezx1yg00zb39t59x9b8r14	cmlezx1yg00za39t5etkeir3o	32000.00
cmlezx25200zt39t58uuvvwcf	cmlezx25200zs39t58k6dhpy5	81000.00
cmlezx2bn010739t5oli0bna9	cmlezx2bn010639t5cw0d4gho	141000.00
cmlezx2je010u39t5quzabvyh	cmlezx2je010t39t5wgb2gvlz	107000.00
cmlezx2rt011i39t5mukicu3y	cmlezx2rt011g39t51cgzwcoi	82000.00
cmlezx2yv011z39t52thpxxty	cmlezx2yv011x39t5cibo4rnf	26000.00
cmlezx35j012f39t5psmylkdx	cmlezx35j012e39t5tgc0t580	79000.00
cmlezx3bx012t39t5c11mt37h	cmlezx3bx012s39t5riq0dyht	144000.00
cmlezx3w8012v39t5s6029pq9	cmlezx3w8012u39t53qx6npv6	53000.00
cmlezx49p013r39t5fy00qol9	cmlezx49p013q39t5gbvwus8i	52000.00
cmlezx4mz014939t5ost2iqxb	cmlezx4mz014839t5ridknsl6	29000.00
cmlezx55n015539t5hm2dqmol	cmlezx55n015439t5ispvr5c4	97000.00
cmlezx667016v39t5yfj41472	cmlezx667016u39t5juarqg2j	666000.00
cmlezx6qo017j39t5u9rkw99g	cmlezx6qo017i39t58w3u5k8d	114000.00
cmlezx6wj017z39t5yt6la53r	cmlezx6wj017y39t5lruwmheu	166000.00
cmlezx7g1018t39t5ijrawm8b	cmlezx7g1018r39t5vzms37xh	75000.00
cmlezx7rd019d39t5i19xf0f1	cmlezx7rd019b39t5hj0kgadv	24000.00
cmlezx85801a939t5487ng3ek	cmlezx85801a639t503a8vk57	48000.00
cmlezx8dp01ar39t5tcd5c9gq	cmlezx8dp01aq39t58e8ah41k	35000.00
cmlezx8kp01bb39t5t6rhp997	cmlezx8kp01b939t5j6t1sz5n	46000.00
cmlezx8pz01br39t5jpv3eruv	cmlezx8pz01bq39t5cf86wf24	31000.00
cmlg3mc5x000fvu8yvot01dqj	cmlg3mc5x000evu8yrsh2rm43	93000.00
cmlg3me27000lvu8y8sujk0ha	cmlg3me27000kvu8yamjk3cjo	50000.00
cmlg439hs002lpv85b9i8klhy	cmlg439hs002kpv85wdf8vge7	97000.00
cmlg43a40003hpv85katvtkbt	cmlg43a40003gpv853wfdf3x1	110000.00
cmlg43aaa003rpv85yhdap4i7	cmlg43aaa003qpv85x1cjc9oq	51000.00
cmlg43aif003zpv858pyws3i1	cmlg43aif003ypv854lldvem9	85000.00
cmlg43avx0049pv85o9a01yw0	cmlg43avx0048pv85wgv33vrt	86000.00
cmlg43b23004jpv85esskaury	cmlg43b22004ipv85xe1068nq	60000.00
cmlg43b8t004tpv856v2zg0i2	cmlg43b8t004spv85ld8h4l0g	36000.00
cmlg43bg80055pv85hwe6y7y6	cmlg43bg80054pv85sxfbrq1o	63000.00
cmlg43d82005xpv856shhefhs	cmlg43d82005tpv85viifgyhl	159000.00
cmlg43dji0067pv85s0izrm6m	cmlg43dji0065pv85tb7zmsm4	109000.00
cmlg43e0u0073pv852a53i3nz	cmlg43e0u0072pv858ru11mr5	117000.00
cmlg43e98007hpv85ve5zt50u	cmlg43e98007gpv85jau0qllw	111000.00
cmlg43egi007zpv85ao1b9x1p	cmlg43egi007ypv85ybsl7icu	113000.00
cmlg43enn008hpv85po3csvrk	cmlg43enn008gpv85rg3wi8t7	54000.00
cmlg43evt008zpv85k3mqork0	cmlg43evt008ypv851uwtcwub	101000.00
cmlg43fa3009opv853hafk9i3	cmlg43fa3009mpv85t27yw7xo	132000.00
cmlg43fo700abpv85irobiciv	cmlg43fo700aapv85tztl55ow	142000.00
cmlg43fwl00aqpv85b4kulo1a	cmlg43fwl00aopv85b95l2b9j	93000.00
cmlg43gdx00bepv85px9qm57x	cmlg43gdx00bdpv857tutmz60	78000.00
cmlg43gnd00bvpv852woim0m4	cmlg43gnd00bspv8587wu6xgo	100000.00
cmlg43gv200cdpv85ayjdr4t2	cmlg43gv200ccpv851ob30lwa	87000.00
cmlg43h4900ctpv8557zbq772	cmlg43h4800cspv85c2tg792t	47000.00
cmlg43hb400depv858cnhrs55	cmlg43hb400dcpv85tsu1w6or	28000.00
cmlg43hf400dppv859qnpqkbm	cmlg43hf400dopv85g2qog2mr	213000.00
cmlg43hi800dupv85xml8n3i1	cmlg43hi800dspv850dpkwzwk	76000.00
cmlg43hpw00e9pv85zaay1efy	cmlg43hpw00e8pv8566u9bwno	22000.00
cmlg43hlt00e3pv85ogvzx8na	cmlg43hlt00e2pv85pd955sbl	53000.00
cmlg43i0f00elpv85hmwutqfc	cmlg43i0f00eipv85gwx9zwbc	57000.00
cmlg43i1400eppv85idsipivt	cmlg43i1300eopv85vxthjsdc	21000.00
cmlg43ib000f3pv85fpyo1l1a	cmlg43ib000f2pv85q05i4q1s	46000.00
cmlg43ib000f1pv85sk8zvo6v	cmlg43ib000f0pv85uceb0u78	87000.00
cmlg43im900fkpv85zksdhrm9	cmlg43im900fipv85h12te3wn	134000.00
cmlg43inf00fppv85f54l59ba	cmlg43inf00fopv85khbulupw	77000.00
cmlg43iu600g1pv85kmma64d9	cmlg43iu600g0pv85lrg2ujsn	30000.00
cmlg43iu400fzpv85xuymc3th	cmlg43iu400fypv85vus1e9y8	52000.00
cmlg43j9j00gbpv85f97ep6rd	cmlg43j9j00gapv85zk703fai	63000.00
cmlg43jt500gspv85xfc4aqad	cmlg43jt500gopv85qvdoln6b	23000.00
cmlg43jt500gwpv85pez1g6h2	cmlg43jt500gupv8525ii6tqm	57000.00
cmlg43jt600gzpv85kkfq23f8	cmlg43jt600gypv85vc2dec7w	35000.00
cmlg43jzu00h7pv85sxy9bszs	cmlg43jzu00h6pv859evfbs9o	28000.00
cmlg43k1t00hbpv85vhd16kyl	cmlg43k1t00hapv852n4i91sj	69000.00
cmlg43k8a00hppv85onfrxu37	cmlg43k8900hlpv85vxqr6sjc	48000.00
cmlg43kb700htpv858er6zzq7	cmlg43kb700hspv85pqgxs8mj	59000.00
cmlg43kg000hypv85w70u6te3	cmlg43kg000hvpv85vjsn5bjq	33000.00
cmlg43k5800hepv85oymo2syk	cmlg43k5700hcpv85g1zsymb3	31000.00
cmlg43kia00i3pv85w72ylntw	cmlg43kia00i2pv855rjrqldq	62000.00
cmlg43kmg00i9pv85zrdqwvh0	cmlg43kmg00i6pv85dwpptuz0	41000.00
cmlezwy0400r139t5xpnb5urm	cmlezwy0400r039t52kxetem4	103000.00
cmlezwy8900r939t52w8pm6kd	cmlezwy8900r739t5v31gcbur	195000.00
cmlezwyqm00ry39t5ss2noo2i	cmlezwyqm00rv39t5w7n9zcrz	123000.00
cmlezwyyi00se39t5wumudq9m	cmlezwyyi00sc39t503dat3nn	106000.00
cmlezwz6q00t139t5392dgotw	cmlezwz6q00t039t5q9ctm878	76000.00
cmlezwzc700tf39t5gh7oafa0	cmlezwzc600te39t58l7x5cvm	164000.00
cmlezwzi500tv39t51axqpwyh	cmlezwzi500tt39t5kc2x2yer	65000.00
cmlezwzov00uc39t50tcl0fsw	cmlezwzov00ub39t5gmapbqwv	58000.00
cmlezwzvw00ut39t56l6nj8o6	cmlezwzvw00us39t5zpdzwq0y	73000.00
cmlezx01l00v939t5p3l78agt	cmlezx01l00v839t59ga7jt5u	85000.00
cmlezx09s00vv39t589mdtyen	cmlezx09s00vu39t5zriqssrx	78000.00
cmlezx0kq00wh39t5ksri86y5	cmlezx0kq00wg39t54oa3fpas	97000.00
cmlezx0st00x139t5eepv0upb	cmlezx0st00x039t5tyjm16ul	134000.00
cmlezx18j00xm39t5wa0f7dwc	cmlezx18j00xk39t57i29t25v	68000.00
cmlezx1ez00y139t55s5odxtd	cmlezx1ez00y039t552sr4up5	32000.00
cmlezx1kw00y739t5hqdjiw0c	cmlezx1kw00y639t5tqwqnh6r	66000.00
cmlezx1re00yn39t53v4ehef2	cmlezx1re00yk39t58ttkg79n	26000.00
cmlezx1wq00z139t577oxxr4o	cmlezx1wq00z039t5heasifts	33000.00
cmlezx22w00zj39t50u4wdupm	cmlezx22w00zi39t5sg60f7ak	29000.00
cmlezx2a200zx39t5i5n7sf75	cmlezx2a200zw39t5lf11n5i4	88000.00
cmlezx2f8010f39t5imgb57g5	cmlezx2f8010e39t5xyvkvuam	65000.00
cmlezx2kf010x39t5ofxp6lsv	cmlezx2kf010w39t5dv3rryys	141000.00
cmlezx2pn011b39t5tmr451x0	cmlezx2pn011a39t57b5exxbo	87000.00
cmlezx2vy011t39t5ilkbe3wq	cmlezx2vy011s39t5gunmqwtw	106000.00
cmlezx32o012939t587c6zk5w	cmlezx32o012839t5s76mt2ol	80000.00
cmlezx38y012n39t5j016bqkl	cmlezx38y012m39t5avethvq8	106000.00
cmlezx3x5013739t582a57opx	cmlezx3x5013439t5cfiapxgg	140000.00
cmlezx46j013n39t5kegvbmv3	cmlezx46j013k39t5oj05dwpf	140000.00
cmlezx4en014539t5i8yzu6kv	cmlezx4en014139t5kb04tzby	54000.00
cmlezx4oq014k39t5w1m1lrfj	cmlezx4oq014h39t57od2nq3f	178000.00
cmlezx4yp014u39t5i4yg1j5o	cmlezx4yp014s39t54u0cgbig	26000.00
cmlezx58u015f39t5i04ylre1	cmlezx58u015d39t5gpmay5xh	123000.00
cmlezx5gm015q39t58d4sjvpj	cmlezx5gm015o39t5d6pfjo5k	52000.00
cmlezx5p7016539t5fuwxjb3r	cmlezx5p7016339t5ibgwrlms	96000.00
cmlezx5yf016j39t5195k6fmo	cmlezx5yf016g39t5hat84vu1	63000.00
cmlezx67k016z39t5utmkm7aw	cmlezx67k016x39t5jys750db	57000.00
cmlezx6kd017e39t5g8hv5k9x	cmlezx6kd017d39t53q6gh4xv	66000.00
cmlezx6t9017w39t5qyy076h8	cmlezx6t9017v39t5lhevklbk	83000.00
cmlezx71b018d39t53py6o7h7	cmlezx71b018c39t580lrde17	45000.00
cmlezx7g1018s39t5zbkh0oy2	cmlezx7g1018q39t5197doepc	52000.00
cmlezx7my019439t5xupexaye	cmlezx7my019239t5h8barhh7	62000.00
cmlezx7un019l39t5qcuohyo1	cmlezx7un019k39t5v5u0temb	39000.00
cmlezx82x01a039t5x9faln4k	cmlezx82x019w39t5w2xz6hke	60000.00
cmlezx8aw01ai39t5unntdi46	cmlezx8aw01ag39t5171lxdv9	59000.00
cmlezx8i701b539t5sc3ssd59	cmlezx8i601b439t55igqjztd	73000.00
cmlezx8nv01bi39t5mm9ys4et	cmlezx8nv01bf39t5jdpctlwy	82000.00
cmlg3siki0001erj0vqddt9rt	cmlg3siki0000erj0jz3vcaw7	153000.00
cmlg3sjlp0003erj0x2fc44qs	cmlg3sjlp0002erj0kzfdun2o	98000.00
cmlg3sk3b0005erj0qh5i8g2m	cmlg3sk3b0004erj0eh7a76kf	85000.00
cmlg3skim0007erj06zu8zlks	cmlg3skim0006erj052ta5r4b	111000.00
cmlg3sln1000cerj0rbrifc11	cmlg3sln1000aerj0a8a9zipr	61000.00
cmlg3smhr000lerj0vzjre0gu	cmlg3smhr000jerj0xzof96pi	60000.00
cmlg3smsg000serj0bl58cwul	cmlg3smsf000qerj0j6dp2056	45000.00
cmlg3sn5t0011erj05aoyarq2	cmlg3sn5n000yerj0v9tm2jfz	20000.00
cmlg3snlk001ferj0qfgs487i	cmlg3snlk001cerj0bq33ngkb	13000.00
cmlg3so0k001rerj0heh93rcw	cmlg3so0k001perj0sxklkqfg	14000.00
cmlg3soik0022erj0ra9khdim	cmlg3soik0021erj09vu7wt7o	73000.00
cmlg3soyf002gerj0xiiqorn8	cmlg3soyf002derj0nj5bhbor	88000.00
cmlg3spbs002perj0ivwy2ls8	cmlg3spbs002oerj0zobd0ruz	90000.00
cmlg3spjg0031erj0pmz9tpm8	cmlg3spjg0030erj08ywq9lnk	71000.00
cmlg3sps8003cerj0iwc7v4n8	cmlg3sps8003aerj03t1ixz9x	48000.00
cmlg3t0j0000nq2fkawc0n8dl	cmlg3t0j0000lq2fk0u5bkhem	519000.00
cmlg43b2a004npv85rvqo64yt	cmlg43b2a004mpv85xwxpt9hl	61000.00
cmlg43b9e004vpv858b9wa39t	cmlg43b9e004upv85863sdotx	63000.00
cmlg43bfs0052pv85acrrw7sv	cmlg43bfs0050pv85oe02wh73	85000.00
cmlg43blw005dpv85cql987cq	cmlg43blw005bpv852bzdajed	43000.00
cmlg43d82005wpv85nkpgrhr9	cmlg43d82005upv85lvys5gpc	63000.00
cmlg43dji0066pv855mvj2ndh	cmlg43dji0064pv85287bqchn	81000.00
cmlg43dsz006npv85hmp8mmkp	cmlg43dsz006mpv85fuccn3as	48000.00
cmlg43dzi006xpv85byfml4vx	cmlg43dzh006wpv859uw3mejb	56000.00
cmlg43ece007lpv85a3d5jovv	cmlg43ece007jpv85dm1xwixv	51000.00
cmlg43elh008bpv85hyku5zjz	cmlg43elh008apv85ez2kwquj	78000.00
cmlg43eu2008xpv856wwmc6bv	cmlg43eu2008wpv85r6oqfhu3	54000.00
cmlg43f7v009lpv85d4ht15wr	cmlg43f7u009kpv85fau6gpp8	55000.00
cmlg43fm200a3pv85nmkusdbx	cmlg43fm200a1pv85wp2u1mkz	72000.00
cmlg43fu600ajpv85sf1vrnee	cmlg43fu600aipv858t1f01fb	62000.00
cmlg43gdx00b9pv8524loxrmx	cmlg43gdx00b4pv85vmxly6xk	71000.00
cmlg43gln00blpv85vnz9l8xr	cmlg43gln00bkpv85at82bhqe	73000.00
cmlg43gsl00c7pv85h0606dgc	cmlg43gsl00c4pv85rzsgysdc	43000.00
cmlg43gyj00copv85es1oxh99	cmlg43gyj00cnpv85kvtfvfs5	105000.00
cmlg43h4t00cypv85sn06ri8n	cmlg43h4t00cwpv8516npb2ar	73000.00
cmlg43hb400dfpv859frcqn10	cmlg43hb400ddpv85a6n6l8lx	110000.00
cmlg43hhk00drpv85vh7kcx8r	cmlg43hhk00dqpv85b56klz9x	52000.00
cmlg43hiv00dxpv85cmdyrw5n	cmlg43hiv00dwpv85afun51ai	121000.00
cmlg43hpx00ecpv85dy9fwlhu	cmlg43hpw00eapv8519z8a338	58000.00
cmlg43hqn00efpv85rinbhsxj	cmlg43hqn00eepv8527agrnhl	144000.00
cmlg43i0f00enpv85dqi1bthd	cmlg43i0f00ekpv85r4iy8sc4	53000.00
cmlg43i2e00etpv8531urt8f7	cmlg43i2e00erpv85xehhqiew	25000.00
cmlezx8aw01aj39t5kp171l29	cmlezx8aw01ah39t5uerimvsm	46000.00
cmlezx8i001b139t51y28hisa	cmlezx8i001b039t5pgwfqmqm	35000.00
cmlezx8nv01bj39t5hdiij272	cmlezx8nv01bg39t5lfvvx9po	29000.00
cmlg3skio0009erj02sikv4fe	cmlg3skio0008erj0c5tvoz0l	115000.00
cmlg3sln1000derj0s1r5x752	cmlg3sln1000berj0d4752qi1	79000.00
cmlg3smhr000kerj04sjxqptj	cmlg3smhr000ierj0i0o2zcrz	197000.00
cmlg3smsg000terj0w4bwpysf	cmlg3smsg000rerj0fdefz06h	58000.00
cmlg3sn5t0013erj04e1xervi	cmlg3sn5t0012erj04srvbhdh	25000.00
cmlg3snga0019erj07fxz5hma	cmlg3sng90018erj0po95dgwv	86000.00
cmlg3snui001lerj0av16iyyg	cmlg3snui001kerj0hmz3fqr5	28000.00
cmlg3so7b001xerj0w6tasid7	cmlg3so7b001werj0112k3ogd	81000.00
cmlg3sopq0029erj0cbtg5d6c	cmlg3sopq0028erj0pdnsyffh	76000.00
cmlg3sp73002lerj08ppmiaup	cmlg3sp73002kerj0qzz4mq94	78000.00
cmlg3spe9002verj0zzkyluhm	cmlg3spe9002uerj0hlqglpyi	95000.00
cmlg3spmz0037erj00o22ivky	cmlg3spmz0036erj0ks614e3g	79000.00
cmlg3spz4003jerj0t52xt1ho	cmlg3spz4003ierj0j54koapn	51000.00
cmlg3sz6g000bq2fk6fc405yq	cmlg3sz6g000aq2fksqyv506j	57000.00
cmlg3t0dz000jq2fkb03rhni9	cmlg3t0dz000iq2fk7ppy9cqu	19000.00
cmlg3t1fe000xq2fkv3tpb0dl	cmlg3t1fe000wq2fk4xjuys8d	16000.00
cmlg43az8004dpv85wmgf956y	cmlg43az8004cpv85pg6fkscw	122000.00
cmlg43d82005lpv856vki8tgz	cmlg43d82005ipv85xtynn7ae	82000.00
cmlg43dp7006dpv85us6yz3y0	cmlg43dp7006bpv85sxymz32z	262000.00
cmlg43e060071pv85nmjbd1kf	cmlg43e060070pv852r69y1r5	98000.00
cmlg43e6p007dpv85xooehn9o	cmlg43e6p007cpv85bmm4046e	93000.00
cmlg43ee0007tpv85cren4eed	cmlg43ee0007spv85nf24kvkx	54000.00
cmlg43ekm0083pv85ywtjb3x1	cmlg43ekm0082pv85knu80yrt	63000.00
cmlg43er9008lpv85i2jranb0	cmlg43er9008kpv85o5ll7xc2	65000.00
cmlg43eyk0097pv85w4kq40iz	cmlg43eyk0095pv85ofipl89j	50000.00
cmlg43f6u009jpv85k81wvtfz	cmlg43f6u009ipv85oex6rsnr	55000.00
cmlg43fm200a2pv85xwgp8znr	cmlg43fm200a0pv85kvg1acg7	55000.00
cmlg43fu600alpv85j08zkdl2	cmlg43fu600akpv85205q4b2l	68000.00
cmlg43gdx00b6pv85r017w2xn	cmlg43gdx00b1pv85a4y0oqqo	58000.00
cmlg43god00bzpv854x7236jh	cmlg43god00bypv854v6d4mj4	118000.00
cmlg43gw300chpv85cnf8066k	cmlg43gw300cgpv85r7sd7wl3	79000.00
cmlg43h5u00d5pv85xdayc8mj	cmlg43h5u00d4pv85b8obcmem	168000.00
cmlg43hdr00dipv85it7vzj2a	cmlg43hdr00dgpv85uiqwbh1c	53000.00
cmlg43hlt00e0pv85tw6rbqoq	cmlg43hlt00dypv85482aion8	120000.00
cmlg43hxh00ehpv8597a2nvil	cmlg43hxh00egpv85sd60uqh1	60000.00
cmlg43i6r00ezpv85a3hvmpjq	cmlg43i6r00eypv854rt9rk57	244000.00
cmlg43ice00f7pv85oy1y4y5p	cmlg43ice00f6pv85xunvvrqr	18000.00
cmlg43ig500fhpv85jcaok1ir	cmlg43ig400fgpv85ndykm7aj	25000.00
cmlg43im900fnpv85j9z81ia9	cmlg43im900flpv85zd3nouuu	29000.00
cmlg43irl00ftpv8517vnrikt	cmlg43irl00frpv857lt88nri	102000.00
cmlg43iu700g4pv858n5c1srf	cmlg43iu600g2pv857glc32sb	36000.00
cmlg43j9j00gdpv85pdw5ki1m	cmlg43j9j00gcpv85vsmmw0c2	78000.00
cmlg43jam00gjpv85gepfa0r2	cmlg43jam00ghpv85sjt88620	80000.00
cmlg43jt500gtpv857itshtow	cmlg43jt500gnpv85xsdnx79s	25000.00
cmlg43jt500grpv85e3hbjodb	cmlg43jt500glpv854k6sqmud	27000.00
cmlg43jzu00h4pv85l3336qc4	cmlg43jzu00h2pv85lp7crxom	64000.00
cmlg43k8a00hqpv85n8nc9qbo	cmlg43k8900hnpv8555g3cu9s	131000.00
cmlg43kg000hzpv85qfut4aew	cmlg43kg000hwpv855rfzb9dm	134000.00
cmlg43k5800hfpv85nlq0lwjq	cmlg43k5700hdpv85cxg7ssbd	202000.00
cmlg43kmg00i7pv85uragkn5n	cmlg43kmg00i5pv85krrq3fdg	188000.00
cmlg43kpl00ibpv85l2iz9o7h	cmlg43kpl00iapv85ripiyn1i	110000.00
cmlg43ktm00inpv858p42in2s	cmlg43ktm00impv850mvefkyi	581000.00
cmlg43ksb00ilpv85gdjc5lj8	cmlg43ksb00ijpv85x4vsywdn	111000.00
cmlg43ksb00ikpv85dibjpke3	cmlg43ksb00iipv853o74ai86	124000.00
cmlg43kwl00itpv85fb7819cy	cmlg43kwl00ispv85ukp8k1v3	45000.00
cmlg43ky000ivpv85243zjqec	cmlg43ky000iupv85crfqm1kn	73000.00
cmlg43l1z00j4pv85efem3drt	cmlg43l1z00izpv85xo6j8ltq	54000.00
cmlg43l1z00j2pv85iwa1uvhb	cmlg43l1z00iypv8516swxnyy	63000.00
cmlg43l1z00j5pv85l6j5phwh	cmlg43l1z00j1pv856te8pbx1	0.00
cmlg43l5v00jbpv85evqxbe8b	cmlg43l5v00japv85zvjfffy3	714000.00
cmlg43l7300jdpv85t2vubtq5	cmlg43l7300jcpv85nzyg6b5y	94000.00
cmlg43l9i00jfpv85xgyynncq	cmlg43l9i00jepv850uynxur3	41000.00
cmlg43lfx00jrpv859xn5f4gc	cmlg43lfw00jqpv8571ikp5mk	464000.00
cmlg43lhe00jvpv85camb2oy8	cmlg43lhe00jupv85n0q0km59	181000.00
cmlg43lnh00k5pv85bg3vkjio	cmlg43lnh00k4pv85ztfs7pwo	43000.00
cmlg43lo600k9pv85w9yluvo3	cmlg43lo600k8pv85gqlocb5x	60000.00
cmlg43lot00kbpv85o1p7am95	cmlg43lot00kapv85k5yt5mdu	0.00
cmlg43lnn00k7pv85ow91993k	cmlg43lnn00k6pv85pb84x8el	178000.00
cmlg43lq400kdpv8509k2e33x	cmlg43lq400kcpv85hnousiw5	114000.00
cmlg43lec00jnpv8501ej52ee	cmlg43lec00jmpv85088xrrsz	104000.00
cmlg43lee00jppv85tsb0snav	cmlg43led00jopv85ect6w4ax	80000.00
cmlg43lul00kfpv85kdnv8ngy	cmlg43lul00kepv85wlmjhkpx	90000.00
cmlg43lfx00jtpv85wfuhakza	cmlg43lfx00jspv85j9jjwl02	80000.00
cmlg43lvs00khpv85ucmrkfu9	cmlg43lvr00kgpv85y2wlszve	98000.00
cmlg43lwe00klpv8502ao87nv	cmlg43lwe00kipv85q6svgz78	91000.00
cmlg43lwe00kkpv85go574p70	cmlg43lwe00kjpv85393u7yiw	25000.00
cmlg43lxq00knpv85hk5xaia9	cmlg43lxq00kmpv85t2axx6mm	56000.00
cmlg43lkd00k2pv85fhvqoc5g	cmlg43lkd00k0pv85c7zl1h9y	85000.00
cmlg43m1l00kppv85f3jaxe2u	cmlg43m1l00kopv853j3jex6l	83000.00
cmlg43m2600krpv85z2xy19fc	cmlg43m2600kqpv857j20dedy	51000.00
cmlg43m2r00ktpv85a6pnouku	cmlg43m2r00kspv85sz64ajhr	133000.00
cmlg43m3k00kvpv85ii8h3yg0	cmlg43m3k00kupv85d9ildmcs	114000.00
cmlg43m5000kxpv85s7404gdg	cmlg43m5000kwpv85d4cdt64s	28000.00
cmlg43m9t00kzpv853fbr7pe2	cmlg43m9t00kypv85uhrm7xch	86000.00
cmlg43mbu00l7pv85h94zuahi	cmlg43mbu00l6pv85l4goqo7r	93000.00
cmlezx8i001b339t5ohpkayg0	cmlezx8i001b239t5vc25o1io	34000.00
cmlezx8nv01bh39t5y7vigdwv	cmlezx8nv01be39t5ryzxcqgn	81000.00
cmlezx8tp01bx39t5fcmxefw6	cmlezx8tp01bw39t5u1lbhngi	83000.00
cmlezx8tp01c139t5is7lfjoh	cmlezx8tp01bz39t54u5nttof	24000.00
cmlezx8tp01c039t5wua7uw5b	cmlezx8tp01by39t50e0m55l1	53000.00
cmlezx8vq01c739t53cvuz07r	cmlezx8vq01c639t50l6503w5	29000.00
cmlezx8um01c339t5byxjsk3p	cmlezx8um01c239t5n45b627e	37000.00
cmlezx8wb01c939t5dhowwjqj	cmlezx8wb01c839t5d5hk8aow	52000.00
cmlezx8vc01c539t5s30gtzao	cmlezx8vc01c439t5f7urkng1	25000.00
cmlezx8y101cb39t5qz1g09zc	cmlezx8y001ca39t5g9oxsbv7	87000.00
cmlezx8ys01cd39t53juuhnmg	cmlezx8ys01cc39t54bagtmd3	28000.00
cmlezx91m01cf39t5jk98w5hb	cmlezx91m01ce39t5h4ilbtn2	59000.00
cmlezx91n01ci39t5ep7zrr9j	cmlezx91n01cg39t5ty6fzhu7	26000.00
cmlezx91n01ck39t5d4t994h0	cmlezx91n01ch39t5vqwutrsz	53000.00
cmlezx91n01cl39t5b7n840mv	cmlezx91n01cj39t59cq5ug2n	30000.00
cmlezx92y01cn39t59g531xfa	cmlezx92y01cm39t5tr3a2wvo	53000.00
cmlezx93301cp39t53snp4vh0	cmlezx93301co39t5e0bp216y	117000.00
cmlezx93v01cr39t5h6jnl3ex	cmlezx93v01cq39t58fmlg2ir	36000.00
cmlezx96x01ct39t52m5b8lus	cmlezx96x01cs39t5vzyle4dp	105000.00
cmlezx98d01cx39t5c50qsxp2	cmlezx98d01cw39t5hsjieawz	92000.00
cmlezx97r01cv39t5d6zded3x	cmlezx97r01cu39t5o78q9b10	56000.00
cmlezx98e01d139t5x972wqq4	cmlezx98e01d039t5c18if6oz	21000.00
cmlezx98d01cz39t5kfis7tzz	cmlezx98d01cy39t57tv2s65s	32000.00
cmlezx99301d339t5agixqfor	cmlezx99301d239t59vohfmwy	40000.00
cmlezx99j01d539t5cp5am6aa	cmlezx99j01d439t5n0h6mb1z	34000.00
cmlezx99r01d739t5onwfifkz	cmlezx99r01d639t5lt02wxyt	26000.00
cmlezx9dm01db39t57vmdniwu	cmlezx9dm01da39t5ljrb0wtt	20000.00
cmlezx9fd01dd39t5rfv9b7fw	cmlezx9fd01dc39t5bgeplxm9	44000.00
cmlezx9fd01dh39t53duam8ro	cmlezx9fd01df39t5i1k7tk8y	30000.00
cmlezx9fd01dj39t5q4jmoabp	cmlezx9fd01dg39t5pmn57fig	28000.00
cmlezx9fd01di39t5nv8kjhcw	cmlezx9fd01de39t5ki1kr0n1	44000.00
cmlezx9bu01d939t5fompbp63	cmlezx9bu01d839t597u63p4i	30000.00
cmlezx9gf01dl39t5uwo99cuw	cmlezx9gf01dk39t5yo88ysm4	245000.00
cmlezx9jk01dr39t5z9089v7p	cmlezx9jk01dp39t57q58z836	81000.00
cmlezx9hm01dn39t5gijkqpga	cmlezx9hm01dm39t50acjqpie	107000.00
cmlezx9jk01dq39t5yfdg0hzs	cmlezx9jk01do39t5zwkybkdl	0.00
cmlezx9lz01dv39t5x4iochrz	cmlezx9lz01dt39t51cjiy2tm	39000.00
cmlezx9lz01dx39t5y93lzvm3	cmlezx9lz01ds39t5f7nwqhv9	126000.00
cmlezx9lz01dw39t5zh9jgfv4	cmlezx9lz01du39t5v26atjgf	59000.00
cmlezxa1a01e239t5cn3pii8c	cmlezxa1a01dy39t53khm6c8b	22000.00
cmlezxa1a01e939t55rq63qam	cmlezxa1a01e739t5cptnd3ym	30000.00
cmlezxa1a01e439t58z6wult6	cmlezxa1a01dz39t53jr8cs9o	37000.00
cmlezxa1a01ed39t5n07wpsfu	cmlezxa1a01ec39t50s1el49f	29000.00
cmlezxa1b01ee39t5miqiui3b	cmlezxa1a01eb39t54cl83lfr	44000.00
cmlezxa1a01ea39t518uoc5ok	cmlezxa1a01e839t5icxdbbsa	42000.00
cmlezxa1b01ef39t5664qkiua	cmlezxa1a01e639t5hrv39ded	53000.00
cmlezxa1a01e539t5oij3yabu	cmlezxa1a01e139t5xlso8b7z	30000.00
cmlezxa1a01e339t5sn33e5if	cmlezxa1a01e039t5ikoirmub	43000.00
cmlezxaai01ei39t5tzxtctj9	cmlezxaai01eg39t5e6r5a5id	22000.00
cmlezxaai01ej39t59o0z5rl4	cmlezxaai01eh39t58pf76u10	21000.00
cmlezxaan01el39t5u4s79fr9	cmlezxaan01ek39t54dvrjvqg	82000.00
cmlezxabs01eo39t5oos0mza1	cmlezxabs01em39t5ere2e019	0.00
cmlezxabs01eq39t5zl8fxp7s	cmlezxabs01en39t5qgwkuuqv	23000.00
cmlezxabs01er39t5mtelu351	cmlezxabs01ep39t54u50k8ta	28000.00
cmlezxabu01et39t590flfpil	cmlezxabt01es39t51mwax6gp	23000.00
cmlezxagx01ev39t54u7drycj	cmlezxagx01eu39t5xdjiyarl	44000.00
cmlezxagx01ex39t5dngd4c71	cmlezxagx01ew39t5aja80vh9	32000.00
cmlezxakm01ez39t5qi936wh9	cmlezxakm01ey39t5wv7hbx2t	72000.00
cmlezxal001f139t562o9eekp	cmlezxal001f039t5mz7dn2a1	23000.00
cmlezxall01f339t5b2hudxr9	cmlezxall01f239t5zm2hom3s	34000.00
cmlezxalu01f539t53n32pnl2	cmlezxalu01f439t5kpdidv93	47000.00
cmlezxalu01f939t5ufctj8ww	cmlezxalu01f739t5950jpa1d	25000.00
cmlezxalu01f839t5t8suu303	cmlezxalu01f639t55qxmd6ed	36000.00
cmlezxanf01fd39t5gquu84y4	cmlezxanf01fb39t5oru5s798	33000.00
cmlezxanf01fc39t532vqhcvm	cmlezxanf01fa39t5a74dsvgb	97000.00
cmlezxaq701ff39t5t6v82s53	cmlezxaq701fe39t58zr4mqna	62000.00
cmlezxaqy01fh39t5chl6rjba	cmlezxaqy01fg39t572wgdiex	45000.00
cmlezxarv01fl39t5gkutaod8	cmlezxaru01fk39t5sphmhuna	41000.00
cmlezxasi01fr39t5ew3mz9ax	cmlezxasi01fp39t5ei8ivm0u	41000.00
cmlezxasi01fn39t5m1jo0y37	cmlezxasi01fm39t5ox51g1ig	41000.00
cmlezxasi01fq39t5hq9mj9e2	cmlezxasi01fo39t5e4u2rt0n	34000.00
cmlezxawd01ft39t5mw6zhu0f	cmlezxawd01fs39t51r3wvt65	47000.00
cmlezxay301fv39t5k5lnn1sn	cmlezxay301fu39t5vd8kuw6w	31000.00
cmlezxayr01g139t5pol712i8	cmlezxayr01g039t5p4w065ao	31000.00
cmlezxarj01fj39t5dtt5dhba	cmlezxarj01fi39t51ns9c4ks	33000.00
cmlezxazn01g539t5emcpm3ko	cmlezxazn01g439t5eczqvcaq	49000.00
cmlezxazc01g339t598bw0fi7	cmlezxazc01g239t5jl9yrla4	46000.00
cmlezxazn01g739t5hgh32rj0	cmlezxazn01g639t5o8cy6six	29000.00
cmlezxay901fz39t5mu5l4pxm	cmlezxay901fx39t5xxvsodid	30000.00
cmlezxay901fy39t5dcnz86v9	cmlezxay901fw39t5qy98lmh7	35000.00
cmlezxb3b01g939t57xfg9wkm	cmlezxb3b01g839t5mgr1hemj	42000.00
cmlezxb4k01gb39t5qr76lb3t	cmlezxb4k01ga39t5tp0h3ezy	32000.00
cmlezxb5601gd39t57o6dqwbc	cmlezxb5601gc39t5klciot0e	26000.00
cmlezxb5y01gi39t5qkl7mdpr	cmlezxb5y01gf39t5gq0elkuo	33000.00
cmlezxb5y01gj39t5wj09k8pn	cmlezxb5y01gg39t58ruhpddu	85000.00
cmlezxb5y01gh39t5z5r2r8cb	cmlezxb5y01ge39t5ks7g93a8	19000.00
cmlezxb6p01gl39t5gvazjia4	cmlezxb6p01gk39t5avdtet8p	54000.00
cmlezxb7e01gp39t53y8cfzm5	cmlezxb7e01gn39t5eug9v9fb	140000.00
cmlezxb7e01go39t571pf918n	cmlezxb7e01gm39t58aqsratn	25000.00
cmlezxbet01h739t5rcr5e4db	cmlezxbet01h439t5sdbaqdd6	82000.00
cmlezxblm01hp39t56c93p5gr	cmlezxbll01hn39t51pfd0qeb	27000.00
cmlezxbsl01i839t596blvvng	cmlezxbsl01i639t5sv78bze5	47000.00
cmlezxbze01ip39t5ph0qt7ui	cmlezxbze01in39t5g383xzjz	51000.00
cmlezxc7x01j739t51ypnlhsv	cmlezxc7w01j639t5sui50yzq	75000.00
cmlezxco801jx39t5yyzprlas	cmlezxco801jw39t5t0s1odke	142000.00
cmlezxcvo01k939t5aureim2l	cmlezxcvo01k639t5v5u1k2a9	99000.00
cmlezxd1o01kt39t5kdrw7q9p	cmlezxd1o01ks39t56dv3ac56	93000.00
cmlezxd7a01l839t5h1dgljkm	cmlezxd7a01l739t5ly88utlb	146000.00
cmlezxdec01ln39t59nfkxxlk	cmlezxdec01lm39t5yjl3u3ph	87000.00
cmlezxdk301m439t56pnx4tte	cmlezxdk301m139t5cugdwp3j	14000.00
cmlezxdqq01mo39t5s9qcjd5h	cmlezxdqq01mi39t57rhf4iho	151000.00
cmlezxdwg01n339t5ki7m1wa4	cmlezxdwg01n239t5wepr51e6	23000.00
cmlezxe1u01nf39t5cakj27g9	cmlezxe1u01nd39t5nzfbdwdj	244000.00
cmlezxe8901nx39t5d0zfk3on	cmlezxe8901nw39t5n3w8hzhd	246000.00
cmlezxees01of39t552pnl5ny	cmlezxees01oe39t5skcqns30	151000.00
cmlezxekr01or39t59kjvfuhr	cmlezxekr01oq39t5j66snlpf	75000.00
cmlezxez101pb39t5lchul3jt	cmlezxez101p639t5xxltiiby	249000.00
cmlezxf5j01pn39t5an4pkwp4	cmlezxf5i01pm39t5x11pcnox	228000.00
cmlezxfgv01qf39t51ink9kau	cmlezxfgv01qe39t5i6c4sa35	467000.00
cmlezxfno01qx39t5k8rpc3zv	cmlezxfno01qw39t5fngn76c1	179000.00
cmlezxftt01rg39t54gwe1f02	cmlezxfts01re39t55i7hvm6s	126000.00
cmlezxfyu01rt39t5eh5n58po	cmlezxfyu01rs39t5hmqcj38z	135000.00
cmlezxgbw01sn39t53ki3287o	cmlezxgbw01sm39t5l8kgo9lg	54000.00
cmlezxgij01t139t5xnr7jfx1	cmlezxgij01t039t5ooqfv3oc	205000.00
cmlezxgv701tj39t5oaym3gi0	cmlezxgv701ti39t5juiqzylp	245000.00
cmlezxh1u01u139t5gt1x25id	cmlezxh1u01u039t5nvvqcu1v	76000.00
cmlezxh8d01uf39t5a2rhk5wt	cmlezxh8d01ue39t5t5luvn68	46000.00
cmlezxhwt01uw39t5039d5f3u	cmlezxhwt01um39t5lqp87glk	53000.00
cmlezxi4c01v539t5r90lw02s	cmlezxi4c01v439t5da4le2vm	128000.00
cmlezxicf01vn39t58al6jjq0	cmlezxicf01vm39t55op9ooki	86000.00
cmlezxiii01w539t5tqm42e4w	cmlezxiii01w439t5vkvnnmm4	204000.00
cmlezxinl01wl39t5b3dr9ofj	cmlezxinl01wk39t5w34wtlia	191000.00
cmlezxiuk01x339t5qvgs57l7	cmlezxiuk01x239t5m65e580l	301000.00
cmlezxizn01xa39t502cve3x3	cmlezxizn01x839t536j5tl0y	124000.00
cmlezxjcl01y339t53zijp6xz	cmlezxjcl01y239t53nfg24d5	187000.00
cmlezxjqf01z139t5j1dhhqvr	cmlezxjqf01z039t582t8osvz	83000.00
cmlezxjwv01zj39t5t54z2alz	cmlezxjwv01zh39t5lhkbq8my	29000.00
cmlezxk3t01zz39t5kyatcrzt	cmlezxk3t01zy39t5xkkhej9x	90000.00
cmlezxkty020l39t5kunmkeqh	cmlezxkty020k39t5le2ipbem	31000.00
cmlezxlab020z39t5135he50m	cmlezxlab020y39t5vdtr077z	44000.00
cmlezxm3s022l39t5cx5v3w70	cmlezxm3s022k39t5hqdqaqzy	0.00
cmlezxmlu023u39t542p60u3a	cmlezxmlu023r39t5f1s56n94	134000.00
cmlezxn5t025d39t59siyvt3u	cmlezxn5t025c39t5iw6rek53	17000.00
cmlezxnxs026339t59szlb590	cmlezxnxs025z39t54a08zuqt	0.00
cmlezxo3v026d39t5q99pg09j	cmlezxo3v026c39t589gwahkc	24000.00
cmlezxoa4026u39t5xth4zzdo	cmlezxoa4026s39t5k0sl611r	87000.00
cmlezxonp027x39t5vctfrr89	cmlezxonp027v39t511cbvq6g	26000.00
cmlezxovv028h39t5pxsh8gkz	cmlezxovv028f39t55kzae9rz	13000.00
cmlg3slt9000ferj0y685ai9g	cmlg3slt8000eerj0bw05u5p5	67000.00
cmlg3smim000nerj00nh0zr8c	cmlg3smim000merj0pe2ipafv	64000.00
cmlg3smtz000verj09ssivny8	cmlg3smtz000uerj0t1dx9smm	24000.00
cmlg3sn5q0010erj0ryhncbb1	cmlg3sn5q000zerj0egt9m73f	66000.00
cmlg3snlk001eerj04ickgqny	cmlg3snlk001derj0iu4800sm	67000.00
cmlg3so0k001qerj0k6webizi	cmlg3so0k001oerj0ceb7hhhs	92000.00
cmlg3soik0023erj0d0lqhmax	cmlg3soik0020erj0my4syzj4	76000.00
cmlg3soyf002ferj0m6jcfk5k	cmlg3soyf002cerj0bgtyg3q0	64000.00
cmlg3spde002terj0ks2tbaa9	cmlg3spde002serj0wmx6uxb0	53000.00
cmlg3spl00034erj05s8g7zsp	cmlg3spl00032erj0utoaeu9w	101000.00
cmlg3spvb003gerj0fx2krv75	cmlg3spvb003eerj066h13ln2	19000.00
cmlg3t0j2000pq2fkvzjxm2jd	cmlg3t0j2000oq2fkczqg7xha	148000.00
cmlg3t1hn000zq2fk1x6k2yzk	cmlg3t1hn000yq2fkytn3a3mm	26000.00
cmlg43b23004lpv853zfnjb2c	cmlg43b23004kpv85evevabil	81000.00
cmlg43d82005rpv856f6ztfkc	cmlg43d82005qpv856rryxmdo	88000.00
cmlg43dia0061pv85upnk2dtc	cmlg43dia0060pv85q37hoydc	159000.00
cmlg43dse006jpv857cz4npyf	cmlg43dse006hpv85yu9z3vz6	159000.00
cmlg43dzh006tpv850ow63pkr	cmlg43dzh006qpv85q2x58mmp	71000.00
cmlg43e8j007fpv85zihn9siz	cmlg43e8j007epv856poo04yo	59000.00
cmlg43eer007xpv85op8k0wz0	cmlg43eer007vpv85qis17kxr	60000.00
cmlg43elh0089pv85r0zkjxtt	cmlg43elh0088pv85n18rd8oa	45000.00
cmlg43etd008rpv85kocbivad	cmlg43etd008qpv85313wfny9	114000.00
cmlg43f4n009bpv85kj03g67a	cmlg43f4n009apv8565lmqrx2	65000.00
cmlg43fdr009rpv85icmsc5a7	cmlg43fdq009qpv85q84dhea1	55000.00
cmlg43fo600a7pv85ajoogvb1	cmlg43fo600a4pv85nvhjds69	95000.00
cmlg43fx700azpv85vv6o3s11	cmlg43fx700axpv85t2qg8oqc	55000.00
cmlg43gdx00bhpv85x324kpbs	cmlg43gdx00bgpv85yqg20a5k	92000.00
cmlg43gln00bjpv85s787an7i	cmlg43gln00bipv85knbbms8v	91000.00
cmlg43gs000c3pv85ryrmiaue	cmlg43gs000c1pv85zmtqv72o	80000.00
cmlg43gxz00ckpv85zlkklysb	cmlg43gxz00cjpv857ln769xa	166000.00
cmlg43h5400d3pv858xx0s0mg	cmlg43h5400d2pv85t6fmysyy	95000.00
cmlg43heo00dnpv85sxxojtq5	cmlg43heo00dlpv85s9lhiqqy	55000.00
cmlg43hmg00e5pv85yeo9fy9o	cmlg43hmg00e4pv85vaw93y7r	35000.00
cmlg43i3t00ewpv85vq92y3m4	cmlg43i3t00eupv85vfib3yvb	53000.00
cmlg43idz00fbpv85gimox9pd	cmlg43idz00fapv85ynevqeqw	24000.00
cmlg43ien00fdpv85ldla88o5	cmlg43iem00fcpv85d4qbk4xu	31000.00
cmlezxb9q01gr39t5i2bji0pe	cmlezxb9q01gq39t5e5xz9idz	85000.00
cmlezxbg901h939t57dnbxlp4	cmlezxbg901h839t5pdeva7rx	34000.00
cmlezxbmh01hr39t58j43kzfu	cmlezxbmh01hq39t5vwhoh5po	27000.00
cmlezxbrw01i539t53ivi2g7i	cmlezxbrw01i439t5i5purxl6	41000.00
cmlezxbxt01il39t5cibb50d1	cmlezxbxt01ik39t5vu9l25ud	46000.00
cmlezxc3g01iv39t53ouaga3m	cmlezxc3g01iu39t5lipi3hmb	61000.00
cmlezxcba01jd39t58jply4yo	cmlezxcba01jc39t58a7xitbx	187000.00
cmlezxco801jp39t5b6wp12jl	cmlezxco801jl39t5wq9lvzlr	75139.81
cmlezxcvo01kb39t5i3w7manx	cmlezxcvo01k839t5x3m7yexm	69000.00
cmlezxd1g01kp39t59yaowi4m	cmlezxd1g01ko39t5nocd1pog	65000.00
cmlezxd7a01l939t5bvditkkd	cmlezxd7a01l639t5vj9oa9mq	154000.00
cmlezxdee01lp39t50e36rjy6	cmlezxdee01lo39t5846zc447	22000.00
cmlezxdk301m339t5vzs4l3u5	cmlezxdk301lz39t5ygnbtlqw	18000.00
cmlezxdqq01mm39t5vx43rvdi	cmlezxdqq01mk39t5qpcomnl0	0.00
cmlezxdw101mv39t5vqte1rte	cmlezxdw101mu39t5q5i178zt	160000.00
cmlezxe1501n939t5fqea59hy	cmlezxe1501n839t5dcsgcplk	165000.00
cmlezxedk01o939t55j637wxg	cmlezxedk01o839t5sn4ituit	153000.00
cmlezxejj01on39t5skzqq6cu	cmlezxejj01ol39t5t6ck6zlk	160000.00
cmlezxepa01oz39t5t6n28oci	cmlezxepa01oy39t58gha9wwl	73000.00
cmlezxez101pf39t5d4pvt64y	cmlezxez101pe39t5hzysm6tl	467000.00
cmlezxf6501pt39t50x382gzh	cmlezxf6501ps39t5357z8imt	185000.00
cmlezxfcr01q939t5bl6wqbqi	cmlezxfcq01q639t50p0wv3zm	214000.00
cmlezxfjn01qr39t5q43d1qwj	cmlezxfjn01qq39t5jnaq7pk3	223000.00
cmlezxfrx01rb39t50gxgg0nc	cmlezxfrx01ra39t53t2u27er	69000.00
cmlezxfz901rv39t5bwejnplg	cmlezxfz901ru39t5g8w5kmhb	95000.00
cmlezxg5m01sb39t5n5ynyfcd	cmlezxg5m01sa39t5clz8f1nc	64000.00
cmlezxgbs01sl39t5aqws2dq9	cmlezxgbr01sk39t5zcmkfc5n	64000.00
cmlezxgrr01th39t515u3djfp	cmlezxgrr01tg39t59g8ldlyr	150000.00
cmlezxgyg01tx39t5t0kmekak	cmlezxgyg01tw39t5hcnbxa6g	77000.00
cmlezxh4q01ud39t5mao7m7lk	cmlezxh4q01uc39t5phnqnhzm	37000.00
cmlezxhb001ul39t5zte9l5ha	cmlezxhb001uj39t5impyogjq	58000.00
cmlezxhwt01uy39t54ro3rmsw	cmlezxhwt01ur39t5clotdgx6	66000.00
cmlezxi4z01v939t50k5m7wbm	cmlezxi4z01v839t5xrvhxj6c	102000.00
cmlezxidx01vp39t59m17hxc7	cmlezxidx01vo39t54igg5aqt	261000.00
cmlezxik101w939t5punuocv0	cmlezxik101w639t5id4v5i1g	204000.00
cmlezxiqm01wn39t5f7ghminp	cmlezxiqm01wm39t5zdriisu0	191000.00
cmlezxixx01x739t51ubtjuo5	cmlezxixx01x639t5fn24rzun	83000.00
cmlezxj9d01xt39t5n6grm7s4	cmlezxj9d01xs39t5hlkrzzxy	20000.00
cmlezxjg201yd39t54di7fqg1	cmlezxjg201yc39t553ebspnz	295000.00
cmlezxjs601z939t50yagd1l8	cmlezxjs601z839t5t465zhzn	40000.00
cmlezxjz701zv39t56kidxdih	cmlezxjz701zu39t54h1eh1kg	87000.00
cmlezxkty020n39t5rhlyr07s	cmlezxkty020m39t5fwkqp098	24000.00
cmlezxl68020r39t5z3vblq4o	cmlezxl67020q39t5nc505x9a	0.00
cmlezxlg1021339t5ckcfgr5r	cmlezxlg1021239t5ssa036uj	33000.00
cmlezxln8021i39t5bqwc0dad	cmlezxln8021g39t5ds28mn08	34000.00
cmlezxlt7021v39t5zwltasi0	cmlezxlt6021u39t59hckaerz	37000.00
cmlezxlz2022b39t5s35cd97g	cmlezxlz2022a39t5hiwbp4xr	28000.00
cmlezxm3s022j39t5n8zeda6w	cmlezxm3s022i39t55x22xh87	41000.00
cmlezxmjh023p39t5znjns1fl	cmlezxmjh023o39t5m8aidix7	23000.00
cmlezxmpo024739t570iy3n9e	cmlezxmpo024639t5yrvjrfac	26000.00
cmlezxmwf024l39t50huzwvb6	cmlezxmwf024k39t5ks0gbwih	25000.00
cmlezxn29024z39t5655z0jkg	cmlezxn29024y39t53i9oeji8	0.00
cmlezxn7n025h39t59whnedr9	cmlezxn7n025g39t56xt3q1d3	0.00
cmlezxnxs025u39t5ol566esb	cmlezxnxs025s39t5dzrtoafe	12000.00
cmlezxo4h026f39t563nzm9gs	cmlezxo4h026e39t5ary9t9i9	29000.00
cmlezxoa4026v39t5zt49kw9i	cmlezxoa4026t39t55owvcpkd	25000.00
cmlezxonp027w39t5t8gah74l	cmlezxonp027u39t5z9g1zl2x	18000.00
cmlezxov7028d39t5p5etohu0	cmlezxov7028c39t5jeq8qqbd	150000.00
cmlezxp0j028q39t5qqej1g7n	cmlezxp0j028m39t5h28zrcjx	0.00
cmlezxp6i028z39t5omtucva5	cmlezxp6i028y39t5pkvfflmv	14000.00
cmlg3smff000herj0k3rvflap	cmlg3smff000gerj0yjartctw	123000.00
cmlg3smpn000perj07vahffdm	cmlg3smpn000oerj0sz6efhxx	26000.00
cmlg3sn1z000xerj0qv8og7mi	cmlg3sn1z000werj01edx5njn	28000.00
cmlg3snc20015erj0aqq5p89j	cmlg3snc20014erj0mido9jjx	51000.00
cmlg3snnc001herj082pqcc48	cmlg3snnc001gerj01n0fr4e9	19000.00
cmlg3so0k001terj0i0p6c5r8	cmlg3so0k001serj0z2ygnmdw	94000.00
cmlg3soil0025erj01gsapy93	cmlg3soik0024erj0dgktsljz	73000.00
cmlg3soyf002herj01ix6jiez	cmlg3soyf002eerj0bki8uhfb	82000.00
cmlg3spfl002xerj0iabq1uvr	cmlg3spfl002werj0h5f966zw	97000.00
cmlg3spn80039erj01aymsuak	cmlg3spn80038erj0nyti4o2p	60000.00
cmlg3spz5003lerj0svj1u4pk	cmlg3spz5003kerj05oeb7p5y	55000.00
cmlg3syeh0003q2fk3cg7eh70	cmlg3syeh0002q2fkfhonfl7k	28000.00
cmlg3syxw0007q2fkho23t5iy	cmlg3syxv0006q2fkfd6ygyl7	52000.00
cmlg3szn6000fq2fkftjjbtq7	cmlg3szn6000eq2fkhixy28ug	17000.00
cmlg3t1mk0011q2fk5vzjdits	cmlg3t1mk0010q2fk6eju8iws	21000.00
cmlg3tfdn0001vtxi5tto0uo4	cmlg3tfdn0000vtxinvaw7i80	58000.00
cmlg3tiwu0003vtxipn0ac6o4	cmlg3tiwt0002vtxid6n8byqn	44000.00
cmlg43biu0057pv851yvsfvjd	cmlg43biu0056pv85rechg5tn	86000.00
cmlg43d82005opv85fi045058	cmlg43d82005npv85b18cg9pv	84000.00
cmlg43dib0063pv85883l5daf	cmlg43dib0062pv85w85gwvee	98000.00
cmlg43dse006kpv8523jm4cd9	cmlg43dse006ipv859csizt3s	69000.00
cmlg43dzh006vpv85fwmom0cz	cmlg43dzh006spv85dzuw4gus	132000.00
cmlg43e5m0079pv85cf4lrl32	cmlg43e5m0078pv85l9y904su	110000.00
cmlg43edf007rpv857y15gvrb	cmlg43edf007qpv85xisj1hsx	82000.00
cmlg43ek00081pv85twak9tqi	cmlg43ek00080pv85f6uavzfb	78000.00
cmlg43eqg008jpv85vbmvidu7	cmlg43eqg008ipv85ga7z3x4b	78000.00
cmlezxbb901gt39t5lp7qk5ii	cmlezxbb801gs39t5wzyjcqpo	36000.00
cmlezxbij01hb39t50khef1iw	cmlezxbij01ha39t517eaxv00	110000.00
cmlezxbp801hx39t5u4ckd3dl	cmlezxbp801hw39t5yijde3ri	53000.00
cmlezxbvc01id39t5u497znma	cmlezxbvc01ic39t595igjvcr	103000.00
cmlezxc0t01ir39t5147ofgtw	cmlezxc0t01iq39t5j4tq6pkf	153000.00
cmlezxc7e01j339t59wor3wkr	cmlezxc7e01j239t5cx9wlt7m	99000.00
cmlezxco801jo39t52o529xo6	cmlezxco801ji39t59kqbifzh	147000.00
cmlezxcvo01kd39t5frb6201e	cmlezxcvo01kc39t53pxbi6wj	110000.00
cmlezxd1g01kr39t5gqkq8rjn	cmlezxd1g01kq39t5271hao09	296000.00
cmlezxd7a01l439t58mjyw8ib	cmlezxd7901l339t5m9wii2yg	0.00
cmlezxde901lj39t5z4viximi	cmlezxde901li39t5zfxj9dmb	14000.00
cmlezxdk801m739t5dfbh3kls	cmlezxdk801m639t5c9mivtqs	13000.00
cmlezxdqo01mf39t5ybok6qkm	cmlezxdqo01me39t5v0nyji8c	13000.00
cmlezxdwj01n739t5wn5to7vs	cmlezxdwj01n639t5ic8afsos	228000.00
cmlezxe2h01nk39t5fmt12ujg	cmlezxe2h01nj39t5ltvievak	244000.00
cmlezxe8x01o139t56e37tw5c	cmlezxe8x01o039t5bs3uniff	94000.00
cmlezxees01od39t5m1z94oxj	cmlezxees01oc39t5gbp57uuz	157000.00
cmlezxeks01ot39t534htg1nl	cmlezxeks01os39t5e9rtmf3o	74218.45
cmlezxez101p839t5c6lny4sv	cmlezxez101p539t5he828gw7	136000.00
cmlezxf6501pr39t5jxmotbag	cmlezxf6501pq39t5u4zr6pat	0.00
cmlezxfcr01qb39t5yiqmzehj	cmlezxfcr01q739t53k87doqr	252000.00
cmlezxfim01ql39t5no6e861f	cmlezxfim01qk39t5jta2chch	223000.00
cmlezxfoe01qz39t59c9n81pf	cmlezxfoe01qy39t5okn4ijh5	60000.00
cmlezxftt01rh39t5fq7s4ulh	cmlezxftt01rf39t58mjv7i95	95000.00
cmlezxfze01rx39t58xm192vn	cmlezxfze01rw39t5ltsvrefb	60000.00
cmlezxg7601sf39t5y938ic5f	cmlezxg7601se39t5dju4tgap	236000.00
cmlezxgje01t339t5f4o0pf3f	cmlezxgje01t239t5t5pp6jwh	130000.00
cmlezxgvi01tl39t50zqy3675	cmlezxgvi01tk39t5votgxwic	219000.00
cmlezxhwu01v239t5ij8uarnf	cmlezxhwu01v139t5gzjkywu9	149000.00
cmlezxi5001vb39t5n8yja48u	cmlezxi4z01va39t5abqehbkl	82000.00
cmlezxidz01vt39t5tnzwhdrb	cmlezxidz01vs39t560py1xsl	0.00
cmlezxikr01wj39t5xecjr3q6	cmlezxikr01wi39t5alfrpz4r	129000.00
cmlezxiry01x039t56ns8y62p	cmlezxiry01wy39t5d0e7z37c	191000.00
cmlezxizw01xd39t54wb6e905	cmlezxizw01xc39t5ynq2q2gm	163000.00
cmlezxjai01xx39t5pyw9bzej	cmlezxjai01xw39t5sg05wllk	50000.00
cmlezxjh701yh39t5usz1lpuo	cmlezxjh701yg39t5zn2dsfs9	187000.00
cmlezxjt501zd39t5bvzq1d4z	cmlezxjt501zc39t5pn448m7s	25000.00
cmlezxjy201zp39t5aqcr3mbb	cmlezxjy201zo39t5acsfbhya	98000.00
cmlezxk6c020539t5ah857spr	cmlezxk6b020439t5jyw7l0vh	89000.00
cmlezxkty020i39t5s6r43kv6	cmlezxkty020g39t57jfdwbmg	240000.00
cmlezxl67020p39t5bmv4vcdx	cmlezxl67020o39t5nufecs27	55000.00
cmlezxlg1021639t5kbx1b2hk	cmlezxlg1021439t5zbg40ak4	41000.00
cmlezxln8021h39t5onycdwa9	cmlezxln8021e39t5vc5fagsd	36000.00
cmlezxlt0021r39t52n9bdqel	cmlezxlt0021q39t53rlvkdo8	22000.00
cmlezxlyz022739t5vrhd74f8	cmlezxlyz022639t5pwgtlohi	20000.00
cmlezxm51022t39t51k4gn442	cmlezxm51022s39t5ffjebj1e	112000.00
cmlezxmap023439t5zhzcgns4	cmlezxmap023239t5uhmi93lm	14000.00
cmlezxmgt023j39t5ctbv6kaz	cmlezxmgs023i39t59j6irl4i	23000.00
cmlezxmn3024039t5vu5x83i1	cmlezxmn3023y39t5qk0simps	23000.00
cmlezxmti024f39t5vwisq800	cmlezxmti024c39t533mgdjnk	23000.00
cmlezxmzt024r39t562rqvjfj	cmlezxmzt024q39t5h9jewql8	19000.00
cmlezxn5d025739t50w0983f3	cmlezxn5d025639t5ofr04k9j	12000.00
cmlezxnau025p39t529ulnwj3	cmlezxnau025o39t5qz0tp2sw	31000.00
cmlezxnxs026039t5she10z4r	cmlezxnxs025v39t550b19wbp	0.00
cmlezxo3v026a39t5ir50dyb4	cmlezxo3v026839t5a3a7o8q0	13000.00
cmlezxoaw027339t5ywbzgrb8	cmlezxoaw027239t5vql34wls	26000.00
cmlezxoh7027d39t5mrt7x1wx	cmlezxoh7027a39t5gig3zag9	20000.00
cmlezxonf027s39t5x4faf8nd	cmlezxonf027n39t5y3opaw1z	12000.00
cmlezxouc028839t5kla0ugt9	cmlezxouc028639t5w9d641lq	34000.00
cmlg3sndw0017erj0nyquowif	cmlg3sndw0016erj03rnvhcwk	57000.00
cmlg3so41001verj0pxs5m9ou	cmlg3so40001uerj0iqmaekge	38000.00
cmlg3solj0027erj0rhi5t6sm	cmlg3solj0026erj0uah91vzy	83000.00
cmlg3sp3d002jerj0au6wvcne	cmlg3sp3c002ierj0tonvjc35	86000.00
cmlg3spdc002rerj0rijn4f50	cmlg3spdb002qerj0877yyq4c	59000.00
cmlg3spl00035erj041k6lcvn	cmlg3spl00033erj0xtci0ues	91000.00
cmlg3spvb003herj0cytmj1jj	cmlg3spvb003ferj0abziqguu	26000.00
cmlg3szcd000dq2fka800dfdw	cmlg3szcd000cq2fkf4da3g3s	47000.00
cmlg3t0j0000mq2fkuk14d1xm	cmlg3t0j0000kq2fk4q1u450h	144000.00
cmlg43ex50091pv85k0idmv6i	cmlg43ex50090pv85dhm1jz9k	65000.00
cmlg43f3z0099pv85noywv2fu	cmlg43f3z0098pv85c6du7ajb	80000.00
cmlg43ff0009tpv85uawisj8c	cmlg43ff0009spv85t0c2g4gx	114000.00
cmlg43fo700a9pv851g8n4py2	cmlg43fo600a6pv856p9kbm0t	55000.00
cmlg43fw200anpv85dihnii4g	cmlg43fw200ampv85c7049vsw	53000.00
cmlg43gdx00bfpv85ozu3jgcz	cmlg43gdx00bcpv857tr487nk	75000.00
cmlg43gnd00bwpv85453dan05	cmlg43gnd00btpv85j9na31qk	87000.00
cmlg43gu200c9pv85lgmlvpav	cmlg43gu200c8pv85x7sclb2h	80000.00
cmlg43h1200crpv854s4cbmpo	cmlg43h1200cqpv85kgwczlt9	115000.00
cmlg43h7x00d9pv857t52s611	cmlg43h7x00d8pv85cktu7cpk	47000.00
cmlg43heo00dmpv85tq8iugeq	cmlg43heo00dkpv85p3n7yg54	47000.00
cmlg43hml00e7pv85skpo1tz3	cmlg43hmk00e6pv85ir000tjy	33000.00
cmlg43i3t00expv85vrnvgvr6	cmlg43i3t00evpv8599tvt4ka	46000.00
cmlg43ifa00ffpv85ikx5r8jo	cmlg43ifa00fepv85v38bf9xk	24000.00
cmlg43irl00fvpv85z2cqs1at	cmlg43irl00fupv8541kyxdly	27000.00
cmlg43iuv00g7pv85a1k9d41c	cmlg43iuv00g6pv8594eo5uet	56000.00
cmlg43j6800g9pv85ei7yh9k0	cmlg43j6800g8pv85klgbxkxn	78000.00
cmlezxbca01gv39t5gtuviqun	cmlezxbca01gu39t5r743by17	78000.00
cmlezxbjd01hd39t53yxfc88g	cmlezxbjd01hc39t58kuj9zcp	119000.00
cmlezxbp801hv39t5r5nbh08s	cmlezxbp801hu39t5sns3rxyk	33000.00
cmlezxc7m01j539t5ob54anm0	cmlezxc7m01j439t5ob54zq8c	89000.00
cmlezxco801jn39t5kq762yea	cmlezxco801jk39t53fw9xbm5	79000.00
cmlezxcvo01ka39t549eqhz5w	cmlezxcvo01k739t5q0vrj1jj	72375.72
cmlezxd1d01kn39t52huvawe8	cmlezxd1d01km39t5b9v6fcx5	77000.00
cmlezxd7a01l539t5llcbyy1r	cmlezxd7901l239t5rsmi84re	23000.00
cmlezxde401lh39t5kodtcjmi	cmlezxde401lg39t5z7iogvu7	17000.00
cmlezxdk301m239t5wbm8dqae	cmlezxdk301ly39t5ajjlz5uh	14000.00
cmlezxdqq01mn39t5s0sxybyx	cmlezxdqq01ml39t54peyfcsi	66000.00
cmlezxe4401no39t5u3da361f	cmlezxe4401nn39t5l5hmwt38	11000.00
cmlezxez101pd39t53rza882v	cmlezxez101pc39t5pdbuk2z4	245000.00
cmlezxf5f01pl39t54kgvlr2r	cmlezxf5f01pk39t59h63cuj6	226000.00
cmlezxfgv01qd39t5layf0bhc	cmlezxfgv01qc39t5vomvmnrj	214000.00
cmlezxfoe01r139t52j56w974	cmlezxfoe01r039t5xlbilvig	259000.00
cmlezxfvw01rn39t56bhnaex0	cmlezxfvw01rm39t5d75du57s	121000.00
cmlezxg2c01s539t51fvg295i	cmlezxg2c01s439t5wfrs5evf	122000.00
cmlezxgev01sv39t5b2blbapr	cmlezxgev01su39t5s8njlyjj	99000.00
cmlezxgky01t539t51dzhsdio	cmlezxgky01t439t5v4do9dfj	217000.00
cmlezxgz001tz39t5h9os81gg	cmlezxgz001ty39t5pru4j99p	243000.00
cmlezxh3y01u939t5gf75zm8h	cmlezxh3y01u839t5qf4gbrgp	53000.00
cmlezxhb001uk39t5xggkip08	cmlezxhb001ui39t55ph09zw2	170000.00
cmlezxhwt01uz39t5xla1pnaq	cmlezxhwt01us39t5v22iipyk	0.00
cmlezxi5o01vh39t5wgg87bvu	cmlezxi5o01vf39t5vqx8d2fv	295000.00
cmlezxidz01vv39t5q0yc1vo0	cmlezxidz01vu39t5q51wx9br	204000.00
cmlezxik101wa39t5l1qrxghs	cmlezxik101w839t538woitz5	0.00
cmlezxiqn01wt39t51rrv377u	cmlezxiqn01wq39t5vrf09mj4	299000.00
cmlezxj2q01xh39t5p93mf5ds	cmlezxj2q01xf39t5fu7dt34d	191000.00
cmlezxj8401xn39t55swgmqi2	cmlezxj8401xm39t58u7p7owt	210000.00
cmlezxjdt01y739t5javf8qyh	cmlezxjds01y539t5czi6098a	48000.00
cmlezxjji01yl39t5nvvh4qqw	cmlezxjji01yk39t5g3phayqq	29000.00
cmlezxjsa01zb39t5xthu2hu5	cmlezxjsa01za39t5963okghp	71000.00
cmlezxkty020j39t5h63u0s6o	cmlezxkty020f39t5j61zvrjb	22000.00
cmlezxld7021139t5u40uqehd	cmlezxld7021039t53zew4sl5	79000.00
cmlezxljf021b39t5be4vsdcg	cmlezxljf021a39t5hpzcdrj9	35000.00
cmlezxlq1021n39t5cg7utgqx	cmlezxlq1021m39t5u7sii34s	47000.00
cmlezxm1q022h39t57u5xrgdo	cmlezxm1q022g39t5vtsugbyh	41000.00
cmlezxm7g022z39t5u1cleiio	cmlezxm7g022y39t5zp6mq8x3	104000.00
cmlezxmdf023b39t5ybsixybs	cmlezxmdf023a39t5uje3rqn7	14000.00
cmlezxmjc023n39t5rvzel55n	cmlezxmjc023m39t52r88j9un	23000.00
cmlezxmol024339t5zoxflipa	cmlezxmok024239t5p5k9zr6j	0.00
cmlezxmv9024h39t5egs6vyzi	cmlezxmv9024g39t5vvge2x3y	23000.00
cmlezxn0o024v39t57ev07voj	cmlezxn0o024u39t5qe2j8voo	24000.00
cmlezxn5d025539t59w2elk13	cmlezxn5d025439t59qmwdqxq	13000.00
cmlezxnxs025y39t5kka7n4zp	cmlezxnxs025t39t55fnslw29	12000.00
cmlezxo6j026n39t5agjxe9oo	cmlezxo6j026m39t5id95wpyi	12000.00
cmlezxom1027j39t5bz0ax2nu	cmlezxom1027i39t52c7iii18	0.00
cmlezxor8028139t5hvifiyqn	cmlezxor8028039t57dnffaqs	10000.00
cmlg3snj1001berj0f3pz0i55	cmlg3snj1001aerj0vddysww2	19000.00
cmlg3snx3001nerj0ly15zbvg	cmlg3snx2001merj0kbgewfh3	85000.00
cmlg3sobv001zerj0qmevmjsr	cmlg3sobv001yerj0xukmlw6u	33000.00
cmlg3sosv002berj0jlyzig5t	cmlg3sosv002aerj0mi84da8o	71000.00
cmlg3sp9l002nerj0di966327	cmlg3sp9l002merj0l05jymwt	71000.00
cmlg3spit002zerj0izvehce8	cmlg3spit002yerj0lfggyo39	53000.00
cmlg3sps8003derj05jwhahan	cmlg3sps8003berj06r89ogor	70000.00
cmlg3sq80003nerj0972rh6jh	cmlg3sq80003merj0brdj9ylg	48000.00
cmlg3sxz20001q2fkdgwvue3b	cmlg3sxz20000q2fkgxitvfwk	54000.00
cmlg3syit0005q2fks1iqz71y	cmlg3syit0004q2fkdk7hv9hc	26000.00
cmlg3sz5w0009q2fkitk0fb39	cmlg3sz5v0008q2fktaa8sz35	11000.00
cmlg3t0c1000hq2fkgfl7i5zs	cmlg3t0c1000gq2fk6jku73kj	50000.00
cmlg43eyk0096pv85qkztu5mm	cmlg43eyk0094pv85xe7nczqv	65000.00
cmlg43f6u009gpv85wuba8pgz	cmlg43f6u009fpv85aiucd9s6	62000.00
cmlg43fgt009xpv8563i0rov4	cmlg43fgt009wpv85uydoyl0h	109000.00
cmlg43fpy00ahpv85nluzjgjg	cmlg43fpy00afpv85aqti528r	65000.00
cmlg43fx700awpv85ajcsrkqj	cmlg43fx700aupv85j91lfrpt	82000.00
cmlg43gdx00b7pv85x9bvwg8k	cmlg43gdx00b3pv852r6z9mnk	88000.00
cmlg43gln00bnpv85ywizbp4i	cmlg43gln00bmpv8532lb48st	57000.00
cmlg43gs000c2pv85k9wyic4l	cmlg43gs000c0pv85lng5b00k	86000.00
cmlg43gxz00clpv858bmcal2b	cmlg43gxz00cipv85x369pyig	48000.00
cmlg43h5v00d7pv85s4e4jg0d	cmlg43h5v00d6pv85qy4vmao9	67000.00
cmlg43hdr00djpv8502af7xn9	cmlg43hdr00dhpv85ep5oyhdt	96000.00
cmlg43hlt00e1pv85c5mhbkmb	cmlg43hlt00dzpv8542qwii5c	44000.00
cmlg43i2e00espv85k288jt4q	cmlg43i2e00eqpv85u3enbb7s	46000.00
cmlg43idz00f9pv85ms6caucb	cmlg43idz00f8pv8515qnab68	39000.00
cmlg43irl00fspv85ywmxfpht	cmlg43irl00fqpv85gevcgika	26000.00
cmlg43isr00fxpv858lmyi9xm	cmlg43isr00fwpv85gycg9v2l	70000.00
cmlg43jam00gipv85gam3xw9k	cmlg43jam00ggpv85a7xzfjyx	84000.00
cmlg43jt500gqpv85r1u30v23	cmlg43jt500gkpv85a85q3tjc	31000.00
cmlg43jt800h1pv85l1txk07j	cmlg43jt800h0pv85lpoa0p9v	52000.00
cmlg43jzu00h9pv85nto5ukvl	cmlg43jzu00h8pv85vlt0kljj	37000.00
cmlg43k8900hopv85qam5dwg8	cmlg43k8900hkpv85c9uy8c1n	108000.00
cmlg43kgc00i1pv85w5xj9ajj	cmlg43kgc00i0pv85w4xf9tz0	123000.00
cmlg43k5800hhpv85xkb35q3l	cmlg43k5800hgpv85hwdfd3l4	66000.00
cmlg43kpm00idpv853ohwg4cn	cmlg43kpl00icpv85gebl0fap	166000.00
cmlezxbcv01h339t5df1bs9a1	cmlezxbcv01h239t5alxe25cq	29000.00
cmlezxbk601hj39t5wii0rhsp	cmlezxbk601hh39t5jzfkopkw	69000.00
cmlezxbq801hz39t5kiy1719j	cmlezxbq801hy39t54bgwr9x8	26000.00
cmlezxbwm01ij39t5je8jcrbo	cmlezxbwm01ii39t520awxzbs	164000.00
cmlezxc4701iz39t5puh31mq1	cmlezxc4701ix39t5pzjp5jtc	50000.00
cmlezxco901jz39t51dairsv8	cmlezxco801ju39t50ejmdmjt	54000.00
cmlezxcx601kh39t5j4ab6a5h	cmlezxcx601kg39t5vo5hy2h9	127000.00
cmlezxd4w01l139t5wj6wnq4g	cmlezxd4w01l039t52mckx9e1	105000.00
cmlezxdao01ld39t5whcm926m	cmlezxdao01lc39t5kktl0x92	19000.00
cmlezxdg601lv39t5u3u7c5my	cmlezxdg601lu39t5seztyznt	92000.00
cmlezxdli01m939t5ppfu33x4	cmlezxdli01m839t59io7iweb	12000.00
cmlezxdql01md39t5axbbdcml	cmlezxdql01mc39t5xzb89132	13000.00
cmlezxe4401np39t55m4k9fko	cmlezxe4401nm39t5oo99744m	243000.00
cmlezxez101pa39t5ua9j8qvk	cmlezxez101p439t5jk794941	137000.00
cmlezxfax01pz39t5oncwgu1s	cmlezxfax01py39t5tghrbswm	211000.00
cmlezxfhz01qi39t5ahzh42ey	cmlezxfhy01qg39t51apcww0f	168000.00
cmlezxfnm01qv39t5lsfsupye	cmlezxfnm01qu39t530ybmskk	143000.00
cmlezxft401rd39t5d8ei4g3s	cmlezxft401rc39t5g1ub6lko	87000.00
cmlezxfzz01rz39t5r8d92936	cmlezxfzz01ry39t5vzphcryr	204000.00
cmlezxg7601sd39t5uxtge0qx	cmlezxg7601sc39t5ppfa4nzv	66000.00
cmlezxgdl01sp39t5lmrq3zk1	cmlezxgdl01so39t5ltg5ufhq	148000.00
cmlezxgnq01tf39t5g79w0449	cmlezxgnq01te39t5ismnjw8t	130000.00
cmlezxgxw01tt39t55n897z7b	cmlezxgxw01ts39t5c2norbig	0.00
cmlezxh3o01u539t5angdahi4	cmlezxh3o01u439t5kf8honx1	116000.00
cmlezxha101uh39t5y0mcb3b9	cmlezxha101ug39t5luafvo0t	46000.00
cmlezxhwt01uu39t5vc6k68q6	cmlezxhwt01uo39t5s9t0ki0y	91000.00
cmlezxi4z01v739t5f1dt90pm	cmlezxi4z01v639t5h16vp02g	40000.00
cmlezxiey01vz39t5qwibo75k	cmlezxiey01vx39t58afhfapl	169000.00
cmlezxiko01wf39t5yu7fi4qr	cmlezxiko01we39t5k11sllxs	208000.00
cmlezxirb01wv39t5f3i9rl1k	cmlezxirb01wu39t5kophv5p0	279000.00
cmlezxj3k01xj39t5sixwnga1	cmlezxj3k01xi39t59ayqh231	47000.00
cmlezxjb101xz39t5kz7xgvo6	cmlezxjb101xy39t5qalt0as9	30000.00
cmlezxjgr01yf39t5xszzir6w	cmlezxjgr01ye39t5y9mufpnm	235000.00
cmlezxjmn01yv39t5zmw2zr5c	cmlezxjmn01yu39t5pznmaln6	129000.00
cmlezxjtg01zf39t5h6vqweib	cmlezxjtg01ze39t5s6cgfq9t	67000.00
cmlezxjyx01zt39t5xpsfz6zx	cmlezxjyx01zs39t5ok76pdcn	40000.00
cmlezxkty020b39t53n93i4ad	cmlezxkty020739t5kgmg4117	22000.00
cmlezxl8f020v39t5hrs1u234	cmlezxl8f020u39t5ybqx857b	53000.00
cmlezxlhf021939t5k70c3uvz	cmlezxlhf021839t55otvir5t	40000.00
cmlezxlok021l39t5ic6a39wt	cmlezxlok021k39t50qabt9my	44000.00
cmlezxluc022139t5t90kctza	cmlezxluc022039t5yh16lx9j	28000.00
cmlezxm0r022f39t51g6eydpx	cmlezxm0r022e39t5eez7qmgb	0.00
cmlezxm5p022v39t56o5dif7a	cmlezxm5p022u39t5ccpvrwzs	65000.00
cmlezxmas023739t5b51wl18y	cmlezxmas023639t5s5m6wwu0	0.00
cmlezxmgi023f39t5pjfbk3dn	cmlezxmgi023e39t5vzsacmbq	56000.00
cmlezxmlu023v39t5birdqxj1	cmlezxmlu023q39t57l6il7wu	23000.00
cmlezxms8024b39t5szvjgr05	cmlezxms8024a39t5hzodmirb	23000.00
cmlezxmyi024p39t5tb5aexet	cmlezxmyi024o39t51awddbuv	24000.00
cmlezxn3x025339t5izkxsk4u	cmlezxn3x025239t52ik1vzc4	12000.00
cmlezxn9l025l39t5hy0124l4	cmlezxn9l025k39t5a94hqx4y	20000.00
cmlezxo6j026p39t51muxfehw	cmlezxo6j026o39t5ju4cg7tg	25000.00
cmlezxom6027l39t5z1z2xuwh	cmlezxom6027k39t5cpe27ozk	0.00
cmlezxosm028339t5ou93h8qu	cmlezxosm028239t5ry7j0btw	11000.00
cmlezxoz7028l39t5z9chuxdp	cmlezxoz6028k39t5nwgf2oxa	14000.00
cmlezxp5g028x39t520vw90l5	cmlezxp5g028w39t5e3yrpqcu	13000.00
cmlg43gnd00bxpv8532t3izk2	cmlg43gnd00bupv85aymnyfxi	47000.00
cmlg43gv200cbpv85aeq7zjry	cmlg43gv200capv85ns7eat69	70000.00
cmlg43h4t00czpv85dmwt7iqc	cmlg43h4t00cxpv85jg5brpgi	36000.00
cmlg43hi800dvpv85eru0eola	cmlg43hi800dtpv85m9va3249	76000.00
cmlg43hpx00edpv85gna5il2r	cmlg43hpw00ebpv858xizc7qp	52000.00
cmlg43i0f00empv85ks7k5jo0	cmlg43i0f00ejpv858nm97yh9	20000.00
cmlg43ib100f5pv85b87qjjta	cmlg43ib000f4pv85xy43p9u0	17000.00
cmlg43im900fmpv85rz5khbn2	cmlg43im900fjpv852w8pi70o	30000.00
cmlg43iu700g5pv851iw4fj1t	cmlg43iu600g3pv853klg6hdl	87000.00
cmlg43j9k00gfpv85x0fwbann	cmlg43j9k00gepv85pkkm5pha	29000.00
cmlg43jt500gppv851uqvy7sj	cmlg43jt500gmpv85fbeykimo	25000.00
cmlg43jt500gxpv85czyfw58i	cmlg43jt500gvpv85gvzy4z1q	39000.00
cmlg43jzu00h5pv8558eqi836	cmlg43jzu00h3pv85fgzqudt8	70000.00
cmlg43k8a00hrpv85gknof49i	cmlg43k8900hmpv85gj4rmy8m	89000.00
cmlg43kg000hxpv85c251l2pj	cmlg43kg000hupv85cpgionjf	36000.00
cmlg43k6f00hjpv85wrjb1pz3	cmlg43k6f00hipv85g8eiqy07	110000.00
cmlg43kmg00i8pv85txopfspu	cmlg43kmg00i4pv85qwh9s7zt	0.00
cmlg43kr600ifpv85svkwdnve	cmlg43kr600iepv858r9j4007	135000.00
cmlg43ksb00ihpv85vc38grbu	cmlg43ksb00igpv85ww9t1h31	158000.00
cmlg43kuh00iqpv85564r95kj	cmlg43kuh00iopv853s9wu4dt	53000.00
cmlg43kuh00irpv85c3yu0041	cmlg43kuh00ippv85q9ojbys6	33000.00
cmlg43l3w00j9pv85ozthht43	cmlg43l3w00j7pv85ot20zux9	112000.00
cmlg43l3w00j8pv85mdlg2vm3	cmlg43l3w00j6pv85hot4bble	180000.00
cmlg43l1z00ixpv852i6jw8nu	cmlg43l1z00iwpv85skaykjar	56000.00
cmlg43l1z00j3pv857spinw8s	cmlg43l1z00j0pv854ekq8l1y	70000.00
cmlg43la400jipv853gwfsgp9	cmlg43la400jgpv85utrqe5qi	86000.00
cmlg43la400jjpv85124p9znj	cmlg43la400jhpv852j4rgved	0.00
cmlg43lcs00jlpv85euirrh8d	cmlg43lcs00jkpv85tt6yvgjb	70000.00
cmlg43lhz00jxpv85y1s9qjdd	cmlg43lhz00jwpv858e06lg9t	105000.00
cmlg43lil00jzpv85ibsaw746	cmlg43lil00jypv855kh8l2ir	76000.00
cmlg43lkd00k3pv858jxv2idl	cmlg43lkd00k1pv85q1g915zu	22000.00
cmlezxbcm01h139t5alhp1huq	cmlezxbcm01gy39t5wj1kqinb	89000.00
cmlezxbjx01hf39t52gzk9c2u	cmlezxbjx01he39t56cuydi4l	77000.00
cmlezxbom01ht39t5ux8hm85d	cmlezxbom01hs39t59hk31vvd	126000.00
cmlezxbun01ib39t5czq2voul	cmlezxbum01ia39t5w71l8df4	141000.00
cmlezxc1q01it39t5gyjzxn96	cmlezxc1q01is39t5kwjymgu8	69000.00
cmlezxc8z01jb39t51ms66nhn	cmlezxc8y01ja39t5fseuj4lv	107000.00
cmlezxco801jt39t5ckoimxcn	cmlezxco801jq39t5ed46r6h0	143000.00
cmlezxcub01k339t5hirq9odw	cmlezxcub01k239t52xkhxw4u	124000.00
cmlezxczm01kk39t5amhubi61	cmlezxczm01kj39t5voy9v2rv	74000.00
cmlezxd4a01kx39t5bf1njsr2	cmlezxd4a01ku39t5l7q42uea	87000.00
cmlezxder01lt39t5xcf0hfql	cmlezxder01ls39t54fz5fco1	11000.00
cmlezxdqx01mr39t5b9e9ny9k	cmlezxdqx01mq39t5o9u2ikya	243000.00
cmlezxdwg01n539t5j1f47ihu	cmlezxdwg01n439t5ihaxtey8	231000.00
cmlezxe1q01nb39t5yirlh4sz	cmlezxe1q01na39t5fbhirxvg	16000.00
cmlezxe7e01nv39t5sllfbylb	cmlezxe7d01ns39t5ub2hnfs0	22000.00
cmlezxed101o539t54yzd32fc	cmlezxed101o439t5q5anfzbz	165000.00
cmlezxeis01oj39t5a7d4j99l	cmlezxeis01oi39t5elo1yuba	136000.00
cmlezxeod01ox39t55n33f5af	cmlezxeod01ow39t5s6ey2k3w	32000.00
cmlezxez201ph39t5izrylm17	cmlezxez201pg39t5x7euqc28	217000.00
cmlezxf6601pv39t5lo1hyenj	cmlezxf6601pu39t5liy27xlr	77000.00
cmlezxfco01q539t5yb97448w	cmlezxfco01q439t5vm4gactp	150000.00
cmlezxfjw01qt39t5acm6nzzz	cmlezxfjw01qs39t5zlqvlf5c	173000.00
cmlezxfpp01r739t5mi3f2ban	cmlezxfpp01r639t5birefb0i	77000.00
cmlezxfws01rp39t5n43ub4zv	cmlezxfws01ro39t5u82rzdok	236000.00
cmlezxg2z01s739t58ew4wymu	cmlezxg2z01s639t5uzvw9wi2	124000.00
cmlezxgg801sz39t5wmq6g9dc	cmlezxgg801sy39t5pv0xfwhq	130000.00
cmlezxgmg01tb39t5k0si2apc	cmlezxgmg01ta39t5746ikdb0	116000.00
cmlezxgxq01tr39t5ksn52zt4	cmlezxgxq01tq39t5qkf7946g	130000.00
cmlezxh3q01u739t5ixyc6p0r	cmlezxh3q01u639t5ky7omwgs	214000.00
cmlezxhwt01ux39t52xnfe0pr	cmlezxhwt01up39t596ht7ou4	68000.00
cmlezxi5o01vj39t57b3agwe6	cmlezxi5o01vg39t5pkc9s5sv	59000.00
cmlezxidz01vr39t5mvnxvi9h	cmlezxidz01vq39t5h6sxd3d5	295000.00
cmlezxik101wb39t5rxs8tx0u	cmlezxik101w739t53z73qags	204000.00
cmlezxiqn01ws39t5ekjy3v7g	cmlezxiqn01wp39t5dambd88o	235000.00
cmlezxj2q01xg39t5533echef	cmlezxj2q01xe39t5tp7ky379	72000.00
cmlezxj8501xp39t5o7w0f0v7	cmlezxj8401xo39t5zb0mz2yb	187000.00
cmlezxjds01y639t534hn7x36	cmlezxjds01y439t5rueaqw48	151000.00
cmlezxjjy01yn39t59wm0bkfy	cmlezxjjy01ym39t54aoclyc7	76000.00
cmlezxjpx01yz39t5qq0lttvu	cmlezxjpx01yy39t5v2addjoj	53000.00
cmlezxjwv01zi39t5jzpjo4do	cmlezxjwv01zg39t5dyste3vt	218000.00
cmlezxk3t01zx39t56u4yb1fb	cmlezxk3t01zw39t59wuwbag6	97000.00
cmlezxkty020h39t562acge2g	cmlezxkty020a39t5hdtx0wad	0.00
cmlezxla9020x39t5wkoajnk7	cmlezxla9020w39t59v0c2siz	43000.00
cmlezxltd021z39t5h20kjjk9	cmlezxltd021x39t54isliw3y	39000.00
cmlezxm4e022p39t5um79319u	cmlezxm4e022o39t5tblstsez	231000.00
cmlezxm9q023139t5pvkzwfoa	cmlezxm9q023039t5hv396xp8	137000.00
cmlezxmfy023d39t5o0vn0uav	cmlezxmfy023c39t5dx71vlwk	20000.00
cmlezxmlu023t39t5qez07jai	cmlezxmlu023s39t56ce9cp30	23000.00
cmlezxmrg024939t5nsjkxudt	cmlezxmrf024839t5e9gn3f5o	24000.00
cmlezxmxx024n39t5kg37cl86	cmlezxmxx024m39t5ekniz9ip	19000.00
cmlezxn2w025139t5wrv6m0r1	cmlezxn2w025039t5z1r300ty	22000.00
cmlezxn7t025j39t5z2rmyhet	cmlezxn7t025i39t5actk4csl	23000.00
cmlezxnxs026239t5cdm9fwtr	cmlezxnxs025w39t55v2zkgpi	12000.00
cmlezxoaq026x39t52f3tn5go	cmlezxoaq026w39t56g9phjzj	12000.00
cmlezxoh7027f39t51df7eq64	cmlezxoh7027e39t5afrhs220	13000.00
cmlezxonf027q39t5t40xtklq	cmlezxonf027p39t5y77ydx52	0.00
cmlezxouc028539t52yfscbfw	cmlezxouc028439t56jfob2tj	19000.00
cmlezxp0j028t39t58oprhzrw	cmlezxp0j028s39t5nh72lza9	12000.00
cmlezxp6l029139t56zl5whvt	cmlezxp6l029039t5iuql3tdw	43000.00
cmlg435q40001pv85b6401gvb	cmlg435q30000pv85rmm3toj9	73000.00
cmlg4369l000bpv85urjuhy7c	cmlg4369l000apv85rxxg0ed3	143000.00
cmlg436l3000hpv85h1xzdjtt	cmlg436l3000gpv85fk1lvcvq	143000.00
cmlg4373h000rpv85vs1441rb	cmlg4373h000qpv859hy0eixu	82000.00
cmlg437ej000xpv8596nb0m00	cmlg437ej000wpv85lbm4omno	82000.00
cmlg437ov0017pv853bsinjny	cmlg437ov0014pv85bfl1rrif	81000.00
cmlg437wc001bpv85u0wve8oc	cmlg437wc0019pv85548dlbzu	85000.00
cmlg4385r001hpv854ru6dbgk	cmlg4385r001fpv85j121m0k5	76000.00
cmlg438eg001lpv85f4y4fygl	cmlg438eg001kpv85f38kzvaf	78000.00
cmlg438ke001ppv85umv8wq90	cmlg438ke001opv85zsc09yao	86000.00
cmlg438s9001vpv85z48cu1ut	cmlg438s9001upv85qfxt2y52	81000.00
cmlg438yc001zpv853ajkfz0k	cmlg438yc001ypv85ch6qxt2f	86000.00
cmlg4395o0029pv85qio529s4	cmlg4395o0027pv85fz82y1zu	103000.00
cmlg439ql002xpv85115n1420	cmlg439ql002wpv852o5pga36	70000.00
cmlg43a2j003dpv8578xr19oi	cmlg43a2j003cpv85nh689gt1	152000.00
cmlg43a9a003ppv853ud80t14	cmlg43a9a003opv85bm3fayk6	56000.00
cmlg43agz003xpv85f8puxvjo	cmlg43agz003wpv853k40hh70	58000.00
cmlg43ay4004bpv85okjo6s69	cmlg43ay4004apv85ykyt3rg5	56000.00
cmlg43d82005mpv85imcah8ke	cmlg43d81005gpv85424jo2co	129000.00
cmlg43dp7006cpv857ueaedvy	cmlg43dp7006apv85p4arufwq	96000.00
cmlg43e110077pv85cpji4lib	cmlg43e110076pv85wj8qqc2r	114000.00
cmlg43edf007ppv8559y1t1fe	cmlg43ede007opv85zk3o1nc8	51000.00
cmlg43em6008dpv851u3ty362	cmlg43em6008cpv85ztnp9x80	78000.00
cmlg43etf008tpv85kdc10ctc	cmlg43etf008spv859si7jjwl	109000.00
cmlg43fa3009ppv85w4yt7xhn	cmlg43fa3009npv85a9qz52rb	80000.00
cmlg43fo700a8pv85resre0ei	cmlg43fo600a5pv85okqbkt9f	55000.00
cmlg43fwl00aspv85q83wmtbo	cmlg43fwl00appv857irhjs2h	86000.00
cmlg43gdx00b8pv85v3tf690t	cmlg43gdx00b0pv85wbwhu0ph	68000.00
cmlezxbcm01gz39t55zufhbol	cmlezxbcm01gw39t5h7xrnqvl	35000.00
cmlezxbk601hi39t524e5actw	cmlezxbk601hg39t5zyqqwe2l	137000.00
cmlezxbqg01i339t5ltg5istr	cmlezxbqg01i239t537q8he0a	50000.00
cmlezxbwj01if39t57laixp76	cmlezxbwj01ie39t5vnztirnb	127000.00
cmlezxc4701j139t5paonxgx2	cmlezxc4701iy39t52grsxp4o	45000.00
cmlezxcc301jh39t5nnv5qzk8	cmlezxcc301jg39t5up3r3vic	51000.00
cmlezxco801jm39t5ym4gx1t2	cmlezxco801jj39t5dz83xl71	61000.00
cmlezxcu801k139t5r1vyppr7	cmlezxcu801k039t5qwt5c38j	107000.00
cmlezxczm01kl39t5wekanxe4	cmlezxczm01ki39t501k71qow	136000.00
cmlezxd4a01kw39t57sku0zo8	cmlezxd4a01kv39t5t3jxnsxc	117000.00
cmlezxdem01lr39t5i8me7pn0	cmlezxdem01lq39t5n58k5yp2	76061.18
cmlezxdqq01mh39t51wp4hcr6	cmlezxdqq01mg39t59u5k2mhp	13000.00
cmlezxdwc01mz39t5bc1nttfn	cmlezxdwc01mw39t53oes732q	230000.00
cmlezxe2h01ni39t5yrqukqhv	cmlezxe2h01ng39t55um7u7qc	73297.08
cmlezxe8x01nz39t5ukczndeq	cmlezxe8x01ny39t5ve42nx0l	133000.00
cmlezxeeg01ob39t5c4otftp2	cmlezxeeg01oa39t5c3y479xx	116000.00
cmlezxejj01om39t5v3nd9zgf	cmlezxejj01ok39t5i4g4t08h	230000.00
cmlezxepa01p139t5y3ubg9nd	cmlezxepa01p039t5u7nlcpdi	84000.00
cmlezxez101p739t5zu0h0ono	cmlezxez101p239t56ov1yd43	136000.00
cmlezxf6601px39t5cxqi6w7l	cmlezxf6601pw39t5eoljy8qz	252000.00
cmlezxfc701q339t5rxeutb31	cmlezxfc601q239t5l5p7a47w	467000.00
cmlezxfhz01qj39t5amvjr8mi	cmlezxfhz01qh39t5qdsyknv9	65000.00
cmlezxfp101r439t5ht4uqbkq	cmlezxfp101r339t5rda1r8w9	69000.00
cmlezxfv301rl39t53pwavvrx	cmlezxfv301rk39t57gzr6vv3	130000.00
cmlezxg1o01s239t5p27j1k8j	cmlezxg1o01s039t5r0ofy5nz	60000.00
cmlezxg8f01si39t52l9dwfnv	cmlezxg8f01sg39t5gb9gqddh	64000.00
cmlezxge901ss39t56jlj9lac	cmlezxge901sq39t5h4zrknu7	73000.00
cmlezxgle01t939t56kv7szvw	cmlezxgld01t739t5aw4ytplg	181000.00
cmlezxgy501tv39t5xzj6xwl8	cmlezxgy501tu39t5e92y4qsi	205000.00
cmlezxhwv01v339t5hyxusr7d	cmlezxhwu01v039t5s3u7lfc6	104000.00
cmlezxias01vl39t50spqnhjc	cmlezxias01vk39t5nxiuriiv	71000.00
cmlezxihn01w339t5ks63gypk	cmlezxihn01w239t5rgzqz3vs	79000.00
cmlezxiqn01wr39t5l3im4t7s	cmlezxiqn01wo39t5816ldbxs	81000.00
cmlezxixq01x539t50bdvo74t	cmlezxixq01x439t5x8kcwpgb	0.00
cmlezxj8p01xr39t5z0uhfy08	cmlezxj8p01xq39t59qs7b0ne	53000.00
cmlezxjfc01yb39t5xb8umjk4	cmlezxjfc01y939t5yquqo2u4	32000.00
cmlezxjll01yt39t5ayr7v00f	cmlezxjll01ys39t5ng0rcoum	164000.00
cmlezxjrs01z539t5bchslmzl	cmlezxjrs01z439t5eqzs0aj9	43000.00
cmlezxjyh01zr39t5vzjcf3hn	cmlezxjyh01zq39t5rg1lm2k7	85000.00
cmlezxk5j020339t5s2g77iyl	cmlezxk5j020239t52b9lroz7	191000.00
cmlezxkty020d39t5nib2zg9v	cmlezxkty020839t59vd7k9kl	3000.00
cmlezxlz1022939t5lwfbgglt	cmlezxlz1022839t5zmofapyu	32000.00
cmlezxm50022r39t5qv697xpw	cmlezxm50022q39t5vmcfovj1	0.00
cmlezxmap023539t5amonlde7	cmlezxmap023339t5bk1rca4l	0.00
cmlezxmgs023h39t58cw9q3p7	cmlezxmgs023g39t58wim8z51	23000.00
cmlezxmn3024139t5ahatcc01	cmlezxmn3023z39t5fpdktmnv	23000.00
cmlezxmti024e39t5cp11ubai	cmlezxmti024d39t5l63b8nor	21000.00
cmlezxmzt024t39t5822v6wqi	cmlezxmzt024s39t5y441qbu9	21000.00
cmlezxn5i025939t5g94aa3cj	cmlezxn5i025839t5zxmb1mun	12000.00
cmlezxnxs026739t5hk2eozu1	cmlezxnxs026539t55yhlx35l	24000.00
cmlezxo4j026k39t5shh4v49a	cmlezxo4j026i39t5iz5o0645	26000.00
cmlezxoau027139t55h2as73y	cmlezxoau027039t5t91d0npj	28000.00
cmlezxoh7027c39t5h2k12m9u	cmlezxoh7027b39t50xjcbw07	16000.00
cmlezxonf027t39t5knfsm65e	cmlezxonf027o39t5u3dzfhgk	14000.00
cmlezxouc028b39t5b8x7s3mp	cmlezxouc028939t5fco4b6s6	150000.00
cmlezxp0j028r39t5u4io1j1d	cmlezxp0j028o39t5lw3ge0ec	113000.00
cmlg435wn0003pv85fc0c9l2h	cmlg435wn0002pv85emm3kw34	70000.00
cmlg436490009pv85olyl7qcf	cmlg436480007pv85wyslf9rq	81000.00
cmlg436cm000fpv858ct6qhbb	cmlg436cm000dpv85u3gn59fp	94000.00
cmlg436ob000lpv85tm938fbx	cmlg436oa000jpv8523dsly9t	87000.00
cmlg436z3000ppv85gych3c3w	cmlg436z3000npv85vgradjtn	87000.00
cmlg43788000upv85qq9wfbq2	cmlg43788000spv85u8jb6u73	85000.00
cmlg437ge0010pv8576toljdu	cmlg437ge000ypv85xlq2ybix	96000.00
cmlg437ne0013pv85ldpg3zzj	cmlg437ne0012pv856h7xjez4	85000.00
cmlg437z6001dpv85e8x8c98d	cmlg437z6001cpv85b3gokxxg	87000.00
cmlg438jl001npv85a622fiy9	cmlg438jl001mpv859idunqo8	71000.00
cmlg438rg001tpv851chw9lok	cmlg438rg001spv85xb22p16n	71000.00
cmlg438xr001xpv85w9hn53uz	cmlg438xr001wpv85t2uzq0np	104000.00
cmlg4395o0028pv85iham3fz3	cmlg4395o0026pv85ii5vrd7o	38000.00
cmlg439cx002fpv85alsgs7xr	cmlg439cw002epv85u5wwuumr	74000.00
cmlg439jm002rpv85m5us0loh	cmlg439jm002qpv85a5qcwsro	85000.00
cmlg439r8002zpv85tp12nvdy	cmlg439r8002ypv854um7ti35	91000.00
cmlg439ye0039pv85bchq38b6	cmlg439ye0038pv857iue00ay	78000.00
cmlg43a5e003jpv851744d9zg	cmlg43a5e003ipv85kkxaqedr	98000.00
cmlg43adi003tpv85geje890o	cmlg43adi003spv85dmw4s5e8	92000.00
cmlg43aoa0043pv85wwxvdj28	cmlg43aoa0042pv851fvrbukd	65000.00
cmlg43b0j004hpv85buzz3omd	cmlg43b0j004gpv85ch4traxu	97000.00
cmlg43b7h004qpv85tuk26n4v	cmlg43b7h004opv85zo8d99ib	60000.00
cmlg43bf8004zpv85pfqwot6i	cmlg43bf8004ypv85oh8rtv3k	91000.00
cmlg43blw005cpv852f57uhid	cmlg43blw005apv85utf63f81	61000.00
cmlg43d82005vpv85jrsthp6m	cmlg43d82005spv8544iulqgn	143000.00
cmlg43dia005zpv85jjhjaxk8	cmlg43dia005ypv85z26pk9ou	159000.00
cmlg43dse006lpv85kgnh1bvg	cmlg43dse006gpv859yfey4dn	102000.00
cmlg43dzh006upv85lz7td1dq	cmlg43dzh006rpv856furofvl	59000.00
cmlg43e68007bpv85zc77fal2	cmlg43e68007apv853v02fv0t	80000.00
cmlg43el90087pv85jdz4upvk	cmlg43el80085pv85k6usbgck	73000.00
cmlg43eru008ppv854jn5itv1	cmlg43eru008mpv85uchua8m6	109000.00
cmlezxbcm01h039t5jgns21vy	cmlezxbcm01gx39t568qd5lq3	24000.00
cmlezxbk601hl39t5vo6a88te	cmlezxbk601hk39t5o5smgsgo	58000.00
cmlezxbqa01i139t5vz59545l	cmlezxbqa01i039t52ma8vlga	41000.00
cmlezxbwm01ih39t50tg1mgiq	cmlezxbwm01ig39t5ie93a2l5	64000.00
cmlezxc4701j039t5lzap3a8w	cmlezxc4701iw39t565zg8dae	103000.00
cmlezxcbb01jf39t5rlu620ag	cmlezxcbb01je39t51s01xn4u	76000.00
cmlezxco801jy39t5ern8l19u	cmlezxco801jv39t544mx1p8n	193000.00
cmlezxcur01k539t5fzf0i0va	cmlezxcur01k439t51hz1syp9	77000.00
cmlezxd7a01lb39t5a9jatzsl	cmlezxd7a01la39t5261rt7fg	87000.00
cmlezxdec01ll39t5cyt7dk92	cmlezxdec01lk39t5s3bsx5vs	19000.00
cmlezxdk301m539t5q8ynr3ff	cmlezxdk301m039t5h2lue6xu	18000.00
cmlezxdqq01mp39t5usklpics	cmlezxdqq01mj39t58y99vsjj	78000.00
cmlezxdwc01n039t5ed6174f6	cmlezxdwc01my39t5xlenkwmf	57000.00
cmlezxe1u01ne39t5u1hd9t8q	cmlezxe1u01nc39t5bxwotath	19000.00
cmlezxe7e01nu39t5o94jpiik	cmlezxe7d01nt39t5vsc0k4j1	228000.00
cmlezxedk01o739t5duhuuzu7	cmlezxedk01o639t5f8nfw07m	14000.00
cmlezxek301op39t54ykhcosz	cmlezxek301oo39t5xcxail1g	66000.00
cmlezxezn01pj39t5t6rld2gk	cmlezxezn01pi39t5yswgncym	249000.00
cmlezxf6401pp39t5picgtiat	cmlezxf6401po39t5szfgk3rk	151000.00
cmlezxfc301q139t57u8rqclz	cmlezxfc301q039t51fe2zbsd	261000.00
cmlezxfj901qp39t5f9d4j9ya	cmlezxfj901qo39t50ykib2f1	261000.00
cmlezxfq501r939t5vcuoz51f	cmlezxfq501r839t55vii5do1	80000.00
cmlezxfy001rr39t5aneit53s	cmlezxfy001rq39t50biyezyd	99000.00
cmlezxg4z01s939t535xv58co	cmlezxg4z01s839t5pzy2d3am	71000.00
cmlezxgfn01sx39t5scfe1ktx	cmlezxgfn01sw39t58wm731xf	228000.00
cmlezxgle01t839t54mu37opt	cmlezxgld01t639t5toi6uxhe	150000.00
cmlezxgx401tp39t57qx2amgu	cmlezxgx401to39t5igzh3v6a	176000.00
cmlezxh4q01ub39t5ou8eq21q	cmlezxh4q01ua39t51ypftq0z	31000.00
cmlezxhwt01uv39t50hmmw9i2	cmlezxhwt01un39t5awo63f99	89000.00
cmlezxi5o01vi39t5huqleuff	cmlezxi5o01ve39t5w278f94m	50000.00
cmlezxiey01w039t53wnovya5	cmlezxiey01vw39t5pcv89jzs	98000.00
cmlezxiko01wh39t5g8z6j3kh	cmlezxiko01wg39t5q6uw4fne	73000.00
cmlezxirb01wx39t5sk328su6	cmlezxirb01ww39t58moqib1e	235000.00
cmlezxj3k01xl39t5bgiri58e	cmlezxj3k01xk39t584pwwuka	295000.00
cmlezxj9d01xv39t50rtksj0j	cmlezxj9d01xu39t5430rgm7t	63000.00
cmlezxjfc01ya39t5rkum098p	cmlezxjfc01y839t5vcsohujw	71000.00
cmlezxjlk01yr39t51d6gjb3b	cmlezxjlk01yq39t50ew4crp7	116000.00
cmlezxjs301z739t5zwa2qjnr	cmlezxjs301z639t5grwu4my4	0.00
cmlezxjwv01zl39t5llyeyops	cmlezxjwv01zk39t5vajqbim3	218000.00
cmlezxkty020e39t52rt4lou7	cmlezxkty020939t56w72t2lf	20000.00
cmlezxl68020t39t5eizxug7k	cmlezxl68020s39t5bcn5txif	22000.00
cmlezxlg1021739t5gffu3t36	cmlezxlg1021539t54s1r4dpj	32000.00
cmlezxln8021j39t5fjv5flpn	cmlezxln8021f39t5tk4io9z7	45000.00
cmlezxlt5021t39t5fbnr0zof	cmlezxlt5021s39t5i4zgtkew	25000.00
cmlezxlyf022539t5bweeumm3	cmlezxlyf022439t5q6n4710t	26000.00
cmlezxmlv023x39t5o2t6tmqz	cmlezxmlv023w39t5c99dyruv	23000.00
cmlezxn5q025b39t5bmhzx6vq	cmlezxn5q025a39t5mj96jw2x	10000.00
cmlezxnxs026139t5mcoutv51	cmlezxnxs025x39t5qb19ssp7	12000.00
cmlezxo3v026b39t5lj0g9983	cmlezxo3v026939t5g2r4qfz5	15000.00
cmlezxo9h026r39t5zk2egg9p	cmlezxo9h026q39t57w0wm6cv	13000.00
cmlezxoeb027539t5biq9uwq9	cmlezxoeb027439t56p65hsuw	0.00
cmlezxojo027h39t56hw5nsnr	cmlezxojo027g39t510llbqij	29000.00
cmlezxoot027z39t58zqqrqy5	cmlezxoot027y39t51wx4xzqp	15000.00
cmlezxovv028g39t5yiiakuhs	cmlezxovv028e39t5pe2vbao4	150000.00
cmlg435x10005pv85k96fsxbw	cmlg435x10004pv85kvrkx8k0	96000.00
cmlg436490008pv85o0t7ajy0	cmlg436480006pv85kdczl8c2	84000.00
cmlg436cm000epv85kde72wmw	cmlg436cm000cpv85xlwj7vue	80000.00
cmlg436ob000kpv85pfxq52md	cmlg436oa000ipv853xw8smh3	70000.00
cmlg436z3000opv85p3rm9xoq	cmlg436z3000mpv85f75nocr7	82000.00
cmlg43788000vpv85zk7osaw0	cmlg43788000tpv85b9nwk1nw	82000.00
cmlg437ge0011pv854s1b2dku	cmlg437ge000zpv85c53ulf8j	96000.00
cmlg437ov0016pv850j4abvmx	cmlg437ov0015pv85w62hacvl	96000.00
cmlg437wc001apv85epo91ggl	cmlg437wc0018pv850maqcmz0	79000.00
cmlg4385r001gpv85nhq6x9pw	cmlg4385r001epv85xzw9jdkq	78000.00
cmlg438di001jpv85diz1y65u	cmlg438di001ipv85l3kzmi0p	47000.00
cmlg438l7001rpv8563h9u2rr	cmlg438l6001qpv85jbpo1obk	102000.00
cmlg4394g0025pv85pv9uyt1u	cmlg4394g0024pv85s94h9cf3	85000.00
cmlg439e1002hpv85gm4wpdb9	cmlg439e1002gpv85q7k3jba0	92000.00
cmlg439j0002ppv85fi55sdzq	cmlg439j0002opv8592je8rug	122000.00
cmlg439ti0033pv85umkpzvf5	cmlg439ti0032pv85tbpwx64f	88000.00
cmlg43am70041pv859vnyunbx	cmlg43am60040pv85v3tsk047	89000.00
cmlg43bfs0053pv85m5wvizuc	cmlg43bfs0051pv853e7e7p9n	74000.00
cmlg43bmh005fpv85lwljhxpx	cmlg43bmh005epv85omff72ei	66000.00
cmlg43d82005ppv855zypwgyw	cmlg43d82005jpv85ibpeyg52	83000.00
cmlg43dp70069pv855xh3t9av	cmlg43dp70068pv85uu32li6t	262000.00
cmlg43e110075pv852ea53lk5	cmlg43e110074pv85m0imsaz6	110000.00
cmlg43ede007npv85krmkmrcs	cmlg43ede007mpv85xdhdamqx	57000.00
cmlg43emz008fpv85es6d5bj3	cmlg43emz008epv85h4v1oydk	93000.00
cmlg43etg008vpv8560nmz3tg	cmlg43etg008upv85bckix5y8	132000.00
cmlg43f6u009hpv85qywa2g11	cmlg43f6u009epv85gsjs6myd	109000.00
cmlg43fgt009zpv85fjeb9yv2	cmlg43fgt009ypv85ai178a6u	60000.00
cmlg43fpy00agpv85sykqt7xs	cmlg43fpy00aepv85kzxqhcyo	93000.00
cmlg43fx700aypv85umtgu8cb	cmlg43fx700avpv85bqgddcvd	86000.00
cmlg43gdx00b5pv8572ha0iqo	cmlg43gdx00b2pv85w2mb2zo7	84000.00
cmlg43gnd00brpv85z3q7z6wz	cmlg43gnd00bqpv853jpqfek8	74000.00
cmlg43gv300cfpv850yyc28xm	cmlg43gv300cepv851fcg9936	53000.00
cmlg43h5100d1pv85cnelvb6q	cmlg43h5100d0pv85o6k2tf2e	67000.00
cmlezxbet01h639t5o6fvnh8w	cmlezxbet01h539t5btewxl2y	77000.00
cmlezxblm01ho39t5luxzcwoe	cmlezxbll01hm39t5lj0ov4wx	56000.00
cmlezxbsl01i939t53iwoenp1	cmlezxbsl01i739t5erdm5i1d	91000.00
cmlezxbze01io39t51mo8rs1s	cmlezxbze01im39t52jk5o3a5	57000.00
cmlezxc7z01j939t576ktimf8	cmlezxc7z01j839t5y2ypmzwu	92000.00
cmlezxco801js39t5dreo9svg	cmlezxco801jr39t5cuabbx0c	135000.00
cmlezxcx401kf39t5bdn0u55v	cmlezxcx401ke39t5dddsbaw4	98000.00
cmlezxd4u01kz39t57lbkb8g8	cmlezxd4u01ky39t5lb1v95o4	124000.00
cmlezxdbi01lf39t57s9bxnzb	cmlezxdbi01le39t5tymznz39	17000.00
cmlezxdgo01lx39t5l22k000s	cmlezxdgo01lw39t58xppa966	14000.00
cmlezxdm601mb39t54mnlys1u	cmlezxdm601ma39t5jz6k5rzk	74000.00
cmlezxdrf01mt39t52fk254n9	cmlezxdrf01ms39t54eb25g42	12000.00
cmlezxdwc01n139t58oqyuwd6	cmlezxdwc01mx39t55k0c1z6t	14000.00
cmlezxe2h01nl39t5jlgujcew	cmlezxe2h01nh39t59i3rmvh8	227000.00
cmlezxe7d01nr39t5p7h0ixi1	cmlezxe7d01nq39t5hfnpgnbm	38000.00
cmlezxecr01o339t5k4150ifm	cmlezxecr01o239t5656tyh4x	208000.00
cmlezxehx01oh39t5hxdgalqd	cmlezxehx01og39t5zce40e13	17000.00
cmlezxenc01ov39t5kenrdaou	cmlezxenc01ou39t541hk2jfb	63000.00
cmlezxez101p939t5kvtd9aw2	cmlezxez101p339t59hrpxijr	208000.00
cmlezxfcr01qa39t5agnkxha6	cmlezxfcr01q839t5qdbjqldf	115000.00
cmlezxfj801qn39t5u21b73vl	cmlezxfj801qm39t5llwe1evh	207000.00
cmlezxfp101r539t5mnegcg6y	cmlezxfp101r239t5blggupmv	73000.00
cmlezxfuk01rj39t5a7m0e4wb	cmlezxfuk01ri39t5n4zch0f4	179000.00
cmlezxg1o01s339t5g460kg3p	cmlezxg1o01s139t5fazq8lva	80000.00
cmlezxg8f01sj39t5koa77a8x	cmlezxg8f01sh39t51lk25wlr	91000.00
cmlezxge901st39t59mhbtetz	cmlezxge901sr39t54tiulnj6	139000.00
cmlezxgnm01td39t5kdcb3ejc	cmlezxgnm01tc39t5ue1ys4p9	214000.00
cmlezxgx401tn39t5ma7lmp9c	cmlezxgx401tm39t5dv0xvhz9	129000.00
cmlezxh3901u339t5nkqxnxdw	cmlezxh3901u239t5yuhcagcg	53000.00
cmlezxhwt01ut39t59mp4888i	cmlezxhwt01uq39t5a61yuou9	74000.00
cmlezxi5001vd39t5otef7dp8	cmlezxi5001vc39t5801hxf76	293000.00
cmlezxiey01w139t59iyhdu1w	cmlezxiey01vy39t5t3fjnjjh	91000.00
cmlezxik401wd39t58s1eip2v	cmlezxik401wc39t5uhcnp26x	208000.00
cmlezxiry01x139t5ee74h14y	cmlezxiry01wz39t5jy87pbfk	301000.00
cmlezxizn01xb39t5rycqgi5i	cmlezxizn01x939t5jql8crxq	30000.00
cmlezxjbr01y139t5vykr62xg	cmlezxjbr01y039t5n1ynt6lt	30000.00
cmlezxjit01yj39t5woddh0dv	cmlezxjit01yi39t5a9xn90fb	31000.00
cmlezxjqg01z339t5c5xgu2bc	cmlezxjqg01z239t5zspb19oz	0.00
cmlezxjxe01zn39t5jmgxpprb	cmlezxjxe01zm39t5hod0gbpg	124000.00
cmlezxk5i020139t537ghamcc	cmlezxk5i020039t59b0yzjf0	121000.00
cmlezxkty020c39t5t5zhq0w7	cmlezxkty020639t5ppbxjxtl	47000.00
cmlezxllu021d39t5vrdqbhv1	cmlezxllu021c39t56ihipi00	62000.00
cmlezxlr3021p39t5kneysqcz	cmlezxlr2021o39t58pt4ovyf	0.00
cmlezxlvy022339t50dz62ltw	cmlezxlvy022239t5jt6ev037	30000.00
cmlezxm06022d39t5gegnwkul	cmlezxm06022c39t57ooszqgi	97000.00
cmlezxm69022x39t5notqnb2w	cmlezxm68022w39t5i7w0yfch	90000.00
cmlezxmbz023939t5ps4ath9h	cmlezxmbz023839t5dxqcj9sa	0.00
cmlezxmia023l39t5056jaunk	cmlezxmia023k39t5qww8b02k	23000.00
cmlezxmov024539t5y1hmfbeq	cmlezxmov024439t5eo7b5n3u	26000.00
cmlezxmvj024j39t5b3qdo9ss	cmlezxmvj024i39t5hje474v8	0.00
cmlezxn0z024x39t5zspomweg	cmlezxn0z024w39t5ndpobvcn	15000.00
cmlezxn6n025f39t595am5ksn	cmlezxn6n025e39t5mtscndwh	15000.00
cmlezxnxs026639t5bk8zre6t	cmlezxnxs026439t53660wxve	31000.00
cmlezxo4j026j39t5abyb5fkv	cmlezxo4j026g39t5c376ogew	12000.00
cmlezxoau026z39t5ogpvmmkg	cmlezxoat026y39t53q6p1p0o	37000.00
cmlezxoh7027939t50xeks0i7	cmlezxoh7027839t5iya9wvel	0.00
cmlezxonf027r39t5cnqlmogk	cmlezxonf027m39t5b6bi32pd	15000.00
cmlezxouc028a39t52382qk21	cmlezxouc028739t53evyw3k9	150000.00
cmlezxp19028v39t521x2ldy3	cmlezxp19028u39t5t8zam1jj	0.00
cmlg4392z0022pv85jddg0va6	cmlg4392z0020pv85tmf536v2	97000.00
cmlg439bc002bpv85zuz0y75z	cmlg439bc002apv85e48txptq	85000.00
cmlg439hs002npv85zu9ehd0t	cmlg439hs002mpv85cfl8zfuf	125000.00
cmlg439oi002vpv852chwexu6	cmlg439oi002upv8540uk54zx	87000.00
cmlg439uj0035pv854hqceaek	cmlg439uj0034pv85sdmkm7pu	148000.00
cmlg43a84003npv85fjh48mm0	cmlg43a84003mpv85kmcw4ghg	132000.00
cmlg43afj003vpv85k1wq3dr2	cmlg43afj003upv852buw1swk	74000.00
cmlg43as60045pv85bb5hws1o	cmlg43as50044pv852t05v813	57000.00
cmlg43azw004fpv8516rsy178	cmlg43azw004epv855j1ite8w	54000.00
cmlg43b7h004rpv856448yldv	cmlg43b7h004ppv85w9rxzw1d	54000.00
cmlg43bds004xpv85xsxnxyyy	cmlg43bds004wpv853wvp9j3q	76000.00
cmlg43bkj0059pv851yuelzwy	cmlg43bkj0058pv85t13nx2ps	96000.00
cmlg43d82005kpv854itbzftt	cmlg43d81005hpv85kqbluz0t	78000.00
cmlg43dp7006fpv85oo205lb0	cmlg43dp7006epv85smuqzl5p	262000.00
cmlg43dzi006zpv85htxscw9s	cmlg43dzi006ypv853tgfiioe	51000.00
cmlg43ece007kpv85gm4mld1x	cmlg43ece007ipv85dvokzm9d	60000.00
cmlg43el90086pv85kkt8i39o	cmlg43el80084pv85fcsgcb4r	97000.00
cmlg43eru008opv851uqzkfm0	cmlg43eru008npv85reuqn30p	83000.00
cmlg43exq0093pv852pge5eqi	cmlg43exq0092pv858eflu7z2	74000.00
cmlg43f57009dpv85f8mkjxmo	cmlg43f57009cpv85rop8ugoo	47000.00
cmlg43ffz009vpv85cpvsbvhm	cmlg43ffz009upv852st8eilu	60000.00
cmlg43for00adpv85sr95a7wd	cmlg43foq00acpv85yp1xxkt2	69000.00
cmlg43fwl00atpv85uo9tdis7	cmlg43fwl00arpv85vp5mly3c	235000.00
cmlg43gdx00bbpv85cw5lmfc0	cmlg43gdx00bapv8582nf28du	88000.00
cmlg43glo00bppv85f9hq8sby	cmlg43glo00bopv85mu5zqucp	73000.00
cmlg43gsl00c6pv85ts3uynxf	cmlg43gsl00c5pv858les770k	87000.00
cmlg43gyj00cppv85af7q6pjv	cmlg43gyj00cmpv85d7n9z5hn	52000.00
cmlg43h4900cvpv85u0vdzygv	cmlg43h4900cupv8554ujay6e	94000.00
cmlg43ha100dbpv8558qw7zyk	cmlg43ha000dapv855d94j9pl	156000.00
cmlg43mas00l2pv8521s981ez	cmlg43mas00l0pv85cokdovxy	77000.00
cmlg43mk700llpv851n6a6a08	cmlg43mk700ljpv85r2qar65w	56000.00
cmlg43mub00m3pv85hz7fgpd0	cmlg43mua00m0pv85otdqd1n6	90000.00
cmlg43n9i00mcpv859chrvdvw	cmlg43n9i00m8pv85ll0cta5h	20000.00
cmlg43o1000napv85fhwb50uw	cmlg43o1000n7pv850976wsre	40000.00
cmlg43oic00o9pv85ng9wdknd	cmlg43oib00o8pv8550ooevzp	24000.00
cmlg43p6f00otpv85nkfu81jk	cmlg43p6f00orpv85lkbuzvrp	12000.00
cmlg43pfx00pbpv85ht4vq64f	cmlg43pfw00p9pv85qbydupos	13000.00
cmlg43pnq00prpv85hn791urj	cmlg43pnq00pqpv85jzvbn84a	16000.00
cmlg43pul00qbpv858llegg2k	cmlg43pul00q9pv85ct87ywkf	14000.00
cmlg43q1d00qrpv85m0ulvsn8	cmlg43q1d00qppv85ga6e9hr0	21000.00
cmlg43q7q00qzpv851d95x8xt	cmlg43q7q00qypv856d3k612z	24000.00
cmlg43qho00rdpv85b4nvx5ri	cmlg43qho00rcpv853f6orgbj	32000.00
cmlg43rh100rspv855ry050u9	cmlg43rh100ropv85crj0j6r7	0.00
cmlg443ws0007x6ttvijax4x4	cmlg443ws0006x6ttm75dge32	67000.00
cmlg44450000bx6ttccqgj5z3	cmlg44450000ax6tt2263ifm5	60000.00
cmlg444pz000jx6tt6mzx0ncz	cmlg444pz000ix6ttk621jy1o	33000.00
cmlg444yf000nx6ttfzfd9cru	cmlg444yf000mx6ttulnvvraq	29000.00
cmlg445f5000rx6ttconvc17g	cmlg445f5000qx6ttfgc6s7tu	1062000.00
cmlg4462r000vx6ttqdmg0w2j	cmlg4462r000ux6ttj16fzdj0	34000.00
cmlg446ub0017x6ttvuq0mwxv	cmlg446ub0016x6tt3ecccvib	232000.00
cmlg44755001dx6ttw4bygd86	cmlg44755001cx6ttoz03dddx	47000.00
cmlg447dz001lx6ttfb69fyx7	cmlg447dz001kx6tt9lnpxwa3	151000.00
cmlg447jy001px6ttowzks2gi	cmlg447jy001ox6ttzwdpe99v	147000.00
cmlg447tc001xx6ttsb0uiw2c	cmlg447tc001wx6ttla44au17	166000.00
cmlg4481f0023x6tt1xhozwke	cmlg4481f0022x6ttfpmj3nrt	715000.00
cmlg448ap0028x6tt1epba3j4	cmlg448ap0027x6ttlilvbwo9	166000.00
cmlg448qm002dx6ttaz0upyn8	cmlg448ql002cx6ttakq2ne5c	211000.00
cmlg449ow0037x6ttxlc6xdd4	cmlg449ow0036x6tt9lujyoz6	162000.00
cmlg44age003vx6ttxh0l1x8p	cmlg44age003ux6tt82csbx9r	62000.00
cmlg44aoj0043x6ttyxuz3ht8	cmlg44aoj0042x6ttqznn3jor	119000.00
cmlg44ay4004hx6tteroejp4s	cmlg44ay4004fx6tt2i1rzpal	166000.00
cmlg44bmn0051x6ttrl2cljy7	cmlg44bmn004zx6ttakwqoin9	172000.00
cmlg44bz50055x6ttogmwnqtr	cmlg44bz50054x6ttuk484jib	126000.00
cmlg44ccu005ox6tt4bb6c68x	cmlg44ccu005lx6ttunyeavv6	225000.00
cmlg44coh0065x6tt7wnvrjhy	cmlg44coh0061x6ttyt1kqzky	202000.00
cmlg44czq0069x6ttel7eejm6	cmlg44czq0068x6ttoasf0ztt	137000.00
cmlg44del006tx6tt1syepy56	cmlg44del006px6ttaomthpnz	104000.00
cmlg44dw50079x6ttyjd058j4	cmlg44dw40076x6ttxvcotkja	126000.00
cmlg44ebe007mx6ttob66dqa6	cmlg44ebe007kx6ttciofwgaq	173000.00
cmlg44etb008bx6ttvw2o4dlk	cmlg44etb0089x6tttl0jx2al	74000.00
cmlg44f9c008ux6tt0qdtqbhn	cmlg44f9c008sx6tt92kdwuuw	82000.00
cmlg44fq6009bx6ttaof26ytj	cmlg44fq6009ax6tt6sl38j4p	80000.00
cmlg44g3f009px6ttlp5slll7	cmlg44g3f009ox6ttu6r11mf4	208000.00
cmlg44ghv00a6x6ttpclx3z84	cmlg44ghv00a5x6ttm4fedf5p	294000.00
cmlg43mec00lcpv852w2bexao	cmlg43mec00lbpv857lqtdynu	82000.00
cmlg43mm700lnpv85tm71sr1t	cmlg43mm700lmpv85az7kp3gx	21000.00
cmlg43nax00mlpv85paf5c5b9	cmlg43nax00mkpv85jygz5b4l	32000.00
cmlg43nmy00mvpv85gvu23nhz	cmlg43nmy00mupv8515lb6axz	29000.00
cmlg43nwu00n5pv8539nkemm8	cmlg43nwu00n4pv85qner7v0k	28000.00
cmlg43o3h00nkpv8594iigfsv	cmlg43o3h00nipv85nakb26pc	22000.00
cmlg43obs00nvpv85b6a46fuv	cmlg43obs00ntpv8529flmtya	168000.00
cmlg43oib00o7pv85ye5oc1x8	cmlg43oib00o6pv859s4yiilj	66000.00
cmlg43p8000oxpv85ws8kvjjn	cmlg43p8000owpv85lmdo7h5j	13000.00
cmlg43pip00pnpv85r4460sj7	cmlg43pip00pmpv854roi4f24	22000.00
cmlg43prj00q6pv852k7wkg4g	cmlg43prj00q4pv85zblz287e	48000.00
cmlg43q0r00qnpv85cbue7mu8	cmlg43q0r00qmpv85omsgop65	25000.00
cmlg43qjh00rkpv85dpjsb0d2	cmlg43qjh00rhpv8529ne0zdm	11000.00
cmlg43rh200s5pv858decgmc7	cmlg43rh100s3pv85q6xpv22k	12000.00
cmlg43s0100sdpv85n7hzi6ft	cmlg43s0100sbpv85tkl9vaxf	0.00
cmlg44ay4004gx6ttwdpnwe3o	cmlg44ay4004ex6tt14mswyt7	112000.00
cmlg44bmm004xx6tt4wa1s50y	cmlg44bmm004wx6ttxmetd8mk	226000.00
cmlg44c3l005gx6ttu87thdn8	cmlg44c3l005ex6ttj3zoh8ea	272000.00
cmlg44chl005ux6ttbbegllpt	cmlg44chl005sx6tt7e2wd2id	75000.00
cmlg44d43006lx6ttix9ww224	cmlg44d43006kx6ttcfqwzfty	128000.00
cmlg44dmk0071x6ttn7nsxkmx	cmlg44dmk0070x6tt9koluzs7	142000.00
cmlg44e2n007hx6ttmj5rluwz	cmlg44e2n007gx6tt9a2hogve	136000.00
cmlg44ekh0081x6ttwumv1fy7	cmlg44ekg0080x6ttxlc4yzbw	92000.00
cmlg44eyq008lx6ttei3t9rjw	cmlg44eyp008jx6ttdl5o64ga	86000.00
cmlg44fee0093x6ttmrq8jxdl	cmlg44fee0092x6tth6m5caps	73000.00
cmlg44g3f009rx6ttinqqxseq	cmlg44g3f009qx6ttdq2ex2fm	115000.00
cmlg44ghv00a7x6tt2v6sanh4	cmlg44ghv00a4x6tth2zw1cyt	64000.00
cmlg43mec00ldpv85pi9kggmu	cmlg43mec00lapv85jqr8prtb	88000.00
cmlg43mn900lppv851s15yly4	cmlg43mn900lopv85zwxjsdeb	144000.00
cmlg43n9j00mfpv85jko29xl8	cmlg43n9i00mdpv85s4a2v59n	11000.00
cmlg43o1000n9pv85329qr1ki	cmlg43o1000n6pv85g90154e2	15000.00
cmlg43oib00o4pv851lmck3d2	cmlg43oib00o0pv85m7cpurvy	24000.00
cmlg43p7200ovpv85k5z4ttrb	cmlg43p7200oupv85osfbtl5a	41000.00
cmlg43phf00pipv85nbd29qv2	cmlg43phf00pgpv85u2nzor7l	37000.00
cmlg43pp700pypv85mlxtzl3e	cmlg43pp700pvpv85xnc6yv2j	16000.00
cmlg43pyx00qhpv85xwzly8cn	cmlg43pyx00qgpv85afydf28n	30000.00
cmlg43qfh00rbpv85qlgcemyf	cmlg43qfh00r9pv85tfh24r0f	71000.00
cmlg43rh100rzpv858mx9i1s6	cmlg43rh100rxpv85pxabb0fr	129000.00
cmlg43ruj00s9pv8573a8c4zw	cmlg43ruj00s8pv856ppsmwlm	69000.00
cmlg44ec9007px6ttbmmhgj6n	cmlg44ec9007ox6ttwvmgre7z	173000.00
cmlg44elf0085x6ttl2nnixhn	cmlg44elf0084x6ttojebhxz4	84000.00
cmlg44exa008fx6ttsgbbz4h8	cmlg44ex9008ex6tth6x3qbsb	76000.00
cmlg44fcc008zx6tt9imulku6	cmlg44fcc008yx6tt0z76hxna	82000.00
cmlg44fst009hx6ttgr129cm7	cmlg44fst009gx6ttyiaco8tl	92000.00
cmlg44g4t009ux6ttzjnw9qvo	cmlg44g4t009sx6ttezbxtv8j	218000.00
cmlg44gkx00a9x6ttfj153sy0	cmlg44gkx00a8x6ttc5tuzjgm	225000.00
cmlg44h8o00adx6tt2mx3njsj	cmlg44h8o00acx6tt045yegoq	94000.00
cmlg43mat00l5pv85nrcyy9xw	cmlg43mat00l4pv85amd9g8cr	96000.00
cmlg43ms000lzpv85pls6k3mo	cmlg43ms000lxpv852hauez0v	85000.00
cmlg43n9j00mjpv854539xqdi	cmlg43n9j00mipv85a6ddv8fi	14000.00
cmlg43nli00mopv85o8vyg1wl	cmlg43nlh00mmpv856dafda3n	29000.00
cmlg43nvb00mypv85nn3bk6po	cmlg43nva00mwpv85jg31aq4z	31000.00
cmlg43o2m00ngpv85ucr1me1h	cmlg43o2m00nepv858ei66ea2	57000.00
cmlg43oat00nqpv85n66orksm	cmlg43oat00nopv85ackmfvdf	19000.00
cmlg43oib00o2pv85rmoq4k8d	cmlg43oib00nzpv85e2secho8	53000.00
cmlg43p2000ojpv85znxfazm1	cmlg43p2000oipv85ho0kxw6c	42000.00
cmlg43p9600p0pv854egn8azq	cmlg43p9600oypv856izam4mx	14000.00
cmlg43phf00pjpv85wjlnn88w	cmlg43phf00phpv8518mh39hd	28000.00
cmlg43pqb00q3pv85ctl6cu72	cmlg43pqa00q2pv85omghaqn4	0.00
cmlg43pzp00qlpv85sf8993f3	cmlg43pzp00qkpv85859wew8i	24000.00
cmlg43q8t00r1pv857iuce5uk	cmlg43q8t00r0pv85oh1hyux7	30000.00
cmlg43qjh00rlpv85a6nkaoft	cmlg43qjh00rjpv85mbzxv3ip	11000.00
cmlg43rh100rypv854aqoobec	cmlg43rh100rtpv85enusjaf6	55000.00
cmlg43ruj00s7pv85dv5bbv5b	cmlg43ruj00s6pv85cx7yldt4	0.00
cmlg44cvt0067x6ttavkawfc0	cmlg44cvs0066x6tttb2xtjyh	131000.00
cmlg44del006sx6ttk4qmxv5h	cmlg44del006qx6tt9jekhwqi	187000.00
cmlg44dw40073x6ttuaxmsbpx	cmlg44dw40072x6ttns65y3ui	164000.00
cmlg44e94007jx6tttjqo36hh	cmlg44e94007ix6tt70tbqjzk	116000.00
cmlg44ei4007vx6tta2wga1mb	cmlg44ei4007ux6ttbeee7eon	175000.00
cmlg44exa008hx6ttblk6plxl	cmlg44exa008gx6tt427ta534	86000.00
cmlg44fat008xx6tt34zzzccu	cmlg44fas008wx6ttt0e5pjtn	60000.00
cmlg44fq6009dx6tt24xmrlt4	cmlg44fq6009cx6ttl0y69bic	76000.00
cmlg44g7t009zx6ttj9a01d4t	cmlg44g7t009yx6tts8oy94cl	132000.00
cmlg44h8n00abx6tt2bi4o6bu	cmlg44h8n00aax6ttwcq8fiko	124000.00
cmlg43mas00l3pv857ydx9q0w	cmlg43mas00l1pv85uih8jo77	31000.00
cmlg43mpr00lrpv85ve1tw0up	cmlg43mpr00lqpv85v82u62pp	86000.00
cmlg43n9i00m7pv85jdio7ogp	cmlg43n9i00m4pv85mihnthn7	19000.00
cmlg43o1000ndpv85g6pztohj	cmlg43o1000nbpv85bmntmt1z	42000.00
cmlg43ojf00obpv85ows7a8u9	cmlg43oje00oapv857vb7kl6j	32000.00
cmlg43p3000ompv85xjugdbw4	cmlg43p2z00okpv85z5pbkxkk	30000.00
cmlg43p9u00p3pv85ml63j8iy	cmlg43p9u00p2pv85d5wgua6k	122000.00
cmlg43pgh00pfpv85em0aggg4	cmlg43pgh00pepv85mbgk6bwa	13000.00
cmlg43pp700q0pv85lqrv2swd	cmlg43pp700pwpv857pl1bxso	38000.00
cmlg43pw600qdpv85zpglp25x	cmlg43pw600qcpv858v9xcq46	14000.00
cmlg43q4w00qxpv85y5p8rif6	cmlg43q4w00qwpv85f945yzuk	35000.00
cmlg43qcz00r5pv85lntlsmom	cmlg43qcz00r4pv850z6suhao	21000.00
cmlg43rh200s4pv85p38h5w0d	cmlg43rh100s2pv8595x3ukke	0.00
cmlg43s0t00sfpv850ssbbn9e	cmlg43s0t00sepv85tswmzbog	21000.00
cmlg449az002rx6tthnxwsy18	cmlg449az002qx6ttakg5p5i7	170000.00
cmlg449j2002zx6ttis1zrp5j	cmlg449j2002yx6tttsylq3v9	85000.00
cmlg449qj0039x6ttygk0s6ba	cmlg449qj0038x6ttgvnt5dmg	31000.00
cmlg44a0g003hx6tt2ordgx6p	cmlg44a0g003gx6tte0ljtybn	120000.00
cmlg44a8r003px6ttbrmwel75	cmlg44a8r003ox6ttmxs3f2tt	180000.00
cmlg44ai3003xx6tts79znco9	cmlg44ai2003wx6tt889m7dwu	27000.00
cmlg44aqh0047x6ttvolwashr	cmlg44aqg0046x6ttdc4we5a1	194000.00
cmlg44az2004lx6ttzgwb17nc	cmlg44az2004kx6tteqj41s9w	67000.00
cmlg44bmn0050x6ttr1j20xzq	cmlg44bmn004yx6ttl72cccfd	173000.00
cmlg44bz60058x6ttuyzjzg3a	cmlg44bz50057x6tt45hry9v8	156000.00
cmlg44ccu005px6ttdvdw37w1	cmlg44ccu005kx6tt0nkp1ecn	156000.00
cmlg44coh0062x6ttu7piuw0f	cmlg44coh005yx6ttzhr37s1n	158000.00
cmlg44czs006hx6ttaefygnsx	cmlg44czr006gx6ttjip6qyhb	190000.00
cmlg44dek006nx6ttnmrunnzq	cmlg44dek006mx6ttpegh1y4q	164000.00
cmlg44dw40078x6tt05xowk2q	cmlg44dw40075x6ttfai8kad5	174000.00
cmlg44ebe007nx6ttvrqg6wpx	cmlg44ebe007lx6ttufgxh78k	115000.00
cmlg44ekh0083x6ttcpzw9g9f	cmlg44ekh0082x6ttxdx4xj6b	72000.00
cmlg44f0m008nx6tt72qrsngz	cmlg44f0l008mx6ttsfzsti2f	82000.00
cmlg44fjj0097x6ttw1eglwki	cmlg44fjj0096x6tt46bde520	151000.00
cmlg44fxz009jx6ttnkumloxc	cmlg44fxz009ix6ttlsamoqg0	234000.00
cmlg44gaa00a1x6tt390d3d2i	cmlg44gaa00a0x6ttoag1dcit	169000.00
cmlg43mde00l9pv85kit2i84b	cmlg43mde00l8pv85enqah17c	110000.00
cmlg43mr600lvpv85o70eduic	cmlg43mr600ltpv85j6aoga3y	118000.00
cmlg43n9i00mapv85duu3y8bi	cmlg43n9i00m6pv85eybb5kke	12000.00
cmlg43o1000ncpv851bpnsif3	cmlg43o1000n8pv857msavmfs	66000.00
cmlg43oib00o1pv85bq6pykfu	cmlg43oib00nypv85tnt7xd9e	41000.00
cmlg43p6f00ospv85wvia9t9c	cmlg43p6f00oqpv85qofr6pyt	24000.00
cmlg43phf00plpv8555bgxr27	cmlg43phf00pkpv85wciajzuq	0.00
cmlg43pp700pxpv85ec9wknpy	cmlg43pp700pupv85qqc5aacx	49000.00
cmlg43q2600qtpv85ownb7c2v	cmlg43q2600qspv85motyj2eu	35000.00
cmlg43q9i00r3pv85y46ld9ik	cmlg43q9i00r2pv85t4hgpj3l	0.00
cmlg43qjh00ripv85isg1zf5m	cmlg43qjh00rgpv857dfj5elw	28000.00
cmlg43rh100s1pv85u7e3mtr7	cmlg43rh100s0pv85w1xcoaak	35000.00
cmlg43s0100scpv85q0qpw3gq	cmlg43s0100sapv85gb9ea6jx	14000.00
cmlg44az2004jx6ttnsh5664c	cmlg44az2004ix6ttrhifah3y	90000.00
cmlg44bmm004vx6tt66g2i4zg	cmlg44bmm004sx6ttny8s80k9	228000.00
cmlg44bz6005dx6ttto3jusyp	cmlg44bz6005cx6ttrhbupsws	121000.00
cmlg44ccu005rx6ttu7oduqt6	cmlg44ccu005qx6ttaqth9azf	215000.00
cmlg44coh0063x6tt1pxili04	cmlg44coh005zx6ttnnuz5pyk	188000.00
cmlg44czr006cx6ttllg0z5o9	cmlg44czr006ax6ttfel86p61	166000.00
cmlg44dg4006xx6ttvx0suit5	cmlg44dg4006wx6tt1b27imuq	112000.00
cmlg44dxw007dx6tt06ek83yv	cmlg44dxw007cx6tt5l97lgr1	95000.00
cmlg44ej7007xx6tt8e6103dg	cmlg44ej7007wx6tt8cpxsd2t	158000.00
cmlg44ew0008dx6ttnobao1e6	cmlg44ew0008cx6tte2e2fc73	86000.00
cmlg44f8i008rx6ttglnewzbe	cmlg44f8i008qx6ttnrcqjf1h	73000.00
cmlg44frk009fx6ttqe2wzdq5	cmlg44frk009ex6tts6okmlfx	81000.00
cmlg44g5f009xx6tt2ecp8u87	cmlg44g5f009wx6ttol39n45s	225000.00
cmlg43mib00lhpv85pf9aefk5	cmlg43mib00lgpv857ff1ln2f	103000.00
cmlg43mr600lupv85ibp4dwzs	cmlg43mr600lspv85mullq9ft	19000.00
cmlg43n9j00mhpv85g9v0vmoj	cmlg43n9j00mgpv85szsmtlxr	32000.00
cmlg43nmb00mtpv85yjybya1z	cmlg43nmb00mrpv85a58w2ua6	32000.00
cmlg43nvz00n2pv8514z10tmd	cmlg43nvz00n0pv85l2gpkhgg	20000.00
cmlg43o4i00nnpv855ea3z2p6	cmlg43o4i00nmpv85cx0my572	54000.00
cmlg43obs00nupv85ibcuoxp4	cmlg43obs00nspv85i8enxm5e	67000.00
cmlg43ojf00odpv85ru8kx6ah	cmlg43ojf00ocpv85nvbh46m9	24000.00
cmlg43p1z00ohpv85zclectel	cmlg43p1z00ogpv85zwbqxpcq	28000.00
cmlg43p9600p1pv85pr3rov96	cmlg43p9600ozpv853k671y2h	32000.00
cmlg43pfx00papv85ee87w9dw	cmlg43pfw00p8pv85z6a1ew3k	57000.00
cmlg43pnr00ptpv857784ivwr	cmlg43pnr00pspv85foh3h352	16000.00
cmlg43pul00qapv85ojkm9k41	cmlg43pul00q8pv85ycjhsdn7	16000.00
cmlg43q1d00qqpv8521ov4r1p	cmlg43q1d00qopv8510u0y5d7	53000.00
cmlg43qhp00rfpv85u3wlchgs	cmlg43qho00repv85vot6dc3y	26000.00
cmlg43rh100rupv85yg23639u	cmlg43rh100rqpv85qffrncid	12000.00
cmlg445jy000tx6ttegjp7shy	cmlg445jy000sx6ttpzps66p7	681000.00
cmlg4464y000xx6ttqbf84pm2	cmlg4464y000wx6ttq4c3l6na	31000.00
cmlg446j10013x6ttu48g7ywb	cmlg446j10012x6tt54g9bhs1	232000.00
cmlg446vd0019x6tt38dmxbsr	cmlg446vd0018x6tt5x3koczw	61000.00
cmlg4475y001fx6ttpojj6rdn	cmlg4475y001ex6ttglqzgh0r	232000.00
cmlg447cn001jx6ttzkkzv8z0	cmlg447cn001ix6ttmrk1ekwt	138000.00
cmlg447kl001rx6tt9s88juiq	cmlg447kl001qx6ttnjjravet	89000.00
cmlg447s7001vx6tt7agh47h0	cmlg447s7001ux6ttbocwmg4a	83000.00
cmlg4481f0021x6ttptu8r76q	cmlg4481f0020x6ttdci0xoma	220000.00
cmlg448ap0029x6ttajssex3f	cmlg448ap0026x6ttbnx6rjhb	133000.00
cmlg448rw002fx6ttjxguwbca	cmlg448rw002ex6ttjgwxz6io	153000.00
cmlg44962002px6tt8ilmn38m	cmlg44962002ox6tt523u99ji	192000.00
cmlg449g1002xx6tt89isw9i2	cmlg449g1002wx6ttsxv3jhmp	158000.00
cmlg449ow0035x6tt8pzpj8cu	cmlg449ow0034x6tt1w77e4ze	100000.00
cmlg449xi003fx6ttdr733w1a	cmlg449xi003ex6ttezdepafr	211000.00
cmlg44a70003nx6ttm0hlb3wo	cmlg44a70003mx6tt5r0zubsk	211000.00
cmlg44apq0045x6ttd1eyeil5	cmlg44apq0044x6tt47ps6k2c	179000.00
cmlg44ay4004dx6tt1bd4aig1	cmlg44ay4004cx6tt2h6067zd	107000.00
cmlg44bmm004tx6tt45byhgqq	cmlg44bmm004qx6ttt79gt1zg	201000.00
cmlg44c3l005hx6ttdl8dwmj2	cmlg44c3l005fx6ttdtvviwlx	294000.00
cmlg44chl005vx6tta8ljm6d8	cmlg44chl005tx6ttmzv7unnl	173000.00
cmlg44czr006dx6ttovokixcz	cmlg44czr006bx6ttj4sdwozl	163000.00
cmlg44del006vx6tt2wmandqa	cmlg44del006ux6tts6c2r811	116000.00
cmlg44dw40077x6ttcnv8v4l9	cmlg44dw40074x6ttl258fd82	179000.00
cmlg44ees007tx6ttlb2y97yk	cmlg44ees007rx6ttcpxlfalv	92000.00
cmlg44etb008ax6tt3cbut8ms	cmlg44etb0088x6ttk6p6lkyw	159000.00
cmlg44f9c008vx6ttj9d10y1v	cmlg44f9c008tx6tt7r50p375	177000.00
cmlg44foj0099x6ttpf9ecukl	cmlg44foj0098x6tterqbnhbl	261000.00
cmlg44g1q009nx6tteqqpv35a	cmlg44g1q009lx6ttttkztv5g	245000.00
cmlg43mfi00lfpv857jgn39ap	cmlg43mfi00lepv858qn9su8p	83000.00
cmlg43ms000lypv85g3oobi78	cmlg43ms000lwpv8502qogslp	105000.00
cmlg43n9j00mepv85cfyw0wo9	cmlg43n9i00mbpv85c9oa5t1u	26000.00
cmlg43nmb00mspv8539lj6bkn	cmlg43nmb00mqpv855noaorfs	38000.00
cmlg43nvz00n3pv85iz8ee4x6	cmlg43nvz00n1pv852ecrkegs	37000.00
cmlg43o3h00nlpv85jharlcbc	cmlg43o3h00njpv856xme4lfg	31000.00
cmlg43ocm00nxpv859ddvz0yd	cmlg43ocm00nwpv85dwk6m3n9	80000.00
cmlg43ol100ofpv856j4pop7t	cmlg43ol100oepv85tidk120w	11000.00
cmlg43p3l00oppv852pmv95is	cmlg43p3l00oopv85sfjmcpnx	12000.00
cmlg43pal00p7pv85rsb1tt6k	cmlg43pak00p6pv85wcon3diw	13000.00
cmlg43pjk00pppv85dmsgmsm7	cmlg43pjk00popv85hq56dbry	16000.00
cmlg43prj00q7pv85ul1o2iqf	cmlg43prj00q5pv85kvghu9w5	149000.00
cmlg43pyx00qjpv85l6fdp1y9	cmlg43pyx00qipv85ejihmayp	49000.00
cmlg43qfh00rapv85wkv5guyf	cmlg43qfh00r8pv855w4h6eg2	19000.00
cmlg43rh100rwpv85fnydfj08	cmlg43rh100rrpv851zbbvh3v	37000.00
cmlg448rx002hx6ttr0qh94t6	cmlg448rx002gx6ttwfnra04a	184000.00
cmlg4494r002lx6tt0676m1hv	cmlg4494r002kx6tt1af55w50	145000.00
cmlg449f9002ux6tthtq8cslu	cmlg449f9002sx6ttsgmrnryg	32000.00
cmlg449mw0033x6ttbistkve6	cmlg449mw0032x6tt9nitevtx	99000.00
cmlg449ud003dx6tt2sxbadwd	cmlg449ud003cx6ttknr05z30	98000.00
cmlg44a5m003lx6ttyxcws6zb	cmlg44a5m003kx6ttepp549vz	33000.00
cmlg44aek003tx6ttg9umzpu7	cmlg44aek003sx6tt2ga98l7a	122000.00
cmlg44aoh0041x6ttrb3xf60b	cmlg44aoh0040x6tt3zfzi6y2	187000.00
cmlg44awj004bx6ttvgc66a1g	cmlg44awj004ax6tt7tp42e9q	63000.00
cmlg44b49004px6tt10yxb563	cmlg44b49004ox6tta8rtpuh4	106000.00
cmlg44bmm004ux6tt2fb7s0x1	cmlg44bmm004rx6ttz4uwv140	226000.00
cmlg44bz6005bx6ttrznj5o4f	cmlg44bz60059x6ttg9sy15dw	128000.00
cmlg44ccu005nx6ttwk5q19r9	cmlg44ccu005jx6ttzlwki84s	219000.00
cmlg44coh0064x6ttcnf1bll1	cmlg44coh0060x6tt3jpqfc42	175000.00
cmlg44czr006fx6tt3j26fyua	cmlg44czr006ex6ttn59tas90	162000.00
cmlg44del006rx6ttikkdg5su	cmlg44del006ox6ttkj5c9ke9	203000.00
cmlg44dw5007bx6ttifdwtyy9	cmlg44dw5007ax6ttw1iuylwz	207000.00
cmlg44ees007sx6tt6z47ujvq	cmlg44ees007qx6tt19xm1epz	91000.00
cmlg44enr0087x6tth5mim6b0	cmlg44enr0086x6tt91mi872w	84000.00
cmlg44f32008px6ttmx1ty22v	cmlg44f32008ox6ttx5u9cnvt	67000.00
cmlg44fhn0095x6tt9o1etn89	cmlg44fhn0094x6tt2f5jbyw9	71000.00
cmlg44g4t009vx6ttvr0mjb3s	cmlg44g4t009tx6tt3ppoaxqp	201000.00
cmlg43mk700lkpv85ptbz46gw	cmlg43mk700lipv85rt3rh82r	158000.00
cmlg43mub00m2pv85qdfcno5m	cmlg43mua00m1pv85ilaoml75	134000.00
cmlg43n9i00m9pv857xnlixdv	cmlg43n9i00m5pv85lzfvlwu7	58000.00
cmlg43nli00mppv85nain0cgn	cmlg43nlh00mnpv8521mxzoi3	23000.00
cmlg43nvb00mzpv85rxpd1yd0	cmlg43nva00mxpv85zww8gnnm	34000.00
cmlg43o2m00nhpv858n7nggvd	cmlg43o2m00nfpv855axsqojs	35000.00
cmlg43oat00nrpv85we7j71wb	cmlg43oat00nppv852z4ph8u2	33000.00
cmlg43oib00o5pv856sno1kyb	cmlg43oib00o3pv85nv03cwqv	30000.00
cmlg43p3000onpv85oef1jb9k	cmlg43p3000olpv857xsl6b9r	43000.00
cmlg43pai00p5pv85wf60usl8	cmlg43pai00p4pv85p3jbh7yl	12000.00
cmlg43pgh00pdpv85pbydfk0x	cmlg43pgh00pcpv85gbpzi3mh	29000.00
cmlg43pp700q1pv85r4vgglpr	cmlg43pp700pzpv85nqad38wl	23000.00
cmlg43pw600qfpv85vacs2dfc	cmlg43pw600qepv85ip9akt6x	26000.00
cmlg43q4w00qvpv85o5bos4bi	cmlg43q4w00qupv85p0b2a73m	12000.00
cmlg43qcz00r7pv85c9ic3zb7	cmlg43qcz00r6pv85i2aqxa3m	21000.00
cmlg43qmr00rnpv85fpkb41uc	cmlg43qmr00rmpv85jzv6sq60	14000.00
cmlg43rh100rvpv85z0wm8uc7	cmlg43rh100rppv85fvuktkxq	10000.00
cmlg443h10001x6tt4kqggp41	cmlg443h10000x6ttua0mvifo	623000.00
cmlg443qw0005x6tt220rkgm0	cmlg443qw0004x6tt09aiw85s	958000.00
cmlg443z70009x6tt5c876g74	cmlg443z70008x6ttxse2bp1x	28000.00
cmlg44498000dx6ttuezjufjk	cmlg44497000cx6ttzgu81sx7	27000.00
cmlg444kh000hx6ttqd6vyn6s	cmlg444kh000gx6tt7nuezu5k	26000.00
cmlg444th000lx6ttjf9b3q8x	cmlg444th000kx6ttfau6hybz	38000.00
cmlg4452u000px6ttsouva2ye	cmlg4452u000ox6ttqcd07y2r	53000.00
cmlg44679000zx6tte4b95pf9	cmlg44679000yx6ttu7b9v1bd	44000.00
cmlg446k10015x6ttno800j2z	cmlg446k10014x6tt2jbctc83	31000.00
cmlg446xc001bx6tttuxhg0pd	cmlg446xc001ax6ttvuha313a	74000.00
cmlg4476n001hx6tti0am5cz5	cmlg4476m001gx6ttgv4dc8hw	124000.00
cmlg447ep001nx6ttf0w26abn	cmlg447ep001mx6ttfzm131ob	194000.00
cmlg447ma001tx6ttmu7rwztz	cmlg447ma001sx6ttu3wj5e7c	70000.00
cmlg447tc001zx6ttx4247qz6	cmlg447tc001yx6tt1cheymf2	138000.00
cmlg4482i0025x6tt88dd9jvo	cmlg4482i0024x6ttztrvpcvk	153000.00
cmlg448d2002bx6tta7dlk772	cmlg448d2002ax6ttkadyufrv	192000.00
cmlg448t2002jx6ttziocacpv	cmlg448t2002ix6ttdgdtakeu	221000.00
cmlg4494t002nx6ttytzuwnc8	cmlg4494t002mx6ttri2609nu	158000.00
cmlg449f9002vx6tt98pxwj16	cmlg449f9002tx6tth1jsnxbf	191000.00
cmlg449m90031x6tt3bbftbvs	cmlg449m90030x6ttdov4sigk	185000.00
cmlg449te003bx6ttlghh95cr	cmlg449te003ax6ttdbphl003	86000.00
cmlg44a41003jx6ttey9fxz3v	cmlg44a40003ix6ttt9xmnsnc	169000.00
cmlg44adt003rx6ttdbkyn1nl	cmlg44adt003qx6ttxu1k8tz9	111000.00
cmlg44ame003zx6tt9klr0dq7	cmlg44amd003yx6ttmrzm4fsr	173000.00
cmlg44au40049x6tty0o5v5jw	cmlg44au40048x6ttb3xbb0nt	119000.00
cmlg44b2f004nx6ttikg4fq3g	cmlg44b2f004mx6tt3qdbqsep	85000.00
cmlg44bmp0053x6ttg5ut4qtg	cmlg44bmp0052x6ttpq027cwk	158000.00
cmlg44bz6005ax6tt202mo7o5	cmlg44bz50056x6tt6q30bg40	126000.00
cmlg44ccu005mx6ttz6gkl1vv	cmlg44cct005ix6ttymop5ys6	157000.00
cmlg44cog005xx6tt2tww1okx	cmlg44cog005wx6ttyzpkz122	148000.00
cmlg44d16006jx6ttq42m0tsz	cmlg44d16006ix6ttqohxdrp0	156000.00
cmlg44dj8006zx6ttir7t9wti	cmlg44dj8006yx6tt1dfavk8q	219000.00
cmlg44e2n007fx6tthoyebq3i	cmlg44e2m007ex6ttsnwidfxj	131000.00
cmlg44ej8007zx6ttel1bcbue	cmlg44ej8007yx6ttn99naaf0	119000.00
cmlg44eyp008kx6ttwn1o35xe	cmlg44eyp008ix6tteyoqehz0	74000.00
cmlg44fcd0091x6tt5239prs1	cmlg44fcd0090x6ttnggt2rcf	86000.00
cmlg44g1q009mx6ttbpow6aev	cmlg44g1q009kx6tte5m8kg68	294000.00
cmlg44ghv00a3x6tt429y0xe5	cmlg44ghv00a2x6ttvfmvnqzf	241000.00
cmlg45l5h000413pedtwjl8su	cmlg45l5g000213pe63t46ycj	869000.00
cmlg45l5h000513pe81pth8tl	cmlg45l5h000313pesqo1u08q	166000.00
cmlg45l7s000713peepmnbxy7	cmlg45l7s000613pe1gw6p8ho	184000.00
cmlg45lem000b13pe5tje8i1l	cmlg45lem000a13pendk5r00i	130000.00
cmlg45lem000913pec3uyyrfs	cmlg45lem000813pe0ecudks6	145000.00
cmlg45lix000d13pepa6cv3h3	cmlg45lix000c13pextkolu03	101000.00
cmlg45lt6000f13pej5sgyent	cmlg45lt6000e13peulkx5q2k	48000.00
cmlg45lu3000h13pek015ra2d	cmlg45lu2000g13peojasn03o	844000.00
cmlg45mpw000j13pelapqzaff	cmlg45mpw000i13pem8nlgbpu	936000.00
cmlg464590003105g14bb9ks8	cmlg464590002105gs9w8ucsx	211000.00
cmlg4652h0005105gynr6k8tm	cmlg4652h0004105gaww18til	180000.00
cmlg465vz0007105gzio0c0ra	cmlg465vz0006105gf5o229kg	217000.00
cmlezxox1028j39t5zwkcx0wf	cmlezxox0028i39t50d2sbhp7	135000.00
cmlezxjk501yp39t5lcbzhyid	cmlezxjk501yo39t5ne3c5uc7	41000.00
cmlezwfrm000139t5s8s8m5ug	cmlezwfrm000039t5jsmq8rkl	1942000.00
cmlezxogk027739t5qwsqajef	cmlezxogk027639t51tk0jd9s	22000.00
cmlezxp0j028p39t53anxsl3k	cmlezxp0j028n39t5q2eupsx9	210000.00
cmqliofbf00003uuakewo96oy	6dd1b8b3-a97c-4273-ac89-073fb6b4ccf3	661000.00
cmqjuarfp0008dslhk8inaf73	858498b2-ad72-4e2d-ba76-ffea984e2c9e	13000.00
cmlezx615016p39t589frdqae	cmlezx615016o39t5uf4s001m	829000.00
cmlezxjn001yx39t5kmpkdg9a	cmlezxjn001yw39t5cct8wlvz	57000.00
cmlezwgaa000r39t5qju7z8cr	cmlezwgaa000q39t5gxoxtinf	183000.00
cmlezxo4j026l39t5pwnstj9i	cmlezxo4j026h39t5fhexuhp7	41000.00
\.


--
-- Data for Name: ProductStock; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ProductStock" (id, name, "imageProduct", stock, brand, "buyPrice", category, "createdAt", "masterCategory", "sellPrice", "skuManual", "updatedAt", barcode) FROM stdin;
cmlezx2sk011m39t5znkdzum5	COVER STOP / RR STOP CB 150 R NEW HITAM	\N	0	HONDA	57000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	57000.00	HON-COV-COV-689	2026-06-18 17:22:17.168	\N
cmlezwwye00os39t5mas6n06z	PANEL / TAMENGDEPAN BAGIAN BAWAH SCOOPY FI	\N	0	HONDA	100000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	87000.00	HON-PAN-PAN-455	2026-02-09 09:54:46.185	\N
cmlezwxdq00po39t50bfzctac	PANEL / TAMENGDEPAN BAGIAN BAWAH SCOOPY	\N	0	HONDA	81000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	87000.00	HON-PAN-PAN-456	2026-02-09 09:54:46.185	\N
102545b0-a8d7-4254-bbb1-721ff7a146fd	COVER STOP / RR STOP SCOOPY 20 KECIL PUTIH DOFF	\N	0	HONDA	85000.00	COVER STOP	2026-06-18 17:27:37.767	BODY PART	85000.00	HON-COV-1817	2026-06-18 17:35:37.871	\N
cmlezwlkl009239t5ezunedlb	FRONT FENDER / SPAKBOR DEPAN  A VARIO 160 HITAM DOFF	\N	0	HONDA	146000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	105000.00	HON-FRO-FRO-158	2026-06-18 17:19:42.083	\N
cmlezwy8900r739t5v31gcbur	PANEL / TAMENGVARIO TECHNO BIRU	\N	0	HONDA	192000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	70000.00	HON-PAN-PAN-425	2026-02-09 09:54:46.185	\N
cmlezwyqm00rv39t5w7n9zcrz	FRONT HANDLE COVER / BATOK DEPAN BEAT 20 PUTIH	\N	0	HONDA	120000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-502	2026-02-09 09:54:50.206	\N
cmlezwyyi00sc39t503dat3nn	FRONT HANDLE COVER / BATOK DEPAN BEAT POP MERAH	\N	0	HONDA	103000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-526	2026-02-09 09:54:50.206	\N
cmlezwoiw00di39t5hhxo8dpo	FRONT FENDER / SPAKBOR DEPAN  GENIO HITAM DOFF	\N	0	HONDA	150000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	105000.00	HON-FRO-FRO-228	2026-02-09 09:54:35.582	\N
d2714890-6d8b-4736-a875-28f11520f2cf	COVER STOP / RR STOP CB 150 R NEW HITAM	\N	0	HONDA	64000.00	COVER STOP	2026-06-18 17:27:37.767	BODY PART	64000.00	HON-COV-1818	2026-06-18 17:35:37.871	\N
24f59336-834a-402a-b3ad-6541e0bfea3c	COVER STOP / RR STOP SCOOPY FI 17 HITAM	\N	0	HONDA	104000.00	COVER STOP	2026-06-18 17:27:37.767	BODY PART	104000.00	HON-COV-1819	2026-06-18 17:35:37.871	\N
cmlezwvmw00m939t52198d3u1	PANEL / TAMENGVARIO TECHNO PUTIH	\N	0	HONDA	152000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.184	LAIN-LAIN	342000.00	HON-PAN-PAN-406	2026-06-19 22:07:23.325	01B2930547AA1
5b4b2b19-8ebb-4127-a07a-9b6e44c42e3f	COVER STOP / RR STOP SCOOPY FI 17 MERAH	\N	0	HONDA	118000.00	COVER STOP	2026-06-18 17:27:37.767	BODY PART	118000.00	HON-COV-1820	2026-06-18 17:35:37.871	\N
cmlezwzi500tt39t5kc2x2yer	FRONT HANDLE COVER / BATOK DEPAN BEAT ORANGE	\N	0	HONDA	62000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-529	2026-02-09 09:54:50.207	\N
cmlezwgfs001039t5b21x4joa	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO HITAM	\N	0	HONDA	132000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	135000.00	HON-COV-COV-36	2026-02-09 09:54:25.619	\N
cmlezx09s00vu39t5zriqssrx	FRONT HANDLE COVER / BATOK DEPAN GENIO A+B BIRU	\N	0	HONDA	75000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-577	2026-02-09 09:54:50.207	\N
cmlezx18j00xk39t57i29t25v	FRONT HANDLE COVER / BATOK DEPAN SMASH 06 HITAM	\N	0	HONDA	65000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:53.443	BODY PART	119000.00	HON-FRO-FRO-607	2026-02-09 09:54:53.443	\N
cmlezx1re00yk39t58ttkg79n	COVER STOP / RR STOP BEAT POP	\N	0	HONDA	23000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	18000.00	HON-COV-COV-645	2026-02-09 09:54:53.444	\N
cmlezwgkk001c39t5swp1t3qr	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO PUTIH	\N	0	HONDA	151000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	154000.00	HON-COV-COV-38	2026-02-09 09:54:25.619	\N
cmlezwglv001e39t5lwp5rfuc	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BEAT FI KECIL	\N	0	HONDA	30000.00	COVER BODY / BODY SAMPING BELAKANG  KANAN KIRI (HONDA)	2026-02-09 09:54:25.619	BODY PART	33000.00	HON-COV-COV-17	2026-02-09 09:54:25.619	\N
cmlezwt0i00j439t5fjn6j6mi	REAR FENDER / SPAKBOR BELAKANG SUPRA FIT NEW	\N	0	HONDA	60000.00	REAR FENDER / (KOLONG) VARIO TECHNO 125	2026-02-09 09:54:40.779	LAIN-LAIN	97000.00	HON-REA-REA-322	2026-02-09 09:54:40.779	01B2133282AA1
cmlezwgmq001i39t55gpn084u	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	\N	0	HONDA	176000.00	COVER BODY / BODY SAMPING BELAKANG  KANAN KIRI (HONDA)	2026-02-09 09:54:25.619	BODY PART	179000.00	HON-COV-COV-32	2026-02-09 09:54:25.619	\N
bb179714-3ee0-4880-9cfa-9120bb7188da	COVER STOP / RR STOP SCOOPY FI 17 PUTIH	\N	0	HONDA	118000.00	COVER STOP	2026-06-18 17:27:37.767	BODY PART	118000.00	HON-COV-1821	2026-06-18 17:35:37.871	\N
cmlezwgpk001o39t5sjnrn35t	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO 110 FI GRAY DOFF	\N	0	HONDA	218000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	221000.00	HON-COV-COV-54	2026-02-09 09:54:25.619	\N
cmlezwgqh001s39t5o53ymleq	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO 150 18 BESAR GRAY DOFF	\N	0	HONDA	316000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	319000.00	HON-COV-COV-43	2026-02-09 09:54:25.619	\N
db7c2393-d936-4a59-95ab-36dd9570901c	COVER STOP / RR STOP VARIO TECHNO 125 HITAM	\N	0	HONDA	51000.00	COVER STOP	2026-06-18 17:27:37.767	BODY PART	51000.00	HON-COV-1823	2026-06-18 17:35:37.871	\N
cmlg43o3h00njpv856xme4lfg	COVER STOP / RR STOP VEGA R 06 SILVER	\N	0	YAMAHA	28000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.568	BODY PART	31000.00	YAM-BOD-COV-629	2026-06-18 17:35:37.871	\N
cmlezwg26000c39t5dfiuy12n	COMPLETE SET BODY VARIO 150 MERAH	\N	0	HONDA	1621000.00	COMPLETE SET BODY	2026-02-09 09:54:25.619	BODY PART	1659000.00	HON-COM-COM-6	2026-06-18 17:27:37.767	\N
cmlezwisq005g39t5huidcr6e	COMPLETE SET BODY SUPRA X 125 07 MERAH MAROON	\N	0	HONDA	1118000.00	COMPLETE SET BODY	2026-02-09 09:54:25.62	BODY PART	1146000.00	HON-COM-COM-10	2026-06-18 17:27:37.767	\N
cmlezxez101pe39t5hzysm6tl	LEGSHIELD LUAR / SAYAP LUAR PCX 150 18 HITAM DOFF	\N	0	HONDA	464000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.245	BODY PART	491000.00	HON-LEG-LEG-1113	2026-06-18 17:27:37.767	\N
cmlezxfgv01qe39t5i6c4sa35	LEGSHIELD LUAR / SAYAP LUAR PCX 150 18 MERAH DOFF	\N	0	HONDA	464000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	491000.00	HON-LEG-LEG-1115	2026-06-18 17:27:37.767	\N
cmlezx82x019x39t5xuqthy5q	MIKA LAMPU GRAND DE	\N	0	HONDA	28000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	33000.00	HON-MIK-MIK-819	2026-06-18 17:27:37.767	\N
cmlezwgro001u39t5tuhhpoad	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 GRAY	\N	0	HONDA	176000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	179000.00	HON-COV-COV-33	2026-02-09 09:54:25.619	\N
cmlezwgxl002839t55v1mm5j9	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO VIOLET	\N	0	HONDA	153000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	156000.00	HON-COV-COV-61	2026-02-09 09:54:25.619	\N
cmlezwg9v000o39t53jskxw13	COMPLETE SET BODY VARIO 150 18 TWO TONE ( CYAN – WHITE )	\N	0	HONDA	2151000.00	COMPLETE SET BODY	2026-02-09 09:54:25.619	BODY PART	2159000.00	HON-COM-COM-8	2026-06-18 17:27:37.767	\N
cmlezx1zf00zc39t5ecv4v29m	FRONT HANDLE COVER / BATOK DEPAN KARISMA X / LUBANG BAUT HITAM CAKRAM	\N	0	HONDA	67000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:53.444	BODY PART	74000.00	HON-FRO-FRO-611	2026-06-19 22:05:52.362	01B2330A40AA1
5b477ebc-746b-47c1-ac1a-3d70575acb67	PIPA GAS TORNADO	\N	0	SUZUKI	12000.00	PIPA	2026-06-18 17:44:06.615	BODY PART	12000.00	SUZ-PIP-1	2026-06-18 17:44:06.615	\N
cmlezwhxr004439t51eh0n3so	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY PINK	\N	0	HONDA	175000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	178000.00	HON-COV-COV-86	2026-02-09 09:54:25.62	\N
cmlezwyqm00s339t5fxtxovw6	FRONT HANDLE COVER / BATOK DEPAN BEAT 20 HIJAU DOFF	\N	0	HONDA	120000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-509	2026-06-19 22:07:30.04	01B5930090AA1
cmlezwibp004s39t5iz3c82b5	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY PUTIH	\N	0	HONDA	174000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	177000.00	HON-COV-COV-83	2026-02-09 09:54:25.62	\N
819b45ed-488d-4f94-923c-5fc54f0b5a26	LEGSHIELD DALAM / SAYAP DALAM REVO FI HITAM	\N	0	HONDA	0.00	LEGSHIELD DALAM	2026-06-18 17:11:12.592	BODY PART	76000.00	HON-LEG-1464	2026-06-18 17:11:12.592	01B391740AA1
cmlezwjtv005m39t5qtq0mg4h	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI REVO SILVER CW + COVER STOP	\N	0	HONDA	214000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.883	BODY PART	217000.00	HON-COV-COV-111	2026-02-09 09:54:30.883	\N
cmlezwk88006m39t54rop6jcd	FRONT FENDER / SPAKBOR DEPAN  BEAT FI PUTIH	\N	0	HONDA	92000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	111000.00	HON-FRO-FRO-141	2026-06-18 17:22:17.168	\N
cmlezx4km014639t5a5vltpfr	LAMPU DEPAN / HEAD LAMP VARIO TECHNO	\N	0	HONDA	137000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	829000.00	HON-LAM-LAM-741	2026-06-19 22:07:44.713	01B2900200AA1
cmlezwmk400au39t54c5n97e0	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SMASH BIRU	\N	0	HONDA	225000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.885	BODY PART	228000.00	HON-COV-COV-117	2026-02-09 09:54:30.885	\N
cmlezx2ao00zy39t5sjxqcffu	COVER STOP BAWAH / RR STOP VARIO MERAH MAROON	\N	0	HONDA	0.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	46000.00	HON-COV-COV-658	2026-06-18 17:22:17.168	01B2231152AA1
289f39b5-347b-44ba-bd5d-5f9b1625a4a1	COMPLETE SET BODY MIO MERAH	\N	0	YAMAHA	770000.00	COMPLETE SET BODY	2026-06-18 17:44:06.615	BODY PART	770000.00	YAM-COM-8	2026-06-18 17:44:06.615	01D1935041AA1
cc4aed20ec200f693e922b236	COMPLETE SET BODY SUPRA X 125 MERAH	\N	0	HONDA	1132000.00	COMPLETE SET BODY	2026-06-18 16:34:31.492	BODY PART	1104000.00	HON-COM-COM-11	2026-06-18 17:22:17.168	\N
cmlezwip1005c39t54u8b8eby	COMPLETE SET BODY KARISMA SILVER	\N	0	HONDA	980000.00	COMPLETE SET BODY	2026-02-09 09:54:25.62	BODY PART	931000.00	HON-COM-COM-13	2026-06-18 17:22:17.168	\N
39b2fe48-2a36-46dc-a95a-cccc2aa444f2	COMPLETE SET BODY MIO MERAH MAROON	\N	0	YAMAHA	706000.00	COMPLETE SET BODY	2026-06-18 17:44:06.615	BODY PART	706000.00	YAM-COM-9	2026-06-18 17:44:06.615	01D1935052AA1
7714fc51-802d-456e-8b22-919132a591fa	COMPLETE SET BODY MIO KUNING	\N	0	YAMAHA	689000.00	COMPLETE SET BODY	2026-06-18 17:44:06.615	BODY PART	689000.00	YAM-COM-10	2026-06-18 17:44:06.615	01D1935092AA1
f3d98728-c916-49c9-beef-f5201ae613cb	COMPLETE SET BODY MIO PUTIH	\N	0	YAMAHA	667000.00	COMPLETE SET BODY	2026-06-18 17:44:06.615	BODY PART	667000.00	YAM-COM-11	2026-06-18 17:44:06.615	01D1935047AA1
afede305-b372-45c3-9dff-a09af2157b3f	COMPLETE SET BODY MIO BIRU TUA	\N	0	YAMAHA	676000.00	COMPLETE SET BODY	2026-06-18 17:44:06.615	BODY PART	676000.00	YAM-COM-12	2026-06-18 17:44:06.615	01D1935071AA1
b29dd05d-4d76-4ecb-a3b3-a422409928fe	COMPLETE SET BODY MIO BIRU MUDA METALIK/TELUR ASIN	\N	0	YAMAHA	681000.00	COMPLETE SET BODY	2026-06-18 17:44:06.615	BODY PART	681000.00	YAM-COM-13	2026-06-18 17:44:06.615	01D1935048AA1
cmlezwl7a008e39t5qztnnbdt	FRONT FENDER / SPAKBOR DEPAN  VARIO 110 FI PUTIH	\N	0	HONDA	121000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	126000.00	HON-FRO-FRO-175	2026-02-09 09:54:30.884	\N
cmlezwllh009639t5zuc1sbp4	FRONT FENDER / SPAKBOR DEPAN  VARIO 150 MERAH	\N	0	HONDA	110000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	105000.00	HON-FRO-FRO-170	2026-02-09 09:54:30.884	\N
cmlezwluc009q39t5it3kengz	FRONT FENDER / SPAKBOR DEPAN  VARIO 150 18 / 125 23 GRAY DOFF	\N	0	HONDA	135000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	130000.00	HON-FRO-FRO-187	2026-02-09 09:54:30.884	\N
cmlezwq0m00f439t5ppy3f02y	FRONT FENDER / SPAKBOR DEPAN  PCX 160 MERAH DOFF	\N	0	HONDA	154000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	167000.00	HON-FRO-FRO-221	2026-06-18 17:22:17.168	\N
cmlezwuys00lq39t5kf3lv7t8	PANEL / TAMENGVARIO 110 FI PUTIH	\N	0	HONDA	156000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	218000.00	HON-PAN-PAN-393	2026-02-09 09:54:40.78	\N
cmlezwh70002t39t5g0ck03f4	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 HITAM	\N	0	HONDA	159000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	162000.00	HON-COV-COV-57	2026-02-09 09:54:25.619	\N
cmlezwwo300oc39t5yq4ojwc9	PANEL / TAMENGDEPAN BAGIAN BAWAH VARIO TECHNO	\N	0	HONDA	55000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	55000.00	HON-PAN-PAN-431	2026-02-09 09:54:46.185	\N
cmlezwx6z00pc39t5901e9sfa	PANEL / TAMENGSMASH 06 HITAM	\N	0	HONDA	62000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	251000.00	HON-PAN-PAN-479	2026-02-09 09:54:46.185	\N
cmlezwxyg00qt39t551meijmx	PANEL / TAMENGVARIO TECHNO 125 BESAR ORANGE	\N	0	HONDA	192000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	187000.00	HON-PAN-PAN-424	2026-02-09 09:54:46.185	\N
cmlezwjzk005y39t5oukax9vr	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SMASH SILVER	\N	0	HONDA	225000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.884	BODY PART	228000.00	HON-COV-COV-118	2026-02-09 09:54:30.884	\N
cmlezwwxl00oo39t5dpd9clg1	PANEL / TAMENGSUPRA X 125 14 HITAM	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	93000.00	HON-PAN-PAN-475	2026-06-19 22:05:52.672	01B4130540AA1
cmlezwzq400ui39t58ou2nv3j	FRONT HANDLE COVER / BATOK DEPAN VARIO 110 FI MERAH MAROON	\N	0	HONDA	126000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	138000.00	HON-FRO-FRO-553	2026-06-19 22:05:52.981	01B4230052AA1
cmlezxjk501yo39t5ne3c5uc7	BOX FILTER UDARA SET SUPRA X 125 / X 125 07 / FIT NEW / KHARISMA	\N	0	HONDA	0.00		2026-02-09 09:55:15.055	MESIN & OLI	37000.00	HON-BOX-BOX-1288	2026-06-19 22:05:53.12	01B2539782AA1
cmlezx2ct010c39t58qmq4u0k	COVER STOP BAWAH / RR STOP VARIO HITAM	\N	0	HONDA	0.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	42000.00	HON-COV-COV-659	2026-06-19 22:05:53.26	01B2231140AA1
cmlezxdw101mu39t5q5i178zt	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 125 MERAH	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.265	BODY PART	245000.00	HON-LEG-LEG-1079	2026-06-19 22:05:53.404	01B4431881AA1
cmlezxecr01o239t5656tyh4x	LEGSHIELD LUAR / SAYAP LUAR VARIO 160 BESAR HITAM	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.266	BODY PART	240000.00	HON-LEG-LEG-1091	2026-06-19 22:05:53.538	01B6431840AA1
cmlezwngc00b739t5u5o1g0ig	FRONT FENDER / SPAKBOR DEPAN  SCOOPY 20 MERAH DOFF	\N	0	HONDA	150000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.58	BODY PART	126000.00	HON-FRO-FRO-201	2026-06-19 22:05:53.674	01B6230787AA1
cmlezwy8w00rc39t5fggakqba	PANEL / TAMENGSUPRA X 125 HITAM	\N	0	HONDA	62000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	88000.00	HON-PAN-PAN-471	2026-02-09 09:54:46.185	\N
cmlezxfj801qm39t5llwe1evh	LEGSHIELD DALAM / SAYAP DALAM KARISMA X / KARISMA HITAM	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	132000.00	HON-LEG-LEG-1150	2026-06-19 22:07:59.622	01B2331740AA1
cmlezwl6f008c39t5kfzkr0yv	FRONT FENDER / SPAKBOR DEPAN  VARIO 110 FI MERAH MAROON	\N	0	HONDA	121000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	126000.00	HON-FRO-FRO-174	2026-02-09 09:54:30.884	\N
cmlezwlsy009k39t5b7brkes9	FRONT FENDER / SPAKBOR DEPAN  VARIO 110 FI GRAY DOFF	\N	0	HONDA	116000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	126000.00	HON-FRO-FRO-191	2026-02-09 09:54:30.884	\N
cmlezwm4700a439t5b8504xpi	FRONT FENDER / SPAKBOR DEPAN  VARIO MERAH	\N	0	HONDA	79000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.885	BODY PART	105000.00	HON-FRO-FRO-196	2026-02-09 09:54:30.885	\N
cmlezwme400ag39t515xmrtc4	FRONT FENDER / SPAKBOR DEPAN  BEAT FI BIRU	\N	0	HONDA	92000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.885	BODY PART	89000.00	HON-FRO-FRO-138	2026-02-09 09:54:30.885	\N
cmlezwmll00aw39t5broev44s	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BLADE 11 HITAM	\N	0	HONDA	144000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.885	BODY PART	154000.00	HON-COV-COV-116	2026-02-09 09:54:30.885	\N
cmlezwo2p00ce39t5972eg7wy	FRONT FENDER / SPAKBOR DEPAN  SCOOPY FI MERAH	\N	0	HONDA	125000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	126000.00	HON-FRO-FRO-212	2026-02-09 09:54:35.581	\N
cmlezwoe100dc39t5prq5agus	FRONT FENDER / SPAKBOR DEPAN  SCOOPY FI MERAH MAROON	\N	0	HONDA	125000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	134000.00	HON-FRO-FRO-213	2026-02-09 09:54:35.582	\N
cmlezwq1300f639t5mh9he0xs	FRONT FENDER / SPAKBOR DEPAN  XEON HIJAU	\N	0	HONDA	60000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	89000.00	HON-FRO-FRO-289	2026-02-09 09:54:35.582	\N
cmlezwqi700fm39t5n9ugjr61	FRONT FENDER / SPAKBOR DEPAN  SCOOPY VIOLET	\N	0	HONDA	92000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	126000.00	HON-FRO-FRO-216	2026-02-09 09:54:35.582	\N
cmlezwqpf00fs39t58n36y361	FRONT FENDER / SPAKBOR DEPAN  B SONIC	\N	0	HONDA	45000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	146000.00	HON-FRO-FRO-242	2026-06-18 17:22:17.168	\N
cmlezwhm9003m39t53z3vw9he	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BEAT POP MERAH	\N	0	HONDA	139000.00	COVER BODY / BODY SAMPING BELAKANG  KANAN KIRI (HONDA)	2026-02-09 09:54:25.62	BODY PART	142000.00	HON-COV-COV-28	2026-02-09 09:54:25.62	\N
cmlezwi2u004c39t5445evrru	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY BIRU	\N	0	HONDA	175000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	178000.00	HON-COV-COV-85	2026-02-09 09:54:25.62	\N
cmlezwkg3007439t5r6zrwbgc	FRONT FENDER / SPAKBOR DEPAN  BEAT BIRU TUA	\N	0	HONDA	75000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	94000.00	HON-FRO-FRO-153	2026-06-18 17:22:17.168	\N
cmlezwkqn007m39t5gfz43qbe	FRONT FENDER / SPAKBOR DEPAN  BEAT ORANGE	\N	0	HONDA	76000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	89000.00	HON-FRO-FRO-155	2026-02-09 09:54:30.884	\N
cmlezwl9b008m39t5jg5u9n92	FRONT FENDER / SPAKBOR DEPAN  VARIO 150 GRAY	\N	0	HONDA	110000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	126000.00	HON-FRO-FRO-169	2026-02-09 09:54:30.884	\N
cmlezwliv009039t5p3fyffkt	FRONT FENDER / SPAKBOR DEPAN  VARIO HITAM	\N	0	HONDA	66000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	89000.00	HON-FRO-FRO-183	2026-02-09 09:54:30.884	\N
cmlezwlrm009i39t5vzh4u7ez	FRONT FENDER / SPAKBOR DEPAN  VARIO TECHNO PUTIH	\N	0	HONDA	95000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	126000.00	HON-FRO-FRO-181	2026-02-09 09:54:30.884	\N
cmlezwlzc009y39t5q2b4mwjv	FRONT FENDER / SPAKBOR DEPAN  VARIO TECHNO 125 ORANGE	\N	0	HONDA	87000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.885	BODY PART	126000.00	HON-FRO-FRO-195	2026-02-09 09:54:30.885	\N
cmlezwmi500ar39t51e6s3xqq	FRONT FENDER / SPAKBOR DEPAN  BEAT FI HITAM	\N	0	HONDA	77000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.885	BODY PART	89000.00	HON-FRO-FRO-137	2026-02-09 09:54:30.885	\N
cmlezwny900c639t55is1clla	FRONT FENDER / SPAKBOR DEPAN  SONIC PUTIH	\N	0	HONDA	63000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	105000.00	HON-FRO-FRO-245	2026-02-09 09:54:35.581	\N
cmlezwo4c00ck39t5uuyaa0c1	FRONT FENDER / SPAKBOR DEPAN  SPACY PUTIH	\N	0	HONDA	90000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	105000.00	HON-FRO-FRO-267	2026-02-09 09:54:35.581	\N
cmlezwoh000de39t5ssnnzmvt	FRONT FENDER / SPAKBOR DEPAN  A SMASH 06 MERAH	\N	0	HONDA	83000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	105000.00	HON-FRO-FRO-275	2026-02-09 09:54:35.582	\N
cmlezwook00dx39t57y66d7rb	FRONT FENDER / SPAKBOR DEPAN  A SMASH 06 HITAM	\N	0	HONDA	71000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	89000.00	HON-FRO-FRO-279	2026-02-09 09:54:35.582	\N
cmlezxe2h01nj39t5ltvievak	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 HITAM DOFF	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.266	BODY PART	257000.00	HON-LEG-LEG-1087	2026-06-19 22:05:54.202	01B5231880AA1
cmlezxdwg01n439t5ihaxtey8	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 BIRU DOFF	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.265	BODY PART	242000.00	HON-LEG-LEG-1083	2026-06-19 22:05:54.569	01B5231595AA1
cmlezxdwc01mw39t53oes732q	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 PUTIH	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.265	BODY PART	242000.00	HON-LEG-LEG-1082	2026-06-19 22:05:54.706	01B5231847AA1
cmlezxe8x01ny39t5ve42nx0l	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 HITAM	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.266	BODY PART	162000.00	HON-LEG-LEG-1093	2026-06-19 22:05:54.843	01B4431840AA1
cmlezxf5f01pk39t59h63cuj6	LEGSHIELD LUAR / SAYAP LUAR SUPRA X 125 14 MERAH	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	231000.00	HON-LEG-LEG-1118	2026-06-19 22:05:54.978	01B4131881AA1
cmlezxejj01ol39t5t6ck6zlk	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 PUTIH	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.266	BODY PART	165000.00	HON-LEG-LEG-1094	2026-06-19 22:05:55.118	01B4431847AA1
cmlezxeeg01oa39t5c3y479xx	LEGSHIELD LUAR / SAYAP LUAR VARIO 110 FI HITAM	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.266	BODY PART	120000.00	HON-LEG-LEG-1097	2026-06-19 22:05:55.248	01B4231840AA1
cmlezxez101p439t5jk794941	LEGSHIELD LUAR / SAYAP LUAR VARIO 110 FI MERAH MAROON	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.245	BODY PART	142000.00	HON-LEG-LEG-1101	2026-06-19 22:05:55.39	01B4231852AA1
cmlezxeis01oi39t5elo1yuba	LEGSHIELD LUAR / SAYAP LUAR VARIO 110 FI PUTIH	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.266	BODY PART	140000.00	HON-LEG-LEG-1100	2026-06-19 22:05:55.525	01B4231847AA1
cmlezxfax01py39t5tghrbswm	LEGSHIELD LUAR / SAYAP LUAR SUPRA X 125 14 FI HITAM	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	214000.00	HON-LEG-LEG-1119	2026-06-19 22:05:55.661	01B4131840AA1
cmlezwoxc00ee39t5pv06ndvs	FRONT FENDER / SPAKBOR DEPAN  GL PRO HITAM	\N	0	HONDA	40000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	89000.00	HON-FRO-FRO-283	2026-02-09 09:54:35.582	\N
cmlezwpbi00ey39t5a7uodrii	FRONT FENDER / SPAKBOR DEPAN  GENIO PUTIH	\N	0	HONDA	150000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	105000.00	HON-FRO-FRO-230	2026-02-09 09:54:35.582	\N
cmlezwqdu00fa39t5xxlgndqi	FRONT FENDER / SPAKBOR DEPAN  XEON MERAH MAROON	\N	0	HONDA	61000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	126000.00	HON-FRO-FRO-290	2026-02-09 09:54:35.582	\N
cmlezwh67002q39t5b0njgs9j	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO HIJAU	\N	0	HONDA	188000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	191000.00	HON-COV-COV-63	2026-02-09 09:54:25.619	\N
cmlezwhdc003239t5gh0on1lo	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO 150 BESAR GRAY	\N	0	HONDA	344000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	347000.00	HON-COV-COV-51	2026-02-09 09:54:25.619	\N
cmlezwhkd003e39t51u4s6fpb	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO 110 FI HITAM DOFF	\N	0	HONDA	218000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	221000.00	HON-COV-COV-52	2026-02-09 09:54:25.619	\N
cmlezwk90006q39t5m62yeep9	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI TIGER SILVER	\N	0	HONDA	153000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.884	BODY PART	156000.00	HON-COV-COV-121	2026-02-09 09:54:30.884	\N
cmlezxjll01ys39t5ng0rcoum	FOOTREST BAWAH SCOOPY FI 17 R+L HITAM	\N	0	HONDA	161000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	232000.00	HON-LEG-FOO-1252	2026-06-19 22:08:01.798	01B4836540AA1
cmlezwme400ai39t5wd31ut2y	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI MEGAPRO 10 HITAM	\N	0	HONDA	86000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.885	BODY PART	89000.00	HON-COV-COV-115	2026-02-09 09:54:30.885	\N
cmlezwsi000io39t51jwrpziq	FRONT FORK COVER / COVER SOK DEPAN SUPRA HITAM	\N	0	HONDA	49000.00	FRONT FORK COVER / COVER SOK DEPAN (HONDA)	2026-02-09 09:54:40.779	BODY PART	52000.00	HON-FRO-FRO-332	2026-02-09 09:54:40.779	\N
cmlezwkhb007839t5bgvrmevy	FRONT FENDER / SPAKBOR DEPAN  BEAT ESP 16 HITAM	\N	0	HONDA	65000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	89000.00	HON-FRO-FRO-130	2026-02-09 09:54:30.884	\N
cmlezwl5c008839t5f00n88cu	FRONT FENDER / SPAKBOR DEPAN  VARIO 110 FI HITAM	\N	0	HONDA	107000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	126000.00	HON-FRO-FRO-173	2026-02-09 09:54:30.884	\N
cmlezwluy009s39t5xut4knj6	FRONT FENDER / SPAKBOR DEPAN  VARIO BIRU MUDA	\N	0	HONDA	79000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.885	BODY PART	126000.00	HON-FRO-FRO-194	2026-02-09 09:54:30.885	\N
cmlezwm3h00a239t5ak4f0ivt	FRONT FENDER / SPAKBOR DEPAN  VARIO TECHNO BIRU	\N	0	HONDA	95000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.885	BODY PART	126000.00	HON-FRO-FRO-193	2026-02-09 09:54:30.885	\N
cmlezwmll00ax39t5rpuyr2zq	FRONT FENDER / SPAKBOR DEPAN  BEAT POP HITAM	\N	0	HONDA	65000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.885	BODY PART	89000.00	HON-FRO-FRO-134	2026-02-09 09:54:30.885	\N
cmlezwnp200bt39t5ajx7wb3t	FRONT FENDER / SPAKBOR DEPAN  CB 150 R NEW HITAM DOFF	\N	0	HONDA	137000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	105000.00	HON-FRO-FRO-236	2026-02-09 09:54:35.581	\N
cmlezwp8a00es39t5m79qusox	FRONT FENDER / SPAKBOR DEPAN  SCOOPY PUTIH	\N	0	HONDA	92000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	105000.00	HON-FRO-FRO-215	2026-02-09 09:54:35.582	\N
cmlezwqi800fo39t5xhfbb9zp	FRONT FENDER / SPAKBOR DEPAN  MEGAPRO 10 MERAH MAROON	\N	0	HONDA	94000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	126000.00	HON-FRO-FRO-296	2026-02-09 09:54:35.582	\N
cmlezwr0g00ga39t5e4d3lat0	FRONT FENDER / SPAKBOR DEPAN  A REVO SILVER CW	\N	0	HONDA	94000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	140000.00	HON-FRO-FRO-252	2026-02-09 09:54:35.582	\N
cmlezwh9w002y39t53et9el16	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO GRAY	\N	0	HONDA	204000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	207000.00	HON-COV-COV-64	2026-02-09 09:54:25.619	\N
cmlezwimj005a39t5yyy0tkd1	COMPLETE SET BODY SUPRA X 125 SILVER	\N	0	HONDA	1171000.00	COMPLETE SET BODY	2026-02-09 09:54:25.62	BODY PART	866000.00	HON-COM-COM-12	2026-06-18 17:22:17.168	\N
cmlezwjtv005n39t5b2blio9p	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI REVO HITAM	\N	0	HONDA	168000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.883	BODY PART	171000.00	HON-COV-COV-109	2026-02-09 09:54:30.883	\N
cmlezwk48006c39t594ih7gao	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI TIGER MERAH	\N	0	HONDA	153000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.884	BODY PART	156000.00	HON-COV-COV-120	2026-02-09 09:54:30.884	\N
cmlezwida004u39t5wv2jivi9	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SUPRA HITAM	\N	0	HONDA	156000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	137000.00	HON-COV-COV-95	2026-02-09 09:54:25.62	\N
cmlezwrrg00h639t5dypshi41	PANEL / TAMENGBEAT ESP 16 MAGENTA	\N	0	HONDA	222000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	225000.00	HON-PAN-PAN-338	2026-02-09 09:54:40.779	\N
cmlezwl5c008a39t5ov2y3ufp	FRONT FENDER / SPAKBOR DEPAN  BEAT POP BIRU	\N	0	HONDA	88000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	89000.00	HON-FRO-FRO-156	2026-02-09 09:54:30.884	\N
cmlezwlez008q39t54vg5zlpu	FRONT FENDER / SPAKBOR DEPAN  BEAT ESP 16 PUTIH	\N	0	HONDA	87000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	89000.00	HON-FRO-FRO-133	2026-02-09 09:54:30.884	\N
cmlezwln7009839t5s9twxf9s	FRONT FENDER / SPAKBOR DEPAN  VARIO PUTIH	\N	0	HONDA	79000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	105000.00	HON-FRO-FRO-185	2026-02-09 09:54:30.884	\N
cmlezwltp009o39t5e50mu28t	FRONT FENDER / SPAKBOR DEPAN  VARIO 110 FI HITAM DOFF	\N	0	HONDA	116000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	126000.00	HON-FRO-FRO-190	2026-02-09 09:54:30.884	\N
cmlezxfzz01ry39t5vzphcryr	LEGSHIELD LUAR / SAYAP LUAR SUPRA X 125 07 HITAM	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	211000.00	HON-LEG-LEG-1122	2026-06-19 22:05:56.183	01B2531840AA1
cmlezxfws01ro39t5u82rzdok	LEGSHIELD LUAR / SAYAP LUAR SUPRA X 125 07 MERAH MAROON	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	243000.00	HON-LEG-LEG-1121	2026-06-19 22:05:56.475	01B2531855AA1
cmlezxe7d01nq39t5hfnpgnbm	LEGSHIELD LUAR / SAYAP LUAR VARIO 160 KECIL	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.266	BODY PART	278000.00	HON-LEG-LEG-1090	2026-06-19 22:05:56.989	01B6438582AA1
cmlezwhuo003t39t5pbveytd0	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO 110 FI HITAM	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	261000.00	HON-COV-COV-53	2026-06-19 22:05:57.304	01B4232740AA1
cmlezwg90000k39t5mvihfssp	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BEAT 24 / BEAT STREET 24 KECIL	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG  KANAN KIRI (HONDA)	2026-02-09 09:54:25.619	BODY PART	87000.00	HON-COV-COV-20	2026-06-19 22:05:57.437	01B7332582AA5
cmlezwm5v00a739t54sksgov3	FRONT FENDER / SPAKBOR DEPAN  VARIO 150 PUTIH	\N	0	HONDA	110000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.885	BODY PART	105000.00	HON-FRO-FRO-172	2026-02-09 09:54:30.885	\N
cmlezwngc00b539t5sh5ihuxe	FRONT FENDER / SPAKBOR DEPAN  SCOOPY FI 17 MERAH	\N	0	HONDA	135000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.58	BODY PART	126000.00	HON-FRO-FRO-206	2026-02-09 09:54:35.58	\N
cmlezwo2z00ci39t5ps7pvweh	FRONT FENDER / SPAKBOR DEPAN  SUPRA FIT HITAM	\N	0	HONDA	75000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	89000.00	HON-FRO-FRO-262	2026-02-09 09:54:35.581	\N
cmlezwoh700dg39t5ia40ic89	FRONT FENDER / SPAKBOR DEPAN  A ABSOLUTE REVO MERAH MAROON	\N	0	HONDA	93000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	130000.00	HON-FRO-FRO-249	2026-02-09 09:54:35.582	\N
cmlezwook00dw39t5cj6uah56	FRONT FENDER / SPAKBOR DEPAN  A SMASH 06 BIRU	\N	0	HONDA	82000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	126000.00	HON-FRO-FRO-278	2026-02-09 09:54:35.582	\N
cmlezwpbh00ew39t50oeewf32	FRONT FENDER / SPAKBOR DEPAN  XEON GT 125 MERAH MAROON	\N	0	HONDA	110000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	126000.00	HON-FRO-FRO-287	2026-02-09 09:54:35.582	\N
cmlezwqhg00fj39t5y1o1g92o	FRONT FENDER / SPAKBOR DEPAN  CS-1 MERAH	\N	0	HONDA	107000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	105000.00	HON-FRO-FRO-295	2026-02-09 09:54:35.582	\N
cmlezwk6j006h39t5sderiqcw	FRONT FENDER / SPAKBOR DEPAN  BEAT MERAH	\N	0	HONDA	71000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	94000.00	HON-FRO-FRO-148	2026-06-18 17:22:17.168	\N
cmlezxjcl01y239t53nfg24d5	FOOTREST BAWAH SCOOPY FI B MERAH	\N	0	HONDA	184000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	232000.00	HON-LEG-FOO-1263	2026-06-19 22:08:02.647	01B4336581AA1
cmlezwi24004839t50zbn71vh	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SUPRA X 125 07 HITAM	\N	0	HONDA	186000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	189000.00	HON-COV-COV-88	2026-02-09 09:54:25.62	\N
cmlezwk4n006e39t5sg3vmyfd	FRONT FENDER / SPAKBOR DEPAN  BEAT HITAM	\N	0	HONDA	59000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	89000.00	HON-FRO-FRO-147	2026-02-09 09:54:30.884	\N
cmlezwifp004y39t5ffc1a8oi	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SUPRA SILVER	\N	0	HONDA	194000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	197000.00	HON-COV-COV-96	2026-02-09 09:54:25.62	\N
cmlezwjtv005i39t57hpzfmxy	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI ABSOLUTE REVO HITAM	\N	0	HONDA	59000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.883	BODY PART	62000.00	HON-COV-COV-101	2026-02-09 09:54:30.883	\N
cmlezwkhb007639t5mdrvcqra	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI ABSOLUTE REVO BESAR SILVER	\N	0	HONDA	186000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.884	BODY PART	189000.00	HON-COV-COV-107	2026-02-09 09:54:30.884	\N
cmlezwmni00b039t5uqfdd0hq	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI CB 150 R PUTIH	\N	0	HONDA	189000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.885	BODY PART	192000.00	HON-COV-COV-114	2026-06-18 17:22:17.168	\N
cmlezwkrz007o39t5chnlaz8n	FRONT FENDER / SPAKBOR DEPAN  VARIO 150 18 / 125 23 MERAH	\N	0	HONDA	142000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	140000.00	HON-FRO-FRO-164	2026-02-09 09:54:30.884	\N
cmlezws1c00hq39t5bpbvmdgd	PANEL / TAMENGBEAT FI ORANGE	\N	0	HONDA	168000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	171000.00	HON-PAN-PAN-351	2026-02-09 09:54:40.779	\N
cmlezwl1z008639t5r340ixzn	FRONT FENDER / SPAKBOR DEPAN  BEAT ESP 16 MERAH	\N	0	HONDA	83000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	89000.00	HON-FRO-FRO-132	2026-02-09 09:54:30.884	\N
cmlezwllh009439t545rxxi8q	FRONT FENDER / SPAKBOR DEPAN  VARIO MERAH MAROON	\N	0	HONDA	79000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	126000.00	HON-FRO-FRO-184	2026-02-09 09:54:30.884	\N
cmlezwm5v00a639t5lvwndt6z	FRONT FENDER / SPAKBOR DEPAN  VARIO TECHNO VIOLET	\N	0	HONDA	95000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.885	BODY PART	130000.00	HON-FRO-FRO-182	2026-02-09 09:54:30.885	\N
cmlezwmfp00al39t57ceo2n7r	FRONT FENDER / SPAKBOR DEPAN  BEAT FI HIJAU	\N	0	HONDA	92000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.885	BODY PART	89000.00	HON-FRO-FRO-139	2026-02-09 09:54:30.885	\N
cmlezwnqi00bx39t5v5uno8w4	FRONT FENDER / SPAKBOR DEPAN  SCOOPY FI BIRU	\N	0	HONDA	125000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	126000.00	HON-FRO-FRO-210	2026-02-09 09:54:35.581	\N
cmlezwoc500d639t55l03bta4	FRONT FENDER / SPAKBOR DEPAN  TIGER REVOLUTION HITAM	\N	0	HONDA	87000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	126000.00	HON-FRO-FRO-272	2026-02-09 09:54:35.582	\N
cmlezwokd00do39t534bmw9mg	FRONT FENDER / SPAKBOR DEPAN  A SMASH BIRU	\N	0	HONDA	78000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	105000.00	HON-FRO-FRO-276	2026-02-09 09:54:35.582	\N
cmlezwozt00ek39t5ljzcw1wa	FRONT FENDER / SPAKBOR DEPAN  GL PRO HITAM + BESI	\N	0	HONDA	98000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	126000.00	HON-FRO-FRO-284	2026-02-09 09:54:35.582	\N
cmlezxgvi01tk39t5votgxwic	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM SCOOPY FI ESP BESAR HITAM	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	121000.00	HON-LEG-LEG-1186	2026-06-19 22:05:57.977	01B4335240AA1
cmlezxfp101r239t5blggupmv	LEGSHIELD DALAM / SAYAP DALAM VARIO	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	78000.00	HON-LEG-LEG-1140	2026-06-19 22:05:58.117	01B2235282AA1
cmlezxfnm01qu39t530ybmskk	LEGSHIELD DALAM / SAYAP DALAM SUPRA / SUPRA X / SUPRA FIT HITAM	\N	0	HONDA	0.00	LEGSHIELD DALAM / SAYAP DALAM REVO FI HITAM	2026-02-09 09:55:11.246	BODY PART	146000.00	HON-LEG-LEG-1153	2026-06-19 22:05:58.634	01B3731740AA1
cmlezwgwd002439t57mkpd33r	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 23 BESAR HITAM	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	305000.00	HON-COV-COV-34	2026-06-19 22:05:59.072	01B6732740AA1
cmlezwh5k002o39t5vn871pvn	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO 150 BESAR HITAM DOFF	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	305000.00	HON-COV-COV-50	2026-06-19 22:05:59.334	01B4432780AA1
cmlezwhfs003839t5lqqmqmzz	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO KECIL	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	54000.00	HON-COV-COV-58	2026-06-19 22:05:59.466	01B2232582AA1
cmlezwir4005e39t5i989asyt	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BEAT FI ESP HITAM	\N	0	HONDA	176000.00	COVER BODY / BODY SAMPING BELAKANG  KANAN KIRI (HONDA)	2026-02-09 09:54:25.62	BODY PART	185000.00	HON-COV-COV-14	2026-06-19 22:05:59.603	01B3832740AA1
cmlezx00y00v639t5hx3g1ir1	FRONT HANDLE COVER / BATOK DEPAN VARIO 110 FI ESP PUTIH	\N	0	HONDA	0.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	138000.00	HON-FRO-FRO-559	2026-06-19 22:05:59.742	01B4930047AA1
cmlezwfzb000439t564tu14n6	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BEAT FI MERAH MAROON	\N	0	HONDA	197000.00	COVER BODY / BODY SAMPING BELAKANG  KANAN KIRI (HONDA)	2026-02-09 09:54:25.619	BODY PART	206000.00	HON-COV-COV-15	2026-06-19 22:05:59.881	01B3832752AA1
cmlezwqhg00fi39t5pmq4oety	FRONT FENDER / SPAKBOR DEPAN  CS-1 HITAM	\N	0	HONDA	95000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	89000.00	HON-FRO-FRO-294	2026-02-09 09:54:35.582	\N
cmlezwh0t002g39t577bqyytl	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO 110 FI MERAH MAROON	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	223000.00	HON-COV-COV-56	2026-02-09 09:54:25.619	01B4232752AA1
cmlezwh1n002i39t5nx028pgr	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 ORANGE	\N	0	HONDA	209000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	212000.00	HON-COV-COV-62	2026-02-09 09:54:25.619	\N
cmlezwik2005439t54cukxel4	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VERZA MERAH MAROON	\N	0	HONDA	218000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	221000.00	HON-COV-COV-98	2026-02-09 09:54:25.62	\N
cmlezwkdk006u39t5yuw11f50	FRONT FENDER / SPAKBOR DEPAN  BEAT POP MERAH	\N	0	HONDA	90000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	111000.00	HON-FRO-FRO-150	2026-06-18 17:22:17.168	\N
cmlezwjtv005k39t52ul0frgl	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI ABSOLUTE REVO FIT KECIL	\N	0	HONDA	33000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.883	BODY PART	36000.00	HON-COV-COV-106	2026-02-09 09:54:30.883	\N
cmlezwg9v000m39t5vr6ywimv	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BEAT HITAM	\N	0	HONDA	154000.00	COVER BODY / BODY SAMPING BELAKANG  KANAN KIRI (HONDA)	2026-02-09 09:54:25.619	BODY PART	161000.00	HON-COV-COV-21	2026-06-18 17:22:17.168	\N
cmlezwhhc003a39t5zalcf0lu	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BEAT POP MERAH MAROON	\N	0	HONDA	133000.00	COVER BODY / BODY SAMPING BELAKANG  KANAN KIRI (HONDA)	2026-02-09 09:54:25.619	BODY PART	186000.00	HON-COV-COV-27	2026-06-18 17:22:17.168	\N
cmlezwgt4002039t538l3b57x	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BEAT PINK	\N	0	HONDA	176000.00	COVER BODY / BODY SAMPING BELAKANG  KANAN KIRI (HONDA)	2026-02-09 09:54:25.619	BODY PART	183000.00	HON-COV-COV-24	2026-06-18 17:22:17.168	\N
cmlezwlez008s39t59fu2t0dr	FRONT FENDER / SPAKBOR DEPAN  A VARIO 160 HITAM	\N	0	HONDA	130000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	158000.00	HON-FRO-FRO-157	2026-06-18 17:22:17.168	\N
cmlezwlzc009u39t5hqy2rwpo	FRONT FENDER / SPAKBOR DEPAN  A VARIO 160 MERAH DOFF	\N	0	HONDA	146000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	158000.00	HON-FRO-FRO-159	2026-06-18 17:22:17.168	\N
cmlezwkhb007939t5g4zibpd9	FRONT FENDER / SPAKBOR DEPAN  A VARIO 160 PUTIH DOFF	\N	0	HONDA	146000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	158000.00	HON-FRO-FRO-160	2026-06-18 17:22:17.168	\N
cmlezwmfp00ak39t5gidkdukl	FRONT FENDER / SPAKBOR DEPAN  SCOOPY 20 KREM	\N	0	HONDA	150000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.885	BODY PART	162000.00	HON-FRO-FRO-198	2026-06-18 17:22:17.168	\N
cmlezwmag00aa39t5pnax8q09	FRONT FENDER / SPAKBOR DEPAN  SCOOPY 20 BIRU DOFF	\N	0	HONDA	150000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.885	BODY PART	162000.00	HON-FRO-FRO-200	2026-06-18 17:22:17.168	\N
cmlezwlhx008w39t5f486sqjl	FRONT FENDER / SPAKBOR DEPAN  VARIO TECHNO HITAM ABU - ABU	\N	0	HONDA	85000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	126000.00	HON-FRO-FRO-179	2026-02-09 09:54:30.884	\N
cmlezwlpk009c39t5av6i2oek	FRONT FENDER / SPAKBOR DEPAN  VARIO 150 BIRU DOFF	\N	0	HONDA	110000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	105000.00	HON-FRO-FRO-189	2026-02-09 09:54:30.884	\N
cmlezwlzc009v39t5hb9d2for	FRONT FENDER / SPAKBOR DEPAN  VARIO TECHNO 125 GRAY	\N	0	HONDA	93000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.885	BODY PART	126000.00	HON-FRO-FRO-192	2026-02-09 09:54:30.885	\N
cmlezwmag00ab39t58jlqdr25	FRONT FENDER / SPAKBOR DEPAN  BEAT POP MERAH MAROON	\N	0	HONDA	88000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.885	BODY PART	105000.00	HON-FRO-FRO-135	2026-02-09 09:54:30.885	\N
cmlezwiku005639t5libj63vc	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI ABSOLUTE REVO BESAR HITAM	\N	0	HONDA	168000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	171000.00	HON-COV-COV-100	2026-02-09 09:54:25.62	\N
cmlezwjtv005s39t54hw4vcno	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI REVO MERAH MAROON + COVER STOP	\N	0	HONDA	214000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.884	BODY PART	217000.00	HON-COV-COV-105	2026-02-09 09:54:30.884	\N
cmlezwk06006039t532g0knpj	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI TIGER KUNING	\N	0	HONDA	153000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.884	BODY PART	156000.00	HON-COV-COV-119	2026-02-09 09:54:30.884	\N
cmlezwhzr004639t5n4ikd0cl	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY FI / ESP MERAH	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	255000.00	HON-COV-COV-76	2026-06-19 22:06:00.211	01B4331881AA1
cmlezwggi001239t593llncje	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BEAT ESP 16 PUTIH	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG  KANAN KIRI (HONDA)	2026-02-09 09:54:25.619	BODY PART	200000.00	HON-COV-COV-30	2026-06-19 22:06:00.352	01B4632747AA1
cmlezwh70002s39t5gi1l6u79	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BEAT PUTIH	\N	0	HONDA	185000.00	COVER BODY / BODY SAMPING BELAKANG  KANAN KIRI (HONDA)	2026-02-09 09:54:25.619	BODY PART	192000.00	HON-COV-COV-26	2026-06-19 22:06:00.623	01B2732747AA1
cmlezwiap004p39t5tc4aharz	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SUPRA / SUPRA X / SUPRA XX / SUPRA FIT + C.STOP	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	182000.00	HON-COV-COV-93	2026-06-19 22:06:00.761	01B1134440AA1
cmlezwmce00ae39t5i40rgb14	FRONT FENDER / SPAKBOR DEPAN  SCOOPY 20 MERAH	\N	0	HONDA	150000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.885	BODY PART	162000.00	HON-FRO-FRO-199	2026-06-19 22:06:00.892	01B6230781AA1
cmlezxejj01ok39t5i4g4t08h	LEGSHIELD LUAR / SAYAP LUAR VARIO 160 BESAR HITAM DOFF	\N	0	HONDA	227000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.266	BODY PART	240000.00	HON-LEG-LEG-1092	2026-06-19 22:06:01.025	01B6431880AA1
cmlezxe7d01nt39t5vsc0k4j1	LEGSHIELD LUAR / SAYAP LUAR VARIO 160 BESAR MERAH DOFF	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.266	BODY PART	240000.00	HON-LEG-LEG-1089	2026-06-19 22:06:01.16	01B6431887AA1
cmlezxez101p339t59hrpxijr	LEGSHIELD LUAR / SAYAP LUAR SCOOPY 20 HITAM	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.245	BODY PART	272000.00	HON-LEG-LEG-1104	2026-06-19 22:06:01.29	01B6231540AA1
cmlezwh3r002m39t52rxnnoxa	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY FI ESP KREM	\N	0	HONDA	237000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	255000.00	HON-COV-COV-66	2026-06-19 22:06:01.426	01B4332783AA1
6dd1b8b3-a97c-4273-ac89-073fb6b4ccf3	COMPLETE SET BODY MIO SILVER	\N	0	YAMAHA	661000.00		2026-06-18 17:44:06.615	BODY PART	661000.00	YAM-COM-14	2026-06-19 22:46:22.074	01D1935042AA1
cmlezwgaa000q39t5gxoxtinf	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BEAT BIRU TUA	\N	0	HONDA	176000.00		2026-02-09 09:54:25.619	BODY PART	183000.00	HON-COV-COV-22	2026-06-23 18:25:34.217	01B2732743AA1
cmlezwk0y006839t5urc5e8dj	FRONT FENDER / SPAKBOR DEPAN  BEAT FI MERAH MAROON	\N	0	HONDA	92000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	105000.00	HON-FRO-FRO-140	2026-02-09 09:54:30.884	\N
cmlezwk0y006439t5n0b2qaic	FRONT FENDER / SPAKBOR DEPAN  BEAT 20 HITAM DOFF	\N	0	HONDA	95000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	100000.00	HON-FRO-FRO-126	2026-06-18 17:22:17.168	\N
cmlezwk0y006539t5g7becqat	FRONT FENDER / SPAKBOR DEPAN  BEAT 20 BIRU DOFF	\N	0	HONDA	86000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	91000.00	HON-FRO-FRO-127	2026-06-18 17:22:17.168	\N
cmlezwkf2007139t5sz4jblix	FRONT FENDER / SPAKBOR DEPAN  BEAT PINK	\N	0	HONDA	75000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	89000.00	HON-FRO-FRO-154	2026-02-09 09:54:30.884	\N
cmlezwkud007q39t5kdx3iuu6	FRONT FENDER / SPAKBOR DEPAN  BEAT ESP 16 BIRU MUDA	\N	0	HONDA	83000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	89000.00	HON-FRO-FRO-131	2026-02-09 09:54:30.884	\N
cmlezwlhx008y39t5rogglibc	FRONT FENDER / SPAKBOR DEPAN  VARIO TECHNO MERAH MAROON	\N	0	HONDA	95000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	130000.00	HON-FRO-FRO-180	2026-02-09 09:54:30.884	\N
cmlezwlqn009e39t5b11mym4q	FRONT FENDER / SPAKBOR DEPAN  VARIO 150 18 / 125 23 GRAY	\N	0	HONDA	142000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	126000.00	HON-FRO-FRO-186	2026-02-09 09:54:30.884	\N
cmlezwk89006o39t5cd34lfe1	FRONT FENDER / SPAKBOR DEPAN  BEAT 20 PUTIH	\N	0	HONDA	95000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	100000.00	HON-FRO-FRO-129	2026-06-18 17:22:17.168	\N
cmlezwozu00em39t5xvm1nzs3	FRONT FENDER / SPAKBOR DEPAN  XEON GT 125 HITAM	\N	0	HONDA	90000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	89000.00	HON-FRO-FRO-285	2026-02-09 09:54:35.582	\N
cmlezwq1300f839t5zqzwu7aa	FRONT FENDER / SPAKBOR DEPAN  SPACY HITAM	\N	0	HONDA	71000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	89000.00	HON-FRO-FRO-266	2026-02-09 09:54:35.582	\N
cmlezwr3b00gk39t5b9vp25tz	FRONT FENDER / SPAKBOR DEPAN  ADV 150 HITAM	\N	0	HONDA	113000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.583	BODY PART	123000.00	HON-FRO-FRO-231	2026-06-18 17:22:17.168	\N
cmlezwt7w00jb39t5be5s7hu3	PANEL / TAMENGBEAT ORANGE	\N	0	HONDA	154000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	157000.00	HON-PAN-PAN-366	2026-02-09 09:54:40.779	\N
cmlezwr1100ge39t5ptikjwhw	FRONT FENDER / SPAKBOR DEPAN  ADV 150 MERAH	\N	0	HONDA	130000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.583	BODY PART	141000.00	HON-FRO-FRO-232	2026-06-18 17:22:17.168	\N
cmlezwnp200bo39t5hy0v3ntq	FRONT FENDER / SPAKBOR DEPAN  ADV 150 PUTIH	\N	0	HONDA	130000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	141000.00	HON-FRO-FRO-233	2026-06-18 17:22:17.168	\N
cmlezwr0g00gb39t5optkopgl	FRONT FENDER / SPAKBOR DEPAN  PCX 150 18 PUTIH	\N	0	HONDA	178000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	192000.00	HON-FRO-FRO-224	2026-06-18 17:22:17.168	\N
cmlezwowf00ea39t5kelseg2p	FRONT FENDER / SPAKBOR DEPAN  CB 150 R HITAM	\N	0	HONDA	126000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	148000.00	HON-FRO-FRO-240	2026-06-18 17:22:17.168	\N
cmlezwol200dq39t5znwk4tpf	FRONT FENDER / SPAKBOR DEPAN  SUPRA X HITAM	\N	0	HONDA	82000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	82000.00	HON-FRO-FRO-264	2026-06-18 17:22:17.168	\N
cmlezwkf2007039t5wbj5tp6k	FRONT FENDER / SPAKBOR DEPAN  BEAT 10 HITAM	\N	0	HONDA	68000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	74000.00	HON-FRO-FRO-142	2026-06-18 17:22:17.168	\N
cmlezwk90006r39t57m450bh8	FRONT FENDER / SPAKBOR DEPAN  BEAT PUTIH	\N	0	HONDA	71000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	94000.00	HON-FRO-FRO-149	2026-06-18 17:22:17.168	\N
cmlezx0kq00wg39t54oa3fpas	FRONT HANDLE COVER / BATOK DEPAN SUPRA X 125 MERAH MAROON CAKRAM	\N	0	HONDA	94000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	90000.00	HON-FRO-FRO-588	2026-06-18 17:22:17.168	\N
cmlezx2ao00zz39t51juv3vr0	COVER STOP / RR STOP VARIO 160 MERAH DOFF	\N	0	HONDA	84000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	84000.00	HON-COV-COV-664	2026-06-18 17:22:17.168	\N
cmlezwqju00fq39t5e64nb7q4	FRONT FENDER / SPAKBOR DEPAN  A REVO MERAH MAROON	\N	0	HONDA	94000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	140000.00	HON-FRO-FRO-251	2026-02-09 09:54:35.582	\N
cmlezx2b1010239t5v5dej6ys	COVER STOP / RR STOP SCOOPY 20 BESAR HITAM	\N	0	HONDA	115000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	115000.00	HON-COV-COV-672	2026-06-18 17:22:17.168	\N
cmlezws2q00hu39t5hd82bv4v	PANEL / TAMENGBEAT FI PUTIH	\N	0	HONDA	168000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	342000.00	HON-PAN-PAN-352	2026-02-09 09:54:40.779	\N
cmlezx2gn010k39t5a4oxggxt	COVER STOP / RR STOP SCOOPY 20 BESAR GRAY DOFF	\N	0	HONDA	138000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	138000.00	HON-COV-COV-674	2026-06-18 17:22:17.168	\N
cmlezx2kf010w39t5dv3rryys	COVER STOP / RR STOP SCOOPY 20 BESAR MERAH DOFF	\N	0	HONDA	138000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	138000.00	HON-COV-COV-675	2026-06-18 17:22:17.168	\N
cmlezwlnj009a39t5604kp2fw	FRONT FENDER / SPAKBOR DEPAN  BEAT 20 HITAM	\N	0	HONDA	78000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	83000.00	HON-FRO-FRO-125	2026-06-19 22:06:01.754	01B5930780AA1
cmlezwk0y006939t58ept7j0z	FRONT FENDER / SPAKBOR DEPAN  BEAT 20 HIJAU DOFF	\N	0	HONDA	86000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	91000.00	HON-FRO-FRO-128	2026-06-19 22:06:01.893	01B5930790AA1
cmlezxdwj01n639t5ic8afsos	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 MERAH	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.265	BODY PART	240000.00	HON-LEG-LEG-1084	2026-06-19 22:06:02.027	01B5231881AA1
cmlezwwdb00nq39t5xv4fap4p	PANEL / TAMENGSCOOPY 20 PUTIH DOFF	\N	0	HONDA	292000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	313000.00	HON-PAN-PAN-437	2026-06-19 22:06:02.765	01B6230593AA1
cmlezwsbq00id39t5wax4qf3a	PANEL / TAMENGBEAT 24 / BEAT STREET 24 HITAM DOFF	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	264000.00	HON-PAN-PAN-357	2026-06-19 22:06:02.905	01B7330580AA3
cmlezwwe400nu39t5o7s4hd1i	PANEL / TAMENGGENIO PUTIH	\N	0	HONDA	342000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	366000.00	HON-PAN-PAN-459	2026-06-19 22:06:03.258	01B5730547AA1
cmlezx02400va39t5vwjekqut	FRONT HANDLE COVER / BATOK DEPAN B SCOOPY FI HITAM	\N	0	HONDA	75000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	82000.00	HON-FRO-FRO-564	2026-06-19 22:06:04.218	01B4330340AA1
cmlezx02z00vc39t5y5setr5y	FRONT HANDLE COVER / BATOK DEPAN B SCOOPY FI MERAH	\N	0	HONDA	87000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	95000.00	HON-FRO-FRO-566	2026-06-19 22:06:04.494	01B4330340AA1
cmlezx1ez00y039t552sr4up5	REAR HANDLE / BATOK BELAKANG COVER VARIO	\N	0	HONDA	29000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	37000.00	HON-REA-REA-623	2026-06-19 22:06:04.801	01B2230182AA1
cmlezx0av00w239t5xdatjof9	FRONT HANDLE COVER / BATOK DEPAN A SCOOPY 20 KREM	\N	0	HONDA	104000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	114000.00	HON-FRO-FRO-573	2026-06-18 17:27:37.767	\N
cmlezx2rt011g39t51cgzwcoi	COVER STOP / RR STOP SCOOPY 20 KECIL PUTIH DOFF	\N	0	HONDA	79000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	79000.00	HON-COV-COV-688	2026-06-18 17:22:17.168	\N
cmlezwoqp00e039t5rq1hpw9y	FRONT FENDER / SPAKBOR DEPAN  A SMASH HITAM	\N	0	HONDA	67000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	89000.00	HON-FRO-FRO-280	2026-02-09 09:54:35.582	\N
cmlezxi4z01v839t5xrvhxj6c	FOOTREST ATAS + TUTUP AKI VARIO 110 FI ESP	\N	0	HONDA	99000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	108000.00	HON-LEG-FOO-1217	2026-06-18 17:22:17.168	01B4534382AA1
cmlezxik101w839t538woitz5	FOOTREST ATAS/PINJAKAN KAKI + TUTUP AKI	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	136000.00	HON-LEG-FOO-1208	2026-06-18 17:22:17.168	\N
cmlezxi5o01vg39t5pkc9s5sv	FOOTREST BAWAH VARIO 160 B R+L REAR	\N	0	HONDA	56000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	63000.00	HON-LEG-FOO-1243	2026-06-18 17:22:17.168	\N
cmlezxjwv01zg39t5dyste3vt	FOOTREST BAWAH SCOOPY 20 B R+L BIRU DOFF	\N	0	HONDA	215000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	240000.00	HON-LEG-FOO-1268	2026-06-18 17:22:17.168	\N
cmlezxjwv01zk39t5vajqbim3	FOOTREST BAWAH SCOOPY 20 B R+L HIJAU DOFF	\N	0	HONDA	215000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	240000.00	HON-LEG-FOO-1269	2026-06-18 17:22:17.168	\N
cmlezxidz01vq39t5h6sxd3d5	FOOTREST BAWAH VARIO 150 18 B R+L HITAM DOFF	\N	0	HONDA	292000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	313000.00	HON-LEG-FOO-1248	2026-06-18 17:22:17.168	\N
cmlezxj3k01xk39t584pwwuka	FOOTREST BAWAH VARIO 150 18 B R+L GRAY DOFF	\N	0	HONDA	292000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	313000.00	HON-LEG-FOO-1250	2026-06-18 17:22:17.168	\N
cmlezxiqn01wo39t5816ldbxs	FOOTREST BAWAH BEAT POP POP B R+L (UNDERSIDE)	\N	0	HONDA	78000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	88000.00	HON-LEG-FOO-1234	2026-06-18 17:22:17.168	01B4036582AA10
cmlezwozt00ei39t5sjb6df5w	FRONT FENDER / SPAKBOR DEPAN  A SUPRA X 125 MERAH	\N	0	HONDA	81000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	105000.00	HON-FRO-FRO-265	2026-02-09 09:54:35.582	\N
cmlezwpig00f039t53gwvpabf	FRONT FENDER / SPAKBOR DEPAN  XEON GT 125 PUTIH	\N	0	HONDA	99000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	105000.00	HON-FRO-FRO-288	2026-02-09 09:54:35.582	\N
cmlezwqfe00fc39t5eacael02	FRONT FENDER / SPAKBOR DEPAN  XEON BIRU MUDA	\N	0	HONDA	62000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	126000.00	HON-FRO-FRO-292	2026-02-09 09:54:35.582	\N
cmlezwqqr00fw39t5rw9vw90z	FRONT FENDER / SPAKBOR DEPAN  MEGAPRO 06 BIRU TUA	\N	0	HONDA	88000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	126000.00	HON-FRO-FRO-300	2026-02-09 09:54:35.582	\N
cmlezwrgp00gu39t5krjjl0jp	FRONT FENDER / SPAKBOR DEPAN  A KARISMA SILVER	\N	0	HONDA	64000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:40.777	BODY PART	126000.00	HON-FRO-FRO-303	2026-02-09 09:54:40.777	\N
cmlezwrpf00h439t540hof27d	PANEL / TAMENGBEAT ESP 16 HITAM	\N	0	HONDA	177000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	324000.00	HON-PAN-PAN-339	2026-02-09 09:54:40.779	\N
cmlezx5pw016639t5w567kt7b	LAMPU DEPAN / HEAD LAMP LEGENDA 2	\N	0	HONDA	59000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	66000.00	HON-LAM-LAM-781	2026-06-18 17:27:37.767	\N
cmlezx5um016c39t5c5j8gqqk	LAMPU DEPAN / HEAD LAMP SONIC + LED	\N	0	HONDA	356000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	395000.00	HON-LAM-LAM-782	2026-06-18 17:27:37.767	\N
cmlezx02z00vd39t536tut3qf	FRONT HANDLE COVER / BATOK DEPAN A SCOOPY FI 17 + ACC HITAM	\N	0	HONDA	150000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-568	2026-02-09 09:54:50.207	\N
cmlezx58u015c39t54hwd0cst	LAMPU DEPAN / HEAD LAMP UNIT TIGER HITAM	\N	0	HONDA	84000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	96000.00	HON-LAM-LAM-772	2026-06-18 17:27:37.767	\N
cmlezwsgm00ii39t52lzoq3f9	PANEL / TAMENGBEAT PINK	\N	0	HONDA	142000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	145000.00	HON-PAN-PAN-359	2026-02-09 09:54:40.779	\N
cmlezwt7w00ja39t5s192bkwv	PANEL / TAMENGBEAT BIRU MUDA	\N	0	HONDA	154000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	157000.00	HON-PAN-PAN-365	2026-02-09 09:54:40.779	\N
cmlezx0bg00w439t5yfl2bz1s	FRONT HANDLE COVER / BATOK DEPAN REVO SILVER CW	\N	0	HONDA	79000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-583	2026-02-09 09:54:50.207	\N
cmlezws4x00i039t5r2zbt414	PANEL / TAMENGBEAT ESP 16 MERAH	\N	0	HONDA	209000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	342000.00	HON-PAN-PAN-341	2026-02-09 09:54:40.779	\N
cmlezwnp200bp39t5k5w8nnoo	FRONT FENDER / SPAKBOR DEPAN  CB 150 R VERZA HITAM	\N	0	HONDA	136000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	89000.00	HON-FRO-FRO-234	2026-06-18 17:19:42.083	\N
cmlezxe1501n839t5dcsgcplk	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 125 MERAH MAROON	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.265	BODY PART	170000.00	HON-LEG-LEG-1080	2026-06-19 22:06:05.784	01B4431852AA1
cmlezx1xa00z239t5hj0e0b9u	COVER STOP / RR STOP VARIO TECHNO 125 HITAM	\N	0	HONDA	0.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	43000.00	HON-COV-COV-655	2026-06-19 22:06:05.926	01B3633140AA1
cmlezx88k01ac39t51xhn1otv	MIKA SEN Rr / MIKA SEN BELAKANG + STOP BEAT ESP 16 / BEAT STREET 16	\N	0	HONDA	0.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.489	LAIN-LAIN	24000.00	HON-MIK-MIK-870	2026-06-19 22:06:06.061	01B4604220AA2
cmlezx2bv010a39t5yaw4r1js	COVER STOP / RR STOP SCOOPY ESP HITAM	\N	0	HONDA	78000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	89000.00	HON-COV-COV-677	2026-06-19 22:06:06.197	01B4333140AA1
cmlezx2r0011c39t5h4nqyvtl	COVER STOP / RR STOP SCOOPY ESP MERAH	\N	0	HONDA	85000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	97000.00	HON-COV-COV-676	2026-06-19 22:06:06.332	01B4333181AA1
cmlezx49p013q39t5gbvwus8i	COVER TANGKI / COVER MESIN BEAT / 10	\N	0	HONDA	49000.00	COVER TANGKI / COVER MESIN (HONDA)	2026-02-09 09:54:56.889	BODY PART	47000.00	HON-COV-COV-704	2026-06-19 22:06:06.928	01B2736682AA1
cmlezxiko01wg39t5q6uw4fne	FOOTREST BAWAH BEAT 24 / BEAT STREET 24	\N	0	HONDA	70000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	87000.00	HON-LEG-FOO-1228	2026-06-19 22:06:07.092	01B7334982AA1
cmlezxiey01vy39t5t3fjnjjh	FOOTREST BAWAH BEAT / BEAT 10	\N	0	HONDA	87000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	42000.00	HON-LEG-FOO-1233	2026-06-19 22:06:07.221	01B2734982AA1
9f6b8b65-bcfa-496d-9c69-bc42af8bdc09	GARNIS VARIO 125 / 23	\N	0	HONDA	0.00	GARNIS	2026-06-18 17:11:12.592	BODY PART	54000.00	HON-GAR-1465	2026-06-19 22:06:07.352	01B6738382AA10
cmlezx5k9015w39t5fafj9oiw	LAMPU DEPAN / HEAD LAMP SCOOPY	\N	0	HONDA	148000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	693000.00	HON-LAM-LAM-747	2026-06-19 22:06:07.493	01B3100200AA1
cmlezwvmw00m739t598g468vx	PANEL / TAMENGVARIO TECHNO 125 BESAR PUTIH	\N	0	HONDA	194000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.184	LAIN-LAIN	187000.00	HON-PAN-PAN-402	2026-02-09 09:54:46.184	\N
cmlezx58u015d39t5gpmay5xh	LAMPU DEPAN / HEAD LAMP UNIT TIGER CHROOM	\N	0	HONDA	120000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	135000.00	HON-LAM-LAM-773	2026-06-18 17:27:37.767	\N
cmlezwzt100um39t5dc7ixo3y	FRONT HANDLE COVER / BATOK DEPAN VARIO 110 FI HITAM	\N	0	HONDA	108000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	138000.00	HON-FRO-FRO-552	2026-06-18 17:22:17.168	\N
cmlezww7h00nl39t5xyicdl83	PANEL / TAMENGDEPAN BAGIAN BAWAH VARIO TECHNO 125	\N	0	HONDA	80000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	71000.00	HON-PAN-PAN-430	2026-02-09 09:54:46.185	\N
cmlezwwkj00o339t5p3cxpk5f	PANEL / TAMENGSCOOPY PINK	\N	0	HONDA	216000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	251000.00	HON-PAN-PAN-454	2026-02-09 09:54:46.185	\N
cmlezwydx00rm39t50a93wt9m	FRONT HANDLE COVER / BATOK DEPAN BEAT 20 BIRU	\N	0	HONDA	120000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:46.185	BODY PART	119000.00	HON-FRO-FRO-500	2026-02-09 09:54:46.185	\N
cmlezx5yf016g39t5hat84vu1	LAMPU DEPAN / HEAD LAMP PRIMA	\N	0	HONDA	60000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	67000.00	HON-LAM-LAM-783	2026-06-18 17:27:37.767	\N
cmlezwzkh00u239t5n2n0xccx	FRONT HANDLE COVER / BATOK DEPAN VARIO 150 HITAM	\N	0	HONDA	167000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-543	2026-02-09 09:54:50.207	\N
cmlezx0ab00vw39t5w4n0u4p4	FRONT HANDLE COVER / BATOK DEPAN GENIO A+B MERAH	\N	0	HONDA	75000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-578	2026-02-09 09:54:50.207	\N
cmlezx5dq015k39t5i7qsba7p	LAMPU DEPAN / HEAD LAMP GRAND DE	\N	0	HONDA	74000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	85000.00	HON-LAM-LAM-774	2026-06-18 17:27:37.767	\N
cmlezx0j200we39t5vjz7he4l	FRONT HANDLE COVER / BATOK DEPAN SUPRA X 125 07 MERAH MAROON	\N	0	HONDA	118000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	132000.00	HON-FRO-FRO-587	2026-02-09 09:54:50.207	\N
cmlezx1ed00xw39t5gx6ef69f	REAR HANDLE / BATOK BELAKANG COVER SUPRA X 125	\N	0	HONDA	49000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	170000.00	HON-REA-REA-628	2026-06-18 17:22:17.168	\N
cmlezx0qd00wq39t5wfv4ojm0	FRONT HANDLE COVER / BATOK DEPAN SUPRA FIT NEW HITAM TROMOL	\N	0	HONDA	61000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-594	2026-02-09 09:54:50.207	\N
cmlezx0xb00x839t50f03ak1o	FRONT HANDLE COVER / BATOK DEPAN SUPRA X 125 07 HITAM	\N	0	HONDA	90000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-590	2026-02-09 09:54:50.207	\N
cmlezx7g0018e39t5welowlfq	MIKA LAMPU PCX 160	\N	0	HONDA	341000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	379000.00	HON-MIK-MIK-801	2026-06-18 17:27:37.767	\N
cmlezx1k900y439t5azfq0zpe	REAR HANDLE / BATOK BELAKANG COVER SUPRA FIT	\N	0	HONDA	38000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	48000.00	HON-REA-REA-630	2026-02-09 09:54:53.444	\N
cmlezx1re00yj39t5v16bbviy	REAR HANDLE / BATOK BELAKANG COVER SUPRA X	\N	0	HONDA	42000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	31000.00	HON-REA-REA-631	2026-02-09 09:54:53.444	\N
cmlezx9hm01dm39t50acjqpie	MIKA LAMPU CB 150 R NEW	\N	0	HONDA	104000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	136000.00	HON-MIK-MIK-815	2026-06-18 17:22:17.168	\N
cmlezx6kd017d39t53q6gh4xv	MIKA LAMPU VARIO TECHNO	\N	0	HONDA	63000.00	MIKA LAMPU (HONDA)	2026-02-09 09:54:56.89	KELISTRIKAN	70000.00	HON-MIK-MIK-792	2026-06-18 17:27:37.767	\N
cmlezwrsq00he39t5wyoyhuyz	PANEL / TAMENGBEAT FI HIJAU	\N	0	HONDA	178000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	324000.00	HON-PAN-PAN-349	2026-02-09 09:54:40.779	\N
cmlezwttw00jq39t51kc9eeax	PANEL / TAMENGDEPAN BAGIAN BAWAH BEAT	\N	0	HONDA	57000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	38000.00	HON-PAN-PAN-370	2026-02-09 09:54:40.779	\N
cmlezwu7h00k839t5agdarmey	REAR FENDER / SPAKBOR BELAKANG BLADE 11	\N	0	HONDA	54000.00	REAR FENDER / (KOLONG) VARIO TECHNO 125	2026-02-09 09:54:40.779	LAIN-LAIN	88000.00	HON-REA-REA-325	2026-02-09 09:54:40.779	\N
cmlezwvw700mp39t53hs7k61c	PANEL / TAMENGVARIO TECHNO GRAY	\N	0	HONDA	184000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	70000.00	HON-PAN-PAN-427	2026-02-09 09:54:46.185	\N
cmlezx8vq01c639t50l6503w5	MIKA SPEEDOMETER REVO FI	\N	0	HONDA	26000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	31000.00	HON-MIK-MIK-852	2026-06-18 17:27:37.767	\N
cmlezwwld00o639t5ho8mfwf4	PANEL / TAMENGREVO MERAH MAROON	\N	0	HONDA	116000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	342000.00	HON-PAN-PAN-467	2026-02-09 09:54:46.185	\N
cmlezwwxl00om39t52hdon6ys	PANEL / TAMENGSUPRA X HITAM	\N	0	HONDA	44000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	324000.00	HON-PAN-PAN-474	2026-02-09 09:54:46.185	\N
cmlezwxpx00qa39t5iz5tpoqu	PANEL / TAMENGVARIO KECIL HITAM / DASI	\N	0	HONDA	59000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	125000.00	HON-PAN-PAN-414	2026-02-09 09:54:46.185	\N
cmlezwyb800rg39t5xmc20yz1	PANEL / TAMENGVARIO KECIL PUTIH / DASI	\N	0	HONDA	75000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	58000.00	HON-PAN-PAN-418	2026-02-09 09:54:46.185	\N
cmlezwzkh00u439t56t8xw8jn	FRONT HANDLE COVER / BATOK DEPAN VARIO 150 MERAH MAROON	\N	0	HONDA	181000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-544	2026-02-09 09:54:50.207	\N
cmlezwzt700uo39t55dfwlqkx	FRONT HANDLE COVER / BATOK DEPAN VARIO 150 18 + ACC SILVER	\N	0	HONDA	178000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-554	2026-02-09 09:54:50.207	\N
cmlezx5gm015o39t5d6pfjo5k	LAMPU DEPAN / HEAD LAMP GRAND	\N	0	HONDA	49000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	55000.00	HON-LAM-LAM-775	2026-06-19 22:06:07.77	01B0800200AA1
cmlezx7uo019n39t5wlb278uz	MIKA SPEEDOMETER SCOOPY FI 17	\N	0	HONDA	24000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	29000.00	HON-MIK-MIK-848	2026-06-19 22:06:07.909	01B4801700AA6
cmlezx7na019639t5rre08nel	MIKA SPEEDOMETER BEAT ESP 16	\N	0	HONDA	27000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	32000.00	HON-MIK-MIK-836	2026-06-19 22:06:08.042	01B4601700AA8
cmlezxfhz01qh39t5qdsyknv9	LEGSHIELD DALAM / SAYAP DALAM BEAT ESP 16 / BEAT STREET 16 BESAR	\N	0	HONDA	62000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	64000.00	HON-LEG-LEG-1134	2026-06-19 22:06:08.215	01B4635282AA1
cmlezx91n01cj39t59cq5ug2n	MIKA SPEEDOMETER SUPRA X 125 14	\N	0	HONDA	27000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	32000.00	HON-MIK-MIK-853	2026-06-19 22:06:08.932	01B4101700AA8
cmlezxfyu01rs39t5hmqcj38z	LEGSHIELD DALAM / SAYAP DALAM VARIO 125 23 KECIL HITAM	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	102000.00	HON-LEG-LEG-1141	2026-06-19 22:06:10.712	01B6736740AA1
cmlezxfco01q439t5vm4gactp	LEGSHIELD DALAM / SAYAP DALAM VARIO 125 23 KECIL HITAM DOFF	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	102000.00	HON-LEG-LEG-1139	2026-06-19 22:06:11.072	01B6736780AA1
cmlezwt1y00j639t5vdsmkuwx	PANEL / TAMENGBEAT POP MERAH	\N	0	HONDA	176000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	273000.00	HON-PAN-PAN-364	2026-02-09 09:54:40.779	\N
cmlezwtt400jn39t5z99s8uol	PANEL / TAMENGDEPAN BAGIAN BAWAH BEAT POP	\N	0	HONDA	63000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	63000.00	HON-PAN-PAN-368	2026-02-09 09:54:40.779	\N
cmlezwv4300m239t5plw35sxf	PANEL / TAMENGVARIO TECHNO 125 BESAR GRAY	\N	0	HONDA	191000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	187000.00	HON-PAN-PAN-399	2026-02-09 09:54:40.78	\N
cmlezx8i001b239t5vc25o1io	MIKA SPEEDOMETER VARIO TECHNO 125	\N	0	HONDA	31000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	36000.00	HON-MIK-MIK-840	2026-06-18 17:27:37.767	\N
cmlezwjtv005v39t56oi6wlul	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI CB 150 R HITAM	\N	0	HONDA	169000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.884	BODY PART	178000.00	HON-COV-COV-112	2026-06-18 17:22:17.168	\N
cmlezx9lz01dt39t51cjiy2tm	MIKA SPEEDOMETER BEAT 20	\N	0	HONDA	36000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	31000.00	HON-MIK-MIK-835	2026-06-18 17:22:17.168	\N
cmlezxa1a01eb39t54cl83lfr	MIKA SEN Fr / MIKA SEN DEPAN  SUPRA X 125 HELM IN	\N	0	HONDA	41000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	47000.00	HON-MIK-MIK-905	2026-06-18 17:22:17.168	\N
cmlezxbca01gu39t5r743by17	FRONT WINKER / SEN DEPAN UNIT BEAT POP	\N	0	HONDA	75000.00	FRONT WINKER / SEN DEPAN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	92000.00	HON-FRO-FRO-966	2026-06-18 17:22:17.168	\N
cmlezxc7m01j439t5ob54zq8c	Fr / Rr WINKER ASSY CB 150 R NEW VARIASI	\N	0	HONDA	86000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	98000.00	HON-FRO-FRR-995	2026-06-18 17:22:17.168	\N
cmlezwvw700mo39t5e29r2igb	PANEL / TAMENGVARIO TECHNO HIJAU	\N	0	HONDA	191000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	70000.00	HON-PAN-PAN-426	2026-02-09 09:54:46.185	\N
cmlezwhm9003n39t5mo7l1uik	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO 160 A KECIL	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	48000.00	HON-COV-COV-59	2026-06-18 17:19:42.083	01B6432582AA7
cmlezwxbl00pg39t5dycfmrht	PANEL / TAMENGSMASH HITAM	\N	0	HONDA	40000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	324000.00	HON-PAN-PAN-481	2026-02-09 09:54:46.185	\N
cmlezwxid00pu39t5mfjl5tol	PANEL / TAMENGREVO HITAM	\N	0	HONDA	101000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	251000.00	HON-PAN-PAN-466	2026-02-09 09:54:46.185	\N
cmlezxehx01og39t5zce40e13	COB LAMPU / FITTING LAMPU VARIO	\N	0	HONDA	14000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.266	KELISTRIKAN	16000.00	HON-STO-COB-1052	2026-06-18 17:27:37.767	\N
cmlezwxvm00qo39t551mv6jnc	PANEL / TAMENGVARIO KECIL MERAH MAROON / DASI	\N	0	HONDA	75000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	58000.00	HON-PAN-PAN-415	2026-02-09 09:54:46.185	\N
cmlezwsb400i839t5708zqghd	FRONT FORK COVER / COVER SOK DEPAN SUPRA X HITAM	\N	0	HONDA	51000.00	FRONT FORK COVER / COVER SOK DEPAN (HONDA)	2026-02-09 09:54:40.779	BODY PART	54000.00	HON-FRO-FRO-331	2026-02-09 09:54:40.779	\N
cmlezxouc028639t5w9d641lq	PEDAL REM SUPRA	\N	0	HONDA	31000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	41000.00	HON-TUT-PED-1449	2026-06-18 17:22:17.168	\N
cmlezxp6l029039t5iuql3tdw	PEDAL REM SUPRA FIT NEW	\N	0	HONDA	40000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	41000.00	HON-TUT-PED-1448	2026-06-18 17:22:17.168	\N
cmlezxirb01ww39t58moqib1e	FOOTREST BAWAH SCOOPY 20 B R+L PUTIH DOFF	\N	0	HONDA	232000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	240000.00	HON-LEG-FOO-1270	2026-06-18 17:27:37.767	\N
cmlezxn3x025239t52ik1vzc4	PIPA GAS PCX 150 18	\N	0	HONDA	9000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	7300.00	HON-TUT-PIP-1396	2026-06-18 17:27:37.767	\N
cmlezwtt400jm39t577fbd9al	PANEL / TAMENGDEPAN BAGIAN BAWAH BEAT ESP 16/PARU	\N	0	HONDA	66000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	66000.00	HON-PAN-PAN-367	2026-02-09 09:54:40.779	\N
cmlezxfc601q239t5l5p7a47w	LEGSHIELD LUAR / SAYAP LUAR PCX 150 18 GRAY DOFF	\N	0	HONDA	464000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	491000.00	HON-LEG-LEG-1114	2026-06-18 17:22:17.168	\N
cmlezwgob001m39t56hxaqkoo	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO 150 18 BESAR HITAM	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	280000.00	HON-COV-COV-47	2026-06-19 22:06:11.452	01B5232740AA1
cmlezwgzf002d39t5a823y9nq	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BEAT 20 BESAR PUTIH	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG  KANAN KIRI (HONDA)	2026-02-09 09:54:25.619	BODY PART	247000.00	HON-COV-COV-25	2026-06-19 22:06:12.079	01B5932747AA1
cmlezwg8n000i39t57dkmp541	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BEAT 24 / BEAT STREET 24 BESAR HITAM DOFF	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG  KANAN KIRI (HONDA)	2026-02-09 09:54:25.619	BODY PART	247000.00	HON-COV-COV-19	2026-06-19 22:06:12.212	01B7332780AA1
cmlezx7un019m39t5ru6mojnu	MIKA SPEEDOMETER SCOOPY FI	\N	0	HONDA	22000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	30000.00	HON-MIK-MIK-847	2026-06-19 22:06:12.341	01B4301700AA5
cmlezx8jl01b639t5iomtkbhr	MIKA SEN Rr / MIKA SEN BELAKANG + STOP VARIO 150 125 (P/M)	\N	0	HONDA	79000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	87000.00	HON-MIK-MIK-878	2026-06-19 22:06:12.475	01B4404320AA3
cmlezwh8g002w39t5s8fh01wv	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY FI ESP MERAH	\N	0	HONDA	237000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	237000.00	HON-COV-COV-67	2026-06-19 22:06:12.613	01B4332781AA1
cmlezwsgm00ij39t5d9d6pc4p	PANEL / TAMENGBEAT ESP 16 PUTIH	\N	0	HONDA	209000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	212000.00	HON-PAN-PAN-342	2026-06-19 22:06:12.976	01B4630547AA4
cmlezwhed003439t58qkifkeg	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY FI ESP MERAH MAROON	\N	0	HONDA	237000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	255000.00	HON-COV-COV-68	2026-06-19 22:06:13.113	01B4332752AA1
cmlezwhhc003c39t5y0d82ael	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY FI ESP PUTIH	\N	0	HONDA	237000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	255000.00	HON-COV-COV-69	2026-06-19 22:06:13.245	01B4332747AA1
cmlezxez101pc39t5pdbuk2z4	LEGSHIELD LUAR / SAYAP LUAR SCOOPY FI 17 PUTIH	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.245	BODY PART	262000.00	HON-LEG-LEG-1110	2026-06-19 22:06:13.38	01B4831847AA1
cmlezxfoe01r039t5xlbilvig	LEGSHIELD LUAR / SAYAP LUAR SCOOPY FI 17 MERAH DOFF	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	262000.00	HON-LEG-LEG-1107	2026-06-19 22:06:13.514	01B4831887AA1
cmlezxjyx01zs39t5ok76pdcn	STANDARD SAMPING PCX 150 18	\N	0	HONDA	37000.00	STANDARD TENGAH PCX 150 18	2026-02-09 09:55:15.055	KAKI-KAKI	39000.00	HON-STA-STA-1287	2026-06-19 22:06:13.649	01B5499997AA1
cmlezxezn01pi39t5yswgncym	LEGSHIELD LUAR / SAYAP LUAR SCOOPY 20 PUTIH DOFF	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.245	BODY PART	253000.00	HON-LEG-LEG-1105	2026-06-19 22:06:13.782	01B6231593AA1
cmlezxdbi01le39t5tymznz39	COB LAMPU / FITTING LAMPU SUPRA X 125	\N	0	HONDA	14000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	16000.00	HON-STO-COB-1056	2026-06-18 17:27:37.767	\N
cmlezxnxs025x39t5qb19ssp7	PIPA GAS BEAT FI/ BEAT FI ESP / VARIO TECHNO 125 / SPACY FI	\N	0	HONDA	9000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	11900.00	HON-TUT-PIP-1402	2026-06-18 17:27:37.767	\N
cmlezxnxs025s39t5dzrtoafe	PIPA GAS GRAND / IMPRESSA / PRIMA / LEGENDA / LEGENDA 2	\N	0	HONDA	9000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	11900.00	HON-TUT-PIP-1408	2026-06-18 17:27:37.767	\N
cmlezwqqq00fu39t5xutv815g	FRONT FENDER / SPAKBOR DEPAN  PCX 160 PUTIH	\N	0	HONDA	154000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	167000.00	HON-FRO-FRO-222	2026-06-18 17:22:17.168	\N
cmlezxdqx01mq39t5o9u2ikya	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 GRAY	\N	0	HONDA	240000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.265	BODY PART	255000.00	HON-LEG-LEG-1078	2026-06-18 17:22:17.168	\N
cmlezwtic00jg39t52dmdki4k	PANEL / TAMENGBEAT POP HITAM	\N	0	HONDA	136000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	251000.00	HON-PAN-PAN-344	2026-02-09 09:54:40.779	\N
cmlezxe4401nm39t5oo99744m	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 SILVER	\N	0	HONDA	240000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.266	BODY PART	255000.00	HON-LEG-LEG-1088	2026-06-18 17:22:17.168	\N
cmlezxed101o439t5q5anfzbz	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 BIRU DOFF	\N	0	HONDA	162000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.266	BODY PART	170000.00	HON-LEG-LEG-1095	2026-06-18 17:22:17.168	\N
cmlezxez101p239t56ov1yd43	LEGSHIELD LUAR / SAYAP LUAR VARIO 110 FI HITAM DOFF	\N	0	HONDA	133000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.245	BODY PART	140000.00	HON-LEG-LEG-1102	2026-06-18 17:22:17.168	\N
cmlezxez101p539t5he828gw7	LEGSHIELD LUAR / SAYAP LUAR VARIO 110 FI GRAY DOFF	\N	0	HONDA	133000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.245	BODY PART	140000.00	HON-LEG-LEG-1103	2026-06-18 17:22:17.168	\N
cmlezxfgv01qc39t5vomvmnrj	LEGSHIELD DALAM / SAYAP DALAM SCOOPY FI 17 BESAR GRAY	\N	0	HONDA	211000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	227000.00	HON-LEG-LEG-1146	2026-06-18 17:22:17.168	\N
cmlezwxen00pq39t5hwlagh7k	PANEL / TAMENG KARISMA/X HITAM	\N	0	HONDA	60000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	63000.00	HON-PAN-PAN-483	2026-02-09 09:54:46.185	\N
cmlezxfcq01q639t50p0wv3zm	LEGSHIELD DALAM / SAYAP DALAM SCOOPY FI 17 BESAR HIJAU	\N	0	HONDA	211000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	227000.00	HON-LEG-LEG-1147	2026-06-18 17:22:17.168	\N
cmlezxgnm01tc39t5ue1ys4p9	LEGSHIELD DALAM / SAYAP DALAM SCOOPY FI 17 BESAR MERAH DOFF	\N	0	HONDA	211000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	227000.00	HON-LEG-LEG-1143	2026-06-18 17:22:17.168	\N
cmlezxh3q01u639t5ky7omwgs	LEGSHIELD DALAM / SAYAP DALAM SCOOPY FI 17 BESAR SILVER	\N	0	HONDA	211000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.247	BODY PART	227000.00	HON-LEG-LEG-1144	2026-06-18 17:22:17.168	\N
cmlezxf6601pw39t5eoljy8qz	LEGSHIELD DALAM / SAYAP DALAM SCOOPY FI ESP BESAR GRAY	\N	0	HONDA	249000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	267000.00	HON-LEG-LEG-1145	2026-06-18 17:22:17.168	\N
cmlezxfcr01q739t53k87doqr	LEGSHIELD DALAM / SAYAP DALAM SCOOPY FI ESP BESAR KREM	\N	0	HONDA	249000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	267000.00	HON-LEG-LEG-1148	2026-06-18 17:22:17.168	\N
cmlezwgen000v39t52dompgsg	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BEAT ORANGE	\N	0	HONDA	192000.00	COVER BODY / BODY SAMPING BELAKANG  KANAN KIRI (HONDA)	2026-02-09 09:54:25.619	BODY PART	199000.00	HON-COV-COV-29	2026-06-18 17:22:17.168	\N
cmlezwihj005039t548ppfyst	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SUPRA FIT NEW HITAM	\N	0	HONDA	161000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	164000.00	HON-COV-COV-91	2026-06-18 17:22:17.168	\N
cmlezwie0004w39t5e2moid0y	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SUPRA FIT NEW SILVER	\N	0	HONDA	190000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	202000.00	HON-COV-COV-94	2026-06-18 17:22:17.168	\N
cmlezwoxc00ec39t5fawotzyh	FRONT FENDER / SPAKBOR DEPAN  PCX 160 HITAM	\N	0	HONDA	130000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	175000.00	HON-FRO-FRO-220	2026-06-18 17:22:17.168	\N
cmlezwqvp00g439t51r2pt9rb	FRONT FENDER / SPAKBOR DEPAN  PCX 150 18 HITAM	\N	0	HONDA	163000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	202000.00	HON-FRO-FRO-223	2026-06-18 17:22:17.168	\N
cmlezwkdl006y39t5f4hchj8o	FRONT FENDER / SPAKBOR DEPAN  BEAT BIRU MUDA	\N	0	HONDA	75000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	96000.00	HON-FRO-FRO-152	2026-06-18 17:22:17.168	\N
cmlezwwfd00o039t5gx2w4nhv	PANEL / TAMENGGENIO HITAM DOFF	\N	0	HONDA	355000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	380000.00	HON-PAN-PAN-460	2026-06-18 17:22:17.168	\N
cmlezwwkj00o239t536lq33ll	PANEL / TAMENGGENIO GRAY DOFF	\N	0	HONDA	355000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	380000.00	HON-PAN-PAN-461	2026-06-18 17:22:17.168	\N
cmlezx23l00zk39t5ls4jr8vy	COVER STOP / RR STOP SCOOPY FI MERAH MAROON	\N	0	HONDA	80000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	91000.00	HON-COV-COV-668	2026-06-18 17:22:17.168	\N
cmlezxi5o01vf39t5vqx8d2fv	FOOTREST BAWAH VARIO 150 18 B R+L MERAH	\N	0	HONDA	292000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	325000.00	HON-LEG-FOO-1244	2026-06-18 17:22:17.168	\N
cmlezx7rd019b39t5hj0kgadv	MIKA LAMPU GRAND	\N	0	HONDA	21000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	33000.00	HON-MIK-MIK-818	2026-06-18 17:22:17.168	\N
cmlezxek301oo39t5xcxail1g	STOP LAMP UNIT GL PRO DE (P)	\N	0	HONDA	63000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.266	KELISTRIKAN	73000.00	HON-STO-STO-1038	2026-06-18 17:22:17.168	\N
cmlezxkty020k39t5le2ipbem	COVER FILTER UDARA VARIO 150 18	\N	0	HONDA	0.00	COVER FILTER UDARA	2026-02-09 09:55:18.838	BODY PART	47000.00	HON-COV-COV-1301	2026-06-19 22:06:14.057	01B5239182AA1
cmlezwuj400kv39t56zhilk09	REAR FENDER / SPAKBOR BELAKANG VARIO TECHNO	\N	0	HONDA	90000.00	REAR FENDER/SPAKBOR BELAKANG (HONDA)	2026-02-09 09:54:40.78	BODY PART	83000.00	HON-REA-REA-312	2026-06-19 22:06:14.49	01B2933282AA1
cmlezwm3h00a039t5chf9fax5	FRONT FENDER / SPAKBOR DEPAN  SCOOPY 20 HITAM	\N	0	HONDA	134000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.885	BODY PART	146000.00	HON-FRO-FRO-197	2026-06-19 22:06:14.626	01B6230740AA1
cmlezxedk01o839t5sn4ituit	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 GRAY DOFF	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.266	BODY PART	259000.00	HON-LEG-LEG-1096	2026-06-19 22:06:14.764	01B4431886AA1
cmlezxgz001ty39t5pru4j99p	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM SCOOPY FI ESP BESAR MERAH	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.247	BODY PART	137000.00	HON-LEG-LEG-1187	2026-06-19 22:06:15.149	01B4335281AA1
cmlezwuhh00kq39t5zb0ds15t	PANEL / TAMENGVARIO 150 18 BESAR SILVER	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	179000.00	HON-PAN-PAN-379	2026-06-19 22:06:15.284	01B5230542AA1
cmlezxg7601se39t5dju4tgap	LEGSHIELD LUAR / SAYAP LUAR SUPRA X 125 07 PUTIH	\N	0	HONDA	233000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	243000.00	HON-LEG-LEG-1123	2026-06-18 17:27:37.767	\N
cmlezwzj900ty39t5hya0emjo	FRONT HANDLE COVER / BATOK DEPAN BEAT FI ESP PUTIH	\N	0	HONDA	111000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	121000.00	HON-FRO-FRO-528	2026-06-18 17:27:37.767	\N
cmlezwsr700j039t5bxtul6nk	PANEL / TAMENGBEAT ESP 16 KECIL/DASI	\N	0	HONDA	28000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	31000.00	HON-PAN-PAN-343	2026-02-09 09:54:40.779	\N
cmlezx1sx00ys39t5o2kksxmx	COVER STOP / RR STOP BEAT FI	\N	0	HONDA	10000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	46000.00	HON-COV-COV-646	2026-06-18 17:22:17.168	\N
cmlezwwe400nv39t52xy5q2a0	PANEL / TAMENGGENIO MERAH	\N	0	HONDA	342000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	366000.00	HON-PAN-PAN-458	2026-06-18 17:22:17.168	\N
cmlezxiqn01wp39t5dambd88o	FOOTREST BAWAH SCOOPY 20 B R+L GRAY DOFF	\N	0	HONDA	232000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	240000.00	HON-LEG-FOO-1265	2026-06-18 17:22:17.168	\N
cmlezx01l00v839t59ga7jt5u	FRONT HANDLE COVER / BATOK DEPAN A SCOOPY FI KREM	\N	0	HONDA	82000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	90000.00	HON-FRO-FRO-567	2026-06-18 17:22:17.168	\N
cmlezx0st00wy39t540i46jjf	FRONT HANDLE COVER / BATOK DEPAN SUPRA X HITAM CAKRAM	\N	0	HONDA	61000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	92000.00	HON-FRO-FRO-597	2026-06-18 17:22:17.168	\N
cmlezx1kw00y639t5tqwqnh6r	REAR HANDLE / BATOK BELAKANG COVER KARISMA X HITAM	\N	0	HONDA	63000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	69000.00	HON-REA-REA-642	2026-06-18 17:22:17.168	\N
cmlezx2t8011o39t5qrfy9qvk	COVER STOP / RR STOP CB 150 R NEW PUTIH	\N	0	HONDA	65000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	72000.00	HON-COV-COV-690	2026-06-18 17:22:17.168	\N
cmlezx2hc010o39t5f2hgq8qt	COVER STOP / RR STOP SCOOPY FI 17 KREM	\N	0	HONDA	103000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	118000.00	HON-COV-COV-678	2026-06-18 17:22:17.168	\N
cmlezx2pn011a39t57b5exxbo	COVER STOP / RR STOP SCOOPY FI KREM	\N	0	HONDA	84000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	96000.00	HON-COV-COV-687	2026-06-18 17:22:17.168	\N
cmlezwxaq00pe39t5slrz698r	PANEL / TAMENGABSOLUTE REVO HITAM	\N	0	HONDA	171000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	174000.00	HON-PAN-PAN-465	2026-02-09 09:54:46.185	\N
cmlezx9fd01de39t5ki1kr0n1	MIKA SEN Fr / MIKA SEN DEPAN  BEAT 20 SMOKE	\N	0	HONDA	41000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	62000.00	HON-MIK-MIK-866	2026-06-18 17:22:17.168	\N
cmlezxom1027i39t52c7iii18	KARET BARSTEP /	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	18000.00	HON-TUT-KAR-1444	2026-06-18 17:22:17.168	\N
cmlezx5zq016l39t591az4eyi	LAMPU DEPAN / HEAD LAMP SCOOPY FI 17 + LED BIRU VARIASI	\N	0	HONDA	585000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	589000.00	HON-LAM-LAM-748	2026-06-18 17:22:17.168	\N
cmlezx6sk017q39t55978mf0i	LAMPU DEPAN / HEAD LAMP SCOOPY FI 17 + LED MERAH VARIASI	\N	0	HONDA	585000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	589000.00	HON-LAM-LAM-749	2026-06-18 17:22:17.168	\N
cmlezx2r0011d39t5ms9wjul7	COVER STOP / RR STOP SCOOPY 20 KECIL HITAM	\N	0	HONDA	64000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	64000.00	HON-COV-COV-680	2026-06-18 17:22:17.168	\N
cmlezx2mm011439t5u3irtp11	COVER STOP / RR STOP SCOOPY 20 KECIL MERAH DOFF	\N	0	HONDA	79000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	79000.00	HON-COV-COV-686	2026-06-18 17:22:17.168	\N
cmlezx18j00xj39t59aj81nov	FRONT HANDLE COVER / BATOK DEPAN SMASH HITAM	\N	0	HONDA	53000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:53.443	BODY PART	119000.00	HON-FRO-FRO-608	2026-02-09 09:54:53.443	\N
cmlezx1xv00z839t5g3xxitij	REAR HANDLE / BATOK BELAKANG COVER GENIO BIRU	\N	0	HONDA	62000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	31000.00	HON-REA-REA-637	2026-02-09 09:54:53.444	\N
cmlezwg5k000e39t5dr3iz2vv	COMPLETE SET BODY VARIO 150 HITAM	\N	0	HONDA	1477000.00	COMPLETE SET BODY	2026-02-09 09:54:25.619	BODY PART	1535000.00	HON-COM-COM-4	2026-06-18 17:27:37.767	\N
cmlezxn5q025a39t5mj96jw2x	PIPA GAS CBR 150	\N	0	HONDA	7000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	7300.00	HON-TUT-PIP-1399	2026-06-18 17:27:37.767	\N
cmlezxnxs025w39t55v2zkgpi	PIPA GAS MEGAPRO 10	\N	0	HONDA	9000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	7300.00	HON-TUT-PIP-1411	2026-06-18 17:27:37.767	\N
cmlezwg0d000839t5ox899wsg	COMPLETE SET BODY VARIO 150 18 MERAH DOFF	\N	0	HONDA	2178000.00	COMPLETE SET BODY	2026-02-09 09:54:25.619	BODY PART	2194000.00	HON-COM-COM-2	2026-06-18 17:27:37.767	\N
cmlezwfzb000639t5nnrwo3iw	COMPLETE SET BODY VARIO 150 18 PUTIH	\N	0	HONDA	1955000.00	COMPLETE SET BODY	2026-02-09 09:54:25.619	BODY PART	2178000.00	HON-COM-COM-3	2026-06-18 17:27:37.767	\N
cmlg43pul00q9pv85ct87ywkf	SWITCH REM BELAKANG ALL MATIC YAMAHA	\N	0	YAMAHA	11000.00	SWITCH REM	2026-02-10 04:39:46.568	KELISTRIKAN	15000.00	YAM-AKS-SWI-687	2026-06-18 17:34:05.97	\N
cmlezwtw300jw39t5x5v7vfgq	PANEL / TAMENGBEAT POP MERAH MAROON	\N	0	HONDA	176000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	179000.00	HON-PAN-PAN-345	2026-02-09 09:54:40.779	\N
cmlezwua300ke39t53ltunlko	PANEL / TAMENGBEAT 20 KECIL/DASI	\N	0	HONDA	23000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	26000.00	HON-PAN-PAN-337	2026-02-09 09:54:40.78	\N
cmlezx24b00zq39t54jr1t6wh	REAR HANDLE / BATOK BELAKANG COVER GRAND MERAH	\N	0	HONDA	49000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	60000.00	HON-REA-REA-634	2026-02-09 09:54:53.444	\N
cmlezwkp9007k39t5p7z1f4y3	FRONT FENDER / SPAKBOR DEPAN  BEAT 10 HIJAU	\N	0	HONDA	88000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	94000.00	HON-FRO-FRO-143	2026-06-18 17:22:17.168	\N
cmlezx2je010s39t5vf69hjx8	COVER STOP / RR STOP SCOOPY FI 17 PUTIH	\N	0	HONDA	111000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	111000.00	HON-COV-COV-685	2026-06-18 17:22:17.168	\N
c0e33b6e-a4a3-45d1-81ca-3108ef600001	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	\N	0	HONDA	43000.00	LEGSHIELD LUAR	2026-06-18 17:27:37.767	BODY PART	43000.00	HON-LEG-1599	2026-06-18 17:27:37.767	\N
cmlezx88j01aa39t59glaqxo2	MIKA SPEEDOMETER SCOOPY 20	\N	0	HONDA	26000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	31000.00	HON-MIK-MIK-849	2026-06-19 22:06:16.21	01B6201700AA6
cmlezwo9a00cw39t5r3ct2ljl	FRONT FENDER / SPAKBOR DEPAN  BLADE 11 HITAM	\N	0	HONDA	88000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	96000.00	HON-FRO-FRO-270	2026-06-19 22:06:16.929	01B3430840AA1
cmlezwsjt00iv39t57pyamzz2	PANEL / TAMENGBEAT 20 BESAR HITAM DOFF	\N	0	HONDA	246000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	218000.00	HON-PAN-PAN-361	2026-06-19 22:06:17.147	01B5930580AA4
cmlezwobn00d239t57gpv2lob	FRONT FENDER / SPAKBOR DEPAN  B SUPRA X 125 07	\N	0	HONDA	54000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	60000.00	HON-FRO-FRO-258	2026-06-19 22:06:17.574	01B2530900AA1
cmlezwr2j00gh39t5hrz3mg8z	FRONT FENDER / SPAKBOR DEPAN  SUPRA X 125 14 HITAM	\N	0	HONDA	77000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.583	BODY PART	89000.00	HON-FRO-FRO-253	2026-06-19 22:06:18.558	01B4130840AA1
cmlezwusl00lh39t5mmeivxw4	PANEL / TAMENGVARIO 110 FI MERAH MAROON	\N	0	HONDA	163000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	201000.00	HON-PAN-PAN-392	2026-02-09 09:54:40.78	\N
cmlezwl03008439t5pi4d8pnd	FRONT FENDER / SPAKBOR DEPAN  BEAT 10 BIRU TUA	\N	0	HONDA	88000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	89000.00	HON-FRO-FRO-144	2026-06-18 17:19:42.083	\N
cmlezwlco008o39t5e5i0cgdq	FRONT FENDER / SPAKBOR DEPAN  BEAT 10 MERAH MAROON	\N	0	HONDA	88000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	105000.00	HON-FRO-FRO-145	2026-06-18 17:19:42.083	\N
cmlezwk6j006g39t52bhtven8	FRONT FENDER / SPAKBOR DEPAN  BEAT 10 PUTIH	\N	0	HONDA	88000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	89000.00	HON-FRO-FRO-146	2026-06-18 17:19:42.083	\N
cmlezwwwe00ok39t5qbynagsk	PANEL / TAMENGSUPRA FIT HITAM	\N	0	HONDA	52000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	324000.00	HON-PAN-PAN-473	2026-02-09 09:54:46.185	\N
cmlezwx4500p039t59tgmj7jh	PANEL / TAMENGDEPAN BAGIAN BAWAH VARIO	\N	0	HONDA	76000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	71000.00	HON-PAN-PAN-432	2026-02-09 09:54:46.185	\N
cmlezwsai00i639t5mlksvpwq	REAR FENDER / SPAKBOR BELAKANG SUPRA X 125 14	\N	0	HONDA	68000.00	REAR FENDER / (KOLONG) VARIO TECHNO 125	2026-02-09 09:54:40.779	LAIN-LAIN	77000.00	HON-REA-REA-320	2026-06-18 17:22:17.168	01B4133282AA1
cmlezwyww00s839t57bgt2335	FRONT HANDLE COVER / BATOK DEPAN BEAT POP BIRU	\N	0	HONDA	98000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-525	2026-02-09 09:54:50.206	\N
cmlezwusl00lg39t5f6miwh7d	REAR FENDER / (KOLONG) VARIO 150 18	\N	0	HONDA	28000.00	REAR FENDER/SPAKBOR BELAKANG (HONDA)	2026-02-09 09:54:40.78	BODY PART	27000.00	HON-REA-REA-313	2026-06-18 17:19:42.083	01B55239282AA1
cmlg3mb340000vu8yv3to3zdt	FRONT FENDER TRAIL BIRU	\N	0	KAWASAKI	47000.00	FRONT FENDER/SPAKBOR DEPAN (KAWASAKI)	2026-02-10 04:26:17.632	BODY PART	50000.00	KAW-BOD-FRO-1	2026-02-10 04:26:17.632	\N
cmlg3mbm10004vu8yhoje2otr	FRONT FENDER NINJA PUTIH	\N	0	KAWASAKI	90000.00	FRONT FENDER/SPAKBOR DEPAN (KAWASAKI)	2026-02-10 04:26:17.633	BODY PART	93000.00	KAW-BOD-FRO-11	2026-02-10 04:26:17.633	\N
cmlg3mc4k0006vu8y3n86dfyj	FRONT FENDER NINJA HITAM	\N	0	KAWASAKI	74000.00	FRONT FENDER/SPAKBOR DEPAN (KAWASAKI)	2026-02-10 04:26:17.632	BODY PART	77000.00	KAW-BOD-FRO-5	2026-02-10 04:26:17.632	\N
cmlg435wn0002pv85emm3kw34	FRONT FENDER/SPAKBOR DEPAN MIO KUNING	\N	0	YAMAHA	67000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.836	BODY PART	70000.00	YAM-BOD-FRO-204	2026-02-10 04:39:23.836	\N
cmlg436480007pv85wyslf9rq	FRONT FENDER/SPAKBOR DEPAN A JUPITER Z 10 MERAH MAROON	\N	0	YAMAHA	78000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.837	BODY PART	81000.00	YAM-BOD-FRO-225	2026-02-10 04:39:23.837	\N
cmlg436cm000dpv85u3gn59fp	FRONT FENDER/SPAKBOR DEPAN JUPITER Z 06 MERAH MAROON	\N	0	YAMAHA	91000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.837	BODY PART	94000.00	YAM-BOD-FRO-231	2026-02-10 04:39:23.837	\N
cmlg436oa000jpv8523dsly9t	FRONT FENDER/SPAKBOR DEPAN JUPITER Z 06 HIJAU	\N	0	YAMAHA	84000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	87000.00	YAM-BOD-FRO-228	2026-02-10 04:39:23.838	\N
cmlg436z3000npv85vgradjtn	FRONT FENDER/SPAKBOR DEPAN JUPITER MX 11 HITAM	\N	0	YAMAHA	84000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	87000.00	YAM-BOD-FRO-210	2026-02-10 04:39:23.838	\N
cmlg43788000spv85u8jb6u73	FRONT FENDER/SPAKBOR DEPAN V-IXION 12 HITAM	\N	0	YAMAHA	82000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	85000.00	YAM-BOD-FRO-239	2026-02-10 04:39:23.838	\N
cmlg437ge000ypv85xlq2ybix	FRONT FENDER/SPAKBOR DEPAN A JUPITER Z1 BIRU	\N	0	YAMAHA	93000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	96000.00	YAM-BOD-FRO-234	2026-02-10 04:39:23.838	\N
cmlezwzuv00uq39t511emgv0z	FRONT HANDLE COVER / BATOK DEPAN VARIO 150 18 + ACC GRAY DOFF	\N	0	HONDA	187000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-555	2026-02-09 09:54:50.207	\N
cmlezwtzg00k039t5mra2qt01	PANEL / TAMENGVARIO 160 BESAR HITAM	\N	0	HONDA	178000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	192000.00	HON-PAN-PAN-371	2026-06-18 17:22:17.168	\N
cmlezx08q00vo39t58oc7l2sd	FRONT HANDLE COVER / BATOK DEPAN A SCOOPY FI 17 + ACC PUTIH	\N	0	HONDA	171000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	132000.00	HON-FRO-FRO-569	2026-02-09 09:54:50.207	\N
cmlezx0ht00w639t504pliwj3	FRONT HANDLE COVER / BATOK DEPAN GENIO A+B HITAM	\N	0	HONDA	67000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-576	2026-02-09 09:54:50.207	\N
cmlezx0wk00x639t5a725sdw2	FRONT HANDLE COVER / BATOK DEPAN SUPRA X 125 07 MERAH	\N	0	HONDA	106000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	132000.00	HON-FRO-FRO-599	2026-02-09 09:54:50.207	\N
cmlezx1ed00xy39t5rg0pgm46	REAR HANDLE / BATOK BELAKANG COVER SUPRA FIT NEW	\N	0	HONDA	44000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	83000.00	HON-REA-REA-629	2026-02-09 09:54:53.444	\N
cmlezx1k800y239t59x3t8s5k	REAR HANDLE / BATOK BELAKANG COVER GRAND HIJAU	\N	0	HONDA	49000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	60000.00	HON-REA-REA-635	2026-02-09 09:54:53.444	\N
cmlezx1re00yi39t595y3utva	REAR HANDLE / BATOK BELAKANG COVER ABSOLUTE REVO	\N	0	HONDA	41000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	60000.00	HON-REA-REA-626	2026-02-09 09:54:53.444	\N
cmlg3mc4k0008vu8yp84fptwd	FRONT FENDER NINJA BIRU	\N	0	KAWASAKI	90000.00	FRONT FENDER/SPAKBOR DEPAN (KAWASAKI)	2026-02-10 04:26:17.632	BODY PART	93000.00	KAW-BOD-FRO-6	2026-02-10 04:26:17.632	\N
cmlezwrgp00gw39t5vhh1gqql	REAR FENDER / SPAKBOR BELAKANG SCOOPY FI 17	\N	0	HONDA	97000.00	REAR FENDER / (KOLONG) VARIO TECHNO 125	2026-02-09 09:54:40.778	LAIN-LAIN	108000.00	HON-REA-REA-316	2026-06-19 22:06:19.215	01B4833282AA1
cmlezwttw00js39t5kdfbj8tu	REAR FENDER / SPAKBOR BELAKANG VERZA	\N	0	HONDA	66000.00	REAR FENDER / (KOLONG) VARIO TECHNO 125	2026-02-09 09:54:40.779	LAIN-LAIN	75000.00	HON-REA-REA-324	2026-06-19 22:06:19.498	01B9233282AA1
cmlezwtq900ji39t5yli98t5p	REAR FENDER / SPAKBOR BELAKANG B SUPRA/X /XX/FIT	\N	0	HONDA	47000.00	REAR FENDER / (KOLONG) VARIO TECHNO 125	2026-02-09 09:54:40.779	LAIN-LAIN	97000.00	HON-REA-REA-323	2026-06-19 22:06:19.834	01B1333482AA1
cmlezwulc00l039t5pl92d43q	REAR FENDER / SPAKBOR BELAKANG GRAND HITAM	\N	0	HONDA	0.00	REAR FENDER / (KOLONG) VARIO TECHNO 125	2026-02-09 09:54:40.78	LAIN-LAIN	60000.00	HON-REA-REA-327	2026-06-19 22:06:20.015	01B0833240AA1
cmlezws1c00hr39t5llx8fk3w	REAR FENDER / SPAKBOR BELAKANG GRAND HITAM	\N	0	HONDA	55000.00	REAR FENDER / (KOLONG) VARIO TECHNO 125	2026-02-09 09:54:40.779	LAIN-LAIN	97000.00	HON-REA-REA-330	2026-06-19 22:06:20.155	01B0833240AA1
cmlezwuzy00lu39t55jsg0cyr	PANEL / TAMENGVARIO 125 23 BESAR HITAM DOFF	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	235000.00	HON-PAN-PAN-397	2026-06-19 22:06:20.288	01B6730580AA1
cmlezwv0u00lw39t5rpem4xqt	PANEL / TAMENGVARIO 125 23 BESAR MERAH	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	217000.00	HON-PAN-PAN-396	2026-06-19 22:06:20.425	01B6730581AA1
cmlezwv2y00m039t51vao3mie	PANEL / TAMENGVARIO 125 23 BESAR HITAM	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	235000.00	HON-PAN-PAN-395	2026-06-19 22:06:20.857	01B6730540AA1
cmlg3mdts000ivu8y0aed0gyq	FRONT FENDER NINJA HIJAU	\N	0	KAWASAKI	90000.00	FRONT FENDER/SPAKBOR DEPAN (KAWASAKI)	2026-02-10 04:26:17.632	BODY PART	93000.00	KAW-BOD-FRO-7	2026-02-10 04:26:17.632	\N
cmlg435x10004pv85kvrkx8k0	FRONT FENDER/SPAKBOR DEPAN JUPITER Z MERAH	\N	0	YAMAHA	93000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.837	BODY PART	96000.00	YAM-BOD-FRO-220	2026-02-10 04:39:23.837	\N
cmlg436480006pv85kdczl8c2	FRONT FENDER/SPAKBOR DEPAN MIO J HIJAU	\N	0	YAMAHA	81000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.837	BODY PART	84000.00	YAM-BOD-FRO-201	2026-02-10 04:39:23.837	\N
cmlg436cm000cpv85xlwj7vue	FRONT FENDER/SPAKBOR DEPAN A JUPITER Z1 HITAM	\N	0	YAMAHA	77000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.837	BODY PART	80000.00	YAM-BOD-FRO-226	2026-02-10 04:39:23.837	\N
cmlg436oa000ipv853xw8smh3	FRONT FENDER/SPAKBOR DEPAN B JUPITER Z1	\N	0	YAMAHA	67000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	70000.00	YAM-BOD-FRO-227	2026-02-10 04:39:23.838	\N
cmlg436z3000mpv85f75nocr7	FRONT FENDER/SPAKBOR DEPAN JUPITER MX BIRU MUDA	\N	0	YAMAHA	79000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	82000.00	YAM-BOD-FRO-232	2026-02-10 04:39:23.838	\N
cmlezwv0v00ly39t5oe2y5a41	PANEL / TAMENGVARIO TECHNO 125 BESAR HITAM	\N	0	HONDA	170000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	187000.00	HON-PAN-PAN-398	2026-02-09 09:54:40.78	\N
cmlezx2tc011q39t5d1gpja05	COVER STOP / RR STOP ABSOLUTE REVO	\N	0	HONDA	20000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	23000.00	HON-COV-COV-691	2026-02-09 09:54:53.444	\N
cmlezwvx400mx39t50k7ztnav	PANEL / TAMENGDEPAN BAGIAN BAWAH VARIO 110 FI	\N	0	HONDA	54000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	71000.00	HON-PAN-PAN-429	2026-02-09 09:54:46.185	\N
cmlezx6af017639t503xfwy7e	MIKA LAMPU BEAT POP	\N	0	HONDA	63000.00	MIKA LAMPU (HONDA)	2026-02-09 09:54:56.89	KELISTRIKAN	66000.00	HON-MIK-MIK-788	2026-02-09 09:54:56.89	\N
cmlezwwe400nw39t57a2gyhgj	PANEL / TAMENGSCOOPY PUTIH	\N	0	HONDA	216000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	251000.00	HON-PAN-PAN-450	2026-02-09 09:54:46.185	\N
cmlg3mc4k0007vu8y4ibk44ql	FRONT FENDER TRAIL PUTIH	\N	0	KAWASAKI	48000.00	FRONT FENDER/SPAKBOR DEPAN (KAWASAKI)	2026-02-10 04:26:17.632	BODY PART	51000.00	KAW-BOD-FRO-4	2026-02-10 04:26:17.632	\N
cmlg43788000tpv85b9nwk1nw	FRONT FENDER/SPAKBOR DEPAN JUPITER MX HIJAU	\N	0	YAMAHA	79000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	82000.00	YAM-BOD-FRO-233	2026-02-10 04:39:23.838	\N
cmlg437ge000zpv85c53ulf8j	FRONT FENDER/SPAKBOR DEPAN V-IXION 12 MERAH MAROON	\N	0	YAMAHA	93000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	96000.00	YAM-BOD-FRO-240	2026-02-10 04:39:23.838	\N
cmlg437ov0015pv85w62hacvl	FRONT FENDER/SPAKBOR DEPAN V-IXION 12 PUTIH	\N	0	YAMAHA	93000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	96000.00	YAM-BOD-FRO-241	2026-02-10 04:39:23.838	\N
cmlg437wc0018pv850maqcmz0	FRONT FENDER/SPAKBOR DEPAN A VEGA ZR PUTIH	\N	0	YAMAHA	76000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	79000.00	YAM-BOD-FRO-254	2026-02-10 04:39:23.838	\N
cmlg4385r001epv85xzw9jdkq	FRONT FENDER/SPAKBOR DEPAN A VEGA ZR BIRU TUA	\N	0	YAMAHA	75000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	78000.00	YAM-BOD-FRO-255	2026-02-10 04:39:23.838	\N
cmlg438di001ipv85l3kzmi0p	FRONT FENDER/SPAKBOR DEPAN B VEGA R 06	\N	0	YAMAHA	44000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	47000.00	YAM-BOD-FRO-249	2026-02-10 04:39:23.839	\N
cmlg438l6001qpv85jbpo1obk	FRONT FENDER/SPAKBOR DEPAN N-MAX GRAY	\N	0	YAMAHA	99000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	102000.00	YAM-BOD-FRO-257	2026-02-10 04:39:23.839	\N
cmlg439e1002gpv85q7k3jba0	FRONT FENDER/SPAKBOR DEPAN FINO PUTIH	\N	0	YAMAHA	89000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	92000.00	YAM-BOD-FRO-261	2026-02-10 04:39:23.839	\N
cmlg439j0002opv8592je8rug	FRONT FENDER/SPAKBOR DEPAN R15 PUTIH	\N	0	YAMAHA	119000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	122000.00	YAM-BOD-FRO-270	2026-02-10 04:39:23.839	\N
cmlg439ti0032pv85tbpwx64f	FRONT FENDER/SPAKBOR DEPAN X-RIDE HITAM	\N	0	YAMAHA	85000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	88000.00	YAM-BOD-FRO-276	2026-02-10 04:39:23.84	\N
cmlg43am60040pv85v3tsk047	FRONT FENDER/SPAKBOR DEPAN A JUPITER Z1 MERAH MAROON	\N	0	YAMAHA	86000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	89000.00	YAM-BOD-FRO-221	2026-02-10 04:39:23.84	\N
cmlezwwo300og39t5dbck2kj5	PANEL / TAMENGVARIO PINK	\N	0	HONDA	161000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	194000.00	HON-PAN-PAN-412	2026-02-09 09:54:46.185	\N
cmlezwwye00ot39t5hlu35qcm	PANEL / TAMENGKARISMA HITAM	\N	0	HONDA	49000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	178000.00	HON-PAN-PAN-477	2026-02-09 09:54:46.185	\N
cmlezwx5j00p739t503jjli8n	PANEL / TAMENGREVO PUTIH	\N	0	HONDA	106000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	342000.00	HON-PAN-PAN-468	2026-02-09 09:54:46.185	\N
cmlezwxkf00q039t5zrj9zj3l	PANEL / TAMENGXEON RC HITAM	\N	0	HONDA	53000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	324000.00	HON-PAN-PAN-482	2026-02-09 09:54:46.185	\N
cmlezx67k016w39t5z9q5t7nz	MIKA LAMPU BEAT ESP 16	\N	0	HONDA	57000.00	MIKA LAMPU (HONDA)	2026-02-09 09:54:56.89	KELISTRIKAN	60000.00	HON-MIK-MIK-787	2026-02-09 09:54:56.89	\N
cmlg3mc5e000cvu8yfgmkk2bq	FRONT FENDER TRAIL HIJAU	\N	0	KAWASAKI	47000.00	FRONT FENDER/SPAKBOR DEPAN (KAWASAKI)	2026-02-10 04:26:17.632	BODY PART	50000.00	KAW-BOD-FRO-2	2026-02-10 04:26:17.632	\N
cmlg437ne0012pv856h7xjez4	FRONT FENDER/SPAKBOR DEPAN A VEGA R 06 BIRU	\N	0	YAMAHA	82000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	85000.00	YAM-BOD-FRO-247	2026-02-10 04:39:23.838	\N
cmlg437z6001cpv85b3gokxxg	FRONT FENDER/SPAKBOR DEPAN V-IXION BIRU	\N	0	YAMAHA	84000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	87000.00	YAM-BOD-FRO-242	2026-02-10 04:39:23.838	\N
cmlg438jl001mpv859idunqo8	FRONT FENDER/SPAKBOR DEPAN A VEGA ZR HITAM	\N	0	YAMAHA	68000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	71000.00	YAM-BOD-FRO-243	2026-02-10 04:39:23.839	\N
cmlg438rg001spv85xb22p16n	FRONT FENDER/SPAKBOR DEPAN VEGA R 04 HITAM	\N	0	YAMAHA	68000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	71000.00	YAM-BOD-FRO-250	2026-02-10 04:39:23.839	\N
cmlg438xr001wpv85t2uzq0np	FRONT FENDER/SPAKBOR DEPAN N-MAX MERAH MAROON	\N	0	YAMAHA	101000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	104000.00	YAM-BOD-FRO-258	2026-02-10 04:39:23.839	\N
cmlg4395o0026pv85ii5vrd7o	FRONT FENDER/SPAKBOR DEPAN B VEGA ZR	\N	0	YAMAHA	35000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	38000.00	YAM-BOD-FRO-245	2026-02-10 04:39:23.839	\N
cmlezwu0900k239t57ybedysb	PANEL / TAMENGVARIO 160 BESAR HITAM DOFF	\N	0	HONDA	194000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	209000.00	HON-PAN-PAN-372	2026-06-19 22:06:21.438	01B6430580AA1
cmlezwu5e00k439t5xelw7901	PANEL / TAMENGVARIO 160 BESAR MERAH DOFF	\N	0	HONDA	194000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	209000.00	HON-PAN-PAN-373	2026-06-19 22:06:21.568	01B6430587AA1
cmlezwua300kg39t5rp9jbjst	PANEL / TAMENGVARIO 160 KECIL HITAM / DASI	\N	0	HONDA	58000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	82000.00	HON-PAN-PAN-375	2026-06-19 22:06:21.702	01B6434840AA1
cmlg439cw002epv85u5wwuumr	FRONT FENDER/SPAKBOR DEPAN A VEGA R 06 HITAM	\N	0	YAMAHA	71000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	74000.00	YAM-BOD-FRO-246	2026-02-10 04:39:23.839	\N
cmlg439jm002qpv85a5qcwsro	FRONT FENDER/SPAKBOR DEPAN FINO HITAM	\N	0	YAMAHA	82000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	85000.00	YAM-BOD-FRO-262	2026-02-10 04:39:23.839	\N
cmlg439r8002ypv854um7ti35	FRONT FENDER/SPAKBOR DEPAN A FORCE HITAM	\N	0	YAMAHA	88000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	91000.00	YAM-BOD-FRO-275	2026-02-10 04:39:23.84	\N
cmlg439ye0038pv857iue00ay	FRONT FENDER/SPAKBOR DEPAN BYSON HITAM	\N	0	YAMAHA	75000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	78000.00	YAM-BOD-FRO-271	2026-02-10 04:39:23.84	\N
cmlg43a5e003ipv85kkxaqedr	FRONT FENDER/SPAKBOR DEPAN X-RIDE PUTIH	\N	0	YAMAHA	95000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	98000.00	YAM-BOD-FRO-277	2026-02-10 04:39:23.84	\N
cmlg43adi003spv85dmw4s5e8	FRONT FENDER/SPAKBOR DEPAN RXK NEW HITAM	\N	0	YAMAHA	89000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	92000.00	YAM-BOD-FRO-284	2026-02-10 04:39:23.84	\N
cmlezwyzd00sl39t5r1pn99tl	FRONT HANDLE COVER / BATOK DEPAN BEAT POP MERAH MAROON	\N	0	HONDA	98000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	132000.00	HON-FRO-FRO-531	2026-02-09 09:54:50.206	\N
cmlezwz8300t639t5bkuq2i9w	FRONT HANDLE COVER / BATOK DEPAN BEAT ESP 16 MAGENTA	\N	0	HONDA	89000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-508	2026-02-09 09:54:50.207	\N
cmlezwzdz00tm39t5ol9oypoz	FRONT HANDLE COVER / BATOK DEPAN VARIO 150 18 + ACC HITAM DOFF	\N	0	HONDA	176000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-540	2026-02-09 09:54:50.207	\N
cmlezwu5i00k639t5ndpw0s98	PANEL / TAMENGVARIO 160 BESAR PUTIH DOFF	\N	0	HONDA	194000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	209000.00	HON-PAN-PAN-374	2026-06-18 17:22:17.168	\N
cmlezwxry00qi39t5ntjppmcp	PANEL / TAMENGSCOOPY 20 KREM	\N	0	HONDA	273000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	293000.00	HON-PAN-PAN-434	2026-06-18 17:22:17.168	\N
cmlezww3p00n639t540bpy2vw	PANEL / TAMENGSCOOPY 20 MERAH DOFF	\N	0	HONDA	277000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	297000.00	HON-PAN-PAN-436	2026-06-18 17:22:17.168	\N
cmlezx1e800xu39t5xn7f2lew	REAR HANDLE / BATOK BELAKANG COVER VARIO 160	\N	0	HONDA	37000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	48000.00	HON-REA-REA-621	2026-02-09 09:54:53.444	\N
cmlg3mc5x000evu8yrsh2rm43	FRONT FENDER NINJA MERAH	\N	0	KAWASAKI	90000.00	FRONT FENDER/SPAKBOR DEPAN (KAWASAKI)	2026-02-10 04:26:17.632	BODY PART	93000.00	KAW-BOD-FRO-9	2026-02-10 04:26:17.632	\N
cmlg3me27000kvu8yamjk3cjo	FRONT FENDER TRAIL MERAH	\N	0	KAWASAKI	47000.00	FRONT FENDER/SPAKBOR DEPAN (KAWASAKI)	2026-02-10 04:26:17.632	BODY PART	50000.00	KAW-BOD-FRO-3	2026-02-10 04:26:17.632	\N
cmlg4392z0020pv85tmf536v2	FRONT FENDER/SPAKBOR DEPAN JUPITER MX 11 MERAH MAROON	\N	0	YAMAHA	94000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.836	BODY PART	97000.00	YAM-BOD-FRO-211	2026-02-10 04:39:23.836	\N
cmlg439bc002apv85e48txptq	FRONT FENDER/SPAKBOR DEPAN R 15 NEW HITAM	\N	0	YAMAHA	82000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	85000.00	YAM-BOD-FRO-265	2026-02-10 04:39:23.839	\N
cmlg439hs002mpv85cfl8zfuf	FRONT FENDER/SPAKBOR DEPAN R15 NEW BIRU	\N	0	YAMAHA	122000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	125000.00	YAM-BOD-FRO-267	2026-02-10 04:39:23.839	\N
cmlg439oi002upv8540uk54zx	FRONT FENDER/SPAKBOR DEPAN VEGA R 04 BIRU	\N	0	YAMAHA	84000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	87000.00	YAM-BOD-FRO-251	2026-02-10 04:39:23.84	\N
cmlg439uj0034pv85sdmkm7pu	FRONT FENDER/SPAKBOR DEPAN NEW X-RIDE 125 PUTIH	\N	0	YAMAHA	145000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	148000.00	YAM-BOD-FRO-279	2026-02-10 04:39:23.84	\N
cmlg43a84003mpv85kmcw4ghg	FRONT FENDER/SPAKBOR DEPAN FINO FI 18 PUTIH	\N	0	YAMAHA	129000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	132000.00	YAM-BOD-FRO-264	2026-02-10 04:39:23.84	\N
cmlg43afj003upv852buw1swk	FRONT FENDER/SPAKBOR DEPAN NINJA 250 KARBU HITAM	\N	0	YAMAHA	71000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	74000.00	YAM-BOD-FRO-282	2026-02-10 04:39:23.84	\N
cmlg43as50044pv852t05v813	REAR FENDER/SPAKBOR BELAKANG JUPITER MX 11	\N	0	YAMAHA	54000.00	REAR FENDER/SPAKBOR BELAKANG (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	57000.00	YAM-BOD-REA-285	2026-02-10 04:39:23.841	\N
cmlg43av80046pv857blyedpp	FRONT FENDER/SPAKBOR DEPAN A JUPITER Z1 PUTIH	\N	0	YAMAHA	86000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	89000.00	YAM-BOD-FRO-222	2026-02-10 04:39:23.841	\N
cmlezwtre00jk39t5gg267zca	PANEL / TAMENGBEAT 20 BESAR MERAH	\N	0	HONDA	219000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	201000.00	HON-PAN-PAN-335	2026-06-18 17:19:42.083	\N
cmlezx18j00xh39t5e1hzwo1u	FRONT HANDLE COVER / BATOK DEPAN SPACY HITAM	\N	0	HONDA	57000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:53.443	BODY PART	119000.00	HON-FRO-FRO-601	2026-02-09 09:54:53.443	\N
cmlezx1lr00yc39t5fiq4qsg5	REAR HANDLE / BATOK BELAKANG COVER BLADE 11	\N	0	HONDA	37000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	31000.00	HON-REA-REA-643	2026-02-09 09:54:53.444	\N
cmlezx1t300yw39t51j7o6143	REAR HANDLE / BATOK BELAKANG COVER REVO	\N	0	HONDA	30000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	48000.00	HON-REA-REA-627	2026-02-09 09:54:53.444	\N
cmlezx2bn010639t5cw0d4gho	COVER STOP / RR STOP SCOOPY 20 BESAR KREM	\N	0	HONDA	138000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	138000.00	HON-COV-COV-673	2026-06-18 17:22:17.168	\N
cmlezx2g3010h39t5v1ccyctf	COVER STOP / RR STOP SCOOPY 20 KECIL GRAY DOFF	\N	0	HONDA	79000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	79000.00	HON-COV-COV-681	2026-06-18 17:22:17.168	\N
cmlezx2je010t39t5wgb2gvlz	COVER STOP / RR STOP SCOOPY FI 17 MERAH	\N	0	HONDA	104000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	104000.00	HON-COV-COV-684	2026-06-18 17:22:17.168	\N
cmlg3siki0000erj0jz3vcaw7	COVER BODY SATRIA FU 150 HITAM	\N	0	SUZUKI	150000.00	COVER BODY/BODY SAMPING (SUZUKI)	2026-02-10 04:31:07.266	BODY PART	153000.00	SUZ-BOD-COV-1	2026-02-10 04:31:07.266	\N
cmlg3sjlp0002erj0kzfdun2o	LAMPU DEPAN NEX	\N	0	SUZUKI	95000.00	LAMPU DEPAN / (SUZUKI)	2026-02-10 04:31:07.267	KELISTRIKAN	98000.00	SUZ-KEL-LAM-7	2026-02-10 04:31:07.267	\N
cmlg3sk3b0004erj0eh7a76kf	LAMPU DEPAN SMASH 06	\N	0	SUZUKI	82000.00	LAMPU DEPAN / (SUZUKI)	2026-02-10 04:31:07.267	KELISTRIKAN	85000.00	SUZ-KEL-LAM-12	2026-02-10 04:31:07.267	\N
cmlg3skim0006erj052ta5r4b	LAMPU DEPAN SHOGUN 125 04	\N	0	SUZUKI	108000.00	LAMPU DEPAN / (SUZUKI)	2026-02-10 04:31:07.267	KELISTRIKAN	111000.00	SUZ-KEL-LAM-13	2026-02-10 04:31:07.267	\N
cmlg3sln1000aerj0a8a9zipr	MIKA LAMPU SPIN 09	\N	0	SUZUKI	58000.00	MIKA LAMPU / SUZUKI)	2026-02-10 04:31:07.267	KELISTRIKAN	61000.00	SUZ-KEL-MIK-18	2026-02-10 04:31:07.267	\N
cmlezwtgh00je39t5o3jam5nt	PANEL / TAMENGBEAT 20 BESAR BIRU MUDA	\N	0	HONDA	219000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	219000.00	HON-PAN-PAN-334	2026-06-19 22:06:22.273	01B5930574AA4
cmlezwtw300jx39t5u0da0bls	PANEL / TAMENGBEAT 20 BESAR PUTIH	\N	0	HONDA	240000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	194000.00	HON-PAN-PAN-336	2026-06-19 22:06:22.435	01B5930547AA4
cmlg3smhr000jerj0xzof96pi	MIKA LAMPU THUNDER	\N	0	SUZUKI	57000.00	MIKA LAMPU / SUZUKI)	2026-02-10 04:31:07.267	KELISTRIKAN	60000.00	SUZ-KEL-MIK-20	2026-02-10 04:31:07.267	\N
cmlg3smsf000qerj0j6dp2056	MIKA LAMPU SHOGUN 125 04	\N	0	SUZUKI	42000.00	MIKA LAMPU / SUZUKI)	2026-02-10 04:31:07.267	KELISTRIKAN	45000.00	SUZ-KEL-MIK-25	2026-02-10 04:31:07.267	\N
cmlg3soik0021erj09vu7wt7o	STOP LAMP ASSY SHOGUN 125 04	\N	0	SUZUKI	70000.00	STOP LAMP ASSY / (SUZUKI)	2026-02-10 04:31:07.268	KELISTRIKAN	73000.00	SUZ-KEL-STO-39	2026-02-10 04:31:07.268	\N
cmlg3soyf002derj0nj5bhbor	FRONT FENDER A SHOGUN 125 07 BIRU	\N	0	SUZUKI	85000.00	FRONT FENDER / SPAKBOR DEPAN (SUZUKI)	2026-02-10 04:31:07.268	BODY PART	88000.00	SUZ-BOD-FRO-54	2026-02-10 04:31:07.268	\N
cmlg3spbs002oerj0zobd0ruz	FRONT FENDER SATRIA FU 150 FI 16 HITAM	\N	0	SUZUKI	87000.00	FRONT FENDER / SPAKBOR DEPAN (SUZUKI)	2026-02-10 04:31:07.268	BODY PART	90000.00	SUZ-BOD-FRO-55	2026-02-10 04:31:07.268	\N
cmlg3spjg0030erj08ywq9lnk	FRONT FENDER SPIN PUTIH	\N	0	SUZUKI	68000.00	FRONT FENDER / SPAKBOR DEPAN (SUZUKI)	2026-02-10 04:31:07.268	BODY PART	71000.00	SUZ-BOD-FRO-52	2026-02-10 04:31:07.268	\N
cmlg3t0j0000lq2fk0u5bkhem	LAMPU DEPAN SATRIA FU 150 FI 16 + LED	\N	0	SUZUKI	516000.00	LAMPU DEPAN / (SUZUKI)	2026-02-10 04:31:27.23	KELISTRIKAN	519000.00	SUZ-KEL-LAM-5	2026-02-10 04:31:27.23	\N
cmlg4392z0021pv85riluq3c3	FRONT FENDER/SPAKBOR DEPAN MIO SOUL HIJAU	\N	0	YAMAHA	79000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.836	BODY PART	82000.00	YAM-BOD-FRO-202	2026-02-10 04:39:23.836	\N
cmlg439cl002cpv85kxn6eb7l	FRONT FENDER/SPAKBOR DEPAN R 15 NEW HITAM DOFF	\N	0	YAMAHA	122000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	125000.00	YAM-BOD-FRO-266	2026-02-10 04:39:23.839	\N
cmlg439k5002spv85iszkh05e	FRONT FENDER/SPAKBOR DEPAN R15 HITAM	\N	0	YAMAHA	96000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	99000.00	YAM-BOD-FRO-268	2026-02-10 04:39:23.839	\N
cmlg43d82005qpv856rryxmdo	PANEL MIO SOUL GT MERAH MAROON	\N	0	YAMAHA	85000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.554	BODY PART	88000.00	YAM-BOD-PAN-309	2026-02-10 04:39:33.554	\N
cmlezx2yv011x39t5cibo4rnf	COVER STOP / RR STOP SUPRA FIT NEW HITAM	\N	0	HONDA	23000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	77000.00	HON-COV-COV-694	2026-02-09 09:54:53.444	\N
cmlezwycn00rj39t5mcn4xhgp	PANEL / TAMENGGENIO HITAM	\N	0	HONDA	324000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	347000.00	HON-PAN-PAN-457	2026-06-18 17:22:17.168	\N
cmlezwvmw00m839t564xbpoq1	PANEL / TAMENGVARIO TECHNO 125 KECIL GRAY/DASI	\N	0	HONDA	84000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.184	LAIN-LAIN	90000.00	HON-PAN-PAN-404	2026-06-18 17:22:17.168	\N
cmlezx6qo017i39t58w3u5k8d	LAMPU DEPAN / HEAD LAMP CS-1	\N	0	HONDA	111000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	829000.00	HON-LAM-LAM-779	2026-02-09 09:54:56.89	\N
cmlezx6wj017y39t5lruwmheu	MIKA LAMPU VARIO 150	\N	0	HONDA	163000.00	MIKA LAMPU (HONDA)	2026-02-09 09:54:56.89	KELISTRIKAN	229000.00	HON-MIK-MIK-790	2026-02-09 09:54:56.89	\N
cmlezx7g1018r39t5vzms37xh	MIKA LAMPU BYSON	\N	0	HONDA	72000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	96000.00	HON-MIK-MIK-823	2026-02-09 09:55:01.489	\N
cmlg3skio0008erj0c5tvoz0l	LAMPU DEPAN SPIN 09	\N	0	SUZUKI	112000.00	LAMPU DEPAN / (SUZUKI)	2026-02-10 04:31:07.266	KELISTRIKAN	115000.00	SUZ-KEL-LAM-9	2026-02-10 04:31:07.266	\N
cmlg3sln1000berj0d4752qi1	LAMPU DEPAN SMASH	\N	0	SUZUKI	76000.00	LAMPU DEPAN / (SUZUKI)	2026-02-10 04:31:07.267	KELISTRIKAN	79000.00	SUZ-KEL-LAM-14	2026-02-10 04:31:07.267	\N
cmlg3smhr000ierj0i0o2zcrz	MIKA LAMPU SKYDRIVE	\N	0	SUZUKI	194000.00	MIKA LAMPU / SUZUKI)	2026-02-10 04:31:07.267	KELISTRIKAN	197000.00	SUZ-KEL-MIK-24	2026-02-10 04:31:07.267	\N
cmlg3smsg000rerj0fdefz06h	FRONT WINKER ASSY SHOGUN (C)	\N	0	SUZUKI	55000.00	FRONT WINKER / (SUZUKI)	2026-02-10 04:31:07.267	KELISTRIKAN	58000.00	SUZ-KEL-FRO-35	2026-02-10 04:31:07.267	\N
cmlg3sn5t0012erj04srvbhdh	MIKA SEN Rr + STOP SHOGUN (C/M) KO	\N	0	SUZUKI	22000.00	MIKA SEN Fr + Rr / SUZUKI)	2026-02-10 04:31:07.267	KELISTRIKAN	25000.00	SUZ-KEL-MIK-31	2026-02-10 04:31:07.267	\N
cmlg3sng90018erj0po95dgwv	MIKA LAMPU SATRIA FU 150 14	\N	0	SUZUKI	83000.00	MIKA LAMPU / SUZUKI)	2026-02-10 04:31:07.268	KELISTRIKAN	86000.00	SUZ-KEL-MIK-22	2026-02-10 04:31:07.268	\N
cmlg3snui001kerj0hmz3fqr5	MIKA SEN Fr NEW SHOGUN (P) KO	\N	0	SUZUKI	25000.00	MIKA SEN Fr + Rr / SUZUKI)	2026-02-10 04:31:07.268	KELISTRIKAN	28000.00	SUZ-KEL-MIK-27	2026-02-10 04:31:07.268	\N
cmlg3so7b001werj0112k3ogd	FRONT FENDER ADDRESS HITAM	\N	0	SUZUKI	78000.00	FRONT FENDER / SPAKBOR DEPAN (SUZUKI)	2026-02-10 04:31:07.268	BODY PART	81000.00	SUZ-BOD-FRO-47	2026-02-10 04:31:07.268	\N
cmlg3sopq0028erj0pdnsyffh	FRONT WINKER ASSY NEX	\N	0	SUZUKI	73000.00	FRONT WINKER / (SUZUKI)	2026-02-10 04:31:07.268	KELISTRIKAN	76000.00	SUZ-KEL-FRO-34	2026-02-10 04:31:07.268	\N
cmlg3sp73002kerj0qzz4mq94	FRONT FENDER NEW SHOGUN HITAM	\N	0	SUZUKI	75000.00	FRONT FENDER / SPAKBOR DEPAN (SUZUKI)	2026-02-10 04:31:07.268	BODY PART	78000.00	SUZ-BOD-FRO-62	2026-02-10 04:31:07.268	\N
cmlg3spe9002uerj0hlqglpyi	FRONT HANDLE COVER SATRIA FU 150 HITAM	\N	0	SUZUKI	92000.00	FRONT HANDLE / (SUZUKI)	2026-02-10 04:31:07.268	PENGEREMAN	95000.00	SUZ-PEN-FRO-66	2026-02-10 04:31:07.268	\N
cmlg3spmz0036erj0ks614e3g	FRONT FENDER NEX HITAM	\N	0	SUZUKI	76000.00	FRONT FENDER / SPAKBOR DEPAN (SUZUKI)	2026-02-10 04:31:07.269	BODY PART	79000.00	SUZ-BOD-FRO-57	2026-02-10 04:31:07.269	\N
cmlg3spz4003ierj0j54koapn	PANEL SHOGUN 125 04 HITAM	\N	0	SUZUKI	48000.00	PANEL / (SUZUKI)	2026-02-10 04:31:07.269	BODY PART	51000.00	SUZ-BOD-PAN-72	2026-02-10 04:31:07.269	\N
cmlg3sz6g000aq2fksqyv506j	LAMPU DEPAN NEW SHOGUN	\N	0	SUZUKI	54000.00	LAMPU DEPAN / (SUZUKI)	2026-02-10 04:31:27.23	KELISTRIKAN	57000.00	SUZ-KEL-LAM-15	2026-02-10 04:31:27.23	\N
cmlg3t0dz000iq2fk7ppy9cqu	COB LAMPU NEW SHOGUN	\N	0	SUZUKI	16000.00	COB LAMPU / (SUZUKI)	2026-02-10 04:31:27.231	KELISTRIKAN	19000.00	SUZ-KEL-COB-82	2026-02-10 04:31:27.231	\N
cmlg3t1fe000wq2fk4xjuys8d	UKURAN OLI NEW SHOGUN	\N	0	SUZUKI	13000.00	UKURAN OLI NEW / (SUZUKI)	2026-02-10 04:31:27.231	MESIN & OLI	16000.00	SUZ-MES-UKU-87	2026-02-10 04:31:27.231	\N
cmlg439es002ipv85jf66z7wi	FRONT FENDER/SPAKBOR DEPAN MIO BIRU MUDA (TELUR ASIN)	\N	0	YAMAHA	67000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.836	BODY PART	70000.00	YAM-BOD-FRO-205	2026-02-10 04:39:23.836	\N
cmlg43a0p003apv85i55qexgk	FRONT FENDER/SPAKBOR DEPAN FINO FI 18 HITAM	\N	0	YAMAHA	112000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	115000.00	YAM-BOD-FRO-263	2026-02-10 04:39:23.84	\N
cmlezwuq600l839t57yw5vbhk	PANEL / TAMENGVARIO 150 125 KECIL HITAM / DASI	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	58000.00	HON-PAN-PAN-389	2026-06-19 22:06:22.794	01B4434840AA1
cmlezwvo000mm39t5wvh4a99x	PANEL / TAMENGVARIO TECHNO 125 KECIL HITAM/DASI	\N	0	HONDA	70000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.184	LAIN-LAIN	76000.00	HON-PAN-PAN-403	2026-06-19 22:06:22.93	01B3634840AA1
cmlezwx4w00p439t5234guxcc	PANEL / TAMENGSCOOPY FI PUTIH	\N	0	HONDA	105000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	292000.00	HON-PAN-PAN-448	2026-06-19 22:06:23.065	01B4330547AA1
cmlezx85801a639t503a8vk57	MIKA LAMPU SMASH 06	\N	0	HONDA	45000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	96000.00	HON-MIK-MIK-820	2026-02-09 09:55:01.489	\N
cmlezx7g0018n39t53y3f1tvd	MIKA LAMPU ABSOLUTE REVO	\N	0	HONDA	57000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	60000.00	HON-MIK-MIK-803	2026-02-09 09:55:01.489	\N
cmlezx3bx012s39t5riq0dyht	FRONT HANDLE COVER / BATOK DEPAN BLADE 11 HITAM	\N	0	HONDA	141000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:53.444	BODY PART	153000.00	HON-FRO-FRO-604	2026-06-18 17:27:37.767	\N
cmlezx18j00xc39t5zukhrc77	FRONT HANDLE COVER / BATOK DEPAN SPACY HIJAU	\N	0	HONDA	67000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:53.443	BODY PART	119000.00	HON-FRO-FRO-602	2026-02-09 09:54:53.443	\N
cmlg3slt8000eerj0bw05u5p5	LAMPU DEPAN RC 100	\N	0	SUZUKI	64000.00	LAMPU DEPAN / (SUZUKI)	2026-02-10 04:31:07.266	KELISTRIKAN	67000.00	SUZ-KEL-LAM-11	2026-02-10 04:31:07.266	\N
cmlg3sn5q000zerj0egt9m73f	FRONT WINKER ASSY SATRIA	\N	0	SUZUKI	63000.00	FRONT WINKER / (SUZUKI)	2026-02-10 04:31:07.267	KELISTRIKAN	66000.00	SUZ-KEL-FRO-36	2026-02-10 04:31:07.267	\N
cmlg3snlk001derj0iu4800sm	FRONT WINKER ASSY TORNADO (P)	\N	0	SUZUKI	64000.00	FRONT WINKER / (SUZUKI)	2026-02-10 04:31:07.268	KELISTRIKAN	67000.00	SUZ-KEL-FRO-37	2026-02-10 04:31:07.268	\N
cmlg3so0k001oerj0ceb7hhhs	STOP LAMP ASSY SATRIA FU 150 14	\N	0	SUZUKI	89000.00	STOP LAMP ASSY / (SUZUKI)	2026-02-10 04:31:07.268	KELISTRIKAN	92000.00	SUZ-KEL-STO-38	2026-02-10 04:31:07.268	\N
cmlg3soik0020erj0my4syzj4	FRONT FENDER THUNDER 125 HITAM	\N	0	SUZUKI	73000.00	FRONT FENDER / SPAKBOR DEPAN (SUZUKI)	2026-02-10 04:31:07.268	BODY PART	76000.00	SUZ-BOD-FRO-58	2026-02-10 04:31:07.268	\N
cmlg3soyf002cerj0bgtyg3q0	FRONT FENDER SPIN HITAM	\N	0	SUZUKI	61000.00	FRONT FENDER / SPAKBOR DEPAN (SUZUKI)	2026-02-10 04:31:07.268	BODY PART	64000.00	SUZ-BOD-FRO-50	2026-02-10 04:31:07.268	\N
cmlg3spde002serj0wmx6uxb0	FRONT FENDER A SHOGUN 125 04 HITAM	\N	0	SUZUKI	50000.00	FRONT FENDER / SPAKBOR DEPAN (SUZUKI)	2026-02-10 04:31:07.268	BODY PART	53000.00	SUZ-BOD-FRO-61	2026-02-10 04:31:07.268	\N
cmlg3spl00032erj0utoaeu9w	FRONT HANDLE COVER SATRIA FU 150 MERAH	\N	0	SUZUKI	98000.00	FRONT HANDLE / (SUZUKI)	2026-02-10 04:31:07.268	PENGEREMAN	101000.00	SUZ-PEN-FRO-63	2026-02-10 04:31:07.268	\N
cmlg3spvb003eerj066h13ln2	BUNTUT Rr RC 100	\N	0	SUZUKI	16000.00	BUNTUT Rr / (SUZUKI)	2026-02-10 04:31:07.269	BODY PART	19000.00	SUZ-BOD-BUN-70	2026-02-10 04:31:07.269	\N
cmlg3t0j2000oq2fkczqg7xha	COVER BODY SHOGUN 125 07 HITAM	\N	0	SUZUKI	145000.00	COVER BODY/BODY SAMPING (SUZUKI)	2026-02-10 04:31:27.23	BODY PART	148000.00	SUZ-BOD-COV-2	2026-02-10 04:31:27.23	\N
cmlg3t1hn000yq2fkytn3a3mm	MIKA SPEEDOMETER SHOGUN 125 04	\N	0	SUZUKI	23000.00	MIKA SPEEDOMETER / (SUZUKI)	2026-02-10 04:31:27.231	KELISTRIKAN	26000.00	SUZ-KEL-MIK-75	2026-02-10 04:31:27.231	\N
cmlg439hs002kpv85wdf8vge7	FRONT FENDER/SPAKBOR DEPAN JUPITER MX 11 PUTIH	\N	0	YAMAHA	94000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.837	BODY PART	97000.00	YAM-BOD-FRO-212	2026-02-10 04:39:23.837	\N
cmlg43a40003gpv853wfdf3x1	FRONT FENDER/SPAKBOR DEPAN LEXI PUTIH	\N	0	YAMAHA	107000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	110000.00	YAM-BOD-FRO-281	2026-02-10 04:39:23.84	\N
cmlg43aif003ypv854lldvem9	FRONT FENDER/SPAKBOR DEPAN BYSON MERAH MAROON	\N	0	YAMAHA	82000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	85000.00	YAM-BOD-FRO-273	2026-02-10 04:39:23.84	\N
cmlg43avx0048pv85wgv33vrt	FRONT FENDER/SPAKBOR DEPAN NEW SHOGUN BIRU	\N	0	YAMAHA	83000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	86000.00	YAM-BOD-FRO-283	2026-02-10 04:39:23.841	\N
cmlg43azw004epv855j1ite8w	FRONT FORK COVER/COVER SOK DEPAN  JUPITER Z HITAM	\N	0	YAMAHA	51000.00	FRONT FORK COVER/COVER SOK DEPAN (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	54000.00	YAM-BOD-FRO-296	2026-02-10 04:39:23.841	\N
cmlg43b22004ipv85xe1068nq	FRONT FORK COVER/COVER SOK DEPAN  JUPITER Z 06 MERAH MAROON	\N	0	YAMAHA	57000.00	FRONT FORK COVER/COVER SOK DEPAN (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	60000.00	YAM-BOD-FRO-298	2026-02-10 04:39:23.841	\N
cmlg43b7h004ppv85w9rxzw1d	FRONT FORK COVER/COVER SOK DEPAN  F1Z-R HITAM	\N	0	YAMAHA	51000.00	FRONT FORK COVER/COVER SOK DEPAN (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	54000.00	YAM-BOD-FRO-299	2026-02-10 04:39:23.841	\N
cmlg43aaa003qpv85x1cjc9oq	REAR FENDER/SPAKBOR BELAKANG JUPITER Z 06	\N	0	YAMAHA	48000.00	REAR FENDER/SPAKBOR BELAKANG (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	51000.00	YAM-BOD-REA-287	2026-02-10 04:39:23.84	01D2333282AA1
cmlezx1lj00y939t5ru97qwzd	FRONT HANDLE COVER / BATOK DEPAN CB 150 R	\N	0	HONDA	127000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:53.444	BODY PART	119000.00	HON-FRO-FRO-609	2026-02-09 09:54:53.444	\N
cmlezx5hp015s39t5v08in9d8	LAMPU DEPAN / HEAD LAMP VERZA	\N	0	HONDA	165000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	182000.00	HON-LAM-LAM-776	2026-06-18 17:22:17.168	\N
cmlezx20000zg39t565ylip6n	REAR HANDLE / BATOK BELAKANG COVER BEAT POP	\N	0	HONDA	40000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	39000.00	HON-REA-REA-615	2026-02-09 09:54:53.444	\N
cmlezx2sd011k39t5204ccw3p	COVER STOP / RR STOP REVO FI / REVO X HITAM	\N	0	HONDA	42000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	77000.00	HON-COV-COV-693	2026-02-09 09:54:53.444	\N
cmlezx2y4011u39t5mbsxv0qe	COVER STOP / RR STOP VARIO 150 18 / 125 23 SILVER	\N	0	HONDA	120000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	77000.00	HON-COV-COV-666	2026-02-09 09:54:53.444	\N
cmlezx34r012c39t5bepg57u1	COVER STOP / RR STOP VERZA HITAM	\N	0	HONDA	39000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	129000.00	HON-COV-COV-698	2026-02-09 09:54:53.444	\N
cmlezx4oq014j39t5njtifjb5	COVER SPEEDOMETER SCOOPY 20 MERAH DOFF	\N	0	HONDA	63000.00	COVER SPEEDOMETER	2026-02-09 09:54:56.889	BODY PART	26000.00	HON-COV-COV-729	2026-02-09 09:54:56.889	\N
cmlezx6rb017m39t5hj55dx4n	MIKA LAMPU SCOOPY FI	\N	0	HONDA	93000.00	MIKA LAMPU (HONDA)	2026-02-09 09:54:56.89	KELISTRIKAN	136000.00	HON-MIK-MIK-797	2026-02-09 09:54:56.89	\N
cmlezx7g0018i39t5ck58kc46	MIKA LAMPU SUPRA X 125 HELM IN	\N	0	HONDA	59000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	47000.00	HON-MIK-MIK-812	2026-02-09 09:55:01.489	\N
cmlezx7mv019039t558sedswz	MIKA LAMPU REVO	\N	0	HONDA	50000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	229000.00	HON-MIK-MIK-804	2026-02-09 09:55:01.489	\N
cmlezx91n01cg39t5ty6fzhu7	MIKA SPEEDOMETER SMASH	\N	0	HONDA	23000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	26000.00	HON-MIK-MIK-859	2026-02-09 09:55:01.49	\N
cmlezx93301co39t5e0bp216y	MIKA LAMPU TIGER REVOLUTION 06	\N	0	HONDA	114000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	117000.00	HON-MIK-MIK-831	2026-02-09 09:55:01.49	\N
cmlezx3a0012q39t56rynt3ci	REAR HANDLE / BATOK BELAKANG COVER VARIO 110 FI	\N	0	HONDA	39000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	52000.00	HON-REA-REA-620	2026-06-18 17:22:17.168	\N
cmlezx9jk01dp39t57q58z836	MIKA LAMPU BLADE 11 + ACSESORIS	\N	0	HONDA	78000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	81000.00	HON-MIK-MIK-816	2026-02-09 09:55:01.49	\N
cmlezwwzg00oy39t5rih9qyg9	PANEL / TAMENGIMPRESSA HITAM	\N	0	HONDA	33000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	324000.00	HON-PAN-PAN-478	2026-06-19 22:06:23.198	01B0930540AA1
cmlezwxwx00qq39t558pe52fi	PANEL DEPAN BAGIAN BAWAH VARIO	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	82000.00	HON-PAN-PAN-493	2026-06-19 22:06:23.334	01B2235182AA1
cmlezxay901fx39t5xxvsodid	MIKA STOP / MIKA BELAKANG SUPRA FIT NEW (M)	\N	0	HONDA	27000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	30000.00	HON-MIK-MIK-943	2026-02-09 09:55:04.847	\N
cmlezxco801jw39t5t0s1odke	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT SCOOPY FI 17	\N	0	HONDA	139000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.264	KELISTRIKAN	154000.00	HON-STO-STO-1019	2026-06-18 17:22:17.168	\N
cmlezx82x019y39t58wkbcdw4	MIKA LAMPU SPACY	\N	0	HONDA	49000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	341000.00	HON-MIK-MIK-827	2026-02-09 09:55:01.489	\N
cmlezxdec01lm39t5yjl3u3ph	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT REVO	\N	0	HONDA	84000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	92000.00	HON-STO-STO-1029	2026-06-18 17:22:17.168	\N
cmlezxd1o01ks39t56dv3ac56	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT PRIMA (C/M)	\N	0	HONDA	90000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	101000.00	HON-STO-STO-1045	2026-06-18 17:22:17.168	\N
cmlezxfts01re39t55i7hvm6s	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM VARIO 150 18 KECIL GRAY DOFF/KUPU KUPU	\N	0	HONDA	123000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	133000.00	HON-LEG-LEG-1163	2026-06-18 17:22:17.168	\N
cmlezxc7w01j639t5sui50yzq	Fr / Rr WINKER ASSY TIGER REVOLUTION	\N	0	HONDA	72000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	75000.00	HON-FRO-FRR-991	2026-02-09 09:55:04.848	\N
cmlezxcvo01k639t5v5u1k2a9	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT SMASH 06	\N	0	HONDA	96000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	99000.00	HON-STO-STO-1040	2026-02-09 09:55:08.265	\N
cmlezx8av01ae39t5f19a51zc	MIKA SPEEDOMETER VARIO 150	\N	0	HONDA	37000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	51000.00	HON-MIK-MIK-839	2026-06-18 17:22:17.168	\N
cmlezxdqq01mi39t57rhf4iho	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT REVO FI / REVO X	\N	0	HONDA	148000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	151000.00	HON-STO-STO-1026	2026-02-09 09:55:08.265	\N
cmlezx8hz01aw39t5n0stxi63	MIKA SEN Rr / MIKA SEN BELAKANG BEAT ESP 16	\N	0	HONDA	38000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	79000.00	HON-MIK-MIK-863	2026-02-09 09:55:01.49	\N
cmlezx8ou01bm39t5zada59ic	MIKA SEN Fr / MIKA SEN DEPAN  VARIO TECHNO	\N	0	HONDA	33000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	94000.00	HON-MIK-MIK-882	2026-02-09 09:55:01.49	\N
cmlezwxmy00q639t5ppqmuemm	PANEL DEPAN BAGIAN BAWAH VARIO 160	\N	0	HONDA	55000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	62000.00	HON-PAN-PAN-488	2026-06-18 17:27:37.767	01B6435182AA1
cmlezx1sc00yq39t5074f7l1b	COVER STOP / RR STOP BEAT 20	\N	0	HONDA	21000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	18000.00	HON-COV-COV-644	2026-06-18 17:19:42.083	\N
cmlezx4y0014q39t5yjst84zq	LAMPU DEPAN / HEAD LAMP CB 150 VERZA	\N	0	HONDA	162000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	182000.00	HON-LAM-LAM-752	2026-06-18 17:27:37.767	\N
cmlezxh1u01u039t5nvvqcu1v	LEGSHIELD TENGAH GRAND MERAH	\N	0	HONDA	73000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.247	BODY PART	76000.00	HON-LEG-LEG-1193	2026-02-09 09:55:11.247	\N
cmlezx2bq010839t5rji7qkb1	COVER STOP / RR STOP VARIO 150 HITAM	\N	0	HONDA	34000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	129000.00	HON-COV-COV-648	2026-02-09 09:54:53.444	\N
cmlezwxkf00pz39t5ri6a6th3	PANEL DEPAN BAGIAN BAWAH VARIO 150 18	\N	0	HONDA	82000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	88000.00	HON-PAN-PAN-485	2026-06-18 17:22:17.168	01B5235182AA1
cmlezx4no014b39t5qzpjiqe8	LAMPU DEPAN / HEAD LAMP VARIO 160 + LED	\N	0	HONDA	1009000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	138000.00	HON-LAM-LAM-742	2026-06-18 17:22:17.168	\N
cmlezx2mw011839t5ux7d37pd	REAR HANDLE / BATOK BELAKANG COVER SMASH 06	\N	0	HONDA	27000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	48000.00	HON-REA-REA-639	2026-02-09 09:54:53.444	\N
cmlezxbcm01gw39t5h7xrnqvl	MIKA STOP / MIKA BELAKANG SUPRA X 125 07 (M)	\N	0	HONDA	32000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	35000.00	HON-MIK-MIK-937	2026-02-09 09:55:04.847	\N
cmlezx31z012439t5phybi4rz	COVER STOP / RR STOP SUPRA HITAM	\N	0	HONDA	22000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	129000.00	HON-COV-COV-696	2026-02-09 09:54:53.444	\N
cmlezxc4701iy39t52grsxp4o	Fr / Rr WINKER ASSY TIGER CHROOM VARIASI	\N	0	HONDA	42000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	45000.00	HON-FRO-FRR-992	2026-02-09 09:55:04.848	\N
cmlezxcu801k039t5qwt5c38j	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT SCOOPY FI	\N	0	HONDA	104000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	107000.00	HON-STO-STO-1018	2026-02-09 09:55:08.265	\N
cmlezxczm01ki39t501k71qow	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT CB 150 VERZA	\N	0	HONDA	133000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	136000.00	HON-STO-STO-1042	2026-02-09 09:55:08.265	\N
cmlezxd4a01kv39t5t3jxnsxc	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT BEAT	\N	0	HONDA	114000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	117000.00	HON-STO-STO-1005	2026-02-09 09:55:08.265	\N
cmlezxdem01lq39t5n58k5yp2	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT SCOOPY FI	\N	0	HONDA	73061.18	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	76061.18	HON-STO-STO-1015	2026-02-09 09:55:08.265	\N
cmlezx4en013y39t5n1kxhj2y	COVER TANGKI / COVER MESIN SUPRA FIT NEW	\N	0	HONDA	122000.00	COVER TANGKI / COVER MESIN VARIO 110 FI	2026-02-09 09:54:56.889	BODY PART	24000.00	HON-COV-COV-722	2026-02-09 09:54:56.889	\N
cmlezxe2h01ng39t55um7u7qc	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT SCOOPY (M)	\N	0	HONDA	70297.08	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.266	KELISTRIKAN	73297.08	HON-STO-STO-1017	2026-02-09 09:55:08.266	\N
cmlezxepa01p039t5u7nlcpdi	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT MEGAPRO (M)	\N	0	HONDA	81000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.266	KELISTRIKAN	84000.00	HON-STO-STO-1035	2026-02-09 09:55:08.266	\N
cmlezx4yp014v39t5srmftyoi	LAMPU DEPAN / HEAD LAMP CB 150 R	\N	0	HONDA	197000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	829000.00	HON-LAM-LAM-753	2026-02-09 09:54:56.889	\N
cmlezx58i015839t5mhqm3pmq	LAMPU DEPAN / HEAD LAMP SCOOPY FI	\N	0	HONDA	492000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	627000.00	HON-LAM-LAM-746	2026-02-09 09:54:56.889	\N
cmlezx5p7016239t56wsoqiex	LAMPU DEPAN / HEAD LAMP ASSY BEAT	\N	0	HONDA	96000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	829000.00	HON-LAM-LAM-732	2026-02-09 09:54:56.89	\N
cmlezx9fd01dc39t5bgeplxm9	MIKA LAMPU KARISMA	\N	0	HONDA	41000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	44000.00	HON-MIK-MIK-832	2026-02-09 09:55:01.49	\N
cmlezwy5y00r439t5vyffhcnm	PANEL DEPAN BAGIAN BAWAH SCOOPY FI 17	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	91000.00	HON-PAN-PAN-496	2026-06-19 22:06:23.749	01B4835182AA1
cmlezwy0400r039t52kxetem4	PANEL DEPAN BAGIAN BAWAH SCOOPY FI / ESP	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	106000.00	HON-PAN-PAN-498	2026-06-19 22:06:23.886	01B4335182AA1
cmlezxc7z01j839t5y2ypmzwu	Fr / Rr WINKER ASSY MEGAPRO 06	\N	0	HONDA	89000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	92000.00	HON-FRO-FRR-997	2026-02-09 09:55:04.848	\N
cmlezxco801jr39t5cuabbx0c	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT BEAT FI	\N	0	HONDA	132000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.264	KELISTRIKAN	135000.00	HON-STO-STO-1008	2026-02-09 09:55:08.264	\N
cmlezxcx401ke39t5dddsbaw4	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT MEGAPRO 06	\N	0	HONDA	95000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	98000.00	HON-STO-STO-1034	2026-02-09 09:55:08.265	\N
cmlezx6sk017s39t5qi2mo2rh	MIKA LAMPU SCOOPY	\N	0	HONDA	82000.00	MIKA LAMPU (HONDA)	2026-02-09 09:54:56.89	KELISTRIKAN	153000.00	HON-MIK-MIK-798	2026-06-18 17:22:17.168	\N
cmlezx8i001b039t5pgwfqmqm	MIKA SEN Fr / MIKA SEN DEPAN  BEAT POP	\N	0	HONDA	32000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	49000.00	HON-MIK-MIK-876	2026-06-18 17:22:17.168	\N
cmlezx8aw01ah39t5uerimvsm	MIKA LAMPU SMASH	\N	0	HONDA	43000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	96000.00	HON-MIK-MIK-821	2026-02-09 09:55:01.489	\N
cmlezxd4u01ky39t5lb1v95o4	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT ABSOLUTE REVO	\N	0	HONDA	121000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	131000.00	HON-STO-STO-1028	2026-06-18 17:22:17.168	\N
cmlezxge901sr39t54tiulnj6	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM VARIO 150 18 KECIL SILVER	\N	0	HONDA	136000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	146000.00	HON-LEG-LEG-1177	2026-06-18 17:22:17.168	\N
cmlezxenc01ou39t541hk2jfb	STOP LAMP UNIT GL PRO (M)	\N	0	HONDA	60000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.266	KELISTRIKAN	63000.00	HON-STO-STO-1037	2026-02-09 09:55:08.266	\N
cmlezx5s2016a39t5188j23l9	LAMPU DEPAN / HEAD LAMP SUPRA X	\N	0	HONDA	61000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	61000.00	HON-LAM-LAM-764	2026-06-18 17:22:17.168	\N
cmlezx2rt011h39t5uv19btuu	COVER STOP / RR STOP VARIO PINK	\N	0	HONDA	29000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	38000.00	HON-COV-COV-661	2026-02-09 09:54:53.444	\N
cmlezx6kd017c39t541rw0ra1	MIKA LAMPU VARIO	\N	0	HONDA	61000.00	MIKA LAMPU (HONDA)	2026-02-09 09:54:56.89	KELISTRIKAN	255000.00	HON-MIK-MIK-794	2026-06-18 17:22:17.168	\N
cmlezxd1d01km39t5b9v6fcx5	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT KARISMA (P/M)	\N	0	HONDA	74000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	85000.00	HON-STO-STO-1043	2026-06-18 17:22:17.168	\N
cmlezxcvo01k739t5q0vrj1jj	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT ABSOLUTE REVO	\N	0	HONDA	69375.72	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	72375.72	HON-STO-STO-1027	2026-02-09 09:55:08.265	\N
cmlezx1xc00z639t5pf183wj8	COVER STOP / RR STOP VARIO 150 HITAM DOFF	\N	0	HONDA	34000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	130000.00	HON-COV-COV-656	2026-06-18 17:22:17.168	\N
cmlezx2yv011w39t56kqtcx1n	COVER STOP / RR STOP SUPRA X 125 HITAM	\N	0	HONDA	25000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	129000.00	HON-COV-COV-695	2026-02-09 09:54:53.444	\N
cmlezx36j012g39t57efp7pmu	COVER STOP / RR STOP GRAND + DASI HITAM	\N	0	HONDA	21000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	38000.00	HON-COV-COV-700	2026-02-09 09:54:53.444	\N
cmlezx4bz013s39t5lxup26wz	COVER SPEEDOMETER SCOOPY 20 HITAM	\N	0	HONDA	56000.00	COVER SPEEDOMETER	2026-02-09 09:54:56.889	BODY PART	26000.00	HON-COV-COV-727	2026-02-09 09:54:56.889	\N
cmlezx5cj015i39t5t0agcs87	LAMPU DEPAN / HEAD LAMP BLADE	\N	0	HONDA	95000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	829000.00	HON-LAM-LAM-768	2026-02-09 09:54:56.889	\N
cmlezwxt500qm39t543y93r5t	PANEL DEPAN BAGIAN BAWAH SCOOPY	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	87000.00	HON-PAN-PAN-495	2026-06-18 17:27:37.767	01B3135182AA1
cmlezwxol00q839t5ntxf9jnm	PANEL DEPAN BAGIAN BAWAH VARIO TECHNO	\N	0	HONDA	55000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	60000.00	HON-PAN-PAN-489	2026-06-18 17:27:37.767	01B22935182AA1
cmlezwz7g00t239t5qsgpotuq	FRONT HANDLE COVER / BATOK DEPAN VARIO 160 + ACC HITAM	\N	0	HONDA	147000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	173000.00	HON-FRO-FRO-536	2026-06-18 17:27:37.767	\N
cmlezx04y00vi39t5sd4n7w8f	FRONT HANDLE COVER / BATOK DEPAN A SCOOPY 20 HITAM	\N	0	HONDA	88000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	97000.00	HON-FRO-FRO-571	2026-06-18 17:27:37.767	01B6230340AA1
cmlezxhwt01us39t5v22iipyk	FOOOTREST / PINJEKAN KAKI	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	0.00	HON-LEG-FOO-1202	2026-02-09 09:55:15.054	\N
9ad79f8a-57e1-40eb-bf24-85c94b7be0e2	COVER STOP / RR STOP VARIO 160 HITAM	\N	0	HONDA	85000.00	COVER STOP	2026-06-18 17:27:37.767	BODY PART	85000.00	HON-COV-1807	2026-06-18 17:35:37.871	\N
eb82b56a-2d56-47d0-b835-bc70f50456b8	COVER STOP / RR STOP VARIO 160 MERAH DOFF	\N	0	HONDA	93000.00	COVER STOP	2026-06-18 17:27:37.767	BODY PART	93000.00	HON-COV-1808	2026-06-18 17:35:37.871	\N
5a1780ab-7c18-47aa-94eb-4338f56c9fd1	COVER STOP / RR STOP SCOOPY 20 BESAR HITAM	\N	0	HONDA	125000.00	COVER STOP	2026-06-18 17:27:37.767	BODY PART	125000.00	HON-COV-1809	2026-06-18 17:35:37.871	\N
10adfcba-90ac-4a0a-b4fd-6936a278b1f6	COVER STOP / RR STOP SCOOPY 20 BESAR KREM	\N	0	HONDA	150000.00	COVER STOP	2026-06-18 17:27:37.767	BODY PART	150000.00	HON-COV-1810	2026-06-18 17:35:37.871	\N
6efed1b8-b3ed-4214-bc37-4a7d9d4570d5	COVER STOP / RR STOP SCOOPY 20 BESAR GRAY DOFF	\N	0	HONDA	150000.00	COVER STOP	2026-06-18 17:27:37.767	BODY PART	150000.00	HON-COV-1811	2026-06-18 17:35:37.871	\N
9eddb380-04f5-44cd-b8a3-507d09f35f85	COVER STOP / RR STOP SCOOPY 20 BESAR MERAH DOFF	\N	0	HONDA	150000.00	COVER STOP	2026-06-18 17:27:37.767	BODY PART	150000.00	HON-COV-1812	2026-06-18 17:35:37.871	\N
cmlezx7gw018u39t5kiiirnqp	MIKA LAMPU PCX 150 18	\N	0	HONDA	276000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	341000.00	HON-MIK-MIK-802	2026-02-09 09:55:01.489	\N
cmlezx04z00vm39t5zihmalsc	FRONT HANDLE COVER / BATOK DEPAN A SCOOPY 20 GRAY DOFF	\N	0	HONDA	104000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	114000.00	HON-FRO-FRO-572	2026-06-18 17:27:37.767	\N
cmlezx8bm01am39t5921nh9mx	MIKA SPEEDOMETER SUPRA X 125 HELM IN	\N	0	HONDA	27000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	32000.00	HON-MIK-MIK-857	2026-06-18 17:27:37.767	\N
44653e4d-470c-42aa-9318-bf6fc76e6660	COVER STOP / RR STOP SCOOPY 20 BESAR PUTIH DOFF	\N	0	HONDA	150000.00	COVER STOP	2026-06-18 17:27:37.767	BODY PART	150000.00	HON-COV-1813	2026-06-18 17:35:37.871	\N
cmlezwxpx00qc39t5t5mlys2i	PANEL DEPAN BAGIAN BAWAH BEAT 20 / BEAT STREET 20	\N	0	HONDA	77000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	82000.00	HON-PAN-PAN-491	2026-06-19 22:06:24.163	01B5935182AA1
cmlezwy2q00r239t5ys0fo8uc	PANEL DEPAN BAGIAN BAWAH BEAT POP	\N	0	HONDA	63000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	68000.00	HON-PAN-PAN-490	2026-06-19 22:06:24.299	01B4035182AA1
cmlezwxpx00qe39t54cinwunu	PANEL DEPAN BAGIAN BAWAH VARIO TECHNO 125	\N	0	HONDA	80000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	86000.00	HON-PAN-PAN-487	2026-06-19 22:06:24.436	01B3635182AA1
cmlezx1xa00z339t5wjqmsxzl	FRONT HANDLE COVER / BATOK DEPAN GRAND / IMPRESSA HITAM	\N	0	HONDA	53000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:53.444	BODY PART	119000.00	HON-FRO-FRO-610	2026-06-19 22:06:24.573	01B0830040AA1
02911274-d0c0-4d89-a584-e4e924e63d9e	COVER STOP / RR STOP SCOOPY 20 KECIL HITAM	\N	0	HONDA	69000.00	COVER STOP	2026-06-18 17:27:37.767	BODY PART	69000.00	HON-COV-1814	2026-06-18 17:35:37.871	\N
f5620461-c256-41c0-a390-bd875bfa0bd4	COVER STOP / RR STOP SCOOPY 20 KECIL GRAY DOFF	\N	0	HONDA	85000.00	COVER STOP	2026-06-18 17:27:37.767	BODY PART	85000.00	HON-COV-1815	2026-06-18 17:35:37.871	\N
cmlezxc4701ix39t5pzjp5jtc	Fr / Rr WINKER ASSY TIGER DE (P)	\N	0	HONDA	47000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	50000.00	HON-FRO-FRR-990	2026-02-09 09:55:04.848	\N
cmlezxco801ju39t50ejmdmjt	Fr / Rr WINKER ASSY GL PRO (C)	\N	0	HONDA	51000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.264	LAIN-LAIN	54000.00	HON-FRO-FRR-1003	2026-02-09 09:55:08.264	\N
cmlezxcx601kg39t5vo5hy2h9	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT VARIO TECHNO	\N	0	HONDA	124000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	127000.00	HON-STO-STO-1012	2026-02-09 09:55:08.265	\N
cmlezxd4w01l039t52mckx9e1	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT SUPRA X 125 (P/M)	\N	0	HONDA	102000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	105000.00	HON-STO-STO-1023	2026-02-09 09:55:08.265	\N
cmlezx83z01a439t52sb7pcix	MIKA SEN Fr / MIKA SEN DEPAN  BEAT FI	\N	0	HONDA	33000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.489	LAIN-LAIN	32000.00	HON-MIK-MIK-868	2026-02-09 09:55:01.489	\N
cmlezxdg601lu39t5seztyznt	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT SUPRA FIT NEW	\N	0	HONDA	89000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	92000.00	HON-STO-STO-1025	2026-02-09 09:55:08.265	\N
cmlezx3yf013a39t5qg6dgqtq	COVER TANGKI / COVER MESIN BEAT ESP 16	\N	0	HONDA	31000.00	COVER TANGKI / COVER MESIN (HONDA)	2026-02-09 09:54:56.889	BODY PART	45000.00	HON-COV-COV-705	2026-06-18 17:19:42.083	\N
cmlezx2f8010e39t5xyvkvuam	REAR HANDLE / BATOK BELAKANG COVER GENIO MERAH	\N	0	HONDA	62000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	39000.00	HON-REA-REA-638	2026-02-09 09:54:53.444	\N
cmlezxgxw01ts39t5c2norbig	LEGSHIELD TENGAH /	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.247	BODY PART	0.00	HON-LEG-LEG-1191	2026-02-09 09:55:11.247	\N
c11cdeac-1dad-4e87-857d-95e8a1036959	COVER STOP / RR STOP SCOOPY 20 KECIL MERAH DOFF	\N	0	HONDA	85000.00	COVER STOP	2026-06-18 17:27:37.767	BODY PART	85000.00	HON-COV-1816	2026-06-18 17:35:37.871	\N
cmlezx5p7016339t5ibgwrlms	LAMPU DEPAN / HEAD LAMP SPACY	\N	0	HONDA	93000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	153000.00	HON-LAM-LAM-777	2026-06-18 17:22:17.168	\N
cmlezxd1g01kq39t5271hao09	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT VARIO 150 18 / 125 23 + LED	\N	0	HONDA	293000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	212000.00	HON-STO-STO-1013	2026-06-18 17:22:17.168	\N
cmlezxe8x01o039t5bs3uniff	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT BLADE 11	\N	0	HONDA	91000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.266	KELISTRIKAN	99000.00	HON-STO-STO-1032	2026-06-18 17:22:17.168	\N
cmlezxcvo01kc39t53pxbi6wj	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT SUPRA X 125 07	\N	0	HONDA	107000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	121000.00	HON-STO-STO-1021	2026-06-18 17:22:17.168	\N
cmlezxc7e01j239t5cx9wlt7m	Fr / Rr WINKER ASSY CB 150 VERZA	\N	0	HONDA	96000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	99000.00	HON-FRO-FRR-993	2026-02-09 09:55:04.848	\N
cmlezxco801ji39t59kqbifzh	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT BEAT 20	\N	0	HONDA	144000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.264	KELISTRIKAN	147000.00	HON-STO-STO-1004	2026-02-09 09:55:08.264	\N
cmlezx32o012839t5s76mt2ol	COVER STOP / RR STOP VARIO 160 HITAM	\N	0	HONDA	77000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	77000.00	HON-COV-COV-651	2026-06-18 17:22:17.168	\N
cmlezx2vy011s39t5gunmqwtw	COVER STOP / RR STOP VARIO 150 18 / 125 23 GRAY DOFF	\N	0	HONDA	103000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	77000.00	HON-COV-COV-650	2026-02-09 09:54:53.444	\N
cmlezx38y012m39t5avethvq8	COVER STOP / RR STOP VARIO 150 18 / 125 23 HITAM	\N	0	HONDA	103000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	129000.00	HON-COV-COV-652	2026-02-09 09:54:53.444	\N
cmlezx4oq014h39t57od2nq3f	LAMPU DEPAN / HEAD LAMP ASSY VARIO TECHNO 125	\N	0	HONDA	175000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	829000.00	HON-LAM-LAM-744	2026-02-09 09:54:56.889	\N
cmlezxeks01os39t5e9rtmf3o	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT BLADE 12	\N	0	HONDA	71218.45	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.266	KELISTRIKAN	74218.45	HON-STO-STO-1033	2026-02-09 09:55:08.266	\N
cmlezx4yp014s39t54u0cgbig	COVER TANGKI / COVER MESIN BLADE 125 FI	\N	0	HONDA	23000.00	COVER TANGKI / COVER MESIN VARIO 110 FI	2026-02-09 09:54:56.889	BODY PART	45000.00	HON-COV-COV-724	2026-02-09 09:54:56.889	\N
cmlezx67k016x39t5jys750db	MIKA LAMPU BEAT FI	\N	0	HONDA	54000.00	MIKA LAMPU (HONDA)	2026-02-09 09:54:56.89	KELISTRIKAN	47000.00	HON-MIK-MIK-786	2026-02-09 09:54:56.89	\N
cmlezx7g1018q39t5197doepc	MIKA LAMPU BLADE	\N	0	HONDA	49000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	28000.00	HON-MIK-MIK-817	2026-02-09 09:55:01.489	\N
cmlezx7my019239t5h8barhh7	MIKA LAMPU SUPRA X 125	\N	0	HONDA	59000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	341000.00	HON-MIK-MIK-808	2026-02-09 09:55:01.489	\N
cmlezx99r01d639t5lt02wxyt	MIKA SEN Fr / MIKA SEN DEPAN  SUPRA X 125 07	\N	0	HONDA	23000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	32000.00	HON-MIK-MIK-900	2026-02-09 09:55:01.49	\N
cmlezx46j013k39t5oj05dwpf	COVER TANGKI / COVER MESIN SCOOPY FI KREM	\N	0	HONDA	137000.00	COVER TANGKI / COVER MESIN VARIO 110 FI	2026-02-09 09:54:56.889	BODY PART	154000.00	HON-COV-COV-713	2026-06-18 17:22:17.168	\N
cmlezx3x5013439t5cfiapxgg	COVER TANGKI / COVER MESIN SCOOPY FI MERAH	\N	0	HONDA	137000.00	COVER TANGKI / COVER MESIN VARIO 110 FI	2026-02-09 09:54:56.889	BODY PART	154000.00	HON-COV-COV-714	2026-06-18 17:22:17.168	\N
cmlezx71b018c39t580lrde17	COVER TANGKI / COVER MESIN VARIO 150 18	\N	0	HONDA	42000.00	COVER TANGKI / COVER MESIN (HONDA)	2026-02-09 09:54:56.89	BODY PART	49000.00	HON-COV-COV-706	2026-06-18 17:22:17.168	\N
cmlezx6i6017a39t5l1vayxob	LAMPU DEPAN / HEAD LAMP MEGAPRO 10	\N	0	HONDA	143000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	109000.00	HON-LAM-LAM-771	2026-06-18 17:22:17.168	\N
cmlezxc4701iw39t565zg8dae	Fr / Rr WINKER ASSY NEW CBR 150 17 + LED	\N	0	HONDA	100000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	103000.00	HON-FRO-FRR-994	2026-02-09 09:55:04.848	\N
cmlezwz6o00su39t51uwq1oxl	FRONT HANDLE COVER / BATOK DEPAN BEAT FI ESP BIRU MUDA	\N	0	HONDA	105000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	115000.00	HON-FRO-FRO-514	2026-06-19 22:06:25.312	01B4530074AA1
cmlezwyqm00s239t5q8qtwtgn	FRONT HANDLE COVER / BATOK DEPAN BEAT FI ESP MERAH MAROON	\N	0	HONDA	104000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	115000.00	HON-FRO-FRO-513	2026-06-19 22:06:25.561	01B4530052AA1
cmlezwz4200sq39t50eeiiyzo	FRONT HANDLE COVER / BATOK DEPAN BEAT FI ESP MERAH MAROON	\N	0	HONDA	105000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	115000.00	HON-FRO-FRO-533	2026-06-19 22:06:25.868	01B4530052AA1
cmlezxcbb01je39t51s01xn4u	Fr / Rr WINKER ASSY MEGAPRO	\N	0	HONDA	73000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	76000.00	HON-FRO-FRR-998	2026-02-09 09:55:04.848	\N
cmlezxcur01k439t51hz1syp9	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT SUPRA FIT	\N	0	HONDA	74000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	77000.00	HON-STO-STO-1020	2026-02-09 09:55:08.265	\N
cmlezxd7a01la39t5261rt7fg	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT SUPRA X (P/M)	\N	0	HONDA	84000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	87000.00	HON-STO-STO-1024	2026-02-09 09:55:08.265	\N
cmlezx8nv01bf39t5jdpctlwy	MIKA SEN Rr / MIKA SEN BELAKANG + STOP BEAT 20 (SMOKE)	\N	0	HONDA	79000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	79000.00	HON-MIK-MIK-864	2026-02-09 09:55:01.49	\N
cmlezxdqq01mj39t58y99vsjj	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT SCOOPY (M)	\N	0	HONDA	75000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	78000.00	HON-STO-STO-1016	2026-02-09 09:55:08.265	\N
cmlezxdwc01my39t5xlenkwmf	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT GRAND SABIT (M)	\N	0	HONDA	54000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	57000.00	HON-STO-STO-1031	2026-02-09 09:55:08.265	\N
cmlezx31z012639t5n50ab1uw	COVER STOP / RR STOP SUPRA X 125 14 HITAM	\N	0	HONDA	67000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	88000.00	HON-COV-COV-697	2026-02-09 09:54:53.444	\N
cmlezx450013f39t5lgi876qx	COVER TANGKI / COVER MESIN REVO FI / REVO X	\N	0	HONDA	26000.00	COVER TANGKI / COVER MESIN VARIO 110 FI	2026-02-09 09:54:56.889	BODY PART	45000.00	HON-COV-COV-725	2026-02-09 09:54:56.889	\N
cmlezx64e016q39t5jvo14ugn	MIKA LAMPU BEAT	\N	0	HONDA	45000.00	MIKA LAMPU (HONDA)	2026-02-09 09:54:56.89	KELISTRIKAN	92000.00	HON-MIK-MIK-785	2026-02-09 09:54:56.89	\N
cmlezx70k018839t5lwkdaci3	LAMPU DEPAN / HEAD LAMP PCX 150 18 + LED	\N	0	HONDA	2098000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	829000.00	HON-LAM-LAM-751	2026-02-09 09:54:56.89	\N
cmlezwzyh00v039t5zhj4z55w	FRONT HANDLE COVER / BATOK DEPAN A SCOOPY FI HITAM	\N	0	HONDA	75000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	82000.00	HON-FRO-FRO-562	2026-06-18 17:22:17.168	\N
cmlezwzyv00v439t5i03n4dnk	FRONT HANDLE COVER / BATOK DEPAN A SCOOPY FI MERAH	\N	0	HONDA	82000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	90000.00	HON-FRO-FRO-563	2026-06-18 17:22:17.168	\N
cmlezx04y00vj39t5t45kxwej	FRONT HANDLE COVER / BATOK DEPAN B SCOOPY FI KREM	\N	0	HONDA	87000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	95000.00	HON-FRO-FRO-565	2026-06-18 17:22:17.168	\N
cmlezxb3b01g839t5mgr1hemj	MIKA STOP / MIKA BELAKANG SUPRA X 125 07 (P)	\N	0	HONDA	39000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	42000.00	HON-MIK-MIK-944	2026-02-09 09:55:04.847	\N
cmlezx4oq014e39t5sdzkpnvi	LAMPU DEPAN / HEAD LAMP VARIO 150 + LED	\N	0	HONDA	734000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	571000.00	HON-LAM-LAM-737	2026-06-18 17:22:17.168	\N
cmlezx85801a739t596xrz1wa	MIKA SEN Rr / MIKA SEN BELAKANG + STOP BEAT	\N	0	HONDA	59000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.489	LAIN-LAIN	61000.00	HON-MIK-MIK-869	2026-06-18 17:22:17.168	\N
cmlezx38o012k39t5581352wg	COVER STOP / RR STOP SCOOPY FI 17 MERAH DOFF	\N	0	HONDA	116000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	116000.00	HON-COV-COV-667	2026-02-09 09:54:53.444	\N
cmlezxc3g01iu39t5lipi3hmb	Fr / Rr WINKER ASSY TIGER	\N	0	HONDA	58000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	61000.00	HON-FRO-FRR-989	2026-02-09 09:55:04.848	\N
cmlezxco801jl39t5wq9lvzlr	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT BEAT FI	\N	0	HONDA	72139.81	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.264	KELISTRIKAN	75139.81	HON-STO-STO-1007	2026-02-09 09:55:08.264	\N
cmlezxcvo01k839t5x3m7yexm	STOP LAMP UNIT GENIO	\N	0	HONDA	66000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	69000.00	HON-STO-STO-1041	2026-02-09 09:55:08.265	\N
cmlezxd1g01ko39t5nocd1pog	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT SUPRA (O/M)	\N	0	HONDA	62000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	65000.00	HON-STO-STO-1022	2026-02-09 09:55:08.265	\N
cmlezxd7a01l639t5vj9oa9mq	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT BEAT ESP 16	\N	0	HONDA	151000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	154000.00	HON-STO-STO-1006	2026-02-09 09:55:08.265	\N
cmlezxepa01oy39t58gha9wwl	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT SMASH (P/M)	\N	0	HONDA	70000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.266	KELISTRIKAN	73000.00	HON-STO-STO-1039	2026-02-09 09:55:08.266	\N
cmlezx33k012a39t50f55usnh	COVER STOP / RR STOP KARISMA X HITAM	\N	0	HONDA	23000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	38000.00	HON-COV-COV-699	2026-02-09 09:54:53.444	\N
cmlezx4dk013v39t5223pahhq	LAMPU DEPAN / HEAD LAMP ASSY BEAT FI	\N	0	HONDA	101000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	162000.00	HON-LAM-LAM-735	2026-02-09 09:54:56.889	\N
cmlezx18j00xd39t59d5j7czz	FRONT HANDLE COVER / BATOK DEPAN BLADE 11 MERAH	\N	0	HONDA	162000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:53.443	BODY PART	175000.00	HON-FRO-FRO-605	2026-06-18 17:27:37.767	\N
cmlezx18j00xb39t5k2t3n3f0	FRONT HANDLE COVER / BATOK DEPAN BLADE 11 ORANGE	\N	0	HONDA	162000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:53.443	BODY PART	175000.00	HON-FRO-FRO-606	2026-06-18 17:27:37.767	\N
cmlezx6qp017k39t53bcjihsf	MIKA LAMPU VARIO 150 18 / 125 23 (PC)	\N	0	HONDA	216000.00	MIKA LAMPU (HONDA)	2026-02-09 09:54:56.89	KELISTRIKAN	229000.00	HON-MIK-MIK-795	2026-02-09 09:54:56.89	\N
cmlezx7my019339t5kuhxlp9o	MIKA LAMPU ADV 150	\N	0	HONDA	215000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	229000.00	HON-MIK-MIK-825	2026-02-09 09:55:01.489	\N
cmlezx450013d39t5n9pbskvb	COVER TANGKI / COVER MESIN SCOOPY FI HITAM	\N	0	HONDA	125000.00	COVER TANGKI / COVER MESIN VARIO 110 FI	2026-02-09 09:54:56.889	BODY PART	136000.00	HON-COV-COV-712	2026-06-18 17:22:17.168	\N
cmlezx651016s39t5eccsif39	LAMPU DEPAN / HEAD LAMP BEAT	\N	0	HONDA	76000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	108000.00	HON-LAM-LAM-734	2026-06-18 17:22:17.168	\N
cmlezx8aw01ak39t5zrhfpy9g	MIKA SEN Fr / MIKA SEN DEPAN  BEAT (P) KO	\N	0	HONDA	23000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.489	LAIN-LAIN	32000.00	HON-MIK-MIK-872	2026-02-09 09:55:01.489	\N
cmlezx8nv01be39t5ryzxcqgn	MIKA LAMPU VERZA	\N	0	HONDA	78000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	229000.00	HON-MIK-MIK-829	2026-02-09 09:55:01.49	\N
cmlezxczm01kj39t5voy9v2rv	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT LEGENDA 2 (P/M)	\N	0	HONDA	71000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	80000.00	HON-STO-STO-1044	2026-06-18 17:22:17.168	\N
cmlezxgg801sy39t5pv0xfwhq	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM SCOOPY FI KECIL BIRU	\N	0	HONDA	127000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	137000.00	HON-LEG-LEG-1178	2026-06-18 17:22:17.168	\N
cmlezxc8y01ja39t5fseuj4lv	Fr / Rr WINKER ASSY MEGAPRO 10	\N	0	HONDA	104000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	107000.00	HON-FRO-FRR-996	2026-02-09 09:55:04.848	\N
cmlezxgxq01tq39t5qkf7946g	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM SCOOPY FI KECIL KREM	\N	0	HONDA	127000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	137000.00	HON-LEG-LEG-1190	2026-06-18 17:22:17.168	\N
cmlezxd4a01ku39t5l7q42uea	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT TIGER 03 (M)	\N	0	HONDA	84000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	87000.00	HON-STO-STO-1046	2026-02-09 09:55:08.265	\N
cmlezx0lj00wk39t5v6bcyrhp	FRONT HANDLE COVER / BATOK DEPAN SUPRA X 125 HELM IN HITAM	\N	0	HONDA	74000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	82000.00	HON-FRO-FRO-589	2026-06-18 17:27:37.767	\N
cmlezx4yp014t39t56asmqvvv	COVER TANGKI / COVER MESIN SCOOPY 20 KREM	\N	0	HONDA	159000.00	COVER TANGKI / COVER MESIN VARIO 110 FI	2026-02-09 09:54:56.889	BODY PART	178000.00	HON-COV-COV-718	2026-06-18 17:27:37.767	\N
cmlezx30d012039t5rnbijuzw	REAR HANDLE / BATOK BELAKANG COVER SMASH	\N	0	HONDA	24000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	48000.00	HON-REA-REA-640	2026-02-09 09:54:53.444	\N
cmlezx37b012i39t58pm65gxl	COVER STOP / RR STOP REVO HITAM	\N	0	HONDA	23000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	129000.00	HON-COV-COV-692	2026-02-09 09:54:53.444	\N
cmlezx46j013l39t5exg9xn6l	COVER TANGKI / COVER MESIN SUPRA X 125 07	\N	0	HONDA	56000.00	COVER TANGKI / COVER MESIN VARIO 110 FI	2026-02-09 09:54:56.889	BODY PART	45000.00	HON-COV-COV-721	2026-02-09 09:54:56.889	\N
cmlezx68w017339t5r95kjpiy	LAMPU DEPAN / HEAD LAMP REVO FI / REVO X	\N	0	HONDA	99000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	127000.00	HON-LAM-LAM-757	2026-02-09 09:54:56.89	\N
cmlezx6or017g39t5cbpjuoqy	MIKA LAMPU VARIO 150 18 / 125 23	\N	0	HONDA	200000.00	MIKA LAMPU (HONDA)	2026-02-09 09:54:56.89	KELISTRIKAN	229000.00	HON-MIK-MIK-793	2026-02-09 09:54:56.89	\N
cmlezx6x0018039t5qkauombc	MIKA LAMPU SCOOPY FI 17	\N	0	HONDA	108000.00	MIKA LAMPU (HONDA)	2026-02-09 09:54:56.89	KELISTRIKAN	136000.00	HON-MIK-MIK-799	2026-02-09 09:54:56.89	\N
cmlezxihn01w239t5rgzqz3vs	FOOTREST BAWAH BEAT 20	\N	0	HONDA	76000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	79000.00	HON-LEG-FOO-1227	2026-02-09 09:55:15.054	\N
cmlezxixq01x439t5x8kcwpgb	GARNIS (HONDA)	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	0.00	HON-LEG-GAR-1274	2026-02-09 09:55:15.055	\N
cmlezxjyh01zq39t5rg1lm2k7	BOX SAMPING GL PRO HITAM	\N	0	HONDA	82000.00	BOX FILTER UDARA	2026-02-09 09:55:15.055	MESIN & OLI	85000.00	HON-BOX-BOX-1294	2026-02-09 09:55:15.055	\N
cmlezxkty020839t59vd7k9kl	COVER MESIN /	\N	0	HONDA	0.00	COVER FILTER UDARA	2026-02-09 09:55:18.838	BODY PART	3000.00	HON-COV-COV-1302	2026-02-09 09:55:18.838	\N
cmlezxm50022q39t5vmcfovj1	REAR WINKER /	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	0.00	HON-TUT-REA-1350	2026-02-09 09:55:18.839	\N
cmlezxmap023339t5bk1rca4l	BUNTUT Rr /	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	0.00	HON-TUT-BUN-1358	2026-02-09 09:55:18.839	\N
cmlezxmgs023g39t58wim8z51	FOOTSTEP BLADE 11	\N	0	HONDA	20000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	23000.00	HON-TUT-FOO-1363	2026-02-09 09:55:18.839	\N
cmlezxmn3023z39t5fpdktmnv	FOOTSTEP BLADE 16	\N	0	HONDA	20000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	23000.00	HON-TUT-FOO-1368	2026-02-09 09:55:18.839	\N
cmlezx7mt018y39t5jrd9nvoo	MIKA LAMPU GENIO	\N	0	HONDA	140000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	96000.00	HON-MIK-MIK-824	2026-02-09 09:55:01.489	\N
cmlezxnxs026539t55yhlx35l	FILTER UDARA BEAT 20 / SCOOPY 20	\N	0	HONDA	21000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	24000.00	HON-TUT-FIL-1425	2026-02-09 09:55:22.865	\N
cmlezxo4j026i39t5iz5o0645	FILTER UDARA ABSOLUTE REVO	\N	0	HONDA	23000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	26000.00	HON-TUT-FIL-1432	2026-02-09 09:55:22.865	\N
cmlezxoau027039t5t91d0npj	FILTER UDARA SUPRA X 125 14	\N	0	HONDA	25000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	28000.00	HON-TUT-FIL-1427	2026-02-09 09:55:22.865	\N
cmlezxoh7027b39t50xjcbw07	FILTER UDARA GRAND	\N	0	HONDA	13000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	16000.00	HON-TUT-FIL-1436	2026-02-09 09:55:22.865	\N
cmlezxp0j028o39t5lw3ge0ec	PIRING REM CAKRAM BEAT	\N	0	HONDA	0.00	PIRING REM CAKRAM	2026-02-09 09:55:22.865	PENGEREMAN	113000.00	HON-PIR-PIR-1460	2026-02-09 09:55:22.865	\N
cmlg3smff000gerj0yjartctw	LAMPU DEPAN SATRIA FU 150	\N	0	SUZUKI	120000.00	LAMPU DEPAN / (SUZUKI)	2026-02-10 04:31:07.266	KELISTRIKAN	123000.00	SUZ-KEL-LAM-8	2026-02-10 04:31:07.266	\N
cmlg3smpn000oerj0sz6efhxx	MIKA SEN Rr + STOP TORNADO (P/P) KO	\N	0	SUZUKI	23000.00	MIKA SEN Fr + Rr / SUZUKI)	2026-02-10 04:31:07.267	KELISTRIKAN	26000.00	SUZ-KEL-MIK-30	2026-02-10 04:31:07.267	\N
cmlg3sn1z000werj01edx5njn	MIKA LAMPU NEW SHOGUN	\N	0	SUZUKI	25000.00	MIKA LAMPU / SUZUKI)	2026-02-10 04:31:07.267	KELISTRIKAN	28000.00	SUZ-KEL-MIK-21	2026-02-10 04:31:07.267	\N
cmlg3snc20014erj0mido9jjx	MIKA SEN Fr SPIN	\N	0	SUZUKI	48000.00	MIKA SEN Fr + Rr / SUZUKI)	2026-02-10 04:31:07.268	KELISTRIKAN	51000.00	SUZ-KEL-MIK-26	2026-02-10 04:31:07.268	\N
cmlg3snnc001gerj01n0fr4e9	MIKA SEN Fr TORNADO (P) KO	\N	0	SUZUKI	16000.00	MIKA SEN Fr + Rr / SUZUKI)	2026-02-10 04:31:07.268	KELISTRIKAN	19000.00	SUZ-KEL-MIK-32	2026-02-10 04:31:07.268	\N
cmlg3so0k001serj0z2ygnmdw	LAMPU DEPAN SHOGUN 125 07	\N	0	SUZUKI	91000.00	LAMPU DEPAN / (SUZUKI)	2026-02-10 04:31:07.268	KELISTRIKAN	94000.00	SUZ-KEL-LAM-10	2026-02-10 04:31:07.268	\N
cmlg3soik0024erj0dgktsljz	FRONT FENDER SKYDRIVE HITAM	\N	0	SUZUKI	70000.00	FRONT FENDER / SPAKBOR DEPAN (SUZUKI)	2026-02-10 04:31:07.268	BODY PART	73000.00	SUZ-BOD-FRO-49	2026-02-10 04:31:07.268	\N
cmlg3soyf002eerj0bki8uhfb	FRONT FENDER A SHOGUN 125 07 HITAM	\N	0	SUZUKI	79000.00	FRONT FENDER / SPAKBOR DEPAN (SUZUKI)	2026-02-10 04:31:07.268	BODY PART	82000.00	SUZ-BOD-FRO-60	2026-02-10 04:31:07.268	\N
cmlg3spfl002werj0h5f966zw	FRONT FENDER SATRIA FU 150 FI 16 BIRU MUDA METALIK	\N	0	SUZUKI	94000.00	FRONT FENDER / SPAKBOR DEPAN (SUZUKI)	2026-02-10 04:31:07.268	BODY PART	97000.00	SUZ-BOD-FRO-56	2026-02-10 04:31:07.268	\N
cmlezx1re00yo39t5e55cu8e7	REAR HANDLE / BATOK BELAKANG COVER SUPRA X 125 14	\N	0	HONDA	83000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	68000.00	HON-REA-REA-632	2026-06-18 17:19:42.083	\N
cmlezx4dk013u39t5lewp8hnt	COVER TANGKI / COVER MESIN SCOOPY 20 HITAM	\N	0	HONDA	159000.00	COVER TANGKI / COVER MESIN VARIO 110 FI	2026-02-09 09:54:56.889	BODY PART	178000.00	HON-COV-COV-716	2026-06-18 17:27:37.767	\N
cmlezxjqg01z239t5zspb19oz	BOX SAMPING /	\N	0	HONDA	0.00	BOX FILTER UDARA	2026-02-09 09:55:15.055	MESIN & OLI	0.00	HON-BOX-BOX-1289	2026-02-09 09:55:15.055	\N
cmlezxkty020639t5ppbxjxtl	COVER MESIN BEAT FI IN + EX	\N	0	HONDA	44000.00	COVER MESIN SET BEAT FI ESP / VARIO 110 ESP / BEAT POP	2026-02-09 09:55:18.838	BODY PART	47000.00	HON-COV-COV-1304	2026-02-09 09:55:18.838	\N
cmlezxmbz023839t5dxqcj9sa	FOOTSTEP /	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	0.00	HON-TUT-FOO-1362	2026-02-09 09:55:18.839	\N
cmlezxmia023k39t5qww8b02k	FOOTSTEP BLADE 12	\N	0	HONDA	20000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	23000.00	HON-TUT-FOO-1364	2026-02-09 09:55:18.839	\N
cmlezxmov024439t5eo7b5n3u	HANDFAT CB 150 R	\N	0	HONDA	23000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	26000.00	HON-TUT-HAN-1378	2026-02-09 09:55:18.839	\N
cmlezx1e200xs39t55h78hl0n	REAR HANDLE / BATOK BELAKANG COVER VARIO 150 18	\N	0	HONDA	22000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	48000.00	HON-REA-REA-622	2026-06-19 22:06:27.205	01B5230182AA1
cmlezxoat026y39t53q6p1p0o	VISOR SUPRA X 125 HELM IN HITAM	\N	0	HONDA	34000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	37000.00	HON-TUT-VIS-1439	2026-02-09 09:55:22.865	\N
cmlezxoh7027839t5iya9wvel	UKURAN OLI /	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	0.00	HON-TUT-UKU-1421	2026-02-09 09:55:22.865	\N
cmlezxp19028u39t5t8zam1jj	BARSTEP / KARET INJAKAN	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	0.00	HON-TUT-BAR-1442	2026-02-09 09:55:22.865	\N
cmlg3sndw0016erj03rnvhcwk	MIKA LAMPU SATRIA FU 150	\N	0	SUZUKI	54000.00	MIKA LAMPU / SUZUKI)	2026-02-10 04:31:07.267	KELISTRIKAN	57000.00	SUZ-KEL-MIK-23	2026-02-10 04:31:07.267	\N
cmlezx8l301bc39t5hldc9ala	MIKA SPEEDOMETER ABSOLUTE REVO	\N	0	HONDA	28000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	26000.00	HON-MIK-MIK-851	2026-06-18 17:19:42.083	\N
cmlg3so40001uerj0iqmaekge	MIKA SEN Rr + STOP NEW SHOGUN (P/M) KO	\N	0	SUZUKI	35000.00	MIKA SEN Fr + Rr / SUZUKI)	2026-02-10 04:31:07.268	KELISTRIKAN	38000.00	SUZ-KEL-MIK-33	2026-02-10 04:31:07.268	\N
cmlg3solj0026erj0uah91vzy	FRONT FENDER NEX HIJAU	\N	0	SUZUKI	80000.00	FRONT FENDER / SPAKBOR DEPAN (SUZUKI)	2026-02-10 04:31:07.268	BODY PART	83000.00	SUZ-BOD-FRO-53	2026-02-10 04:31:07.268	\N
cmlg3sp3c002ierj0tonvjc35	FRONT HANDLE COVER SATRIA FU 150 14 HITAM + VISOR	\N	0	SUZUKI	83000.00	FRONT HANDLE / (SUZUKI)	2026-02-10 04:31:07.268	PENGEREMAN	86000.00	SUZ-PEN-FRO-65	2026-02-10 04:31:07.268	\N
cmlg3spdb002qerj0877yyq4c	FRONT HANDLE COVER SHOGUN 125 04 HITAM	\N	0	SUZUKI	56000.00	FRONT HANDLE / (SUZUKI)	2026-02-10 04:31:07.268	PENGEREMAN	59000.00	SUZ-PEN-FRO-68	2026-02-10 04:31:07.268	\N
cmlg3spl00033erj0xtci0ues	LEGSHIELD TENGAH SATRIA FU 150 GRAY	\N	0	SUZUKI	88000.00	LEGSHIELD TENGAH / (SUZUKI)	2026-02-10 04:31:07.268	BODY PART	91000.00	SUZ-BOD-LEG-71	2026-02-10 04:31:07.268	\N
cmlezx4en014039t5u5x6rqw1	COVER SPEEDOMETER SCOOPY 20 MERAH	\N	0	HONDA	58000.00	COVER SPEEDOMETER	2026-02-09 09:54:56.889	BODY PART	26000.00	HON-COV-COV-728	2026-02-09 09:54:56.889	\N
cmlezx4yp014x39t55usit7z4	LAMPU DEPAN / HEAD LAMP CB 150 R NEW + LED	\N	0	HONDA	409000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	829000.00	HON-LAM-LAM-754	2026-02-09 09:54:56.889	\N
cmlezxgyg01tw39t5hcnbxa6g	LEGSHIELD TENGAH GRAND HIJAU	\N	0	HONDA	74000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.247	BODY PART	77000.00	HON-LEG-LEG-1192	2026-02-09 09:55:11.247	\N
cmlezx5zq016k39t5gjx3xjf3	MIKA LAMPU BEAT 20	\N	0	HONDA	94000.00	MIKA LAMPU (HONDA)	2026-02-09 09:54:56.89	KELISTRIKAN	123000.00	HON-MIK-MIK-784	2026-02-09 09:54:56.89	\N
cmlezx68v017039t5rmvsr5z6	LAMPU DEPAN / HEAD LAMP MEGAPRO 06	\N	0	HONDA	132000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	829000.00	HON-LAM-LAM-770	2026-02-09 09:54:56.89	\N
cmlezx2mw011639t5jgpv4sv6	REAR HANDLE / BATOK BELAKANG COVER BEAT FI ESP	\N	0	HONDA	39000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	45000.00	HON-REA-REA-617	2026-06-18 17:22:17.168	\N
cmlezx39a012o39t5ra1ui9vi	REAR HANDLE / BATOK BELAKANG COVER CB 150 R	\N	0	HONDA	60000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	68000.00	HON-REA-REA-641	2026-06-18 17:22:17.168	\N
7919c75a-b4e3-4256-b1d4-6de290dc4bc2	LEGSHIELD DALAM SCOOPY FI 17 KECIL (B)	\N	0	HONDA	73000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	73000.00	HON-LEG-2076	2026-06-18 17:47:31.403	\N
0524fd3f-01a3-4898-b10b-d913e10e36be	LEGSHIELD DALAM KECIL A SCOOPY FI / ESP HITAM	\N	0	HONDA	44000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	44000.00	HON-LEG-2077	2026-06-18 17:47:31.403	\N
cmlezx6zp018639t5eqq5ubdf	LAMPU DEPAN / HEAD LAMP ASSY SUPRA X 125 07	\N	0	HONDA	125000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	162000.00	HON-LAM-LAM-759	2026-02-09 09:54:56.89	\N
0164f3fa-3185-4d9a-9561-b36c4dfce3bd	LEGSHIELD DALAM KECIL A SCOOPY FI / ESP MERAH	\N	0	HONDA	60000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	60000.00	HON-LEG-2078	2026-06-18 17:47:31.403	\N
125f7799-ce3c-4bc1-8152-72a758a20658	LEGSHIELD DALAM KECIL A SCOOPY FI / ESP PUTIH	\N	0	HONDA	60000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	60000.00	HON-LEG-2079	2026-06-18 17:47:31.403	\N
cmlezx7g0018f39t5zu7wlg54	MIKA LAMPU REVO FI / REVO X	\N	0	HONDA	65000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	9000.00	HON-MIK-MIK-805	2026-02-09 09:55:01.489	\N
cmlezx7mt018w39t5q1dnyct8	MIKA LAMPU SUPRA X 125 14	\N	0	HONDA	62000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	47000.00	HON-MIK-MIK-807	2026-02-09 09:55:01.489	\N
355ecf36-8d64-40de-9947-7b47870f7737	COVER BODY BEAT 24 / BEAT STREET 24 BESAR HITAM	\N	0	HONDA	369000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	369000.00	HON-COV-2080	2026-06-18 17:47:31.403	\N
cmlezxlg1021239t5ssa036uj	TUTUP KNALPOT VARIO 150 18 / 125 23	\N	0	HONDA	30000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	33000.00	HON-TUT-TUT-1322	2026-02-09 09:55:18.839	\N
cmlezxln8021g39t5ds28mn08	TUTUP KNALPOT BEAT	\N	0	HONDA	31000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	34000.00	HON-TUT-TUT-1331	2026-02-09 09:55:18.839	\N
cmlezxlt6021u39t59hckaerz	TUTUP KNALPOT BEAT POP	\N	0	HONDA	34000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	37000.00	HON-TUT-TUT-1316	2026-02-09 09:55:18.839	\N
3b5097dc-726e-4c71-85e8-a5463c194155	COVER BODY / BODY SAMPING BEAT 24 / BEAT STREET 24 BESAR HITAM DOFF	\N	0	HONDA	397000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	397000.00	HON-COV-2081	2026-06-18 17:47:31.403	\N
91e1b54e-9261-4238-8311-b10d32aabc14	COVER BODY / BODY SAMPING BEAT 24 / BEAT STREET 24 KECIL	\N	0	HONDA	87000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	87000.00	HON-COV-2082	2026-06-18 17:47:31.403	\N
cmlezxmjh023o39t5m8aidix7	FOOTSTEP BLADE 17	\N	0	HONDA	20000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	23000.00	HON-TUT-FOO-1369	2026-02-09 09:55:18.839	\N
cmlezxmpo024639t5yrvjrfac	HANDFAT VERZA	\N	0	HONDA	23000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	26000.00	HON-TUT-HAN-1377	2026-02-09 09:55:18.839	\N
cmlezx8fn01au39t5c82ghgtp	MIKA LAMPU CS-1	\N	0	HONDA	50000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	229000.00	HON-MIK-MIK-822	2026-02-09 09:55:01.49	\N
cmlezx8kp01b839t5h79jqu9e	MIKA SEN Rr / MIKA SEN BELAKANG + STOP VARIO (P/M) KO	\N	0	HONDA	79000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	79000.00	HON-MIK-MIK-881	2026-02-09 09:55:01.49	\N
32156a20-ca2f-488a-86d9-abcdacc842ae	FRONT FENDER / SPAKBOR DEPAN BEAT 24 / BEAT STREET 24 HITAM	\N	0	HONDA	94000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	94000.00	HON-FRO-2083	2026-06-18 17:47:31.403	\N
cmlezxo4h026e39t5ary9t9i9	FILTER UDARA BEAT FI	\N	0	HONDA	26000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	29000.00	HON-TUT-FIL-1430	2026-02-09 09:55:22.865	\N
bf1231f5-9ea7-413e-b3bf-bf7812994845	FRONT FENDER / SPAKBOR DEPAN BEAT 24 / BEAT STREET 24 MERAH	\N	0	HONDA	111000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	111000.00	HON-FRO-2084	2026-06-18 17:47:31.403	\N
687e1b36-813e-46d7-a49c-caab06701ac3	FRONT FENDER / SPAKBOR DEPAN BEAT 24 / BEAT STREET 24 HITAM DOFF	\N	0	HONDA	111000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	111000.00	HON-FRO-2085	2026-06-18 17:47:31.403	\N
f308fc5e-0fd7-43c7-be92-23d78a2b6816	FRONT FENDER / SPAKBOR DEPAN BEAT 24 / BEAT STREET 24 BIRU DOFF	\N	0	HONDA	111000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	111000.00	HON-FRO-2086	2026-06-18 17:47:31.403	\N
cmlezxp0j028m39t5h28zrcjx	PEDAL REM /	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	0.00	HON-TUT-PED-1447	2026-02-09 09:55:22.865	\N
cmlg3snj1001aerj0vddysww2	MIKA SEN Fr SHOGUN (C) KO	\N	0	SUZUKI	16000.00	MIKA SEN Fr + Rr / SUZUKI)	2026-02-10 04:31:07.267	KELISTRIKAN	19000.00	SUZ-KEL-MIK-29	2026-02-10 04:31:07.267	\N
cmlg3snx2001merj0kbgewfh3	FRONT FENDER SATRIA FU 150 MERAH MAROON	\N	0	SUZUKI	82000.00	FRONT FENDER / SPAKBOR DEPAN (SUZUKI)	2026-02-10 04:31:07.268	BODY PART	85000.00	SUZ-BOD-FRO-48	2026-02-10 04:31:07.268	\N
cmlg3sobv001yerj0xukmlw6u	MIKA SEN Rr + STOP NEW SHOGUN (O/M) KO	\N	0	SUZUKI	30000.00	MIKA SEN Fr + Rr / SUZUKI)	2026-02-10 04:31:07.268	KELISTRIKAN	33000.00	SUZ-KEL-MIK-28	2026-02-10 04:31:07.268	\N
cmlg3sosv002aerj0mi84da8o	FRONT FENDER SATRIA FU 150 HITAM	\N	0	SUZUKI	68000.00	FRONT FENDER / SPAKBOR DEPAN (SUZUKI)	2026-02-10 04:31:07.268	BODY PART	71000.00	SUZ-BOD-FRO-59	2026-02-10 04:31:07.268	\N
cmlg3sp9l002merj0l05jymwt	FRONT FENDER SPIN MERAH	\N	0	SUZUKI	68000.00	FRONT FENDER / SPAKBOR DEPAN (SUZUKI)	2026-02-10 04:31:07.268	BODY PART	71000.00	SUZ-BOD-FRO-51	2026-02-10 04:31:07.268	\N
cmlg3spit002yerj0lfggyo39	FRONT HANDLE COVER NEW SHOGUN HITAM CAKRAM	\N	0	SUZUKI	50000.00	FRONT HANDLE / (SUZUKI)	2026-02-10 04:31:07.268	PENGEREMAN	53000.00	SUZ-PEN-FRO-69	2026-02-10 04:31:07.268	\N
cmlezx8qc01bs39t52ysqu5kw	MIKA SPEEDOMETER SMASH 06	\N	0	HONDA	27000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	26000.00	HON-MIK-MIK-858	2026-02-09 09:55:01.49	\N
cmlezx8tp01bz39t54u5nttof	MIKA SEN Fr / MIKA SEN DEPAN  VARIO (P)	\N	0	HONDA	21000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	32000.00	HON-MIK-MIK-880	2026-02-09 09:55:01.49	\N
cmlezx8tp01by39t50e0m55l1	MIKA LAMPU MEGAPRO 10	\N	0	HONDA	50000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	229000.00	HON-MIK-MIK-830	2026-02-09 09:55:01.49	\N
cmlezx8um01c239t5n45b627e	MIKA SEN Rr / MIKA SEN BELAKANG SCOOPY FI	\N	0	HONDA	34000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	79000.00	HON-MIK-MIK-886	2026-02-09 09:55:01.49	\N
cmlezx8wb01c839t5d5hk8aow	MIKA SEN Fr / MIKA SEN DEPAN  SCOOPY FI 17	\N	0	HONDA	49000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	94000.00	HON-MIK-MIK-887	2026-02-09 09:55:01.49	\N
cmlezxhwt01up39t596ht7ou4	FOOTREST VARIO TECHNO	\N	0	HONDA	65000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	68000.00	HON-LEG-FOO-1206	2026-02-09 09:55:15.054	\N
cmlezx1zf00ze39t5olg9chrl	COVER STOP / RR STOP BEAT ESP 16	\N	0	HONDA	19000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	22000.00	HON-COV-COV-647	2026-06-18 17:22:17.168	\N
cmlezx25200zs39t58k6dhpy5	COVER STOP / RR STOP SCOOPY FI HITAM	\N	0	HONDA	78000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	104000.00	HON-COV-COV-670	2026-06-18 17:22:17.168	\N
cmlezx8y001ca39t5g9oxsbv7	MIKA SEN Fr / MIKA SEN DEPAN  BLADE 11 + INNER (O)	\N	0	HONDA	84000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	44000.00	HON-MIK-MIK-889	2026-02-09 09:55:01.49	\N
cmlezx8ys01cc39t54bagtmd3	MIKA SEN Fr / MIKA SEN DEPAN  BLADE	\N	0	HONDA	25000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	32000.00	HON-MIK-MIK-890	2026-02-09 09:55:01.49	\N
609d1ba7-d562-4f05-8ff3-856b168f3d94	FRONT FENDER / SPAKBOR DEPAN BEAT 24 / BEAT STREET 24 HIJAU DOFF	\N	0	HONDA	111000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	111000.00	HON-FRO-2087	2026-06-18 17:47:31.403	\N
cmlezx91m01ce39t5h4ilbtn2	MIKA SEN Rr / MIKA SEN BELAKANG + STOP ABSOLUTE REVO (P/M) KO	\N	0	HONDA	56000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	79000.00	HON-MIK-MIK-892	2026-02-09 09:55:01.49	\N
cmlezxjpx01yy39t5v2addjoj	BOX SAMPING PRIMA HITAM	\N	0	HONDA	50000.00	BOX FILTER UDARA	2026-02-09 09:55:15.055	MESIN & OLI	53000.00	HON-BOX-BOX-1293	2026-02-09 09:55:15.055	\N
a3cb3964-69b4-49a5-8b26-a55dfb0537ba	FRONT FENDER / SPAKBOR DEPAN BEAT 24 / BEAT STREET 24 PUTIH	\N	0	HONDA	111000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	111000.00	HON-FRO-2088	2026-06-18 17:47:31.403	\N
cmlezx92y01cm39t5tr3a2wvo	MIKA SEN Fr / MIKA SEN DEPAN  SCOOPY 20	\N	0	HONDA	50000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	32000.00	HON-MIK-MIK-888	2026-02-09 09:55:01.49	\N
2e399f9a-2153-4f8b-b7e0-6dba630f08f2	FRONT FENDER / SPAKBOR DEPAN STYLO 160 HITAM	\N	0	HONDA	132000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	132000.00	HON-FRO-2089	2026-06-18 17:47:31.403	\N
2e60b944-32bc-41a1-8beb-10c9c99ecb73	FRONT FENDER / SPAKBOR DEPAN STYLO 160 HITAM DOFF	\N	0	HONDA	146000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	146000.00	HON-FRO-2090	2026-06-18 17:47:31.403	\N
cmlezxltd021x39t54isliw3y	TUTUP KNALPOT BEAT 20	\N	0	HONDA	36000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	39000.00	HON-TUT-TUT-1321	2026-02-09 09:55:18.839	\N
0d2578a3-e5e0-40f7-ac98-792e5577f7c3	FRONT FENDER / SPAKBOR DEPAN STYLO 160 KREM	\N	0	HONDA	146000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	146000.00	HON-FRO-2091	2026-06-18 17:47:31.403	\N
f49e0101-fe72-4d2b-8dbf-3d907668099a	REAR FENDER / SPAKBOR DEPAN PCX 150 18	\N	0	HONDA	85000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	85000.00	HON-FRO-2092	2026-06-18 17:47:31.403	\N
cmlezxmlu023s39t56ce9cp30	FOOTSTEP BLADE 20	\N	0	HONDA	20000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	23000.00	HON-TUT-FOO-1372	2026-02-09 09:55:18.839	\N
cmlezx96x01cs39t5vzyle4dp	MIKA SEN Rr / MIKA SEN BELAKANG + STOP BLADE 11 (P/M) KO	\N	0	HONDA	102000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	79000.00	HON-MIK-MIK-895	2026-02-09 09:55:01.49	\N
cmlezxmxx024m39t5ekniz9ip	KARET BARSTEP SMASH 06	\N	0	HONDA	16000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	19000.00	HON-TUT-KAR-1389	2026-02-09 09:55:18.839	\N
cmlezx97r01cu39t5o78q9b10	MIKA SEN Rr / MIKA SEN BELAKANG + STOP REVO FI / REVO X	\N	0	HONDA	53000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	79000.00	HON-MIK-MIK-893	2026-02-09 09:55:01.49	\N
cmlezx3wr013039t5xh4kc824	COVER TANGKI / COVER MESIN VARIO 160	\N	0	HONDA	24000.00	COVER TANGKI / COVER MESIN (HONDA)	2026-02-09 09:54:56.889	BODY PART	29000.00	HON-COV-COV-707	2026-06-18 17:27:37.767	\N
cmlezx3x5013639t5zvm0u1sd	COVER TANGKI / COVER MESIN VARIO 150	\N	0	HONDA	31000.00	COVER TANGKI / COVER MESIN VARIO 110 FI	2026-02-09 09:54:56.889	BODY PART	45000.00	HON-COV-COV-709	2026-06-18 17:19:42.083	\N
cmlezx4oq014g39t54hj3nf0z	COVER TANGKI / COVER MESIN SCOOPY 20 GRAY DOFF	\N	0	HONDA	180000.00	COVER TANGKI / COVER MESIN VARIO 110 FI	2026-02-09 09:54:56.889	BODY PART	201000.00	HON-COV-COV-717	2026-06-18 17:27:37.767	\N
cmlezxonf027p39t5y77ydx52	UKURAN OLI /	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	0.00	HON-TUT-UKU-1450	2026-02-09 09:55:22.865	\N
cmlezxouc028439t56jfob2tj	BUNTUT Rr WIN 100	\N	0	HONDA	16000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	19000.00	HON-TUT-BUN-1441	2026-02-09 09:55:22.865	\N
cmlezx98d01cw39t5hsjieawz	MIKA SEN Fr / MIKA SEN DEPAN  SUPRA X 125 14 + INNER	\N	0	HONDA	89000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	94000.00	HON-MIK-MIK-894	2026-02-09 09:55:01.49	\N
c0326266-08ed-42bf-af1b-110ef9e9cfd7	REAR FENDER / SPAKBOR DEPAN ATAS B VARIO 150 18 / VARIO 125 18 / VARIO 125 23 / VARIO 160	\N	0	HONDA	17000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	17000.00	HON-FRO-2093	2026-06-18 17:47:31.403	\N
cmlg3spn80038erj0nyti4o2p	FRONT HANDLE COVER SHOGUN 125 07 HITAM (NON KOPLING)	\N	0	SUZUKI	57000.00	FRONT HANDLE / (SUZUKI)	2026-02-10 04:31:07.269	PENGEREMAN	60000.00	SUZ-PEN-FRO-67	2026-02-10 04:31:07.269	\N
cmlg3spz5003kerj05oeb7p5y	FRONT HANDLE COVER NEW SHOGUN MERAH CAKRAM	\N	0	SUZUKI	52000.00	FRONT HANDLE / (SUZUKI)	2026-02-10 04:31:07.269	PENGEREMAN	55000.00	SUZ-PEN-FRO-64	2026-02-10 04:31:07.269	\N
cmlezx2a200zw39t5lf11n5i4	COVER STOP / RR STOP SCOOPY FI MERAH	\N	0	HONDA	85000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	84000.00	HON-COV-COV-671	2026-06-19 22:06:28.415	01B4333181AA1
cmlg3syeh0002q2fkfhonfl7k	MIKA STOP SHOGUN 125 04 BESAR (P) KO	\N	0	SUZUKI	25000.00	MIKA STOP / (SUZUKI)	2026-02-10 04:31:27.23	KELISTRIKAN	28000.00	SUZ-KEL-MIK-79	2026-02-10 04:31:27.23	\N
cmlg3syxv0006q2fkfd6ygyl7	LAMPU DEPAN SHOGUN	\N	0	SUZUKI	49000.00	LAMPU DEPAN / (SUZUKI)	2026-02-10 04:31:27.231	KELISTRIKAN	52000.00	SUZ-KEL-LAM-16	2026-02-10 04:31:27.231	\N
cmlg3szn6000eq2fkhixy28ug	COB LAMPU SHOGUN 125 04	\N	0	SUZUKI	14000.00	COB LAMPU / (SUZUKI)	2026-02-10 04:31:27.231	KELISTRIKAN	17000.00	SUZ-KEL-COB-81	2026-02-10 04:31:27.231	\N
cmlezx9dm01da39t5ljrb0wtt	MIKA SEN Fr / MIKA SEN DEPAN  SUPRA X 125 KO	\N	0	HONDA	17000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	94000.00	HON-MIK-MIK-899	2026-02-09 09:55:01.49	\N
cmlg3t1mk0010q2fk6eju8iws	COB LAMPU SATRIA FU 150	\N	0	SUZUKI	18000.00	COB LAMPU / (SUZUKI)	2026-02-10 04:31:27.231	KELISTRIKAN	21000.00	SUZ-KEL-COB-80	2026-02-10 04:31:27.231	\N
0af7d89c-762e-4e1b-8a27-5b1747ebc6ab	PANEL BEAT 24 / BEAT STREET 24 BESAR HITAM	\N	0	HONDA	258000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	258000.00	HON-PAN-2094	2026-06-18 17:47:31.403	\N
cmlezxa1a01e139t5xlso8b7z	MIKA SEN Rr / MIKA SEN BELAKANG SUPRA X (P) KO	\N	0	HONDA	27000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	79000.00	HON-MIK-MIK-904	2026-02-09 09:55:04.847	\N
3d1a6a88-b45c-4f60-8b4d-e7ce5852cb28	PANEL BEAT 24 / BEAT STREET 24 BESAR HITAM DOFF	\N	0	HONDA	288000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	288000.00	HON-PAN-2095	2026-06-18 17:47:31.403	\N
d621749e-7b9f-4988-96c1-2d339787c6e2	PANEL BEAT 24 / BEAT STREET 24 BESAR MERAH	\N	0	HONDA	288000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	288000.00	HON-PAN-2096	2026-06-18 17:47:31.403	\N
403df8f1-896c-4edc-afdd-a02f47acf29f	PANEL BEAT 24 / BEAT STREET 24 BESAR BIRU DOFF	\N	0	HONDA	288000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	288000.00	HON-PAN-2097	2026-06-18 17:47:31.403	\N
cmlezxb7e01gm39t58aqsratn	MIKA STOP / MIKA BELAKANG GRAND (M) KO	\N	0	HONDA	22000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	170000.00	HON-MIK-MIK-961	2026-02-09 09:55:04.847	\N
cmlezxgbw01sm39t5l8kgo9lg	LEGSHIELD DALAM / SAYAP DALAM BEAT 20 KECIL NON CHARGER	\N	0	HONDA	51000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	56000.00	HON-LEG-LEG-1137	2026-06-18 17:22:17.168	\N
947211e3-7fb4-4e0f-a546-4ca2218ccb0e	PANEL BEAT 24 / BEAT STREET 24 BESAR HIJAU DOFF	\N	0	HONDA	288000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	288000.00	HON-PAN-2098	2026-06-18 17:47:31.403	\N
cmlezxanf01fa39t5a74dsvgb	MIKA SEN Fr / MIKA SEN DEPAN  SPACY	\N	0	HONDA	94000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	103000.00	HON-MIK-MIK-919	2026-06-18 17:22:17.168	\N
cmlezxbsl01i639t5sv78bze5	MIKA STOP / MIKA BELAKANG VARIO TECHNO (M)	\N	0	HONDA	44000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	170000.00	HON-MIK-MIK-932	2026-02-09 09:55:04.848	\N
cmlezxbze01in39t5g383xzjz	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT REVO	\N	0	HONDA	48000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	429000.00	HON-FRO-FRO-986	2026-02-09 09:55:04.848	\N
cmlezxjlk01yq39t50ew4crp7	BOX SAMPING MEGAPRO 06 HITAM	\N	0	HONDA	113000.00	BOX FILTER UDARA	2026-02-09 09:55:15.055	MESIN & OLI	116000.00	HON-BOX-BOX-1290	2026-02-09 09:55:15.055	\N
cmlezxjs301z639t5grwu4my4	COVER RADIATOR (HONDA)	\N	0	HONDA	0.00	BOX FILTER UDARA	2026-02-09 09:55:15.055	MESIN & OLI	0.00	HON-BOX-COV-1296	2026-02-09 09:55:15.055	\N
cmlezxagx01eu39t5xdjiyarl	MIKA STOP / MIKA BELAKANG REVO BESAR (P)	\N	0	HONDA	41000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	190000.00	HON-MIK-MIK-945	2026-06-18 17:22:17.168	\N
cmlezxkty020939t56w72t2lf	CHAIN COVER MEGAPRO	\N	0	HONDA	17000.00	COVER MESIN SET BEAT FI ESP / VARIO 110 ESP / BEAT POP	2026-02-09 09:55:18.838	BODY PART	20000.00	HON-COV-CHA-1307	2026-02-09 09:55:18.838	\N
cmlezxl68020s39t5bcn5txif	CHAIN COVER SUPRA FIT NEW	\N	0	HONDA	19000.00	COVER MESIN SET BEAT FI ESP / VARIO 110 ESP / BEAT POP	2026-02-09 09:55:18.839	BODY PART	22000.00	HON-COV-CHA-1309	2026-02-09 09:55:18.839	\N
cmlezxlg1021539t54s1r4dpj	TUTUP KNALPOT VARIO 150	\N	0	HONDA	29000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	32000.00	HON-TUT-TUT-1325	2026-02-09 09:55:18.839	\N
4173bec2-d97e-425c-97de-930f4d5acc66	PANEL BEAT 24 / BEAT STREET 24 BESAR PUTIH	\N	0	HONDA	288000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	288000.00	HON-PAN-2099	2026-06-18 17:47:31.403	\N
cmlezxdk301m139t5cugdwp3j	COB LAMPU / FITTING LAMPU MEGAPRO 06	\N	0	HONDA	11000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	17100.00	HON-STO-COB-1066	2026-02-09 09:55:08.265	\N
cmlezx3w8012w39t59kw44hek	COVER TANGKI / COVER MESIN SCOOPY 20 MERAH	\N	0	HONDA	159000.00	COVER TANGKI / COVER MESIN VARIO 110 FI	2026-02-09 09:54:56.889	BODY PART	178000.00	HON-COV-COV-719	2026-06-18 17:27:37.767	\N
cmlezxmlv023w39t5c99dyruv	FOOTSTEP BLADE 21	\N	0	HONDA	20000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	23000.00	HON-TUT-FOO-1373	2026-02-09 09:55:18.839	\N
cc528e17-6ca3-4604-982a-4afe18f29478	PANEL BEAT 24 / BEAT STREET 24 KECIL	\N	0	HONDA	24000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	24000.00	HON-PAN-2100	2026-06-18 17:47:31.403	\N
621a1b8d-00a2-476e-97c1-54e19ace7e59	PANEL VARIO 160 KECIL ATAS	\N	0	HONDA	26000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	26000.00	HON-PAN-2101	2026-06-18 17:47:31.403	\N
cmlezxfno01qw39t5fngn76c1	LEGSHIELD LUAR / SAYAP LUAR SMASH BIRU	\N	0	HONDA	176000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	194000.00	HON-LEG-LEG-1128	2026-02-09 09:55:11.246	\N
cmlezxoeb027439t56p65hsuw	BUNTUT / INJAKAN KAKI BELAKANG	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	0.00	HON-TUT-BUN-1440	2026-02-09 09:55:22.865	\N
cmlezxojo027g39t510llbqij	FILTER UDARA VARIO TECHNO 125	\N	0	HONDA	26000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	29000.00	HON-TUT-FIL-1428	2026-02-09 09:55:22.865	\N
cd5d22d5-ad0b-445b-a03d-bc49d6c49792	PANEL SUPRA X 125 14 HITAM	\N	0	HONDA	93000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	93000.00	HON-PAN-2102	2026-06-18 17:47:31.403	\N
cmlg3sps8003berj06r89ogor	STOP LAMP ASSY TORNADO (P/M)	\N	0	SUZUKI	67000.00	STOP LAMP ASSY / (SUZUKI)	2026-02-10 04:31:07.269	KELISTRIKAN	70000.00	SUZ-KEL-STO-40	2026-02-10 04:31:07.269	\N
cmlg3sq80003merj0brdj9ylg	MIKA STOP SATRIA FU 150 BESAR (P) + KECIL (M)	\N	0	SUZUKI	45000.00	MIKA STOP / (SUZUKI)	2026-02-10 04:31:07.269	KELISTRIKAN	48000.00	SUZ-KEL-MIK-78	2026-02-10 04:31:07.269	\N
cmlg3sxz20000q2fkgxitvfwk	REAR HANDLE COVER SHOGUN 125 04 BIRU	\N	0	SUZUKI	51000.00	REAR HANDLE COVER / (SUZUKI)	2026-02-10 04:31:27.23	BODY PART	54000.00	SUZ-BOD-REA-3	2026-02-10 04:31:27.23	\N
cmlg3syit0004q2fkdk7hv9hc	COVER STOP NEW SHOGUN HITAM	\N	0	SUZUKI	23000.00	COVER STOP NEW / (SUZUKI)	2026-02-10 04:31:27.231	BODY PART	26000.00	SUZ-BOD-COV-77	2026-02-10 04:31:27.231	\N
cmlg3sz5v0008q2fktaa8sz35	COB LAMPU TORNADO	\N	0	SUZUKI	8000.00	COB LAMPU / (SUZUKI)	2026-02-10 04:31:27.231	KELISTRIKAN	11000.00	SUZ-KEL-COB-83	2026-02-10 04:31:27.231	\N
cmlg3t0c1000gq2fk6jku73kj	STOP LAMP ASSY NEW SHOGUN (P/M)	\N	0	SUZUKI	47000.00	STOP LAMP ASSY / (SUZUKI)	2026-02-10 04:31:27.231	KELISTRIKAN	50000.00	SUZ-KEL-STO-41	2026-02-10 04:31:27.231	\N
3431493d-9ba5-4e27-804d-17ae56e921e7	PANEL SCOOPY KECIL SILVER	\N	0	HONDA	60000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	60000.00	HON-PAN-2103	2026-06-18 17:47:31.403	\N
cmlg439rv0030pv85fc95bvl8	FRONT FENDER/SPAKBOR DEPAN NEW X-RIDE 125 HITAM	\N	0	YAMAHA	128000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	131000.00	YAM-BOD-FRO-278	2026-02-10 04:39:23.84	\N
cmlg439xl0036pv854l7legr7	FRONT FENDER/SPAKBOR DEPAN VEGA R 04 MERAH	\N	0	YAMAHA	84000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	87000.00	YAM-BOD-FRO-252	2026-02-10 04:39:23.84	\N
cmlg43a33003epv85r5vcpel9	FRONT FENDER/SPAKBOR DEPAN A VEGA ZR BIRU MUDA	\N	0	YAMAHA	78000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	81000.00	YAM-BOD-FRO-253	2026-02-10 04:39:23.84	\N
ae6406bb-ea59-4a2f-b6b1-ade09183e676	PANEL DEPAN BAGIAN BAWAH BEAT 24 / BEAT STREET 24	\N	0	HONDA	42000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	42000.00	HON-PAN-2104	2026-06-18 17:47:31.403	\N
cmlezxovv028e39t5pe2vbao4	PIPA GARPU DEPAN BEAT 20	\N	0	HONDA	0.00	PIPA GARPU DEPAN	2026-02-09 09:55:22.865	KAKI-KAKI	150000.00	HON-PIP-PIP-1457	2026-02-09 09:55:22.865	01B595300AA1
11d2fe1b-5bec-4976-bad5-c6206abd97bd	PANEL DEPAN BAGIAN BAWAH PCX 150 18	\N	0	HONDA	46000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	46000.00	HON-PAN-2105	2026-06-18 17:47:31.403	\N
319456e5-880e-40bf-9ca1-94e528f4541e	FRONT HANDLE COVER / BATOK DEPAN VARIO 110 FI ESP HITAM	\N	0	HONDA	125000.00	FRONT HANDLE COVER	2026-06-18 17:47:31.403	BODY PART	125000.00	HON-FHC-2106	2026-06-18 17:47:31.403	\N
631bab47-161b-4138-8640-3c6c2270a688	FRONT HANDLE COVER / BATOK DEPAN VARIO 110 FI ESP HITAM DOFF	\N	0	HONDA	138000.00	FRONT HANDLE COVER	2026-06-18 17:47:31.403	BODY PART	138000.00	HON-FHC-2107	2026-06-18 17:47:31.403	\N
e93b987d-a1e5-413b-a5cd-fefcd54754c1	FRONT HANDLE COVER / BATOK DEPAN VARIO 110 FI ESP MERAH	\N	0	HONDA	138000.00	FRONT HANDLE COVER	2026-06-18 17:47:31.403	BODY PART	138000.00	HON-FHC-2108	2026-06-18 17:47:31.403	\N
cmlezx46j013m39t5kf5cwakb	COVER TANGKI / COVER MESIN SCOOPY FI PUTIH	\N	0	HONDA	137000.00	COVER TANGKI / COVER MESIN VARIO 110 FI	2026-02-09 09:54:56.889	BODY PART	154000.00	HON-COV-COV-715	2026-06-18 17:22:17.168	\N
cmlezx3wr013239t5dho6u7nk	COVER TANGKI / COVER MESIN BEAT 20	\N	0	HONDA	41000.00	COVER TANGKI / COVER MESIN (HONDA)	2026-02-09 09:54:56.889	BODY PART	45000.00	HON-COV-COV-701	2026-06-18 17:19:42.083	01B5936682AA1
8b5caf1e-7cf3-4abd-9a3d-a775e26a831a	REAR HANDLE COVER / BATOK BELAKANG VARIO 110 FI ESP ( ISS )	\N	0	HONDA	52000.00	REAR HANDLE	2026-06-18 17:47:31.403	BODY PART	52000.00	HON-RHC-2109	2026-06-18 17:47:31.403	\N
cmlezxdwg01n239t5wepr51e6	COB LAMPU / FITTING LAMPU BEAT	\N	0	HONDA	20000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	27000.00	HON-STO-COB-1050	2026-06-18 17:22:17.168	\N
cmlezxjqf01z039t582t8osvz	BOX SAMPING GRAND HITAM	\N	0	HONDA	80000.00	BOX FILTER UDARA	2026-02-09 09:55:15.055	MESIN & OLI	83000.00	HON-BOX-BOX-1295	2026-02-09 09:55:15.055	\N
cmlezx4mz014839t5ridknsl6	COVER TANGKI / COVER MESIN SUPRA X 125 14	\N	0	HONDA	26000.00	COVER TANGKI / COVER MESIN VARIO 110 FI	2026-02-09 09:54:56.889	BODY PART	31000.00	HON-COV-COV-723	2026-06-18 17:27:37.767	01B4136682AA1
cmlezxbll01hn39t51pfd0qeb	MIKA STOP / MIKA BELAKANG LEGENDA 2 (P) KO	\N	0	HONDA	24000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	29000.00	HON-MIK-MIK-956	2026-06-18 17:27:37.767	\N
cmlezxm3s022k39t5hqdqaqzy	VISOR /	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	0.00	HON-TUT-VIS-1347	2026-02-09 09:55:18.839	\N
cmlezxmlu023r39t5f1s56n94	REAR WINKER ASSY SCOOPY FI	\N	0	HONDA	131000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	134000.00	HON-TUT-REA-1356	2026-02-09 09:55:18.839	\N
cmlezxnxs025z39t54a08zuqt	FILTER UDARA /	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	0.00	HON-TUT-FIL-1423	2026-02-09 09:55:22.865	\N
cmlezxo3v026c39t589gwahkc	FILTER UDARA CB 150 R	\N	0	HONDA	21000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	24000.00	HON-TUT-FIL-1431	2026-02-09 09:55:22.865	\N
cmlezxoa4026s39t5k0sl611r	VISOR ASSY TIGER 06	\N	0	HONDA	84000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	87000.00	HON-TUT-VIS-1438	2026-02-09 09:55:22.865	\N
cmlezxonp027v39t511cbvq6g	FILTER UDARA VERZA	\N	0	HONDA	23000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	26000.00	HON-TUT-FIL-1429	2026-02-09 09:55:22.865	\N
cmlg3spvb003ferj0abziqguu	MIKA SPEEDOMETER NEW SHOGUN	\N	0	SUZUKI	23000.00	MIKA SPEEDOMETER / (SUZUKI)	2026-02-10 04:31:07.269	KELISTRIKAN	26000.00	SUZ-KEL-MIK-76	2026-02-10 04:31:07.269	\N
cmlg3szcd000cq2fkf4da3g3s	REAR HANDLE COVER SHOGUN 125 04 HITAM	\N	0	SUZUKI	44000.00	REAR HANDLE COVER / (SUZUKI)	2026-02-10 04:31:27.23	BODY PART	47000.00	SUZ-BOD-REA-4	2026-02-10 04:31:27.23	\N
cmlg3t0j0000kq2fk4q1u450h	LAMPU DEPAN SATRIA FU 150 14	\N	0	SUZUKI	141000.00	LAMPU DEPAN / (SUZUKI)	2026-02-10 04:31:27.23	KELISTRIKAN	144000.00	SUZ-KEL-LAM-6	2026-02-10 04:31:27.23	\N
cmlg43a9a003opv85bm3fayk6	REAR FENDER/SPAKBOR BELAKANG JUPITER Z 10	\N	0	YAMAHA	53000.00	REAR FENDER/SPAKBOR BELAKANG (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	56000.00	YAM-BOD-REA-286	2026-02-10 04:39:23.84	\N
cmlg43agz003wpv853k40hh70	REAR FENDER/SPAKBOR BELAKANG JUPITER MX	\N	0	YAMAHA	55000.00	REAR FENDER/SPAKBOR BELAKANG (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	58000.00	YAM-BOD-REA-288	2026-02-10 04:39:23.84	\N
cmlg43b2a004mpv85xwxpt9hl	REAR FENDER/SPAKBOR BELAKANG MIO J	\N	0	YAMAHA	58000.00	REAR FENDER/SPAKBOR BELAKANG (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	61000.00	YAM-BOD-REA-289	2026-02-10 04:39:23.841	\N
cmlg43ay4004apv85ykyt3rg5	REAR FENDER/SPAKBOR BELAKANG VEGA R 06	\N	0	YAMAHA	53000.00	REAR FENDER/SPAKBOR BELAKANG (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	56000.00	YAM-BOD-REA-292	2026-02-10 04:39:23.841	\N
cmlg43b9e004upv85863sdotx	FRONT FORK COVER/COVER SOK DEPAN  F1Z-R BIRU	\N	0	YAMAHA	60000.00	FRONT FORK COVER/COVER SOK DEPAN (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	63000.00	YAM-BOD-FRO-300	2026-02-10 04:39:23.841	\N
cmlg43bds004wpv853wvp9j3q	FRONT FENDER/SPAKBOR DEPAN JUPITER MX HITAM	\N	0	YAMAHA	73000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	76000.00	YAM-BOD-FRO-216	2026-02-10 04:39:23.841	\N
cmlg43bfs0050pv85oe02wh73	FRONT FENDER/SPAKBOR DEPAN BYSON PUTIH	\N	0	YAMAHA	82000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	85000.00	YAM-BOD-FRO-274	2026-02-10 04:39:23.84	\N
cmlg43bkj0058pv85t13nx2ps	FRONT FENDER/SPAKBOR DEPAN JUPITER Z BIRU	\N	0	YAMAHA	93000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	96000.00	YAM-BOD-FRO-219	2026-02-10 04:39:23.841	\N
cmlg43blw005bpv852bzdajed	FRONT FENDER/SPAKBOR DEPAN B JUPITER Z 10	\N	0	YAMAHA	40000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	43000.00	YAM-BOD-FRO-214	2026-02-10 04:39:23.841	\N
cmlg43biu0056pv85rechg5tn	FRONT FENDER/SPAKBOR DEPAN JUPITER Z HITAM	\N	0	YAMAHA	83000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	86000.00	YAM-BOD-FRO-218	2026-02-10 04:39:23.841	\N
cmlg43d81005gpv85424jo2co	PANEL MIO M3 BESAR	\N	0	YAMAHA	126000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.554	BODY PART	129000.00	YAM-BOD-PAN-302	2026-02-10 04:39:33.554	\N
cmlezxjb101xy39t5qalt0as9	STANDARD SAMPING BEAT FI	\N	0	HONDA	0.00	STANDARD TENGAH	2026-02-09 09:55:15.055	KAKI-KAKI	32000.00	HON-STA-STA-1280	2026-06-19 22:06:29.053	01B3899997AA1
cmlezxjn001yw39t5cct8wlvz	BOX SAMPING SUPRA X HITAM	\N	0	HONDA	54000.00		2026-02-09 09:55:15.055	MESIN & OLI	57000.00	HON-BOX-BOX-1291	2026-06-23 18:25:29.77	01B1332840AA1
842e215e-e5ba-44dd-be28-b2988fd58afb	BOX FILTER UDARA SET SUPRA X 125 / SUPRA X 125 07 / SUPRA FIT NEW / KARISMA	\N	0	HONDA	37000.00	FILTER	2026-06-18 17:47:31.403	MESIN	37000.00	HON-FIL-2119	2026-06-18 17:47:31.403	\N
cmlezx98e01d039t5c18if6oz	MIKA SEN Fr / MIKA SEN DEPAN  SUPRA (O) KO	\N	0	HONDA	18000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	94000.00	HON-MIK-MIK-897	2026-02-09 09:55:01.49	\N
3733a89f-36dd-42cc-8888-3f34f92cf26e	COVER STOP / RR STOP BEAT 24 / BEAT STREET 24	\N	0	HONDA	22000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	22000.00	HON-CST-2120	2026-06-18 17:47:31.403	\N
cmlezxa1a01dy39t53khm6c8b	MIKA SEN Fr / MIKA SEN DEPAN  SUPRA X (P) KO	\N	0	HONDA	19000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	94000.00	HON-MIK-MIK-903	2026-02-09 09:55:04.847	\N
cmlezxjai01xw39t5sg05wllk	FOOTREST BAWAH BEAT FI A (KOLONG)	\N	0	HONDA	47000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	50000.00	HON-LEG-FOO-1230	2026-02-09 09:55:15.055	\N
cmlezxaai01eg39t5e6r5a5id	MIKA SEN Fr / MIKA SEN DEPAN  KARISMA (P) KO	\N	0	HONDA	19000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	94000.00	HON-MIK-MIK-916	2026-02-09 09:55:04.847	\N
cmlezxal001f039t5mz7dn2a1	MIKA STOP / MIKA BELAKANG REVO KECIL (M)	\N	0	HONDA	20000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	170000.00	HON-MIK-MIK-946	2026-02-09 09:55:04.847	\N
a9255e8b-6a46-4d4d-bff5-4592196cd16f	COVER STOP / RR STOP BAWAH BEAT 24 / BEAT STREET 24	\N	0	HONDA	28000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	28000.00	HON-CST-2121	2026-06-18 17:47:31.403	\N
cmlezxasi01fo39t5e4u2rt0n	MIKA STOP / MIKA BELAKANG SUPRA FIT NEW (P)	\N	0	HONDA	31000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	30000.00	HON-MIK-MIK-942	2026-02-09 09:55:04.847	\N
cmlezxazc01g239t5jl9yrla4	MIKA STOP / MIKA BELAKANG MEGAPRO 06	\N	0	HONDA	43000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	170000.00	HON-MIK-MIK-958	2026-02-09 09:55:04.847	\N
cmlezx3x5013539t5x6t763sy	COVER TANGKI / COVER MESIN BEAT POP	\N	0	HONDA	48000.00	COVER TANGKI / COVER MESIN (HONDA)	2026-02-09 09:54:56.889	BODY PART	56000.00	HON-COV-COV-702	2026-06-18 17:27:37.767	01B4036682AA1
cmlezxln8021e39t5vc5fagsd	TUTUP KNALPOT BEAT FI	\N	0	HONDA	33000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	36000.00	HON-TUT-TUT-1329	2026-02-09 09:55:18.839	\N
cmlezx9lz01du39t5v26atjgf	MIKA LAMPU SUPRA FIT NEW	\N	0	HONDA	56000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	53000.00	HON-MIK-MIK-811	2026-06-18 17:22:17.168	\N
cmlezxbqg01i239t537q8he0a	MIKA STOP / MIKA BELAKANG MEGAPRO KO	\N	0	HONDA	47000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	30000.00	HON-MIK-MIK-957	2026-02-09 09:55:04.848	\N
cmlezx4en014139t5kb04tzby	COVER TANGKI / COVER MESIN VARIO TECHNO	\N	0	HONDA	51000.00	COVER TANGKI / COVER MESIN VARIO 110 FI	2026-02-09 09:54:56.889	BODY PART	41000.00	HON-COV-COV-710	2026-06-18 17:27:37.767	01B2936682AA1
cmlezxez101p639t5xxltiiby	LEGSHIELD LUAR / SAYAP LUAR SCOOPY 20 GRAY DOFF	\N	0	HONDA	246000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.245	BODY PART	253000.00	HON-LEG-LEG-1106	2026-06-18 17:27:37.767	\N
cmlezxmgs023i39t59j6irl4i	FOOTSTEP BLADE 14	\N	0	HONDA	20000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	23000.00	HON-TUT-FOO-1366	2026-02-09 09:55:18.839	\N
cmlezxmn3023y39t5qk0simps	FOOTSTEP BLADE 13	\N	0	HONDA	20000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	23000.00	HON-TUT-FOO-1365	2026-02-09 09:55:18.839	\N
cmlezxmti024c39t533mgdjnk	HANDFAT L/R SMASH	\N	0	HONDA	20000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	23000.00	HON-TUT-HAN-1384	2026-02-09 09:55:18.839	\N
e1e07763-a418-4afa-bea1-0f97d0e65d92	COVER STOP / RR STOP PCX 150 18 BESAR HITAM	\N	0	HONDA	145000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	145000.00	HON-CST-2122	2026-06-18 17:47:31.403	\N
cmlezxbwj01ie39t5vnztirnb	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT SUPRA X 125 HELM IN	\N	0	HONDA	124000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	429000.00	HON-FRO-FRO-981	2026-02-09 09:55:04.848	\N
cmlezxcc301jg39t5up3r3vic	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT LEGENDA 2	\N	0	HONDA	48000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	429000.00	HON-FRO-FRO-1000	2026-02-09 09:55:04.848	\N
cb947897-699e-4e1f-9a92-32751c25d960	COVER STOP / RR STOP PCX 150 18 BESAR PUTIH	\N	0	HONDA	160000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	160000.00	HON-CST-2123	2026-06-18 17:47:31.403	\N
cmlezxco801jj39t5dz83xl71	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT GRAND (C/P)	\N	0	HONDA	58000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.264	LAIN-LAIN	429000.00	HON-FRO-FRO-1002	2026-02-09 09:55:08.264	\N
cmlezxoaw027239t5vql34wls	FILTER UDARA SUPRA X 125	\N	0	HONDA	23000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	26000.00	HON-TUT-FIL-1435	2026-02-09 09:55:22.865	\N
78cdc15a-985d-43c4-b2a1-a768e15a220a	COVER STOP / RR STOP PCX 150 18 KECIL HITAM	\N	0	HONDA	120000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	120000.00	HON-CST-2124	2026-06-18 17:47:31.403	\N
cmlezxonf027n39t5y3opaw1z	UKURAN OLI VARIO TECHNO 125	\N	0	HONDA	9000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	12000.00	HON-TUT-UKU-1451	2026-02-09 09:55:22.865	\N
cmlg43a7a003kpv85sliffx7g	FRONT FENDER/SPAKBOR DEPAN BYSON BIRU	\N	0	YAMAHA	83000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	86000.00	YAM-BOD-FRO-272	2026-02-10 04:39:23.84	\N
cmlg43az8004cpv85pg6fkscw	FRONT FENDER/SPAKBOR DEPAN R15 BIRU	\N	0	YAMAHA	119000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	122000.00	YAM-BOD-FRO-269	2026-02-10 04:39:23.84	\N
cmlg43b8t004spv85ld8h4l0g	REAR FENDER/SPAKBOR BELAKANG VEGA R 04	\N	0	YAMAHA	33000.00	REAR FENDER/SPAKBOR BELAKANG (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	36000.00	YAM-BOD-REA-293	2026-02-10 04:39:23.841	\N
cmlg43bfs0051pv853e7e7p9n	FRONT FENDER/SPAKBOR DEPAN A JUPITER Z 10 HITAM	\N	0	YAMAHA	71000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	74000.00	YAM-BOD-FRO-213	2026-02-10 04:39:23.841	\N
abb076cb-589e-4925-95d7-39547640794a	COVER STOP / RR STOP PCX 150 18 KECIL PUTIH	\N	0	HONDA	130000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	130000.00	HON-CST-2125	2026-06-18 17:47:31.403	\N
b2d6361a-415d-4473-b638-e89690926526	COVER STOP / RR STOP BAWAH VARIO HITAM	\N	0	HONDA	42000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	42000.00	HON-CST-2126	2026-06-18 17:47:31.403	\N
923d7f36-0ba0-43c1-ac92-c0004e5265c7	COVER STOP / RR STOP BAWAH VARIO MERAH MAROON	\N	0	HONDA	46000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	46000.00	HON-CST-2127	2026-06-18 17:47:31.403	\N
cmlg43d82005npv85b18cg9pv	PANEL MIO J HITAM	\N	0	YAMAHA	80000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.554	BODY PART	84000.00	YAM-BOD-PAN-306	2026-06-19 22:06:29.183	01D3030540AA1
cmlezx4oq014m39t5ahm3dno9	COVER TANGKI / COVER MESIN VARIO	\N	0	HONDA	44000.00	COVER TANGKI / COVER MESIN (HONDA)	2026-02-09 09:54:56.889	BODY PART	49000.00	HON-COV-COV-708	2026-06-19 22:06:29.552	01B2236682AA1
cmlezxiry01wz39t5jy87pbfk	FOOTREST BAWAH PCX 150 18 B R+L MERAH DOFF	\N	0	HONDA	298000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	331000.00	HON-LEG-FOO-1272	2026-06-19 22:06:29.684	01B5436587AA6
c515f92d-2f57-4a17-a2fe-b22c87345265	COVER STOP / RR STOP BAWAH VARIO PUTIH	\N	0	HONDA	46000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	46000.00	HON-CST-2128	2026-06-18 17:47:31.403	\N
f148d944-6020-47c1-ac56-c7e6b54c92ca	COVER FOOTSTEP SCOOPY 20	\N	0	HONDA	20000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	20000.00	HON-OTH-2129	2026-06-18 17:47:31.403	\N
cmlezxi4z01v639t5h16vp02g	FOOTREST BAWAH BEAT FI ESP / BEAT POP/VARIO K46	\N	0	HONDA	37000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	40000.00	HON-LEG-FOO-1231	2026-02-09 09:55:15.054	\N
57b83965-381e-4325-a618-12aa5d12204a	COVER FOOTSTEP SUPRA X 125 14 SILVER	\N	0	HONDA	78000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	78000.00	HON-OTH-2130	2026-06-18 17:47:31.403	\N
1de049bb-addd-46be-afeb-c42b2677f8f1	COVER SHOCK BELAKANG BEAT / BEAT 10	\N	0	HONDA	17000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	17000.00	HON-OTH-2131	2026-06-18 17:47:31.403	\N
74b49644-f77b-4392-b7ec-04d6a7a2cd26	COVER LAMPU PLAT NOMOR BEAT 20 / BEAT STREET 20	\N	0	HONDA	23000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	23000.00	HON-OTH-2132	2026-06-18 17:47:31.403	\N
e99d8d24-3bb9-4e7b-a585-80e1f08353a6	TUTUP KIPAS BEAT 24 / BEAT STREET 24 / SCOOPY 24	\N	0	HONDA	30000.00	TUTUP	2026-06-18 17:47:31.403	BODY PART	30000.00	HON-TUT-2133	2026-06-18 17:47:31.403	\N
d612fad2-439f-4c8c-8af8-03ccacfc2f25	TUTUP KNALPOT PCX 150 18 SILVER	\N	0	HONDA	81000.00	TUTUP	2026-06-18 17:47:31.403	BODY PART	81000.00	HON-TUT-2134	2026-06-18 17:47:31.403	\N
cmlezxkty020739t5kgmg4117	CHAIN COVER SUPRA X 125	\N	0	HONDA	19000.00	COVER MESIN SET BEAT FI ESP / VARIO 110 ESP / BEAT POP	2026-02-09 09:55:18.838	BODY PART	22000.00	HON-COV-CHA-1308	2026-02-09 09:55:18.838	\N
cmlezxlhf021839t55otvir5t	TUTUP KNALPOT VARIO TECHNO 125	\N	0	HONDA	37000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	40000.00	HON-TUT-TUT-1327	2026-02-09 09:55:18.839	\N
cmlezxlok021k39t50qabt9my	TUTUP KNALPOT VARIO TECHNO	\N	0	HONDA	41000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	44000.00	HON-TUT-TUT-1330	2026-02-09 09:55:18.839	\N
fa8767db-001d-43e7-b402-f0c61e0c3ce2	DUDUKAN RADIATOR PCX 150 18 / ADV 150	\N	0	HONDA	58000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	58000.00	HON-OTH-2138	2026-06-18 17:47:31.403	\N
cmlezxm5p022u39t5ccpvrwzs	REAR WINKER UNIT GENIO	\N	0	HONDA	62000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	65000.00	HON-TUT-REA-1352	2026-02-09 09:55:18.839	\N
cmlezxmas023639t5s5m6wwu0	REAR WINKER ASSY /	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	0.00	HON-TUT-REA-1354	2026-02-09 09:55:18.839	\N
cmlezxmgi023e39t5vzsacmbq	REAR WINKER ASSY C 700	\N	0	HONDA	53000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	56000.00	HON-TUT-REA-1357	2026-02-09 09:55:18.839	\N
cmlezxmlu023q39t57l6il7wu	FOOTSTEP BLADE 18	\N	0	HONDA	20000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	23000.00	HON-TUT-FOO-1370	2026-02-09 09:55:18.839	\N
cmlezxms8024a39t5hzodmirb	FOOTSTEP BLADE 19	\N	0	HONDA	20000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	23000.00	HON-TUT-FOO-1371	2026-02-09 09:55:18.839	\N
44dccb75-3f8b-4439-99cc-b17b8b934e58	DUDUKAN PANEL BEAT 24 / BEAT STREET 24	\N	0	HONDA	47000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	47000.00	HON-PAN-2139	2026-06-18 17:47:31.403	\N
25b019aa-c520-4230-928b-db8cd88c6091	DUDUKAN PANEL BEAT 20 / BEAT STREET 20	\N	0	HONDA	54000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	54000.00	HON-PAN-2140	2026-06-18 17:47:31.403	\N
cmlezxa1a01e039t5ikoirmub	MIKA SEN Rr / MIKA SEN BELAKANG + STOP SUPRA X (P/M) KO	\N	0	HONDA	40000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	79000.00	HON-MIK-MIK-902	2026-02-09 09:55:04.847	\N
cmlezxo6j026o39t5ju4cg7tg	FILTER UDARA BEAT	\N	0	HONDA	22000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	25000.00	HON-TUT-FIL-1433	2026-02-09 09:55:22.865	\N
cmlezxom6027k39t5cpe27ozk	VISOR /	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	0.00	HON-TUT-VIS-1437	2026-02-09 09:55:22.865	\N
cmlezxosm028239t5ry7j0btw	UKURAN OLI BEAT FI	\N	0	HONDA	8000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	11000.00	HON-TUT-UKU-1452	2026-02-09 09:55:22.865	\N
cmlezxoz6028k39t5nwgf2oxa	PIPA GAS SMASH	\N	0	HONDA	11000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	14000.00	HON-TUT-PIP-1410	2026-02-09 09:55:22.865	\N
cmlg3tfdn0000vtxinvaw7i80	MIKA LAMPU SHOGUN 125 07	\N	0	SUZUKI	55000.00	MIKA LAMPU / SUZUKI)	2026-02-10 04:31:49.787	KELISTRIKAN	58000.00	SUZ-KEL-MIK-19	2026-02-10 04:31:49.787	\N
cmlg3tiwt0002vtxid6n8byqn	PANEL NEW SHOGUN HITAM	\N	0	SUZUKI	41000.00	PANEL / (SUZUKI)	2026-02-10 04:31:49.787	BODY PART	44000.00	SUZ-BOD-PAN-73	2026-02-10 04:31:49.787	\N
cmlg43aoa0042pv851fvrbukd	REAR FENDER/SPAKBOR BELAKANG MIO SOUL	\N	0	YAMAHA	62000.00	REAR FENDER/SPAKBOR BELAKANG (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	65000.00	YAM-BOD-REA-291	2026-02-10 04:39:23.841	\N
cmlg43b0j004gpv85ch4traxu	FRONT FENDER/SPAKBOR DEPAN JUPITER MX 11 HIJAU	\N	0	YAMAHA	94000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	97000.00	YAM-BOD-FRO-223	2026-02-10 04:39:23.841	\N
cmlg43b7h004opv85zo8d99ib	FRONT FORK COVER/COVER SOK DEPAN  JUPITER Z BIRU	\N	0	YAMAHA	57000.00	FRONT FORK COVER/COVER SOK DEPAN (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	60000.00	YAM-BOD-FRO-297	2026-02-10 04:39:23.841	\N
cmlg43b23004kpv85evevabil	FRONT FENDER/SPAKBOR DEPAN A JUPITER Z 10 BIRU MUDA	\N	0	YAMAHA	78000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	81000.00	YAM-BOD-FRO-224	2026-02-10 04:39:23.841	\N
cmlg43bf8004ypv85oh8rtv3k	FRONT FENDER/SPAKBOR DEPAN JUPITER MX MERAH MAROON	\N	0	YAMAHA	88000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	91000.00	YAM-BOD-FRO-217	2026-02-10 04:39:23.841	\N
cmlg43blw005apv85utf63f81	REAR FENDER/SPAKBOR BELAKANG VEGA ZR	\N	0	YAMAHA	58000.00	REAR FENDER/SPAKBOR BELAKANG (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	61000.00	YAM-BOD-REA-294	2026-02-10 04:39:23.841	\N
cmlg43bmh005epv85omff72ei	REAR FENDER/SPAKBOR BELAKANG V-IXION	\N	0	YAMAHA	63000.00	REAR FENDER/SPAKBOR BELAKANG (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	66000.00	YAM-BOD-REA-295	2026-02-10 04:39:23.841	\N
cmlezxabs01em39t5ere2e019	MIKA STOP / MIKA BELAKANG (HONDA)	\N	0	HONDA	0.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	30000.00	HON-MIK-MIK-925	2026-02-09 09:55:04.847	\N
cmlezxaru01fk39t5sphmhuna	MIKA SEN Rr / MIKA SEN BELAKANG + STOP KARISMA (P/M) KO	\N	0	HONDA	38000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	79000.00	HON-MIK-MIK-920	2026-02-09 09:55:04.847	\N
cmlezxay901fw39t5qy98lmh7	MIKA STOP / MIKA BELAKANG GENIO (P)	\N	0	HONDA	32000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	170000.00	HON-MIK-MIK-953	2026-02-09 09:55:04.847	\N
a03a6d85-bd65-4ffe-a877-3a2412099612	COVER SPEEDOMETER VARIO 110 FI / VARIO 110 FI ESP MERAH	\N	0	HONDA	83000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	83000.00	HON-OTH-2141	2026-06-18 17:47:31.403	\N
cmlezxiuk01x239t5m65e580l	FOOTREST BAWAH PCX 150 18 B R+L PUTIH	\N	0	HONDA	298000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	331000.00	HON-LEG-FOO-1273	2026-06-19 22:06:29.947	01B5436547AA1
cmlezxiqn01wq39t5vrf09mj4	FOOTREST BAWAH VARIO 150 18 B R+L MERAH DOFF	\N	0	HONDA	292000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	313000.00	HON-LEG-FOO-1249	2026-06-19 22:06:30.08	01B5236587AA1
711204f7-e148-4ae0-a7f3-e2562c024220	COVER SPEEDOMETER VARIO 110 FI / VARIO 110 FI ESP MERAH MAROON	\N	0	HONDA	83000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	83000.00	HON-OTH-2142	2026-06-18 17:47:31.403	\N
4c4da739-2b67-48f5-960a-3670f519ce4d	COVER SPEEDOMETER VARIO 110 FI / VARIO 110 FI ESP SILVER	\N	0	HONDA	83000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	83000.00	HON-OTH-2143	2026-06-18 17:47:31.403	\N
cmlezxbll01hm39t5lj0ov4wx	FRONT WINKER / SEN DEPAN UNIT SUPRA FIT NEW	\N	0	HONDA	53000.00	FRONT WINKER / SEN DEPAN (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	82000.00	HON-FRO-FRO-974	2026-02-09 09:55:04.848	\N
cmlezxjsa01za39t5963okghp	BOX SAMPING MEGAPRO HITAM	\N	0	HONDA	68000.00	BOX FILTER UDARA	2026-02-09 09:55:15.055	MESIN & OLI	71000.00	HON-BOX-BOX-1292	2026-02-09 09:55:15.055	\N
cmlezxkty020f39t5j61zvrjb	CHAIN COVER SUPRA	\N	0	HONDA	19000.00	COVER MESIN SET BEAT FI ESP / VARIO 110 ESP / BEAT POP	2026-02-09 09:55:18.838	BODY PART	22000.00	HON-COV-CHA-1310	2026-02-09 09:55:18.838	\N
6b1844a9-bd7e-4937-b81b-e723fff8e404	VISOR VARIO 110 FI ESP HITAM	\N	0	HONDA	49000.00	VISOR	2026-06-18 17:47:31.403	BODY PART	49000.00	HON-VIS-2144	2026-06-18 17:47:31.403	\N
fa240a34-21f3-46be-a999-486dccaf1110	LAMPU DEPAN BEAT 24 / BEAT STREET 24 + LED	\N	0	HONDA	351000.00	LAMPU DEPAN	2026-06-18 17:47:31.403	KELISTRIKAN	351000.00	HON-LDP-2146	2026-06-18 17:47:31.403	\N
cmlezxm7g022y39t5zp6mq8x3	REAR WINKER ASSY VARIO 150 18 / 125 23 + LED	\N	0	HONDA	101000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	104000.00	HON-TUT-REA-1355	2026-02-09 09:55:18.839	\N
cmlezxmjc023m39t52r88j9un	FOOTSTEP BLADE 15	\N	0	HONDA	20000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	23000.00	HON-TUT-FOO-1367	2026-02-09 09:55:18.839	\N
cmlezxmok024239t5p5k9zr6j	HANDFAT /	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	0.00	HON-TUT-HAN-1374	2026-02-09 09:55:18.839	\N
f7c93053-55e9-4c52-8db4-7461cc98a991	MIKA SEN Fr STYLO 160	\N	0	HONDA	153000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	153000.00	HON-MIK-2147	2026-06-18 17:47:31.403	\N
5f95e60e-075d-436a-8769-d21f3f42c6a6	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT STYLO 160 + LED	\N	0	HONDA	475000.00	WINKER	2026-06-18 17:47:31.403	KELISTRIKAN	475000.00	HON-WINK-2148	2026-06-18 17:47:31.403	\N
cmlezxbze01im39t52jk5o3a5	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT SUPRA X 125 07	\N	0	HONDA	54000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	429000.00	HON-FRO-FRO-985	2026-02-09 09:55:04.848	\N
cmlezxdgo01lw39t58xppa966	COB LAMPU / FITTING LAMPU MEGAPRO 10	\N	0	HONDA	11000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	17100.00	HON-STO-COB-1067	2026-02-09 09:55:08.265	\N
cmlezxdwc01mx39t55k0c1z6t	COB LAMPU / FITTING LAMPU KARISMA	\N	0	HONDA	11000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	29000.00	HON-STO-COB-1071	2026-02-09 09:55:08.265	\N
cmlezxor8028039t57dnffaqs	UKURAN OLI GRAND	\N	0	HONDA	7000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	10000.00	HON-TUT-UKU-1453	2026-02-09 09:55:22.865	\N
cmlezxmdf023a39t5uje3rqn7	BUNTUT Rr GRAND	\N	0	HONDA	11000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	11000.00	HON-TUT-BUN-1361	2026-02-09 09:55:18.839	\N
cmlg435q30000pv85rmm3toj9	FRONT FENDER/SPAKBOR DEPAN MIO BIRU TUA	\N	0	YAMAHA	70000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.836	BODY PART	73000.00	YAM-BOD-FRO-203	2026-02-10 04:39:23.836	\N
cmlg4369l000apv85rxxg0ed3	FRONT FENDER/SPAKBOR DEPAN JUPITER MX KING 150 MERAH MAROON	\N	0	YAMAHA	140000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.837	BODY PART	143000.00	YAM-BOD-FRO-208	2026-02-10 04:39:23.837	\N
cmlg436l3000gpv85fk1lvcvq	FRONT FENDER/SPAKBOR DEPAN JUPITER MX KING 150 PUTIH	\N	0	YAMAHA	140000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	143000.00	YAM-BOD-FRO-209	2026-02-10 04:39:23.838	\N
cmlg4373h000qpv859hy0eixu	FRONT FENDER/SPAKBOR DEPAN JUPITER MX BIRU MUDA	\N	0	YAMAHA	79000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	82000.00	YAM-BOD-FRO-229	2026-02-10 04:39:23.838	\N
cmlg437ej000wpv85lbm4omno	FRONT FENDER/SPAKBOR DEPAN JUPITER MX HIJAU	\N	0	YAMAHA	79000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	82000.00	YAM-BOD-FRO-230	2026-02-10 04:39:23.838	\N
cmlg437ov0014pv85bfl1rrif	FRONT FENDER/SPAKBOR DEPAN A JUPITER Z 10 HIJAU	\N	0	YAMAHA	78000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	81000.00	YAM-BOD-FRO-235	2026-02-10 04:39:23.838	\N
cmlg437wc0019pv85548dlbzu	FRONT FENDER/SPAKBOR DEPAN A VEGA R 06 MERAH	\N	0	YAMAHA	82000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	85000.00	YAM-BOD-FRO-248	2026-02-10 04:39:23.838	\N
cmlg4385r001fpv85j121m0k5	FRONT FENDER/SPAKBOR DEPAN V-IXION HITAM	\N	0	YAMAHA	73000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.838	BODY PART	76000.00	YAM-BOD-FRO-236	2026-02-10 04:39:23.838	\N
cmlg438eg001kpv85f38kzvaf	FRONT FENDER/SPAKBOR DEPAN A VEGA ZR SILVER	\N	0	YAMAHA	75000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	78000.00	YAM-BOD-FRO-256	2026-02-10 04:39:23.839	\N
cmlg438ke001opv85zsc09yao	FRONT FENDER/SPAKBOR DEPAN V-IXION MERAH MAROON	\N	0	YAMAHA	83000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	86000.00	YAM-BOD-FRO-237	2026-02-10 04:39:23.839	\N
cmlg438s9001upv85qfxt2y52	FRONT FENDER/SPAKBOR DEPAN A VEGA ZR MERAH MAROON	\N	0	YAMAHA	78000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	81000.00	YAM-BOD-FRO-244	2026-02-10 04:39:23.839	\N
cmlg438yc001ypv85ch6qxt2f	FRONT FENDER/SPAKBOR DEPAN V-IXION PUTIH	\N	0	YAMAHA	83000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	86000.00	YAM-BOD-FRO-238	2026-02-10 04:39:23.839	\N
cmlg439ql002wpv852o5pga36	FRONT FENDER/SPAKBOR DEPAN MIO SILVER	\N	0	YAMAHA	67000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	70000.00	YAM-BOD-FRO-206	2026-02-10 04:39:23.84	\N
cmlg43a2j003cpv85nh689gt1	FRONT FENDER/SPAKBOR DEPAN FREGO HITAM	\N	0	YAMAHA	149000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.84	BODY PART	152000.00	YAM-BOD-FRO-280	2026-02-10 04:39:23.84	\N
cmlg43d82005upv85lvys5gpc	FRONT FORK COVER/COVER SOK DEPAN  F1Z-R MERAH	\N	0	YAMAHA	60000.00	FRONT FORK COVER/COVER SOK DEPAN (YAMAHA)	2026-02-10 04:39:33.554	BODY PART	63000.00	YAM-BOD-FRO-301	2026-02-10 04:39:33.554	\N
cmlg43dsz006mpv85fuccn3as	PANEL JUPITER Z 10 HITAM	\N	0	YAMAHA	45000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.555	BODY PART	48000.00	YAM-BOD-PAN-340	2026-02-10 04:39:33.555	\N
25c03661-aec2-43e8-b3c3-e8ba9ddc6ff3	STANDARD SAMPING REVO FI / ABSOLUTE REVO	\N	0	HONDA	41000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	41000.00	HON-STD-2149	2026-06-18 22:23:48.216	\N
cmlezwz6q00t039t5q9ctm878	FRONT HANDLE COVER / BATOK DEPAN VARIO 125 23 HITAM DOFF	\N	0	HONDA	0.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	84000.00	HON-FRO-FRO-534	2026-06-19 22:06:30.211	01B6730080AA1
cmlezxj8401xo39t5zb0mz2yb	FOOTREST BAWAH SCOOPY FI / FI ESP B KREM	\N	0	HONDA	184000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	184000.00	HON-LEG-FOO-1262	2026-06-19 22:06:30.344	01B4336583AA1
cmlezwzvw00us39t5zpdzwq0y	FRONT HANDLE COVER / BATOK DEPAN VARIO 125 23 HITAM DOFF	\N	0	HONDA	0.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	84000.00	HON-FRO-FRO-556	2026-06-19 22:06:30.476	01B6730080AA1
cmlg43dzh006wpv859uw3mejb	PANEL JUPITER Z 06 HITAM	\N	0	YAMAHA	53000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	56000.00	YAM-BOD-PAN-341	2026-02-10 04:39:33.556	\N
cmlg43elh008apv85ez2kwquj	FRONT HANDLE COVER/ BATOK DEPAN MIO J PUTIH	\N	0	YAMAHA	75000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	78000.00	YAM-BOD-FRO-379	2026-02-10 04:39:33.556	\N
cmlg43oje00oapv857vb7kl6j	COVER STOP / RR STOP JUPITER MERAH	\N	0	YAMAHA	29000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.568	BODY PART	32000.00	YAM-BOD-COV-621	2026-06-18 17:35:37.871	\N
cmlg43f7u009kpv85fau6gpp8	FRONT HANDLE COVER/ BATOK DEPAN MIO BIRU TUA	\N	0	YAMAHA	52000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	55000.00	YAM-BOD-FRO-392	2026-02-10 04:39:33.557	\N
cmlg43fm200a1pv85wp2u1mkz	PANEL DEPAN BAGIAN BAWAH X-RIDE	\N	0	YAMAHA	69000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	72000.00	YAM-BOD-PAN-373	2026-02-10 04:39:33.557	\N
cmlg43fu600aipv858t1f01fb	FRONT HANDLE COVER/ BATOK DEPAN JUPITER MX HITAM (KOPLING)	\N	0	YAMAHA	59000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	62000.00	YAM-BOD-FRO-400	2026-02-10 04:39:33.557	\N
cmlg43gdx00b4pv85vmxly6xk	FRONT HANDLE COVER/ BATOK DEPAN JUPITER Z 06 HITAM	\N	0	YAMAHA	68000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.653	BODY PART	71000.00	YAM-BOD-FRO-404	2026-02-10 04:39:37.653	\N
cmlg43gln00bkpv85at82bhqe	FRONT HANDLE COVER/ BATOK DEPAN VEGA R 04 MERAH CAKRAM	\N	0	YAMAHA	70000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.654	BODY PART	73000.00	YAM-BOD-FRO-423	2026-02-10 04:39:37.654	\N
cmlg43gyj00cnpv85kvtfvfs5	MIKA LAMPU MIO M3	\N	0	YAMAHA	102000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	105000.00	YAM-KEL-MIK-433	2026-02-10 04:39:37.654	\N
cmlg43h4t00cwpv8516npb2ar	FRONT HANDLE COVER/ BATOK DEPAN JUPITER Z 10 HITAM	\N	0	YAMAHA	70000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.654	BODY PART	73000.00	YAM-BOD-FRO-414	2026-02-10 04:39:37.654	\N
cmlg43hb400ddpv85a6n6l8lx	MIKA LAMPU MIO SOUL GT 125 BLUE CORE	\N	0	YAMAHA	107000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	110000.00	YAM-KEL-MIK-434	2026-02-10 04:39:37.654	\N
cmlg43hhk00dqpv85b56klz9x	MIKA LAMPU JUPITER MX	\N	0	YAMAHA	49000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	52000.00	YAM-KEL-MIK-445	2026-02-10 04:39:37.654	\N
cmlg43hpw00eapv8519z8a338	MIKA LAMPU JUPITER	\N	0	YAMAHA	55000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	58000.00	YAM-KEL-MIK-446	2026-02-10 04:39:37.655	\N
cmlg43i0f00ekpv85r4iy8sc4	MIKA SEN Fr / MIKA SEN DEPAN  MIO SOUL GT 125 BLUE CORE	\N	0	YAMAHA	50000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	53000.00	YAM-KEL-MIK-467	2026-02-10 04:39:37.655	\N
cmlg43ice00f6pv85xunvvrqr	MIKA SEN Fr / MIKA SEN DEPAN  MIO (P) KO	\N	0	YAMAHA	15000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	18000.00	YAM-KEL-MIK-468	2026-02-10 04:39:37.655	\N
cmlg43im900flpv85zd3nouuu	MIKA SPEEDOMETER MIO 08	\N	0	YAMAHA	26000.00	MIKA SPEEDOMETER (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	29000.00	YAM-KEL-MIK-495	2026-02-10 04:39:37.655	\N
cmlg43iu600g2pv857glc32sb	MIKA SEN Rr / MIKA SEN BELAKANG  + STOP F1 (C/M) KO	\N	0	YAMAHA	33000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	36000.00	YAM-KEL-MIK-490	2026-02-10 04:39:37.655	\N
cmlg43j9j00gcpv85vsmmw0c2	FRONT HANDLE COVER/ BATOK DEPAN VEGA R 06 SILVER CAKRAM	\N	0	YAMAHA	75000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.655	BODY PART	78000.00	YAM-BOD-FRO-426	2026-02-10 04:39:37.655	\N
cmlg43jt500glpv854k6sqmud	MIKA SPEEDOMETER JUPITER MX	\N	0	YAMAHA	24000.00	MIKA SPEEDOMETER (YAMAHA)	2026-02-10 04:39:42.089	KELISTRIKAN	27000.00	YAM-KEL-MIK-502	2026-02-10 04:39:42.089	\N
cmlg43k5700hdpv85cxg7ssbd	LAMPU DEPAN MIO SOUL	\N	0	YAMAHA	199000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	202000.00	YAM-KEL-LAM-533	2026-02-10 04:39:42.09	\N
cmlg43ksb00iipv853o74ai86	FRONT WINKER / SEN DEPAN ASSY JUPITER MX 11	\N	0	YAMAHA	121000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	124000.00	YAM-KEL-FRO-569	2026-02-10 04:39:42.091	\N
cmlg43l1z00izpv85xo6j8ltq	FRONT WINKER / SEN DEPAN ASSY VEGA R 04	\N	0	YAMAHA	51000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	54000.00	YAM-KEL-FRO-573	2026-02-10 04:39:42.091	\N
cmlg43l9i00jepv850uynxur3	MIKA STOP/MIKA BELAKANG JUPITER MX BESAR (P)	\N	0	YAMAHA	38000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	41000.00	YAM-KEL-MIK-518	2026-02-10 04:39:42.091	\N
cmlg43lhe00jupv85n0q0km59	LAMPU DEPAN FINO FI 18	\N	0	YAMAHA	178000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	181000.00	YAM-KEL-LAM-548	2026-02-10 04:39:42.091	\N
cmlg43lo600k8pv85gqlocb5x	LAMPU DEPAN F1	\N	0	YAMAHA	57000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	60000.00	YAM-KEL-LAM-557	2026-02-10 04:39:42.092	\N
cmlg43lvr00kgpv85y2wlszve	STOP LAMP ASSY / LAMPU STOP MIO M3	\N	0	YAMAHA	95000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	98000.00	YAM-KEL-STO-587	2026-02-10 04:39:42.092	\N
cmlg43m2600kqpv857j20dedy	STOP LAMP RX KING (P)	\N	0	YAMAHA	48000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	51000.00	YAM-KEL-STO-592	2026-02-10 04:39:42.092	\N
cmlg43mas00l1pv85uih8jo77	MIKA STOP/MIKA BELAKANG JUPITER MX KECIL (M)	\N	0	YAMAHA	28000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	31000.00	YAM-KEL-MIK-521	2026-02-10 04:39:42.092	\N
cmlg43mpr00lqpv85v82u62pp	LAMPU DEPAN MIO J	\N	0	YAMAHA	83000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	86000.00	YAM-KEL-LAM-535	2026-02-10 04:39:42.092	\N
cmlg43n9i00m4pv85mihnthn7	COB LAMPU / FITTING LAMPU  JUPITER Z	\N	0	YAMAHA	16000.00	COB LAMP / FITTING LAMPU YAMAHA)	2026-02-10 04:39:46.567	KELISTRIKAN	19000.00	YAM-KEL-COB-608	2026-02-10 04:39:46.567	\N
cmlg43o1000nbpv85bmntmt1z	BOX SAMPING / TUTUP AKI JUPITER Z 10	\N	0	YAMAHA	39000.00	BOX SAMPING / TUTUP AKI (YAMAHA)	2026-02-10 04:39:46.568	KELISTRIKAN	42000.00	YAM-KEL-BOX-644	2026-02-10 04:39:46.568	\N
cmlg43p2z00okpv85z5pbkxkk	COVER STOP / RR STOP VEGA ZR HITAM	\N	0	YAMAHA	27000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.568	BODY PART	30000.00	YAM-BOD-COV-631	2026-06-18 17:35:37.871	\N
cmlg43d82005tpv85viifgyhl	PANEL MIO SOUL HIJAU	\N	0	YAMAHA	156000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.555	BODY PART	159000.00	YAM-BOD-PAN-316	2026-02-10 04:39:33.555	\N
cmlg43dji0065pv85tb7zmsm4	PANEL MIO MERAH MAROON	\N	0	YAMAHA	106000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.555	BODY PART	109000.00	YAM-BOD-PAN-328	2026-02-10 04:39:33.555	\N
cmlg43e0u0072pv858ru11mr5	PANEL VEGA ZR HITAM	\N	0	YAMAHA	114000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	117000.00	YAM-BOD-PAN-357	2026-02-10 04:39:33.556	\N
cmlg43ece007jpv85dm1xwixv	PANEL DEPAN BAGIAN BAWAH MIO J	\N	0	YAMAHA	46000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	51000.00	YAM-BOD-PAN-369	2026-06-19 22:06:30.86	01D3035182AA1
cmlezx59p015g39t51f7nxwaz	LAMPU DEPAN / HEAD LAMP VARIO 150 18 + LED	\N	0	HONDA	896000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	829000.00	HON-LAM-LAM-739	2026-06-19 22:06:31.213	01B5200200AA1
cmlg43evt008ypv851uwtcwub	PANEL JUPITER MX SILVER	\N	0	YAMAHA	98000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	101000.00	YAM-BOD-PAN-352	2026-02-10 04:39:33.556	\N
cmlg43fa3009mpv85t27yw7xo	PANEL VEGA ZR BIRU MUDA	\N	0	YAMAHA	129000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	132000.00	YAM-BOD-PAN-363	2026-02-10 04:39:33.557	\N
cmlg43fo700aapv85tztl55ow	FRONT HANDLE COVER/ BATOK DEPAN JUPITER MX KING 150 + VISOR PUTIH	\N	0	YAMAHA	139000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	142000.00	YAM-BOD-FRO-399	2026-02-10 04:39:33.557	\N
cmlg43fwl00aopv85b95l2b9j	PANEL MIO MERAH	\N	0	YAMAHA	90000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	93000.00	YAM-BOD-PAN-324	2026-02-10 04:39:33.557	\N
cmlg43gdx00bdpv857tutmz60	FRONT HANDLE COVER/ BATOK DEPAN VEGA R 06 MERAH CAKRAM	\N	0	YAMAHA	75000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.654	BODY PART	78000.00	YAM-BOD-FRO-420	2026-02-10 04:39:37.654	\N
cmlg43gnd00bspv8587wu6xgo	MIKA LAMPU MIO SOUL GT	\N	0	YAMAHA	97000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	100000.00	YAM-KEL-MIK-436	2026-02-10 04:39:37.654	\N
cmlg43gv200ccpv851ob30lwa	MIKA LAMPU JUPITER Z1	\N	0	YAMAHA	84000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	87000.00	YAM-KEL-MIK-441	2026-02-10 04:39:37.654	\N
cmlg43h4800cspv85c2tg792t	MIKA LAMPU VEGA R 06	\N	0	YAMAHA	44000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	47000.00	YAM-KEL-MIK-452	2026-02-10 04:39:37.654	\N
cmlg43hb400dcpv85tsu1w6or	MIKA LAMPU VEGA R 04	\N	0	YAMAHA	25000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	28000.00	YAM-KEL-MIK-453	2026-02-10 04:39:37.654	\N
cmlg43hi800dspv850dpkwzwk	FRONT HANDLE COVER/ BATOK DEPAN VEGA ZR HITAM	\N	0	YAMAHA	73000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.655	BODY PART	76000.00	YAM-BOD-FRO-415	2026-02-10 04:39:37.655	\N
cmlg43hpw00e8pv8566u9bwno	MIKA SEN Fr / MIKA SEN DEPAN  VEGA R 04 (P) KO	\N	0	YAMAHA	19000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	22000.00	YAM-KEL-MIK-481	2026-02-10 04:39:37.655	\N
cmlg43i0f00eipv85gwx9zwbc	MIKA LAMPU V-IXION 12	\N	0	YAMAHA	54000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	57000.00	YAM-KEL-MIK-447	2026-02-10 04:39:37.655	\N
cmlg43ib000f0pv85uceb0u78	FRONT HANDLE COVER/ BATOK DEPAN VEGA ZR MERAH MAROON	\N	0	YAMAHA	84000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.655	BODY PART	87000.00	YAM-BOD-FRO-416	2026-02-10 04:39:37.655	\N
cmlg43im900fipv85h12te3wn	FRONT HANDLE COVER/ BATOK DEPAN JUPITER MX KING 150 + VISOR HITAM	\N	0	YAMAHA	131000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.655	BODY PART	134000.00	YAM-BOD-FRO-417	2026-02-10 04:39:37.655	\N
cmlg43iu400fypv85vus1e9y8	MIKA SEN Fr / MIKA SEN DEPAN  MIO J	\N	0	YAMAHA	49000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	52000.00	YAM-KEL-MIK-469	2026-02-10 04:39:37.655	\N
cmlg43jt500gupv8525ii6tqm	MIKA SPEEDOMETER V-IXION	\N	0	YAMAHA	54000.00	MIKA SPEEDOMETER (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	57000.00	YAM-KEL-MIK-507	2026-02-10 04:39:42.09	\N
cmlg43k1t00hapv852n4i91sj	MIKA STOP/MIKA BELAKANG MIO SOUL GT BESAR (P) + KECIL (M)	\N	0	YAMAHA	66000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	69000.00	YAM-KEL-MIK-509	2026-02-10 04:39:42.09	\N
cmlg43kb700hspv85pqgxs8mj	LAMPU DEPAN ALFA	\N	0	YAMAHA	56000.00	LAMPU DEPAN ALFA (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	59000.00	YAM-KEL-LAM-558	2026-02-10 04:39:42.09	\N
cmlg43kia00i2pv855rjrqldq	LAMPU DEPAN VEGA R 04	\N	0	YAMAHA	59000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	62000.00	YAM-KEL-LAM-545	2026-02-10 04:39:42.09	\N
cmlg43kpl00iapv85ripiyn1i	FRONT WINKER / SEN DEPAN ASSY X-RIDE	\N	0	YAMAHA	107000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	110000.00	YAM-KEL-FRO-564	2026-02-10 04:39:42.091	\N
cmlg43ky000iupv85crfqm1kn	FRONT WINKER / SEN DEPAN ASSY MIO	\N	0	YAMAHA	70000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	73000.00	YAM-KEL-FRO-565	2026-02-10 04:39:42.091	\N
cmlg43l7300jcpv85nzyg6b5y	FRONT WINKER / SEN DEPAN ASSY MIO J	\N	0	YAMAHA	91000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	94000.00	YAM-KEL-FRO-566	2026-02-10 04:39:42.091	\N
cmlg43lfx00jspv85j9jjwl02	Fr / Rr WINKER ASSY / SEN KANAN KIRI  V-IXION 12 VARIASI	\N	0	YAMAHA	77000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	80000.00	YAM-KEL-FRR-582	2026-02-10 04:39:42.091	\N
cmlg43mas00l0pv85cokdovxy	FRONT WINKER / SEN DEPAN ASSY JUPITER MX	\N	0	YAMAHA	74000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	77000.00	YAM-KEL-FRO-568	2026-02-10 04:39:42.092	\N
cmlg43mk700ljpv85r2qar65w	MIKA STOP/MIKA BELAKANG MIO SOUL BESAR (P) + KECIL (M)	\N	0	YAMAHA	53000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	56000.00	YAM-KEL-MIK-512	2026-02-10 04:39:42.092	\N
cmlg43mua00m0pv85otdqd1n6	LAMPU DEPAN VEGA ZR	\N	0	YAMAHA	87000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	90000.00	YAM-KEL-LAM-543	2026-02-10 04:39:42.092	\N
cmlg43n9i00m8pv85ll0cta5h	COB LAMPU / FITTING LAMPU  MIO M3	\N	0	YAMAHA	17000.00	COB LAMP / FITTING LAMPU YAMAHA)	2026-02-10 04:39:46.567	KELISTRIKAN	20000.00	YAM-KEL-COB-602	2026-02-10 04:39:46.567	\N
cmlg43o1000n7pv850976wsre	COVER TANGKI / COVER MESIN VEGA R 04	\N	0	YAMAHA	37000.00	COVER TANGKI / COVER MESIN (YAMAHA)	2026-02-10 04:39:46.568	BODY PART	40000.00	YAM-BOD-COV-637	2026-02-10 04:39:46.568	\N
cmlg43nlh00mmpv856dafda3n	COVER STOP / RR STOP JUPITER Z 10 MERAH MAROON	\N	0	YAMAHA	26000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.567	BODY PART	29000.00	YAM-BOD-COV-618	2026-06-18 17:35:37.871	\N
cmlg43dp7006bpv85sxymz32z	PANEL JUPITER Z1 MERAH MAROON	\N	0	YAMAHA	259000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.555	BODY PART	262000.00	YAM-BOD-PAN-337	2026-02-10 04:39:33.555	\N
cmlg43e060070pv852r69y1r5	PANEL MIO J MERAH MAROON	\N	0	YAMAHA	95000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	98000.00	YAM-BOD-PAN-330	2026-02-10 04:39:33.556	\N
cmlg43e6p007cpv85bmm4046e	PANEL MIO GT MERAH MAROON	\N	0	YAMAHA	90000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	93000.00	YAM-BOD-PAN-305	2026-02-10 04:39:33.556	\N
cmlg43ekm0082pv85knu80yrt	FRONT HANDLE COVER/ BATOK DEPAN MIO J HITAM	\N	0	YAMAHA	60000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	63000.00	YAM-BOD-FRO-377	2026-02-10 04:39:33.556	\N
cmlg43er9008kpv85o5ll7xc2	FRONT HANDLE COVER/ BATOK DEPAN MIO 08 BIRU MUDA	\N	0	YAMAHA	62000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	65000.00	YAM-BOD-FRO-383	2026-02-10 04:39:33.556	\N
cmlg43e98007gpv85jau0qllw	PANEL MIO BIRU TUA	\N	0	YAMAHA	0.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	111000.00	YAM-BOD-PAN-321	2026-06-19 22:06:31.539	01D1930560AA1
cmlg43eyk0095pv85ofipl89j	FRONT HANDLE COVER/ BATOK DEPAN MIO HITAM	\N	0	YAMAHA	47000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	50000.00	YAM-BOD-FRO-387	2026-02-10 04:39:33.556	\N
cmlg43f6u009ipv85oex6rsnr	FRONT HANDLE COVER/ BATOK DEPAN MIO KUNING	\N	0	YAMAHA	52000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	55000.00	YAM-BOD-FRO-391	2026-02-10 04:39:33.557	\N
cmlg43fm200a0pv85kvg1acg7	FRONT HANDLE COVER/ BATOK DEPAN MIO PUTIH	\N	0	YAMAHA	52000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	55000.00	YAM-BOD-FRO-396	2026-02-10 04:39:33.557	\N
cmlg43fu600akpv85205q4b2l	FRONT HANDLE COVER/ BATOK DEPAN MIO M3 HITAM	\N	0	YAMAHA	65000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	68000.00	YAM-BOD-FRO-374	2026-02-10 04:39:33.557	\N
cmlg43gdx00b1pv85a4y0oqqo	FRONT HANDLE COVER/ BATOK DEPAN JUPITER MX HITAM (NON KOPLING)	\N	0	YAMAHA	55000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.653	BODY PART	58000.00	YAM-BOD-FRO-401	2026-02-10 04:39:37.653	\N
cmlg43god00bypv854v6d4mj4	MIKA LAMPU MIO SOUL	\N	0	YAMAHA	115000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	118000.00	YAM-KEL-MIK-438	2026-02-10 04:39:37.654	\N
cmlg43gw300cgpv85r7sd7wl3	FRONT HANDLE COVER/ BATOK DEPAN JUPITER MX 11 HITAM	\N	0	YAMAHA	76000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.654	BODY PART	79000.00	YAM-BOD-FRO-413	2026-02-10 04:39:37.654	\N
cmlg43h5u00d4pv85b8obcmem	MIKA LAMPU AEROX 155	\N	0	YAMAHA	165000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	168000.00	YAM-KEL-MIK-463	2026-02-10 04:39:37.654	\N
cmlg43hdr00dgpv85uiqwbh1c	MIKA SEN Fr / MIKA SEN DEPAN  MIO SOUL GT 125 BLUE CORE	\N	0	YAMAHA	50000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	53000.00	YAM-KEL-MIK-471	2026-02-10 04:39:37.654	\N
ee05f6af-963d-4586-8cc3-111049bf7716	KARET TROMOL KARISMA/REVO/KIRANA/SUPRA FIT NEW/SUPRA X 125/SUPRA X 125 07	\N	0	HONDA	8800.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	8800.00	HON-OTH-2155	2026-06-18 17:47:31.403	\N
cmlg43hxh00egpv85sd60uqh1	MIKA SEN Rr / MIKA SEN BELAKANG  + STOP VEGA ZR 11	\N	0	YAMAHA	57000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	60000.00	YAM-KEL-MIK-483	2026-02-10 04:39:37.655	\N
cmlg43i6r00eypv854rt9rk57	MIKA LAMPU XEON RC	\N	0	YAMAHA	241000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	244000.00	YAM-KEL-MIK-456	2026-02-10 04:39:37.655	\N
cmlg43ig400fgpv85ndykm7aj	MIKA SEN Fr / MIKA SEN DEPAN  VEGA ZR (P)	\N	0	YAMAHA	22000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	25000.00	YAM-KEL-MIK-480	2026-02-10 04:39:37.655	\N
cmlg43irl00frpv857lt88nri	MIKA LAMPU XEON	\N	0	YAMAHA	99000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	102000.00	YAM-KEL-MIK-457	2026-02-10 04:39:37.655	\N
cmlg43jam00ghpv85sjt88620	FRONT HANDLE COVER/ BATOK DEPAN F1Z-R BIRU KOPLING	\N	0	YAMAHA	77000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.655	BODY PART	80000.00	YAM-BOD-FRO-429	2026-02-10 04:39:37.655	\N
cmlg43jt500gnpv85xsdnx79s	MIKA SPEEDOMETER F1Z-R	\N	0	YAMAHA	22000.00	MIKA SPEEDOMETER (YAMAHA)	2026-02-10 04:39:42.089	KELISTRIKAN	25000.00	YAM-KEL-MIK-506	2026-02-10 04:39:42.089	\N
cmlg43jzu00h2pv85lp7crxom	MIKA STOP/MIKA BELAKANG JUPITER Z 10 KECIL (M)	\N	0	YAMAHA	61000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	64000.00	YAM-KEL-MIK-522	2026-02-10 04:39:42.09	\N
cmlg43k8900hnpv8555g3cu9s	LAMPU DEPAN V-IXION 10	\N	0	YAMAHA	128000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	131000.00	YAM-KEL-LAM-551	2026-02-10 04:39:42.09	\N
cmlg43kg000hwpv855rfzb9dm	LAMPU DEPAN V-IXION 12	\N	0	YAMAHA	131000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	134000.00	YAM-KEL-LAM-552	2026-02-10 04:39:42.09	\N
cmlg43kmg00i5pv85krrq3fdg	FRONT WINKER / SEN DEPAN ASSY NEW N-MAX	\N	0	YAMAHA	185000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	188000.00	YAM-KEL-FRO-562	2026-02-10 04:39:42.09	\N
cmlg43ktm00impv850mvefkyi	LAMPU DEPAN N-MAX + LED	\N	0	YAMAHA	578000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	581000.00	YAM-KEL-LAM-546	2026-02-10 04:39:42.091	\N
cmlg43l1z00j1pv856te8pbx1	REAR WINKER / SEN BELAKANG (YAMAHA)	\N	0	YAMAHA	0.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	0.00	YAM-KEL-REA-576	2026-02-10 04:39:42.091	\N
cmlg43led00jopv85ect6w4ax	Fr / Rr WINKER ASSY / SEN KANAN KIRI  V-IXION 12	\N	0	YAMAHA	77000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	80000.00	YAM-KEL-FRR-581	2026-02-10 04:39:42.091	\N
cmlg43ms000lxpv852hauez0v	LAMPU DEPAN JUPITER MX	\N	0	YAMAHA	82000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	85000.00	YAM-KEL-LAM-536	2026-02-10 04:39:42.092	\N
cmlg43n9j00mipv85a6ddv8fi	COB LAMPU / FITTING LAMPU  MIO	\N	0	YAMAHA	11000.00	COB LAMP / FITTING LAMPU YAMAHA)	2026-02-10 04:39:46.567	KELISTRIKAN	14000.00	YAM-KEL-COB-605	2026-02-10 04:39:46.567	\N
cmlg43nva00mwpv85jg31aq4z	COVER TANGKI / COVER MESIN JUPITER MX 11	\N	0	YAMAHA	28000.00	COVER TANGKI / COVER MESIN (YAMAHA)	2026-02-10 04:39:46.567	BODY PART	31000.00	YAM-BOD-COV-634	2026-02-10 04:39:46.567	\N
cmlg43o2m00nepv858ei66ea2	BOX SAMPING / TUTUP AKI JUPITER Z 06	\N	0	YAMAHA	54000.00	BOX SAMPING / TUTUP AKI (YAMAHA)	2026-02-10 04:39:46.568	KELISTRIKAN	57000.00	YAM-KEL-BOX-646	2026-02-10 04:39:46.568	\N
cmlg43oat00nopv85ackmfvdf	COB LAMPU / FITTING LAMPU  XEON	\N	0	YAMAHA	16000.00	COB LAMP / FITTING LAMPU YAMAHA)	2026-02-10 04:39:46.568	KELISTRIKAN	19000.00	YAM-KEL-COB-609	2026-02-10 04:39:46.568	\N
cmlg43oib00nzpv85e2secho8	FOOTREST BAWAH MIO 08/ KOLONG	\N	0	YAMAHA	50000.00	FOOTREST (YAMAHA)	2026-02-10 04:39:46.568	BODY PART	53000.00	YAM-BOD-FOO-659	2026-02-10 04:39:46.568	\N
cmlg43p2000oipv85ho0kxw6c	COVER TANGKI / COVER MESIN MIO	\N	0	YAMAHA	39000.00	COVER TANGKI / COVER MESIN (YAMAHA)	2026-02-10 04:39:46.568	BODY PART	42000.00	YAM-BOD-COV-639	2026-02-10 04:39:46.568	\N
cmlezx667016u39t5juarqg2j	LAMPU DEPAN / HEAD LAMP GENIO + LED	\N	0	HONDA	663000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	829000.00	HON-LAM-LAM-778	2026-06-18 17:19:42.083	\N
cmlg43d82005jpv85ibpeyg52	PANEL MIO SOUL GT HITAM VIOLET	\N	0	YAMAHA	80000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.554	BODY PART	83000.00	YAM-BOD-PAN-308	2026-02-10 04:39:33.554	\N
cmlg43dp70068pv85uu32li6t	PANEL JUPITER Z1 BIRU	\N	0	YAMAHA	259000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.555	BODY PART	262000.00	YAM-BOD-PAN-336	2026-02-10 04:39:33.555	\N
cmlg43e110074pv85m0imsaz6	PANEL N-MAX BESAR BIRU	\N	0	YAMAHA	107000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	110000.00	YAM-BOD-PAN-365	2026-02-10 04:39:33.556	\N
cmlg43emz008epv85h4v1oydk	PANEL MIO BIRU	\N	0	YAMAHA	90000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	93000.00	YAM-BOD-PAN-322	2026-02-10 04:39:33.556	\N
cmlg43etg008upv85bckix5y8	PANEL VEGA ZR PUTIH	\N	0	YAMAHA	129000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	132000.00	YAM-BOD-PAN-362	2026-02-10 04:39:33.556	\N
cmlg43f6u009epv85gsjs6myd	PANEL MIO KUNING	\N	0	YAMAHA	106000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	109000.00	YAM-BOD-PAN-323	2026-02-10 04:39:33.557	\N
cmlg43fgt009ypv85ai178a6u	FRONT HANDLE COVER/ BATOK DEPAN MIO MERAH MAROON	\N	0	YAMAHA	57000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	60000.00	YAM-BOD-FRO-395	2026-02-10 04:39:33.557	\N
cmlg43fpy00aepv85kzxqhcyo	PANEL MIO SILVER	\N	0	YAMAHA	90000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	93000.00	YAM-BOD-PAN-334	2026-02-10 04:39:33.557	\N
cmlg43fx700avpv85bqgddcvd	PANEL MIO M3 KECIL/DASI KUNING	\N	0	YAMAHA	83000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	86000.00	YAM-BOD-PAN-325	2026-02-10 04:39:33.557	\N
cmlg43gdx00b2pv85w2mb2zo7	FRONT HANDLE COVER/ BATOK DEPAN JUPITER Z BIRU	\N	0	YAMAHA	81000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.653	BODY PART	84000.00	YAM-BOD-FRO-403	2026-02-10 04:39:37.653	\N
cmlg43gnd00bqpv853jpqfek8	FRONT HANDLE COVER/ BATOK DEPAN F1Z-R MERAH KOPLING	\N	0	YAMAHA	71000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.654	BODY PART	74000.00	YAM-BOD-FRO-430	2026-02-10 04:39:37.654	\N
cmlg43gv300cepv851fcg9936	MIKA LAMPU VEGA ZR	\N	0	YAMAHA	50000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	53000.00	YAM-KEL-MIK-451	2026-02-10 04:39:37.654	\N
cmlg43h5100d0pv85o6k2tf2e	MIKA LAMPU FORCE	\N	0	YAMAHA	64000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	67000.00	YAM-KEL-MIK-462	2026-02-10 04:39:37.654	\N
cmlg43hf400dopv85g2qog2mr	MIKA LAMPU NEW N-MAX (PC)	\N	0	YAMAHA	210000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	213000.00	YAM-KEL-MIK-454	2026-02-10 04:39:37.654	\N
cmlg43hlt00e2pv85pd955sbl	MIKA SEN Fr / MIKA SEN DEPAN  JUPITER Z1	\N	0	YAMAHA	50000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	53000.00	YAM-KEL-MIK-477	2026-02-10 04:39:37.655	\N
cmlg43i1300eopv85vxthjsdc	MIKA SEN Fr / MIKA SEN DEPAN  F1Z-R (P) KO	\N	0	YAMAHA	18000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	21000.00	YAM-KEL-MIK-486	2026-02-10 04:39:37.655	\N
cmlg43ib000f2pv85q05i4q1s	MIKA LAMPU V-IXION	\N	0	YAMAHA	43000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	46000.00	YAM-KEL-MIK-448	2026-02-10 04:39:37.655	\N
cmlg43inf00fopv85khbulupw	MIKA LAMPU V-IXION 16	\N	0	YAMAHA	74000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	77000.00	YAM-KEL-MIK-449	2026-02-10 04:39:37.655	\N
cmlg43iu600g0pv85lrg2ujsn	MIKA SPEEDOMETER JUPITER Z1	\N	0	YAMAHA	27000.00	MIKA SPEEDOMETER (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	30000.00	YAM-KEL-MIK-500	2026-02-10 04:39:37.655	\N
cmlg43j9j00gapv85zk703fai	FRONT HANDLE COVER/ BATOK DEPAN F1Z-R HITAM KOPLING	\N	0	YAMAHA	60000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.655	BODY PART	63000.00	YAM-BOD-FRO-428	2026-02-10 04:39:37.655	\N
cmlg43jzu00h6pv859evfbs9o	MIKA SPEEDOMETER VEGA ZR	\N	0	YAMAHA	25000.00	MIKA SPEEDOMETER (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	28000.00	YAM-KEL-MIK-505	2026-02-10 04:39:42.09	\N
cmlg43k8900hlpv85vxqr6sjc	MIKA STOP/MIKA BELAKANG V-IXION BESAR (P)	\N	0	YAMAHA	45000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	48000.00	YAM-KEL-MIK-525	2026-02-10 04:39:42.09	\N
cmlg43kg000hvpv85vjsn5bjq	STAY LAMPU DEPAN JUPITER Z 06	\N	0	YAMAHA	30000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	33000.00	YAM-KEL-STA-559	2026-02-10 04:39:42.09	\N
cmlg43kmg00i6pv85dwpptuz0	MIKA STOP/MIKA BELAKANG V-IXION 12	\N	0	YAMAHA	38000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	41000.00	YAM-KEL-MIK-527	2026-02-10 04:39:42.091	\N
cmlg43kuh00ippv85q9ojbys6	MIKA STOP/MIKA BELAKANG RX KING 05 KO	\N	0	YAMAHA	30000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	33000.00	YAM-KEL-MIK-528	2026-02-10 04:39:42.091	\N
cmlg43l1z00j0pv854ekq8l1y	FRONT WINKER / SEN DEPAN ASSY F1Z-R MK	\N	0	YAMAHA	67000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	70000.00	YAM-KEL-FRO-575	2026-02-10 04:39:42.091	\N
cmlg43lec00jmpv85088xrrsz	Fr / Rr WINKER ASSY / SEN KANAN KIRI  NEW V-IXION 17 / R15 NEW	\N	0	YAMAHA	101000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	104000.00	YAM-KEL-FRR-579	2026-02-10 04:39:42.091	\N
cmlg43mde00l8pv85enqah17c	STOP LAMP ASSY / LAMPU STOP JUPITER Z 10	\N	0	YAMAHA	107000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	110000.00	YAM-KEL-STO-596	2026-02-10 04:39:42.092	\N
cmlg43mr600ltpv85j6aoga3y	LAMPU DEPAN JUPITER MX 11	\N	0	YAMAHA	115000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	118000.00	YAM-KEL-LAM-540	2026-02-10 04:39:42.092	\N
cmlg43n9i00m6pv85eybb5kke	COB LAMPU / FITTING LAMPU  RX KING 05	\N	0	YAMAHA	9000.00	COB LAMP / FITTING LAMPU YAMAHA)	2026-02-10 04:39:46.567	KELISTRIKAN	12000.00	YAM-KEL-COB-610	2026-02-10 04:39:46.567	\N
cmlg43o1000n8pv857msavmfs	BOX SAMPING / TUTUP AKI V-IXION	\N	0	YAMAHA	63000.00	BOX SAMPING / TUTUP AKI (YAMAHA)	2026-02-10 04:39:46.568	KELISTRIKAN	66000.00	YAM-KEL-BOX-645	2026-02-10 04:39:46.568	\N
cmlg43oib00nypv85tnt7xd9e	BOX SAMPING / TUTUP AKI F1Z-R HITAM	\N	0	YAMAHA	38000.00	BOX SAMPING / TUTUP AKI (YAMAHA)	2026-02-10 04:39:46.568	KELISTRIKAN	41000.00	YAM-KEL-BOX-647	2026-02-10 04:39:46.568	\N
cmlg43pp700pupv85qqc5aacx	BOX SAMPING / TUTUP AKI F1Z-R MERAH	\N	0	YAMAHA	46000.00	BOX SAMPING / TUTUP AKI (YAMAHA)	2026-02-10 04:39:46.568	KELISTRIKAN	49000.00	YAM-KEL-BOX-641	2026-02-10 04:39:46.568	\N
cmlg43q2600qspv85motyj2eu	FILTER UDARA V-IXION 12	\N	0	YAMAHA	32000.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:46.569	MESIN & OLI	35000.00	YAM-MES-FIL-694	2026-02-10 04:39:46.569	\N
cmlg43q9i00r2pv85t4hgpj3l	CHAIN COVER / TUTUP RANTAI (YAMAHA)	\N	0	YAMAHA	0.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:46.569	MESIN & OLI	0.00	YAM-MES-CHA-697	2026-02-10 04:39:46.569	\N
cmlg43qjh00rgpv857dfj5elw	COVER STOP / RR STOP JUPITER Z 10 HITAM	\N	0	YAMAHA	25000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.569	BODY PART	28000.00	YAM-BOD-COV-615	2026-06-18 17:35:37.871	\N
d24a0b34-e2b1-4abf-bc95-aed05f1bd28b	KARET TROMOL GRAND / LEGENDA / SUPRA / SUPRA FIT	\N	0	HONDA	8800.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	8800.00	HON-OTH-2156	2026-06-18 17:47:31.403	\N
cmlg43d81005hpv85kqbluz0t	PANEL MIO M3 KECIL/ DASI HITAM	\N	0	YAMAHA	75000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.554	BODY PART	78000.00	YAM-BOD-PAN-303	2026-02-10 04:39:33.554	\N
cmlg43dp7006epv85smuqzl5p	PANEL JUPITER Z1 PUTIH	\N	0	YAMAHA	259000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.555	BODY PART	262000.00	YAM-BOD-PAN-338	2026-02-10 04:39:33.555	\N
cmlg43dzi006ypv853tgfiioe	PANEL VEGA R 06 HITAM	\N	0	YAMAHA	48000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	51000.00	YAM-BOD-PAN-359	2026-02-10 04:39:33.556	\N
cmlg43ece007ipv85dvokzm9d	PANEL VEGA R 06 SILVER	\N	0	YAMAHA	57000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	60000.00	YAM-BOD-PAN-360	2026-02-10 04:39:33.556	\N
cmlg43el80084pv85fcsgcb4r	PANEL JUPITER MX HITAM	\N	0	YAMAHA	94000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	97000.00	YAM-BOD-PAN-343	2026-02-10 04:39:33.556	\N
cmlg43eru008npv85reuqn30p	PANEL MIO PUTIH	\N	0	YAMAHA	80000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	83000.00	YAM-BOD-PAN-332	2026-02-10 04:39:33.556	\N
cmlg43n9j00mgpv85szsmtlxr	COVER STOP / RR STOP JUPITER Z 10 HIJAU	\N	0	YAMAHA	29000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.567	BODY PART	32000.00	YAM-BOD-COV-617	2026-06-18 17:35:37.871	\N
cmlg43f57009cpv85rop8ugoo	PANEL JUPITER Z HITAM	\N	0	YAMAHA	44000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	47000.00	YAM-BOD-PAN-345	2026-02-10 04:39:33.557	\N
cmlg43ffz009upv852st8eilu	PANEL X-RIDE BESAR	\N	0	YAMAHA	57000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	60000.00	YAM-BOD-PAN-354	2026-02-10 04:39:33.557	\N
cmlg43foq00acpv85yp1xxkt2	FRONT HANDLE COVER/ BATOK DEPAN JUPITER MX BIRU (NON KOPLING)	\N	0	YAMAHA	66000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	69000.00	YAM-BOD-FRO-398	2026-02-10 04:39:33.557	\N
cmlezx4no014a39t50013m1cr	LAMPU DEPAN / HEAD LAMP VARIO	\N	0	HONDA	127000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	138000.00	HON-LAM-LAM-743	2026-06-19 22:06:32.653	01B2200200AA1
cmlg43jt500gopv85qvdoln6b	MIKA SPEEDOMETER JUPITER / JUPITER Z	\N	0	YAMAHA	0.00	MIKA SPEEDOMETER (YAMAHA)	2026-02-10 04:39:42.089	KELISTRIKAN	23000.00	YAM-KEL-MIK-504	2026-06-19 22:06:33.001	01D1301700AA12
cmlg43fwl00arpv85vp5mly3c	PANEL JUPITER Z1 HITAM	\N	0	YAMAHA	232000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	235000.00	YAM-BOD-PAN-335	2026-02-10 04:39:33.557	\N
cmlg43gdx00bapv8582nf28du	FRONT HANDLE COVER/ BATOK DEPAN JUPITER Z 06 MERAH MAROON	\N	0	YAMAHA	85000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.653	BODY PART	88000.00	YAM-BOD-FRO-406	2026-02-10 04:39:37.653	\N
cmlg43glo00bopv85mu5zqucp	FRONT HANDLE COVER/ BATOK DEPAN VEGA R 04 BIRU CAKRAM	\N	0	YAMAHA	70000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.654	BODY PART	73000.00	YAM-BOD-FRO-422	2026-02-10 04:39:37.654	\N
cmlg43gsl00c5pv858les770k	MIKA LAMPU JUPITER MX KING 150	\N	0	YAMAHA	84000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	87000.00	YAM-KEL-MIK-440	2026-02-10 04:39:37.654	\N
cmlg43gyj00cmpv85d7n9z5hn	MIKA LAMPU JUPITER Z 10	\N	0	YAMAHA	49000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	52000.00	YAM-KEL-MIK-443	2026-02-10 04:39:37.654	\N
cmlg43h4900cupv8554ujay6e	FRONT HANDLE COVER/ BATOK DEPAN JUPITER Z1 BIRU	\N	0	YAMAHA	91000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.654	BODY PART	94000.00	YAM-BOD-FRO-409	2026-02-10 04:39:37.654	\N
cmlg43ha000dapv855d94j9pl	MIKA LAMPU LEXI	\N	0	YAMAHA	153000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	156000.00	YAM-KEL-MIK-465	2026-02-10 04:39:37.654	\N
cmlg43hqn00eepv8527agrnhl	MIKA LAMPU N-MAX	\N	0	YAMAHA	141000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	144000.00	YAM-KEL-MIK-455	2026-02-10 04:39:37.655	\N
cmlg43i2e00erpv85xehhqiew	MIKA SEN Fr / MIKA SEN DEPAN  JUPITER MX (P)	\N	0	YAMAHA	22000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	25000.00	YAM-KEL-MIK-479	2026-02-10 04:39:37.655	\N
cmlg43idz00fapv85ynevqeqw	MIKA SPEEDOMETER MIO SOUL GT	\N	0	YAMAHA	21000.00	MIKA SPEEDOMETER (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	24000.00	YAM-KEL-MIK-493	2026-02-10 04:39:37.655	\N
cmlg43nmb00mrpv85a58w2ua6	COVER STOP / RR STOP V-IXION HITAM	\N	0	YAMAHA	29000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.567	BODY PART	32000.00	YAM-BOD-COV-626	2026-06-18 17:35:37.871	\N
cmlg43j6800g8pv85klgbxkxn	FRONT HANDLE COVER/ BATOK DEPAN VEGA R 06 BIRU CAKRAM	\N	0	YAMAHA	75000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.655	BODY PART	78000.00	YAM-BOD-FRO-419	2026-02-10 04:39:37.655	\N
cmlg43jt600gypv85vc2dec7w	MIKA STOP/MIKA BELAKANG VEGA R 06 BESAR (P)	\N	0	YAMAHA	32000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	35000.00	YAM-KEL-MIK-515	2026-02-10 04:39:42.09	\N
cmlg43k5700hcpv85g1zsymb3	MIKA STOP/MIKA BELAKANG MIO J PUTIH BESAR	\N	0	YAMAHA	28000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	31000.00	YAM-KEL-MIK-510	2026-02-10 04:39:42.09	\N
cmlg43ksb00ijpv85x4vsywdn	FRONT WINKER / SEN DEPAN ASSY JUPITER Z 10	\N	0	YAMAHA	108000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	111000.00	YAM-KEL-FRO-571	2026-02-10 04:39:42.091	\N
cmlg43l1z00iypv8516swxnyy	FRONT WINKER / SEN DEPAN ASSY F1Z-R (O)	\N	0	YAMAHA	60000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	63000.00	YAM-KEL-FRO-574	2026-02-10 04:39:42.091	\N
cmlg43lfw00jqpv8571ikp5mk	LAMPU DEPAN MIO SOUL GT 125 BLUE CORE + LED	\N	0	YAMAHA	461000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	464000.00	YAM-KEL-LAM-530	2026-02-10 04:39:42.091	\N
cmlg43lnh00k4pv85ztfs7pwo	Fr / Rr WINKER ASSY / SEN KANAN KIRI  RX KING (H)	\N	0	YAMAHA	40000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	43000.00	YAM-KEL-FRR-585	2026-02-10 04:39:42.092	\N
cmlg43lul00kepv85wlmjhkpx	STOP LAMP ASSY / LAMPU STOP MIO J	\N	0	YAMAHA	87000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	90000.00	YAM-KEL-STO-588	2026-02-10 04:39:42.092	\N
cmlg43m1l00kopv853j3jex6l	LAMPU DEPAN MIO 08	\N	0	YAMAHA	80000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	83000.00	YAM-KEL-LAM-532	2026-02-10 04:39:42.092	\N
cmlg43m9t00kypv85uhrm7xch	STOP LAMP ASSY / LAMPU STOP MIO 08	\N	0	YAMAHA	83000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	86000.00	YAM-KEL-STO-590	2026-02-10 04:39:42.092	\N
cmlg43mib00lgpv857ff1ln2f	STOP LAMP ASSY / LAMPU STOP V-IXION	\N	0	YAMAHA	100000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	103000.00	YAM-KEL-STO-600	2026-02-10 04:39:42.092	\N
cmlg43mr600lspv85mullq9ft	MIKA STOP/MIKA BELAKANG VEGA ZR	\N	0	YAMAHA	16000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	19000.00	YAM-KEL-MIK-513	2026-02-10 04:39:42.092	\N
cmlg43nvz00n0pv85l2gpkhgg	COB LAMPU / FITTING LAMPU  MIO SOUL GT	\N	0	YAMAHA	17000.00	COB LAMP / FITTING LAMPU YAMAHA)	2026-02-10 04:39:46.567	KELISTRIKAN	20000.00	YAM-KEL-COB-603	2026-02-10 04:39:46.567	\N
cmlg43obs00nspv85i8enxm5e	FOOTREST MIO/DEK LANTAI	\N	0	YAMAHA	64000.00	FOOTREST (YAMAHA)	2026-02-10 04:39:46.568	BODY PART	67000.00	YAM-BOD-FOO-655	2026-02-10 04:39:46.568	\N
bb935f6b-f607-4043-804f-badd8cf33d1a	COMPLETE SET BODY VARIO 125 23 HITAM	\N	0	HONDA	2004000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	2004000.00	HON-COM-2157	2026-06-18 17:47:31.403	\N
8612426a-c1ff-4f5a-90cc-12fa6b140dfd	COMPLETE SET BODY VARIO 160 HITAM	\N	0	HONDA	2280000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	2280000.00	HON-COM-2158	2026-06-18 17:47:31.403	\N
cmlg43dia005ypv85z26pk9ou	PANEL MIO SOUL MERAH MAROON	\N	0	YAMAHA	156000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.555	BODY PART	159000.00	YAM-BOD-PAN-317	2026-02-10 04:39:33.555	\N
cmlg43dse006gpv859yfey4dn	PANEL MIO J BIRU MUDA	\N	0	YAMAHA	99000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.555	BODY PART	102000.00	YAM-BOD-PAN-329	2026-02-10 04:39:33.555	\N
cmlg43dzh006rpv856furofvl	PANEL JUPITER Z 06 BIRU	\N	0	YAMAHA	56000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	59000.00	YAM-BOD-PAN-349	2026-02-10 04:39:33.556	\N
cmlg43e68007apv853v02fv0t	PANEL DEPAN BAGIAN BAWAH AEROX 155	\N	0	YAMAHA	77000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	80000.00	YAM-BOD-PAN-367	2026-02-10 04:39:33.556	\N
71cdc79d-da9d-475d-be97-4e081144109d	COMPLETE SET BODY SCOOPY 20 HITAM	\N	0	HONDA	2274000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	2274000.00	HON-COM-2159	2026-06-18 17:47:31.403	\N
cmlg43el80085pv85k6usbgck	FRONT HANDLE COVER/ BATOK DEPAN MIO SOUL GT HITAM VIOLET	\N	0	YAMAHA	70000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	73000.00	YAM-BOD-FRO-380	2026-02-10 04:39:33.556	\N
cmlg43eru008mpv85uchua8m6	PANEL JUPITER MX BIRU TUA	\N	0	YAMAHA	106000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	109000.00	YAM-BOD-PAN-351	2026-02-10 04:39:33.556	\N
c9a071f7-b0d7-46fb-8bac-5699f0571843	COMPLETE SET BODY VARIO 150 18 HITAM	\N	0	HONDA	2060000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	2060000.00	HON-COM-2160	2026-06-18 17:47:31.403	\N
cmlg43fgt009wpv85uydoyl0h	PANEL MIO BIRU MUDA (TELUR ASIN)	\N	0	YAMAHA	106000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	109000.00	YAM-BOD-PAN-333	2026-02-10 04:39:33.557	\N
cmlg43fpy00afpv85aqti528r	PANEL X-RIDE KECIL/DASI HITAM	\N	0	YAMAHA	62000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	65000.00	YAM-BOD-PAN-355	2026-02-10 04:39:33.557	\N
cmlg43fx700aupv85j91lfrpt	PANEL MIO M3 KECIL/DASI PUTIH	\N	0	YAMAHA	79000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	82000.00	YAM-BOD-PAN-327	2026-02-10 04:39:33.557	\N
cmlg43hiv00dwpv85afun51ai	MIKA SEN Rr / MIKA SEN BELAKANG  + STOP N-MAX (M/P)	\N	0	YAMAHA	117000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	121000.00	YAM-KEL-MIK-474	2026-06-19 22:06:33.296	01D4802400AA1
cmlg43gdx00b3pv852r6z9mnk	FRONT HANDLE COVER/ BATOK DEPAN JUPITER Z 06 BIRU	\N	0	YAMAHA	85000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.653	BODY PART	88000.00	YAM-BOD-FRO-405	2026-02-10 04:39:37.653	\N
cmlg43gln00bmpv8532lb48st	FRONT HANDLE COVER/ BATOK DEPAN VEGA R 04 HITAM CAKRAM	\N	0	YAMAHA	54000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.654	BODY PART	57000.00	YAM-BOD-FRO-421	2026-02-10 04:39:37.654	\N
cmlg43gs000c0pv85lng5b00k	FRONT HANDLE COVER/ BATOK DEPAN VEGA ZR PUTIH	\N	0	YAMAHA	83000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.654	BODY PART	86000.00	YAM-BOD-FRO-425	2026-02-10 04:39:37.654	\N
cmlg43gxz00cipv85x369pyig	MIKA LAMPU X-RIDE	\N	0	YAMAHA	45000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	48000.00	YAM-KEL-MIK-458	2026-02-10 04:39:37.654	\N
cmlg43h5v00d6pv85qy4vmao9	MIKA LAMPU JUPITER Z 06 + INNER	\N	0	YAMAHA	64000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	67000.00	YAM-KEL-MIK-444	2026-02-10 04:39:37.654	\N
cmlg43hdr00dhpv85ep5oyhdt	FRONT HANDLE COVER/ BATOK DEPAN JUPITER Z1 MERAH MAROON	\N	0	YAMAHA	93000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.654	BODY PART	96000.00	YAM-BOD-FRO-410	2026-02-10 04:39:37.654	\N
cmlg43hlt00dzpv8542qwii5c	MIKA SEN Fr / MIKA SEN DEPAN  JUPITER Z 10	\N	0	YAMAHA	41000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	44000.00	YAM-KEL-MIK-476	2026-02-10 04:39:37.655	\N
cmlg43i2e00eqpv85u3enbb7s	MIKA SEN Rr / MIKA SEN BELAKANG  + STOP VEGA R 04 (P/M) KO	\N	0	YAMAHA	43000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	46000.00	YAM-KEL-MIK-484	2026-02-10 04:39:37.655	\N
cmlg43idz00f8pv8515qnab68	MIKA SEN Rr / MIKA SEN BELAKANG  + STOP ALFA (C/M) KO	\N	0	YAMAHA	36000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	39000.00	YAM-KEL-MIK-491	2026-02-10 04:39:37.655	\N
cmlg43irl00fqpv85gevcgika	MIKA SPEEDOMETER JUPITER MX 11	\N	0	YAMAHA	23000.00	MIKA SPEEDOMETER (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	26000.00	YAM-KEL-MIK-498	2026-02-10 04:39:37.655	\N
cmlg43jam00ggpv85a7xzfjyx	FRONT HANDLE COVER/ BATOK DEPAN JUPITER MX 11 MERAH MAROON	\N	0	YAMAHA	81000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.655	BODY PART	84000.00	YAM-BOD-FRO-407	2026-02-10 04:39:37.655	\N
cmlg43jt500gkpv85a85q3tjc	MIKA SPEEDOMETER JUPITER Z 06	\N	0	YAMAHA	28000.00	MIKA SPEEDOMETER (YAMAHA)	2026-02-10 04:39:42.089	KELISTRIKAN	31000.00	YAM-KEL-MIK-501	2026-02-10 04:39:42.089	\N
cmlg43jzu00h8pv85vlt0kljj	MIKA STOP/MIKA BELAKANG JUPITER Z 10 BESAR (P)	\N	0	YAMAHA	34000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	37000.00	YAM-KEL-MIK-524	2026-02-10 04:39:42.09	\N
cmlg43k8900hkpv85c9uy8c1n	LAMPU DEPAN JUPITER Z 06	\N	0	YAMAHA	105000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	108000.00	YAM-KEL-LAM-542	2026-02-10 04:39:42.09	\N
cmlg43kgc00i0pv85w4xf9tz0	FRONT WINKER / SEN DEPAN UNIT ADDRESS	\N	0	YAMAHA	120000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	123000.00	YAM-KEL-FRO-561	2026-02-10 04:39:42.09	\N
cmlg43kpl00icpv85gebl0fap	FRONT WINKER / SEN DEPAN ASSY N-MAX	\N	0	YAMAHA	163000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	166000.00	YAM-KEL-FRO-563	2026-02-10 04:39:42.091	\N
cmlg43kwl00ispv85ukp8k1v3	MIKA STOP/MIKA BELAKANG JUPITER BESAR (P) KO	\N	0	YAMAHA	42000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	45000.00	YAM-KEL-MIK-517	2026-02-10 04:39:42.091	\N
cmlg43l5v00japv85zvjfffy3	LAMPU DEPAN AEROX 155 + LED	\N	0	YAMAHA	711000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	714000.00	YAM-KEL-LAM-547	2026-02-10 04:39:42.091	\N
cmlg43lkd00k0pv85c7zl1h9y	FRONT WINKER / SEN DEPAN UNIT MIO SOUL GT 125 BC	\N	0	YAMAHA	82000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	85000.00	YAM-KEL-FRO-567	2026-02-10 04:39:42.091	\N
cmlg43mec00lapv85jqr8prtb	STOP LAMP ASSY / LAMPU STOP VEGA ZR 11	\N	0	YAMAHA	85000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	88000.00	YAM-KEL-STO-597	2026-02-10 04:39:42.092	\N
cmlg43mn900lopv85zwxjsdeb	LAMPU DEPAN JUPITER MX KING 150	\N	0	YAMAHA	141000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	144000.00	YAM-KEL-LAM-539	2026-02-10 04:39:42.092	\N
cmlg43n9i00mdpv85s4a2v59n	COB LAMPU / FITTING LAMPU  JUPITER MX 11	\N	0	YAMAHA	8000.00	COB LAMP / FITTING LAMPU YAMAHA)	2026-02-10 04:39:46.567	KELISTRIKAN	11000.00	YAM-KEL-COB-606	2026-02-10 04:39:46.567	\N
cmlg43o1000n6pv85g90154e2	COB LAMPU / FITTING LAMPU  JUPITER MX	\N	0	YAMAHA	12000.00	COB LAMP / FITTING LAMPU YAMAHA)	2026-02-10 04:39:46.568	KELISTRIKAN	15000.00	YAM-KEL-COB-607	2026-02-10 04:39:46.568	\N
fe6b06be-f8f1-4f57-b203-f4b705c69452	COMPLETE SET BODY VARIO 150 18 HITAM DOFF	\N	0	HONDA	2203000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	2203000.00	HON-COM-2161	2026-06-18 17:47:31.403	\N
cmlg43dse006hpv85yu9z3vz6	PANEL MIO SOUL BIRU	\N	0	YAMAHA	156000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.555	BODY PART	159000.00	YAM-BOD-PAN-320	2026-02-10 04:39:33.555	\N
cmlg43dzh006qpv85q2x58mmp	PANEL X-RIDE KECIL/DASI PUTIH	\N	0	YAMAHA	68000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	71000.00	YAM-BOD-PAN-356	2026-02-10 04:39:33.556	\N
cmlg43e8j007epv856poo04yo	PANEL JUPITER Z 06 MERAH MAROON	\N	0	YAMAHA	56000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	59000.00	YAM-BOD-PAN-342	2026-02-10 04:39:33.556	\N
cmlg43eer007vpv85qis17kxr	PANEL JUPITER Z 06 SILVER	\N	0	YAMAHA	57000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	60000.00	YAM-BOD-PAN-350	2026-02-10 04:39:33.556	\N
cmlg43elh0088pv85n18rd8oa	PANEL VEGA R 04 HITAM	\N	0	YAMAHA	42000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	45000.00	YAM-BOD-PAN-361	2026-02-10 04:39:33.556	\N
cmlg43nmb00mqpv855noaorfs	COVER STOP / RR STOP V-IXION BIRU	\N	0	YAMAHA	35000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.567	BODY PART	38000.00	YAM-BOD-COV-627	2026-06-18 17:35:37.871	\N
cmlg43f4n009apv8565lmqrx2	FRONT HANDLE COVER/ BATOK DEPAN MIO 08 HIJAU	\N	0	YAMAHA	62000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	65000.00	YAM-BOD-FRO-388	2026-02-10 04:39:33.557	\N
cmlg43fdq009qpv85q84dhea1	FRONT HANDLE COVER/ BATOK DEPAN MIO BIRU MUDA (TELUR ASIN)	\N	0	YAMAHA	52000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	55000.00	YAM-BOD-FRO-393	2026-02-10 04:39:33.557	\N
cmlg43fo600a4pv85nvhjds69	PANEL N-MAX BESAR HITAM	\N	0	YAMAHA	92000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	95000.00	YAM-BOD-PAN-364	2026-02-10 04:39:33.557	\N
cmlg43fx700axpv85t2qg8oqc	FRONT HANDLE COVER/ BATOK DEPAN MIO MERAH	\N	0	YAMAHA	52000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	55000.00	YAM-BOD-FRO-394	2026-02-10 04:39:33.557	\N
cmlg43gdx00bgpv85yqg20a5k	FRONT HANDLE COVER/ BATOK DEPAN JUPITER Z 10 HIJAU	\N	0	YAMAHA	89000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.653	BODY PART	92000.00	YAM-BOD-FRO-408	2026-02-10 04:39:37.653	\N
cmlg43f6u009fpv85aiucd9s6	FRONT HANDLE COVER/ BATOK DEPAN MIO SOUL HIJAU	\N	0	YAMAHA	59000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	62000.00	YAM-BOD-FRO-389	2026-06-19 22:06:33.652	01D2630059AA1
cmlg43gln00bipv85knbbms8v	FRONT HANDLE COVER/ BATOK DEPAN JUPITER Z 10 BIRU MUDA	\N	0	YAMAHA	88000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.654	BODY PART	91000.00	YAM-BOD-FRO-411	2026-02-10 04:39:37.654	\N
cmlg43gs000c1pv85zmtqv72o	FRONT HANDLE COVER/ BATOK DEPAN F1Z-R SILVER KOPLING	\N	0	YAMAHA	77000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.654	BODY PART	80000.00	YAM-BOD-FRO-431	2026-02-10 04:39:37.654	\N
cmlg43gxz00cjpv857ln769xa	MIKA LAMPU NEW X-RIDE 125	\N	0	YAMAHA	163000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	166000.00	YAM-KEL-MIK-459	2026-02-10 04:39:37.654	\N
cmlg43h5400d2pv85t6fmysyy	MIKA LAMPU FINO FI 18	\N	0	YAMAHA	92000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	95000.00	YAM-KEL-MIK-464	2026-02-10 04:39:37.654	\N
cmlg43nvz00n1pv852ecrkegs	COVER STOP / RR STOP V-IXION MERAH MAROON	\N	0	YAMAHA	34000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.567	BODY PART	37000.00	YAM-BOD-COV-628	2026-06-18 17:35:37.871	\N
cmlg43hmg00e4pv85vaw93y7r	MIKA SEN Fr / MIKA SEN DEPAN  JUPITER MX 11	\N	0	YAMAHA	32000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	35000.00	YAM-KEL-MIK-478	2026-02-10 04:39:37.655	\N
cmlg43i3t00eupv85vfib3yvb	MIKA SEN Fr / MIKA SEN DEPAN  ADDRESS	\N	0	YAMAHA	50000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	53000.00	YAM-KEL-MIK-488	2026-02-10 04:39:37.655	\N
950ec62a-51a8-4090-bb7f-9c54ea77e765	COMPLETE SET BODY SCOOPY FI 17 HITAM	\N	0	HONDA	1981000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	1981000.00	HON-COM-2162	2026-06-18 17:47:31.403	\N
cmlg43isr00fwpv85gycg9v2l	FRONT HANDLE COVER/ BATOK DEPAN VEGA R 06 HITAM CAKRAM	\N	0	YAMAHA	67000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.655	BODY PART	70000.00	YAM-BOD-FRO-418	2026-02-10 04:39:37.655	\N
cmlg43jt800h0pv85lpoa0p9v	MIKA STOP/MIKA BELAKANG MIO M3 BESAR (SMOKE) + KECIL (M)	\N	0	YAMAHA	49000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	52000.00	YAM-KEL-MIK-508	2026-02-10 04:39:42.09	\N
cmlg43k5800hgpv85hwdfd3l4	LAMPU DEPAN MIO	\N	0	YAMAHA	63000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	66000.00	YAM-KEL-LAM-534	2026-02-10 04:39:42.09	\N
cmlg43kr600iepv858r9j4007	LAMPU DEPAN ADDRESS	\N	0	YAMAHA	132000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	135000.00	YAM-KEL-LAM-553	2026-02-10 04:39:42.091	\N
cmlg43l3w00j6pv85hot4bble	LAMPU DEPAN MIO M3	\N	0	YAMAHA	177000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	180000.00	YAM-KEL-LAM-529	2026-02-10 04:39:42.091	\N
cmlg43la400jhpv852j4rgved	Fr/Rr WINKER / SEN KANAN KIRI (YAMAHA)	\N	0	YAMAHA	0.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	0.00	YAM-KEL-FRR-578	2026-02-10 04:39:42.091	\N
cmlg43lil00jypv855kh8l2ir	Fr / Rr WINKER ASSY / SEN KANAN KIRI  V-IXION	\N	0	YAMAHA	73000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	76000.00	YAM-KEL-FRR-583	2026-02-10 04:39:42.091	\N
cmlg43lot00kapv85k5yt5mdu	STOP LAMP ASSY / LAMPU STOP (YAMAHA)	\N	0	YAMAHA	0.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	0.00	YAM-KEL-STO-586	2026-02-10 04:39:42.092	\N
cmlg43lwe00kjpv85393u7yiw	MIKA STOP/MIKA BELAKANG JUPITER Z 06 KECIL (M)	\N	0	YAMAHA	22000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	25000.00	YAM-KEL-MIK-520	2026-02-10 04:39:42.092	\N
cmlg43m5000kwpv85d4cdt64s	MIKA STOP/MIKA BELAKANG MIO BESAR KO	\N	0	YAMAHA	25000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	28000.00	YAM-KEL-MIK-511	2026-02-10 04:39:42.092	\N
cmlg43mfi00lepv858qn9su8p	STOP LAMP ASSY / LAMPU STOP VEGA R 06	\N	0	YAMAHA	80000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	83000.00	YAM-KEL-STO-599	2026-02-10 04:39:42.092	\N
cmlg43ms000lwpv8502qogslp	LAMPU DEPAN JUPITER	\N	0	YAMAHA	102000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	105000.00	YAM-KEL-LAM-537	2026-02-10 04:39:42.092	\N
cmlg43n9i00mbpv85c9oa5t1u	COB LAMPU / FITTING LAMPU  MIO SOUL	\N	0	YAMAHA	23000.00	COB LAMP / FITTING LAMPU YAMAHA)	2026-02-10 04:39:46.567	KELISTRIKAN	26000.00	YAM-KEL-COB-604	2026-02-10 04:39:46.567	\N
cmlg43ocm00nwpv85dwk6m3n9	FOOTREST BAWAH X-RIDE/ KOLONG	\N	0	YAMAHA	77000.00	FOOTREST (YAMAHA)	2026-02-10 04:39:46.568	BODY PART	80000.00	YAM-BOD-FOO-658	2026-02-10 04:39:46.568	\N
d3c4f336-5028-4b65-9712-131ccc95df5b	COMPLETE SET BODY BEAT ESP 16 HITAM	\N	0	HONDA	1231000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	1231000.00	HON-COM-2163	2026-06-18 17:47:31.403	\N
14dafc48-eec5-4e16-a997-a1facf4bdbc7	COMPLETE SET BODY REVO FI HITAM	\N	0	HONDA	1030000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	1030000.00	HON-COM-2164	2026-06-18 17:47:31.403	\N
cmlg43dse006ipv859csizt3s	PANEL JUPITER MX 11 HITAM	\N	0	YAMAHA	66000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.555	BODY PART	69000.00	YAM-BOD-PAN-339	2026-02-10 04:39:33.555	\N
cmlg43dzh006spv85dzuw4gus	PANEL VEGA ZR MERAH MAROON	\N	0	YAMAHA	129000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	132000.00	YAM-BOD-PAN-358	2026-02-10 04:39:33.556	\N
cmlg43e5m0078pv85l9y904su	PANEL N-MAX BESAR PUTIH	\N	0	YAMAHA	107000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	110000.00	YAM-BOD-PAN-366	2026-02-10 04:39:33.556	\N
cmlg43edf007qpv85xisj1hsx	FRONT HANDLE COVER/ BATOK DEPAN MIO M3 MERAH MAROON	\N	0	YAMAHA	79000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	82000.00	YAM-BOD-FRO-375	2026-02-10 04:39:33.556	\N
cmlg43ek00080pv85f6uavzfb	FRONT HANDLE COVER/ BATOK DEPAN MIO M3 PUTIH	\N	0	YAMAHA	75000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	78000.00	YAM-BOD-FRO-376	2026-02-10 04:39:33.556	\N
cmlg43eqg008ipv85ga7z3x4b	FRONT HANDLE COVER/ BATOK DEPAN MIO J MERAH MAROON	\N	0	YAMAHA	75000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	78000.00	YAM-BOD-FRO-378	2026-02-10 04:39:33.556	\N
cmlg43nax00mkpv85jygz5b4l	COVER STOP / RR STOP JUPITER Z 10 BIRU MUDA	\N	0	YAMAHA	29000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.567	BODY PART	32000.00	YAM-BOD-COV-616	2026-06-18 17:35:37.871	\N
cmlg43f3z0098pv85c6du7ajb	PANEL JUPITER MX 11 HIJAU	\N	0	YAMAHA	77000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	80000.00	YAM-BOD-PAN-353	2026-02-10 04:39:33.557	\N
cmlg43fo600a6pv856p9kbm0t	PANEL JUPITER Z 10 HIJAU	\N	0	YAMAHA	52000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	55000.00	YAM-BOD-PAN-346	2026-02-10 04:39:33.557	\N
cmlg43fw200ampv85c7049vsw	PANEL JUPITER Z 10 MERAH MAROON	\N	0	YAMAHA	50000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	53000.00	YAM-BOD-PAN-347	2026-02-10 04:39:33.557	\N
cmlg43gdx00bcpv857tr487nk	FRONT HANDLE COVER/ BATOK DEPAN JUPITER Z1 HITAM	\N	0	YAMAHA	72000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.654	BODY PART	75000.00	YAM-BOD-FRO-412	2026-02-10 04:39:37.654	\N
cmlg43gnd00btpv85j9na31qk	FRONT HANDLE COVER/ BATOK DEPAN VEGA ZR BIRU TUA	\N	0	YAMAHA	84000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.654	BODY PART	87000.00	YAM-BOD-FRO-424	2026-02-10 04:39:37.654	\N
cmlg43dia0060pv85q37hoydc	PANEL MIO SOUL PUTIH	\N	0	YAMAHA	156000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.555	BODY PART	159000.00	YAM-BOD-PAN-318	2026-06-19 22:06:34.633	01D2630547AA1
cmlezx55n015439t5ispvr5c4	LAMPU DEPAN / HEAD LAMP SUPRA X 125	\N	0	HONDA	94000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	102000.00	HON-LAM-LAM-761	2026-06-19 22:06:35.244	01B2000200AA1
cmlg43gu200c8pv85x7sclb2h	FRONT HANDLE COVER/ BATOK DEPAN F1Z-R ORANGE KOPLING	\N	0	YAMAHA	77000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.654	BODY PART	80000.00	YAM-BOD-FRO-432	2026-02-10 04:39:37.654	\N
cmlg43nwu00n4pv85qner7v0k	COVER STOP / RR STOP JUPITER HITAM	\N	0	YAMAHA	25000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.567	BODY PART	28000.00	YAM-BOD-COV-619	2026-06-18 17:35:37.871	\N
cmlg43h7x00d8pv85cktu7cpk	MIKA SEN Fr / MIKA SEN DEPAN  MIO 08	\N	0	YAMAHA	44000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	47000.00	YAM-KEL-MIK-470	2026-02-10 04:39:37.654	\N
cmlg43heo00dkpv85p3n7yg54	MIKA SEN Fr / MIKA SEN DEPAN  NEW N-MAX	\N	0	YAMAHA	44000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	47000.00	YAM-KEL-MIK-472	2026-02-10 04:39:37.654	\N
cmlg43hmk00e6pv85ir000tjy	MIKA SEN Rr / MIKA SEN BELAKANG  + STOP VEGA ZR (P/M)	\N	0	YAMAHA	30000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	33000.00	YAM-KEL-MIK-482	2026-02-10 04:39:37.655	\N
cmlg43i3t00evpv8599tvt4ka	MIKA SEN Rr / MIKA SEN BELAKANG  + STOP F1Z-R (O/M) KO	\N	0	YAMAHA	43000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	46000.00	YAM-KEL-MIK-487	2026-02-10 04:39:37.655	\N
cmlg43iuv00g6pv8594eo5uet	MIKA LAMPU V-IXION 10	\N	0	YAMAHA	53000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	56000.00	YAM-KEL-MIK-450	2026-02-10 04:39:37.655	\N
cmlg43jt500gvpv85gvzy4z1q	MIKA STOP/MIKA BELAKANG JUPITER Z 06 BESAR (P)	\N	0	YAMAHA	36000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	39000.00	YAM-KEL-MIK-516	2026-02-10 04:39:42.09	\N
cmlg43k6f00hipv85g8eiqy07	LAMPU DEPAN JUPITER Z 10	\N	0	YAMAHA	107000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	110000.00	YAM-KEL-LAM-541	2026-02-10 04:39:42.09	\N
cmlg43ksb00igpv85ww9t1h31	FRONT WINKER / SEN DEPAN UNIT JUPITER Z1	\N	0	YAMAHA	155000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	158000.00	YAM-KEL-FRO-570	2026-02-10 04:39:42.091	\N
cmlg43l1z00iwpv85skaykjar	LAMPU DEPAN F1Z-R	\N	0	YAMAHA	53000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	56000.00	YAM-KEL-LAM-554	2026-02-10 04:39:42.091	\N
cmlg43lcs00jkpv85tt6yvgjb	Fr / Rr WINKER ASSY / SEN KANAN KIRI  V-IXION VARIASI	\N	0	YAMAHA	67000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	70000.00	YAM-KEL-FRR-580	2026-02-10 04:39:42.091	\N
cmlg43lkd00k1pv85q1g915zu	MIKA STOP/MIKA BELAKANG JUPITER KECIL (M) KO	\N	0	YAMAHA	19000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	22000.00	YAM-KEL-MIK-519	2026-02-10 04:39:42.091	\N
cmlg43lq400kcpv85hnousiw5	LAMPU DEPAN X-RIDE	\N	0	YAMAHA	111000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	114000.00	YAM-KEL-LAM-549	2026-02-10 04:39:42.092	\N
cmlg43lxq00kmpv85t2axx6mm	STOP LAMP RX KING (M)	\N	0	YAMAHA	53000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	56000.00	YAM-KEL-STO-591	2026-02-10 04:39:42.092	\N
cmlg43m3k00kupv85d9ildmcs	STOP LAMP ASSY / LAMPU STOP MIO J SMOKE	\N	0	YAMAHA	111000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	114000.00	YAM-KEL-STO-589	2026-02-10 04:39:42.092	\N
cmlg43mec00lbpv857lqtdynu	STOP LAMP ASSY / LAMPU STOP VEGA ZR	\N	0	YAMAHA	79000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	82000.00	YAM-KEL-STO-598	2026-02-10 04:39:42.092	\N
cmlg43mm700lmpv85az7kp3gx	MIKA STOP/MIKA BELAKANG VEGA R 06 KECIL (M)	\N	0	YAMAHA	18000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	21000.00	YAM-KEL-MIK-514	2026-02-10 04:39:42.092	\N
cmlg43nmy00mupv8515lb6axz	COVER TANGKI / COVER MESIN JUPITER MX	\N	0	YAMAHA	26000.00	COVER TANGKI / COVER MESIN (YAMAHA)	2026-02-10 04:39:46.567	BODY PART	29000.00	YAM-BOD-COV-635	2026-02-10 04:39:46.567	\N
cmlg43obs00ntpv8529flmtya	FOOTREST ATAS N-MAX R+L / DEK LANTAI	\N	0	YAMAHA	165000.00	FOOTREST (YAMAHA)	2026-02-10 04:39:46.568	BODY PART	168000.00	YAM-BOD-FOO-656	2026-02-10 04:39:46.568	\N
cmlg43oib00o6pv859s4yiilj	FOOTREST ATAS MIO M3/ DEK LANTAI	\N	0	YAMAHA	63000.00	FOOTREST (YAMAHA)	2026-02-10 04:39:46.568	BODY PART	66000.00	YAM-BOD-FOO-657	2026-02-10 04:39:46.568	\N
cmlg43o3h00nipv85nakb26pc	COVER STOP / RR STOP JUPITER MX HITAM	\N	0	YAMAHA	19000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.568	BODY PART	22000.00	YAM-BOD-COV-620	2026-06-18 17:35:37.871	\N
1ecef4d9-984c-429e-8b3a-5cd1186d2664	COMPLETE SET BODY SUPRA X 125 14 HITAM	\N	0	HONDA	873000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	873000.00	HON-COM-2165	2026-06-18 17:47:31.403	\N
beefafc3-ed72-49d3-90f7-fb1fdc23d66b	COMPLETE SET BODY BEAT FI ESP HITAM	\N	0	HONDA	1084000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	1084000.00	HON-COM-2166	2026-06-18 17:47:31.403	\N
328a100a-760a-44fb-86a3-377a27014f21	COMPLETE SET BODY BEAT FI HITAM	\N	0	HONDA	1039000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	1039000.00	HON-COM-2167	2026-06-18 17:47:31.403	\N
cmlg43nlh00mnpv8521mxzoi3	COVER STOP / RR STOP KARISMA HITAM	\N	0	YAMAHA	20000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.567	BODY PART	23000.00	YAM-BOD-COV-625	2026-06-18 17:35:37.871	\N
cmlg43ede007opv85zk3o1nc8	PANEL DEPAN BAGIAN BAWAH MIO M3	\N	0	YAMAHA	48000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	51000.00	YAM-BOD-PAN-368	2026-02-10 04:39:33.556	\N
cmlg43em6008cpv85ztnp9x80	FRONT HANDLE COVER/ BATOK DEPAN MIO SOUL GT PUTIH	\N	0	YAMAHA	75000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	78000.00	YAM-BOD-FRO-381	2026-02-10 04:39:33.556	\N
cmlg43etf008spv859si7jjwl	PANEL JUPITER MX MERAH MAROON	\N	0	YAMAHA	106000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	109000.00	YAM-BOD-PAN-344	2026-02-10 04:39:33.556	\N
cmlg43fa3009npv85a9qz52rb	FRONT HANDLE COVER/ BATOK DEPAN MIO SOUL GT MERAH MAROON	\N	0	YAMAHA	77000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	80000.00	YAM-BOD-FRO-390	2026-02-10 04:39:33.557	\N
cmlg43fo600a5pv85okqbkt9f	FRONT HANDLE COVER/ BATOK DEPAN MIO SILVER	\N	0	YAMAHA	52000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	55000.00	YAM-BOD-FRO-397	2026-02-10 04:39:33.557	\N
cmlg43fwl00appv857irhjs2h	PANEL MIO M3 KECIL/DASI MERAH MAROON	\N	0	YAMAHA	83000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	86000.00	YAM-BOD-PAN-326	2026-02-10 04:39:33.557	\N
cmlg43gdx00b0pv85wbwhu0ph	FRONT HANDLE COVER/ BATOK DEPAN JUPITER Z HITAM	\N	0	YAMAHA	65000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.653	BODY PART	68000.00	YAM-BOD-FRO-402	2026-02-10 04:39:37.653	\N
cmlg43oib00o3pv85nv03cwqv	COVER STOP / RR STOP VEGA R 06 HITAM	\N	0	YAMAHA	27000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.568	BODY PART	30000.00	YAM-BOD-COV-630	2026-06-18 17:35:37.871	\N
cmlg43gv200capv85ns7eat69	MIKA LAMPU JUPITER MX 11	\N	0	YAMAHA	67000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	70000.00	YAM-KEL-MIK-442	2026-02-10 04:39:37.654	\N
cmlg43h4t00cxpv85jg5brpgi	MIKA LAMPU F1Z-R	\N	0	YAMAHA	33000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	36000.00	YAM-KEL-MIK-461	2026-02-10 04:39:37.654	\N
cmlg43hi800dtpv85m9va3249	MIKA LAMPU ADDRESS	\N	0	YAMAHA	73000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	76000.00	YAM-KEL-MIK-466	2026-02-10 04:39:37.655	\N
cmlg43hpw00ebpv858xizc7qp	MIKA LAMPU MIO J	\N	0	YAMAHA	49000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	52000.00	YAM-KEL-MIK-435	2026-02-10 04:39:37.655	\N
cmlg43i0f00ejpv858nm97yh9	MIKA SEN Fr / MIKA SEN DEPAN  F1Z-R (O) KO	\N	0	YAMAHA	17000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	20000.00	YAM-KEL-MIK-485	2026-02-10 04:39:37.655	\N
cmlg43ib000f4pv85xy43p9u0	MIKA SEN Fr / MIKA SEN DEPAN  F1 ( C ) KB	\N	0	YAMAHA	14000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	17000.00	YAM-KEL-MIK-489	2026-02-10 04:39:37.655	\N
c2b39c58-f41c-4424-863b-ad3d77c338cc	COMPLETE SET BODY SCOOPY FI ESP HITAM	\N	0	HONDA	1828000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	1828000.00	HON-COM-2168	2026-06-18 17:47:31.403	\N
cmlg43iu600g3pv853klg6hdl	FRONT HANDLE COVER/ BATOK DEPAN VEGA ZR BIRU MUDA	\N	0	YAMAHA	84000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:37.655	BODY PART	87000.00	YAM-BOD-FRO-427	2026-02-10 04:39:37.655	\N
cmlg43j9k00gepv85pkkm5pha	MIKA SPEEDOMETER JUPITER Z 10	\N	0	YAMAHA	26000.00	MIKA SPEEDOMETER (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	29000.00	YAM-KEL-MIK-499	2026-02-10 04:39:37.655	\N
cmlg43jt500gmpv85fbeykimo	MIKA SPEEDOMETER JUPITER	\N	0	YAMAHA	22000.00	MIKA SPEEDOMETER (YAMAHA)	2026-02-10 04:39:42.089	KELISTRIKAN	25000.00	YAM-KEL-MIK-503	2026-02-10 04:39:42.089	\N
cmlg43jzu00h3pv85fgzqudt8	MIKA STOP/MIKA BELAKANG JUPITER MX 11 BESAR (SMOKE) + KECIL (M)	\N	0	YAMAHA	67000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	70000.00	YAM-KEL-MIK-523	2026-02-10 04:39:42.09	\N
cmlg43k8900hmpv85gj4rmy8m	LAMPU DEPAN VEGA R 06	\N	0	YAMAHA	86000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	89000.00	YAM-KEL-LAM-544	2026-02-10 04:39:42.09	\N
cmlg43kg000hupv85cpgionjf	MIKA STOP/MIKA BELAKANG V-IXION KECIL (M)	\N	0	YAMAHA	33000.00	MIKA STOP/MIKA BELAKANG (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	36000.00	YAM-KEL-MIK-526	2026-02-10 04:39:42.09	\N
cmlg43kmg00i4pv85qwh9s7zt	FRONT WINKER / SEN DEPAN (YAMAHA)	\N	0	YAMAHA	0.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.09	KELISTRIKAN	0.00	YAM-KEL-FRO-560	2026-02-10 04:39:42.09	\N
cmlg43kuh00iopv853s9wu4dt	FRONT WINKER / SEN DEPAN ASSY VEGA ZR (P)	\N	0	YAMAHA	50000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	53000.00	YAM-KEL-FRO-572	2026-02-10 04:39:42.091	\N
cmlg43l3w00j7pv85ot20zux9	REAR WINKER ASSY X-RIDE	\N	0	YAMAHA	109000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	112000.00	YAM-KEL-REA-577	2026-02-10 04:39:42.091	\N
cmlg43la400jgpv85utrqe5qi	LAMPU DEPAN F1Z-R DE	\N	0	YAMAHA	83000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	86000.00	YAM-KEL-LAM-555	2026-02-10 04:39:42.091	\N
cmlg43lhz00jwpv858e06lg9t	LAMPU DEPAN FORCE	\N	0	YAMAHA	102000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.091	KELISTRIKAN	105000.00	YAM-KEL-LAM-556	2026-02-10 04:39:42.091	\N
cmlg43lnn00k6pv85pb84x8el	LAMPU DEPAN MIO SOUL GT	\N	0	YAMAHA	175000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	178000.00	YAM-KEL-LAM-531	2026-02-10 04:39:42.092	\N
cmlg43lwe00kipv85q6svgz78	Fr / Rr WINKER ASSY / SEN KANAN KIRI  RX KING 05 (O)	\N	0	YAMAHA	88000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	91000.00	YAM-KEL-FRR-584	2026-02-10 04:39:42.092	\N
cmlg43m2r00kspv85sz64ajhr	STOP LAMP ASSY / LAMPU STOP JUPITER MX 11	\N	0	YAMAHA	130000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	133000.00	YAM-KEL-STO-593	2026-02-10 04:39:42.092	\N
7a03a900-7b53-42f9-8a2d-d252acebc09b	COMPLETE SET BODY SCOOPY FI HITAM	\N	0	HONDA	1815000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	1815000.00	HON-COM-2169	2026-06-18 17:47:31.403	\N
cmlg43mk700lipv85rt3rh82r	LAMPU DEPAN BYSON	\N	0	YAMAHA	155000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	158000.00	YAM-KEL-LAM-550	2026-02-10 04:39:42.092	\N
cmlg43mua00m1pv85ilaoml75	LAMPU DEPAN JUPITER Z1	\N	0	YAMAHA	131000.00	LAMPU DEPAN / HEAD LAMP (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	134000.00	YAM-KEL-LAM-538	2026-02-10 04:39:42.092	\N
cmlg43n9i00m5pv85lzfvlwu7	STOP LAMP ASSY / LAMPU STOP V-IXION 12	\N	0	YAMAHA	55000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:46.567	KELISTRIKAN	58000.00	YAM-KEL-STO-601	2026-02-10 04:39:46.567	\N
cmlg43nva00mxpv85zww8gnnm	COVER TANGKI / COVER MESIN JUPITER Z 06	\N	0	YAMAHA	31000.00	COVER TANGKI / COVER MESIN (YAMAHA)	2026-02-10 04:39:46.567	BODY PART	34000.00	YAM-BOD-COV-636	2026-02-10 04:39:46.567	\N
cmlg43oat00nppv852z4ph8u2	COVER TANGKI / COVER MESIN VEGA R 06	\N	0	YAMAHA	30000.00	COVER TANGKI / COVER MESIN (YAMAHA)	2026-02-10 04:39:46.568	BODY PART	33000.00	YAM-BOD-COV-638	2026-02-10 04:39:46.568	\N
e2b545f8-4dad-4e8c-918b-395d7d9c9702	COMPLETE SET BODY BEAT 10 HITAM	\N	0	HONDA	884000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	884000.00	HON-COM-2170	2026-06-18 17:47:31.403	\N
cmlg43pfw00p8pv85z6a1ew3k	BOX SAMPING / TUTUP AKI JUPITER MX SILVER	\N	0	YAMAHA	54000.00	BOX SAMPING / TUTUP AKI (YAMAHA)	2026-02-10 04:39:46.568	KELISTRIKAN	57000.00	YAM-KEL-BOX-640	2026-02-10 04:39:46.568	\N
cmlg43p9600ozpv853k671y2h	COVER STOP / RR STOP JUPITER ORANGE	\N	0	YAMAHA	29000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.568	BODY PART	32000.00	YAM-BOD-COV-622	2026-06-18 17:35:37.871	\N
43fa1d9d-cdab-44d1-bacc-071b216ee387	COMPLETE SET BODY ABSOLUTE REVO FIT HITAM	\N	0	HONDA	723000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	723000.00	HON-COM-2171	2026-06-18 17:47:31.403	\N
cmlg43q1d00qopv8510u0y5d7	BOX SAMPING / TUTUP AKI F1Z-R PUTIH	\N	0	YAMAHA	50000.00	BOX SAMPING / TUTUP AKI (YAMAHA)	2026-02-10 04:39:46.569	KELISTRIKAN	53000.00	YAM-KEL-BOX-642	2026-02-10 04:39:46.569	\N
cmlg43rh100rqpv85qffrncid	UKURAN OLI MIO J	\N	0	YAMAHA	9000.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:52.021	MESIN & OLI	12000.00	YAM-MES-UKU-704	2026-02-10 04:39:52.021	\N
3a577e57-f90f-4b62-acce-3d97216e040b	COMPLETE SET BODY ABSOLUTE REVO HITAM	\N	0	HONDA	915000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	915000.00	HON-COM-2172	2026-06-18 17:47:31.403	\N
cmlg4464y000wx6ttq4c3l6na	REAR HANDLE COVER /BATOK BELAKANG MIO	\N	0	YAMAHA	28000.00	REAR HANDLE COVER /BATOK BELAKANG(YAMAHA)	2026-02-10 04:40:07.574	BODY PART	31000.00	YAM-BOD-REA-25	2026-02-10 04:40:07.574	\N
cmlg446j10012x6tt54g9bhs1	LEGSHIELD LUAR/ SAYAP LUAR N-MAX BESAR PUTIH	\N	0	YAMAHA	229000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.574	BODY PART	232000.00	YAM-BOD-LEG-42	2026-02-10 04:40:07.574	\N
cmlg446vd0018x6tt5x3koczw	COVER TANGKI/COVER MESIN  MIO J	\N	0	YAMAHA	58000.00	COVER TANGKI/COVER MESIN (YAMAHA)	2026-02-10 04:40:07.575	BODY PART	61000.00	YAM-BOD-COV-33	2026-02-10 04:40:07.575	\N
cmlg4475y001ex6ttglqzgh0r	LEGSHIELD LUAR/ SAYAP LUAR N-MAX BESAR MERAH DOFF	\N	0	YAMAHA	229000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	232000.00	YAM-BOD-LEG-44	2026-02-10 04:40:07.575	\N
cmlg447cn001ix6ttmrk1ekwt	REAR HANDLE COVER /BATOK BELAKANG AEROX 155 PUTIH	\N	0	YAMAHA	135000.00	REAR HANDLE COVER /BATOK BELAKANG(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	138000.00	YAM-BOD-REA-30	2026-02-10 04:40:07.575	\N
cmlg447kl001qx6ttnjjravet	FOOTREST ATAS /PINJAKAN KAKI X RIDE	\N	0	YAMAHA	86000.00	FOOTREST ATAS /PINJAKAN KAKI (YAMAHA)	2026-02-10 04:40:07.575	BODY PART	89000.00	YAM-BOD-FOO-35	2026-02-10 04:40:07.575	\N
cmlg4481f0020x6ttdci0xoma	LEGSHIELD LUAR/ SAYAP LUAR JUPITER MX 11 MERAH MAROON	\N	0	YAMAHA	217000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	220000.00	YAM-BOD-LEG-67	2026-02-10 04:40:07.575	\N
cmlg43e110076pv85wj8qqc2r	PANEL MIO 08 BIRU MUDA	\N	0	YAMAHA	110000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	114000.00	YAM-BOD-PAN-311	2026-06-19 22:06:36.984	01D2430560AA1
cmlg448ap0026x6ttbnx6rjhb	LEGSHIELD LUAR/ SAYAP LUAR VEGA R 04 HITAM	\N	0	YAMAHA	130000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	133000.00	YAM-BOD-LEG-72	2026-02-10 04:40:07.575	\N
cmlg448rw002ex6ttjgwxz6io	LEGSHIELD LUAR/ SAYAP LUAR JUPITER Z 10 MERAH MAROON	\N	0	YAMAHA	150000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	153000.00	YAM-BOD-LEG-58	2026-02-10 04:40:07.575	\N
cmlg44962002ox6tt523u99ji	LEGSHIELD LUAR/ SAYAP LUAR VEGA R 06 BIRU	\N	0	YAMAHA	189000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.576	BODY PART	192000.00	YAM-BOD-LEG-71	2026-02-10 04:40:07.576	\N
cmlg449g1002wx6ttsxv3jhmp	LEGSHIELD LUAR/ SAYAP LUAR F1Z-R BIRU	\N	0	YAMAHA	155000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.576	BODY PART	158000.00	YAM-BOD-LEG-77	2026-02-10 04:40:07.576	\N
cmlg449ow0034x6tt1w77e4ze	LEGSHIELD TENGAH ATAS N-MAX	\N	0	YAMAHA	97000.00	LEGSHIELD TENGAH (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	100000.00	YAM-BOD-LEG-78	2026-02-10 04:40:07.576	\N
cmlg449xi003ex6ttezdepafr	LEGSHIELD LUAR/ SAYAP LUAR JUPITER Z 06 BIRU	\N	0	YAMAHA	208000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.576	BODY PART	211000.00	YAM-BOD-LEG-60	2026-02-10 04:40:07.576	\N
cmlg44a70003mx6tt5r0zubsk	LEGSHIELD LUAR/ SAYAP LUAR JUPITER Z 06 HIJAU	\N	0	YAMAHA	208000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.576	BODY PART	211000.00	YAM-BOD-LEG-61	2026-02-10 04:40:07.576	\N
cmlg44apq0044x6tt47ps6k2c	LEGSHIELD DALAM VEGA R 06 MERAH	\N	0	YAMAHA	176000.00	LEGSHIELD DALAM (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	179000.00	YAM-BOD-LEG-94	2026-02-10 04:40:07.576	\N
cmlg44ay4004cx6tt2h6067zd	LEGSHIELD DALAM VEGA R 04 HITAM	\N	0	YAMAHA	104000.00	LEGSHIELD DALAM (YAMAHA)	2026-02-10 04:40:07.577	BODY PART	107000.00	YAM-BOD-LEG-92	2026-02-10 04:40:07.577	\N
1202b800-f861-4aa8-98ac-8c5d47b3ac2a	COMPLETE SET BODY BEAT HITAM	\N	0	HONDA	874000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	874000.00	HON-COM-2173	2026-06-18 17:47:31.403	\N
cmlg44c3l005fx6ttdtvviwlx	COVER BODY/BODY SAMPING JUPITER Z1 BIRU	\N	0	YAMAHA	291000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	294000.00	YAM-BOD-COV-136	2026-02-10 04:40:18.144	\N
cmlg44chl005tx6ttmzv7unnl	COVER BODY/BODY SAMPING MIO M3 BESAR KUNING	\N	0	YAMAHA	170000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	173000.00	YAM-BOD-COV-121	2026-02-10 04:40:18.144	\N
cmlg44czr006bx6ttj4sdwozl	COVER BODY/BODY SAMPING VEGA R HITAM	\N	0	YAMAHA	160000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	163000.00	YAM-BOD-COV-165	2026-02-10 04:40:18.144	\N
cmlg44del006ux6tts6c2r811	COVER BODY/BODY SAMPING V-IXION 12 MERAH MAROON	\N	0	YAMAHA	113000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	116000.00	YAM-BOD-COV-167	2026-02-10 04:40:18.145	\N
cmlg44dw40074x6ttl258fd82	COVER BODY/BODY SAMPING V-IXION HITAM	\N	0	YAMAHA	176000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	179000.00	YAM-BOD-COV-169	2026-02-10 04:40:18.145	\N
a4efc95f-2437-4e9b-a46f-fd5f41d3571c	COMPLETE SET BODY SUPRA X 125 07 HITAM	\N	0	HONDA	1072000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	1072000.00	HON-COM-2174	2026-06-18 17:47:31.403	\N
94b9b4d8-1f74-4bb2-95f2-a5ed8b1df1bd	COMPLETE SET BODY SUPRA X 125 HITAM	\N	0	HONDA	1104000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	1104000.00	HON-COM-2175	2026-06-18 17:47:31.403	\N
cmlg44f9c008tx6tt7r50p375	COVER BODY/BODY SAMPING MIO M3 BESAR MERAH MAROON	\N	0	YAMAHA	174000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	177000.00	YAM-BOD-COV-107	2026-02-10 04:40:18.146	\N
cmlg44foj0098x6tterqbnhbl	COVER BODY/BODY SAMPING JUPITER MX 11 HIJAU	\N	0	YAMAHA	258000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	261000.00	YAM-BOD-COV-149	2026-02-10 04:40:18.146	\N
cmlg44g1q009lx6ttttkztv5g	COVER BODY/BODY SAMPING JUPITER Z 06 MERAH MAROON + COVER STOP	\N	0	YAMAHA	242000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.147	BODY PART	245000.00	YAM-BOD-COV-155	2026-02-10 04:40:18.147	\N
e908ec36-638a-40e8-9b0f-8cfcae276574	COMPLETE SET BODY VARIO HITAM	\N	0	HONDA	1021000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	1021000.00	HON-COM-2176	2026-06-18 17:47:31.403	\N
cmlg43pw600qepv85ip9akt6x	FILTER UDARA MIO M3	\N	0	YAMAHA	23000.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:46.569	MESIN & OLI	26000.00	YAM-MES-FIL-690	2026-02-10 04:39:46.569	\N
cmlg43qcz00r6pv85i2aqxa3m	CHAIN COVER VEGA R 04	\N	0	YAMAHA	18000.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:46.569	MESIN & OLI	21000.00	YAM-MES-CHA-698	2026-02-10 04:39:46.569	\N
cmlg43qmr00rmpv85jzv6sq60	COB LAMPU / FITTING LAMPU  VEGA R 06	\N	0	YAMAHA	11000.00	COB LAMP / FITTING LAMPU YAMAHA)	2026-02-10 04:39:46.569	KELISTRIKAN	14000.00	YAM-KEL-COB-611	2026-02-10 04:39:46.569	\N
cmlg43rh100rppv85fvuktkxq	UKURAN OLI VEGA R 06	\N	0	YAMAHA	7000.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:52.021	MESIN & OLI	10000.00	YAM-MES-UKU-706	2026-02-10 04:39:52.021	\N
cmlg443h10000x6ttua0mvifo	COMPLETE SET BODY MIO HITAM	\N	0	YAMAHA	620000.00	COMPLETE SET BODY (YAMAHA)	2026-02-10 04:40:07.573	BODY PART	623000.00	YAM-BOD-COM-1	2026-02-10 04:40:07.573	\N
cmlg443qw0004x6tt09aiw85s	COMPLETE SET BODY JUPITER Z 06 HITAM	\N	0	YAMAHA	955000.00	COMPLETE SET BODY (YAMAHA)	2026-02-10 04:40:07.574	BODY PART	958000.00	YAM-BOD-COM-14	2026-02-10 04:40:07.574	\N
cmlg443z70008x6ttxse2bp1x	REAR HANDLE COVER /BATOK BELAKANG JUPITER Z 10	\N	0	YAMAHA	25000.00	REAR HANDLE COVER /BATOK BELAKANG(YAMAHA)	2026-02-10 04:40:07.574	BODY PART	28000.00	YAM-BOD-REA-21	2026-02-10 04:40:07.574	\N
cmlg43pgh00pcpv85gbpzi3mh	COVER STOP / RR STOP F1Z-R PUTIH	\N	0	YAMAHA	26000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.568	BODY PART	29000.00	YAM-BOD-COV-623	2026-06-18 17:35:37.871	\N
cmlg444kh000gx6tt7nuezu5k	REAR HANDLE COVER /BATOK BELAKANG MIO M3	\N	0	YAMAHA	23000.00	REAR HANDLE COVER /BATOK BELAKANG(YAMAHA)	2026-02-10 04:40:07.574	BODY PART	26000.00	YAM-BOD-REA-23	2026-02-10 04:40:07.574	\N
cmlg444th000kx6ttfau6hybz	REAR HANDLE COVER /BATOK BELAKANG VEGA R 06	\N	0	YAMAHA	35000.00	REAR HANDLE COVER /BATOK BELAKANG(YAMAHA)	2026-02-10 04:40:07.574	BODY PART	38000.00	YAM-BOD-REA-26	2026-02-10 04:40:07.574	\N
cmlg4452u000ox6ttqcd07y2r	REAR HANDLE COVER /BATOK BELAKANG JUPITER Z1	\N	0	YAMAHA	50000.00	REAR HANDLE COVER /BATOK BELAKANG(YAMAHA)	2026-02-10 04:40:07.574	BODY PART	53000.00	YAM-BOD-REA-18	2026-02-10 04:40:07.574	\N
cmlg44679000yx6ttu7b9v1bd	REAR HANDLE COVER /BATOK BELAKANG JUPITER Z 06	\N	0	YAMAHA	41000.00	REAR HANDLE COVER /BATOK BELAKANG(YAMAHA)	2026-02-10 04:40:07.574	BODY PART	44000.00	YAM-BOD-REA-19	2026-02-10 04:40:07.574	\N
cmlg446k10014x6tt2jbctc83	REAR HANDLE COVER /BATOK BELAKANG VEGA ZR	\N	0	YAMAHA	28000.00	REAR HANDLE COVER /BATOK BELAKANG(YAMAHA)	2026-02-10 04:40:07.574	BODY PART	31000.00	YAM-BOD-REA-28	2026-02-10 04:40:07.574	\N
cmlg43pp700pzpv85nqad38wl	COVER STOP / RR STOP F1Z-R HITAM	\N	0	YAMAHA	20000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.568	BODY PART	23000.00	YAM-BOD-COV-624	2026-06-18 17:35:37.871	\N
cmlg4476m001gx6ttgv4dc8hw	REAR HANDLE COVER /BATOK BELAKANG AEROX 155 HITAM	\N	0	YAMAHA	121000.00	REAR HANDLE COVER /BATOK BELAKANG(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	124000.00	YAM-BOD-REA-29	2026-02-10 04:40:07.575	\N
cmlg447s7001ux6ttbocwmg4a	LEGSHIELD LUAR/ SAYAP LUAR MIO J MERAH MAROON	\N	0	YAMAHA	80000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	83000.00	YAM-BOD-LEG-48	2026-06-19 22:06:37.381	01D3031852AA1
cmlg447ep001mx6ttfzm131ob	LEGSHIELD LUAR/ SAYAP LUAR MIO M3 BESAR MERAH MAROON	\N	0	YAMAHA	191000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	194000.00	YAM-BOD-LEG-51	2026-02-10 04:40:07.575	\N
23cbc4e1-58a4-4ac7-a870-e77d4e614d4a	COMPLETE SET BODY SUPRA FIT NEW HITAM CAKRAM	\N	0	HONDA	932000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	932000.00	HON-COM-2177	2026-06-18 17:47:31.403	\N
cmlg447tc001yx6tt1cheymf2	REAR HANDLE COVER /BATOK BELAKANG AEROX 155 BIRU	\N	0	YAMAHA	135000.00	REAR HANDLE COVER /BATOK BELAKANG(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	138000.00	YAM-BOD-REA-31	2026-02-10 04:40:07.575	\N
cmlg4482i0024x6ttztrvpcvk	LEGSHIELD LUAR/ SAYAP LUAR JUPITER Z 10 BIRU	\N	0	YAMAHA	150000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	153000.00	YAM-BOD-LEG-68	2026-02-10 04:40:07.575	\N
cmlg448d2002ax6ttkadyufrv	LEGSHIELD LUAR/ SAYAP LUAR VEGA R 06 MERAH	\N	0	YAMAHA	189000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	192000.00	YAM-BOD-LEG-69	2026-02-10 04:40:07.575	\N
cmlg448t2002ix6ttdgdtakeu	LEGSHIELD LUAR/ SAYAP LUAR JUPITER MX 11 HIJAU	\N	0	YAMAHA	218000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.576	BODY PART	221000.00	YAM-BOD-LEG-66	2026-02-10 04:40:07.576	\N
cmlg4494t002mx6ttri2609nu	LEGSHIELD LUAR/ SAYAP LUAR F1Z-R MERAH	\N	0	YAMAHA	155000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.576	BODY PART	158000.00	YAM-BOD-LEG-76	2026-02-10 04:40:07.576	\N
cmlg449f9002tx6tth1jsnxbf	LEGSHIELD LUAR/ SAYAP LUAR MIO M3 BESAR PUTIH	\N	0	YAMAHA	188000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.576	BODY PART	191000.00	YAM-BOD-LEG-52	2026-02-10 04:40:07.576	\N
cmlg449m90030x6ttdov4sigk	LEGSHIELD LUAR/ SAYAP LUAR JUPITER Z 06 HITAM	\N	0	YAMAHA	182000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.576	BODY PART	185000.00	YAM-BOD-LEG-59	2026-02-10 04:40:07.576	\N
cmlg449te003ax6ttdbphl003	FOOTREST BAWAH N-MAX A	\N	0	YAMAHA	83000.00	FOOTREST ATAS /PINJAKAN KAKI (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	86000.00	YAM-BOD-FOO-37	2026-02-10 04:40:07.576	\N
cmlg44a40003ix6ttt9xmnsnc	LEGSHIELD DALAM JUPITER Z 06 HIJAU	\N	0	YAMAHA	166000.00	LEGSHIELD DALAM (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	169000.00	YAM-BOD-LEG-84	2026-02-10 04:40:07.576	\N
cmlg44adt003qx6ttxu1k8tz9	LEGSHIELD DALAM JUPITER MX HITAM	\N	0	YAMAHA	108000.00	LEGSHIELD DALAM (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	111000.00	YAM-BOD-LEG-88	2026-02-10 04:40:07.576	\N
cmlg44amd003yx6ttmrzm4fsr	LEGSHIELD DALAM VEGA R 06 BIRU	\N	0	YAMAHA	170000.00	LEGSHIELD DALAM (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	173000.00	YAM-BOD-LEG-91	2026-02-10 04:40:07.576	\N
cmlg44au40048x6ttb3xbb0nt	LEGSHIELD DALAM VEGA R 04 MERAH	\N	0	YAMAHA	116000.00	LEGSHIELD DALAM (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	119000.00	YAM-BOD-LEG-95	2026-02-10 04:40:07.576	\N
cmlg44bmp0052x6ttpq027cwk	COVER BODY/BODY SAMPING MIO M3 BESAR HITAM	\N	0	YAMAHA	155000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.142	BODY PART	158000.00	YAM-BOD-COV-106	2026-02-10 04:40:18.142	\N
cmlg44bz50056x6tt6q30bg40	COVER BODY/BODY SAMPING MIO PUTIH	\N	0	YAMAHA	123000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.143	BODY PART	126000.00	YAM-BOD-COV-127	2026-02-10 04:40:18.143	\N
0b3d6375-a3de-490e-b26d-cc450f3eaac9	COMPLETE SET BODY KARISMA X HITAM	\N	0	HONDA	931000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	931000.00	HON-COM-2178	2026-06-18 17:47:31.403	\N
fab17b08-446c-414c-be8f-c87a3b3ba45d	COMPLETE SET BODY SUPRA FIT HITAM	\N	0	HONDA	809000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	809000.00	HON-COM-2179	2026-06-18 17:47:31.403	\N
26cddc5e-b0c1-4bdf-84db-c171a4907137	COMPLETE SET BODY SUPRA X HITAM	\N	0	HONDA	869000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	869000.00	HON-COM-2180	2026-06-18 17:47:31.403	\N
cmlg44b2f004mx6tt3qdbqsep	LEGSHIELD DALAM MIO 08	\N	0	YAMAHA	82000.00	LEGSHIELD DALAM (YAMAHA)	2026-02-10 04:40:07.577	BODY PART	85000.00	YAM-BOD-LEG-99	2026-02-10 04:40:07.577	01D2435282AA1
cmlg43prj00q4pv85zblz287e	COVER TANGKI / COVER MESIN JUPITER Z1	\N	0	YAMAHA	45000.00	COVER TANGKI / COVER MESIN (YAMAHA)	2026-02-10 04:39:46.568	BODY PART	48000.00	YAM-BOD-COV-633	2026-02-10 04:39:46.568	\N
cmlg43q0r00qmpv85omsgop65	FILTER UDARA MIO J	\N	0	YAMAHA	22000.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:46.569	MESIN & OLI	25000.00	YAM-MES-FIL-691	2026-02-10 04:39:46.569	\N
cmlg43qjh00rhpv8529ne0zdm	COB LAMPU / FITTING LAMPU  F1Z-R	\N	0	YAMAHA	8000.00	COB LAMP / FITTING LAMPU YAMAHA)	2026-02-10 04:39:46.569	KELISTRIKAN	11000.00	YAM-KEL-COB-612	2026-02-10 04:39:46.569	\N
cmlg43rh100s3pv85q6xpv22k	UKURAN OLI MIO 08	\N	0	YAMAHA	9000.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:52.021	MESIN & OLI	12000.00	YAM-MES-UKU-705	2026-02-10 04:39:52.021	\N
cmlg43s0100sbpv85tkl9vaxf	BUNTUT Rr (YAMAHA)	\N	0	YAMAHA	0.00	STANDARD (YAMAHA)	2026-02-10 04:39:52.022	KAKI-KAKI	0.00	YAM-KAK-BUN-713	2026-02-10 04:39:52.022	\N
cmlg44ay4004ex6tt14mswyt7	LEGSHIELD DALAM MIO M3	\N	0	YAMAHA	109000.00	LEGSHIELD DALAM (YAMAHA)	2026-02-10 04:40:07.577	BODY PART	112000.00	YAM-BOD-LEG-97	2026-02-10 04:40:07.577	\N
cmlg44c3l005ex6ttj3zoh8ea	COVER BODY/BODY SAMPING JUPITER Z1 HITAM	\N	0	YAMAHA	269000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	272000.00	YAM-BOD-COV-135	2026-02-10 04:40:18.144	\N
cmlg44chl005sx6tt7e2wd2id	COVER BODY/BODY SAMPING N-MAX KECIL	\N	0	YAMAHA	72000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	75000.00	YAM-BOD-COV-105	2026-02-10 04:40:18.144	\N
cmlg44d43006kx6ttcfqwzfty	COVER BODY/BODY SAMPING MIO M3 KECIL	\N	0	YAMAHA	125000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	128000.00	YAM-BOD-COV-123	2026-02-10 04:40:18.144	\N
cmlg44dmk0070x6tt9koluzs7	COVER BODY/BODY SAMPING MIO SILVER + COVER STOP	\N	0	YAMAHA	139000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	142000.00	YAM-BOD-COV-131	2026-02-10 04:40:18.145	\N
cmlg44fee0092x6tth6m5caps	FRONT FENDER/SPAKBOR DEPAN MIO PUTIH	\N	0	YAMAHA	70000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	73000.00	YAM-BOD-FRO-198	2026-02-10 04:40:18.146	\N
cmlg44g3f009qx6ttdq2ex2fm	COVER BODY/BODY SAMPING JUPITER MX 11 KECIL HITAM	\N	0	YAMAHA	112000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.147	BODY PART	115000.00	YAM-BOD-COV-140	2026-02-10 04:40:18.147	\N
cmlg44ghv00a4x6tth2zw1cyt	FRONT FENDER/SPAKBOR DEPAN MIO SOUL GT HITAM	\N	0	YAMAHA	61000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.147	BODY PART	64000.00	YAM-BOD-FRO-185	2026-02-10 04:40:18.147	\N
cmlezww4j00nf39t5z6iw9j3s	PANEL / TAMENGSCOOPY 20 GRAY DOFF	\N	0	HONDA	292000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	313000.00	HON-PAN-PAN-452	2026-06-18 17:22:17.168	\N
cmlg43pip00pmpv854roi4f24	COVER STOP / RR STOP MIO HITAM	\N	0	YAMAHA	19000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.568	BODY PART	22000.00	YAM-BOD-COV-632	2026-06-18 17:35:37.871	\N
b8c8ee4f-9830-4baa-b4b5-e365cca3d7d6	COMPLETE SET BODY SUPRA HITAM	\N	0	HONDA	866000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	866000.00	HON-COM-2181	2026-06-18 17:47:31.403	\N
828b532d-b96d-4913-b8a8-dbede48caa27	COMPLETE SET BODY GRAND HITAM	\N	0	HONDA	562000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	562000.00	HON-COM-2182	2026-06-18 17:47:31.403	\N
cmlg44bmm004wx6ttxmetd8mk	COVER BODY/BODY SAMPING N-MAX BESAR MERAH DOFF	\N	0	YAMAHA	222000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.142	BODY PART	226000.00	YAM-BOD-COV-103	2026-06-19 22:06:38.204	01D4232787AA1
cmlg44e2n007gx6tt9a2hogve	COVER BODY/BODY SAMPING MIO 08 BIRU MUDA + COVER STOP	\N	0	YAMAHA	130000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	136000.00	YAM-BOD-COV-132	2026-06-19 22:06:38.819	01D2434460AA1
cmlg44ekg0080x6ttxlc4yzbw	FRONT FENDER/SPAKBOR DEPAN MIO M3 PUTIH	\N	0	YAMAHA	89000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	92000.00	YAM-BOD-FRO-179	2026-02-10 04:40:18.145	01D4030747AA1
e88ff2f7-91dd-4d64-8309-3ee8f3d7c966	LEGSHIELD LUAR  / SAYAP LUAR VARIO 125 23 BESAR HITAM	\N	0	HONDA	207000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	207000.00	HON-LEG-2183	2026-06-18 17:47:31.403	\N
dba2e1fc-909a-4597-adb0-abccbc5eb36a	LEGSHIELD LUAR  / SAYAP LUAR VARIO 125 23 BESAR HITAM DOFF	\N	0	HONDA	245000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	245000.00	HON-LEG-2184	2026-06-18 17:47:31.403	\N
b9067394-ab25-4b7d-a1a0-aea8034db000	LEGSHIELD LUAR  / SAYAP LUAR VARIO 125 23 BESAR BIRU DOFF	\N	0	HONDA	245000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	245000.00	HON-LEG-2185	2026-06-18 17:47:31.403	\N
da74368e-a410-4839-b2c8-ff0302a3a411	LEGSHIELD LUAR  / SAYAP LUAR VARIO 125 23 BESAR MERAH	\N	0	HONDA	245000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	245000.00	HON-LEG-2186	2026-06-18 17:47:31.403	\N
7a9aca53-bf19-49aa-84d0-0b0728be018c	LEGSHIELD LUAR  / SAYAP LUAR VARIO 125 23 BESAR PUTIH DOFF	\N	0	HONDA	245000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	245000.00	HON-LEG-2187	2026-06-18 17:47:31.403	\N
738b1184-40bf-4027-aea6-e29c39947915	LEGSHIELD LUAR  / SAYAP LUAR VARIO 125 23 KECIL	\N	0	HONDA	22000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	22000.00	HON-LEG-2188	2026-06-18 17:47:31.403	\N
bbfdfb34-5026-40d2-b0b7-b71b0b431933	LEGSHIELD LUAR  / SAYAP LUAR VARIO 160 BESAR HITAM	\N	0	HONDA	215000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	215000.00	HON-LEG-2189	2026-06-18 17:47:31.403	\N
c4c462ba-a716-481c-aea3-74137996d428	LEGSHIELD LUAR  / SAYAP LUAR VARIO 160 BESAR HITAM DOFF	\N	0	HONDA	240000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	240000.00	HON-LEG-2190	2026-06-18 17:47:31.403	\N
a65a8a11-9628-473c-898c-69b5bd67cfdd	LEGSHIELD LUAR  / SAYAP LUAR VARIO 160 BESAR PUTIH DOFF	\N	0	HONDA	240000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	240000.00	HON-LEG-2191	2026-06-18 17:47:31.403	\N
709a1608-d0e1-469c-ba78-4f6405bb0883	LEGSHIELD LUAR  / SAYAP LUAR VARIO 160 BESAR MERAH DOFF	\N	0	HONDA	240000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	240000.00	HON-LEG-2192	2026-06-18 17:47:31.403	\N
584a9927-60f5-4217-9d7e-f17ef479b0ee	LEGSHIELD LUAR  / SAYAP LUAR VARIO 160 KECIL	\N	0	HONDA	40000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	40000.00	HON-LEG-2193	2026-06-18 17:47:31.403	\N
d56d5073-17eb-428c-bda1-4d35804452bd	LEGSHIELD LUAR  / SAYAP LUAR SCOOPY 20 HITAM	\N	0	HONDA	219000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	219000.00	HON-LEG-2194	2026-06-18 17:47:31.403	\N
004651bb-cd77-42b3-9af4-87cd4e31b04d	LEGSHIELD LUAR  / SAYAP LUAR SCOOPY 20 KREM	\N	0	HONDA	243000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	243000.00	HON-LEG-2195	2026-06-18 17:47:31.403	\N
f51f7558-be8b-41b8-bc2f-bd2711c80f2d	LEGSHIELD LUAR  / SAYAP LUAR SCOOPY 20 MERAH	\N	0	HONDA	243000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	243000.00	HON-LEG-2196	2026-06-18 17:47:31.403	\N
eabf42f7-6b0f-49e5-82cc-9a87b7232f31	LEGSHIELD LUAR  / SAYAP LUAR SCOOPY 20 MERAH DOFF	\N	0	HONDA	253000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	253000.00	HON-LEG-2197	2026-06-18 17:47:31.403	\N
cmlg43pzp00qkpv85859wew8i	FILTER UDARA MIO 08	\N	0	YAMAHA	21000.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:46.569	MESIN & OLI	24000.00	YAM-MES-FIL-693	2026-02-10 04:39:46.569	\N
cmlg43q8t00r0pv85oh1hyux7	FILTER UDARA JUPITER MX	\N	0	YAMAHA	27000.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:46.569	MESIN & OLI	30000.00	YAM-MES-FIL-696	2026-02-10 04:39:46.569	\N
cmlg43qjh00rjpv85mbzxv3ip	COB LAMPU / FITTING LAMPU  F1	\N	0	YAMAHA	8000.00	COB LAMP / FITTING LAMPU YAMAHA)	2026-02-10 04:39:46.569	KELISTRIKAN	11000.00	YAM-KEL-COB-613	2026-02-10 04:39:46.569	\N
cmlg43rh100rtpv85enusjaf6	STANDARD SAMPING NEW N-MAX	\N	0	YAMAHA	52000.00	STANDARD (YAMAHA)	2026-02-10 04:39:52.021	KAKI-KAKI	55000.00	YAM-KAK-STA-709	2026-02-10 04:39:52.021	\N
cmlg43ruj00s6pv85cx7yldt4	UKURAN OLI (YAMAHA)	\N	0	YAMAHA	0.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:52.022	MESIN & OLI	0.00	YAM-MES-UKU-703	2026-02-10 04:39:52.022	\N
cmlg44del006qx6tt9jekhwqi	COVER BODY/BODY SAMPING V-IXION PUTIH	\N	0	YAMAHA	184000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	187000.00	YAM-BOD-COV-166	2026-02-10 04:40:18.145	\N
cmlg44dw40072x6ttns65y3ui	COVER BODY/BODY SAMPING MIO SOUL GT PUTIH	\N	0	YAMAHA	161000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	164000.00	YAM-BOD-COV-114	2026-02-10 04:40:18.145	\N
cmlg44ei4007ux6ttbeee7eon	COVER BODY/BODY SAMPING VEGA ZR HITAM	\N	0	YAMAHA	172000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	175000.00	YAM-BOD-COV-162	2026-02-10 04:40:18.145	\N
cmlg44fas008wx6ttt0e5pjtn	FRONT FENDER/SPAKBOR DEPAN MIO HITAM	\N	0	YAMAHA	57000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	60000.00	YAM-BOD-FRO-197	2026-02-10 04:40:18.146	\N
cmlg44fq6009cx6ttl0y69bic	FRONT FENDER/SPAKBOR DEPAN MIO SOUL GT 125 BLUE CORE PUTIH	\N	0	YAMAHA	73000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	76000.00	YAM-BOD-FRO-200	2026-02-10 04:40:18.146	\N
cmlg44g7t009yx6tts8oy94cl	COVER BODY/BODY SAMPING JUPITER MX 11 KECIL PUTIH	\N	0	YAMAHA	129000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.147	BODY PART	132000.00	YAM-BOD-COV-154	2026-02-10 04:40:18.147	\N
cmlg44h8n00aax6ttwcq8fiko	FRONT FENDER/SPAKBOR DEPAN JUPITER MX KING 150 HITAM	\N	0	YAMAHA	121000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:25.416	BODY PART	124000.00	YAM-BOD-FRO-207	2026-02-10 04:40:25.416	\N
19ede313-822e-4c72-a549-c77e83168581	LEGSHIELD LUAR  / SAYAP LUAR SCOOPY 20 HIJAU DOFF	\N	0	HONDA	253000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	253000.00	HON-LEG-2198	2026-06-18 17:47:31.403	\N
1cce48f6-317b-439b-a656-6077f68058db	LEGSHIELD LUAR  / SAYAP LUAR SCOOPY 20 PUTIH DOFF	\N	0	HONDA	253000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	253000.00	HON-LEG-2199	2026-06-18 17:47:31.403	\N
a8edef08-6705-4881-94d5-aa5db04fcbae	LEGSHIELD LUAR  / SAYAP LUAR PCX 150 18 HITAM	\N	0	HONDA	449000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	449000.00	HON-LEG-2200	2026-06-18 17:47:31.403	\N
78bf1169-9f1a-46d7-842b-bf9311a93915	LEGSHIELD LUAR  / SAYAP LUAR PCX 150 18 PUTIH	\N	0	HONDA	491000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	491000.00	HON-LEG-2201	2026-06-18 17:47:31.403	\N
cmlg44eyp008jx6ttdl5o64ga	FRONT FENDER/SPAKBOR DEPAN MIO 08 MERAH MAROON	\N	0	YAMAHA	83000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	86000.00	YAM-BOD-FRO-191	2026-06-19 22:06:39.001	01D2430752AA1
cmlg44cvs0066x6tttb2xtjyh	COVER BODY/BODY SAMPING MIO HITAM + COVER STOP	\N	0	YAMAHA	127000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.143	BODY PART	131000.00	YAM-BOD-COV-118	2026-06-19 22:06:39.142	01D1934440AA1
cmlg44e94007ix6tt70tbqjzk	FRONT FENDER/SPAKBOR DEPAN A AEROX 155 HITAM	\N	0	YAMAHA	111000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	116000.00	YAM-BOD-FRO-172	2026-06-19 22:06:39.274	01D4430840AA1
cmlg44exa008gx6tt427ta534	FRONT FENDER/SPAKBOR DEPAN MIO 08 HIJAU	\N	0	YAMAHA	83000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	86000.00	YAM-BOD-FRO-190	2026-06-19 22:06:39.407	01D2430759AA1
eb1130a4-ecd8-45fb-8a88-cf4f7e709133	LEGSHIELD LUAR  / SAYAP LUAR VARIO 150 18 / VARIO 125 18 HITAM	\N	0	HONDA	239000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	239000.00	HON-LEG-2202	2026-06-18 17:47:31.403	\N
5c17e186-a9fe-42a5-9b72-a56c6247ee70	LEGSHIELD LUAR  / SAYAP LUAR VARIO 150 18 / VARIO 125 18 HITAM DOFF	\N	0	HONDA	257000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	257000.00	HON-LEG-2203	2026-06-18 17:47:31.403	\N
2249fd17-7a8e-42f6-846a-25832c6d415c	LEGSHIELD LUAR  / SAYAP LUAR VARIO 150 18 / VARIO 125 18 MERAH	\N	0	HONDA	240000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	240000.00	HON-LEG-2204	2026-06-18 17:47:31.403	\N
4229c854-bfe6-408e-9d9a-74bcc62408d7	LEGSHIELD LUAR  / SAYAP LUAR VARIO 150 18 / VARIO 125 18 MERAH DOFF	\N	0	HONDA	257000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	257000.00	HON-LEG-2205	2026-06-18 17:47:31.403	\N
53ddd936-76af-4342-8043-75b12a388ccf	LEGSHIELD LUAR  / SAYAP LUAR VARIO 150 18 / VARIO 125 18 BIRU DOFF	\N	0	HONDA	242000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	242000.00	HON-LEG-2206	2026-06-18 17:47:31.403	\N
54a8b8fc-db75-42c3-9366-7aa082741057	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 / VARIO 125 18 PUTIH	\N	0	HONDA	242000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	242000.00	HON-LEG-2207	2026-06-18 17:47:31.403	\N
13725076-b451-4a87-b307-aad6328acccc	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 / VARIO 125 HITAM	\N	0	HONDA	137000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	137000.00	HON-LEG-2208	2026-06-18 17:47:31.403	\N
5268a340-3791-4bf3-a760-74027ea42ac4	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 / VARIO 125 HITAM DOFF	\N	0	HONDA	162000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	162000.00	HON-LEG-2209	2026-06-18 17:47:31.403	\N
ff5570f0-3a66-4622-8f75-7c07c264e4e6	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 / VARIO 125 GRAY	\N	0	HONDA	156000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	156000.00	HON-LEG-2210	2026-06-18 17:47:31.403	\N
3a3aab47-3b6d-43b4-90ad-d2f87dd064ee	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 / VARIO 125 GRAY DOFF	\N	0	HONDA	172000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	172000.00	HON-LEG-2211	2026-06-18 17:47:31.403	\N
00f22a49-0c9a-4185-aa1e-fabed4b1b4b1	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 / VARIO 125 MERAH	\N	0	HONDA	165000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	165000.00	HON-LEG-2212	2026-06-18 17:47:31.403	\N
16773fea-3807-4ea0-9ca1-0d55514f2df9	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 / VARIO 125 MERAH MAROON	\N	0	HONDA	170000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	170000.00	HON-LEG-2213	2026-06-18 17:47:31.403	\N
2449581a-e2e3-4e5a-9deb-5e6bc1228e96	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 / VARIO 125 PUTIH	\N	0	HONDA	165000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	165000.00	HON-LEG-2214	2026-06-18 17:47:31.403	\N
3a51aa36-a971-4749-bf53-ff31cb2845e8	LEGSHIELD LUAR / SAYAP LUAR SCOOPY FI / SCOOPY FI ESP PUTIH	\N	0	HONDA	262000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	262000.00	HON-LEG-2215	2026-06-18 17:47:31.403	\N
cmlezxfuk01ri39t5n4zch0f4	LEGSHIELD LUAR / SAYAP LUAR SMASH MERAH	\N	0	HONDA	176000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	230000.00	HON-LEG-LEG-1129	2026-02-09 09:55:11.246	\N
cmlg43q4w00qwpv85f945yzuk	FILTER UDARA V-IXION	\N	0	YAMAHA	32000.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:46.569	MESIN & OLI	35000.00	YAM-MES-FIL-695	2026-02-10 04:39:46.569	\N
cmlg43qcz00r4pv850z6suhao	CHAIN COVER JUPITER MX	\N	0	YAMAHA	18000.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:46.569	MESIN & OLI	21000.00	YAM-MES-CHA-699	2026-02-10 04:39:46.569	\N
cmlg43rh100s2pv8595x3ukke	KARET BARSTEP (YAMAHA)	\N	0	YAMAHA	0.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:52.021	MESIN & OLI	0.00	YAM-MES-KAR-707	2026-02-10 04:39:52.021	\N
cmlg43s0t00sepv85tswmzbog	KARET BARSTEP JUPITER Z 10	\N	0	YAMAHA	18000.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:52.022	MESIN & OLI	21000.00	YAM-MES-KAR-708	2026-02-10 04:39:52.022	\N
cmlg449az002qx6ttakg5p5i7	LEGSHIELD LUAR/ SAYAP LUAR MIO M3 BESAR HITAM	\N	0	YAMAHA	167000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	170000.00	YAM-BOD-LEG-50	2026-02-10 04:40:07.575	\N
cmlg449j2002yx6tttsylq3v9	FOOTREST ATAS /PINJAKAN KAKI MIO SOUL GT	\N	0	YAMAHA	82000.00	FOOTREST ATAS /PINJAKAN KAKI (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	85000.00	YAM-BOD-FOO-36	2026-02-10 04:40:07.576	\N
cmlg449qj0038x6ttgvnt5dmg	LEGSHIELD TENGAH VEGA R 06	\N	0	YAMAHA	28000.00	LEGSHIELD TENGAH (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	31000.00	YAM-BOD-LEG-79	2026-02-10 04:40:07.576	\N
cmlg44a0g003gx6tte0ljtybn	LEGSHIELD DALAM JUPITER Z 10 BESAR	\N	0	YAMAHA	117000.00	LEGSHIELD DALAM (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	120000.00	YAM-BOD-LEG-87	2026-02-10 04:40:07.576	\N
cmlg44a8r003ox6ttmxs3f2tt	FOOTREST BAWAH N-MAX B R+L HITAM	\N	0	YAMAHA	177000.00	FOOTREST ATAS /PINJAKAN KAKI (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	180000.00	YAM-BOD-FOO-38	2026-02-10 04:40:07.576	\N
cmlg44ai2003wx6tt889m7dwu	LEGSHIELD TENGAH JUPITER MX	\N	0	YAMAHA	24000.00	LEGSHIELD TENGAH (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	27000.00	YAM-BOD-LEG-81	2026-02-10 04:40:07.576	\N
cmlg44aqg0046x6ttdc4we5a1	FOOTREST BAWAH N-MAX B R+L PUTIH	\N	0	YAMAHA	191000.00	FOOTREST ATAS /PINJAKAN KAKI (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	194000.00	YAM-BOD-FOO-39	2026-02-10 04:40:07.576	\N
cmlg44ccu005kx6tt0nkp1ecn	COVER BODY/BODY SAMPING MIO BIRU TUA + COVER STOP	\N	0	YAMAHA	153000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	156000.00	YAM-BOD-COV-128	2026-02-10 04:40:18.144	\N
cmlg44coh005yx6ttzhr37s1n	COVER BODY/BODY SAMPING JUPITER Z HITAM + COVER STOP	\N	0	YAMAHA	155000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	158000.00	YAM-BOD-COV-148	2026-02-10 04:40:18.144	\N
cmlg44czr006gx6ttjip6qyhb	COVER BODY/BODY SAMPING VEGA ZR HITAM + COVER STOP	\N	0	YAMAHA	187000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	190000.00	YAM-BOD-COV-157	2026-02-10 04:40:18.144	\N
cmlg44dek006mx6ttpegh1y4q	COVER BODY/BODY SAMPING MIO SOUL GT MERAH MAROON	\N	0	YAMAHA	161000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	164000.00	YAM-BOD-COV-113	2026-02-10 04:40:18.144	\N
cmlg44dw40075x6ttfai8kad5	COVER BODY/BODY SAMPING VEGA R HITAM + COVER STOP	\N	0	YAMAHA	171000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	174000.00	YAM-BOD-COV-160	2026-02-10 04:40:18.145	\N
cmlg44ebe007lx6ttufgxh78k	FRONT FENDER/SPAKBOR DEPAN A AEROX 155 PUTIH	\N	0	YAMAHA	112000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	115000.00	YAM-BOD-FRO-173	2026-02-10 04:40:18.145	\N
cmlg44f0l008mx6ttsfzsti2f	FRONT FENDER/SPAKBOR DEPAN MIO SOUL MERAH MAROON	\N	0	YAMAHA	79000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	82000.00	YAM-BOD-FRO-195	2026-02-10 04:40:18.146	\N
cmlg44fxz009ix6ttlsamoqg0	COVER BODY/BODY SAMPING JUPITER MX 11 PUTIH	\N	0	YAMAHA	231000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.147	BODY PART	234000.00	YAM-BOD-COV-153	2026-02-10 04:40:18.147	\N
cmlg44gaa00a0x6ttoag1dcit	COVER BODY/BODY SAMPING JUPITER Z 06 HITAM	\N	0	YAMAHA	166000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.147	BODY PART	169000.00	YAM-BOD-COV-151	2026-02-10 04:40:18.147	\N
efed0d12-2120-4db7-8cea-a3d61a8a7645	COVER STOP / RR STOP SCOOPY FI 17 GRAY DOFF	\N	0	HONDA	118000.00	COVER STOP	2026-06-18 17:27:37.767	BODY PART	118000.00	HON-COV-2013	2026-06-18 17:35:37.871	\N
cmlg43pp700pwpv857pl1bxso	TUTUP KNALPOT JUPITER Z 06	\N	0	YAMAHA	35000.00	TUTUP KNALPOT (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	38000.00	YAM-AKS-TUT-651	2026-06-18 22:23:48.216	\N
0581b81c-37ad-4b0a-a873-47d186e0dfd6	LEGSHIELD LUAR / SAYAP LUAR VARIO 110 FI / VARIO 110 FI ESP HITAM	\N	0	HONDA	120000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	120000.00	HON-LEG-2216	2026-06-18 17:47:31.403	\N
607bed5c-9e58-4b7f-8651-931a8df59095	LEGSHIELD LUAR / SAYAP LUAR VARIO 110 FI / VARIO 110 FI ESP MERAH MAROON	\N	0	HONDA	142000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	142000.00	HON-LEG-2217	2026-06-18 17:47:31.403	\N
cmlezx5m1015y39t5ixdo7qcp	LAMPU DEPAN / HEAD LAMP SUPRA FIT NEW	\N	0	HONDA	91000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	97000.00	HON-LAM-LAM-763	2026-06-18 17:27:37.767	\N
412f1e77-61f4-42c7-bb5d-474a6935da8d	LEGSHIELD LUAR / SAYAP LUAR VARIO 110 FI / VARIO 110 FI ESP PUTIH	\N	0	HONDA	140000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	140000.00	HON-LEG-2218	2026-06-18 17:47:31.403	\N
e1355c98-855e-4c03-a14b-2dbf59d1904f	LEGSHIELD LUAR / SAYAP LUAR REVO FI / REVO X HITAM	\N	0	HONDA	81000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	81000.00	HON-LEG-2219	2026-06-18 17:47:31.403	\N
9ff58c6c-2654-4870-a569-43d5df876d92	LEGSHIELD LUAR / SAYAP LUAR SUPRA X 125 14 HITAM	\N	0	HONDA	214000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	214000.00	HON-LEG-2220	2026-06-18 17:47:31.403	\N
ec210873-8ade-4a21-97bf-3b3beb164bf4	LEGSHIELD LUAR / SAYAP LUAR SUPRA X 125 07 SILVER	\N	0	HONDA	243000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	243000.00	HON-LEG-2221	2026-06-18 17:47:31.403	\N
06c13659-1aae-42b3-8b40-45e28477e24a	LEGSHIELD TENGAH ATAS ABSOLUTE REVO FIT	\N	0	HONDA	48000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	48000.00	HON-LEG-2222	2026-06-18 17:47:31.403	\N
01ee42d4-421d-4879-961a-171bfc6cc218	LEGSHIELD DALAM / SAYAP DALAM  VARIO 125 23 BESAR	\N	0	HONDA	120000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	120000.00	HON-LEG-2223	2026-06-18 17:47:31.403	\N
611d7582-5314-4741-a36f-b35bccd7190e	LEGSHIELD DALAM / SAYAP DALAM  VARIO 125 23 KECIL HITAM	\N	0	HONDA	142000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	142000.00	HON-LEG-2224	2026-06-18 17:47:31.403	\N
cmlg43qfh00r8pv855w4h6eg2	CHAIN COVER JUPITER Z	\N	0	YAMAHA	16000.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:46.569	MESIN & OLI	19000.00	YAM-MES-CHA-700	2026-02-10 04:39:46.569	\N
cmlg43rh100rrpv851zbbvh3v	PEDAL REM JUPITER MX	\N	0	YAMAHA	34000.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:52.021	MESIN & OLI	37000.00	YAM-MES-PED-702	2026-02-10 04:39:52.021	\N
cmlg448rx002gx6ttwfnra04a	LEGSHIELD LUAR/ SAYAP LUAR VEGA R 06 HITAM	\N	0	YAMAHA	181000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.576	BODY PART	184000.00	YAM-BOD-LEG-70	2026-02-10 04:40:07.576	\N
cmlg4494r002kx6tt1af55w50	LEGSHIELD LUAR/ SAYAP LUAR VEGA R 04 MERAH	\N	0	YAMAHA	142000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.576	BODY PART	145000.00	YAM-BOD-LEG-73	2026-02-10 04:40:07.576	\N
cmlg449f9002sx6ttsgmrnryg	LEGSHIELD TENGAH JUPITER	\N	0	YAMAHA	29000.00	LEGSHIELD TENGAH (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	32000.00	YAM-BOD-LEG-82	2026-02-10 04:40:07.576	\N
cmlg449mw0032x6tt9nitevtx	COVER TANGKI/COVER MESIN  MIO M3 BESAR + KECIL	\N	0	YAMAHA	96000.00	COVER TANGKI/COVER MESIN (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	99000.00	YAM-BOD-COV-32	2026-02-10 04:40:07.576	\N
cmlg449ud003cx6ttknr05z30	LEGSHIELD DALAM JUPITER Z1 BESAR	\N	0	YAMAHA	95000.00	LEGSHIELD DALAM (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	98000.00	YAM-BOD-LEG-85	2026-02-10 04:40:07.576	\N
cmlg44a5m003kx6ttepp549vz	LEGSHIELD TENGAH JUPITER Z 06	\N	0	YAMAHA	30000.00	LEGSHIELD TENGAH (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	33000.00	YAM-BOD-LEG-80	2026-02-10 04:40:07.576	\N
cmlg44aek003sx6tt2ga98l7a	LEGSHIELD DALAM JUPITER MX SILVER	\N	0	YAMAHA	119000.00	LEGSHIELD DALAM (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	122000.00	YAM-BOD-LEG-89	2026-02-10 04:40:07.576	\N
cmlg44aoh0040x6tt3zfzi6y2	LEGSHIELD LUAR/ SAYAP LUAR N-MAX KECIL SILVER	\N	0	YAMAHA	184000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	187000.00	YAM-BOD-LEG-46	2026-02-10 04:40:07.575	\N
cmlg44b49004ox6tta8rtpuh4	LEGSHIELD DALAM MIO GT	\N	0	YAMAHA	103000.00	LEGSHIELD DALAM (YAMAHA)	2026-02-10 04:40:07.577	BODY PART	106000.00	YAM-BOD-LEG-98	2026-02-10 04:40:07.577	\N
cmlg44bmm004rx6ttz4uwv140	COVER BODY/BODY SAMPING N-MAX BESAR PUTIH	\N	0	YAMAHA	222000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.142	BODY PART	226000.00	YAM-BOD-COV-104	2026-02-10 04:40:18.142	\N
cmlg44bz60059x6ttg9sy15dw	COVER BODY/BODY SAMPING MIO 08 HIJAU + COVER STOP	\N	0	YAMAHA	125000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	128000.00	YAM-BOD-COV-134	2026-02-10 04:40:18.144	\N
cmlg44ccu005jx6ttzlwki84s	COVER BODY/BODY SAMPING JUPITER Z 06 HITAM + COVER STOP	\N	0	YAMAHA	216000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	219000.00	YAM-BOD-COV-145	2026-02-10 04:40:18.144	\N
cmlg44coh0060x6tt3jpqfc42	COVER BODY/BODY SAMPING MIO M3 BESAR PUTIH	\N	0	YAMAHA	172000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	175000.00	YAM-BOD-COV-122	2026-02-10 04:40:18.144	\N
cmlg44czr006ex6ttn59tas90	COVER BODY/BODY SAMPING VEGA R ORANGE	\N	0	YAMAHA	159000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	162000.00	YAM-BOD-COV-164	2026-02-10 04:40:18.144	\N
cmlg44del006ox6ttkj5c9ke9	COVER BODY/BODY SAMPING VEGA R 06 HITAM + COVER STOP	\N	0	YAMAHA	200000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	203000.00	YAM-BOD-COV-158	2026-02-10 04:40:18.145	\N
cmlg44dw5007ax6ttw1iuylwz	COVER BODY/BODY SAMPING V-IXION MERAH MAROON	\N	0	YAMAHA	204000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	207000.00	YAM-BOD-COV-170	2026-02-10 04:40:18.145	\N
cmlg44enr0086x6tt91mi872w	FRONT FENDER/SPAKBOR DEPAN MIO J PUTIH	\N	0	YAMAHA	81000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	84000.00	YAM-BOD-FRO-184	2026-02-10 04:40:18.145	\N
cmlg44f32008ox6ttx5u9cnvt	FRONT FENDER/SPAKBOR DEPAN MIO SOUL HITAM	\N	0	YAMAHA	64000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	67000.00	YAM-BOD-FRO-193	2026-02-10 04:40:18.146	\N
cmlg44g4t009tx6tt3ppoaxqp	COVER BODY/BODY SAMPING JUPITER Z 10 HITAM	\N	0	YAMAHA	198000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.147	BODY PART	201000.00	YAM-BOD-COV-142	2026-02-10 04:40:18.147	\N
afb08f41-2fb8-46fe-81a7-1b58e7df02e2	LEGSHIELD DALAM / SAYAP DALAM  VARIO 125 23 KECIL HITAM DOFF	\N	0	HONDA	158000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	158000.00	HON-LEG-2225	2026-06-18 17:47:31.403	\N
cmlg44az2004kx6tteqj41s9w	FOOTREST MIO	\N	0	YAMAHA	0.00	FOOTREST ATAS /PINJAKAN KAKI (YAMAHA)	2026-02-10 04:40:07.577	BODY PART	67000.00	YAM-BOD-FOO-40	2026-06-19 22:06:39.54	01D1934382AA1
cmlg44fjj0096x6tt46bde520	COVER BODY/BODY SAMPING MIO J HITAM	\N	0	YAMAHA	146000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	151000.00	YAM-BOD-COV-108	2026-06-19 22:06:39.676	01D3032740AA1
cmlg44bmn004yx6ttl72cccfd	COVER BODY/BODY SAMPING MIO J PUTIH	\N	0	YAMAHA	169000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.143	BODY PART	173000.00	YAM-BOD-COV-110	2026-06-19 22:06:39.807	01D3032747AA1
cmlg44bz50057x6tt45hry9v8	COVER BODY/BODY SAMPING MIO MERAH MAROON + COVER STOP	\N	0	YAMAHA	153000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.143	BODY PART	156000.00	YAM-BOD-COV-119	2026-06-19 22:06:39.939	01D1934452AA1
cmlg44ekh0082x6ttxdx4xj6b	FRONT FENDER/SPAKBOR DEPAN MIO J HITAM (PU)	\N	0	YAMAHA	0.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	72000.00	YAM-BOD-FRO-182	2026-06-19 22:06:40.368	01D3030740AA1
93ea57d2-a1f5-4e3a-8b70-dce13a4a871c	LEGSHIELD DALAM / SAYAP DALAM  VARIO 125 23 KECIL BIRU DOFF	\N	0	HONDA	158000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	158000.00	HON-LEG-2226	2026-06-18 17:47:31.403	\N
cmlg44ees007qx6tt19xm1epz	FRONT FENDER/SPAKBOR DEPAN B AEROX 155	\N	0	YAMAHA	88000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	91000.00	YAM-BOD-FRO-174	2026-02-10 04:40:18.145	01D4430982AA1
6ad77f68-1c40-43f6-be39-eff4591a0942	LEGSHIELD DALAM / SAYAP DALAM  VARIO 125 23 KECIL MERAH	\N	0	HONDA	158000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	158000.00	HON-LEG-2227	2026-06-18 17:47:31.403	\N
078eb472-5912-45b9-9171-e6bdaaa29530	LEGSHIELD DALAM / SAYAP DALAM  VARIO 125 23 KECIL PUTIH DOFF	\N	0	HONDA	158000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	158000.00	HON-LEG-2228	2026-06-18 17:47:31.403	\N
1c0c9c44-f46b-4276-913c-731ce2359d76	LEGSHIELD DALAM / SAYAP DALAM  VARIO 160 BESAR	\N	0	HONDA	87000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	87000.00	HON-LEG-2229	2026-06-18 17:47:31.403	\N
c8497d68-514c-4135-b466-557c3da53333	LEGSHIELD DALAM / SAYAP DALAM  VARIO 160 KECIL HITAM	\N	0	HONDA	267000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	267000.00	HON-LEG-2230	2026-06-18 17:47:31.403	\N
593c3b96-cfa3-4c74-84f4-3e9194099dcf	LEGSHIELD DALAM / SAYAP DALAM  VARIO 160 KECIL HITAM DOFF	\N	0	HONDA	278000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	278000.00	HON-LEG-2231	2026-06-18 17:47:31.403	\N
a20691e9-22d3-4d95-9197-98b655198c5a	LEGSHIELD DALAM / SAYAP DALAM  VARIO 160 KECIL MERAH DOFF	\N	0	HONDA	278000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	278000.00	HON-LEG-2232	2026-06-18 17:47:31.403	\N
b5ebabee-3238-4bc2-80c3-e96eab87015b	LEGSHIELD DALAM / SAYAP DALAM  VARIO 160 KECIL PUTIH DOFF	\N	0	HONDA	278000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	278000.00	HON-LEG-2233	2026-06-18 17:47:31.403	\N
b0a4278e-e469-434c-95e8-a1994af6355a	LEGSHIELD DALAM  / SAYAP DALAM  SCOOPY 20 BESAR HITAM	\N	0	HONDA	239000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	239000.00	HON-LEG-2234	2026-06-18 17:47:31.403	\N
cmlezxmwf024k39t5ks0gbwih	KARET BARSTEP SUPRA	\N	0	HONDA	22000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	8800.00	HON-TUT-KAR-1387	2026-06-18 17:19:42.083	\N
cmlg43pyx00qgpv85afydf28n	FILTER UDARA N-MAX	\N	0	YAMAHA	27000.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:46.569	MESIN & OLI	30000.00	YAM-MES-FIL-689	2026-02-10 04:39:46.569	\N
cmlg43qfh00r9pv85tfh24r0f	BOX SAMPING / TUTUP AKI JUPITER Z1	\N	0	YAMAHA	68000.00	BOX SAMPING / TUTUP AKI (YAMAHA)	2026-02-10 04:39:46.569	KELISTRIKAN	71000.00	YAM-KEL-BOX-643	2026-02-10 04:39:46.569	\N
cmlg43rh100rxpv85pxabb0fr	STANDARD TENGAH NEW N-MAX	\N	0	YAMAHA	126000.00	STANDARD (YAMAHA)	2026-02-10 04:39:52.021	KAKI-KAKI	129000.00	YAM-KAK-STA-710	2026-02-10 04:39:52.021	\N
cmlg43ruj00s8pv856ppsmwlm	STANDARD TENGAH MIO	\N	0	YAMAHA	66000.00	STANDARD (YAMAHA)	2026-02-10 04:39:52.022	KAKI-KAKI	69000.00	YAM-KAK-STA-712	2026-02-10 04:39:52.022	\N
cmlg44elf0084x6ttojebhxz4	FRONT FENDER/SPAKBOR DEPAN MIO J MERAH MAROON	\N	0	YAMAHA	81000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	84000.00	YAM-BOD-FRO-183	2026-02-10 04:40:18.145	\N
cmlg44fcc008yx6tt0z76hxna	FRONT FENDER/SPAKBOR DEPAN MIO SOUL PUTIH	\N	0	YAMAHA	79000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	82000.00	YAM-BOD-FRO-196	2026-02-10 04:40:18.146	\N
cmlg44fst009gx6ttyiaco8tl	FRONT FENDER/SPAKBOR DEPAN MIO M3 KUNING	\N	0	YAMAHA	89000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.147	BODY PART	92000.00	YAM-BOD-FRO-177	2026-02-10 04:40:18.147	\N
cmlg44g4t009sx6ttezbxtv8j	COVER BODY/BODY SAMPING JUPITER Z 10 HITAM + COVER STOP	\N	0	YAMAHA	215000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.147	BODY PART	218000.00	YAM-BOD-COV-141	2026-02-10 04:40:18.147	\N
cmlg44gkx00a8x6ttc5tuzjgm	COVER BODY/BODY SAMPING JUPITER Z 10 BIRU MUDA	\N	0	YAMAHA	222000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.147	BODY PART	225000.00	YAM-BOD-COV-150	2026-02-10 04:40:18.147	\N
cmlg44h8o00acx6tt045yegoq	FRONT FENDER/SPAKBOR DEPAN JUPITER Z 06 MERAH MAROON	\N	0	YAMAHA	91000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:25.416	BODY PART	94000.00	YAM-BOD-FRO-215	2026-02-10 04:40:25.416	\N
1b3c8f8d-7beb-47e4-aa93-fce14e7b0d15	LEGSHIELD DALAM / SAYAP DALAM  SCOOPY 20 BESAR HITAM DOFF	\N	0	HONDA	272000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	272000.00	HON-LEG-2235	2026-06-18 17:47:31.403	\N
9a83f7e0-b0e4-4b05-aacf-99a37cfbcb83	LEGSHIELD DALAM / SAYAP DALAM  SCOOPY 20 BESAR GRAY DOFF	\N	0	HONDA	272000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	272000.00	HON-LEG-2236	2026-06-18 17:47:31.403	\N
65354498-86e5-4373-9791-b9c13b916d31	LEGSHIELD DALAM / SAYAP DALAM  SCOOPY 20 BESAR KREM	\N	0	HONDA	272000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	272000.00	HON-LEG-2237	2026-06-18 17:47:31.403	\N
940288c5-fc6e-409e-94e8-073fae023942	LEGSHIELD DALAM / SAYAP DALAM  SCOOPY 20 BESAR SILVER	\N	0	HONDA	272000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	272000.00	HON-LEG-2238	2026-06-18 17:47:31.403	\N
cmlezwnue00c239t5l0zk5qsr	FRONT FENDER / SPAKBOR DEPAN  GENIO HITAM	\N	0	HONDA	135000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	89000.00	HON-FRO-FRO-227	2026-02-09 09:54:35.581	\N
cmlezwo2y00cg39t5gmchxmek	FRONT FENDER / SPAKBOR DEPAN  A SUPRA X 125 07 MERAH	\N	0	HONDA	99000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	105000.00	HON-FRO-FRO-256	2026-02-09 09:54:35.581	\N
cmlezwo8l00cu39t5kzg05ttx	FRONT FENDER / SPAKBOR DEPAN  CB 150 R NEW MERAH	\N	0	HONDA	137000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	105000.00	HON-FRO-FRO-238	2026-02-09 09:54:35.581	\N
cmlezwoe000da39t5zu2ge5ar	FRONT FENDER / SPAKBOR DEPAN  TIGER REVOLUTION BIRU	\N	0	HONDA	103000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	126000.00	HON-FRO-FRO-274	2026-02-09 09:54:35.582	\N
cmlezwojr00dl39t5q0a76j5a	FRONT FENDER / SPAKBOR DEPAN  SCOOPY PINK	\N	0	HONDA	92000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	126000.00	HON-FRO-FRO-219	2026-02-09 09:54:35.582	\N
cmlezwos200e439t5ovd6h6dm	FRONT FENDER / SPAKBOR DEPAN  SCOOPY FI PUTIH	\N	0	HONDA	125000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	126000.00	HON-FRO-FRO-214	2026-02-09 09:54:35.582	\N
cmlezwp0x00eo39t5vs1ukdw7	FRONT FENDER / SPAKBOR DEPAN  XEON HITAM	\N	0	HONDA	52000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	89000.00	HON-FRO-FRO-286	2026-02-09 09:54:35.582	\N
cmlezwqgl00fg39t53l191z2e	FRONT FENDER / SPAKBOR DEPAN  MEGAPRO 06 BIRU TUA	\N	0	HONDA	88000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	126000.00	HON-FRO-FRO-293	2026-02-09 09:54:35.582	\N
cmlg44fhn0094x6tt2f5jbyw9	FRONT FENDER/SPAKBOR DEPAN MIO J / GT HITAM	\N	0	YAMAHA	68000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	71000.00	YAM-BOD-FRO-181	2026-06-19 22:06:40.635	01D3030740AA1
015b14d2-1d0d-44c4-8a73-885283018906	STANDARD TENGAH PCX 150 18	\N	0	HONDA	0.00	STANDARD	2026-06-18 17:11:12.592	BODY PART	105000.00	HON-STD-1466	2026-06-19 22:06:40.767	01B5484397AA1
cmlg44ec9007ox6ttwvmgre7z	COVER BODY/BODY SAMPING MIO J MERAH MAROON	\N	0	YAMAHA	169000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.143	BODY PART	173000.00	YAM-BOD-COV-109	2026-06-19 22:06:40.911	01D3032752AA1
cmlg44ex9008ex6tth6x3qbsb	FRONT FENDER/SPAKBOR DEPAN MIO 08 HITAM	\N	0	YAMAHA	73000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	76000.00	YAM-BOD-FRO-188	2026-06-19 22:06:41.036	01D2430740AA1
cmlezwqzr00g639t5rygolm1g	FRONT FENDER / SPAKBOR DEPAN  SONIC HITAM DOFF	\N	0	HONDA	52000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	105000.00	HON-FRO-FRO-243	2026-02-09 09:54:35.582	\N
cmlezwrrg00h839t5q14w6wz2	REAR FENDER / SPAKBOR BELAKANG MEGAPRO 06	\N	0	HONDA	54000.00	REAR FENDER / (KOLONG) VARIO TECHNO 125	2026-02-09 09:54:40.779	LAIN-LAIN	97000.00	HON-REA-REA-329	2026-02-09 09:54:40.779	\N
cmlezwngc00b339t5x1haagc3	FRONT FENDER / SPAKBOR DEPAN  SCOOPY FI 17 GRAY DOFF	\N	0	HONDA	135000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.58	BODY PART	140000.00	HON-FRO-FRO-204	2026-02-09 09:54:35.58	\N
cmlezwnzm00cb39t5crkb63jy	FRONT FENDER / SPAKBOR DEPAN  A SUPRA X 125 HELM IN HITAM	\N	0	HONDA	53000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	126000.00	HON-FRO-FRO-254	2026-02-09 09:54:35.581	\N
cmlezwo5o00cp39t5twtd57ct	FRONT FENDER / SPAKBOR DEPAN  SPACY HIJAU	\N	0	HONDA	91000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	126000.00	HON-FRO-FRO-269	2026-02-09 09:54:35.581	\N
cmlezwook00du39t5z9mfvquq	FRONT FENDER / SPAKBOR DEPAN  A SMASH MERAH	\N	0	HONDA	78000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	105000.00	HON-FRO-FRO-277	2026-02-09 09:54:35.582	\N
cmlezwpbh00eu39t5zuvst7xb	FRONT FENDER / SPAKBOR DEPAN  A REVO MERAH	\N	0	HONDA	94000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	105000.00	HON-FRO-FRO-250	2026-02-09 09:54:35.582	\N
cmlezwqff00fe39t5uhughthk	FRONT FENDER / SPAKBOR DEPAN  XEON PUTIH	\N	0	HONDA	61000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	105000.00	HON-FRO-FRO-291	2026-02-09 09:54:35.582	\N
cmlezwqzr00g839t5pq5yu929	FRONT FENDER / SPAKBOR DEPAN  SONIC MERAH	\N	0	HONDA	63000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	105000.00	HON-FRO-FRO-244	2026-02-09 09:54:35.582	\N
cmlg43q7q00qypv856d3k612z	FILTER UDARA MIO SOUL	\N	0	YAMAHA	21000.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:46.569	MESIN & OLI	24000.00	YAM-MES-FIL-692	2026-02-10 04:39:46.569	\N
cmlg43rh100ropv85crj0j6r7	PEDAL REM (YAMAHA)	\N	0	YAMAHA	0.00	FILTER UDARA (YAMAHA)	2026-02-10 04:39:52.021	MESIN & OLI	0.00	YAM-MES-PED-701	2026-02-10 04:39:52.021	\N
cmlezwrgo00gm39t5w68b4rmt	FRONT FENDER / SPAKBOR DEPAN  MEGAPRO 06 MERAH MAROON	\N	0	HONDA	88000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:40.776	BODY PART	140000.00	HON-FRO-FRO-301	2026-02-09 09:54:40.776	\N
cmlg443ws0006x6ttm75dge32	REAR HANDLE COVER /BATOK BELAKANG JUPITER MX SILVER	\N	0	YAMAHA	64000.00	REAR HANDLE COVER /BATOK BELAKANG(YAMAHA)	2026-02-10 04:40:07.574	BODY PART	67000.00	YAM-BOD-REA-15	2026-02-10 04:40:07.574	\N
cmlg44450000ax6tt2263ifm5	REAR HANDLE COVER /BATOK BELAKANG JUPITER MX HITAM	\N	0	YAMAHA	57000.00	REAR HANDLE COVER /BATOK BELAKANG(YAMAHA)	2026-02-10 04:40:07.574	BODY PART	60000.00	YAM-BOD-REA-16	2026-02-10 04:40:07.574	\N
cmlg43qho00rcpv853f6orgbj	COVER STOP / RR STOP JUPITER Z 06 HITAM	\N	0	YAMAHA	29000.00	COVER STOP / Rr STOP (YAMAHA)	2026-02-10 04:39:46.569	BODY PART	32000.00	YAM-BOD-COV-614	2026-06-18 17:35:37.871	\N
cmlg444pz000ix6ttk621jy1o	REAR HANDLE COVER /BATOK BELAKANG JUPITER Z	\N	0	YAMAHA	30000.00	REAR HANDLE COVER /BATOK BELAKANG(YAMAHA)	2026-02-10 04:40:07.574	BODY PART	33000.00	YAM-BOD-REA-17	2026-02-10 04:40:07.574	\N
b23c2937-8b16-429d-976c-06d25f84c3b7	LEGSHIELD DALAM / SAYAP DALAM  BEAT 20 / BEAT STREET 20 BESAR	\N	0	HONDA	82000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	82000.00	HON-LEG-2239	2026-06-18 17:47:31.403	\N
cmlg445f5000qx6ttfgc6s7tu	COMPLETE SET BODY JUPITER Z 06 SILVER	\N	0	YAMAHA	1059000.00	COMPLETE SET BODY (YAMAHA)	2026-02-10 04:40:07.574	BODY PART	1062000.00	YAM-BOD-COM-12	2026-02-10 04:40:07.574	\N
cmlg4462r000ux6ttj16fzdj0	REAR HANDLE COVER /BATOK BELAKANG VEGA R 04	\N	0	YAMAHA	31000.00	REAR HANDLE COVER /BATOK BELAKANG(YAMAHA)	2026-02-10 04:40:07.574	BODY PART	34000.00	YAM-BOD-REA-27	2026-02-10 04:40:07.574	\N
cmlezws3z00hy39t5luxoc7dx	PANEL / TAMENGBEAT HITAM	\N	0	HONDA	125000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	324000.00	HON-PAN-PAN-353	2026-02-09 09:54:40.779	\N
cmlezwscn00ig39t5iwjye77c	PANEL / TAMENGBEAT MERAH	\N	0	HONDA	142000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	342000.00	HON-PAN-PAN-358	2026-02-09 09:54:40.779	\N
cmlg44755001cx6ttoz03dddx	REAR HANDLE COVER /BATOK BELAKANG JUPITER MX 11	\N	0	YAMAHA	44000.00	REAR HANDLE COVER /BATOK BELAKANG(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	47000.00	YAM-BOD-REA-20	2026-02-10 04:40:07.575	\N
cmlg447dz001kx6tt9lnpxwa3	LEGSHIELD LUAR/ SAYAP LUAR JUPITER MX HITAM	\N	0	YAMAHA	148000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	151000.00	YAM-BOD-LEG-63	2026-02-10 04:40:07.575	\N
cmlg447jy001ox6ttzwdpe99v	LEGSHIELD LUAR/ SAYAP LUAR JUPITER Z 10 HITAM	\N	0	YAMAHA	144000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	147000.00	YAM-BOD-LEG-57	2026-02-10 04:40:07.575	\N
cmlg447tc001wx6ttla44au17	LEGSHIELD LUAR/ SAYAP LUAR JUPITER MX MERAH MAROON	\N	0	YAMAHA	163000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	166000.00	YAM-BOD-LEG-64	2026-02-10 04:40:07.575	\N
cmlg4481f0022x6ttfpmj3nrt	COMPLETE SET BODY VEGA R 04 HITAM	\N	0	YAMAHA	712000.00	COMPLETE SET BODY (YAMAHA)	2026-02-10 04:40:07.575	BODY PART	715000.00	YAM-BOD-COM-10	2026-02-10 04:40:07.575	\N
cmlg448ap0027x6ttlilvbwo9	LEGSHIELD LUAR/ SAYAP LUAR JUPITER MX BIRU	\N	0	YAMAHA	163000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	166000.00	YAM-BOD-LEG-65	2026-02-10 04:40:07.575	\N
cmlg448ql002cx6ttakq2ne5c	LEGSHIELD LUAR/ SAYAP LUAR JUPITER Z 06 MERAH MAROON	\N	0	YAMAHA	208000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	211000.00	YAM-BOD-LEG-62	2026-02-10 04:40:07.575	\N
cmlg449ow0036x6tt9lujyoz6	LEGSHIELD DALAM JUPITER Z 06 HITAM	\N	0	YAMAHA	159000.00	LEGSHIELD DALAM (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	162000.00	YAM-BOD-LEG-83	2026-02-10 04:40:07.576	\N
cmlg44age003ux6tt82csbx9r	LEGSHIELD DALAM JUPITER Z1 KECIL	\N	0	YAMAHA	59000.00	LEGSHIELD DALAM (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	62000.00	YAM-BOD-LEG-86	2026-02-10 04:40:07.576	\N
cmlg44aoj0042x6ttqznn3jor	LEGSHIELD DALAM VEGA R 04 BIRU	\N	0	YAMAHA	116000.00	LEGSHIELD DALAM (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	119000.00	YAM-BOD-LEG-93	2026-02-10 04:40:07.576	\N
cmlg44ay4004fx6tt2i1rzpal	LEGSHIELD DALAM VEGA R 06 HITAM	\N	0	YAMAHA	163000.00	LEGSHIELD DALAM (YAMAHA)	2026-02-10 04:40:07.577	BODY PART	166000.00	YAM-BOD-LEG-90	2026-02-10 04:40:07.577	\N
cmlg44bmn004zx6ttakwqoin9	COVER BODY/BODY SAMPING MIO J HIJAU	\N	0	YAMAHA	169000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.143	BODY PART	172000.00	YAM-BOD-COV-111	2026-02-10 04:40:18.143	\N
cmlg44bz50054x6ttuk484jib	COVER BODY/BODY SAMPING MIO MERAH MAROON	\N	0	YAMAHA	123000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.143	BODY PART	126000.00	YAM-BOD-COV-126	2026-02-10 04:40:18.143	\N
cmlg44ccu005lx6ttunyeavv6	COVER BODY/BODY SAMPING JUPITER Z 10 MERAH MAROON	\N	0	YAMAHA	222000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	225000.00	YAM-BOD-COV-144	2026-02-10 04:40:18.144	\N
cmlezwgsw001y39t5lopyjgic	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO 160 B KECIL	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	48000.00	HON-COV-COV-60	2026-06-19 22:06:41.161	01B6432580AA1
cmlezxhwt01uq39t5a61yuou9	FOOTREST SCOOPY	\N	0	HONDA	71000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	16000.00	HON-LEG-FOO-1207	2026-06-19 22:06:41.287	01B3134382AA7
cmlg44coh0061x6ttyt1kqzky	COVER BODY/BODY SAMPING JUPITER MX SILVER	\N	0	YAMAHA	199000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	202000.00	YAM-BOD-COV-156	2026-02-10 04:40:18.144	\N
cmlg44czq0068x6ttoasf0ztt	COVER BODY/BODY SAMPING MIO SOUL GT HITAM VIOLET	\N	0	YAMAHA	134000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	137000.00	YAM-BOD-COV-112	2026-02-10 04:40:18.144	\N
cmlg44del006px6ttaomthpnz	COVER BODY/BODY SAMPING MIO HITAM	\N	0	YAMAHA	101000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	104000.00	YAM-BOD-COV-124	2026-02-10 04:40:18.145	\N
cmlg44dw40076x6ttxvcotkja	COVER BODY/BODY SAMPING MIO MERAH	\N	0	YAMAHA	123000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	126000.00	YAM-BOD-COV-125	2026-02-10 04:40:18.145	\N
cmlg44ebe007kx6ttciofwgaq	COVER BODY/BODY SAMPING VEGA R PUTIH	\N	0	YAMAHA	170000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	173000.00	YAM-BOD-COV-161	2026-02-10 04:40:18.145	\N
cmlg44etb0089x6tttl0jx2al	FRONT FENDER/SPAKBOR DEPAN MIO SOUL GT PUTIH	\N	0	YAMAHA	71000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	74000.00	YAM-BOD-FRO-187	2026-02-10 04:40:18.146	\N
cmlg44f9c008sx6tt92kdwuuw	FRONT FENDER/SPAKBOR DEPAN MIO SOUL BIRU MUDA	\N	0	YAMAHA	79000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	82000.00	YAM-BOD-FRO-194	2026-02-10 04:40:18.146	\N
cmlg44fq6009ax6tt6sl38j4p	FRONT FENDER/SPAKBOR DEPAN MIO SOUL GT 125 BLUE CORE MERAH MAROON	\N	0	YAMAHA	77000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	80000.00	YAM-BOD-FRO-199	2026-02-10 04:40:18.146	\N
cmlg44g3f009ox6ttu6r11mf4	COVER BODY/BODY SAMPING JUPITER MX 11 HITAM	\N	0	YAMAHA	205000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.147	BODY PART	208000.00	YAM-BOD-COV-139	2026-02-10 04:40:18.147	\N
b7873ed0-3b24-4dc5-a097-a90b9a646880	LEGSHIELD DALAM / SAYAP DALAM  BEAT 20 / BEAT STREET 20 KECIL	\N	0	HONDA	58000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	58000.00	HON-LEG-2240	2026-06-18 17:47:31.403	\N
cmlg43s0100sapv85gb9ea6jx	BUNTUT Rr RX KING	\N	0	YAMAHA	11000.00	STANDARD (YAMAHA)	2026-02-10 04:39:52.022	KAKI-KAKI	14000.00	YAM-KAK-BUN-714	2026-02-10 04:39:52.022	\N
cmlg44az2004ix6ttrhifah3y	COVER TANGKI/COVER MESIN  MIO SOUL	\N	0	YAMAHA	87000.00	COVER TANGKI/COVER MESIN (YAMAHA)	2026-02-10 04:40:07.575	BODY PART	90000.00	YAM-BOD-COV-34	2026-02-10 04:40:07.575	\N
cmlg44bz6005cx6ttrhbupsws	COVER BODY/BODY SAMPING MIO 08 HIJAU	\N	0	YAMAHA	118000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.143	BODY PART	121000.00	YAM-BOD-COV-133	2026-02-10 04:40:18.143	\N
cmlg44ccu005qx6ttaqth9azf	COVER BODY/BODY SAMPING JUPITER MX HITAM + COVER STOP	\N	0	YAMAHA	212000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	215000.00	YAM-BOD-COV-146	2026-02-10 04:40:18.144	\N
cmlg44coh005zx6ttnnuz5pyk	COVER BODY/BODY SAMPING JUPITER MX HITAM	\N	0	YAMAHA	185000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	188000.00	YAM-BOD-COV-147	2026-02-10 04:40:18.144	\N
cmlg44czr006ax6ttfel86p61	COVER BODY/BODY SAMPING VEGA R 06 HITAM	\N	0	YAMAHA	163000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	166000.00	YAM-BOD-COV-163	2026-02-10 04:40:18.144	\N
cmlg44dg4006wx6tt1b27imuq	COVER BODY/BODY SAMPING V-IXION 12 PUTIH	\N	0	YAMAHA	109000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	112000.00	YAM-BOD-COV-168	2026-02-10 04:40:18.145	\N
cmlg44dxw007cx6tt5l97lgr1	COVER BODY/BODY SAMPING V-IXION 12 HITAM	\N	0	YAMAHA	92000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	95000.00	YAM-BOD-COV-171	2026-02-10 04:40:18.145	\N
cmlg44f8i008qx6ttnrcqjf1h	FRONT FENDER/SPAKBOR DEPAN MIO SOUL GT 125 BLUE CORE HITAM	\N	0	YAMAHA	70000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	73000.00	YAM-BOD-FRO-180	2026-02-10 04:40:18.146	\N
cmlg44g5f009wx6ttol39n45s	COVER BODY/BODY SAMPING JUPITER Z 10 HIJAU	\N	0	YAMAHA	222000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.147	BODY PART	225000.00	YAM-BOD-COV-143	2026-02-10 04:40:18.147	\N
cmlezwsld00iy39t5l58dhbzz	PANEL / TAMENGBEAT ESP 16 HITAM DOFF	\N	0	HONDA	219000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	355000.00	HON-PAN-PAN-363	2026-02-09 09:54:40.779	\N
c91039f9-dded-4682-808d-75a1cc79b0de	LEGSHIELD DALAM / SAYAP DALAM  BEAT 20 BESAR NON CHARGER	\N	0	HONDA	79000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	79000.00	HON-LEG-2241	2026-06-18 17:47:31.403	\N
cmlezwlqn009f39t5wtqfklzw	FRONT FENDER / SPAKBOR DEPAN  VARIO 150 18 / 125 23 SILVER	\N	0	HONDA	142000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	130000.00	HON-FRO-FRO-188	2026-02-09 09:54:30.884	\N
cmlezwmfp00ao39t5c1by1ydy	FRONT FENDER / SPAKBOR DEPAN  BEAT POP PUTIH	\N	0	HONDA	88000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.885	BODY PART	89000.00	HON-FRO-FRO-136	2026-02-09 09:54:30.885	\N
cmlezwngc00bi39t56g2tpzh4	FRONT FENDER / SPAKBOR DEPAN  SCOOPY MERAH MAROON	\N	0	HONDA	92000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	140000.00	HON-FRO-FRO-218	2026-02-09 09:54:35.581	\N
290aa588-33fc-4852-b8e9-105064ae4c7c	LEGSHIELD DALAM / SAYAP DALAM  BEAT 20 KECIL NON CHARGER	\N	0	HONDA	56000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	56000.00	HON-LEG-2242	2026-06-18 17:47:31.403	\N
cmlezwnp200bs39t5zkubbbt2	FRONT FENDER / SPAKBOR DEPAN  CB 150 R NEW HITAM	\N	0	HONDA	123000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	89000.00	HON-FRO-FRO-235	2026-02-09 09:54:35.581	\N
fb14a7c3-0ce8-411d-9a32-732fb813b7ca	LEGSHIELD DALAM / SAYAP DALAM  VARIO 150 18 / VARIO 125 18 BESAR	\N	0	HONDA	116000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	116000.00	HON-LEG-2243	2026-06-18 17:47:31.403	\N
cmlezwo4z00cm39t5od2rl4bw	FRONT FENDER / SPAKBOR DEPAN  SPACY MERAH MAROON	\N	0	HONDA	97000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	140000.00	HON-FRO-FRO-268	2026-02-09 09:54:35.581	\N
cmlezwobh00d039t50c566c8m	FRONT FENDER / SPAKBOR DEPAN  BLADE HITAM	\N	0	HONDA	80000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	89000.00	HON-FRO-FRO-271	2026-02-09 09:54:35.581	\N
cmlezwoc500d739t5yhqh87d9	FRONT FENDER / SPAKBOR DEPAN  TIGER REVOLUTION MERAH MAROON	\N	0	HONDA	99000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	88000.00	HON-FRO-FRO-273	2026-02-09 09:54:35.582	\N
cmlezwsjt00iu39t5b8fy47o9	PANEL / TAMENGBEAT 20 BESAR GRAY DOFF	\N	0	HONDA	246000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	194000.00	HON-PAN-PAN-362	2026-02-09 09:54:40.779	\N
cmlg44bmm004sx6ttny8s80k9	COVER BODY/BODY SAMPING N-MAX BESAR BIRU	\N	0	YAMAHA	222000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.142	BODY PART	228000.00	YAM-BOD-COV-102	2026-06-19 22:06:41.549	01D4232760AA1
cmlg44ej7007wx6tt8cpxsd2t	COVER BODY/BODY SAMPING MIO SOUL MERAH MAROON	\N	0	YAMAHA	154000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	158000.00	YAM-BOD-COV-116	2026-06-19 22:06:41.681	01D2632752AA1
cmlg44frk009ex6tts6okmlfx	FRONT FENDER/SPAKBOR DEPAN MIO M3 HITAM	\N	0	YAMAHA	78000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.147	BODY PART	81000.00	YAM-BOD-FRO-176	2026-06-19 22:06:41.808	01D4030740AA1
cmlg43rh100s0pv85w1xcoaak	STANDARD SAMPING MIO	\N	0	YAMAHA	0.00	STANDARD (YAMAHA)	2026-02-10 04:39:52.021	KAKI-KAKI	35000.00	YAM-KAK-STA-711	2026-06-19 22:06:42.079	01D1999997AA1
cmlezwttw00jr39t5sr533w44	PANEL / TAMENGDEPAN BAGIAN BAWAH BEAT FI	\N	0	HONDA	70000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	63000.00	HON-PAN-PAN-369	2026-02-09 09:54:40.779	\N
cmlezwu8f00kc39t5eco24nkm	PANEL / TAMENGBEAT POP PUTIH	\N	0	HONDA	176000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	342000.00	HON-PAN-PAN-346	2026-02-09 09:54:40.78	\N
056b1ee1-2bc7-4b56-bc65-cd1c152d12c9	LEGSHIELD DALAM / SAYAP DALAM  VARIO 150 18 / VARIO 125 18 KECIL HITAM	\N	0	HONDA	128000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	128000.00	HON-LEG-2244	2026-06-18 17:47:31.403	\N
94547470-18be-43ca-9249-13ac7c6da8ee	LEGSHIELD DALAM / SAYAP DALAM  VARIO 150 18 / VARIO 125 18 KECIL HITAM DOFF	\N	0	HONDA	137000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	137000.00	HON-LEG-2245	2026-06-18 17:47:31.403	\N
ebe955e1-6913-4f02-b659-084252c2ca48	LEGSHIELD DALAM / SAYAP DALAM  VARIO 150 18 / VARIO 125 18 KECIL MERAH DOFF	\N	0	HONDA	137000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	137000.00	HON-LEG-2246	2026-06-18 17:47:31.403	\N
cmlezwvmw00m639t5owjcnqcs	PANEL / TAMENGVARIO TECHNO 125 BESAR MERAH MAROON	\N	0	HONDA	194000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.184	LAIN-LAIN	187000.00	HON-PAN-PAN-401	2026-02-09 09:54:46.184	\N
944a0dc6-4595-4c38-b877-5367682cdeb6	LEGSHIELD DALAM / SAYAP DALAM  VARIO 150 18 / VARIO 125 18 KECIL PUTIH	\N	0	HONDA	135000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	135000.00	HON-LEG-2247	2026-06-18 17:47:31.403	\N
cmlezww7h00nk39t5clwx313t	PANEL / TAMENGVARIO 150 BESAR BIRU DOFF	\N	0	HONDA	118000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	187000.00	HON-PAN-PAN-421	2026-02-09 09:54:46.185	\N
cmlg44cog005wx6ttyzpkz122	COVER BODY/BODY SAMPING MIO BIRU MUDA (TELUR ASIN) + COVER STOP	\N	0	YAMAHA	145000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	148000.00	YAM-BOD-COV-129	2026-02-10 04:40:18.144	\N
cmlg44d16006ix6ttqohxdrp0	COVER BODY/BODY SAMPING MIO KUNING + COVER STOP	\N	0	YAMAHA	153000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	156000.00	YAM-BOD-COV-130	2026-02-10 04:40:18.144	\N
cmlg44dj8006yx6tt1dfavk8q	COVER BODY/BODY SAMPING VEGA R 06 SILVER + COVER STOP	\N	0	YAMAHA	216000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	219000.00	YAM-BOD-COV-159	2026-02-10 04:40:18.145	\N
cmlg44ej8007yx6ttn99naaf0	FRONT FENDER/SPAKBOR DEPAN A AEROX 155 KUNING	\N	0	YAMAHA	116000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	119000.00	YAM-BOD-FRO-175	2026-02-10 04:40:18.145	\N
cmlg44eyp008ix6tteyoqehz0	FRONT FENDER/SPAKBOR DEPAN MIO SOUL GT MERAH MAROON	\N	0	YAMAHA	71000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	74000.00	YAM-BOD-FRO-186	2026-02-10 04:40:18.146	\N
cmlg44g1q009kx6tte5m8kg68	COVER BODY/BODY SAMPING JUPITER Z1 PUTIH	\N	0	YAMAHA	291000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.147	BODY PART	294000.00	YAM-BOD-COV-138	2026-02-10 04:40:18.147	\N
cmlg44ghv00a2x6ttvfmvnqzf	COVER BODY/BODY SAMPING JUPITER Z 06 BIRU + COVER STOP	\N	0	YAMAHA	238000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.147	BODY PART	241000.00	YAM-BOD-COV-152	2026-02-10 04:40:18.147	\N
cmlezwwxl00on39t5mtogu39a	PANEL / TAMENGVARIO 110 FI HITAM DOFF	\N	0	HONDA	163000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	218000.00	HON-PAN-PAN-422	2026-02-09 09:54:46.185	\N
cmlezwxbl00ph39t56r8ztdin	PANEL / TAMENGSMASH MERAH	\N	0	HONDA	39000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	342000.00	HON-PAN-PAN-480	2026-02-09 09:54:46.185	\N
65766103-e932-46f3-a490-867234dd148d	LEGSHIELD DALAM / SAYAP DALAM SCOOPY FI 17 BESAR HITAM	\N	0	HONDA	192000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	192000.00	HON-LEG-2248	2026-06-18 17:47:31.403	\N
d0cbeae9-1c7e-4e8c-b0e6-2768fdaffa3f	LEGSHIELD DALAM / SAYAP DALAM  SCOOPY FI 17 BESAR HITAM DOFF	\N	0	HONDA	218000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	218000.00	HON-LEG-2249	2026-06-18 17:47:31.403	\N
cmlezwycn00ri39t57dl3jq5b	PANEL / TAMENGVARIO KECIL PINK / DASI	\N	0	HONDA	75000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	58000.00	HON-PAN-PAN-416	2026-02-09 09:54:46.185	\N
91e96549-7c3e-4ec2-ae1e-b4d8cad8d69f	LEGSHIELD DALAM / SAYAP DALAM  SCOOPY FI 17 BESAR MERAH	\N	0	HONDA	218000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	218000.00	HON-LEG-2250	2026-06-18 17:47:31.403	\N
cmlezwyyi00sh39t5p46ofh6c	FRONT HANDLE COVER / BATOK DEPAN BEAT 20 HITAM DOFF	\N	0	HONDA	120000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-527	2026-02-09 09:54:50.206	\N
a0834fc7-818b-4eea-9b45-67320cdbad8b	LEGSHIELD DALAM / SAYAP DALAM  SCOOPY FI 17 BESAR PUTIH	\N	0	HONDA	218000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	218000.00	HON-LEG-2251	2026-06-18 17:47:31.403	\N
cmlezwzcf00tg39t5ud6tsqmq	FRONT HANDLE COVER / BATOK DEPAN VARIO 150 18 + ACC MERAH	\N	0	HONDA	176000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-541	2026-02-09 09:54:50.207	\N
cmlezx0iu00wb39t5nkte5ep9	FRONT HANDLE COVER / BATOK DEPAN REVO PUTIH	\N	0	HONDA	81000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-582	2026-02-09 09:54:50.207	\N
cmlezx0r100wu39t5ocnwurou	FRONT HANDLE COVER / BATOK DEPAN SUPRA FIT HITAM TROMOL	\N	0	HONDA	62000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-596	2026-02-09 09:54:50.207	\N
bc8e3712-482a-43af-9fdf-5ba8a5237f29	LEGSHIELD DALAM / SAYAP DALAM  BEAT ESP 16 / BEAT STREET 16 KECIL	\N	0	HONDA	64000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	64000.00	HON-LEG-2252	2026-06-18 17:47:31.403	\N
5a5e8cd3-30fc-4797-a4a2-cf48bf6f20b4	LEGSHIELD DALAM / SAYAP DALAM  SCOOPY FI ESP BESAR HITAM	\N	0	HONDA	232000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	232000.00	HON-LEG-2253	2026-06-18 17:47:31.403	\N
da5397ab-b8e0-4c44-b22d-a982527c4eb0	LEGSHIELD DALAM / SAYAP DALAM  SCOOPY FI ESP BESAR MERAH	\N	0	HONDA	257000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	257000.00	HON-LEG-2254	2026-06-18 17:47:31.403	\N
810ea3fa-086e-43fd-a07e-f1008bfbfd1f	LEGSHIELD DALAM / SAYAP DALAM  SCOOPY FI ESP BESAR PUTIH	\N	0	HONDA	257000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	257000.00	HON-LEG-2255	2026-06-18 17:47:31.403	\N
44e56e8d-b750-4657-a318-74692d5bc4a3	LEGSHIELD DALAM / SAYAP DALAM  VARIO 150 / VARIO 125 BESAR	\N	0	HONDA	128000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	128000.00	HON-LEG-2256	2026-06-18 17:47:31.403	\N
2b2a2b3f-1ba0-4ea6-a8a2-05eb8ef961c2	LEGSHIELD DALAM / SAYAP DALAM  VARIO 150 / VARIO 125 KECIL HITAM	\N	0	HONDA	86000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	86000.00	HON-LEG-2257	2026-06-18 17:47:31.403	\N
cmlg44e2m007ex6ttsnwidfxj	COVER BODY/BODY SAMPING MIO SOUL HITAM	\N	0	YAMAHA	127000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	131000.00	YAM-BOD-COV-115	2026-06-19 22:06:42.352	01D2632740AA1
cmlg44fcd0090x6ttnggt2rcf	FRONT FENDER/SPAKBOR DEPAN MIO 08 PUTIH	\N	0	YAMAHA	83000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	86000.00	YAM-BOD-FRO-192	2026-06-19 22:06:42.484	01D2430747AA1
cmlezwos100e239t574huqwii	FRONT FENDER / SPAKBOR DEPAN  B SUPRA X 125	\N	0	HONDA	52000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	89000.00	HON-FRO-FRO-260	2026-06-19 22:06:42.617	01B2030900AA1
cmlezxfcr01q839t5qdbjqldf	LEGSHIELD LUAR / SAYAP LUAR ABSOLUTE REVO FIT	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	205000.00	HON-LEG-LEG-1127	2026-06-19 22:06:42.747	01B3731882AA1
4cfeebc3-6fa0-4768-8b97-4a1388794173	LEGSHIELD DALAM / SAYAP DALAM  VARIO 150 / VARIO 125 KECIL HITAM DOFF	\N	0	HONDA	102000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	102000.00	HON-LEG-2258	2026-06-18 17:47:31.403	\N
cmlezwwpj00oi39t59rcvaar9	PANEL / TAMENGREVO FI MERAH MAROON	\N	0	HONDA	192000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	342000.00	HON-PAN-PAN-463	2026-02-09 09:54:46.185	\N
867100e0-f8c1-4a59-a0e9-91879aaea74c	LEGSHIELD DALAM / SAYAP DALAM  VARIO 150 / VARIO 125 KECIL GRAY	\N	0	HONDA	102000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	102000.00	HON-LEG-2259	2026-06-18 17:47:31.403	\N
319a6ca0-ec3f-4d77-b64e-be01812f845a	LEGSHIELD DALAM / SAYAP DALAM  VARIO 150 / VARIO 125 KECIL MERAH	\N	0	HONDA	102000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	102000.00	HON-LEG-2260	2026-06-18 17:47:31.403	\N
3615eae5-1eee-49c2-a79d-20e6170ac8ea	LEGSHIELD DALAM / SAYAP DALAM VARIO 150 / VARIO 125 KECIL MERAH MAROON	\N	0	HONDA	102000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	102000.00	HON-LEG-2261	2026-06-18 17:47:31.403	\N
b586ea43-7d30-429b-b277-3dba6e5714ca	LEGSHIELD DALAM / SAYAP DALAM  VARIO 150 / VARIO 125 KECIL GRAY DOFF	\N	0	HONDA	102000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	102000.00	HON-LEG-2262	2026-06-18 17:47:31.403	\N
cmlg44ghv00a5x6ttm4fedf5p	COVER BODY/BODY SAMPING JUPITER Z1 MERAH MAROON	\N	0	YAMAHA	291000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.147	BODY PART	294000.00	YAM-BOD-COV-137	2026-02-10 04:40:18.147	\N
03abc1e7-d712-4aa4-9e62-404c4f9273cc	LEGSHIELD DALAM / SAYAP DALAM  VARIO 150 / VARIO 125 KECIL BIRU DOFF	\N	0	HONDA	102000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	102000.00	HON-LEG-2263	2026-06-18 17:47:31.403	\N
cmlg45l5h000313pesqo1u08q	LEGSHIELD LUAR/ SAYAP LUAR JUPITER MX 11 HITAM	\N	0	YAMAHA	163000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:41:16.791	BODY PART	166000.00	YAM-BOD-LEG-55	2026-02-10 04:41:16.791	\N
cmlg45l5g000213pe63t46ycj	COMPLETE SET BODY VEGA R 06 HITAM	\N	0	YAMAHA	866000.00	COMPLETE SET BODY (YAMAHA)	2026-02-10 04:41:16.791	BODY PART	869000.00	YAM-BOD-COM-11	2026-02-10 04:41:16.791	\N
cmlg45l7s000613pe1gw6p8ho	LEGSHIELD LUAR/ SAYAP LUAR JUPITER MX 11 PUTIH	\N	0	YAMAHA	181000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:41:16.791	BODY PART	184000.00	YAM-BOD-LEG-56	2026-02-10 04:41:16.791	\N
cmlg45lem000813pe0ecudks6	LEGSHIELD LUAR/ SAYAP LUAR VEGA R 04 BIRU	\N	0	YAMAHA	142000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:41:16.791	BODY PART	145000.00	YAM-BOD-LEG-74	2026-02-10 04:41:16.791	\N
cmlg45lem000a13pendk5r00i	LEGSHIELD LUAR/ SAYAP LUAR F1Z-R HITAM	\N	0	YAMAHA	127000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:41:16.791	BODY PART	130000.00	YAM-BOD-LEG-75	2026-02-10 04:41:16.791	\N
cmlg45lt6000e13peulkx5q2k	LEGSHIELD LUAR/ SAYAP LUAR MIO M3 KECIL	\N	0	YAMAHA	45000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:41:16.791	BODY PART	48000.00	YAM-BOD-LEG-53	2026-02-10 04:41:16.791	\N
cmlg45lu2000g13peojasn03o	COMPLETE SET BODY JUPITER MX KOPLING HITAM	\N	0	YAMAHA	841000.00	COMPLETE SET BODY (YAMAHA)	2026-02-10 04:41:16.791	BODY PART	844000.00	YAM-BOD-COM-13	2026-02-10 04:41:16.791	\N
cmlg45mpw000i13pem8nlgbpu	COMPLETE SET BODY VEGA R 06 SILVER	\N	0	YAMAHA	933000.00	COMPLETE SET BODY (YAMAHA)	2026-02-10 04:41:16.791	BODY PART	936000.00	YAM-BOD-COM-9	2026-02-10 04:41:16.791	\N
cmlezx98d01cy39t57tv2s65s	MIKA SPEEDOMETER SUPRA X 125 + INNER	\N	0	HONDA	29000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	27000.00	HON-MIK-MIK-854	2026-06-18 17:19:42.083	\N
cmlg464590002105gs9w8ucsx	LEGSHIELD LUAR/ SAYAP LUAR JUPITER Z1 BESAR	\N	0	YAMAHA	208000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:41:41.317	BODY PART	211000.00	YAM-BOD-LEG-54	2026-02-10 04:41:41.317	\N
cmlg465vz0006105gf5o229kg	LEGSHIELD LUAR/ SAYAP LUAR N-MAX BESAR HITAM	\N	0	YAMAHA	214000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:41:41.317	BODY PART	217000.00	YAM-BOD-LEG-41	2026-02-10 04:41:41.317	\N
6a9a2fee-d6a9-4349-bb3c-b07828d2c6d4	LEGSHIELD DALAM / SAYAP DALAM  VARIO 150 / VARIO 125 KECIL PUTIH	\N	0	HONDA	102000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	102000.00	HON-LEG-2264	2026-06-18 17:47:31.403	\N
b07069a7-7df3-42b2-9052-7a8820064a1c	LEGSHIELD DALAM / SAYAP DALAM  ATAS VARIO TECHNO 125 HITAM	\N	0	HONDA	217000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	217000.00	HON-LEG-2265	2026-06-18 17:47:31.403	\N
79b61e33-8983-44d8-b468-2a7cfb5bebe5	LEGSHIELD DALAM / SAYAP DALAM  BAWAH VARIO TECHNO 125	\N	0	HONDA	67000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	67000.00	HON-LEG-2266	2026-06-18 17:47:31.403	\N
b3947159-b9f3-4b65-894e-db6a950b10d4	LEGSHIELD DALAM / SAYAP DALAM  SCOOPY FI / SCOOPY FI ESP KECIL HITAM	\N	0	HONDA	121000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	121000.00	HON-LEG-2267	2026-06-18 17:47:31.403	\N
cmlezwxyg00qs39t5irwmwgwl	PANEL / TAMENGBLADE 11 HITAM	\N	0	HONDA	68000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	324000.00	HON-PAN-PAN-469	2026-02-09 09:54:46.185	\N
c3b5d018-efbe-452a-97b6-28efb5a75fe5	LEGSHIELD DALAM / SAYAP DALAM  SCOOPY FI / SCOOPY FI ESP KECIL MERAH MAROON	\N	0	HONDA	137000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	137000.00	HON-LEG-2268	2026-06-18 17:47:31.403	\N
cmlezwy8w00ra39t5uyak6azk	PANEL / TAMENGBLADE HITAM	\N	0	HONDA	97000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	324000.00	HON-PAN-PAN-470	2026-02-09 09:54:46.185	\N
cmlezwyyi00sf39t507qf0rqa	FRONT HANDLE COVER / BATOK DEPAN BEAT PINK	\N	0	HONDA	62000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-530	2026-02-09 09:54:50.206	\N
cmlezwzwk00uw39t5lzqbz2x8	FRONT HANDLE COVER / BATOK DEPAN VARIO 150 HITAM DOFF	\N	0	HONDA	189000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-558	2026-02-09 09:54:50.207	\N
e86cbfb5-d2f4-4578-b42e-5c6f84bf913c	LEGSHIELD DALAM / SAYAP DALAM  SCOOPY FI / SCOOPY FI ESP KECIL PUTIH	\N	0	HONDA	137000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	137000.00	HON-LEG-2269	2026-06-18 17:47:31.403	\N
cmlezx99301d239t59vohfmwy	MIKA SEN Rr / MIKA SEN BELAKANG + STOP SUPRA X (P/P) KO	\N	0	HONDA	37000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	79000.00	HON-MIK-MIK-896	2026-02-09 09:55:01.49	\N
cmlezx9fd01df39t5i1k7tk8y	MIKA LAMPU SUPRA X	\N	0	HONDA	27000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	341000.00	HON-MIK-MIK-810	2026-02-09 09:55:01.49	\N
34229c9b-0167-45c3-a809-189f0771b98a	LEGSHIELD DALAM / SAYAP DALAM  VARIO	\N	0	HONDA	78000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	78000.00	HON-LEG-2270	2026-06-18 17:47:31.403	\N
4f4c6218-7ebd-4129-bd05-fe3aa8b1dea3	LEGSHIELD DALAM / SAYAP DALAM  SUPRA / SUPRA X / SUPRA FIT HITAM	\N	0	HONDA	146000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	146000.00	HON-LEG-2271	2026-06-18 17:47:31.403	\N
cmlezx09e00vq39t5xpe6vy61	FRONT HANDLE COVER / BATOK DEPAN B SCOOPY 20 BIRU DOFF	\N	0	HONDA	75000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	132000.00	HON-FRO-FRO-575	2026-02-09 09:54:50.207	\N
cmlezwsi000im39t5zk9i9ww3	REAR FENDER / SPAKBOR BELAKANG SUPRA X 125 07	\N	0	HONDA	75000.00	REAR FENDER / (KOLONG) VARIO TECHNO 125	2026-02-09 09:54:40.779	LAIN-LAIN	77000.00	HON-REA-REA-321	2026-06-19 22:06:43.011	01B2533282AA1
cmlg4652h0004105gaww18til	LEGSHIELD LUAR/ SAYAP LUAR N-MAX KECIL HITAM	\N	0	YAMAHA	177000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:41:41.317	BODY PART	180000.00	YAM-BOD-LEG-45	2026-06-19 22:06:43.148	01D4238540AA1
cmlg45lix000c13pextkolu03	LEGSHIELD DALAM MIO SOUL	\N	0	YAMAHA	97000.00	LEGSHIELD DALAM (YAMAHA)	2026-02-10 04:41:16.791	BODY PART	101000.00	YAM-BOD-LEG-100	2026-06-19 22:06:43.274	01D2635282AA1
cmlezx0ig00w839t5o7qjia1u	FRONT HANDLE COVER / BATOK DEPAN ABSOLUTE REVO MERAH MAROON	\N	0	HONDA	94000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	132000.00	HON-FRO-FRO-584	2026-02-09 09:54:50.207	\N
cmlezx1p800yg39t5omt99vvu	REAR HANDLE / BATOK BELAKANG COVER GENIO HITAM	\N	0	HONDA	57000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	39000.00	HON-REA-REA-636	2026-02-09 09:54:53.444	\N
cmlezx1uq00yy39t5584uug2z	COVER STOP / RR STOP VARIO 150 18 / 125 23 MERAH DOFF	\N	0	HONDA	120000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	77000.00	HON-COV-COV-654	2026-02-09 09:54:53.444	\N
cmlezx2ln010z39t5ggs98ty5	COVER STOP / RR STOP VARIO 150 18 / 125 23 MERAH	\N	0	HONDA	103000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	77000.00	HON-COV-COV-649	2026-02-09 09:54:53.444	\N
b703e50e-4eb6-4b2c-999e-9e9666073bc7	COVER BODY / BODY SAMPING VARIO 125 23 BESAR HITAM	\N	0	HONDA	280000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	280000.00	HON-COV-2272	2026-06-18 17:47:31.403	\N
cmlezxall01f239t5zm2hom3s	MIKA STOP / MIKA BELAKANG SUPRA X 125 (P)	\N	0	HONDA	31000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	30000.00	HON-MIK-MIK-941	2026-02-09 09:55:04.847	\N
3dc236de-bf8a-42c6-832d-ba5de41b7a47	COVER BODY/ BODY SAMPING  VARIO 125 23 BESAR HITAM DOFF	\N	0	HONDA	305000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	305000.00	HON-COV-2273	2026-06-18 17:47:31.403	\N
cmlezxbp801hu39t5sns3rxyk	MIKA STOP / MIKA BELAKANG BEAT ESP 16 (P) KO	\N	0	HONDA	30000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	30000.00	HON-MIK-MIK-930	2026-02-09 09:55:04.848	\N
cmlezwmi500aq39t5tce67auv	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI CB 150 R MERAH	\N	0	HONDA	189000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.885	BODY PART	192000.00	HON-COV-COV-113	2026-06-18 17:22:17.168	\N
cmlezwzsc00uk39t5p0wh4ake	FRONT HANDLE COVER / BATOK DEPAN VARIO 150 PUTIH	\N	0	HONDA	181000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-551	2026-02-09 09:54:50.207	\N
cmlezwzxz00uy39t5hshhg1eb	FRONT HANDLE COVER / BATOK DEPAN VARIO 110 FI PUTIH	\N	0	HONDA	126000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-560	2026-02-09 09:54:50.207	\N
cmlezx0ao00vy39t5yl4dtoau	FRONT HANDLE COVER / BATOK DEPAN GENIO A+B PUTIH	\N	0	HONDA	75000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-579	2026-02-09 09:54:50.207	\N
cmlezxp0j028n39t5q2eupsx9	AKI BESAR	\N	3	HONDA	0.00		2026-02-09 09:55:22.865	KELISTRIKAN	210000.00	HON-AKI-AKI-1459	2026-06-23 19:17:00.584	\N
cmlezx0to00x239t5237cr62c	FRONT HANDLE COVER / BATOK DEPAN SUPRA HITAM	\N	0	HONDA	60000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-598	2026-02-09 09:54:50.207	\N
cmlezxox0028i39t50d2sbhp7	AKI KECIL	\N	0	HONDA	0.00		2026-02-09 09:55:22.865	KELISTRIKAN	135000.00	HON-AKI-AKI-1458	2026-02-10 13:46:34.19	\N
cmlezx1ls00ye39t5r3gywhlv	REAR HANDLE / BATOK BELAKANG COVER REVO FI / REVO X	\N	0	HONDA	46000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	60000.00	HON-REA-REA-625	2026-02-09 09:54:53.444	\N
61e37ef6-41a5-4d36-9557-711c75b5195d	COVER BODY/ BODY SAMPING  VARIO 125 23 BESAR BIRU DOFF	\N	0	HONDA	305000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	305000.00	HON-COV-2274	2026-06-18 17:47:31.403	\N
349bfa32-6589-44ea-a55c-efc50e157bf3	COVER BODY/ BODY SAMPING  VARIO 125 23 KECIL	\N	0	HONDA	86000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	86000.00	HON-COV-2275	2026-06-18 17:47:31.403	\N
06283037-60c3-4123-9f8a-ef2d05c7c449	COVER BODY/ BODY SAMPING  VARIO 160 BESAR HITAM	\N	0	HONDA	280000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	280000.00	HON-COV-2276	2026-06-18 17:47:31.403	\N
cmlezx5pw016739t5g1juo3o4	LAMPU DEPAN / HEAD LAMP MEGAPRO	\N	0	HONDA	98000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	109000.00	HON-LAM-LAM-769	2026-06-18 17:27:37.767	\N
cmlezx68w017239t567cufulc	MIKA LAMPU VARIO 160	\N	0	HONDA	229000.00	MIKA LAMPU (HONDA)	2026-02-09 09:54:56.89	KELISTRIKAN	255000.00	HON-MIK-MIK-791	2026-06-18 17:27:37.767	\N
cmlezxco801jk39t53fw9xbm5	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT PRIMA (C/P)	\N	0	HONDA	76000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.264	LAIN-LAIN	429000.00	HON-FRO-FRO-1001	2026-02-09 09:55:08.264	\N
cmlezxd7901l239t5rsmi84re	COB LAMPU / FITTING LAMPU VARIO TECHNO	\N	0	HONDA	20000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	63000.00	HON-STO-COB-1054	2026-02-09 09:55:08.265	\N
cmlezxdk301ly39t5ajjlz5uh	COB LAMPU / FITTING LAMPU BLADE 11	\N	0	HONDA	11000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	17100.00	HON-STO-COB-1068	2026-02-09 09:55:08.265	\N
cmlezxe4401nn39t5l5hmwt38	COB LAMPU / FITTING LAMPU PRIMA	\N	0	HONDA	8000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.266	KELISTRIKAN	17100.00	HON-STO-COB-1073	2026-02-09 09:55:08.266	\N
288f6660-ce14-4b8b-ae2f-1e00f3dc5a99	COVER BODY/ BODY SAMPING  VARIO 160 BESAR HITAM DOFF	\N	0	HONDA	305000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	305000.00	HON-COV-2277	2026-06-18 17:47:31.403	\N
4f20a6f2-2255-4be7-a0aa-9193fd3a400b	COVER BODY/ BODY SAMPING  VARIO 160 BESAR MERAH DOFF	\N	0	HONDA	305000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	305000.00	HON-COV-2278	2026-06-18 17:47:31.403	\N
8d56bf13-c8cb-4dc5-b7a4-3ff19f425dbd	COVER BODY/ BODY SAMPING  VARIO 160 BESAR PUTIH DOFF	\N	0	HONDA	305000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	305000.00	HON-COV-2279	2026-06-18 17:47:31.403	\N
10f5cc82-9249-4bec-885a-fd9760d2111a	COVER BODY/ BODY SAMPING  VARIO 160 A KECIL	\N	0	HONDA	54000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	54000.00	HON-COV-2280	2026-06-18 17:47:31.403	\N
e1d35a67-c989-4cab-aa46-5d3e8f587828	COVER BODY/ BODY SAMPING  VARIO 160 B KECIL HITAM DOFF	\N	0	HONDA	124000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	124000.00	HON-COV-2281	2026-06-18 17:47:31.403	\N
814ea805-dd79-4b56-8cfe-e8f1458a8353	COVER BODY/ BODY SAMPING  SCOOPY 20 HITAM	\N	0	HONDA	351000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	351000.00	HON-COV-2282	2026-06-18 17:47:31.403	\N
adb5af42-e03b-45f0-958f-1230d377f102	COVER BODY/ BODY SAMPING  SCOOPY 20 KREM	\N	0	HONDA	382000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	382000.00	HON-COV-2283	2026-06-18 17:47:31.403	\N
c1355182-8270-4814-8fc4-e50dd523f9af	COVER BODY/ BODY SAMPING  SCOOPY 20 MERAH DOFF	\N	0	HONDA	382000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	382000.00	HON-COV-2284	2026-06-18 17:47:31.403	\N
edc1f474-e477-4003-b025-353de9d02bf5	COVER BODY/ BODY SAMPING  SCOOPY 20 PUTIH DOFF	\N	0	HONDA	382000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	382000.00	HON-COV-2285	2026-06-18 17:47:31.403	\N
cmlezx5yf016h39t5cuprurg2	LAMPU DEPAN / HEAD LAMP SUPRA	\N	0	HONDA	54000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	61000.00	HON-LAM-LAM-765	2026-06-19 22:06:43.546	01B1100200AA1
cmlezwgbx000s39t5i0h6k891	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BEAT MERAH MAROON	\N	0	HONDA	179000.00	COVER BODY / BODY SAMPING BELAKANG  KANAN KIRI (HONDA)	2026-02-09 09:54:25.619	BODY PART	197000.00	HON-COV-COV-23	2026-06-19 22:06:43.679	01B2732755AA1
cmlg3smim000merj0pe2ipafv	MIKA LAMPU SATRIA FU 150 FI 16	\N	0	SUZUKI	61000.00	MIKA LAMPU / SUZUKI)	2026-02-10 04:31:07.267	KELISTRIKAN	64000.00	SUZ-KEL-MIK-17	2026-06-19 22:06:43.813	01C3400100AA1
aed3a0a7-6f7e-4243-91d6-87c89b9e2b34	COVER BODY/ BODY SAMPING  SCOOPY 20 HIJAU DOFF	\N	0	HONDA	382000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	382000.00	HON-COV-2286	2026-06-18 17:47:31.403	\N
9e84bef5-c1da-4fd0-8d7d-c377ab27bf7a	COVER BODY/ BODY SAMPING  BEAT 20 / BEAT STREET 20 BESAR HITAM	\N	0	HONDA	225000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	225000.00	HON-COV-2287	2026-06-18 17:47:31.403	\N
cmlezx99j01d439t5n0h6mb1z	MIKA SEN Rr / MIKA SEN BELAKANG + STOP SUPRA (O/M) KO	\N	0	HONDA	31000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	79000.00	HON-MIK-MIK-898	2026-02-09 09:55:01.49	\N
cmlezx7rd019a39t5pt3fqwfh	MIKA LAMPU SONIC	\N	0	HONDA	96000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	109000.00	HON-MIK-MIK-826	2026-06-18 17:27:37.767	\N
cmlezxa1a01dz39t53jr8cs9o	MIKA SEN Rr / MIKA SEN BELAKANG + STOP SUPRA FIT (P/M) KO	\N	0	HONDA	34000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	79000.00	HON-MIK-MIK-901	2026-02-09 09:55:04.847	\N
cmlezxabs01en39t5qgwkuuqv	MIKA STOP / MIKA BELAKANG BEAT ESP 16 (M) KO	\N	0	HONDA	20000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	30000.00	HON-MIK-MIK-926	2026-02-09 09:55:04.847	\N
cmlezx7g0018h39t5rdh87buw	MIKA LAMPU SUPRA FIT	\N	0	HONDA	47000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	53000.00	HON-MIK-MIK-809	2026-06-18 17:27:37.767	\N
cmlezxalu01f739t5950jpa1d	MIKA SEN Fr / MIKA SEN DEPAN  SMASH 06 (P)	\N	0	HONDA	22000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	32000.00	HON-MIK-MIK-911	2026-02-09 09:55:04.847	\N
cmlezxayr01g039t5p4w065ao	MIKA STOP / MIKA BELAKANG BEAT 20 (P)	\N	0	HONDA	28000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	30000.00	HON-MIK-MIK-928	2026-02-09 09:55:04.847	\N
cmlezxb5601gc39t5klciot0e	MIKA STOP / MIKA BELAKANG KARISMA (P) KO	\N	0	HONDA	23000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	170000.00	HON-MIK-MIK-960	2026-02-09 09:55:04.847	\N
cmlezxbcv01h239t5alxe25cq	MIKA SEN Fr / MIKA SEN DEPAN  GRAND (C/P) KO	\N	0	HONDA	26000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	94000.00	HON-MIK-MIK-914	2026-02-09 09:55:04.847	\N
cmlezxbq801hy39t54bgwr9x8	MIKA STOP / MIKA BELAKANG SUPRA X (M) KO	\N	0	HONDA	23000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	30000.00	HON-MIK-MIK-939	2026-02-09 09:55:04.848	\N
cmlezxbwm01ii39t520awxzbs	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT SUPRA X 125 14	\N	0	HONDA	161000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	429000.00	HON-FRO-FRO-982	2026-02-09 09:55:04.848	\N
cmlezxdql01mc39t5xzb89132	COB LAMPU / FITTING LAMPU SPACY	\N	0	HONDA	10000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	17100.00	HON-STO-COB-1070	2026-02-09 09:55:08.265	\N
836e3a91-a756-4b3f-943d-8b4429e836a6	COVER STOP / RR STOP SCOOPY FI 17 MERAH DOFF	\N	0	HONDA	118000.00	COVER STOP	2026-06-18 17:27:37.767	BODY PART	118000.00	HON-COV-2075	2026-06-18 17:35:37.871	\N
cmlezxft401rc39t5g1ub6lko	LEGSHIELD DALAM / SAYAP DALAM REVO FI / REVO X BESAR	\N	0	HONDA	84000.00	LEGSHIELD DALAM / SAYAP DALAM REVO FI HITAM	2026-02-09 09:55:11.246	BODY PART	76000.00	HON-LEG-LEG-1152	2026-02-09 09:55:11.246	\N
14639fc2-0afb-4407-aa2a-e9db17873c25	COVER BODY/ BODY SAMPING  BEAT 20 / BEAT STREET 20 BESAR HITAM DOFF	\N	0	HONDA	247000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	247000.00	HON-COV-2288	2026-06-18 17:47:31.403	\N
cmlezxgdl01so39t5ltg5ufhq	LEGSHIELD LUAR / SAYAP LUAR REVO MERAH MAROON	\N	0	HONDA	145000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	228000.00	HON-LEG-LEG-1124	2026-02-09 09:55:11.246	\N
37a88dfb-5fbb-4803-aa77-ab24526e8250	COVER BODY/ BODY SAMPING  BEAT 20 / BEAT STREET 20 BESAR PUTIH	\N	0	HONDA	247000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	247000.00	HON-COV-2289	2026-06-18 17:47:31.403	\N
edcffe08-e203-4f06-82da-e7cdf9a80b4c	COVER BODY/ BODY SAMPING  BEAT 20 / BEAT STREET 20 BESAR BIRU DOFF	\N	0	HONDA	247000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	247000.00	HON-COV-2290	2026-06-18 17:47:31.403	\N
d0dea398-de09-4514-bfaf-2f0f7d8df57e	COVER BODY/ BODY SAMPING  BEAT 20 / BEAT STREET 20 BESAR HIJAU DOFF	\N	0	HONDA	247000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	247000.00	HON-COV-2291	2026-06-18 17:47:31.403	\N
cmlg445jy000sx6ttpzps66p7	COMPLETE SET BODY MIO BIRU MUDA METALIK/TELUR ASIN	\N	0	YAMAHA	678000.00	COMPLETE SET BODY (YAMAHA)	2026-02-10 04:40:07.573	BODY PART	681000.00	YAM-BOD-COM-7	2026-02-10 04:40:07.573	01D1935048AA1
cmlezx8nv01bg39t5lfvvx9po	MIKA SPEEDOMETER VARIO 110 FI	\N	0	HONDA	26000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	41000.00	HON-MIK-MIK-841	2026-06-18 17:19:42.083	\N
cmlg446ub0016x6tt3ecccvib	LEGSHIELD LUAR/ SAYAP LUAR N-MAX BESAR BIRU	\N	0	YAMAHA	229000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	232000.00	YAM-BOD-LEG-43	2026-02-10 04:40:07.575	01D4231860AA1
cmlg44bmm004qx6ttt79gt1zg	COVER BODY/BODY SAMPING N-MAX BESAR HITAM	\N	0	YAMAHA	198000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.142	BODY PART	201000.00	YAM-BOD-COV-101	2026-02-10 04:40:18.142	01D4232740AA1
7f7ea459-dab4-4005-afa0-3e0f0cac11f7	COVER BODY/ BODY SAMPING  CB 150 R NEW HITAM	\N	0	HONDA	178000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	178000.00	HON-COV-2292	2026-06-18 17:47:31.403	\N
cmlezx6xo018239t59o8rip2m	MIKA LAMPU SCOOPY 20	\N	0	HONDA	136000.00	MIKA LAMPU (HONDA)	2026-02-09 09:54:56.89	KELISTRIKAN	153000.00	HON-MIK-MIK-800	2026-06-18 17:27:37.767	\N
cmlezx9fd01dg39t5pmn57fig	MIKA SPEEDOMETER SPACY	\N	0	HONDA	25000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	26000.00	HON-MIK-MIK-861	2026-06-18 17:19:42.083	\N
cmlezx7g0018m39t55oof07wk	MIKA LAMPU CB 150 VERZA	\N	0	HONDA	92000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	105000.00	HON-MIK-MIK-813	2026-06-18 17:27:37.767	\N
b22a7de4-ad1f-4059-9d2f-bede3a25ce3f	COVER BODY/ BODY SAMPING  CB 150 R NEW MERAH	\N	0	HONDA	192000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	192000.00	HON-COV-2293	2026-06-18 17:47:31.403	\N
97580f61-fa2d-4702-9729-8d1f3b94bc98	COVER BODY/ BODY SAMPING  CB 150 R NEW PUTIH	\N	0	HONDA	192000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	192000.00	HON-COV-2294	2026-06-18 17:47:31.403	\N
2a9a1426-7928-4956-9daa-3846a97d2c4b	COVER BODY/ BODY SAMPING  SCOOPY FI / SCOOPY FI ESP HITAM	\N	0	HONDA	227000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	227000.00	HON-COV-2295	2026-06-18 17:47:31.403	\N
cmlg444yf000mx6ttulnvvraq	REAR HANDLE COVER /BATOK BELAKANG MIO J	\N	0	YAMAHA	25000.00	REAR HANDLE COVER /BATOK BELAKANG(YAMAHA)	2026-02-10 04:40:07.574	BODY PART	29000.00	YAM-BOD-REA-24	2026-06-19 22:06:44.135	01D3030182AA1
cmlg447ma001sx6ttu3wj5e7c	LEGSHIELD LUAR/ SAYAP LUAR MIO J HITAM	\N	0	YAMAHA	67000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	70000.00	YAM-BOD-LEG-47	2026-06-19 22:06:44.266	01D3031840AA1
cmlg446xc001ax6ttvuha313a	LEGSHIELD LUAR/ SAYAP LUAR MIO J PUTIH	\N	0	YAMAHA	71000.00	LEGSHIELD LUAR/ SAYAP LUAR(YAMAHA)	2026-02-10 04:40:07.575	BODY PART	74000.00	YAM-BOD-LEG-49	2026-06-19 22:06:44.397	01D3031847AA1
cmlg44etb0088x6ttk6p6lkyw	COVER BODY/BODY SAMPING MIO SOUL PUTIH	\N	0	YAMAHA	154000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	159000.00	YAM-BOD-COV-117	2026-06-19 22:06:44.528	01D2632747AA1
cmlg44cct005ix6ttymop5ys6	COVER BODY/BODY SAMPING MIO PUTIH + COVER STOP	\N	0	YAMAHA	153000.00	COVER BODY/BODY SAMPING (YAMAHA)	2026-02-10 04:40:18.144	BODY PART	157000.00	YAM-BOD-COV-120	2026-06-19 22:06:44.66	01D1934447AA1
cmlg44ees007rx6ttcpxlfalv	FRONT FENDER/SPAKBOR DEPAN MIO M3 MERAH MAROON	\N	0	YAMAHA	89000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.145	BODY PART	92000.00	YAM-BOD-FRO-178	2026-06-19 22:06:44.789	01D4030752AA1
cmlg4395o0027pv85fz82y1zu	FRONT FENDER/SPAKBOR DEPAN N-MAX PUTIH	\N	0	YAMAHA	99000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	103000.00	YAM-BOD-FRO-260	2026-02-10 04:39:23.839	01D4230747AA1
cmlg43bg80054pv85sxfbrq1o	REAR FENDER/SPAKBOR BELAKANG MIO 08	\N	0	YAMAHA	58000.00	REAR FENDER/SPAKBOR BELAKANG (YAMAHA)	2026-02-10 04:39:23.841	BODY PART	63000.00	YAM-BOD-REA-290	2026-02-10 04:39:23.841	01D2433282AA1
cmlg43d82005ipv85xtynn7ae	PANEL MIO GT HITAM	\N	0	YAMAHA	79000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.554	BODY PART	82000.00	YAM-BOD-PAN-304	2026-02-10 04:39:33.554	01D3830540AA1
cmlezxa1a01ec39t50s1el49f	MIKA SEN Fr / MIKA SEN DEPAN  GRAND (P/P)	\N	0	HONDA	26000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	94000.00	HON-MIK-MIK-915	2026-02-09 09:55:04.847	\N
cmlezxaai01eh39t58pf76u10	MIKA SEN Rr / MIKA SEN BELAKANG LEGENDA 2 (P) KO	\N	0	HONDA	18000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	46000.00	HON-MIK-MIK-917	2026-02-09 09:55:04.847	\N
f35d97a8-153f-4447-829a-d7e151c140ef	COVER BODY/ BODY SAMPING  SCOOPY FI / SCOOPY FI ESP KREM	\N	0	HONDA	255000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	255000.00	HON-COV-2296	2026-06-18 17:47:31.403	\N
cmlezxaqy01fg39t572wgdiex	MIKA STOP / MIKA BELAKANG BEAT	\N	0	HONDA	42000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	170000.00	HON-MIK-MIK-927	2026-02-09 09:55:04.847	\N
cmlezxay301fu39t5vd8kuw6w	MIKA SEN Rr / MIKA SEN BELAKANG + STOP SMASH (P/M) KO	\N	0	HONDA	28000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	79000.00	HON-MIK-MIK-912	2026-02-09 09:55:04.847	\N
cmlezxb4k01ga39t5tp0h3ezy	MIKA STOP / MIKA BELAKANG SCOOPY (M)	\N	0	HONDA	29000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	30000.00	HON-MIK-MIK-936	2026-02-09 09:55:04.847	\N
181853e9-9a6b-411c-bf45-0694c8c09cdf	COVER BODY/ BODY SAMPING  SCOOPY FI / SCOOPY FI ESP MERAH	\N	0	HONDA	255000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	255000.00	HON-COV-2297	2026-06-18 17:47:31.403	\N
cmlezxbb801gs39t5wzyjcqpo	MIKA STOP / MIKA BELAKANG BEAT 20 SMOKE	\N	0	HONDA	33000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	38000.00	HON-MIK-MIK-929	2026-02-09 09:55:04.847	\N
a47a913d-fac5-49dc-b695-8e93a5de9887	COVER BODY/ BODY SAMPING  SCOOPY FI / SCOOPY FI ESP MERAH MAROON	\N	0	HONDA	255000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	255000.00	HON-COV-2298	2026-06-18 17:47:31.403	\N
cmlezxbij01ha39t517eaxv00	FRONT WINKER / SEN DEPAN UNIT VARIO TECHNO	\N	0	HONDA	107000.00	FRONT WINKER / SEN DEPAN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	82000.00	HON-FRO-FRO-969	2026-02-09 09:55:04.847	\N
cmlezxbp801hw39t5yijde3ri	FRONT WINKER / SEN DEPAN UNIT KARISMA	\N	0	HONDA	50000.00	FRONT WINKER / SEN DEPAN (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	82000.00	HON-FRO-FRO-977	2026-02-09 09:55:04.848	\N
cmlg43dib0062pv85w85gwvee	PANEL MIO J PUTIH	\N	0	YAMAHA	95000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.555	BODY PART	98000.00	YAM-BOD-PAN-307	2026-06-19 22:06:45.055	01D3030547AA1
cmlg43dp7006apv85p4arufwq	PANEL MIO 08 HITAM	\N	0	YAMAHA	93000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.555	BODY PART	96000.00	YAM-BOD-PAN-310	2026-06-19 22:06:45.189	01D2430540AA1
cmlg43egi007ypv85ybsl7icu	PANEL MIO 08 HIJAU	\N	0	YAMAHA	110000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	113000.00	YAM-BOD-PAN-312	2026-06-19 22:06:45.322	01D2430559AA1
cmlg43etd008qpv85313wfny9	PANEL MIO 08 MERAH MAROON	\N	0	YAMAHA	110000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	114000.00	YAM-BOD-PAN-313	2026-06-19 22:06:45.679	01D2430552AA1
cmlg43d82005spv8544iulqgn	PANEL MIO SOUL HITAM	\N	0	YAMAHA	140000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.555	BODY PART	143000.00	YAM-BOD-PAN-315	2026-06-19 22:06:45.809	01D2630540AA1
cmlg43dji0064pv85287bqchn	PANEL MIO HITAM	\N	0	YAMAHA	77000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.555	BODY PART	81000.00	YAM-BOD-PAN-319	2026-06-19 22:06:45.941	01D1930540AA1
cmlg43ede007mpv85xdhdamqx	PANEL DEPAN BAGIAN BAWAH MIO 08	\N	0	YAMAHA	54000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	57000.00	YAM-BOD-PAN-370	2026-06-19 22:06:46.076	01D2435182AA1
cmlg43exq0092pv858eflu7z2	PANEL DEPAN BAGIAN BAWAH N-MAX	\N	0	YAMAHA	71000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	74000.00	YAM-BOD-PAN-372	2026-06-19 22:06:46.667	01D4235182AA1
cmlg43enn008gpv85rg3wi8t7	FRONT HANDLE COVER/ BATOK DEPAN MIO 08 HITAM	\N	0	YAMAHA	51000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	54000.00	YAM-BOD-FRO-382	2026-06-19 22:06:47.075	01D2430040AA1
cmlg43ex50090pv85dhm1jz9k	FRONT HANDLE COVER/ BATOK DEPAN MIO 08 PUTIH	\N	0	YAMAHA	62000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	65000.00	YAM-BOD-FRO-385	2026-06-19 22:06:47.341	01D2430047AA1
cmlg43eu2008wpv85r6oqfhu3	FRONT HANDLE COVER/ BATOK DEPAN MIO SOUL HITAM	\N	0	YAMAHA	51000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	54000.00	YAM-BOD-FRO-386	2026-06-19 22:06:47.478	01D2630040AA1
cmlg43gnd00bupv85aymnyfxi	MIKA LAMPU MIO 08	\N	0	YAMAHA	44000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	47000.00	YAM-KEL-MIK-437	2026-06-19 22:06:47.621	01D2400100AA3
cmlg43gsl00c4pv85rzsgysdc	MIKA LAMPU MIO	\N	0	YAMAHA	40000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	43000.00	YAM-KEL-MIK-439	2026-06-19 22:06:47.755	01D1900100AA1
cmlg43h1200cqpv85kgwczlt9	MIKA LAMPU FAZZIO	\N	0	YAMAHA	112000.00	MIKA LAMPU (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	115000.00	YAM-KEL-MIK-460	2026-06-19 22:06:47.886	01D5000100AA8
cmlg43heo00dlpv85s9lhiqqy	MIKA SEN Fr / MIKA SEN DEPAN  N-MAX	\N	0	YAMAHA	52000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.654	KELISTRIKAN	55000.00	YAM-KEL-MIK-473	2026-06-19 22:06:48.244	01D4200700AA1
cmlg43hlt00dypv85482aion8	MIKA SEN Rr / MIKA SEN BELAKANG  + STOP N-MAX (M/P)	\N	0	YAMAHA	117000.00	MIKA SEN (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	120000.00	YAM-KEL-MIK-475	2026-06-19 22:06:48.378	01D4802400AA1
cmlg43iem00fcpv85d4qbk4xu	MIKA SPEEDOMETER MIO M3	\N	0	YAMAHA	28000.00	MIKA SPEEDOMETER (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	31000.00	YAM-KEL-MIK-492	2026-06-19 22:06:48.517	01D4001700AA8
cmlg43ifa00fepv85v38bf9xk	MIKA SPEEDOMETER MIO J	\N	0	YAMAHA	21000.00	MIKA SPEEDOMETER (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	24000.00	YAM-KEL-MIK-494	2026-06-19 22:06:48.659	01D3001782AA6
cmlg43im900fjpv852w8pi70o	MIKA SPEEDOMETER MIO SOUL	\N	0	YAMAHA	27000.00	MIKA SPEEDOMETER (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	30000.00	YAM-KEL-MIK-496	2026-06-19 22:06:48.791	01D2601700AA4
cmlg43irl00fupv8541kyxdly	MIKA SPEEDOMETER MIO	\N	0	YAMAHA	24000.00	MIKA SPEEDOMETER (YAMAHA)	2026-02-10 04:39:37.655	KELISTRIKAN	27000.00	YAM-KEL-MIK-497	2026-06-19 22:06:49.93	01D1901700AA10
cmlg43mat00l4pv85amd9g8cr	STOP LAMP ASSY / LAMPU STOP JUPITER (P/M)	\N	0	YAMAHA	0.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	96000.00	YAM-KEL-STO-594	2026-06-19 22:06:50.068	01D1303020AA1
cmlg43mbu00l6pv85l4goqo7r	STOP LAMP ASSY / LAMPU STOP JUPITER Z 06	\N	0	YAMAHA	90000.00	STAY LAMPU DEPAN (YAMAHA)	2026-02-10 04:39:42.092	KELISTRIKAN	93000.00	YAM-KEL-STO-595	2026-06-19 22:06:50.203	01D2303020AA1
cmlezwgzf002c39t5lq7b0m38	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY FI ESP HITAM	\N	0	HONDA	211000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	227000.00	HON-COV-COV-65	2026-06-19 22:06:50.34	01B4332740AA1
cmlezxbvc01ic39t595igjvcr	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT CB 150 R NEW / HONDA ADV 150 + LED	\N	0	HONDA	100000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	429000.00	HON-FRO-FRO-980	2026-02-09 09:55:04.848	\N
cmlezx8pz01bq39t5cf86wf24	MIKA SPEEDOMETER VARIO TECHNO	\N	0	HONDA	28000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	33000.00	HON-MIK-MIK-842	2026-06-18 17:27:37.767	\N
cmlezxc0t01iq39t5j4tq6pkf	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT BLADE 11	\N	0	HONDA	150000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	429000.00	HON-FRO-FRO-987	2026-02-09 09:55:04.848	\N
e45b6593-9e6d-48f8-a7cd-079aa3715c8f	COVER BODY/ BODY SAMPING  SCOOPY FI / SCOOPY FI ESP PUTIH	\N	0	HONDA	255000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	255000.00	HON-COV-2299	2026-06-18 17:47:31.403	\N
cmlezxd7901l339t5m9wii2yg	COB LAMPU / FITTING LAMPU (HONDA)	\N	0	HONDA	0.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	29000.00	HON-STO-COB-1047	2026-02-09 09:55:08.265	\N
417e2e76-80fd-40eb-817b-9410bfd634ff	COVER BODY/ BODY SAMPING  VERZA HITAM	\N	0	HONDA	145000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	145000.00	HON-COV-2300	2026-06-18 17:47:31.403	\N
cmlezxde901li39t5zfxj9dmb	COB LAMPU / FITTING LAMPU TIGER REVOLUTION	\N	0	HONDA	11000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	12600.00	HON-STO-COB-1064	2026-02-09 09:55:08.265	\N
cmlezxdk801m639t5c9mivtqs	COB LAMPU / FITTING LAMPU BLADE	\N	0	HONDA	10000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	17100.00	HON-STO-COB-1069	2026-02-09 09:55:08.265	\N
cmlezxf6501pq39t5u4zr6pat	LEGSHIELD DALAM / SAYAP DALAM (HONDA)	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	111000.00	HON-LEG-LEG-1132	2026-02-09 09:55:11.246	\N
cmlezwhlh003k39t5p1twepx6	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY FI 17 HITAM	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	284000.00	HON-COV-COV-71	2026-02-09 09:54:25.62	01B4832740AA1
cmlezwi2c004a39t5j6w1jnq0	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY FI 17 PUTIH	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	241000.00	HON-COV-COV-73	2026-02-09 09:54:25.62	01B4832747AA1
cmlezxfim01qk39t5jta2chch	LEGSHIELD DALAM / SAYAP DALAM KARISMA X BIRU	\N	0	HONDA	220000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	111000.00	HON-LEG-LEG-1149	2026-02-09 09:55:11.246	\N
418df5e4-64cc-4b3b-a618-aa9e82b75a4a	COVER BODY/ BODY SAMPING  BEAT FI / BEAT FI ESP HITAM	\N	0	HONDA	185000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	185000.00	HON-COV-2301	2026-06-18 17:47:31.403	\N
cmlezwgf0000y39t52qdp4pf0	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 KECIL	\N	0	HONDA	87000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	90000.00	HON-COV-COV-35	2026-06-19 22:06:50.608	01B3632582AA1
cmlezwgho001639t5ofbk970k	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO MERAH MAROON	\N	0	HONDA	151000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	154000.00	HON-COV-COV-37	2026-06-19 22:06:50.741	01B2932755AA1
cmlezwgpo001q39t5cs1g5q1v	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO MERAH MAROON	\N	0	HONDA	209000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	212000.00	HON-COV-COV-40	2026-06-19 22:06:50.874	01B2232752AA1
cmlezwgkk001a39t55rnnkjcq	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO PINK	\N	0	HONDA	214000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	217000.00	HON-COV-COV-41	2026-06-19 22:06:51.006	01B2232751AA1
cmlezwgm7001g39t5b1bl37nw	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO PUTIH	\N	0	HONDA	208000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	211000.00	HON-COV-COV-42	2026-06-19 22:06:51.138	01B2232747AA1
cmlezwgwn002639t579tvy10h	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO 150 125 BESAR MERAH MAROON	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	329000.00	HON-COV-COV-44	2026-06-19 22:06:51.275	01B4432752AA1
cmlezwgsg001w39t5k3llka1s	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO 150 18 BESAR PUTIH	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	321000.00	HON-COV-COV-48	2026-06-19 22:06:51.409	01B5232747AA1
cmlezwgyp002a39t5fztcyegh	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO 150 18 BESAR SILVER	\N	0	HONDA	316000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	319000.00	HON-COV-COV-49	2026-06-19 22:06:51.541	01B5232742AA1
cmlezwgv3002239t5osnbdfak	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO 110 FI PUTIH	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	223000.00	HON-COV-COV-55	2026-06-19 22:06:51.68	01B4232747AA1
cmlezwhed003539t5hrtbbw3w	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY FI 17 MERAH DOFF	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	341000.00	HON-COV-COV-70	2026-06-19 22:06:51.81	01B4832787AA1
cmlezwhvb003w39t5zwhjxre2	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY FI 17 KREM	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	345000.00	HON-COV-COV-72	2026-06-19 22:06:51.942	01B4832783AA1
cmlezwhl2003g39t5cibzomc4	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY FI 17 GRAY DOFF	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	341000.00	HON-COV-COV-74	2026-06-19 22:06:52.537	01B4832786AA1
cmlezwhuo003s39t5ij246iwq	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY FI R / L HITAM	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	214000.00	HON-COV-COV-75	2026-06-19 22:06:52.699	01B4331840AA1
cmlezwi8o004l39t5b7vgu6k9	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY FI / ESP KREM	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	262000.00	HON-COV-COV-77	2026-06-19 22:06:52.831	01B4331883AA1
cmlezwhl2003i39t517rnpjyp	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY FI R / L PUTIH	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	244000.00	HON-COV-COV-78	2026-06-19 22:06:53.195	01B4331847AA1
cmlezwhvq004039t5vqq8fhm2	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY FI ESP BIRU	\N	0	HONDA	243000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	261000.00	HON-COV-COV-84	2026-06-19 22:06:53.328	01B4332774AA1
cmlezwhvb003x39t5pvrcidit	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY FI R / L BIRU	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	269000.00	HON-COV-COV-80	2026-06-19 22:06:53.712	01B4331874AA1
cmlezx9bu01d839t597u63p4i	MIKA SPEEDOMETER BLADE 11	\N	0	HONDA	27000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	36000.00	HON-MIK-MIK-860	2026-02-09 09:55:01.49	\N
cmlezxa1a01e739t5cptnd3ym	MIKA SEN Fr / MIKA SEN DEPAN  SUPRA FIT NEW KO	\N	0	HONDA	27000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	94000.00	HON-MIK-MIK-908	2026-02-09 09:55:04.847	\N
cmlezxabt01es39t51mwax6gp	MIKA SEN Fr / MIKA SEN DEPAN  SUPRA DE BAUT DEPAN (P) KO	\N	0	HONDA	20000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	94000.00	HON-MIK-MIK-910	2026-02-09 09:55:04.847	\N
cmlezxalu01f439t5kpdidv93	MIKA STOP / MIKA BELAKANG ABSOLUTE REVO	\N	0	HONDA	44000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	30000.00	HON-MIK-MIK-947	2026-02-09 09:55:04.847	\N
5723ac88-85a9-47f0-821a-af25c7d39870	COVER BODY/ BODY SAMPING  BEAT FI / BEAT FI ESP MERAH MAROON	\N	0	HONDA	206000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	206000.00	HON-COV-2302	2026-06-18 17:47:31.403	\N
96f380f8-a9c3-4539-99bd-5c591e844b00	COVER BODY/ BODY SAMPING  BEAT FI / BEAT FI ESP PUTIH	\N	0	HONDA	200000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	200000.00	HON-COV-2303	2026-06-18 17:47:31.403	\N
cmlezxbcm01gx39t568qd5lq3	MIKA STOP / MIKA BELAKANG LEGENDA 2 (M) KO	\N	0	HONDA	21000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	30000.00	HON-MIK-MIK-955	2026-02-09 09:55:04.847	\N
cmlezxbqa01i039t52ma8vlga	MIKA SEN Rr / MIKA SEN BELAKANG + STOP SUPRA X 125 (P/M) KO	\N	0	HONDA	38000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	79000.00	HON-MIK-MIK-907	2026-02-09 09:55:04.848	\N
47521fd9-0114-4878-aac9-f448583d4e66	COVER BODY/ BODY SAMPING  CB 150 R HITAM	\N	0	HONDA	183000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	183000.00	HON-COV-2304	2026-06-18 17:47:31.403	\N
443cc1f9-c989-451e-be85-61d927e6c001	COVER BODY/ BODY SAMPING  CB 150 R MERAH	\N	0	HONDA	204000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	204000.00	HON-COV-2305	2026-06-18 17:47:31.403	\N
912783a0-3956-4d3b-a101-c77645e625ce	COVER BODY/ BODY SAMPING  CB 150 R PUTIH	\N	0	HONDA	204000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	204000.00	HON-COV-2306	2026-06-18 17:47:31.403	\N
730611bf-3786-4e8f-b833-baa7a08bef2b	SWITCH REM DEPAN ALL MATIC YAMAHA	\N	0	YAMAHA	15000.00	SWITCH REM	2026-06-18 17:27:37.767	KELISTRIKAN	15000.00	YAM-SWI-6	2026-06-18 17:34:05.97	\N
06c94b5f-1b9a-4e23-bf66-af340fa694b3	SWITCH REM BELAKANG YAMAHA / RXS	\N	0	YAMAHA	15000.00	SWITCH REM	2026-06-18 17:27:37.767	KELISTRIKAN	15000.00	YAM-SWI-7	2026-06-18 17:34:05.97	\N
cmlezx7vj019q39t5hsno0ola	MIKA SPEEDOMETER SUPRA FIT NEW + INNER	\N	0	HONDA	28000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	33000.00	HON-MIK-MIK-855	2026-06-18 17:22:17.168	\N
cmlezxe1u01nc39t5bxwotath	COB LAMPU / FITTING LAMPU SUPRA X 125 HELM IN	\N	0	HONDA	16000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.266	KELISTRIKAN	20000.00	HON-STO-COB-1061	2026-06-18 17:22:17.168	\N
ea6e4da4-2b89-4071-9b1d-8e9beb33faf0	COVER BODY/ BODY SAMPING  BEAT / BEAT 10 HITAM	\N	0	HONDA	161000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	161000.00	HON-COV-2307	2026-06-18 17:47:31.403	\N
cmlezxbwm01ig39t5ie93a2l5	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT SUPRA X (P)	\N	0	HONDA	61000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	429000.00	HON-FRO-FRO-983	2026-02-09 09:55:04.848	\N
cmlezxedk01o639t5f8nfw07m	COB LAMPU / FITTING LAMPU REVO	\N	0	HONDA	11000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.266	KELISTRIKAN	17100.00	HON-STO-COB-1062	2026-02-09 09:55:08.266	\N
cmlezwi3r004e39t5gw9336k8	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY VIOLET	\N	0	HONDA	174000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	177000.00	HON-COV-COV-82	2026-06-19 22:06:53.974	01B3132761AA1
cmlezwi4f004i39t50r533w8c	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SUPRA X 125 07 HITAM + COVER STOP	\N	0	HONDA	210000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	213000.00	HON-COV-COV-87	2026-06-19 22:06:54.12	01B2534440AA1
cmlezwi3r004f39t50rd51ahp	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SUPRA X 125 14 HITAM	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	213000.00	HON-COV-COV-89	2026-06-19 22:06:54.251	01B4132740AA1
cmlezwi8o004k39t5ucp5o8qf	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SUPRA X 125 KECIL HITAM	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	99000.00	HON-COV-COV-90	2026-06-19 22:06:54.382	01B2032540AA1
cmlezwiap004o39t5ac3xjz3g	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SUPRA FIT NEW S HITAM	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	193000.00	HON-COV-COV-92	2026-06-19 22:06:54.766	01B2134440AA1
cmlezwill005839t5ehxgeq7n	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI ABSOLUTE REVO FIT BESAR HITAM	\N	0	HONDA	152000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	156000.00	HON-COV-COV-99	2026-06-19 22:06:54.892	01B3732640AA1
cmlezwjtv005l39t56bxyqdko	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI ABSOLUTE REVO FIT KECIL HITAM PU	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.883	BODY PART	36000.00	HON-COV-COV-102	2026-06-19 22:06:55.03	01B3732582AA1
cmlezwjtv005u39t51xcwe0e7	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI ABSOLUTE REVO KECIL HITAM	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.883	BODY PART	62000.00	HON-COV-COV-103	2026-06-19 22:06:55.166	01B2832540AA1
cmlezwkud007r39t5147gm6z8	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI REVO FI HITAM	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.884	BODY PART	251000.00	HON-COV-COV-108	2026-06-19 22:06:55.295	01B3932740AA1
cmlezwk06006239t5xr06c8li	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI REVO HITAM + COVER STOP	\N	0	HONDA	190000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.884	BODY PART	193000.00	HON-COV-COV-104	2026-06-19 22:06:55.428	01B2434440AA1
cmlezwk6j006i39t5dq34kcf0	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI REVO HITAM + COVER STOP	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.884	BODY PART	196000.00	HON-COV-COV-110	2026-06-19 22:06:55.555	01B2434440AA1
cmlezwkxq007y39t5rjfsnopm	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI GRAND HITAM + COVER STOP + DASI	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.884	BODY PART	111000.00	HON-COV-COV-123	2026-06-19 22:06:55.827	01B0834440AA1
cmlezwl87008i39t51hxkig4s	COVER BODY / TUTUP RANGKA KANAN KIRI VARIO 150 125 KECIL	\N	0	HONDA	78000.00	COVER BODY / TUTUP RANGKA KANAN KIRI	2026-02-09 09:54:30.884	BODY PART	81000.00	HON-COV-COV-124	2026-06-19 22:06:56.192	01B4432582AA1
cmlezwkyt008039t50x3vacqm	FRONT FENDER / SPAKBOR DEPAN  VARIO 150 HITAM	\N	0	HONDA	86000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	89000.00	HON-FRO-FRO-167	2026-06-19 22:06:56.32	01B3630740AA1
617ff0c9-9be7-4f31-a83a-631e59d19241	COVER BODY/ BODY SAMPING  BEAT / BEAT 10 BIRU TUA	\N	0	HONDA	183000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	183000.00	HON-COV-2308	2026-06-18 17:47:31.403	\N
4410fd4e-1db1-41b0-94b0-62ea4a2871ec	COVER BODY/ BODY SAMPING  BEAT / BEAT 10 MERAH MAROON	\N	0	HONDA	186000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	186000.00	HON-COV-2309	2026-06-18 17:47:31.403	\N
2c1fc752-55d1-47fa-b88c-ff47cd0f6025	COVER BODY/ BODY SAMPING  BEAT / BEAT 10 PINK	\N	0	HONDA	183000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	183000.00	HON-COV-2310	2026-06-18 17:47:31.403	\N
88cd3516-d621-4630-9af2-2d0228755fd6	COVER BODY/ BODY SAMPING  BEAT / BEAT 10 PUTIH	\N	0	HONDA	192000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	192000.00	HON-COV-2311	2026-06-18 17:47:31.403	\N
cmlezx9lz01ds39t5f7nwqhv9	MIKA LAMPU CB 150 R	\N	0	HONDA	123000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	136000.00	HON-MIK-MIK-814	2026-06-18 17:27:37.767	\N
cmlezx8fn01as39t52y5bpi5z	MIKA SPEEDOMETER REVO + OUTTER	\N	0	HONDA	29000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	34000.00	HON-MIK-MIK-850	2026-06-18 17:27:37.767	\N
569d1c12-351d-4ff3-889b-12f04c86be03	COVER BODY/ BODY SAMPING  SUPRA / SUPRA X / SUPRA XX / SUPRA FIT HITAM + COVER STOP	\N	0	HONDA	182000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	182000.00	HON-COV-2312	2026-06-18 17:47:31.403	\N
d5890b3b-c4a7-4507-85b6-6ec51e1b74f7	FRONT FENDER / SPAKBOR DEPAN A VARIO 160 HITAM	\N	0	HONDA	141000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	141000.00	HON-FRO-2313	2026-06-18 17:47:31.403	\N
1ee018c4-8b57-4916-9378-612ff3671e46	FRONT FENDER / SPAKBOR DEPAN A VARIO 160 HITAM DOFF	\N	0	HONDA	158000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	158000.00	HON-FRO-2314	2026-06-18 17:47:31.403	\N
d5fafaa2-6abd-45d1-ba9f-6b381f6686e7	FRONT FENDER / SPAKBOR DEPAN A VARIO 160 MERAH DOFF	\N	0	HONDA	158000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	158000.00	HON-FRO-2315	2026-06-18 17:47:31.403	\N
413d4408-5df2-4632-a56f-8ba6a8c82649	FRONT FENDER / SPAKBOR DEPAN A VARIO 160 PUTIH DOFF	\N	0	HONDA	158000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	158000.00	HON-FRO-2316	2026-06-18 17:47:31.403	\N
f5204323-b715-430c-a973-66a7ee9d2538	FRONT FENDER / SPAKBOR DEPAN PCX 160 / PCX 160 2025 HITAM	\N	0	HONDA	141000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	141000.00	HON-FRO-2317	2026-06-18 17:47:31.403	\N
d1acca14-b581-4742-a228-73ee909a879a	FRONT FENDER / SPAKBOR DEPAN PCX 160 / PCX 160 2025 MERAH DOFF	\N	0	HONDA	167000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	167000.00	HON-FRO-2318	2026-06-18 17:47:31.403	\N
4650c73a-6cd8-468b-9019-1fe02d751c1b	FRONT FENDER / SPAKBOR DEPAN PCX 160 / PCX 160 2025 PUTIH	\N	0	HONDA	167000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	167000.00	HON-FRO-2319	2026-06-18 17:47:31.403	\N
b2f292f4-bfd1-4c63-aa09-9aa63f4b0d17	FRONT FENDER / SPAKBOR DEPAN SCOOPY 20 / SCOOPY 24 HITAM	\N	0	HONDA	146000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	146000.00	HON-FRO-2320	2026-06-18 17:47:31.403	\N
3ef5bad6-4952-4660-94a1-1bc64b642a0e	FRONT FENDER / SPAKBOR DEPAN SCOOPY 20 / SCOOPY 24 KREM	\N	0	HONDA	162000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	162000.00	HON-FRO-2321	2026-06-18 17:47:31.403	\N
eefd8e76-c757-4708-b733-114a0a6da426	FRONT FENDER / SPAKBOR DEPAN SCOOPY 20 / SCOOPY 24 MERAH	\N	0	HONDA	162000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	162000.00	HON-FRO-2322	2026-06-18 17:47:31.403	\N
a88c8cbc-2ab0-43df-a4cd-30e4033da18c	FRONT FENDER / SPAKBOR DEPAN NINJA 250 KARBU HITAM	\N	0	KAWASAKI	79000.00	FRONT FENDER	2026-06-18 17:27:37.767	BODY PART	79000.00	KAW-FRO-1	2026-06-18 17:27:37.767	\N
46ca1866-541d-4c7f-a8fd-28da9e031712	FRONT FENDER / SPAKBOR DEPAN  NINJA HITAM	\N	0	KAWASAKI	82000.00	FRONT FENDER	2026-06-18 17:27:37.767	BODY PART	82000.00	KAW-FRO-2	2026-06-18 17:27:37.767	\N
ecfd0448-964d-4db8-a802-b0e9edb9c886	FRONT FENDER / SPAKBOR DEPAN  NINJA BIRU	\N	0	KAWASAKI	99000.00	FRONT FENDER	2026-06-18 17:27:37.767	BODY PART	99000.00	KAW-FRO-3	2026-06-18 17:27:37.767	\N
399eadfd-8b99-479c-bd29-825e4873b7e0	FRONT FENDER / SPAKBOR DEPAN  NINJA HIJAU	\N	0	KAWASAKI	99000.00	FRONT FENDER	2026-06-18 17:27:37.767	BODY PART	99000.00	KAW-FRO-4	2026-06-18 17:27:37.767	\N
509e91bc-2f08-4971-a271-c6c357119dbc	FRONT FENDER / SPAKBOR DEPAN  NINJA KUNING	\N	0	KAWASAKI	104000.00	FRONT FENDER	2026-06-18 17:27:37.767	BODY PART	104000.00	KAW-FRO-5	2026-06-18 17:27:37.767	\N
3ed1b578-057c-47f3-8162-e26e1945710c	FRONT FENDER / SPAKBOR DEPAN  NINJA MERAH	\N	0	KAWASAKI	99000.00	FRONT FENDER	2026-06-18 17:27:37.767	BODY PART	99000.00	KAW-FRO-6	2026-06-18 17:27:37.767	\N
e6b8f53a-7b3a-4193-bdc5-4c90eee13d44	FRONT FENDER / SPAKBOR DEPAN  NINJA MERAH MAROON	\N	0	KAWASAKI	98000.00	FRONT FENDER	2026-06-18 17:27:37.767	BODY PART	98000.00	KAW-FRO-7	2026-06-18 17:27:37.767	\N
7a5a0cac-4505-4108-896b-0ee7d8a85ad6	FRONT FENDER / SPAKBOR DEPAN  NINJA PUTIH	\N	0	KAWASAKI	99000.00	FRONT FENDER	2026-06-18 17:27:37.767	BODY PART	99000.00	KAW-FRO-8	2026-06-18 17:27:37.767	\N
78f3a90b-b9e5-4307-9009-fc878f117298	FRONT FENDER / SPAKBOR DEPAN SCOOPY 20 / SCOOPY 24 BIRU DOFF	\N	0	HONDA	162000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	162000.00	HON-FRO-2323	2026-06-18 17:47:31.403	\N
fc55ea7e-0480-41d3-8940-9417b2039593	FRONT FENDER / SPAKBOR DEPAN SCOOPY 20 / SCOOPY 24 MERAH DOFF	\N	0	HONDA	162000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	162000.00	HON-FRO-2324	2026-06-18 17:47:31.403	\N
3eb1c8bc-af6f-487e-b845-3fa20b06184e	FRONT FENDER / SPAKBOR DEPAN SCOOPY 20 / SCOOPY 24 PUTIH DOFF	\N	0	HONDA	162000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	162000.00	HON-FRO-2325	2026-06-18 17:47:31.403	\N
1cf40429-11eb-4978-a35e-6b3c17877ca5	FRONT FENDER / SPAKBOR DEPAN BEAT 20 / BEAT STREET 20 HITAM	\N	0	HONDA	83000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	83000.00	HON-FRO-2326	2026-06-18 17:47:31.403	\N
9713f9ae-e24a-4e38-9a19-0547eae02ec1	FRONT FENDER / SPAKBOR DEPAN BEAT 20 / BEAT STREET 20 HITAM DOFF	\N	0	HONDA	100000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	100000.00	HON-FRO-2327	2026-06-18 17:47:31.403	\N
721c21af-0c83-4b2d-b9ff-628800a23249	FRONT FENDER / SPAKBOR DEPAN BEAT 20 / BEAT STREET 20 BIRU DOFF	\N	0	HONDA	91000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	91000.00	HON-FRO-2328	2026-06-18 17:47:31.403	\N
44ce0696-16b9-48be-8306-1b8826cfb140	FRONT FENDER / SPAKBOR DEPAN BEAT 20 / BEAT STREET 20 HIJAU DOFF	\N	0	HONDA	91000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	91000.00	HON-FRO-2329	2026-06-18 17:47:31.403	\N
cmlezxasi01fm39t5ox51g1ig	MIKA STOP / MIKA BELAKANG GL PRO KO	\N	0	HONDA	38000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	38000.00	HON-MIK-MIK-951	2026-06-18 17:22:17.168	\N
d17117e0-62b1-4e9a-b011-31d3682ac515	FRONT FENDER / SPAKBOR DEPAN BEAT 20 / BEAT STREET 20 PUTIH	\N	0	HONDA	100000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	100000.00	HON-FRO-2330	2026-06-18 17:47:31.403	\N
93f99da7-9178-446d-899a-90206ce4d19a	FRONT FENDER / SPAKBOR DEPAN ADV 150 HITAM	\N	0	HONDA	123000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	123000.00	HON-FRO-2331	2026-06-18 17:47:31.403	\N
cmlezx801019t39t560zmbecs	MIKA SPEEDOMETER GRAND	\N	0	HONDA	27000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	26000.00	HON-MIK-MIK-862	2026-06-18 17:19:42.083	\N
d30da286-5411-410f-8160-42ae791e4b50	FRONT FENDER / SPAKBOR DEPAN ADV 150 MERAH	\N	0	HONDA	141000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	141000.00	HON-FRO-2332	2026-06-18 17:47:31.403	\N
81641b27-17db-4abd-a622-c4d6d27c6570	FRONT FENDER / SPAKBOR DEPAN ADV 150 PUTIH	\N	0	HONDA	141000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	141000.00	HON-FRO-2333	2026-06-18 17:47:31.403	\N
cmlezx801019s39t53csrna6j	MIKA SPEEDOMETER SUPRA	\N	0	HONDA	28000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	26000.00	HON-MIK-MIK-856	2026-06-19 22:06:56.578	01B1101700AA6
cmlezxgx401to39t5igzh3v6a	LEGSHIELD LUAR / SAYAP LUAR BLADE 11 ORANGE	\N	0	HONDA	173000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	230000.00	HON-LEG-LEG-1131	2026-02-09 09:55:11.246	\N
cmlezxazn01g439t5eczqvcaq	MIKA SEN Rr / MIKA SEN BELAKANG + STOP PRIMA (C/M) KO	\N	0	HONDA	46000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	54000.00	HON-MIK-MIK-922	2026-06-18 17:27:37.767	\N
cmlezxarj01fi39t51ns9c4ks	MIKA STOP / MIKA BELAKANG GL PRO DE (P) KO	\N	0	HONDA	30000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	35000.00	HON-MIK-MIK-950	2026-06-18 17:27:37.767	\N
cmlezxasi01fp39t5ei8ivm0u	MIKA STOP / MIKA BELAKANG GL PRO DE SMOKE	\N	0	HONDA	38000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	45000.00	HON-MIK-MIK-952	2026-06-18 17:27:37.767	\N
cmlezxo3v026939t5g2r4qfz5	SWITCH REM BELAKANG HONDA / SUZUKI	\N	0	HONDA	12000.00	SWITCH REM	2026-02-09 09:55:22.865	KELISTRIKAN	16000.00	HON-TUT-SWI-1419	2026-06-18 17:34:05.97	\N
cmlezxo9h026q39t57w0wm6cv	SWITCH REM DEPAN SUPRA X	\N	0	HONDA	10000.00	SWITCH REM	2026-02-09 09:55:22.865	KELISTRIKAN	14000.00	HON-TUT-SWI-1420	2026-06-18 17:34:05.97	\N
cmlg43pp700pvpv85xnc6yv2j	SWITCH REM BELAKANG JUPITER Z	\N	0	YAMAHA	13000.00	SWITCH REM	2026-02-10 04:39:46.568	KELISTRIKAN	16000.00	YAM-AKS-SWI-685	2026-06-18 17:34:05.97	\N
cmlg43pnr00pspv85foh3h352	SWITCH REM BELAKANG JUPITER MX	\N	0	YAMAHA	13000.00	SWITCH REM	2026-02-10 04:39:46.568	KELISTRIKAN	16000.00	YAM-AKS-SWI-684	2026-06-18 17:34:05.97	\N
cmlg43phf00pkpv85wciajzuq	SWITCH REM BELAKANG (YAMAHA)	\N	0	YAMAHA	0.00	SWITCH REM	2026-02-10 04:39:46.568	KELISTRIKAN	15000.00	YAM-AKS-SWI-681	2026-06-18 17:34:05.97	\N
cmlezxa1a01e839t5icxdbbsa	MIKA SEN Rr / MIKA SEN BELAKANG + STOP SUPRA FIT NEW (P/M) KO	\N	0	HONDA	39000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	79000.00	HON-MIK-MIK-909	2026-02-09 09:55:04.847	\N
2ee538eb-6cb4-4698-b45e-192739fed379	FRONT FENDER / SPAKBOR DEPAN PCX 150 18 HITAM	\N	0	HONDA	176000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	176000.00	HON-FRO-2334	2026-06-18 17:47:31.403	\N
2763a5bd-20af-480e-bcd2-05dd70a76070	FRONT FENDER / SPAKBOR DEPAN PCX 150 18 PUTIH	\N	0	HONDA	192000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	192000.00	HON-FRO-2335	2026-06-18 17:47:31.403	\N
cmlezxaan01ek39t54dvrjvqg	MIKA STOP / MIKA BELAKANG VARIO 150 18 / 125 23	\N	0	HONDA	79000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	170000.00	HON-MIK-MIK-933	2026-02-09 09:55:04.847	\N
cmlezxakm01ey39t5wv7hbx2t	MIKA STOP / MIKA BELAKANG SCOOPY FI 17 BESAR (P) + KECIL (M)	\N	0	HONDA	69000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	170000.00	HON-MIK-MIK-934	2026-02-09 09:55:04.847	\N
601cc487-95bc-437e-b203-93357bb929ad	FRONT FENDER / SPAKBOR DEPAN CB 150 R VERZA HITAM	\N	0	HONDA	148000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	148000.00	HON-FRO-2336	2026-06-18 17:47:31.403	\N
4709c68f-4287-47a3-b20c-eca55ac4a0c4	FRONT FENDER / SPAKBOR DEPAN CB 150 R NEW / CBR 150 R K45G (2016 - 2018) / CBR 150 R K45N (2018 - 2020) HITAM	\N	0	HONDA	134000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	134000.00	HON-FRO-2337	2026-06-18 17:47:31.403	\N
110f1fca-7a46-4a56-9530-8605215d9a98	FRONT FENDER / SPAKBOR DEPAN CB 150 R NEW / CBR 150 R K45G (2016 - 2018) / CBR 150 R K45N (2018 - 2020) HITAM DOFF	\N	0	HONDA	149000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	149000.00	HON-FRO-2338	2026-06-18 17:47:31.403	\N
30fe181c-4e3d-48c3-bdd8-3e517a6fbfd0	FRONT FENDER / SPAKBOR DEPAN CB 150 R NEW / CBR 150 R K45G (2016 - 2018) / CBR 150 R K45N (2018 - 2020) PUTIH	\N	0	HONDA	149000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	149000.00	HON-FRO-2339	2026-06-18 17:47:31.403	\N
b751b36f-4031-4051-9a63-a115c873d1e9	FRONT FENDER / SPAKBOR DEPAN CB 150 R NEW / CBR 150 R K45G (2016 - 2018) / CBR 150 R K45N (2018 - 2020) MERAH	\N	0	HONDA	149000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	149000.00	HON-FRO-2340	2026-06-18 17:47:31.403	\N
cmlezxcba01jc39t58a7xitbx	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT SPACY	\N	0	HONDA	184000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	475000.00	HON-FRO-FRO-999	2026-06-18 17:22:17.168	\N
cmlezxbg901h839t5pdeva7rx	MIKA SEN Rr / MIKA SEN BELAKANG + STOP GRAND (C/M) KO	\N	0	HONDA	31000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	79000.00	HON-MIK-MIK-924	2026-02-09 09:55:04.847	\N
cmlezxbmh01hq39t5vwhoh5po	MIKA STOP / MIKA BELAKANG SUPRA X 125 (M)	\N	0	HONDA	24000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	30000.00	HON-MIK-MIK-938	2026-02-09 09:55:04.848	\N
cmlezxbrw01i439t5i5purxl6	MIKA STOP / MIKA BELAKANG BEAT FI	\N	0	HONDA	38000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	170000.00	HON-MIK-MIK-931	2026-02-09 09:55:04.848	\N
cmlezxbxt01ik39t5vu9l25ud	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT SUPRA X 125	\N	0	HONDA	43000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	429000.00	HON-FRO-FRO-984	2026-02-09 09:55:04.848	\N
cmlezxdqq01mk39t5qpcomnl0	LEGSHIELD LUAR / SAYAP LUAR (HONDA)	\N	0	HONDA	0.00	LEGSHIELD DALAM ATAS / LEGSHIELD KONTAK (HONDA)	2026-02-09 09:55:08.265	BODY PART	194000.00	HON-LEG-LEG-1077	2026-02-09 09:55:08.265	\N
cmlezxf6501ps39t5357z8imt	LEGSHIELD LUAR / SAYAP LUAR ABSOLUTE REVO MERAH MAROON	\N	0	HONDA	182000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	228000.00	HON-LEG-LEG-1125	2026-02-09 09:55:11.246	\N
99855b7a-a299-42c5-95d2-4decc5fe1293	FRONT FENDER / SPAKBOR DEPAN SUPRA X 125 14 HITAM	\N	0	HONDA	82000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	82000.00	HON-FRO-2341	2026-06-18 17:47:31.403	\N
0fb84adc-f03a-4825-b0b5-645b88fc9ba9	FRONT FENDER / SPAKBOR DEPAN BLADE 11 HITAM	\N	0	HONDA	96000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	96000.00	HON-FRO-2342	2026-06-18 17:47:31.403	\N
cmlezxg5m01sa39t5clz8f1nc	LEGSHIELD DALAM / SAYAP DALAM VARIO TECHNO BESAR	\N	0	HONDA	61000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	217000.00	HON-LEG-LEG-1142	2026-06-18 17:22:17.168	\N
cmlezxawd01fs39t51r3wvt65	MIKA SEN Fr / MIKA SEN DEPAN  PRIMA (C/P) KO	\N	0	HONDA	44000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	52000.00	HON-MIK-MIK-921	2026-06-18 17:22:17.168	\N
3b88da4c-12d7-456c-8dc2-1ce686caceab	FRONT FENDER / SPAKBOR DEPAN BEAT 10 HITAM	\N	0	HONDA	74000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	74000.00	HON-FRO-2343	2026-06-18 17:47:31.403	\N
cmlezxbcm01gy39t5wj1kqinb	FRONT WINKER / SEN DEPAN UNIT BEAT / BEAT 10	\N	0	HONDA	86000.00	FRONT WINKER / SEN DEPAN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	82000.00	HON-FRO-FRO-967	2026-06-19 22:06:56.848	01B2701400AA3
cmlezwrtm00hi39t5xp55bqko	PANEL / TAMENGBEAT ESP 16 BIRU MUDA	\N	0	HONDA	209000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	213000.00	HON-PAN-PAN-340	2026-06-19 22:06:56.977	01B4630574AA4
cmlezwrsq00hc39t5cwbiyjhq	PANEL / TAMENGBEAT FI / BEAT FI ESP HITAM	\N	0	HONDA	148000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	151000.00	HON-PAN-PAN-347	2026-06-19 22:06:57.108	01B3830540AA4
cmlezwrsq00hd39t5a1cxdk3i	PANEL / TAMENGBEAT FI BIRU	\N	0	HONDA	168000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	171000.00	HON-PAN-PAN-348	2026-06-19 22:06:57.241	01B3830574AA4
cmlezwsah00i439t5jfx0t2b8	PANEL / TAMENGBEAT BIRU TUA	\N	0	HONDA	142000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	145000.00	HON-PAN-PAN-355	2026-06-19 22:06:57.37	01B2730543AA6
cmlezwsbq00ic39t5onnsd6g0	PANEL / TAMENGBEAT HIJAU	\N	0	HONDA	142000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	146000.00	HON-PAN-PAN-356	2026-06-19 22:06:57.498	01B2730559AA6
c8ec0754-d4fc-45f9-a392-8ece430ed21f	FRONT FENDER / SPAKBOR DEPAN BEAT 10 HIJAU	\N	0	HONDA	94000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	94000.00	HON-FRO-2344	2026-06-18 17:47:31.403	\N
cmlezxfjn01qq39t5jnaq7pk3	LEGSHIELD DALAM / SAYAP DALAM KARISMA X SILVER	\N	0	HONDA	220000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	111000.00	HON-LEG-LEG-1151	2026-02-09 09:55:11.246	\N
1b8942fe-fe94-4007-9194-9c607af12992	FRONT FENDER / SPAKBOR DEPAN BEAT 10 BIRU TUA	\N	0	HONDA	94000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	94000.00	HON-FRO-2345	2026-06-18 17:47:31.403	\N
8e0832e1-f6f1-4fd3-84cf-2079010598a0	FRONT FENDER / SPAKBOR DEPAN BEAT 10 MERAH MAROON	\N	0	HONDA	94000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	94000.00	HON-FRO-2346	2026-06-18 17:47:31.403	\N
a8df4cc7-5c25-4f41-8d8d-d014aa330def	FRONT FENDER / SPAKBOR DEPAN BEAT 10 PUTIH	\N	0	HONDA	94000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	94000.00	HON-FRO-2347	2026-06-18 17:47:31.403	\N
cmlezxaq701fe39t58zr4mqna	MIKA STOP / MIKA BELAKANG SCOOPY FI BESAR (P) + KECIL (M)	\N	0	HONDA	59000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	170000.00	HON-MIK-MIK-935	2026-06-18 17:19:42.083	\N
cmlezx9jk01do39t5zwkybkdl	MIKA SPEEDOMETER (HONDA)	\N	0	HONDA	0.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	26000.00	HON-MIK-MIK-834	2026-02-09 09:55:01.49	\N
cmlezxagx01ew39t5aja80vh9	MIKA STOP / MIKA BELAKANG SUPRA X (P) KO	\N	0	HONDA	29000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	30000.00	HON-MIK-MIK-940	2026-02-09 09:55:04.847	\N
0dee117d-7c2a-4043-849d-de2d52623923	FRONT FENDER / SPAKBOR DEPAN B SUPRA X 125 07	\N	0	HONDA	60000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	60000.00	HON-FRO-2348	2026-06-18 17:47:31.403	\N
6923ca70-1583-4738-a981-259b596d72d9	REAR FENDER / SPAKBOR BELAKANG ATAS A VARIO 150 18 / VARIO 125 18 / VARIO 125 23 / VARIO 160	\N	0	HONDA	22000.00	REAR FENDER	2026-06-18 17:47:31.403	BODY PART	22000.00	HON-REA-2349	2026-06-18 17:47:31.403	\N
69b5b112-f9b0-4c39-992a-0df62b44e2f7	REAR FENDER  / SPAKBOR BELAKANG  SCOOPY FI 17	\N	0	HONDA	108000.00	REAR FENDER	2026-06-18 17:47:31.403	BODY PART	108000.00	HON-REA-2350	2026-06-18 17:47:31.403	\N
f3a0458a-800d-42f5-84d3-383d1b83ea90	REAR FENDER / SPAKBOR BELAKANG  SUPRA X 125 14	\N	0	HONDA	77000.00	REAR FENDER	2026-06-18 17:47:31.403	BODY PART	77000.00	HON-REA-2351	2026-06-18 17:47:31.403	\N
6b4a2e16-1910-45d2-8d3b-315fca600619	REAR FENDER / SPAKBOR BELAKANG  VERZA	\N	0	HONDA	75000.00	REAR FENDER	2026-06-18 17:47:31.403	BODY PART	75000.00	HON-REA-2352	2026-06-18 17:47:31.403	\N
2422ab61-d93f-4d0e-9169-63fc65be7d34	REAR FENDER / SPAKBOR BELAKANG  B SUPRA X / SUPRA / SUPRA XX / SUPRA FIT	\N	0	HONDA	53000.00	REAR FENDER	2026-06-18 17:47:31.403	BODY PART	53000.00	HON-REA-2353	2026-06-18 17:47:31.403	\N
87809bbf-bf87-4339-93aa-23be7b0549c7	REAR FENDER / SPAKBOR BELAKANG  GRAND / IMPRESSA HITAM	\N	0	HONDA	60000.00	REAR FENDER	2026-06-18 17:47:31.403	BODY PART	60000.00	HON-REA-2354	2026-06-18 17:47:31.403	\N
95f3f536-e864-4e40-9da7-078c1dfc7198	REAR FENDER LOWER ( KOLONG ) VARIO 150 18 / VARIO 125 18	\N	0	HONDA	31000.00	REAR FENDER	2026-06-18 17:47:31.403	BODY PART	31000.00	HON-REA-2355	2026-06-18 17:47:31.403	\N
5005d541-28cf-4f72-8c27-6385e0c746fe	REAR FENDER LOWER ( KOLONG ) VARIO TECHNO 125	\N	0	HONDA	32000.00	REAR FENDER	2026-06-18 17:47:31.403	BODY PART	32000.00	HON-REA-2356	2026-06-18 17:47:31.403	\N
3e13734d-57f4-4515-abf9-83fb30b33a45	PANEL / TAMENG VARIO 125 23 BESAR HITAM	\N	0	HONDA	202000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	202000.00	HON-PAN-2357	2026-06-18 17:47:31.403	\N
cmlezxazn01g639t5o8cy6six	MIKA STOP / MIKA BELAKANG GENIO	\N	0	HONDA	26000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	170000.00	HON-MIK-MIK-954	2026-02-09 09:55:04.847	\N
4bafe6c5-1cce-42e7-81ba-db53d84c190d	PANEL / TAMENG VARIO 125 23 BESAR HITAM DOFF	\N	0	HONDA	235000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	235000.00	HON-PAN-2358	2026-06-18 17:47:31.403	\N
b288af93-3667-43ed-be29-b0e206a5e644	PANEL / TAMENG VARIO 125 23 BESAR MERAH	\N	0	HONDA	217000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	217000.00	HON-PAN-2359	2026-06-18 17:47:31.403	\N
790ee9f9-2283-49d5-97df-b53095872781	PANEL / TAMENG VARIO 125 23 BESAR PUTIH DOFF	\N	0	HONDA	235000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	235000.00	HON-PAN-2360	2026-06-18 17:47:31.403	\N
917eddcb-d019-48df-976e-72932a31dba8	PANEL / TAMENG VARIO 125 23 KECIL HITAM DOFF	\N	0	HONDA	136000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	136000.00	HON-PAN-2361	2026-06-18 17:47:31.403	\N
cmlezxf6601pu39t5liy27xlr	LEGSHIELD DALAM / SAYAP DALAM BEAT 20 BESAR NON CHARGER	\N	0	HONDA	74000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	79000.00	HON-LEG-LEG-1133	2026-06-18 17:22:17.168	\N
4bee3e66-57b1-4363-bea8-d2ff71099d61	PANEL / TAMENG VARIO 160 BESAR HITAM	\N	0	HONDA	192000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	192000.00	HON-PAN-2362	2026-06-18 17:47:31.403	\N
d9be80e3-cd82-4481-81e6-9b19c4e83438	PANEL / TAMENG VARIO 160 BESAR HITAM DOFF	\N	0	HONDA	209000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	209000.00	HON-PAN-2363	2026-06-18 17:47:31.403	\N
6500c21b-304f-4ae9-9bc6-7eb471e65edb	PANEL / TAMENG VARIO 160 BESAR MERAH DOFF	\N	0	HONDA	209000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	209000.00	HON-PAN-2364	2026-06-18 17:47:31.403	\N
7ecebcb6-9257-4cb4-a8d7-4408cc5f478b	PANEL / TAMENG VARIO 160 BESAR PUTIH DOFF	\N	0	HONDA	209000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	209000.00	HON-PAN-2365	2026-06-18 17:47:31.403	\N
cmlezxbk601hk39t5o5smgsgo	FRONT WINKER / SEN DEPAN ASSY SUPRA (O)	\N	0	HONDA	55000.00	FRONT WINKER / SEN DEPAN (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	59000.00	HON-FRO-FRO-973	2026-06-18 17:22:17.168	\N
cmlezxanf01fb39t5oru5s798	MIKA STOP / MIKA BELAKANG GL PRO DE (M) KO	\N	0	HONDA	30000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	35000.00	HON-MIK-MIK-949	2026-06-18 17:27:37.767	\N
cmlezxbk601hg39t5zyqqwe2l	FRONT WINKER / SEN DEPAN UNIT SCOOPY FI 17	\N	0	HONDA	134000.00	FRONT WINKER / SEN DEPAN (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	146000.00	HON-FRO-FRO-972	2026-06-18 17:27:37.767	\N
2a6e2d56-0309-4deb-b207-917f0891d10b	PANEL / TAMENG VARIO 160 KECIL HITAM	\N	0	HONDA	65000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	65000.00	HON-PAN-2366	2026-06-18 17:47:31.403	\N
cmlezxb5y01gf39t5gq0elkuo	MIKA STOP / MIKA BELAKANG SMASH 06 BESAR (P)	\N	0	HONDA	30000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	170000.00	HON-MIK-MIK-959	2026-02-09 09:55:04.847	\N
e9ac365c-42af-478d-8961-b6e69e46c328	PANEL / TAMENG VARIO 160 KECIL HITAM DOFF	\N	0	HONDA	82000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	82000.00	HON-PAN-2367	2026-06-18 17:47:31.403	\N
cmlezww0100n339t5pwgws5aw	PANEL / TAMENGVARIO TECHNO MERAH MAROON	\N	0	HONDA	152000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	155000.00	HON-PAN-PAN-405	2026-06-19 22:06:58.58	01B2930555AA1
cmlezxbet01h539t5btewxl2y	FRONT WINKER / SEN DEPAN UNIT BEAT ESP 16	\N	0	HONDA	74000.00	FRONT WINKER / SEN DEPAN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	80000.00	HON-FRO-FRO-964	2026-06-19 22:06:59.076	01B4601400AA2
cmlezxbet01h439t5sdbaqdd6	FRONT WINKER / SEN DEPAN UNIT BEAT FI	\N	0	HONDA	79000.00	FRONT WINKER / SEN DEPAN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	85000.00	HON-FRO-FRO-968	2026-06-19 22:06:59.527	01B3801300AA3
cmlezxj9d01xu39t5430rgm7t	STANDARD TENGAH BEAT FI ESP / POP / SCOOPY FI / FI 17	\N	0	HONDA	0.00	STANDARD TENGAH	2026-02-09 09:55:15.055	KAKI-KAKI	78000.00	HON-STA-STA-1279	2026-06-19 22:06:59.885	01B3884397AA20
cmlezww5l00ni39t50h5sv9lt	PANEL / TAMENGSCOOPY VIOLET	\N	0	HONDA	216000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	219000.00	HON-PAN-PAN-451	2026-06-19 22:07:00.118	01B3130561AA1
cmlezxbom01hs39t59hk31vvd	FRONT WINKER / SEN DEPAN UNIT REVO FI / REVO X	\N	0	HONDA	123000.00	FRONT WINKER / SEN DEPAN (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	66000.00	HON-FRO-FRO-976	2026-02-09 09:55:04.848	\N
7d92f546-f3d4-4acb-8c67-9fb966c31520	PANEL / TAMENG VARIO 160 KECIL PUTIH DOFF	\N	0	HONDA	82000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	82000.00	HON-PAN-2368	2026-06-18 17:47:31.403	\N
a9ce7e6d-ec2e-48f3-9048-c9c018f58cbc	PANEL / TAMENG SCOOPY 20 HITAM	\N	0	HONDA	270000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	270000.00	HON-PAN-2369	2026-06-18 17:47:31.403	\N
dcde5dfa-cb15-4665-ae0c-f369ca67322c	PANEL / TAMENG SCOOPY 20 KREM	\N	0	HONDA	293000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	293000.00	HON-PAN-2370	2026-06-18 17:47:31.403	\N
4c0fe6e2-d8e4-4110-b59b-5e22d5f0cb43	PANEL / TAMENG SCOOPY 20 MERAH	\N	0	HONDA	293000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	293000.00	HON-PAN-2371	2026-06-18 17:47:31.403	\N
cmlezxc1q01is39t5kwjymgu8	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT BLADE	\N	0	HONDA	66000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	429000.00	HON-FRO-FRO-988	2026-02-09 09:55:04.848	\N
ae711a98-6dd3-4028-8aa9-2df926e76b02	PANEL / TAMENG SCOOPY 20 MERAH DOFF	\N	0	HONDA	297000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	297000.00	HON-PAN-2372	2026-06-18 17:47:31.403	\N
72fcf1c9-d137-4a9e-ad68-e0f673e9bdbe	PANEL / TAMENG SCOOPY 20 PUTIH DOFF	\N	0	HONDA	313000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	313000.00	HON-PAN-2373	2026-06-18 17:47:31.403	\N
cmlezxder01ls39t54fz5fco1	COB LAMPU / FITTING LAMPU TIGER	\N	0	HONDA	8000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	17100.00	HON-STO-COB-1065	2026-02-09 09:55:08.265	\N
cmlezxe1q01na39t5fbhirxvg	COB LAMPU / FITTING LAMPU SMASH	\N	0	HONDA	13000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.266	KELISTRIKAN	17100.00	HON-STO-COB-1072	2026-02-09 09:55:08.266	\N
cmlezxe7d01ns39t5ub2hnfs0	COB LAMPU / FITTING LAMPU BEAT POP	\N	0	HONDA	19000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.266	KELISTRIKAN	17100.00	HON-STO-COB-1051	2026-02-09 09:55:08.266	\N
e8bd5673-7c9c-4f2a-ac20-b15fea6762a6	PANEL / TAMENG BEAT 20 / BEAT STREET 20 BESAR HITAM	\N	0	HONDA	206000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	206000.00	HON-PAN-2374	2026-06-18 17:47:31.403	\N
585a423f-1ab8-4284-97ec-0150928d4984	PANEL / TAMENG BEAT 20 / BEAT STREET 20 BESAR HITAM DOFF	\N	0	HONDA	264000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	264000.00	HON-PAN-2375	2026-06-18 17:47:31.403	\N
16e9c568-bb14-4a0d-b92a-9ec2ebaa6b5c	PANEL / TAMENG BEAT 20 / BEAT STREET 20 BESAR BIRU MUDA	\N	0	HONDA	236000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	236000.00	HON-PAN-2376	2026-06-18 17:47:31.403	\N
f8165fc7-ff72-4d0c-8fd5-ccd0d4ae2e45	PANEL / TAMENG BEAT 20 / BEAT STREET 20 BESAR MERAH	\N	0	HONDA	236000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	236000.00	HON-PAN-2377	2026-06-18 17:47:31.403	\N
5a6426fc-db70-48c6-ac4d-a66fda8f677b	PANEL / TAMENG BEAT 20 / BEAT STREET 20 BESAR HIJAU DOFF	\N	0	HONDA	264000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	264000.00	HON-PAN-2378	2026-06-18 17:47:31.403	\N
b87e7912-5ad6-42a0-b78a-4f3b19f41dd9	PANEL / TAMENG BEAT 20 / BEAT STREET 20 BESAR PUTIH	\N	0	HONDA	258000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	258000.00	HON-PAN-2379	2026-06-18 17:47:31.403	\N
24ef7d6e-fd43-40f3-82f1-431a50d318da	PANEL / TAMENG BEAT 20 / BEAT STREET 20 KECIL	\N	0	HONDA	28000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	28000.00	HON-PAN-2380	2026-06-18 17:47:31.403	\N
32ea46c3-8972-44c7-a99b-b3b0e6c91625	PANEL / TAMENG GENIO HITAM	\N	0	HONDA	347000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	347000.00	HON-PAN-2381	2026-06-18 17:47:31.403	\N
94dc490a-181b-4b28-b82d-7433568501a4	PANEL / TAMENG GENIO MERAH	\N	0	HONDA	366000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	366000.00	HON-PAN-2382	2026-06-18 17:47:31.403	\N
3649626a-b37b-4a4c-a6e1-7cac465fad8d	PANEL / TAMENG GENIO PUTIH	\N	0	HONDA	366000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	366000.00	HON-PAN-2383	2026-06-18 17:47:31.403	\N
4583ced8-2fbc-4157-81f1-66b2a75d14f8	PANEL / TAMENG VARIO 150 / VARIO 125 KECIL HITAM	\N	0	HONDA	58000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	58000.00	HON-PAN-2384	2026-06-18 17:47:31.403	\N
cmlezxdk301lz39t5ygnbtlqw	COB LAMPU / FITTING LAMPU BEAT FI	\N	0	HONDA	15000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	22000.00	HON-STO-COB-1049	2026-06-18 17:22:17.168	\N
f09ba722-4eb3-43e2-bb23-731ec80518f7	PANEL / TAMENG VARIO TECHNO 125 KECIL HITAM	\N	0	HONDA	76000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	76000.00	HON-PAN-2385	2026-06-18 17:47:31.403	\N
0f9b158b-2542-4593-8f7b-ee7ca1dd1a73	PANEL / TAMENG VARIO TECHNO 125 KECIL GRAY	\N	0	HONDA	90000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	90000.00	HON-PAN-2386	2026-06-18 17:47:31.403	\N
a82f93fa-7170-4a82-979a-4e86c702dc86	PANEL / TAMENG SCOOPY FI / SCOOPY FI ESP HITAM	\N	0	HONDA	96000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	96000.00	HON-PAN-2387	2026-06-18 17:47:31.403	\N
cmlezxmfy023c39t5dx71vlwk	BUNTUT Rr GL PRO NEOTECH	\N	0	HONDA	17000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	21000.00	HON-TUT-BUN-1360	2026-06-18 17:27:37.767	\N
cmlezxeod01ow39t5s6ey2k3w	COB LAMPU / FITTING LAMPU VARIO TECHNO 125	\N	0	HONDA	29000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.266	KELISTRIKAN	41000.00	HON-STO-COB-1053	2026-06-18 17:27:37.767	\N
25997b21-3c24-4944-a5f7-1c08fe71c61d	PANEL / TAMENG SCOOPY FI / SCOOPY FI ESP KREM	\N	0	HONDA	112000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	112000.00	HON-PAN-2388	2026-06-18 17:47:31.403	\N
655e039b-33a5-4d7b-acb7-8dafdca2fd95	PANEL / TAMENG SCOOPY FI / SCOOPY FI ESP MERAH	\N	0	HONDA	112000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	112000.00	HON-PAN-2389	2026-06-18 17:47:31.403	\N
14fd147b-4706-4443-bca9-eec5a1d111cf	PANEL / TAMENG SCOOPY FI / SCOOPY FI ESP MERAH MAROON	\N	0	HONDA	112000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	112000.00	HON-PAN-2390	2026-06-18 17:47:31.403	\N
cmlezxdee01lo39t5846zc447	COB LAMPU / FITTING LAMPU BEAT ESP 16	\N	0	HONDA	19000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	17100.00	HON-STO-COB-1048	2026-06-18 17:19:42.083	\N
5fff6512-b2cf-43b0-b36e-63576eab0e25	PANEL / TAMENG SCOOPY FI / SCOOPY FI ESP PUTIH	\N	0	HONDA	112000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	112000.00	HON-PAN-2391	2026-06-18 17:47:31.403	\N
9339fca1-136b-4a2e-a534-a1756c4e0bda	PANEL / TAMENG IMPRESSA / GRAND HITAM	\N	0	HONDA	37000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	37000.00	HON-PAN-2392	2026-06-18 17:47:31.403	\N
5d4e826e-4413-4e90-9c58-3256f3f4e458	PANEL DEPAN BAGIAN BAWAH VARIO 125 23	\N	0	HONDA	79000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	79000.00	HON-PAN-2393	2026-06-18 17:47:31.403	\N
d710dd5b-f1f7-455a-bd17-3b57cbf26f74	PANEL DEPAN BAGIAN BAWAH VARIO 150 18 / VARIO 125 18	\N	0	HONDA	88000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	88000.00	HON-PAN-2394	2026-06-18 17:47:31.403	\N
76bbed50-31dd-4dec-a286-01cecd55fe3a	PANEL DEPAN BAGIAN BAWAH VARIO 150 / VARIO 125	\N	0	HONDA	64000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	64000.00	HON-PAN-2395	2026-06-18 17:47:31.403	\N
cmlezwwye00ou39t5jnum5dwf	PANEL / TAMENGSUPRA FIT NEW/X NEW HITAM	\N	0	HONDA	53000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	56000.00	HON-PAN-PAN-476	2026-06-19 22:07:00.689	01B2130540AA1
cmlezxjtg01ze39t5s6cgfq9t	STANDARD TENGAH SUPRA	\N	0	HONDA	64000.00	STANDARD TENGAH	2026-02-09 09:55:15.055	KAKI-KAKI	86000.00	HON-STA-STA-1286	2026-06-19 22:07:00.821	01B1184397AA1
cmlezxjjy01ym39t54aoclyc7	STANDARD TENGAH BEAT 20	\N	0	HONDA	0.00	STANDARD TENGAH	2026-02-09 09:55:15.055	KAKI-KAKI	86000.00	HON-STA-STA-1285	2026-06-19 22:07:01.187	01B5984397AA12
4cb0bbf8-b680-491c-be0e-3d32bb0fb308	PANEL DEPAN BAGIAN BAWAH BEAT ESP 16 / BEAT STREET 16	\N	0	HONDA	71000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	71000.00	HON-PAN-2396	2026-06-18 17:47:31.403	\N
575c2fd9-88a6-41d9-ae9c-519f68593bcb	PANEL DEPAN BAGIAN BAWAH SCOOPY FI / SCOOPY FI ESP	\N	0	HONDA	106000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	106000.00	HON-PAN-2397	2026-06-18 17:47:31.403	\N
43915b17-3235-485f-8c80-453948dc03c4	PANEL DEPAN BAGIAN BAWAH BEAT FI / BEAT FI ESP	\N	0	HONDA	76000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	76000.00	HON-PAN-2398	2026-06-18 17:47:31.403	\N
7d321800-341d-4f2a-bd66-f002ed6f2f3b	PANEL DEPAN BAGIAN BAWAH BEAT / BEAT 10	\N	0	HONDA	62000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	62000.00	HON-PAN-2399	2026-06-18 17:47:31.403	\N
e86c27c7-87bf-47f3-835d-6bdacdd52376	FRONT HANDLE COVER / BATOK DEPAN A SCOOPY FI / SCOOPY FI ESP HITAM	\N	0	HONDA	82000.00	FRONT HANDLE COVER	2026-06-18 17:47:31.403	BODY PART	82000.00	HON-FHC-2400	2026-06-18 17:47:31.403	\N
568a75bd-f902-4bf4-bc14-a1f6fc66967d	FRONT HANDLE COVER / BATOK DEPAN A SCOOPY FI / SCOOPY FI ESP MERAH	\N	0	HONDA	90000.00	FRONT HANDLE COVER	2026-06-18 17:47:31.403	BODY PART	90000.00	HON-FHC-2401	2026-06-18 17:47:31.403	\N
cmlezxdec01lk39t5s3bsx5vs	COB LAMPU / FITTING LAMPU ABSOLUTE REVO	\N	0	HONDA	16000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	17100.00	HON-STO-COB-1063	2026-06-18 17:19:42.083	\N
6b093f01-234f-4a52-9abb-02fd2f39cc08	FRONT HANDLE COVER / BATOK DEPAN B SCOOPY FI / SCOOPY FI ESP HITAM	\N	0	HONDA	82000.00	FRONT HANDLE COVER	2026-06-18 17:47:31.403	BODY PART	82000.00	HON-FHC-2402	2026-06-18 17:47:31.403	\N
99755092-b430-4a4c-b35b-81fa49fa0b20	FRONT HANDLE COVER / BATOK DEPAN B SCOOPY FI / SCOOPY FI ESP KREM	\N	0	HONDA	95000.00	FRONT HANDLE COVER	2026-06-18 17:47:31.403	BODY PART	95000.00	HON-FHC-2403	2026-06-18 17:47:31.403	\N
e20e8615-8e89-4614-a831-9e158dc7595a	FRONT HANDLE COVER / BATOK DEPAN B SCOOPY FI / SCOOPY FI ESP MERAH	\N	0	HONDA	95000.00	FRONT HANDLE COVER	2026-06-18 17:47:31.403	BODY PART	95000.00	HON-FHC-2404	2026-06-18 17:47:31.403	\N
eeb25d07-e38b-43a3-86f4-4e009f422d09	REAR HANDLE COVER /BATOK BELAKANG VARIO 125 23	\N	0	HONDA	37000.00	REAR HANDLE	2026-06-18 17:47:31.403	BODY PART	37000.00	HON-RHC-2405	2026-06-18 17:47:31.403	\N
8c47418a-f447-474c-b2da-0dc67d866a6f	REAR HANDLE COVER /BATOK BELAKANG VARIO 150 18 / VARIO 125 18	\N	0	HONDA	26000.00	REAR HANDLE	2026-06-18 17:47:31.403	BODY PART	26000.00	HON-RHC-2406	2026-06-18 17:47:31.403	\N
2b8fc53e-fd22-4815-b954-9fc036ea33b7	REAR HANDLE COVER /BATOK BELAKANG SUPRA X 125 14	\N	0	HONDA	91000.00	REAR HANDLE	2026-06-18 17:47:31.403	BODY PART	91000.00	HON-RHC-2407	2026-06-18 17:47:31.403	\N
befd1cb2-9ac8-4de9-99bd-ef2bbc9ad29c	REAR HANDLE COVER /BATOK BELAKANG BEAT FI ESP	\N	0	HONDA	45000.00	REAR HANDLE	2026-06-18 17:47:31.403	BODY PART	45000.00	HON-RHC-2408	2026-06-18 17:47:31.403	\N
cmlezxdao01lc39t5kktl0x92	COB LAMPU / FITTING LAMPU SUPRA X 125 07	\N	0	HONDA	16000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	29000.00	HON-STO-COB-1055	2026-06-18 17:19:42.083	\N
1414ff47-d2ba-40e6-8b65-74b811ae1d95	REAR HANDLE COVER /BATOK BELAKANG CB 150 R	\N	0	HONDA	68000.00	REAR HANDLE	2026-06-18 17:47:31.403	BODY PART	68000.00	HON-RHC-2409	2026-06-18 17:47:31.403	\N
432ea367-85fd-44dc-92bd-efe971de1fd4	REAR HANDLE COVER /BATOK BELAKANG SUPRA X 125 HELM IN HITAM	\N	0	HONDA	170000.00	REAR HANDLE	2026-06-18 17:47:31.403	BODY PART	170000.00	HON-RHC-2410	2026-06-18 17:47:31.403	\N
3c7b68b4-9486-4baa-adf2-11ad89cabc05	REAR HANDLE COVER /BATOK BELAKANG KARISMA X HITAM	\N	0	HONDA	70000.00	REAR HANDLE	2026-06-18 17:47:31.403	BODY PART	70000.00	HON-RHC-2411	2026-06-18 17:47:31.403	\N
11fbff6c-0025-484d-997b-7ac29b5fefc5	COVER STOP / Rr STOP VARIO 160 HITAM	\N	0	HONDA	85000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	85000.00	HON-CST-2415	2026-06-18 17:47:31.403	\N
cmlezxde401lg39t5z7iogvu7	COB LAMPU / FITTING LAMPU SUPRA FIT NEW	\N	0	HONDA	14000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	17000.00	HON-STO-COB-1057	2026-06-18 17:22:17.168	\N
cmlezxn2w025039t5z1r300ty	HANDFAT + PIPA GAS BEAT FI ESP / VARIO TECHNO / VARIO TECHNO 125	\N	0	HONDA	19000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	23000.00	HON-TUT-HAN-1376	2026-06-18 17:22:17.168	\N
99551945-d52b-4abc-a5df-7a897472f364	COVER STOP / Rr STOP VARIO 160 MERAH DOFF	\N	0	HONDA	93000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	93000.00	HON-CST-2416	2026-06-18 17:47:31.403	\N
1a3010d6-68a1-4378-bf9b-153f3b1314f7	COVER STOP / Rr STOP SCOOPY 20 BESAR HITAM	\N	0	HONDA	125000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	125000.00	HON-CST-2417	2026-06-18 17:47:31.403	\N
3593425c-37cd-4e69-a566-5f48849bb54f	COVER STOP / Rr STOP SCOOPY 20 BESAR KREM	\N	0	HONDA	150000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	150000.00	HON-CST-2418	2026-06-18 17:47:31.403	\N
cmlezxdk301m039t5h2lue6xu	COB LAMPU / FITTING LAMPU SUPRA FIT	\N	0	HONDA	15000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	17000.00	HON-STO-COB-1058	2026-06-18 17:27:37.767	\N
cmlezxdrf01ms39t54eb25g42	COB LAMPU / FITTING LAMPU SUPRA	\N	0	HONDA	9000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	13000.00	HON-STO-COB-1060	2026-06-18 17:27:37.767	\N
cmlezxdqq01mg39t59u5k2mhp	COB LAMPU / FITTING LAMPU SUPRA X	\N	0	HONDA	10000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	17100.00	HON-STO-COB-1059	2026-06-18 17:19:42.083	\N
4c438b3d-def9-4f45-92de-912358e774d4	COVER STOP / Rr STOP SCOOPY 20 BESAR GRAY DOFF	\N	0	HONDA	150000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	150000.00	HON-CST-2419	2026-06-18 17:47:31.403	\N
d006e2c2-3d40-4d03-981c-773e705143f1	COVER STOP / Rr STOP SCOOPY 20 BESAR MERAH DOFF	\N	0	HONDA	150000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	150000.00	HON-CST-2420	2026-06-18 17:47:31.403	\N
a69d5803-5bf3-41df-a281-d00fa102c12b	COVER STOP / Rr STOP SCOOPY 20 BESAR PUTIH DOFF	\N	0	HONDA	150000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	150000.00	HON-CST-2421	2026-06-18 17:47:31.403	\N
4e7e248f-6f70-4989-9511-e4e543c22d98	COVER STOP / Rr STOP SCOOPY 20 KECIL HITAM	\N	0	HONDA	69000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	69000.00	HON-CST-2422	2026-06-18 17:47:31.403	\N
ad22c11a-aa09-42be-98ce-f39d0f1ea871	COVER STOP / Rr STOP SCOOPY 20 KECIL GRAY DOFF	\N	0	HONDA	85000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	85000.00	HON-CST-2423	2026-06-18 17:47:31.403	\N
942905af-f63f-4a9f-b2bf-a748a154dfda	COVER STOP / Rr STOP SCOOPY 20 KECIL MERAH DOFF	\N	0	HONDA	85000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	85000.00	HON-CST-2424	2026-06-18 17:47:31.403	\N
13af8dac-3eaa-4efb-86cf-84676fb7aa96	COVER STOP / Rr STOP SCOOPY 20 KECIL PUTIH DOFF	\N	0	HONDA	85000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	85000.00	HON-CST-2425	2026-06-18 17:47:31.403	\N
39df5975-756e-4c28-8969-4ac6be525408	COVER STOP / Rr STOP CB 150 R NEW HITAM	\N	0	HONDA	64000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	64000.00	HON-CST-2426	2026-06-18 17:47:31.403	\N
fbbd3721-5282-4682-a83a-4a3ba9949695	COVER STOP / Rr STOP SCOOPY FI 17 HITAM	\N	0	HONDA	104000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	104000.00	HON-CST-2427	2026-06-18 17:47:31.403	\N
122eee3c-6158-4025-aa0e-5d0954dc989e	BOX BAGASI SUPRA X 125 07	\N	0	HONDA	139000.00	BOX	2026-06-18 17:47:31.403	AKSESORIS	139000.00	HON-BOX-2413	2026-06-18 22:23:48.216	\N
cmlezxdli01m839t59io7iweb	COB LAMPU / FITTING LAMPU GL PRO	\N	0	HONDA	9000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	29000.00	HON-STO-COB-1074	2026-06-18 17:19:42.083	\N
fb918ee3-f2fe-4388-a84f-51db2fac49e8	COVER STOP / Rr STOP SCOOPY FI 17 MERAH	\N	0	HONDA	118000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	118000.00	HON-CST-2428	2026-06-18 17:47:31.403	\N
16df79f7-cf6d-4de9-992f-8f51b6ad9b72	COVER STOP / Rr STOP SCOOPY FI 17 PUTIH	\N	0	HONDA	118000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	118000.00	HON-CST-2429	2026-06-18 17:47:31.403	\N
3e6927ac-9f04-40ae-9001-118d639e3ad1	COVER STOP / Rr STOP BEAT ESP 16 / BEAT STREET 16	\N	0	HONDA	24000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	24000.00	HON-CST-2430	2026-06-18 17:47:31.403	\N
046c89a9-6012-49a8-adbb-014d6fbf0037	COVER STOP / Rr STOP VARIO TECHNO 125 HITAM	\N	0	HONDA	51000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	51000.00	HON-CST-2431	2026-06-18 17:47:31.403	\N
cmlezxdqo01me39t5v0nyji8c	COB LAMPU / FITTING LAMPU GRAND	\N	0	HONDA	10000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	29000.00	HON-STO-COB-1075	2026-06-18 17:19:42.083	\N
1c59c3eb-2550-45f9-beba-2e90cbc32ee3	COVER STOP / Rr STOP SCOOPY FI / SCOOPY FI ESP HITAM	\N	0	HONDA	89000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	89000.00	HON-CST-2432	2026-06-18 17:47:31.403	\N
a8d3f75e-db34-47a5-8d9e-4877c2c96fc4	COVER STOP / Rr STOP SCOOPY FI / SCOOPY FI ESP MERAH	\N	0	HONDA	97000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	97000.00	HON-CST-2433	2026-06-18 17:47:31.403	\N
e0a3f088-72c8-421c-b2a6-43ed8baac093	COVER TANGKI / COVER MESIN VARIO 125 23	\N	0	HONDA	51000.00	COVER TANGKI	2026-06-18 17:47:31.403	BODY PART	51000.00	HON-CTK-2434	2026-06-18 17:47:31.403	\N
e24bd943-c2e1-4813-8663-9276f2313a41	COVER TANGKI / COVER MESIN BEAT 20 / BEAT STREET 20	\N	0	HONDA	47000.00	COVER TANGKI	2026-06-18 17:47:31.403	BODY PART	47000.00	HON-CTK-2435	2026-06-18 17:47:31.403	\N
7d37c0b0-7400-4b2f-a7ee-fe949160a7b9	COVER TANGKI / COVER MESIN VARIO 150 18 / VARIO 125 18	\N	0	HONDA	48000.00	COVER TANGKI	2026-06-18 17:47:31.403	BODY PART	48000.00	HON-CTK-2436	2026-06-18 17:47:31.403	\N
50b0774d-52a9-417d-b650-e165c834dbdd	COVER TANGKI / COVER MESIN BEAT ESP 16 / BEAT STREET 16	\N	0	HONDA	36000.00	COVER TANGKI	2026-06-18 17:47:31.403	BODY PART	36000.00	HON-CTK-2437	2026-06-18 17:47:31.403	\N
94646687-d146-4ef6-927e-e633d5ef82f3	COVER TANGKI / COVER MESIN SCOOPY FI / SCOOPY FI ESP HITAM	\N	0	HONDA	136000.00	COVER TANGKI	2026-06-18 17:47:31.403	BODY PART	136000.00	HON-CTK-2438	2026-06-18 17:47:31.403	\N
1145d24b-1673-4ae9-a6dc-e81e9dc2f6dc	COVER TANGKI / COVER MESIN SCOOPY FI / SCOOPY FI ESP KREM	\N	0	HONDA	154000.00	COVER TANGKI	2026-06-18 17:47:31.403	BODY PART	154000.00	HON-CTK-2439	2026-06-18 17:47:31.403	\N
edea8fae-64a8-4c07-a111-bd7477d29a44	COVER TANGKI / COVER MESIN SCOOPY FI / SCOOPY FI ESP MERAH	\N	0	HONDA	154000.00	COVER TANGKI	2026-06-18 17:47:31.403	BODY PART	154000.00	HON-CTK-2440	2026-06-18 17:47:31.403	\N
ac89c407-44b7-4909-8cc1-034c3b1c84ca	COVER TANGKI / COVER MESIN SCOOPY FI / SCOOPY FI ESP PUTIH	\N	0	HONDA	154000.00	COVER TANGKI	2026-06-18 17:47:31.403	BODY PART	154000.00	HON-CTK-2441	2026-06-18 17:47:31.403	\N
a24798ec-90a6-451d-a6d3-acb0b6b1a2cb	COVER RADIATOR VARIO 160 / PCX 160 / STYLO 160	\N	0	HONDA	44000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	44000.00	HON-OTH-2442	2026-06-18 17:47:31.403	\N
d1193b04-fcbc-43d2-9e25-adc024e610ca	COVER MESIN SET BEAT 20 / SCOOPY 20 / BEAT STREET 20 / BEAT 24 / BEAT STREET 24	\N	0	HONDA	56000.00	COVER TANGKI	2026-06-18 17:47:31.403	BODY PART	56000.00	HON-CTK-2443	2026-06-18 17:47:31.403	\N
e16b5b95-47ec-4e4c-819f-532bebeccb55	COVER MESIN SET BEAT ESP 16 / SCOOPY FI 17 / BEAT STREET 16	\N	0	HONDA	52000.00	COVER TANGKI	2026-06-18 17:47:31.403	BODY PART	52000.00	HON-CTK-2444	2026-06-18 17:47:31.403	\N
cmlezxmrf024839t5e9gn3f5o	HANDFAT SUPRA / SUPRA X / SUPRA XX / SUPRA FIT	\N	0	HONDA	21000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	26000.00	HON-TUT-HAN-1381	2026-06-18 17:22:17.168	\N
3efb90bf-03b2-4417-ba95-289a7134ac56	COVER MESIN SET BEAT FI / SCOOPY FI	\N	0	HONDA	51000.00	COVER TANGKI	2026-06-18 17:47:31.403	BODY PART	51000.00	HON-CTK-2445	2026-06-18 17:47:31.403	\N
cmlezxmti024d39t5l63b8nor	HANDFAT GRAND / LEGENDA / LEGENDA 2 / ASTREA STAR / PRIMA / IMPRESSA	\N	0	HONDA	18000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	22000.00	HON-TUT-HAN-1382	2026-06-18 17:22:17.168	\N
9886c662-c85c-4c72-9da2-49a4b3ed47a9	COVER MESIN SET BEAT FI ESP / VARIO 110 ESP / BEAT POP	\N	0	HONDA	41000.00	COVER TANGKI	2026-06-18 17:47:31.403	BODY PART	41000.00	HON-CTK-2446	2026-06-18 17:47:31.403	\N
cmlezxlz1022839t5zmofapyu	TUTUP AKI BEAT 20	\N	0	HONDA	29000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	28000.00	HON-TUT-TUT-1341	2026-06-18 17:22:17.168	\N
c4acbbcd-ff8f-484e-a718-32cc27572ded	COVER MESIN SET BEAT / BEAT 10 / SCOOPY / SPACY KARBU	\N	0	HONDA	41000.00	COVER TANGKI	2026-06-18 17:47:31.403	BODY PART	41000.00	HON-CTK-2447	2026-06-18 17:47:31.403	\N
36c58a22-7e6a-489f-953f-8a4c11a39030	COVER FOOTSTEP SCOOPY FI 17	\N	0	HONDA	24000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	24000.00	HON-OTH-2448	2026-06-18 17:47:31.403	\N
1c476fe2-ebaa-4cd7-a677-b723c21f1626	COVER CHARGER / CHASAN BEAT 20 / BEAT STREET 20	\N	0	HONDA	39000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	39000.00	HON-OTH-2449	2026-06-18 17:47:31.403	\N
eebbc19a-f649-440c-8c66-b2ab0982fcc5	CHAIN COVER / TUTUP RANTAI ABSOLUTE REVO / BLADE	\N	0	HONDA	27000.00	TUTUP	2026-06-18 17:47:31.403	BODY PART	27000.00	HON-TUT-2450	2026-06-18 17:47:31.403	\N
cmlezxllu021c39t56ihipi00	TUTUP KNALPOT SCOOPY 20 HITAM	\N	0	HONDA	59000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	68000.00	HON-TUT-TUT-1315	2026-06-18 17:27:37.767	\N
cmlezxn5d025439t59qmwdqxq	PIPA GAS BEAT 20/BEAT ESP 16/VARIO 125 FI ESP/VARIO 150/VARIO 150 18/SCOPPY FI 17/SCOOPY FI 20/GENIO	\N	0	HONDA	10000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	12900.00	HON-TUT-PIP-1395	2026-06-18 17:27:37.767	\N
cmlezxonf027o39t5u3dzfhgk	SWITCH REM BELAKANG ABSOLUTE REVO	\N	0	HONDA	11000.00	SWITCH REM	2026-02-09 09:55:22.865	KELISTRIKAN	10000.00	HON-TUT-SWI-1413	2026-06-18 17:34:05.97	\N
d74b4b44-eeb3-4ed4-8b43-d5686edbd23f	CHAIN COVER / TUTUP RANTAI SUPRA X 125 / KARISMA X / SUPRA X 125 07	\N	0	HONDA	24000.00	TUTUP	2026-06-18 17:47:31.403	BODY PART	24000.00	HON-TUT-2451	2026-06-18 17:47:31.403	\N
abc40d1e-30ce-4562-b973-fadbe1cd3fb3	TUTUP KIPAS BEAT ESP 16 / BEAT STREET 16 / BEAT POP / BEAT FI ESP / SCOOPY FI ESP / SCOOPY FI 17 / VARIO 110 FI ESP	\N	0	HONDA	33000.00	TUTUP	2026-06-18 17:47:31.403	BODY PART	33000.00	HON-TUT-2452	2026-06-18 17:47:31.403	\N
679db3b5-7b1d-44d8-ada8-0c7654278ac2	TUTUP KIPAS BEAT FI / SCOOPY FI / SPACY FI / SPACY KARBU	\N	0	HONDA	26000.00	TUTUP	2026-06-18 17:47:31.403	BODY PART	26000.00	HON-TUT-2453	2026-06-18 17:47:31.403	\N
4393420f-a63d-477c-8198-46387717aeb2	TUTUP KIPAS BEAT / BEAT 10	\N	0	HONDA	19000.00	TUTUP	2026-06-18 17:47:31.403	BODY PART	19000.00	HON-TUT-2454	2026-06-18 17:47:31.403	\N
cmlezxik401wc39t5uhcnp26x	FOOTREST BAWAH SCOOPY FI 17 R+L GRAY DOFF	\N	0	HONDA	205000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	232000.00	HON-LEG-FOO-1257	2026-02-09 09:55:15.055	\N
cmlezx18j00xn39t5xyorbs1y	REAR HANDLE / BATOK BELAKANG COVER BEAT FI	\N	0	HONDA	28000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	31000.00	HON-REA-REA-613	2026-06-19 22:07:01.322	01B3830100AA1
cmlezxmzt024s39t5y441qbu9	HANDFAT L/R GL PRO NEOTECH	\N	0	HONDA	18000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	17000.00	HON-TUT-HAN-1383	2026-06-18 17:19:42.083	\N
cmlezxizn01x939t5jql8crxq	GARNIS VARIO 150 18	\N	0	HONDA	27000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	48000.00	HON-LEG-GAR-1275	2026-02-09 09:55:15.055	\N
cmlezxn5d025639t5ofr04k9j	PIPA GAS REVO FI	\N	0	HONDA	9000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	9000.00	HON-TUT-PIP-1398	2026-06-18 17:19:42.083	\N
cmlezxjxe01zm39t5hod0gbpg	FOOTREST ATAS + TUTUP AKI SCOOPY FI 17	\N	0	HONDA	121000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	125000.00	HON-LEG-FOO-1223	2026-02-09 09:55:15.055	\N
cmlezxlvy022239t5jt6ev037	TUTUP AKI SCOOPY FI ESP	\N	0	HONDA	27000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	29000.00	HON-TUT-TUT-1337	2026-06-18 17:22:17.168	\N
cmlezxlr2021o39t58pt4ovyf	TUTUP AKI	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	23000.00	HON-TUT-TUT-1332	2026-02-09 09:55:18.839	\N
cmlezxo4j026g39t5c376ogew	PIPA GAS ABSOLUTE REVO / ABSOLUTE REVO FIT / SUPRA X 125 HELM IN	\N	0	HONDA	9000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	11900.00	HON-TUT-PIP-1403	2026-06-18 17:27:37.767	\N
cmlezxoaq026w39t56g9phjzj	PIPA GAS BEAT / BEAT 10 / VARIO TECHNO / VARIO	\N	0	HONDA	9000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	11900.00	HON-TUT-PIP-1404	2026-06-18 17:27:37.767	\N
cmlezxnxs025t39t55fnslw29	PIPA GAS SUPRA X 125 / SUPRA X 125 07 / KARISMA / KARISMA X	\N	0	HONDA	9000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	11900.00	HON-TUT-PIP-1405	2026-06-18 17:27:37.767	\N
cmlezxm06022c39t57ooszqgi	TUTUP AKI BEAT POP	\N	0	HONDA	94000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	23000.00	HON-TUT-TUT-1343	2026-02-09 09:55:18.839	\N
cmlezx58u015a39t5ke9m2tyy	COVER SPEEDOMETER BEAT 20 HITAM	\N	0	HONDA	65000.00	COVER SPEEDOMETER	2026-02-09 09:54:56.889	BODY PART	68000.00	HON-COV-COV-730	2026-06-19 22:07:01.457	01B5906340AA1
cmlezxmvj024i39t5hje474v8	MINI REFLEKTOR /	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	16000.00	HON-TUT-MIN-1390	2026-02-09 09:55:18.839	\N
cmlezxn0z024w39t5ndpobvcn	MINI REFLECTOR Rr SUPRA X	\N	0	HONDA	12000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	16000.00	HON-TUT-MIN-1392	2026-02-09 09:55:18.839	\N
cmlezxn6n025e39t5mtscndwh	MINI REFLECTOR Rr GRAND	\N	0	HONDA	12000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	16000.00	HON-TUT-MIN-1393	2026-02-09 09:55:18.839	\N
6dd97677-1807-493d-9d1a-9a81012f0e8e	DUDUKAN RADIATOR VARIO 150 18 / 125 18 / 125 23	\N	0	HONDA	45000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	45000.00	HON-OTH-2493	2026-06-18 17:47:31.403	\N
b27e61d5-afc6-43da-a49c-445e12ddbec2	DUDUKAN RADIATOR VARIO 150 / VARIO 125 / VARIO TECHNO 125	\N	0	HONDA	45000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	45000.00	HON-OTH-2494	2026-06-18 17:47:31.403	\N
698deaa8-6ca6-4018-b931-f5f11d6d8d0e	GARNIS VARIO 125 23	\N	0	HONDA	54000.00	GARNIS	2026-06-18 17:47:31.403	BODY PART	54000.00	HON-GAR-2495	2026-06-18 17:47:31.403	\N
c7ef5a04-648b-45d0-9975-16357f2c1718	COVER HANDLE TOP VARIO 125 23 HITAM	\N	0	HONDA	87000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	87000.00	HON-OTH-2496	2026-06-18 17:47:31.403	\N
8adc6042-4f13-4c58-9158-20372e59c70e	COVER HANDLE TOP VARIO 125 23 HITAM DOFF	\N	0	HONDA	98000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	98000.00	HON-OTH-2497	2026-06-18 17:47:31.403	\N
a68fd838-24c6-4411-850c-932e8ad7eb09	COVER HANDLE TOP VARIO 125 23 MERAH	\N	0	HONDA	98000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	98000.00	HON-OTH-2498	2026-06-18 17:47:31.403	\N
db0d08c9-17c5-4e4d-9052-72fe3de72729	COVER HANDLE TOP VARIO 125 23 BIRU DOFF	\N	0	HONDA	98000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	98000.00	HON-OTH-2499	2026-06-18 17:47:31.403	\N
cmlezxidx01vo39t54igg5aqt	FOOTREST BAWAH VARIO 150 18 B R+L HITAM	\N	0	HONDA	258000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	277000.00	HON-LEG-FOO-1247	2026-06-18 17:22:17.168	\N
cmlezxjg201yc39t553ebspnz	FOOTREST BAWAH VARIO 150 18 B R+L PUTIH	\N	0	HONDA	292000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	313000.00	HON-LEG-FOO-1251	2026-06-18 17:22:17.168	\N
cmlezxm3s022i39t55x22xh87	DUDUKAN RADIATOR VARIO 150 18 / 125 23	\N	0	HONDA	38000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	45000.00	HON-TUT-DUD-1345	2026-06-18 17:22:17.168	\N
21791102-87c3-4a51-8ef4-5edfcaf235e9	COVER HANDLE TOP VARIO 125 23 PUTIH DOFF	\N	0	HONDA	98000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	98000.00	HON-OTH-2500	2026-06-18 17:47:31.403	\N
db91cc71-1d29-4fe2-8130-9e20d9ae5647	LAMPU DEPAN / HEAD LAMP VARIO 125 23 + LED	\N	0	HONDA	915000.00	LAMPU DEPAN	2026-06-18 17:47:31.403	KELISTRIKAN	915000.00	HON-LDP-2501	2026-06-18 17:47:31.403	\N
cmlezxi5001vc39t5801hxf76	FOOTREST BAWAH VARIO 150 18 B R+L SILVER	\N	0	HONDA	290000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	322000.00	HON-LEG-FOO-1245	2026-06-18 17:22:17.168	\N
fa6a69e9-e747-4098-ac4b-5842a7cf5a31	LAMPU DEPAN / HEAD LAMP SCOOPY 20 + LED	\N	0	HONDA	693000.00	LAMPU DEPAN	2026-06-18 17:47:31.403	KELISTRIKAN	693000.00	HON-LDP-2502	2026-06-18 17:47:31.403	\N
da7d548e-8c0e-44bd-9bb0-4065f361349c	LAMPU DEPAN / HEAD LAMP GENIO / GENIO 22 / GENIO 25 + LED	\N	0	HONDA	706000.00	LAMPU DEPAN	2026-06-18 17:47:31.403	KELISTRIKAN	706000.00	HON-LDP-2503	2026-06-18 17:47:31.403	\N
a0c803fe-e32a-4afc-8ad4-b8d69c6445fb	LAMPU DEPAN / HEAD LAMP BEAT / BEAT 10	\N	0	HONDA	84000.00	LAMPU DEPAN	2026-06-18 17:47:31.403	KELISTRIKAN	84000.00	HON-LDP-2504	2026-06-18 17:47:31.403	\N
ac6f5582-b252-4757-aac2-2d7981517701	LAMPU DEPAN / HEAD LAMP GRAND / IMPRESSA	\N	0	HONDA	55000.00	LAMPU DEPAN	2026-06-18 17:47:31.403	KELISTRIKAN	55000.00	HON-LDP-2505	2026-06-18 17:47:31.403	\N
d1a9fe05-ce5d-40cc-bcdd-70f65470f702	LAMPU DEPAN / HEAD LAMP SATRIA FU 150 FI 16 + LED	\N	0	HONDA	571000.00	LAMPU DEPAN	2026-06-18 17:47:31.403	KELISTRIKAN	571000.00	HON-LDP-2506	2026-06-18 17:47:31.403	\N
9767cdc1-dc4a-47d6-b204-d611350dab53	LAMPU DEPAN / HEAD LAMP SATRIA FU 150 14	\N	0	HONDA	153000.00	LAMPU DEPAN	2026-06-18 17:47:31.403	KELISTRIKAN	153000.00	HON-LDP-2507	2026-06-18 17:47:31.403	\N
cmlezxlz2022a39t5hiwbp4xr	TUTUP AKI VARIO 110 FI ESP	\N	0	HONDA	25000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	31000.00	HON-TUT-TUT-1342	2026-06-18 17:27:37.767	\N
cmlezxo3v026839t5a3a7o8q0	PIPA GAS SUPRA / SUPRA X / SUPRA FIT / SUPRA V / SUPRA XX	\N	0	HONDA	10000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	13300.00	HON-TUT-PIP-1406	2026-06-18 17:27:37.767	\N
cmlezxo6j026m39t5id95wpyi	PIPA GAS TIGER	\N	0	HONDA	9000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	9000.00	HON-TUT-PIP-1407	2026-06-18 17:27:37.767	\N
cmlezxonf027m39t5b6bi32pd	SWITCH REM BELAKANG TIGER	\N	0	HONDA	12000.00	SWITCH REM	2026-02-09 09:55:22.865	KELISTRIKAN	10000.00	HON-TUT-SWI-1415	2026-06-18 17:34:05.97	\N
28d015ef-37bd-49d6-8f4a-955cc5c0cd77	FOOTREST BAWAH / UNDERSIDE BEAT FI ESP A	\N	0	HONDA	42000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	42000.00	HON-FOT-2486	2026-06-18 22:23:48.216	\N
cmlezxb6p01gk39t5avdtet8p	FRONT FROK COVER / TUTUP GARPU SUPRA X / FIT CAKRAM HITAM	\N	0	HONDA	0.00	FRONT FROK COVER / TUTUP GARPU (HONDA)	2026-02-09 09:55:04.847	BODY PART	54000.00	HON-FRO-FRO-962	2026-06-19 22:07:01.589	01B1331340AA1
cmlezxco801jq39t5ed46r6h0	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT BEAT POP	\N	0	HONDA	140000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.264	KELISTRIKAN	143000.00	HON-STO-STO-1009	2026-06-19 22:07:01.719	01B4003020AA1
cmlezxco801jv39t544mx1p8n	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT VARIO 150	\N	0	HONDA	190000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.264	KELISTRIKAN	193000.00	HON-STO-STO-1010	2026-06-19 22:07:01.851	01B4402820AA1
cmlezxcub01k239t52xkhxw4u	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT VARIO	\N	0	HONDA	121000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	124000.00	HON-STO-STO-1011	2026-06-19 22:07:01.979	01B2203000AA1
cmlezxd7a01l739t5ly88utlb	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT VARIO TECHNO 125	\N	0	HONDA	143000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	146000.00	HON-STO-STO-1014	2026-06-19 22:07:02.105	01B3603000AA1
cmlezxdm601ma39t5jz6k5rzk	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT GRAND (C/M)	\N	0	HONDA	71000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.265	KELISTRIKAN	74000.00	HON-STO-STO-1030	2026-06-19 22:07:02.235	01B0803022AA1
cmlezxl67020q39t5nc505x9a	TUTUP KNALPOT /	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	59000.00	HON-TUT-TUT-1314	2026-02-09 09:55:18.839	\N
cmlezxoa4026t39t55owvcpkd	FILTER UDARA VARIO	\N	0	HONDA	22000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	41000.00	HON-TUT-FIL-1434	2026-02-09 09:55:22.865	\N
cmlezxonp027u39t5z9g1zl2x	KARET BARSTEP F1	\N	0	HONDA	15000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	8800.00	HON-TUT-KAR-1446	2026-02-09 09:55:22.865	\N
20300c24-19a8-4690-9142-3fa6d90c59b4	LAMPU DEPAN / HEAD LAMP NEX / NEX FI	\N	0	HONDA	108000.00	LAMPU DEPAN	2026-06-18 17:47:31.403	KELISTRIKAN	108000.00	HON-LDP-2508	2026-06-18 17:47:31.403	\N
2e83a641-4fbc-431a-9433-8d2f17c3106f	MIKA LAMPU GRAND / IMPRESSA	\N	0	HONDA	26000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	26000.00	HON-MIK-2509	2026-06-18 17:47:31.403	\N
e1461cee-862f-433a-b37f-1b40ff49f857	MIKA SPEEDOMETER BEAT 20 / BEAT 24	\N	0	HONDA	42000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	42000.00	HON-MIK-2510	2026-06-18 17:47:31.403	\N
da244dd6-8b91-400e-b643-466f42b9b51e	MIKA SPEEDOMETER VARIO 150 18 / VARIO 125 18 / 125 23	\N	0	HONDA	47000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	47000.00	HON-MIK-2511	2026-06-18 17:47:31.403	\N
ede05a88-01db-41dd-b336-c87d67480e1e	MIKA SPEEDOMETER VARIO 150 / VARIO 125	\N	0	HONDA	43000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	43000.00	HON-MIK-2512	2026-06-18 17:47:31.403	\N
be79b796-6cd4-43b6-9b51-6f0018f82850	MIKA SPEEDOMETER VARIO 110 FI / VARIO 110 FI ESP	\N	0	HONDA	31000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	31000.00	HON-MIK-2513	2026-06-18 17:47:31.403	\N
2cef3979-b4ab-46b2-9a0f-847bd6d2a20a	MIKA SPEEDOMETER SCOOPY FI / SCOOPY FI ESP	\N	0	HONDA	27000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	27000.00	HON-MIK-2514	2026-06-18 17:47:31.403	\N
78b94819-3368-456b-9128-c90c2ceeb812	MIKA SPEEDOMETER BEAT FI / BEAT FI ESP / BEAT POP	\N	0	HONDA	40000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	40000.00	HON-MIK-2515	2026-06-18 17:47:31.403	\N
b5578916-7afa-4433-9ed5-655a8247848b	MIKA SPEEDOMETER SPACY / SPACY FI	\N	0	HONDA	30000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	30000.00	HON-MIK-2516	2026-06-18 17:47:31.403	\N
2d970178-aa3b-4c3b-a4af-61a6b19a1161	MIKA SPEEDOMETER ABSOLUTE REVO / ABSOLUTE REVO FIT	\N	0	HONDA	33000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	33000.00	HON-MIK-2517	2026-06-18 17:47:31.403	\N
0abfa83d-d7dd-4466-9519-d16285ecb983	MIKA SPEEDOMETER BEAT / BEAT 10	\N	0	HONDA	31000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	31000.00	HON-MIK-2518	2026-06-18 17:47:31.403	\N
6f90296e-92f8-43dc-83e3-4ec587ec2c56	MIKA SPEEDOMETER SUPRA X 125 / SUPRA X 125 07+ INNER	\N	0	HONDA	34000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	34000.00	HON-MIK-2519	2026-06-18 17:47:31.403	\N
cmlezxp0j028s39t5nh72lza9	UKURAN OLI SUPRA	\N	0	HONDA	9000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	9000.00	HON-TUT-UKU-1422	2026-06-18 17:19:42.083	\N
cmlezxj2q01xe39t5tp7ky379	FOOTREST BAWAH VARIO 110 FI B R+L	\N	0	HONDA	69000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	69000.00	HON-LEG-FOO-1235	2026-02-09 09:55:15.055	\N
cmlezxla9020w39t59v0c2siz	TUTUP KNALPOT SCOOPY	\N	0	HONDA	40000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	59000.00	HON-TUT-TUT-1319	2026-02-09 09:55:18.839	\N
cmlezxm4e022o39t5tblstsez	VISOR PCX 150 18	\N	0	HONDA	228000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	5800.00	HON-TUT-VIS-1349	2026-02-09 09:55:18.839	\N
cmlezxm9q023039t5hv396xp8	REAR WINKER UNIT SCOOPY FI 17	\N	0	HONDA	134000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	134000.00	HON-TUT-REA-1353	2026-02-09 09:55:18.839	\N
cmlezxn7t025i39t5actk4csl	KARET BARSTEP ABSOLUTE REVO	\N	0	HONDA	20000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	8800.00	HON-TUT-KAR-1386	2026-02-09 09:55:18.839	\N
cmlezxkty020a39t5hdtx0wad	CHAIN COVER / TUTUP RANTAI	\N	0	HONDA	0.00	COVER MESIN SET BEAT FI ESP / VARIO 110 ESP / BEAT POP	2026-02-09 09:55:18.838	BODY PART	21000.00	HON-COV-CHA-1305	2026-06-18 17:19:42.083	\N
51fd5bff-0af2-4ee7-a05d-d8ea2fc72d13	MIKA SPEEDOMETER KARISMA / KARISMA X	\N	0	HONDA	35000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	35000.00	HON-MIK-2520	2026-06-18 17:47:31.403	\N
cmlezxoh7027e39t5afrhs220	PIPA GAS GL PRO / GL MAX	\N	0	HONDA	10000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	9000.00	HON-TUT-PIP-1409	2026-06-18 17:27:37.767	\N
cmlezxp6i028y39t5pkvfflmv	SWITCH REM BELAKANG SUPRA	\N	0	HONDA	11000.00	SWITCH REM	2026-02-09 09:55:22.865	KELISTRIKAN	10000.00	HON-TUT-SWI-1418	2026-06-18 17:34:05.97	\N
cmlezxoot027y39t51wx4xzqp	SWITCH REM BELAKANG KARISMA	\N	0	HONDA	12000.00	SWITCH REM	2026-02-09 09:55:22.865	KELISTRIKAN	10000.00	HON-TUT-SWI-1414	2026-06-18 17:34:05.97	\N
22356fa2-9d1d-4c6e-9a27-316ebda2a662	MIKA SPEEDOMETER SUPRA FIT NEW / FIT NEW S + INNER	\N	0	HONDA	33000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	33000.00	HON-MIK-2521	2026-06-18 17:47:31.403	\N
d53fe259-e171-49eb-8896-466f6ceef80d	MIKA SPEEDOMETER SUPRA / SUPRA FIT	\N	0	HONDA	33000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	33000.00	HON-MIK-2522	2026-06-18 17:47:31.403	\N
cmlezxln8021f39t5tk4io9z7	TUTUP KNALPOT SCOOPY FI HITAM	\N	0	HONDA	42000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	59000.00	HON-TUT-TUT-1328	2026-02-09 09:55:18.839	\N
cmlezxlyf022439t5q6n4710t	TUTUP AKI BEAT FI	\N	0	HONDA	23000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	23000.00	HON-TUT-TUT-1339	2026-02-09 09:55:18.839	\N
95c14a0f-a4d8-41e6-baf0-3d416e03c7ba	MIKA SPEEDOMETER GRAND / IMPRESSA	\N	0	HONDA	32000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	32000.00	HON-MIK-2523	2026-06-18 17:47:31.403	\N
44d7726d-3c2c-478d-8172-aaf9baab49c6	MIKA SEN Fr / MIKA SEN DEPAN BEAT 20 / BEAT STREET 20	\N	0	HONDA	49000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	49000.00	HON-MIK-2524	2026-06-18 17:47:31.403	\N
11399c52-b2d8-447d-ab8e-d5fa853fc1bc	MIKA SEN Rr / MIKA SEN BELAKANG + STOP VARIO 150 / VARIO 125 (P/M)	\N	0	HONDA	87000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	87000.00	HON-MIK-2525	2026-06-18 17:47:31.403	\N
cmlezxi5o01ve39t5w278f94m	FOOTREST BAWAH VARIO 150 18 / 125 23 A	\N	0	HONDA	47000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	47000.00	HON-LEG-FOO-1246	2026-06-18 17:19:42.083	\N
f9bc03ee-d846-4f71-8691-1ea1fb11d7f9	MIKA SEN Fr / MIKA SEN DEPAN SPACY / SPACY FI	\N	0	HONDA	103000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	103000.00	HON-MIK-2526	2026-06-18 17:47:31.403	\N
4c15abf4-9df9-42a8-8a64-4fe8920b256b	MIKA SEN Fr / MIKA SEN DEPAN SUPRA X 125 HELM IN	\N	0	HONDA	47000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	47000.00	HON-MIK-2527	2026-06-18 17:47:31.403	\N
20e0e81e-c64f-4d70-ae1c-b07de1723956	MIKA SEN Fr / MIKA SEN DEPAN PRIMA (C/P) KO	\N	0	HONDA	52000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	52000.00	HON-MIK-2528	2026-06-18 17:47:31.403	\N
55cb4da1-f379-40e6-942b-0078df57e29f	MIKA STOP / MIKA BELAKANG VARIO 160 BESAR (M) + KECIL (P)	\N	0	HONDA	190000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	190000.00	HON-MIK-2529	2026-06-18 17:47:31.403	\N
7ff6079c-c554-4c48-9549-1dd859267594	MIKA STOP / MIKA BELAKANG GL PRO KO / GL MAX	\N	0	HONDA	44000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	44000.00	HON-MIK-2530	2026-06-18 17:47:31.403	\N
3dca7e42-83ed-46ac-82cc-71f6c2c02057	REAR WINKER / SEN BELAKANG UNIT SCOOPY 20	\N	0	HONDA	123000.00	WINKER	2026-06-18 17:47:31.403	KELISTRIKAN	123000.00	HON-WINK-2531	2026-06-18 17:47:31.403	\N
df5fccf3-5ff8-42d7-a2f3-686c038c84ff	FRONT WINKER / SEN DEPAN UNIT BEAT 20 / BEAT STREET 20	\N	0	HONDA	92000.00	WINKER	2026-06-18 17:47:31.403	KELISTRIKAN	92000.00	HON-WINK-2532	2026-06-18 17:47:31.403	\N
b0c39c8c-4d4e-4bad-b560-4fe9b28db6b0	FRONT WINKER / SEN DEPAN UNIT BEAT ESP 16 / BEAT STREET 16	\N	0	HONDA	80000.00	WINKER	2026-06-18 17:47:31.403	KELISTRIKAN	80000.00	HON-WINK-2533	2026-06-18 17:47:31.403	\N
2e45019b-2911-482e-9a89-d2d40d13ae8c	FRONT WINKER / SEN DEPAN UNIT BEAT FI / BEAT FI ESP	\N	0	HONDA	85000.00	WINKER	2026-06-18 17:47:31.403	KELISTRIKAN	85000.00	HON-WINK-2534	2026-06-18 17:47:31.403	\N
cmlezxkty020m39t5fwkqp098	CHAIN COVER ABSOLUTE REVO	\N	0	HONDA	21000.00	COVER MESIN SET BEAT FI ESP / VARIO 110 ESP / BEAT POP	2026-02-09 09:55:18.838	BODY PART	40000.00	HON-COV-CHA-1306	2026-06-18 17:19:42.083	\N
690375c8-8b8f-4371-9684-445cfae9d6fd	FRONT WINKER / SEN DEPAN ASSY SPACY / SPACY FI	\N	0	HONDA	171000.00	WINKER	2026-06-18 17:47:31.403	KELISTRIKAN	171000.00	HON-WINK-2535	2026-06-18 17:47:31.403	\N
cb1c13a0-5ea1-4cb9-b60c-f3f2a1a8e958	FRONT WINKER / SEN DEPAN ASSY SUPRA X 125 HELM IN	\N	0	HONDA	140000.00	WINKER	2026-06-18 17:47:31.403	KELISTRIKAN	140000.00	HON-WINK-2536	2026-06-18 17:47:31.403	\N
cmlezxfj901qo39t50ykib2f1	LEGSHIELD LUAR / SAYAP LUAR SCOOPY FI 17 HIJAU	\N	0	HONDA	258000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	35000.00	HON-LEG-LEG-1112	2026-06-18 17:19:42.083	\N
2430d878-fb69-4948-9534-3fc93b052e11	FRONT WINKER / SEN DEPAN ASSY BLADE	\N	0	HONDA	71000.00	WINKER	2026-06-18 17:47:31.403	KELISTRIKAN	71000.00	HON-WINK-2537	2026-06-18 17:47:31.403	\N
eadd2246-8e72-466d-905e-9314624e5ff7	FRONT WINKER / SEN DEPAN ASSY SUPRA X 125 07	\N	0	HONDA	59000.00	WINKER	2026-06-18 17:47:31.403	KELISTRIKAN	59000.00	HON-WINK-2538	2026-06-18 17:47:31.403	\N
b88e4d9b-5834-4cc3-8ec8-d9314c4aa397	Fr / Rr WINKER / SEN KANAN KIRI ASSY CB 150 VERZA / VERZA 150 (2013 - 2018)	\N	0	HONDA	109000.00	WINKER	2026-06-18 17:47:31.403	KELISTRIKAN	109000.00	HON-WINK-2539	2026-06-18 17:47:31.403	\N
df0b9602-1ce5-4f84-865f-d19d5e432172	Fr / Rr WINKER / SEN KANAN KIRI ASSY CB 150 R NEW VARIASI	\N	0	HONDA	98000.00	WINKER	2026-06-18 17:47:31.403	KELISTRIKAN	98000.00	HON-WINK-2540	2026-06-18 17:47:31.403	\N
d5a08b4a-871c-4ef9-9b1e-9e1b9ca44e77	Fr / Rr WINKER / SEN KANAN KIRI ASSY MEGAPRO 06 / MEGA PRO LAMA / TIGER	\N	0	HONDA	101000.00	WINKER	2026-06-18 17:47:31.403	KELISTRIKAN	101000.00	HON-WINK-2541	2026-06-18 17:47:31.403	\N
cmlezxlab020y39t5vdtr077z	TUTUP KNALPOT SPACY	\N	0	HONDA	41000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	59000.00	HON-TUT-TUT-1318	2026-02-09 09:55:18.839	\N
46cc5ed9-7c1c-4857-a83b-a56ef36dc651	Fr / Rr WINKER / SEN KANAN KIRI ASSY GL PRO / GL MAX (C)	\N	0	HONDA	60000.00	WINKER	2026-06-18 17:47:31.403	KELISTRIKAN	60000.00	HON-WINK-2542	2026-06-18 17:47:31.403	\N
cmlezxikr01wi39t5alfrpz4r	FOOTREST ATAS + TUTUP AKI SCOOPY FI 17 COKLAT	\N	0	HONDA	126000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	126000.00	HON-LEG-FOO-1219	2026-02-09 09:55:15.055	\N
11d25dd3-9eef-4944-9eaa-ae17f8139d53	REAR WINKER / SEN BELAKANG ASSY C 700	\N	0	HONDA	62000.00	WINKER	2026-06-18 17:47:31.403	KELISTRIKAN	62000.00	HON-WINK-2543	2026-06-18 17:47:31.403	\N
cmlezxl67020o39t5nufecs27	TUTUP KNALPOT SCOOPY FI SILVER	\N	0	HONDA	52000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	59000.00	HON-TUT-TUT-1317	2026-02-09 09:55:18.839	\N
50c1ab0d-f116-4686-acf7-0dbdae5530ad	STOP LAMP / LAMPU STOP ASSY CB 150 VERZA / VERZA 150 (2013 - 2018)	\N	0	HONDA	147000.00	STOP LAMP	2026-06-18 17:47:31.403	KELISTRIKAN	147000.00	HON-STL-2544	2026-06-18 17:47:31.403	\N
afc56557-944a-4b3a-ad81-75b746cbaaf8	STOP LAMP / LAMPU STOP ASSY SCOOPY FI 17	\N	0	HONDA	154000.00	STOP LAMP	2026-06-18 17:47:31.403	KELISTRIKAN	154000.00	HON-STL-2545	2026-06-18 17:47:31.403	\N
ccc64afc-d803-44e5-b954-a321c0135447	STOP LAMP / LAMPU STOP ASSY VARIO 150 / VARIO 125	\N	0	HONDA	212000.00	STOP LAMP	2026-06-18 17:47:31.403	KELISTRIKAN	212000.00	HON-STL-2546	2026-06-18 17:47:31.403	\N
cmlezxlg1021439t5zbg40ak4	TUTUP KNALPOT BEAT ESP 16	\N	0	HONDA	38000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	23000.00	HON-TUT-TUT-1324	2026-02-09 09:55:18.839	\N
cmlezxgv701ti39t5juiqzylp	LEGSHIELD LUAR / SAYAP LUAR SCOOPY FI 17 MERAH	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	230000.00	HON-LEG-LEG-1108	2026-06-19 22:07:02.7	01B4831881AA1
cmlezxfze01rw39t5ltsvrefb	LEGSHIELD DALAM / INNER UPPER SCOOPY FI 17 KECIL HITAM	\N	0	HONDA	0.00	LEGSHIELD DALAM /	2026-02-09 09:55:11.246	BODY PART	44000.00	HON-LEG-LEG-1157	2026-06-19 22:07:02.832	01B4836040AA1
cmlezxfrx01ra39t53t2u27er	LEGSHIELD DALAM / INNER UPPER SCOOPY FI 17 KECIL PUTIH	\N	0	HONDA	0.00	LEGSHIELD DALAM /	2026-02-09 09:55:11.246	BODY PART	60000.00	HON-LEG-LEG-1156	2026-06-19 22:07:02.975	01B4836047AA1
cmlezwug800km39t54x6dxddv	PANEL / TAMENGVARIO 150 18 BESAR HITAM	\N	0	HONDA	171000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	158000.00	HON-PAN-PAN-376	2026-06-19 22:07:03.108	01B5230540AA1
cmlezwudf00ki39t52zkz98lc	PANEL / TAMENGVARIO 150 18 BESAR HITAM DOFF	\N	0	HONDA	195000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	179000.00	HON-PAN-PAN-377	2026-06-19 22:07:03.242	01B5230580AA1
cmlezxgbr01sk39t5zcmkfc5n	LEGSHIELD DALAM BEAT / BEAT 10 BESAR	\N	0	HONDA	61000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	64000.00	HON-LEG-LEG-1159	2026-06-19 22:07:03.376	01B2735282AA1
cmlezxgev01su39t5s8njlyjj	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU DALAM BEAT POP	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	99000.00	HON-LEG-LEG-1160	2026-06-19 22:07:03.509	01B4035282AA1
cmlezxfv301rk39t57gzr6vv3	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM VARIO 150 18 KECIL MERAH	\N	0	HONDA	127000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	137000.00	HON-LEG-LEG-1165	2026-06-19 22:07:03.642	01B5236781AA1
cmlezxftt01rf39t58mjv7i95	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM VARIO 150 18 KECIL GRAY/KUPU KUPU	\N	0	HONDA	92000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	95000.00	HON-LEG-LEG-1164	2026-06-19 22:07:03.768	01B4436765AA1
cmlezxg2z01s639t5uzvw9wi2	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM VARIO 150 18 KECIL MERAH DOFF	\N	0	HONDA	121000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	124000.00	HON-LEG-LEG-1166	2026-06-19 22:07:04.252	01B5236787AA1
cmlezxge901sq39t5h4zrknu7	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM VARIO	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	73000.00	HON-LEG-LEG-1167	2026-06-19 22:07:04.858	01B2235282AA1
cmlezxh3o01u439t5kf8honx1	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM VARIO 150 18 BESAR HITAM	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.247	BODY PART	116000.00	HON-LEG-LEG-1169	2026-06-19 22:07:05.461	01B5235282AA1
cmlezxfvw01rm39t5d75du57s	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM VARIO 150 BESAR HITAM	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	121000.00	HON-LEG-LEG-1170	2026-06-19 22:07:05.595	01B4435282AA1
cmlezxg2c01s439t5wfrs5evf	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM VARIO 150 18 KECIL HITAM	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	122000.00	HON-LEG-LEG-1171	2026-06-19 22:07:05.728	01B5236740AA1
cmlezxfz901ru39t5g8w5kmhb	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM VARIO 150 18 KECIL HITAM DOFF	\N	0	HONDA	92000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	95000.00	HON-LEG-LEG-1172	2026-06-19 22:07:05.866	01B4436780AA1
cmlezxg1o01s039t5r0ofy5nz	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM VARIO 110 FI BESAR	\N	0	HONDA	57000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	60000.00	HON-LEG-LEG-1173	2026-06-19 22:07:06.255	01B4235282AA1
cmlezxlt0021q39t53rlvkdo8	TUTUP AKI VARIO 150 18	\N	0	HONDA	19000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	25000.00	HON-TUT-TUT-1333	2026-02-09 09:55:18.839	\N
09ff2414-2bed-4452-985f-54488d723388	STOP LAMP / LAMPU STOP ASSY BLADE 11	\N	0	HONDA	99000.00	STOP LAMP	2026-06-18 17:47:31.403	KELISTRIKAN	99000.00	HON-STL-2547	2026-06-18 17:47:31.403	\N
cmlezxoh7027a39t5gig3zag9	KARET BARSTEP GL PRO	\N	0	HONDA	17000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	12100.00	HON-TUT-KAR-1445	2026-06-18 17:27:37.767	\N
9099986f-4ddb-4a01-bf6c-6ebbbf50bef8	STOP LAMP / LAMPU STOP ASSY ABSOLUTE REVO / ABSOLUTE REVO FIT	\N	0	HONDA	131000.00	STOP LAMP	2026-06-18 17:47:31.403	KELISTRIKAN	131000.00	HON-STL-2548	2026-06-18 17:47:31.403	\N
cmlezxovv028f39t55kzae9rz	SWITCH REM BELAKANG ALL MATIC HONDA	\N	0	HONDA	10000.00	SWITCH REM	2026-02-09 09:55:22.865	KELISTRIKAN	14000.00	HON-TUT-SWI-1416	2026-06-18 17:34:05.97	\N
ab8d4af8-b4c0-44be-a85a-2474109e3f91	STOP LAMP / LAMPU STOP ASSY SUPRA X 125 07 / SUPRA X 125 04	\N	0	HONDA	121000.00	STOP LAMP	2026-06-18 17:47:31.403	KELISTRIKAN	121000.00	HON-STL-2549	2026-06-18 17:47:31.403	\N
aee3c38b-a340-41b0-a3a8-f4064a4c5efd	STOP LAMP / LAMPU STOP ASSY REVO	\N	0	HONDA	92000.00	STOP LAMP	2026-06-18 17:47:31.403	KELISTRIKAN	92000.00	HON-STL-2550	2026-06-18 17:47:31.403	\N
4f63100e-cc8b-4b94-be76-b1d83daa6b27	STOP LAMP / LAMPU STOP ASSY KARISMA / KARISMA X (P/M)	\N	0	HONDA	85000.00	STOP LAMP	2026-06-18 17:47:31.403	KELISTRIKAN	85000.00	HON-STL-2551	2026-06-18 17:47:31.403	\N
cmlezxg8f01sg39t5gb9gqddh	LEGSHIELD DALAM BAWAH / LACI / KUPU KUPU DALAM VARIO TECHNO BESAR	\N	0	HONDA	61000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	64000.00	HON-LEG-LEG-1176	2026-02-09 09:55:11.246	01B2935282AA1
cmlezxg7601sc39t5ppfa4nzv	LEGSHIELD DALAM BAWAH / LACI / KUPU KUPU DALAM VARIO TECHNO 125	\N	0	HONDA	63000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	67000.00	HON-LEG-LEG-1175	2026-06-18 17:22:17.168	01B3635282AA1
cmlezxidz01vs39t560py1xsl	FOOOTREST BAWAH / UNDERSIDE	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	52000.00	HON-LEG-FOO-1226	2026-06-18 17:22:17.168	\N
cmlezxnxs025v39t550b19wbp	SWITCH REM BELAKANG /	\N	0	HONDA	0.00	SWITCH REM	2026-02-09 09:55:22.865	KELISTRIKAN	10000.00	HON-TUT-SWI-1412	2026-06-18 17:34:05.97	\N
739e5428-ed61-4bce-94e9-9a6e1738f8c0	STOP LAMP / LAMPU STOP ASSY LEGENDA 2 (P/M)	\N	0	HONDA	80000.00	STOP LAMP	2026-06-18 17:47:31.403	KELISTRIKAN	80000.00	HON-STL-2552	2026-06-18 17:47:31.403	\N
d1345622-e4d1-411b-8a5d-9809d9c327fa	STOP LAMP / LAMPU STOP ASSY PRIMA (C/M)	\N	0	HONDA	101000.00	STOP LAMP	2026-06-18 17:47:31.403	KELISTRIKAN	101000.00	HON-STL-2553	2026-06-18 17:47:31.403	\N
cmlezxh3901u239t5yuhcagcg	LEGSHIELD TENGAH SUPRA X / FIT	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.247	BODY PART	53000.00	HON-LEG-LEG-1195	2026-02-09 09:55:11.247	01B1332382AA1
abc5bb7f-5470-42af-b520-5eea44347b5c	STOP LAMP / LAMPU STOP UNIT GL PRO / GL MAX (M)	\N	0	HONDA	69000.00	STOP LAMP	2026-06-18 17:47:31.403	KELISTRIKAN	69000.00	HON-STL-2554	2026-06-18 17:47:31.403	\N
cmlezxm51022s39t5ffjebj1e	REAR WINKER UNIT SCOOPY 20	\N	0	HONDA	109000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	109000.00	HON-TUT-REA-1351	2026-02-09 09:55:18.839	\N
15848878-c33d-4b7f-b9ad-c5c443ac1e4c	STOP LAMP / LAMPU STOP ASSY GRAND / IMPRESSA SABIT (M)	\N	0	HONDA	63000.00	STOP LAMP	2026-06-18 17:47:31.403	KELISTRIKAN	63000.00	HON-STL-2555	2026-06-18 17:47:31.403	\N
cmlezxmap023239t5uhmi93lm	BUNTUT Rr PRIMA	\N	0	HONDA	11000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	11000.00	HON-TUT-BUN-1359	2026-02-09 09:55:18.839	\N
cmlezxg1o01s139t5fazq8lva	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU DALAM VARIO 150 / 125 KECIL HITAM	\N	0	HONDA	77000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	80000.00	HON-LEG-LEG-1174	2026-06-19 22:07:06.468	01B4436740AA1
cmlezxgnq01te39t5ismnjw8t	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM SCOOPY FI KECIL MERAH	\N	0	HONDA	127000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	60000.00	HON-LEG-LEG-1181	2026-06-19 22:07:06.607	01B4336752AA1
cmlezxgje01t239t5t5pp6jwh	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM SCOOPY FI KECIL MERAH MAROON	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	137000.00	HON-LEG-LEG-1180	2026-06-19 22:07:06.741	01B4336752AA1
cmlezxgmg01ta39t5746ikdb0	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM SCOOPY FI KECIL HITAM	\N	0	HONDA	111000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	116000.00	HON-LEG-LEG-1188	2026-06-19 22:07:06.876	01B4336740AA1
cmlezxgx401tm39t5dv0xvhz9	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM SCOOPY FI KECIL PUTIH	\N	0	HONDA	126000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	129000.00	HON-LEG-LEG-1189	2026-06-19 22:07:07.005	01B4336747AA1
cmlezxh3y01u839t5qf4gbrgp	LEGSHIELD TENGAH SUPRA X 125 07/ X 125	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.247	BODY PART	53000.00	HON-LEG-LEG-1196	2026-06-19 22:07:07.139	01B2532282AA1
cmlezxh4q01ua39t51ypftq0z	LEGSHIELD TENGAH BAWAH SUPRA X 125 07/ X 126	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.247	BODY PART	31000.00	HON-LEG-LEG-1197	2026-06-19 22:07:07.5	01B2532482AA1
cmlezxh4q01uc39t5phnqnhzm	LEGSHIELD TENGAH BAWAH KARISMA X	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.247	BODY PART	37000.00	HON-LEG-LEG-1198	2026-06-19 22:07:07.636	01B1432482AA1
cmlezxhwt01uo39t5s9t0ki0y	FOOTREST BEAT	\N	0	HONDA	88000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	91000.00	HON-LEG-FOO-1203	2026-06-19 22:07:07.799	01B2734382AA1
cmlezxhwt01un39t5awo63f99	FOOTREST ATAS VARIO TECHNO 125	\N	0	HONDA	86000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	89000.00	HON-LEG-FOO-1204	2026-06-19 22:07:07.942	01B3634382AA1
cmlezxhwt01ur39t5clotdgx6	FOOTREST ATAS VARIO	\N	0	HONDA	63000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	66000.00	HON-LEG-FOO-1205	2026-06-19 22:07:08.076	01B2234382AA1
cmlezxhwu01v039t5s3u7lfc6	FOOTREST ATAS + TUTUP AKI BEAT FI ESP	\N	0	HONDA	101000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	104000.00	HON-LEG-FOO-1209	2026-06-19 22:07:08.207	01B4534382AA1
cmlezxjy201zo39t5acsfbhya	FOOTREST ATAS + TUTUP AKI BEAT FI	\N	0	HONDA	95000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	98000.00	HON-LEG-FOO-1210	2026-06-19 22:07:08.34	01B3834382AA1
cmlezxk3t01zy39t5xkkhej9x	FOOTREST ATAS + TUTUP AKI BEAT 20	\N	0	HONDA	87000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	90000.00	HON-LEG-FOO-1211	2026-06-19 22:07:08.48	01B5934382AA10
e1e94e4d-ec02-409c-923e-b122d432e34a	BUNTUT Rr PRIMA / ASTREA STAR	\N	0	HONDA	15000.00	BUNTUT	2026-06-18 17:47:31.403	BODY PART	15000.00	HON-BUN-2564	2026-06-18 17:47:31.403	\N
2c24c3f0-604e-40c2-9c17-fad9cd77954f	BUNTUT Rr GRAND / IMPRESSA	\N	0	HONDA	15000.00	BUNTUT	2026-06-18 17:47:31.403	BODY PART	15000.00	HON-BUN-2565	2026-06-18 17:47:31.403	\N
3bb893c7-95aa-4e79-bc9b-7e6890de2720	COB LAMPU / FITTING LAMPU BEAT ESP 16 / BEAT STREET 16	\N	0	HONDA	24000.00	COB LAMPU	2026-06-18 17:47:31.403	KELISTRIKAN	24000.00	HON-COB-2566	2026-06-18 17:47:31.403	\N
cmlezxjmn01yu39t5pznmaln6	FOOTREST ATAS + TUTUP AKI SCOOPY FI ESP COKLAT	\N	0	HONDA	126000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	137000.00	HON-LEG-FOO-1222	2026-06-18 17:22:17.168	\N
cmlezxjgr01ye39t5y9mufpnm	FOOTREST BAWAH SCOOPY 20 B R+L PUTIH	\N	0	HONDA	232000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	259000.00	HON-LEG-FOO-1267	2026-06-18 17:22:17.168	\N
cmlezxirb01wu39t5kophv5p0	FOOTREST BAWAH PCX 150 18 B R+L HITAM	\N	0	HONDA	276000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	307000.00	HON-LEG-FOO-1271	2026-06-18 17:22:17.168	\N
cmlezxmyi024o39t51awddbuv	HANDFAT BEAT / BEAT 10 / VARIO TECHNO / VARIO / SPACY	\N	0	HONDA	21000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	26000.00	HON-TUT-HAN-1379	2026-06-18 17:22:17.168	\N
319b2483-5376-4a97-8aaf-fd4570c35d1c	COB LAMPU / FITTING LAMPU BEAT FI / BEAT FI ESP	\N	0	HONDA	22000.00	COB LAMPU	2026-06-18 17:47:31.403	KELISTRIKAN	22000.00	HON-COB-2567	2026-06-18 17:47:31.403	\N
cmlezx2mf011239t5amr0vaow	COVER STOP / RR STOP SCOOPY 20 BESAR PUTIH DOFF	\N	0	HONDA	138000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	138000.00	HON-COV-COV-679	2026-06-18 17:22:17.168	\N
cmlezxixx01x639t5fn24rzun	FOOTREST BAWAH BEAT ESP 16	\N	0	HONDA	80000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	83000.00	HON-LEG-FOO-1229	2026-02-09 09:55:15.055	01B4634982AA1
cmlezxiko01we39t5k11sllxs	FOOTREST BAWAH SCOOPY FI 17 R+L HIJAU	\N	0	HONDA	205000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	232000.00	HON-LEG-FOO-1258	2026-02-09 09:55:15.055	\N
bda6855f-a064-43a6-9cc7-c1d1810f87a7	COB LAMPU / FITTING LAMPU ABSOLUTE REVO / ABSOLUTE REVO FIT / REVO AT	\N	0	HONDA	22000.00	COB LAMPU	2026-06-18 17:47:31.403	KELISTRIKAN	22000.00	HON-COB-2568	2026-06-18 17:47:31.403	\N
bddce35f-4ea9-4e8d-b347-7b5f56f3687f	COB LAMPU / FITTING LAMPU BEAT / BEAT 10	\N	0	HONDA	27000.00	COB LAMPU	2026-06-18 17:47:31.403	KELISTRIKAN	27000.00	HON-COB-2569	2026-06-18 17:47:31.403	\N
cmlezxmzt024q39t5h9jewql8	MINI REFLECTOR Fr GRAND	\N	0	HONDA	16000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	21000.00	HON-TUT-MIN-1391	2026-06-18 17:27:37.767	\N
ef91964c-8994-4e68-9b31-d59433459ef3	COB LAMPU / FITTING LAMPU SUPRA X 125 07 / SUPRA X 125 FI 14	\N	0	HONDA	20000.00	COB LAMPU	2026-06-18 17:47:31.403	KELISTRIKAN	20000.00	HON-COB-2570	2026-06-18 17:47:31.403	\N
f82c0201-4f53-4260-abbe-c7693c2ecd03	COB LAMPU / FITTING LAMPU SUPRA FIT NEW / FIT NEW S	\N	0	HONDA	16000.00	COB LAMPU	2026-06-18 17:47:31.403	KELISTRIKAN	16000.00	HON-COB-2571	2026-06-18 17:47:31.403	\N
a1036722-5b16-4e2c-a6c8-32c896513905	COB LAMPU / FITTING LAMPU SUPRA X / SUPRA V / XX	\N	0	HONDA	14000.00	COB LAMPU	2026-06-18 17:47:31.403	KELISTRIKAN	14000.00	HON-COB-2572	2026-06-18 17:47:31.403	\N
0585e3ed-3958-4b48-abae-9f136b2ab21a	COB LAMPU / FITTING LAMPU GL PRO / WIN / GL MAX / GL 100 / CB 100	\N	0	HONDA	13000.00	COB LAMPU	2026-06-18 17:47:31.403	KELISTRIKAN	13000.00	HON-COB-2573	2026-06-18 17:47:31.403	\N
d4ece35f-c14c-4581-8e2b-99c3bd7050ec	COB LAMPU / FITTING LAMPU GRAND / LEGENDA / 2 / IMPRESSA / ASTREA STAR	\N	0	HONDA	14000.00	COB LAMPU	2026-06-18 17:47:31.403	KELISTRIKAN	14000.00	HON-COB-2574	2026-06-18 17:47:31.403	\N
c0ffc340-2e3e-45bf-885c-9da25150bc23	HANDFAT / KARET GAS + PIPA GAS BEAT FI ESP / VARIO TECHNO / VARIO TECHNO 125	\N	0	HONDA	23000.00	PIPA	2026-06-18 17:47:31.403	BODY PART	23000.00	HON-PIP-2576	2026-06-18 17:47:31.403	\N
cbb59490-3651-4c72-abd4-63fec16c221b	KARET BARSTEP ABSOLUTE REVO / BLADE / SUPRA X 125 14 / HELM IN / ABSOLUTE REVO FIT / REVO AT	\N	0	HONDA	25000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	25000.00	HON-OTH-2584	2026-06-18 17:47:31.403	\N
cmlezxk5i020039t59b0yzjf0	FOOTREST ATAS + TUTUP AKI VARIO 150 18	\N	0	HONDA	118000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	121000.00	HON-LEG-FOO-1216	2026-06-19 22:07:09.074	01B5234382AA1
cmlezxias01vk39t5nxiuriiv	FOOTREST BAWAH BEAT FI B R+L	\N	0	HONDA	68000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	71000.00	HON-LEG-FOO-1232	2026-06-19 22:07:09.209	01B3836582AA14
cmlezxjfc01y839t5vcsohujw	FOOTREST BAWAH VARIO TECHNO	\N	0	HONDA	68000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	71000.00	HON-LEG-FOO-1236	2026-06-19 22:07:09.35	01B2934982AA1
cmlezxi4z01va39t5abqehbkl	FOOTREST BAWAH VARIO TECHNO 125	\N	0	HONDA	79000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	82000.00	HON-LEG-FOO-1238	2026-06-19 22:07:09.48	01B3634982AA1
cmlezxiey01vx39t58afhfapl	FOOTREST BAWAH VARIO 160 B HITAM	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	169000.00	HON-LEG-FOO-1239	2026-06-19 22:07:09.612	01B6439040AA1
cmlezxiqm01wm39t5zdriisu0	FOOTREST BAWAH VARIO 160 B HITAM DOFF	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	191000.00	HON-LEG-FOO-1240	2026-06-19 22:07:09.748	01B6439080AA1
11fc4164-9538-4f6a-8736-b10b944ac613	KARET BARSTEP SUPRA / SUPRA FIT	\N	0	HONDA	27000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	27000.00	HON-OTH-2585	2026-06-18 17:47:31.403	\N
28a59867-fa1c-4f40-829c-567bc0771f02	KARET BARSTEP GRAND / SUPRA X 125 / SUPRA X 125 07 / SUPRA FIT NEW / REVO / LEGENDA / KARISMA	\N	0	HONDA	26000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	26000.00	HON-OTH-2586	2026-06-18 17:47:31.403	\N
cmlezxluc022039t5yh16lx9j	TUTUP AKI VARIO 150	\N	0	HONDA	25000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	25000.00	HON-TUT-TUT-1336	2026-02-09 09:55:18.839	\N
cmlezxm0r022e39t5eez7qmgb	DUDUKAN RADIATOR /	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	50000.00	HON-TUT-DUD-1344	2026-02-09 09:55:18.839	\N
ab1aeb56-f93d-4113-b064-5f44aa471aa8	MINI REFLECTOR Rr SUPRA X / LEGENDA / KARISMA / SUPRA X 125 / SUPRA FIT	\N	0	HONDA	16000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	16000.00	HON-OTH-2587	2026-06-18 17:47:31.403	\N
9864a27b-bb75-40ba-b267-ef5558bb24fe	MINI REFLECTOR Rr GRAND / GL MAX / GL PRO / TIGER / MEGA PRO	\N	0	HONDA	16000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	16000.00	HON-OTH-2588	2026-06-18 17:47:31.403	\N
cmlezxj8401xm39t58u7p7owt	FOOTREST BAWAH SCOOPY 20 B R+L HITAM	\N	0	HONDA	207000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	231000.00	HON-LEG-FOO-1266	2026-06-18 17:22:17.168	\N
cmlezxjds01y539t5czi6098a	FOOTREST BAWAH VARIO 160 A	\N	0	HONDA	45000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	45000.00	HON-LEG-FOO-1242	2026-02-09 09:55:15.055	\N
cmlezxljf021a39t5hpzcdrj9	TUTUP KNALPOT VARIO 110 FI	\N	0	HONDA	32000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	25000.00	HON-TUT-TUT-1326	2026-02-09 09:55:18.839	\N
cmlezxmv9024g39t5vvge2x3y	HANDFAT BEAT FI / BEAT POP / VARIO 125 PGMFI / VARIO 110 FI / VARIO 150 / VARIO 125 ESP / ABSOLUTE REVO FIT / BLADE / BLADE 11 / REVO FI / SUPRA X 125 14	\N	0	HONDA	20000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	25000.00	HON-TUT-HAN-1375	2026-06-18 17:22:17.168	\N
cmlezxn9l025k39t5a94hqx4y	HANDFAT SUPRA X 125 07 / SUPRA FIT NEW / KARISMA / KARISMA X / SUPRA FIT X / SUPRA X 125 HELM IN / KIRANA	\N	0	HONDA	17000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	21000.00	HON-TUT-HAN-1380	2026-06-18 17:22:17.168	\N
cmlezxjt501zc39t5pn448m7s	COVER RADIATOR VARIO TECHNO 125	\N	0	HONDA	22000.00	BOX FILTER UDARA	2026-02-09 09:55:15.055	MESIN & OLI	25000.00	HON-BOX-COV-1299	2026-02-09 09:55:15.055	01B3637182AA15
cmlezxlq1021m39t5u7sii34s	TUTUP KNALPOT SCOOPY FI 17 HITAM	\N	0	HONDA	44000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	59000.00	HON-TUT-TUT-1323	2026-02-09 09:55:18.839	\N
cmlezwueq00kk39t5c4us3hhl	PANEL / TAMENGVARIO 150 18 BESAR MERAH	\N	0	HONDA	195000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	179000.00	HON-PAN-PAN-378	2026-06-18 17:22:17.168	\N
cmlezwuy400ln39t5cktdwy8l	PANEL / TAMENGVARIO 150 18 BESAR PUTIH	\N	0	HONDA	195000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	179000.00	HON-PAN-PAN-381	2026-06-18 17:22:17.168	\N
5324d15b-65e0-458c-be5a-ea0962591155	PIPA GAS REVO FI / REVO X	\N	0	HONDA	12300.00	PIPA	2026-06-18 17:47:31.403	BODY PART	12300.00	HON-PIP-2589	2026-06-18 17:47:31.403	\N
7b61626d-dfc6-4fd4-84e0-3f3af8fa56b0	UKURAN OLI SUPRA / SUPRA FIT NEW / REVO	\N	0	HONDA	13000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	13000.00	HON-OTH-2590	2026-06-18 17:47:31.403	\N
cmlezxm1q022g39t5vtsugbyh	DUDUKAN RADIATOR VARIO 150/KZR	\N	0	HONDA	38000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	38000.00	HON-TUT-DUD-1346	2026-02-09 09:55:18.839	\N
cmlezxn0o024u39t5qe2j8voo	KARET BARSTEP GRAND	\N	0	HONDA	21000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	8800.00	HON-TUT-KAR-1388	2026-02-09 09:55:18.839	\N
cmlezxld7021039t53zew4sl5	TUTUP KNALPOT SCOOPY 20 SILVER	\N	0	HONDA	76000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	87000.00	HON-TUT-TUT-1320	2026-06-18 17:27:37.767	\N
cmlezxp5g028w39t5e3yrpqcu	SWITCH REM BELAKANG SCOOPY	\N	0	HONDA	10000.00	SWITCH REM	2026-02-09 09:55:22.865	KELISTRIKAN	10000.00	HON-TUT-SWI-1417	2026-06-18 17:34:05.97	\N
cmlg43pnq00pqpv85jzvbn84a	SWITCH REM BELAKANG V-IXION	\N	0	YAMAHA	13000.00	SWITCH REM	2026-02-10 04:39:46.568	KELISTRIKAN	10000.00	YAM-AKS-SWI-683	2026-06-18 17:34:05.97	\N
0c008eec-56de-40e3-8ec7-1a9b4add37fd	COVER FILTER UDARA BEAT ESP 16 / BEAT STREET 16 / SCOOPY FI 17 / VARIO 110 ESP	\N	0	HONDA	39000.00	FILTER	2026-06-18 17:47:31.403	MESIN	39000.00	HON-FIL-2591	2026-06-18 17:47:31.403	\N
cmlezxn5i025839t5zxmb1mun	PIPA GAS CB 150 R NEW	\N	0	HONDA	9000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	5800.00	HON-TUT-PIP-1397	2026-06-18 17:19:42.083	\N
cmlezxnxs026439t53660wxve	FILTER UDARA BEAT FI / FI ESP / SCOOPY FI / VARIO 110 FI / SCOOOPY FI 17	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:22.865	LAIN-LAIN	39000.00	HON-TUT-FIL-1424	2026-06-19 22:07:09.891	01B3842400AA1
cmlezxkty020g39t57jfdwbmg	TUTUP KIPAS BEAT FI / FI ESP / POP / SCOOPY ESP K16R / ESP K93 / VARIO 110 ESP	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.838	LAIN-LAIN	240000.00	HON-TUT-TUT-1311	2026-06-19 22:07:10.034	01B3835882AA24
cmlezwuq600l639t5nfbw043z	PANEL / TAMENGVARIO 150 18 BESAR MERAH DOFF	\N	0	HONDA	195000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	179000.00	HON-PAN-PAN-380	2026-06-19 22:07:10.229	01B5230587AA1
cmlezxouc028739t53evyw3k9	PIPA GARPU DEPAN BEAT FI	\N	0	HONDA	0.00	PIPA GARPU DEPAN	2026-02-09 09:55:22.865	KAKI-KAKI	150000.00	HON-PIP-PIP-1454	2026-06-19 22:07:10.367	01B3853000AA1
cmlezxouc028939t5fco4b6s6	PIPA GARPU DEPAN BEAT FI ESP 18	\N	0	HONDA	0.00	PIPA GARPU DEPAN	2026-02-09 09:55:22.865	KAKI-KAKI	150000.00	HON-PIP-PIP-1455	2026-06-19 22:07:10.504	01B6363000AA1
cmlezxov7028c39t5jeq8qqbd	PIPA GARPU DEPAN BEAT	\N	0	HONDA	0.00	PIPA GARPU DEPAN	2026-02-09 09:55:22.865	KAKI-KAKI	150000.00	HON-PIP-PIP-1456	2026-06-19 22:07:10.638	01B2753000AA1
cmlezxj2q01xf39t5fu7dt34d	FOOTREST BAWAH VARIO 160 B	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	45000.00	HON-LEG-FOO-1241	2026-06-19 22:07:10.773	01B6439080AA1
cmlezxjfc01y939t5yquqo2u4	STANDARD SAMPING BEAT 20	\N	0	HONDA	0.00	STANDARD TENGAH	2026-02-09 09:55:15.055	KAKI-KAKI	29000.00	HON-STA-STA-1282	2026-06-19 22:07:10.913	01B5999997AA1
cmlezwg26000a39t59el2cb2q	COMPLETE SET BODY VARIO 150 HITAM DOFF	\N	0	HONDA	1626000.00	COMPLETE SET BODY	2026-02-09 09:54:25.619	BODY PART	1664000.00	HON-COM-COM-5	2026-06-18 17:27:37.767	\N
cmlezwgen000u39t5dh9khhjv	COMPLETE SET BODY VARIO 150 PUTIH	\N	0	HONDA	1621000.00	COMPLETE SET BODY	2026-02-09 09:54:25.619	BODY PART	1659000.00	HON-COM-COM-7	2026-06-18 17:27:37.767	\N
cmlg43pul00q8pv85ycjhsdn7	SWITCH REM BELAKANG F1Z-R	\N	0	YAMAHA	13000.00	SWITCH REM	2026-02-10 04:39:46.568	KELISTRIKAN	10000.00	YAM-AKS-SWI-686	2026-06-18 17:34:05.97	\N
15f10b34-c358-4587-ac29-ed8b32e7a966	DOP LAMPU T19 LED	\N	0	HONDA	28000.00	BOHLAM	2026-06-18 17:47:31.403	KELISTRIKAN	28000.00	HON-BOH-2605	2026-06-18 17:47:31.403	\N
03653ade-58fd-4ddf-87de-2eba4bc2ce77	BOHLAM T10 (CLEAR)	\N	0	HONDA	3600.00	BOHLAM	2026-06-18 17:47:31.403	KELISTRIKAN	3600.00	HON-BOH-2606	2026-06-18 17:47:31.403	\N
48df8d42-9492-42b8-86ca-27c843754ea7	BOHLAM T13 (CLEAR)	\N	0	HONDA	3600.00	BOHLAM	2026-06-18 17:47:31.403	KELISTRIKAN	3600.00	HON-BOH-2607	2026-06-18 17:47:31.403	\N
c4f6dd32-4817-4656-bcea-531a14f24d6c	BOHLAM T13 (ORANGE)	\N	0	HONDA	3600.00	BOHLAM	2026-06-18 17:47:31.403	KELISTRIKAN	3600.00	HON-BOH-2608	2026-06-18 17:47:31.403	\N
e8ca9a37-f1b1-4f3a-82d7-2108ddf5bd35	COMPLETE SET BODY BEAT 20 HITAM	\N	0	HONDA	1286000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	1286000.00	HON-COM-2609	2026-06-18 17:47:31.403	\N
bb39c61e-df90-483e-a1a4-c0ec1a3fb561	COMPLETE SET BODY VARIO 110 FI HITAM	\N	0	HONDA	1082000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	1082000.00	HON-COM-2610	2026-06-18 17:47:31.403	\N
cmlezxe8901nw39t5n3w8hzhd	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 GRAY DOFF	\N	0	HONDA	243000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.266	BODY PART	194000.00	HON-LEG-LEG-1081	2026-06-18 17:19:42.083	\N
11e17ebf-bab3-455a-a30c-7960174c7ae9	COMPLETE SET BODY VARIO TECHNO 125 HITAM	\N	0	HONDA	1322000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	1322000.00	HON-COM-2611	2026-06-18 17:47:31.403	\N
c2b92005-a578-44d8-a2b8-f745c66d60bb	COMPLETE SET BODY VEGA ZR HITAM	\N	0	HONDA	512000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	512000.00	HON-COM-2612	2026-06-18 17:47:31.403	\N
6dd50ff8-8f8a-4365-85f3-eb3384f0d997	COMPLETE SET BODY VEGA R 04 HITAM	\N	0	HONDA	696000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	696000.00	HON-COM-2613	2026-06-18 17:47:31.403	\N
c29a3ccb-185d-4ad3-82b2-94ad77ff2c36	LEGSHIELD LUAR / SAYAP LUAR SCOOPY FI / SCOOPY FI ESP BIRU	\N	0	HONDA	262000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	262000.00	HON-LEG-2614	2026-06-18 17:47:31.403	\N
436b8f88-d232-48e3-845e-40ac05a9e562	LEGSHIELD LUAR / SAYAP LUAR SCOOPY FI / SCOOPY FI ESP MERAH MAROON	\N	0	HONDA	262000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	262000.00	HON-LEG-2615	2026-06-18 17:47:31.403	\N
789a63b6-3467-4987-a08f-3ba35b100e2e	PANEL / TAMENG VARIO 150 18 / VARIO 125 18 BESAR HITAM	\N	0	HONDA	158000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	158000.00	HON-PAN-2616	2026-06-18 17:47:31.403	\N
6dac6e23-582b-463b-a594-66e1ee137f54	PANEL / TAMENG VARIO 150 18 / VARIO 125 18 BESAR HITAM DOFF	\N	0	HONDA	179000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	179000.00	HON-PAN-2617	2026-06-18 17:47:31.403	\N
ddd1abf4-f9b2-496f-9e79-3e989de9b82d	PANEL / TAMENG VARIO 150 18 / VARIO 125 18 BESAR MERAH	\N	0	HONDA	179000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	179000.00	HON-PAN-2618	2026-06-18 17:47:31.403	\N
7e3f57d1-b523-446e-b14f-be5483ac9aca	PANEL / TAMENG VARIO 150 18 / VARIO 125 18 BESAR MERAH DOFF	\N	0	HONDA	179000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	179000.00	HON-PAN-2619	2026-06-18 17:47:31.403	\N
f457969c-6f92-45c5-bedd-f1192f2e38ed	PANEL / TAMENG VARIO 150 18 / VARIO 125 18 BESAR PUTIH	\N	0	HONDA	179000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	179000.00	HON-PAN-2620	2026-06-18 17:47:31.403	\N
663899f0-c3fe-458f-afb8-a04d9bbb12cf	COVER STOP / Rr STOP SCOOPY FI 17 GRAY DOFF	\N	0	HONDA	118000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	118000.00	HON-CST-2621	2026-06-18 17:47:31.403	\N
3734bca1-a0b2-4150-989e-d1841cda3484	TUTUP KIPAS BEAT 20 / BEAT STREET 20 / GENIO	\N	0	HONDA	23000.00	TUTUP	2026-06-18 17:47:31.403	BODY PART	23000.00	HON-TUT-2622	2026-06-18 17:47:31.403	\N
cmlezwr2j00gg39t5bfwqz4ea	FRONT FENDER / SPAKBOR DEPAN  PCX 160 HITAM DOFF	\N	0	HONDA	162000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.583	BODY PART	126000.00	HON-FRO-FRO-225	2026-06-18 17:19:42.083	\N
cmlezwnmx00bk39t58n9r2lsh	FRONT FENDER / SPAKBOR DEPAN  PCX 150 18 HITAM DOFF	\N	0	HONDA	187000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	126000.00	HON-FRO-FRO-226	2026-06-18 17:19:42.083	\N
cmlezwkdk006v39t5wgy0tcpg	FRONT FENDER / SPAKBOR DEPAN  BEAT 10 BIRU MUDA	\N	0	HONDA	90000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	89000.00	HON-FRO-FRO-151	2026-06-18 17:19:42.083	\N
a11301a0-6e16-4832-a092-00e9af392c70	PIPA GAS CB 150 R NEW / CB 150 / SONIC 150 R	\N	0	HONDA	7300.00	PIPA	2026-06-18 17:47:31.403	BODY PART	7300.00	HON-PIP-2629	2026-06-18 17:47:31.403	\N
6cf64a0c-f40f-46d4-b525-47bfe10dd8af	LEGSHIELD DALAM KECIL A SCOOPY FI / ESP KREM	\N	0	HONDA	60000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	60000.00	HON-LEG-2630	2026-06-18 17:47:31.403	\N
2392043b-db96-444e-8bd6-eb7b4aeb8a18	COVER BODY / BODY SAMPING SCOOPY 20 GRAY DOFF	\N	0	HONDA	382000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	382000.00	HON-COV-2631	2026-06-18 17:47:31.403	\N
ba8775cf-1cb3-440a-845e-00aa95a401a0	COVER STOP / Rr STOP PCX 150 18 BESAR HITAM DOFF	\N	0	HONDA	160000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	160000.00	HON-CST-2632	2026-06-18 17:47:31.403	\N
ddd2da65-2515-464c-866d-d6600bc0b636	COVER STOP / Rr STOP PCX 150 18 BESAR BIRU DOFF	\N	0	HONDA	160000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	160000.00	HON-CST-2633	2026-06-18 17:47:31.403	\N
cmlezxg4z01s839t5pzy2d3am	LEGSHIELD DALAM / INNER UPPER SCOOPY FI 17 KECIL MERAH DOFF	\N	0	HONDA	0.00	LEGSHIELD DALAM /	2026-02-09 09:55:11.246	BODY PART	127000.00	HON-LEG-LEG-1158	2026-06-19 22:07:11.05	01B4836087AA1
cmlezwwci00no39t5udwh81vk	PANEL / TAMENGSCOOPY FI BIRU MUDA	\N	0	HONDA	105000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	105000.00	HON-PAN-PAN-453	2026-06-19 22:07:11.185	01B4330574AA1
7b41f1ef-dcfb-49d3-9555-90b3671a5f22	COVER STOP / Rr STOP PCX 150 18 BESAR MERAH DOFF	\N	0	HONDA	160000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	160000.00	HON-CST-2634	2026-06-18 17:47:31.403	\N
cmlezx26200zu39t5hakj325f	COVER STOP / RR STOP SCOOPY FI PUTIH	\N	0	HONDA	88000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	115000.00	HON-COV-COV-669	2026-06-18 17:19:42.083	\N
aba0b6ec-6d6e-4b8b-ae83-acc752b43bad	COVER STOP / Rr STOP PCX 150 18 KECIL HITAM DOFF	\N	0	HONDA	130000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	130000.00	HON-CST-2635	2026-06-18 17:47:31.403	\N
cmlezxiry01wy39t5d0e7z37c	FOOTREST BAWAH SCOOPY FI B MERAH MAROON	\N	0	HONDA	188000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	188000.00	HON-LEG-FOO-1260	2026-06-18 17:19:42.083	\N
cmlezx0qp00ws39t5xkimf2e1	FRONT HANDLE COVER / BATOK DEPAN SUPRA X 125 MERAH CAKRAM	\N	0	HONDA	84000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	90000.00	HON-FRO-FRO-592	2026-06-18 17:27:37.767	\N
cmlezxalu01f639t55qxmd6ed	MIKA STOP / MIKA BELAKANG GL PRO (P) KO	\N	0	HONDA	33000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	30000.00	HON-MIK-MIK-948	2026-06-18 17:19:42.083	\N
cmlezxekr01oq39t5j66snlpf	STOP LAMP UNIT GL PRO DE SMOKE	\N	0	HONDA	72000.00	STOP LAMP ASSY / LAMPU BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:08.266	KELISTRIKAN	72000.00	HON-STO-STO-1036	2026-06-18 17:19:42.083	\N
cmlezx7un019i39t5lca5wcz1	MIKA SPEEDOMETER VARIO 150 SMOKE	\N	0	HONDA	45000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	51000.00	HON-MIK-MIK-845	2026-06-18 17:27:37.767	\N
cmlezwvmw00mk39t5su4trqp8	PANEL / TAMENGVARIO 150 18 BESAR GRAY	\N	0	HONDA	195000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	187000.00	HON-PAN-PAN-419	2026-06-18 17:19:42.083	\N
cmlg43pjk00popv85hq56dbry	SWITCH REM BELAKANG VEGA ZR	\N	0	YAMAHA	13000.00	SWITCH REM	2026-02-10 04:39:46.568	KELISTRIKAN	12000.00	YAM-AKS-SWI-682	2026-06-18 17:34:05.97	\N
220ef5e4-9fa9-4a1d-92cc-e38d0535c833	COVER STOP / Rr STOP PCX 150 18 KECIL BIRU DOFF	\N	0	HONDA	130000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	130000.00	HON-CST-2636	2026-06-18 17:47:31.403	\N
45379640-4673-4c7f-b406-796d83e12deb	COVER STOP / Rr STOP PCX 150 18 KECIL MERAH DOFF	\N	0	HONDA	130000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	130000.00	HON-CST-2637	2026-06-18 17:47:31.403	\N
f6945cb7-85ec-4c14-ae84-161fb443a0aa	MIKA SEN Rr / MIKA SEN BELAKANG  + STOP PRIMA SMOKE	\N	0	HONDA	61000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	61000.00	HON-MIK-2638	2026-06-18 17:47:31.403	\N
f26abb05-250e-4f46-a159-b39c2738be7a	LEGSHIELD LUAR / SAYAP LUAR SCOOPY 20 PUTIH	\N	0	HONDA	253000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	253000.00	HON-LEG-2639	2026-06-18 17:47:31.403	\N
b2be128c-254e-4a69-9713-8e03005f4fc2	LEGSHIELD LUAR/ SAYAP LUAR  PCX 150 18 GRAY DOFF	\N	0	HONDA	491000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	491000.00	HON-LEG-2640	2026-06-18 17:47:31.403	\N
8722d779-96e9-4bf0-a708-7efc68d38d06	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 / VARIO 125 18 GRAY	\N	0	HONDA	255000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	255000.00	HON-LEG-2641	2026-06-18 17:47:31.403	\N
4087f23c-4171-4be8-90b8-ee1adfa07f95	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 / VARIO 125 18 GRAY DOFF	\N	0	HONDA	259000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	259000.00	HON-LEG-2642	2026-06-18 17:47:31.403	\N
d3c1249b-635a-4f41-a64a-8b0690e845bd	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 / VARIO 125 18 SILVER	\N	0	HONDA	255000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	255000.00	HON-LEG-2643	2026-06-18 17:47:31.403	\N
b23e72dd-ab76-42a5-88f6-13170e80694c	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 / VARIO 125 BIRU DOFF	\N	0	HONDA	170000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	170000.00	HON-LEG-2644	2026-06-18 17:47:31.403	\N
cmlezxlyz022639t5pwgtlohi	TUTUP AKI BEAT FI ESP	\N	0	HONDA	17000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	23000.00	HON-TUT-TUT-1340	2026-06-18 17:19:42.083	\N
6b277f5d-9aba-4873-82d8-4d382e5073e7	LEGSHIELD LUAR / SAYAP LUAR VARIO 110 FI / VARIO 110 FI ESP HITAM DOFF	\N	0	HONDA	140000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	140000.00	HON-LEG-2645	2026-06-18 17:47:31.403	\N
cmlezxlt5021s39t5i4zgtkew	TUTUP AKI SCOOPY FI 17	\N	0	HONDA	22000.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	24000.00	HON-TUT-TUT-1334	2026-06-18 17:19:42.083	\N
84e02c19-33c2-4627-8104-e6d30ecd7cbf	LEGSHIELD LUAR / SAYAP LUAR VARIO 110 FI / VARIO 110 FI ESP GRAY DOFF	\N	0	HONDA	140000.00	LEGSHIELD LUAR	2026-06-18 17:47:31.403	BODY PART	140000.00	HON-LEG-2646	2026-06-18 17:47:31.403	\N
cmlezxn29024y39t53i9oeji8	KARET BARSTEP /	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	8800.00	HON-TUT-KAR-1385	2026-06-18 17:19:42.083	\N
cmlezx7th019e39t5523bv8m3	MIKA LAMPU SUPRA X 125 07	\N	0	HONDA	58000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	47000.00	HON-MIK-MIK-806	2026-06-18 17:19:42.083	\N
cmlezxn7n025g39t56xt3q1d3	PIPA GAS /	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	5800.00	HON-TUT-PIP-1394	2026-06-18 17:19:42.083	\N
18a5099a-d588-4f53-920a-d09e6213b61f	LEGSHIELD DALAM VARIO 150 18 / VARIO 125 18 KECIL GRAY DOFF	\N	0	HONDA	133000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	133000.00	HON-LEG-2647	2026-06-18 17:47:31.403	\N
56ed80d7-4b3a-43b9-9c93-116a5c46ec6c	LEGSHIELD DALAM VARIO 150 18 / VARIO 125 18 KECIL MERAH	\N	0	HONDA	137000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	137000.00	HON-LEG-2648	2026-06-18 17:47:31.403	\N
57e4bbc1-472a-43f2-978c-55c1b8818a38	LEGSHIELD DALAM VARIO 150 18 / VARIO 125 18 KECIL SILVER	\N	0	HONDA	146000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	146000.00	HON-LEG-2649	2026-06-18 17:47:31.403	\N
6d9890b9-1cf3-42ac-880a-64bba1b6be38	LEGSHIELD DALAM SCOOPY FI 17 BESAR GRAY	\N	0	HONDA	227000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	227000.00	HON-LEG-2650	2026-06-18 17:47:31.403	\N
cmlg3md5i000gvu8ymb2gepfx	FRONT FENDER NINJA KUNING	\N	0	KAWASAKI	95000.00	FRONT FENDER/SPAKBOR DEPAN (KAWASAKI)	2026-02-10 04:26:17.632	BODY PART	95000.00	KAW-BOD-FRO-8	2026-06-18 17:19:42.083	\N
cmlg3mbd50002vu8yx8m0qid7	FRONT FENDER NINJA MERAH MAROON	\N	0	KAWASAKI	89000.00	FRONT FENDER/SPAKBOR DEPAN (KAWASAKI)	2026-02-10 04:26:17.633	BODY PART	89000.00	KAW-BOD-FRO-10	2026-06-18 17:19:42.083	\N
5614f128-1ebc-465f-ba66-14d6df2ed701	LEGSHIELD DALAM SCOOPY FI 17 BESAR HIJAU	\N	0	HONDA	227000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	227000.00	HON-LEG-2651	2026-06-18 17:47:31.403	\N
d233461d-ca69-469a-a30c-bc4f38f42ae8	LEGSHIELD DALAM SCOOPY FI 17 BESAR MERAH DOFF	\N	0	HONDA	227000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	227000.00	HON-LEG-2652	2026-06-18 17:47:31.403	\N
f35213a8-997d-4e1d-98f9-2611a78f4973	LEGSHIELD DALAM SCOOPY FI 17 BESAR SILVER	\N	0	HONDA	227000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	227000.00	HON-LEG-2653	2026-06-18 17:47:31.403	\N
1f86140d-7e13-4370-83d5-7da2c71295f5	LEGSHIELD DALAM SCOOPY FI ESP BESAR GRAY	\N	0	HONDA	267000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	267000.00	HON-LEG-2654	2026-06-18 17:47:31.403	\N
cmlezwfrm000039t5jsmq8rkl	COMPLETE SET BODY VARIO 150 18 MERAH	\N	0	HONDA	1939000.00		2026-02-09 09:54:25.619	BODY PART	2198000.00	HON-COM-COM-1	2026-06-18 17:27:37.767	\N
3161a5e1-2da0-4043-ab59-d9439d09a942	LEGSHIELD DALAM SCOOPY FI ESP BESAR KREM	\N	0	HONDA	267000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	267000.00	HON-LEG-2655	2026-06-18 17:47:31.403	\N
cmlg43pw600qcpv858v9xcq46	SWITCH REM BELAKANG YAMAHA	\N	0	YAMAHA	11000.00	SWITCH REM	2026-02-10 04:39:46.569	KELISTRIKAN	10000.00	YAM-AKS-SWI-688	2026-06-18 17:34:05.97	\N
10b20e6a-efa9-4814-a4c1-3b0fb346ccd9	LEGSHIELD DALAM SCOOPY FI / SCOOPY FI ESP KECIL BIRU	\N	0	HONDA	137000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	137000.00	HON-LEG-2656	2026-06-18 17:47:31.403	\N
cmlezwg8f000g39t5irvaqb12	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BEAT 20 KECIL	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG  KANAN KIRI (HONDA)	2026-02-09 09:54:25.619	BODY PART	176000.00	HON-COV-COV-18	2026-02-09 09:54:25.619	01B5932582AA1
f06213ee-244b-4eac-9130-3c17b0a13f6e	LEGSHIELD DALAM SCOOPY FI / SCOOPY FI ESP KECIL MERAH	\N	0	HONDA	137000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	137000.00	HON-LEG-2657	2026-06-18 17:47:31.403	\N
cmlezwgmq001j39t50ggys3to	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO HITAM	\N	0	HONDA	172000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	137000.00	HON-COV-COV-39	2026-02-09 09:54:25.619	01B2232740AA1
5c7118dd-845d-43a2-8b31-5845d0283a76	LEGSHIELD DALAM SCOOPY FI / SCOOPY FI ESP KECIL KREM	\N	0	HONDA	137000.00	LEGSHIELD DALAM	2026-06-18 17:47:31.403	BODY PART	137000.00	HON-LEG-2658	2026-06-18 17:47:31.403	\N
bb086d2e-ed80-410c-a573-75cf1a2cdb7f	COVER BODY / BODY SAMPING SCOOPY FI / SCOOPY FI ESP BIRU	\N	0	HONDA	261000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	261000.00	HON-COV-2659	2026-06-18 17:47:31.403	\N
11f37af8-16bc-489c-8afc-d0574b7c92d6	COVER BODY / BODY SAMPING BEAT / BEAT 10 ORANGE	\N	0	HONDA	199000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	199000.00	HON-COV-2660	2026-06-18 17:47:31.403	\N
cmlezwnzm00ca39t50irnlm9w	FRONT FENDER / SPAKBOR DEPAN  B REVO FI / REVO X	\N	0	HONDA	38000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	140000.00	HON-FRO-FRO-247	2026-02-09 09:54:35.581	01B3930982AA1
cmlezwkve007u39t5rvpn0dsy	FRONT FENDER / SPAKBOR DEPAN  VARIO 150 18 / 125 23 MERAH DOFF	\N	0	HONDA	142000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	130000.00	HON-FRO-FRO-165	2026-06-19 22:07:11.583	01B5230787AA1
cmlezwhcm003039t5v6u8eafz	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO 150 18 BESAR MERAH	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	284000.00	HON-COV-COV-46	2026-06-19 22:07:11.718	01B5232781AA1
cmlezwhqa003q39t5904ttqzr	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY FI / ESP MERAH MAROON	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	237000.00	HON-COV-COV-79	2026-06-19 22:07:11.849	01B4331852AA1
cmlezwkn0007c39t5nkcm16a1	FRONT FENDER / SPAKBOR DEPAN  B VARIO 160	\N	0	HONDA	65000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	126000.00	HON-FRO-FRO-161	2026-06-19 22:07:12.041	01B6430982AA1
cmlezwkp8007i39t5o30sqjsj	FRONT FENDER / SPAKBOR DEPAN  VARIO 150 18 / 125 23 HITAM	\N	0	HONDA	125000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	126000.00	HON-FRO-FRO-162	2026-06-19 22:07:12.628	01B5230740AA1
cmlezwkn0007f39t5hsb3krdq	FRONT FENDER / SPAKBOR DEPAN  VARIO 150 18 / 125 23 HITAM DOFF	\N	0	HONDA	142000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	126000.00	HON-FRO-FRO-163	2026-06-19 22:07:12.762	01B5230780AA1
cmlezwkvf007w39t52jb0st3x	FRONT FENDER / SPAKBOR DEPAN  VARIO 150 18 / 125 23 PUTIH	\N	0	HONDA	142000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	130000.00	HON-FRO-FRO-166	2026-06-19 22:07:12.904	01B5230747AA1
cmlezwlsy009m39t58okg9omc	FRONT FENDER / SPAKBOR DEPAN  VARIO 150 MERAH MAROON	\N	0	HONDA	110000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	126000.00	HON-FRO-FRO-171	2026-06-19 22:07:13.032	01B4430752AA1
cmlezwl7a008g39t5i8bjwmuj	FRONT FENDER / SPAKBOR DEPAN  VARIO TECHNO 125 HITAM	\N	0	HONDA	74000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	126000.00	HON-FRO-FRO-176	2026-06-19 22:07:13.169	01B3630740AA1
cmlezwl87008k39t502qv6osk	FRONT FENDER / SPAKBOR DEPAN  VARIO TECHNO 125 MERAH MAROON	\N	0	HONDA	90000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	140000.00	HON-FRO-FRO-177	2026-06-19 22:07:13.298	01B3630752AA1
cmlezwlgv008u39t5whp8hjyu	FRONT FENDER / SPAKBOR DEPAN  VARIO TECHNO 125 PUTIH	\N	0	HONDA	90000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	126000.00	HON-FRO-FRO-178	2026-06-19 22:07:14.193	01B3630747AA1
cmlezwngc00b239t5235qzaim	FRONT FENDER / SPAKBOR DEPAN  SCOOPY FI 17 HITAM	\N	0	HONDA	120000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.58	BODY PART	126000.00	HON-FRO-FRO-203	2026-06-19 22:07:14.329	01B4830740AA1
cmlezwnqi00bw39t5ikevsdc6	FRONT FENDER / SPAKBOR DEPAN  SCOOPY FI 17 KREM	\N	0	HONDA	135000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	126000.00	HON-FRO-FRO-205	2026-06-19 22:07:14.458	01B4830783AA1
cmlezwngc00bd39t5cspkvtn9	FRONT FENDER / SPAKBOR DEPAN  SCOOPY FI 17 MERAH DOFF	\N	0	HONDA	135000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.58	BODY PART	140000.00	HON-FRO-FRO-207	2026-06-19 22:07:14.598	01B4830787AA1
cmlezwnue00c039t5rrw7lmpj	FRONT FENDER / SPAKBOR DEPAN  SCOOPY FI 17 PUTIH	\N	0	HONDA	135000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	126000.00	HON-FRO-FRO-208	2026-06-19 22:07:14.731	01B4830747AA1
cmlezwngc00bc39t5p4k8pket	FRONT FENDER / SPAKBOR DEPAN  SCOOPY FI HITAM	\N	0	HONDA	111000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.58	BODY PART	126000.00	HON-FRO-FRO-209	2026-06-19 22:07:14.863	01B4330740AA1
cmlezwngc00b439t5s96pfylq	FRONT FENDER / SPAKBOR DEPAN  SCOOPY FI KREM	\N	0	HONDA	125000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.58	BODY PART	126000.00	HON-FRO-FRO-211	2026-06-19 22:07:14.997	01B4330883AA1
cmlezwngc00bg39t51xny6f60	FRONT FENDER / SPAKBOR DEPAN  SCOOPY FI GRAY DOFF	\N	0	HONDA	126000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	140000.00	HON-FRO-FRO-217	2026-06-19 22:07:15.602	01B4830786AA1
cmlezwosy00e839t5jn7zgudm	FRONT FENDER / SPAKBOR DEPAN  GENIO MERAH	\N	0	HONDA	150000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	105000.00	HON-FRO-FRO-229	2026-06-19 22:07:15.737	01B5730781AA1
cmlezwpt200f239t5boz4tolu	FRONT FENDER / SPAKBOR DEPAN  SONIC HITAM	\N	0	HONDA	44000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	89000.00	HON-FRO-FRO-241	2026-06-19 22:07:16.009	01B4730840AA1
cmlezwnyx00c839t5sjl84jjs	FRONT FENDER / SPAKBOR DEPAN  REVO FI / REVO X HITAM	\N	0	HONDA	99000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	126000.00	HON-FRO-FRO-246	2026-06-19 22:07:16.365	01B3930740AA1
cmlezwo5o00co39t5flev3qkk	FRONT FENDER / SPAKBOR DEPAN  A REVO HITAM	\N	0	HONDA	82000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	89000.00	HON-FRO-FRO-248	2026-06-19 22:07:17.261	01B2830840AA1
cmlezwobo00d439t5wd8558mu	FRONT FENDER / SPAKBOR DEPAN  A SUPRA X 125 07 HITAM	\N	0	HONDA	82000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	89000.00	HON-FRO-FRO-255	2026-06-19 22:07:17.393	01B2530840AA1
cmlezwo8l00cs39t5fh3cuvtx	FRONT FENDER / SPAKBOR DEPAN  A SUPRA X 125 07 MERAH MAROON	\N	0	HONDA	99000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	130000.00	HON-FRO-FRO-257	2026-06-19 22:07:17.524	01B2530852AA1
cmlezwquq00g239t5msyr4g85	FRONT FENDER / SPAKBOR DEPAN  MEGAPRO 06 HITAM	\N	0	HONDA	81000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	89000.00	HON-FRO-FRO-298	2026-02-09 09:54:35.582	01B8830740AA1
cmlezwrgq00gy39t54eohrpvp	REAR FENDER / SPAKBOR BELAKANG BEAT 20	\N	0	HONDA	126000.00	REAR FENDER/SPAKBOR BELAKANG (HONDA)	2026-02-09 09:54:40.778	BODY PART	80000.00	HON-REA-REA-304	2026-02-09 09:54:40.778	01B5933282AA1
cmlezwrrg00h739t5kxu16m5c	REAR FENDER / SPAKBOR BELAKANG ABSOLUTE REVO	\N	0	HONDA	92000.00	REAR FENDER / (KOLONG) VARIO TECHNO 125	2026-02-09 09:54:40.779	LAIN-LAIN	97000.00	HON-REA-REA-318	2026-02-09 09:54:40.779	01B2833282AA1
cmlezwrz800ho39t54krx396h	REAR FENDER / SPAKBOR BELAKANG REVO FI / REVO X	\N	0	HONDA	44000.00	REAR FENDER / (KOLONG) VARIO TECHNO 125	2026-02-09 09:54:40.779	LAIN-LAIN	97000.00	HON-REA-REA-319	2026-02-09 09:54:40.779	01B3933283AA1
cmlezwum300l239t5o3clqkjs	PANEL / TAMENGVARIO 150 BESAR MERAH MAROON	\N	0	HONDA	118000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	187000.00	HON-PAN-PAN-387	2026-02-09 09:54:40.78	01B4430552AA1
cmlezwp0x00eq39t5lqqnxsmg	FRONT FENDER / SPAKBOR DEPAN  A SUPRA FIT NEW HITAM	\N	0	HONDA	67000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	126000.00	HON-FRO-FRO-261	2026-06-19 22:07:17.798	01B2130840AA1
cmlezwoav00cy39t5mgqpjmuy	FRONT FENDER / SPAKBOR DEPAN  SUPRA / SUPRA X / XX HITAM	\N	0	HONDA	0.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	126000.00	HON-FRO-FRO-263	2026-06-19 22:07:17.928	01B1330740AA1
cmlezwos200e539t5ukmetyoc	FRONT FENDER / SPAKBOR DEPAN  A GRAND IMPRESSA HITAM	\N	0	HONDA	52000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	126000.00	HON-FRO-FRO-281	2026-06-19 22:07:18.062	01B0830840AA1
cmlezwoxc00ed39t57qt98ntj	FRONT FENDER / SPAKBOR DEPAN  B GRAND HITAM	\N	0	HONDA	41000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	89000.00	HON-FRO-FRO-282	2026-06-19 22:07:18.197	01B0830940AA1
cmlezwqtd00fy39t5ziomdhbb	FRONT FENDER / SPAKBOR DEPAN  MEGAPRO HITAM	\N	0	HONDA	57000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	89000.00	HON-FRO-FRO-297	2026-06-19 22:07:18.334	01B8430740AA1
cmlezwqtd00g039t5lqgd3v3k	FRONT FENDER / SPAKBOR DEPAN  MEGAPRO 10 HITAM	\N	0	HONDA	82000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	89000.00	HON-FRO-FRO-299	2026-06-19 22:07:18.475	01B9130740AA1
cmlezwrgq00h039t5czae19r8	REAR FENDER / SPAKBOR BELAKANG BEAT ESP 16	\N	0	HONDA	95000.00	REAR FENDER/SPAKBOR BELAKANG (HONDA)	2026-02-09 09:54:40.779	BODY PART	97000.00	HON-REA-REA-305	2026-06-19 22:07:18.605	01B4633282AA1
cmlezwrtm00hk39t5wd0ncg98	REAR FENDER / SPAKBOR BELAKANG BEAT POP	\N	0	HONDA	78000.00	REAR FENDER/SPAKBOR BELAKANG (HONDA)	2026-02-09 09:54:40.779	BODY PART	97000.00	HON-REA-REA-306	2026-06-19 22:07:18.742	01B4033282AA1
cmlezws2r00hw39t58cmnkm5k	REAR FENDER / SPAKBOR BELAKANG BEAT FI	\N	0	HONDA	79000.00	REAR FENDER/SPAKBOR BELAKANG (HONDA)	2026-02-09 09:54:40.779	BODY PART	97000.00	HON-REA-REA-307	2026-06-19 22:07:19.105	01B3833200AA1
cmlezwsb400ia39t5tm45r3mp	REAR FENDER / SPAKBOR BELAKANG BEAT	\N	0	HONDA	68000.00	REAR FENDER/SPAKBOR BELAKANG (HONDA)	2026-02-09 09:54:40.779	BODY PART	80000.00	HON-REA-REA-308	2026-06-19 22:07:19.238	01B2733282AA1
cmlezwt6q00j839t5uapk2c3r	REAR FENDER / SPAKBOR BELAKANG VARIO 150	\N	0	HONDA	95000.00	REAR FENDER/SPAKBOR BELAKANG (HONDA)	2026-02-09 09:54:40.779	BODY PART	80000.00	HON-REA-REA-310	2026-06-19 22:07:19.373	01B4433282AA1
cmlezwrgo00go39t57fp4rd7t	REAR FENDER / SPAKBOR BELAKANG VARIO	\N	0	HONDA	86000.00	REAR FENDER / (KOLONG) VARIO TECHNO 125	2026-02-09 09:54:40.776	LAIN-LAIN	97000.00	HON-REA-REA-314	2026-06-19 22:07:19.644	01B2233282AA1
cmlezwrgp00gs39t5k5ujy8e7	REAR FENDER / SPAKBOR BELAKANG SCOOPY 20	\N	0	HONDA	121000.00	REAR FENDER / (KOLONG) VARIO TECHNO 125	2026-02-09 09:54:40.777	LAIN-LAIN	97000.00	HON-REA-REA-315	2026-06-19 22:07:19.781	01B6233282AA1
cmlezwrhk00h239t5qzpt3y76	REAR FENDER / SPAKBOR BELAKANG SCOOPY FI	\N	0	HONDA	93000.00	REAR FENDER / (KOLONG) VARIO TECHNO 125	2026-02-09 09:54:40.779	LAIN-LAIN	97000.00	HON-REA-REA-317	2026-06-19 22:07:19.915	01B4333282AA1
cmlezwuhh00ko39t5yhy666oy	REAR FENDER / SPAKBOR BELAKANG BLADE	\N	0	HONDA	56000.00	REAR FENDER / (KOLONG) VARIO TECHNO 125	2026-02-09 09:54:40.78	LAIN-LAIN	97000.00	HON-REA-REA-326	2026-06-19 22:07:20.048	01B3033282AA1
cmlezwurr00lb39t5p0s0zix2	REAR FENDER / SPAKBOR BELAKANG KARISMA	\N	0	HONDA	64000.00	REAR FENDER / (KOLONG) VARIO TECHNO 125	2026-02-09 09:54:40.78	LAIN-LAIN	97000.00	HON-REA-REA-328	2026-06-19 22:07:20.188	01B2333282AA1
cmlezwstu00j239t5nzblapme	PANEL / TAMENGBEAT 20 BESAR HITAM	\N	0	HONDA	191000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	187000.00	HON-PAN-PAN-333	2026-06-19 22:07:20.322	01B5930540AA4
cmlezwry500hm39t5fpoxv49y	PANEL / TAMENGBEAT FI MERAH MAROON	\N	0	HONDA	168000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	342000.00	HON-PAN-PAN-350	2026-06-19 22:07:21.238	01B3830552AA4
cmlezws4x00i139t5lt1bazq3	PANEL / TAMENGBEAT / BEAT 10 HITAM	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	191000.00	HON-PAN-PAN-354	2026-06-19 22:07:21.371	01B2730540AA6
cmlezwsjt00is39t5osyknyv3	PANEL / TAMENGBEAT PUTIH	\N	0	HONDA	142000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.779	LAIN-LAIN	342000.00	HON-PAN-PAN-360	2026-06-19 22:07:21.506	01B2730547AA6
cmlezwuj400ku39t5ppkj9nl3	PANEL / TAMENGVARIO 150 18 KECIL HITAM / DASI	\N	0	HONDA	76000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	187000.00	HON-PAN-PAN-382	2026-06-19 22:07:21.642	01B5234840AA1
cmlezwurr00le39t5xwbmvdue	PANEL / TAMENGVARIO 150 BESAR HITAM	\N	0	HONDA	94000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	187000.00	HON-PAN-PAN-383	2026-06-19 22:07:21.78	01B4430540AA1
cmlezwuzx00ls39t5ag6csh5s	PANEL / TAMENGVARIO 150 BESAR GRAY PU	\N	0	HONDA	118000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	187000.00	HON-PAN-PAN-384	2026-06-19 22:07:21.921	01B4430565AA1
cmlezwuik00ks39t5tplfhmu9	PANEL / TAMENGVARIO 150 BESAR HITAM DOFF	\N	0	HONDA	118000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	187000.00	HON-PAN-PAN-385	2026-06-19 22:07:22.048	01B4430580AA1
cmlezwujm00ky39t57izx0p4q	PANEL / TAMENGVARIO 150 BESAR MERAH	\N	0	HONDA	118000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	187000.00	HON-PAN-PAN-386	2026-06-19 22:07:22.179	01B4430581AA1
cmlezwupe00l439t5ndtmljx7	PANEL / TAMENGVARIO 150 BESAR PUTIH	\N	0	HONDA	118000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	187000.00	HON-PAN-PAN-388	2026-06-19 22:07:22.767	01B4430547AA1
cmlezwurr00la39t5nwxo0298	PANEL / TAMENGVARIO 150 KECIL HITAM / DASI	\N	0	HONDA	53000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	187000.00	HON-PAN-PAN-390	2026-06-19 22:07:22.925	01B4434840AA1
cmlezwuty00lk39t5t7efsdpg	PANEL / TAMENGVARIO 110 FI HITAM PU	\N	0	HONDA	135000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	178000.00	HON-PAN-PAN-391	2026-06-19 22:07:23.061	01B4230540AA1
cmlezwuy400lm39t5tlpo4ba1	PANEL / TAMENGVARIO 160 BESAR MERAH	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	187000.00	HON-PAN-PAN-394	2026-06-19 22:07:23.193	01B6730581AA1
cf7a1d8f-c69c-4e73-a563-344ff7985811	COVER BODY / BODY SAMPING SUPRA / SUPRA X / XX / V / FIT HITAM	\N	0	HONDA	164000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	164000.00	HON-COV-2661	2026-06-18 17:47:31.403	\N
6ff1bdbb-3c37-49f2-a9b2-1a5c5f623ee6	COVER BODY / BODY SAMPING SUPRA / SUPRA X / XX / V / FIT SILVER	\N	0	HONDA	202000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	202000.00	HON-COV-2662	2026-06-18 17:47:31.403	\N
22a7dc6f-ad0e-44e1-8848-444a7ca32703	FRONT FENDER / SPAKBOR DEPAN PCX 160 HITAM DOFF	\N	0	HONDA	175000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	175000.00	HON-FRO-2663	2026-06-18 17:47:31.403	\N
cmlezwvxu00n039t54l9gwi30	PANEL / TAMENGVARIO TECHNO VIOLET	\N	0	HONDA	152000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	70000.00	HON-PAN-PAN-407	2026-06-19 22:07:23.455	01B2930561AA1
cmlezwvx400mu39t5edphwjrk	PANEL / TAMENGVARIO TECHNO KECIL VIOLET / DASI	\N	0	HONDA	88000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	70000.00	HON-PAN-PAN-409	2026-06-19 22:07:23.589	01B2934861AA1
cmlezwvmw00mf39t5a4iwxl0g	PANEL / TAMENGVARIO HITAM	\N	0	HONDA	135000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.184	LAIN-LAIN	187000.00	HON-PAN-PAN-410	2026-06-19 22:07:23.727	01B2230540AA4
cmlezwvmw00mi39t5t02gj9r2	PANEL / TAMENGVARIO MERAH MAROON	\N	0	HONDA	161000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.184	LAIN-LAIN	194000.00	HON-PAN-PAN-411	2026-06-19 22:07:23.86	01B2230552AA4
cmlezwx6100pa39t5wo3cudcs	PANEL / TAMENGVARIO PUTIH	\N	0	HONDA	164000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	218000.00	HON-PAN-PAN-413	2026-06-19 22:07:23.99	01B2230547AA4
cmlezwvmw00ma39t52epwg8hk	PANEL / TAMENGVARIO TECHNO KECIL GRAY / DASI	\N	0	HONDA	88000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.184	LAIN-LAIN	70000.00	HON-PAN-PAN-408	2026-06-19 22:07:24.118	01B2934865AA1
cmlezwy8w00rb39t51jar0x7r	PANEL / TAMENGVARIO TECHNO KECIL GRAY / DASI	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	70000.00	HON-PAN-PAN-417	2026-06-19 22:07:24.479	01B2934865AA1
cmlezwxdq00pk39t5f9r0ax3v	PANEL / TAMENGVARIO 110 FI GRAY DOFF	\N	0	HONDA	148000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	194000.00	HON-PAN-PAN-423	2026-06-19 22:07:24.61	01B4230586AA1
cmlezwvw700ms39t5qu0akacw	PANEL / TAMENGVARIO BIRU MUDA	\N	0	HONDA	175000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	201000.00	HON-PAN-PAN-428	2026-06-19 22:07:24.742	01B2230574AA4
cmlezwwo300od39t59l87fxaw	PANEL / TAMENGSCOOPY FI 17 HITAM	\N	0	HONDA	232000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	251000.00	HON-PAN-PAN-438	2026-06-19 22:07:24.87	01B4830540AA1
cmlezwx5j00p639t5ow75xg6p	PANEL / TAMENGSCOOPY FI 17 GRAY DOFF	\N	0	HONDA	263000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	277000.00	HON-PAN-PAN-439	2026-06-19 22:07:25.009	01B4830586AA1
cmlezwxit00pw39t5k3ofimkt	PANEL / TAMENGSCOOPY FI 17 KREM	\N	0	HONDA	263000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	273000.00	HON-PAN-PAN-440	2026-06-19 22:07:25.143	01B4830583AA1
cmlezwxsl00qk39t5w4j673m3	PANEL / TAMENGSCOOPY FI 17 MERAH	\N	0	HONDA	263000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	273000.00	HON-PAN-PAN-441	2026-06-19 22:07:25.275	01B4830581AA1
cmlezww3p00n839t5s733jvr7	PANEL / TAMENGSCOOPY FI 17 MERAH DOFF	\N	0	HONDA	263000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	273000.00	HON-PAN-PAN-442	2026-06-19 22:07:25.907	01B4830587AA1
cmlezww3p00n939t52e7ott1j	PANEL / TAMENGSCOOPY FI 17 PUTIH	\N	0	HONDA	263000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	292000.00	HON-PAN-PAN-443	2026-06-19 22:07:26.034	01B4830547AA1
cmlezwxdq00pl39t5x63c6c8z	PANEL / TAMENGSCOOPY MERAH MAROON	\N	0	HONDA	216000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	273000.00	HON-PAN-PAN-449	2026-06-19 22:07:26.164	01B3130555AA1
cmlezwwn500o839t53bcn32me	PANEL / TAMENGREVO FI HITAM	\N	0	HONDA	172000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	324000.00	HON-PAN-PAN-462	2026-06-19 22:07:26.293	01B3930540AA1
cmlezwyfv00ro39t57xvk6ea3	PANEL / TAMENGSUPRA X 125 /125 07 HITAM	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	88000.00	HON-PAN-PAN-472	2026-06-19 22:07:26.421	01B2030540AA1
cmlezwxhl00ps39t593oetmxc	PANEL / TAMENGXEON RC PUTIH	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	342000.00	HON-PAN-PAN-484	2026-06-19 22:07:26.552	01B1430540AA1
cmlezwxkf00py39t50kwfw93j	PANEL DEPAN BAGIAN BAWAH VARIO 110 FI	\N	0	HONDA	54000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	42000.00	HON-PAN-PAN-486	2026-06-19 22:07:26.687	01B4235182AA1
cmlezwxzh00qy39t5fwxae4a7	PANEL DEPAN BAGIAN BAWAH SCOOPY FI	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	42000.00	HON-PAN-PAN-497	2026-06-19 22:07:26.818	01B4335182AA1
cmlezww0100n239t5r5uvh7lp	PANEL / TAMENGSCOOPY 20 MERAH	\N	0	HONDA	273000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	251000.00	HON-PAN-PAN-435	2026-06-19 22:07:26.958	01B6230587AA1
cmlezww4i00nd39t5ownslj6s	PANEL / TAMENGSCOOPY FI HITAM	\N	0	HONDA	90000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	251000.00	HON-PAN-PAN-444	2026-06-19 22:07:27.148	01B4330540AA1
cmlezww4i00nc39t5fzze9jdk	PANEL / TAMENGSCOOPY FI KREM	\N	0	HONDA	105000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	273000.00	HON-PAN-PAN-445	2026-06-19 22:07:27.739	01B4330583AA1
cmlezwwdb00nr39t54wq12uxx	PANEL / TAMENGSCOOPY FI MERAH	\N	0	HONDA	105000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	273000.00	HON-PAN-PAN-446	2026-06-19 22:07:27.871	01B4330581AA1
cmlezwwn500oa39t5eyaijz4w	PANEL / TAMENGSCOOPY FI MERAH MAROON	\N	0	HONDA	105000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	273000.00	HON-PAN-PAN-447	2026-06-19 22:07:28.005	01B4330552AA1
cmlezwy8900r639t5y9vldajh	FRONT HANDLE COVER / BATOK DEPAN BEAT 20 HITAM	\N	0	HONDA	105000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:46.185	BODY PART	119000.00	HON-FRO-FRO-499	2026-06-19 22:07:28.151	01B5930040AA1
cmlezwyql00rq39t55xeh6dss	FRONT HANDLE COVER / BATOK DEPAN BEAT 20 MERAH	\N	0	HONDA	120000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-501	2026-06-19 22:07:28.294	01B5930091AA1
cmlezwyql00rr39t5ei3kyu08	FRONT HANDLE COVER / BATOK DEPAN BEAT 20 BIRU DOFF	\N	0	HONDA	120000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-503	2026-06-19 22:07:28.43	01B5930074AA1
cmlezwyqm00rx39t5jb99152m	FRONT HANDLE COVER / BATOK DEPAN BEAT ESP 16 HITAM	\N	0	HONDA	78000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-504	2026-06-19 22:07:28.564	01B4630040AA1
cmlezwzc600tc39t53h4kr0hw	FRONT HANDLE COVER / BATOK DEPAN BEAT ESP 16 BIRU	\N	0	HONDA	89000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-505	2026-06-19 22:07:28.701	01B4630074AA1
cmlezwyqm00rs39t5u7a8v8ms	FRONT HANDLE COVER / BATOK DEPAN BEAT ESP 16 MERAH	\N	0	HONDA	89000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-506	2026-06-19 22:07:29.244	01B4630081AA1
cmlezwyqm00rw39t5hoq0m7o1	FRONT HANDLE COVER / BATOK DEPAN BEAT ESP 16 PUTIH	\N	0	HONDA	89000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-507	2026-06-19 22:07:29.763	01B4630047AA1
cmlezwzaw00ta39t59nqnvcvd	FRONT HANDLE COVER / BATOK DEPAN VARIO 160 + ACC HITAM DOFF	\N	0	HONDA	162000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	190000.00	HON-FRO-FRO-537	2026-06-18 17:27:37.767	01B6434580AA1
6519262c-cf10-4971-a691-ca14ffac085d	FRONT FENDER / SPAKBOR DEPAN PCX 150 18 HITAM DOFF	\N	0	HONDA	202000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	202000.00	HON-FRO-2664	2026-06-18 17:47:31.403	\N
ce8d43d5-03c4-44a3-a757-cee645b44870	FRONT FENDER / SPAKBOR DEPAN BEAT 10 BIRU MUDA	\N	0	HONDA	96000.00	FRONT FENDER	2026-06-18 17:47:31.403	BODY PART	96000.00	HON-FRO-2665	2026-06-18 17:47:31.403	\N
cmlezx09f00vs39t59s5r7ils	FRONT HANDLE COVER / BATOK DEPAN B SCOOPY 20 HITAM	\N	0	HONDA	61000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-574	2026-02-09 09:54:50.207	01B6230240AA1
cmlezwzi500ts39t53wfipw83	FRONT HANDLE COVER / BATOK DEPAN BEAT POP HITAM	\N	0	HONDA	82000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-510	2026-06-19 22:07:30.401	01B4030040AA1
cmlezwzcf00ti39t5ihwv1vqq	FRONT HANDLE COVER / BATOK DEPAN BEAT POP PUTIH	\N	0	HONDA	97000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-511	2026-06-19 22:07:30.709	01B4030047AA1
cmlezwzdz00tn39t5rcvhv0xz	FRONT HANDLE COVER / BATOK DEPAN BEAT FI HITAM	\N	0	HONDA	75000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-515	2026-06-19 22:07:31.046	01B3830040AA1
cmlezwzi500tw39t5lfgp0153	FRONT HANDLE COVER / BATOK DEPAN BEAT HITAM	\N	0	HONDA	57000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-516	2026-06-19 22:07:31.558	01B2730040AA1
cmlezwyzd00sk39t556h7oega	FRONT HANDLE COVER / BATOK DEPAN BEAT FI PUTIH	\N	0	HONDA	85000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-532	2026-06-19 22:07:31.887	01B3830047AA1
cmlezwyqm00s639t5mghtixmg	FRONT HANDLE COVER / BATOK DEPAN BEAT FI PUTIH	\N	0	HONDA	84000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-517	2026-06-19 22:07:32.19	01B3830047AA1
cmlezwz6o00sv39t5lcgvqf81	FRONT HANDLE COVER / BATOK DEPAN BEAT FI BIRU	\N	0	HONDA	83000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-518	2026-06-19 22:07:32.438	01B3830074AA1
cmlezwyyi00sd39t5uzfynvhc	FRONT HANDLE COVER / BATOK DEPAN BEAT FI HIJAU	\N	0	HONDA	83000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-519	2026-06-19 22:07:32.578	01B3830059AA1
cmlezwyzd00sn39t5gzgz49jp	FRONT HANDLE COVER / BATOK DEPAN BEAT FI MERAH MAROON	\N	0	HONDA	83000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-520	2026-06-19 22:07:32.719	01B3830052AA1
cmlezwz8200t439t5lyfv32jt	FRONT HANDLE COVER / BATOK DEPAN BEAT BIRU TUA	\N	0	HONDA	62000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-521	2026-06-19 22:07:32.858	01B2730043AA1
cmlezwyxp00sa39t5epm53voq	FRONT HANDLE COVER / BATOK DEPAN BEAT HIJAU	\N	0	HONDA	62000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-522	2026-06-19 22:07:32.992	01B2730059AA1
cmlezwz5500ss39t5xaf3n3p5	FRONT HANDLE COVER / BATOK DEPAN BEAT MERAH MAROON	\N	0	HONDA	62000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-523	2026-06-19 22:07:33.592	01B2730052AA1
cmlezwzha00tq39t5exvf84ib	FRONT HANDLE COVER / BATOK DEPAN BEAT PUTIH	\N	0	HONDA	62000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-524	2026-06-19 22:07:33.732	01B2730047AA1
cmlezwz6q00sy39t5jbp9gb8h	FRONT HANDLE COVER / BATOK DEPAN VARIO TECHNO 125 HITAM	\N	0	HONDA	90000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.206	BODY PART	119000.00	HON-FRO-FRO-535	2026-06-19 22:07:33.866	01B3630040AA1
cmlezwzc600te39t58l7x5cvm	FRONT HANDLE COVER / BATOK DEPAN VARIO 150 18 + ACC HITAM	\N	0	HONDA	161000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-539	2026-06-19 22:07:33.996	01B5234540AA1
cmlezwzjv00u039t51nq2jlh4	FRONT HANDLE COVER / BATOK DEPAN VARIO 150 18 + ACC MERAH DOFF	\N	0	HONDA	176000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-542	2026-06-19 22:07:34.136	01B5234587AA1
cmlezwzmi00u839t53eifb2i6	FRONT HANDLE COVER / BATOK DEPAN VARIO 110 FI GRAY DOFF	\N	0	HONDA	126000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-546	2026-06-19 22:07:34.265	01B4230086AA1
cmlezwzov00ub39t5gmapbqwv	FRONT HANDLE COVER / BATOK DEPAN VARIO HITAM	\N	0	HONDA	55000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-547	2026-06-19 22:07:34.401	01B2230740AA1
cmlezwzov00ua39t5vgfsflpt	FRONT HANDLE COVER / BATOK DEPAN VARIO TECHNO GRAY	\N	0	HONDA	91000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-548	2026-06-19 22:07:34.535	01B2930065AA1
cmlezwzov00ud39t52q6236fb	FRONT HANDLE COVER / BATOK DEPAN VARIO TECHNO PUTIH	\N	0	HONDA	91000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-549	2026-06-19 22:07:34.673	01B2930047AA1
cmlezwzph00ug39t53vt80cx1	FRONT HANDLE COVER / BATOK DEPAN VARIO TECHNO VIOLET	\N	0	HONDA	91000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-550	2026-06-19 22:07:34.806	01B2930061AA1
cmlezwzwk00uu39t57czikg0t	FRONT HANDLE COVER / BATOK DEPAN VARIO 125 HITAM	\N	0	HONDA	167000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-557	2026-06-19 22:07:34.938	01B4430040AA1
cmlezwzyk00v239t5jdc7iy0g	FRONT HANDLE COVER / BATOK DEPAN VARIO 150 18 + ACC PUTIH	\N	0	HONDA	176000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-561	2026-06-19 22:07:35.532	01B5234547AA1
cmlezx04c00vg39t5zzc93jmi	FRONT HANDLE COVER / BATOK DEPAN B SCOOPY FI 17 HITAM	\N	0	HONDA	80000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-570	2026-06-19 22:07:35.668	01B4830340AA1
cmlezx0ap00w039t53susxqxt	FRONT HANDLE COVER / BATOK DEPAN REVO FI / REVO X HITAM	\N	0	HONDA	95000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-580	2026-06-19 22:07:35.804	01B3930040AA1
cmlezx0kx00wi39t5ktr2s13d	FRONT HANDLE COVER / BATOK DEPAN REVO HITAM	\N	0	HONDA	73000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-581	2026-06-19 22:07:36.063	01B2430040AA1
cmlezx0iu00wa39t50r6uy3wn	FRONT HANDLE COVER / BATOK DEPAN ABSOLUTE REVO / ABSOLUTE FIT	\N	0	HONDA	0.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	88000.00	HON-FRO-FRO-585	2026-06-19 22:07:36.364	01B2830040AA1
cmlezx0m200wm39t5uexvwuy5	FRONT HANDLE COVER / BATOK DEPAN ABSOLUTE REVO HITAM	\N	0	HONDA	94000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-586	2026-06-19 22:07:37.003	01B2830040AA1
4740040d-bf85-4a87-9519-a8180c475aa3	PANEL / TAMENG SCOOPY 20 GRAY DOFF	\N	0	HONDA	313000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	313000.00	HON-PAN-2666	2026-06-18 17:47:31.403	\N
ec84f1af-9a94-4d9f-b980-4c2d672c9f7f	PANEL / TAMENG BEAT 20 / BEAT STREET 20 BESAR GRAY DOFF	\N	0	HONDA	264000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	264000.00	HON-PAN-2667	2026-06-18 17:47:31.403	\N
55913569-d99d-4ab5-8f11-f5eedf295493	PANEL / TAMENG GENIO HITAM DOFF	\N	0	HONDA	380000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	380000.00	HON-PAN-2668	2026-06-18 17:47:31.403	\N
1c0ea246-8d96-4b13-bd2d-b2b78f2a87ed	PANEL / TAMENG GENIO GRAY DOFF	\N	0	HONDA	380000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	380000.00	HON-PAN-2669	2026-06-18 17:47:31.403	\N
0cfca73e-1509-42e7-8abe-927128d7582c	PANEL / TAMENG SCOOPY FI / SCOOPY FI ESP BIRU MUDA	\N	0	HONDA	112000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	112000.00	HON-PAN-2670	2026-06-18 17:47:31.403	\N
4321bee2-121d-4605-9c5a-1627a8d9a25a	COVER STOP  / Rr STOP SCOOPY FI / SCOOPY FI ESP MERAH MAROON	\N	0	HONDA	91000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	91000.00	HON-CST-2671	2026-06-18 17:47:31.403	\N
dc7e1468-e135-4982-8b5d-6eaa8000f6ba	COVER STOP / Rr STOP SCOOPY FI / SCOOPY FI ESP PUTIH	\N	0	HONDA	100000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	100000.00	HON-CST-2672	2026-06-18 17:47:31.403	\N
cmlezx0to00x439t5mj9436uc	FRONT HANDLE COVER / BATOK DEPAN SUPRA FIT NEW HITAM CAKRAM	\N	0	HONDA	73000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-593	2026-06-19 22:07:37.132	01B2130A40AA1
cmlezx0r100wv39t5d0oe00eq	FRONT HANDLE COVER / BATOK DEPAN SUPRA FIT HITAM CAKRAM	\N	0	HONDA	62000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-595	2026-06-19 22:07:37.58	01B1930A40AA1
cmlezx0st00x039t5tyjm16ul	FRONT HANDLE COVER / BATOK DEPAN SUPRA X 125 14 + VISOR	\N	0	HONDA	131000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-600	2026-06-19 22:07:38.317	01B4134540AA1
cmlezx18j00xa39t5fgl3j6a6	FRONT HANDLE COVER / BATOK DEPAN SPACY PUTIH	\N	0	HONDA	65000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:53.443	BODY PART	119000.00	HON-FRO-FRO-603	2026-06-19 22:07:38.651	01B3330047AA1
cmlezx23l00zm39t5sycurinv	REAR HANDLE / BATOK BELAKANG COVER BEAT 20	\N	0	HONDA	33000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	31000.00	HON-REA-REA-612	2026-06-19 22:07:38.969	01B5930182AA1
cmlezx18j00xo39t5xo4r4zkc	REAR HANDLE / BATOK BELAKANG COVER BEAT	\N	0	HONDA	29000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	31000.00	HON-REA-REA-614	2026-06-19 22:07:39.264	01B2730182AA1
cmlezx2bn010439t5urpi4yuv	REAR HANDLE / BATOK BELAKANG COVER BEAT ESP 16	\N	0	HONDA	32000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	39000.00	HON-REA-REA-616	2026-06-19 22:07:39.392	01B4630182AA1
89812ecb-a9d0-46f1-b226-983a752c675d	FOOTREST BAWAH / UNDERSIDE VARIO 150 18 B R+L MERAH	\N	0	HONDA	325000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	325000.00	HON-FOT-2673	2026-06-18 22:23:48.216	\N
cmlezx31n012239t5bekwyfi4	REAR HANDLE / BATOK BELAKANG COVER VARIO TECHNO 125 HITAM	\N	0	HONDA	63000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	31000.00	HON-REA-REA-618	2026-06-19 22:07:39.785	01B3630140AA1
cmlezwzlj00u639t5i02xody8	FRONT HANDLE COVER / BATOK DEPAN VARIO 110 FI HITAM DOFF	\N	0	HONDA	126000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	119000.00	HON-FRO-FRO-545	2026-06-19 22:07:39.919	01B4230080AA1
cmlezx2ln010y39t518nvmi0z	COVER STOP / RR STOP VARIO TECHNO 125 HITAM	\N	0	HONDA	43000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	43000.00	HON-COV-COV-665	2026-06-19 22:07:40.049	01B3633140AA1
cmlezx2g3010g39t5t86nuscg	COVER STOP / RR STOP SCOOPY FI 17 HITAM	\N	0	HONDA	91000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	91000.00	HON-COV-COV-682	2026-06-19 22:07:40.182	01B4833140AA1
cmlezx35j012e39t5tgc0t580	REAR HANDLE / BATOK BELAKANG COVER VARIO TECHNO VIOLET	\N	0	HONDA	76000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	31000.00	HON-REA-REA-619	2026-06-19 22:07:40.31	01B2930182AA1
cmlezx1wq00z039t5heasifts	REAR HANDLE / BATOK BELAKANG COVER GRAND INPRESSA	\N	0	HONDA	30000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	60000.00	HON-REA-REA-633	2026-06-19 22:07:40.437	01B0830182AA1
cmlezx1sy00yu39t5u9m1q8g9	COVER STOP / RR STOP VARIO 150 18 / 125 23 HITAM DOFF	\N	0	HONDA	120000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	38000.00	HON-COV-COV-653	2026-06-19 22:07:40.724	01B5233180AA1
cmlezx22w00zi39t5sg60f7ak	COVER STOP / RR STOP VARIO KECIL HITAM	\N	0	HONDA	26000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	110000.00	HON-COV-COV-657	2026-06-19 22:07:41.017	01B2233140AA1
cmlezx2hj010q39t57sbebsqt	COVER STOP / RR STOP VARIO KECIL MERAH MAROON	\N	0	HONDA	29000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	38000.00	HON-COV-COV-660	2026-06-19 22:07:41.401	01B2233152AA1
cmlezx23l00zl39t56tlqz4ts	COVER STOP / RR STOP VARIO 150 18 / 125 23 PUTIH	\N	0	HONDA	120000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	142000.00	HON-COV-COV-663	2026-06-19 22:07:41.706	01B5233147AA1
cmlezx3w8012u39t53qx6npv6	COVER TANGKI / COVER MESIN BEAT FI	\N	0	HONDA	50000.00	COVER TANGKI / COVER MESIN (HONDA)	2026-02-09 09:54:56.889	BODY PART	45000.00	HON-COV-COV-703	2026-06-19 22:07:42.101	01B3836682AA1
cmlezx3w8012x39t5oogdi69v	COVER TANGKI / COVER MESIN VARIO TECHNO 125	\N	0	HONDA	52000.00	COVER TANGKI / COVER MESIN VARIO 110 FI	2026-02-09 09:54:56.889	BODY PART	45000.00	HON-COV-COV-711	2026-06-19 22:07:42.228	01B3636682AA1
cmlezx450013c39t5d73w7fhk	COVER TANGKI / COVER MESIN SCOOPY FI 17 HITAM	\N	0	HONDA	197000.00	COVER TANGKI / COVER MESIN VARIO 110 FI	2026-02-09 09:54:56.889	BODY PART	24000.00	HON-COV-COV-720	2026-06-19 22:07:42.36	01B4836640AA1
cmlezx5hp015t39t50tzggx77	COVER SPEEDOMETER BEAT ESP 16 HITAM	\N	0	HONDA	98000.00	COVER SPEEDOMETER	2026-02-09 09:54:56.89	BODY PART	27000.00	HON-COV-COV-731	2026-06-19 22:07:42.846	01B4601740AA1
cmlezx4en013z39t5z0j0ckc3	LAMPU DEPAN / HEAD LAMP BEAT ESP 16	\N	0	HONDA	90000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	162000.00	HON-LAM-LAM-736	2026-06-19 22:07:43.198	01B4600200AA1
cmlezx54y015139t59o0g0bdi	LAMPU DEPAN / HEAD LAMP VARIO 110 FI ESP + LED (SOCKET 3)	\N	0	HONDA	483000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	829000.00	HON-LAM-LAM-738	2026-06-19 22:07:43.684	01B4900400AA1
cmlezx1yg00za39t5etkeir3o	COVER STOP / RR STOP VARIO KECIL PUTIH	\N	0	HONDA	29000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	119000.00	HON-COV-COV-662	2026-06-19 22:07:44.07	01B2233147AA1
cmlezx46i013i39t5ff52h2ht	COVER SPEEDOMETER VARIO 160 HITAM	\N	0	HONDA	0.00	COVER SPEEDOMETER	2026-02-09 09:54:56.889	BODY PART	78000.00	HON-COV-COV-726	2026-06-19 22:07:44.405	01B6406340AA1
432722b1-7e10-47af-8ded-4e93c3c61bb9	MIKA STOP / MIKA BELAKANG GL PRO / GL MAX (P) KO	\N	0	HONDA	38000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	38000.00	HON-MIK-2677	2026-06-18 17:47:31.403	\N
f2a26c80-91b8-4073-9985-fa8be9a72ba3	STOP LAMP / LAMPU STOP UNIT GL PRO DE SMOKE	\N	0	HONDA	83000.00	STOP LAMP	2026-06-18 17:47:31.403	KELISTRIKAN	83000.00	HON-STL-2678	2026-06-18 17:47:31.403	\N
01f3e5de-e280-4039-9e0a-447f49730928	STOP LAMP/ LAMPU STOP UNIT GL PRO DE (P)	\N	0	HONDA	73000.00	STOP LAMP	2026-06-18 17:47:31.403	KELISTRIKAN	73000.00	HON-STL-2679	2026-06-18 17:47:31.403	\N
161f2940-5e4d-4c24-817a-8a29062b99be	COMPLETE SET BODY VEGA R 06 SILVER	\N	0	HONDA	922000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	922000.00	HON-COM-2680	2026-06-18 17:47:31.403	\N
005de784-2288-448c-8d0a-ccff8364508f	PANEL / TAMENG VARIO 150 18 / VARIO 125 18 BESAR GRAY	\N	0	HONDA	179000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	179000.00	HON-PAN-2681	2026-06-18 17:47:31.403	\N
77d2b7d3-edb2-488f-b83e-d60267332e1b	PANEL / TAMENG VARIO 150 18 / VARIO 125 18 BESAR SILVER	\N	0	HONDA	179000.00	PANEL	2026-06-18 17:47:31.403	BODY PART	179000.00	HON-PAN-2682	2026-06-18 17:47:31.403	\N
8d3c4f0b-dcff-46ab-acb9-e0fe8b06681f	COVER STOP / Rr STOP SCOOPY FI 17 MERAH DOFF	\N	0	HONDA	118000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	118000.00	HON-CST-2683	2026-06-18 17:47:31.403	\N
cmlezx4ut014o39t5t7k2dx9e	LAMPU DEPAN / HEAD LAMP VARIO TECHNO 125	\N	0	HONDA	168000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	829000.00	HON-LAM-LAM-745	2026-06-19 22:07:45.02	01B3600200AA1
cmlezx6z4018439t5juq4rjya	LAMPU DEPAN / HEAD LAMP SCOOPY FI 17 + LED	\N	0	HONDA	541000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	829000.00	HON-LAM-LAM-750	2026-06-19 22:07:45.149	01B4800400AA1
cmlezx5o4016039t5rfet8b4q	LAMPU DEPAN / HEAD LAMP ABSOLUTE REVO	\N	0	HONDA	102000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	829000.00	HON-LAM-LAM-756	2026-06-19 22:07:45.275	01B2800200AA1
cmlezx6t9017u39t55iacwaf8	LAMPU DEPAN / HEAD LAMP SUPRA X 125 HELM IN	\N	0	HONDA	105000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	162000.00	HON-LAM-LAM-758	2026-06-19 22:07:45.406	01B3500200AA1
cmlezx71b018a39t5974y4560	LAMPU DEPAN / HEAD LAMP SUPRA X 125 07	\N	0	HONDA	101000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	829000.00	HON-LAM-LAM-760	2026-06-19 22:07:45.539	01B2500200AA1
cmlezx5fv015m39t5ys9zkx4r	LAMPU DEPAN / HEAD LAMP SUPRA FIT	\N	0	HONDA	83000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	627000.00	HON-LAM-LAM-762	2026-06-19 22:07:45.673	01B1900200AA1
cmlezx57z015639t52j0korrc	LAMPU DEPAN / HEAD LAMP BLADE 11	\N	0	HONDA	148000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	829000.00	HON-LAM-LAM-767	2026-06-19 22:07:45.935	01B3400200AA1
cmlezx6t9017v39t5lhevklbk	LAMPU DEPAN / HEAD LAMP KARISMA	\N	0	HONDA	80000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	829000.00	HON-LAM-LAM-780	2026-06-19 22:07:52.678	01B1400200AA1
cmlezx6f1017839t5tpuhnqmz	MIKA LAMPU VARIO 110 FI	\N	0	HONDA	113000.00	MIKA LAMPU (HONDA)	2026-02-09 09:54:56.89	KELISTRIKAN	229000.00	HON-MIK-MIK-789	2026-06-19 22:07:52.945	01B4200100AA1
cmlezx6rm017o39t5jo8nb9ze	MIKA LAMPU VARIO TECHNO 125	\N	0	HONDA	112000.00	MIKA LAMPU (HONDA)	2026-02-09 09:54:56.89	KELISTRIKAN	229000.00	HON-MIK-MIK-796	2026-06-19 22:07:53.32	01B3600100AA1
cmlezx8cv01ao39t5cuo7iqeb	MIKA LAMPU PCX	\N	0	HONDA	0.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	341000.00	HON-MIK-MIK-828	2026-06-19 22:07:53.628	01B6300100AA1
cmlezx9gf01dk39t5yo88ysm4	MIKA LAMPU XEON RC	\N	0	HONDA	242000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	341000.00	HON-MIK-MIK-833	2026-06-19 22:07:53.809	01D3500100AA1
cmlezx7th019f39t5r28v42jk	MIKA SPEEDOMETER BEAT	\N	0	HONDA	26000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	26000.00	HON-MIK-MIK-837	2026-06-19 22:07:53.929	01B2701700AA4
cmlezx93v01cq39t58fmlg2ir	MIKA SEN Fr / MIKA SEN DEPAN  BEAT FI / BEAT FI ESP	\N	0	HONDA	0.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	32000.00	HON-MIK-MIK-865	2026-06-19 22:07:54.049	01B3800700AA8
cmlezx82x019w39t5w2xz6hke	MIKA SEN Rr / MIKA SEN + STOP BEAT	\N	0	HONDA	57000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.489	LAIN-LAIN	46000.00	HON-MIK-MIK-867	2026-06-19 22:07:54.171	01B2704320AA1
cmlezx8aw01ag39t5171lxdv9	MIKA SEN Rr / MIKA SEN BELAKANG + STOP BEAT FI	\N	0	HONDA	56000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.489	LAIN-LAIN	79000.00	HON-MIK-MIK-871	2026-06-19 22:07:54.302	01B3804300AA1
cmlezx8dp01aq39t58e8ah41k	MIKA SEN Fr / MIKA SEN DEPAN  BEAT 20	\N	0	HONDA	32000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	32000.00	HON-MIK-MIK-873	2026-06-19 22:07:54.587	01B5900700AA20
cmlezx8hz01ay39t58vr48wqg	MIKA SEN Fr / MIKA SEN DEPAN  BEAT ESP 16	\N	0	HONDA	39000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	32000.00	HON-MIK-MIK-874	2026-06-19 22:07:54.965	01B4600700AA6
cmlezx5gm015p39t5hsqrztji	LAMPU DEPAN / HEAD LAMP VARIO 110 FI + LED	\N	0	HONDA	466000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	829000.00	HON-LAM-LAM-740	2026-06-19 22:07:55.304	01B4200400AA1
cmlezx54y015039t5vekrjmkv	LAMPU DEPAN / HEAD LAMP REVO	\N	0	HONDA	76000.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.889	KELISTRIKAN	829000.00	HON-LAM-LAM-755	2026-06-19 22:07:55.602	01B2400200AA1
cmlezx7un019k39t5v5u0temb	MIKA SPEEDOMETER VARIO 150 / 125	\N	0	HONDA	36000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	41000.00	HON-MIK-MIK-846	2026-06-19 22:07:55.724	01B4401700AA4
cmlezx82x019z39t5e82rpyvx	MIKA SPEEDOMETER BEAT FI	\N	0	HONDA	34000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	26000.00	HON-MIK-MIK-838	2026-06-19 22:07:56.055	01B3801700AA6
cmlezx8i601b439t55igqjztd	MIKA SEN Rr / MIKA SEN BELAKANG + STOP BEAT 20	\N	0	HONDA	70000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	32000.00	HON-MIK-MIK-875	2026-06-19 22:07:56.509	01B5904200AA3
cmlezx8kp01b939t5j6t1sz5n	MIKA SEN Rr / MIKA SEN BELAKANG + STOP BEAT ESP 16	\N	0	HONDA	43000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	79000.00	HON-MIK-MIK-877	2026-06-19 22:07:56.919	01B4604220AA2
cmlezx8nw01bk39t54ll787nv	MIKA SEN Rr / MIKA SEN BELAKANG + STOP VARIO TECHNO (P/M) KO	\N	0	HONDA	74000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	79000.00	HON-MIK-MIK-879	2026-06-19 22:07:57.188	01B2204320AA2
cmlezx8px01bo39t5syujy0re	MIKA SEN Fr / MIKA SEN DEPAN  VARIO TECHNO 125	\N	0	HONDA	30000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	94000.00	HON-MIK-MIK-883	2026-06-19 22:07:57.313	01B3600700AA6
cmlezx8tp01bw39t5u1lbhngi	MIKA SEN Rr / MIKA SEN BELAKANG + STOP VARIO TECHNO 125	\N	0	HONDA	80000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	79000.00	HON-MIK-MIK-884	2026-06-19 22:07:57.431	01B3604300AA1
cmlezx8r001bu39t5mch7d3u4	MIKA SEN Fr / MIKA SEN DEPAN  SCOOPY FI	\N	0	HONDA	40000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	94000.00	HON-MIK-MIK-885	2026-06-19 22:07:57.548	01B4300700AA6
cmlezx91n01ch39t5vqwutrsz	MIKA SEN Fr / MIKA SEN DEPAN  REVO FI / REVO X	\N	0	HONDA	50000.00	MIKA SEN (HONDA)	2026-02-09 09:55:01.49	LAIN-LAIN	94000.00	HON-MIK-MIK-891	2026-06-19 22:07:57.679	01B3900700AA5
cmlezx615016o39t5uf4s001m	LAMPU DEPAN / HEAD LAMP SUPRA X 125 14	\N	0	HONDA	104000.00		2026-02-09 09:54:56.89	KELISTRIKAN	829000.00	HON-LAM-LAM-766	2026-06-23 18:25:27.53	01B4100200AA1
cmlezxees01oe39t5skcqns30	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 FI GRAY	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.266	BODY PART	194000.00	HON-LEG-LEG-1099	2026-02-09 09:55:08.266	01B4431865AA1
cmlezxf6401po39t5szfgk3rk	LEGSHIELD LUAR / SAYAP LUAR ABSOLUTE REVO HITAM PU	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	201000.00	HON-LEG-LEG-1126	2026-02-09 09:55:11.246	01B2831840AA1
cmlezxg8f01sh39t51lk25wlr	LEGSHIELD LUAR / SAYAP LUAR GRAND R / L	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	230000.00	HON-LEG-LEG-1130	2026-02-09 09:55:11.246	01B0831882AA1
cmlezxhb001ui39t55ph09zw2	LEGSHIELD DALAM / SAYAP DALAM SUPRA X 125 04 HITAM	\N	0	HONDA	0.00	LEGSHIELD DALAM / SAYAP DALAM REVO FI HITAM	2026-02-09 09:55:11.246	BODY PART	206000.00	HON-LEG-LEG-1154	2026-02-09 09:55:11.246	01B2031740AA1
cmlezxfoe01qy39t5okn4ijh5	LEGSHIELD DALAM / SAYAP DALAM SUPRA X 125 14 BESAR	\N	0	HONDA	57000.00	LEGSHIELD DALAM / SAYAP DALAM REVO FI HITAM	2026-02-09 09:55:11.246	BODY PART	206000.00	HON-LEG-LEG-1155	2026-02-09 09:55:11.246	01B4135282AA1
cmlezxfpp01r639t5birefb0i	LEGSHIELD DALAM BEAT / BEAT 20 BESAR NON CHARGER	\N	0	HONDA	74000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	74000.00	HON-LEG-LEG-1162	2026-02-09 09:55:11.246	01B6935282AA1
cmlezxj9d01xs39t5hlkrzzxy	GARNIS VARIO 150 18 KECIL	\N	0	HONDA	17000.00	GARNIS VARIO 125 / 23	2026-02-09 09:55:15.055	LAIN-LAIN	48000.00	HON-GAR-GAR-1278	2026-02-09 09:55:15.055	01B5238300AA1
cmlezxa1a01e639t5hrv39ded	MIKA SEN Rr / MIKA SEN BELAKANG + STOP SUPRA X 125 07 (P/M)	\N	0	HONDA	50000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	79000.00	HON-MIK-MIK-906	2026-06-19 22:07:57.803	01B2504320AA2
8ee1f95b-63c9-4832-8e74-ee0b87d30a9a	COMPLETE SET BODY VARIO MERAH MAROON	\N	0	HONDA	1012000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	1012000.00	HON-COM-2685	2026-06-18 17:47:31.403	\N
cmlezxb5y01ge39t5ks7g93a8	MIKA SEN Rr / MIKA SEN BELAKANG GRAND (C) KO	\N	0	HONDA	16000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	44000.00	HON-MIK-MIK-913	2026-06-19 22:07:57.93	01B0804322AA3
cmlezxabs01ep39t54u50k8ta	MIKA SEN Fr / MIKA SEN DEPAN  GENIO	\N	0	HONDA	25000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	32000.00	HON-MIK-MIK-918	2026-06-19 22:07:58.05	01B5700700AA4
cmlezxb7e01gn39t5eug9v9fb	MIKA SEN Fr / MIKA SEN STYLO 160	\N	0	HONDA	137000.00	MIKA SEN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	136000.00	HON-MIK-MIK-923	2026-06-19 22:07:58.167	01B7200712AA1
cmlezxb5y01gg39t58ruhpddu	FRONT WINKER / SEN DEPAN UNIT BEAT 20	\N	0	HONDA	82000.00	FRONT WINKER / SEN DEPAN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	82000.00	HON-FRO-FRO-963	2026-06-19 22:07:58.29	01B5901300AA2
cmlezxb9q01gq39t5e5xz9idz	FRONT WINKER / SEN DEPAN UNIT BEAT 20	\N	0	HONDA	82000.00	FRONT WINKER / SEN DEPAN (HONDA)	2026-02-09 09:55:04.847	LAIN-LAIN	82000.00	HON-FRO-FRO-965	2026-06-19 22:07:58.414	01B5901300AA2
cmlezxbjx01he39t56cuydi4l	FRONT WINKER / SEN DEPAN UNIT VARIO TECHNO 125	\N	0	HONDA	74000.00	FRONT WINKER / SEN DEPAN (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	82000.00	HON-FRO-FRO-970	2026-06-19 22:07:58.532	01B3601300AA4
cmlezxbsl01i739t5erdm5i1d	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT VARIO	\N	0	HONDA	88000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	429000.00	HON-FRO-FRO-978	2026-06-19 22:07:58.653	01B2201500AA5
cmlezxbum01ia39t5w71l8df4	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT SCOOPY FI	\N	0	HONDA	138000.00	FRONT WINKER ASSY / SEN BELAKANG KOMPLIT (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	429000.00	HON-FRO-FRO-979	2026-06-19 22:07:58.777	01B4301500AA4
cmlezxez201pg39t5x7euqc28	LEGSHIELD LUAR / SAYAP LUAR SCOOPY FI 17 HITAM	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.245	BODY PART	194000.00	HON-LEG-LEG-1109	2026-06-19 22:07:58.896	01B4831840AA1
cmlezxfc301q039t51fe2zbsd	LEGSHIELD LUAR / SAYAP LUAR SCOOPY FI 17 GRAY DOFF	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	205000.00	HON-LEG-LEG-1111	2026-06-19 22:07:59.015	01B4831886AA1
cmlezxfjw01qs39t5zlqvlf5c	LEGSHIELD LUAR / SAYAP LUAR SUPRA FIT NEW HITAM	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	201000.00	HON-LEG-LEG-1116	2026-06-19 22:07:59.136	01B2131840AA1
cmlezxfhy01qg39t51apcww0f	LEGSHIELD LUAR / SAYAP LUAR SUPRA X 125 HITAM	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	194000.00	HON-LEG-LEG-1120	2026-06-19 22:07:59.259	01B2031840AA1
cmlezxfp101r339t5rda1r8w9	LEGSHIELD DALAM / SAYAP DALAM BEA FI BESAR	\N	0	HONDA	66000.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	111000.00	HON-LEG-LEG-1135	2026-06-19 22:07:59.381	01B3835282AA1
cmlezxfy001rq39t50biyezyd	LEGSHIELD DALAM / SAYAP DALAM BEAT POP	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	111000.00	HON-LEG-LEG-1136	2026-06-19 22:07:59.504	01B4035282AA1
cmlezxfq501r839t55vii5do1	LEGSHIELD DALAM BEAT / BEAT 20 BESAR CHARGER	\N	0	HONDA	77000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	74000.00	HON-LEG-LEG-1161	2026-06-19 22:07:59.745	01B5935282AA1
cmlezxgrr01tg39t59g8ldlyr	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM VARIO 125 23 KECIL BIRU DOFF	\N	0	HONDA	147000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	147000.00	HON-LEG-LEG-1168	2026-06-19 22:07:59.868	01B6736795AA1
cmlezxgfn01sw39t58wm731xf	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM SCOOPY 20 BESAR HITAM	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	224000.00	HON-LEG-LEG-1179	2026-06-19 22:07:59.988	01B6231840AA1
cmlezxgy501tu39t5e92y4qsi	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM SCOOPY FI 17 BESAR HITAM DOFF	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.247	BODY PART	202000.00	HON-LEG-LEG-1182	2026-06-19 22:08:00.108	01B4835280AA1
cmlezxgij01t039t5ooqfv3oc	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM SCOOPY FI 17 BESAR PUTIH	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	202000.00	HON-LEG-LEG-1183	2026-06-19 22:08:00.467	01B4835247AA1
cmlezxgky01t439t5v4do9dfj	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM SCOOPY FI 17 BESAR HIJAU	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	211000.00	HON-LEG-LEG-1184	2026-06-19 22:08:00.743	01B4835259AA1
cmlezxgld01t739t5aw4ytplg	LEGSHIELD DALAM KECIL/LACI/KUPU KUPU DALAM SCOOPY FI 17 BESAR HITAM	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.246	BODY PART	178000.00	HON-LEG-LEG-1185	2026-06-19 22:08:01.052	01B4835240AA1
cmlezxh8d01ue39t5t5luvn68	LEGSHIELD TENGAH BAWAH ABSOULUTE REVO FIT	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.247	BODY PART	43000.00	HON-LEG-LEG-1199	2026-06-19 22:08:01.373	01B3732482AA1
cmlezxhwt01um39t5lqp87glk	LEGSHIELD TENGAH ATAS ABSOULUTE REVO HITAM PU	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	43000.00	HON-LEG-LEG-1201	2026-06-19 22:08:01.681	01B2832340AA1
cmlezxk5j020239t52b9lroz7	FOOTREST ATAS + TUTUP AKI BEAT POP	\N	0	HONDA	188000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	188000.00	HON-LEG-FOO-1212	2026-02-09 09:55:15.055	01B4034382AA1
cmlezxk6b020439t5jyw7l0vh	FOOTREST ATAS + TUTUP AKI VARIO 150	\N	0	HONDA	86000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	94000.00	HON-LEG-FOO-1214	2026-02-09 09:55:15.055	01B4434382AA1
cmlezxk3t01zw39t59wuwbag6	FOOTREST ATAS + TUTUP AKI VARIO 160	\N	0	HONDA	94000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	94000.00	HON-LEG-FOO-1215	2026-02-09 09:55:15.055	01B6434382AA1
1f8805ef-9aad-4b3c-aeab-414418c15407	FRONT HANDLE COVER / BATOK DEPAN A SCOOPY FI / SCOOPY FI ESP KREM	\N	0	HONDA	90000.00	FRONT HANDLE COVER	2026-06-18 17:47:31.403	BODY PART	90000.00	HON-FHC-2686	2026-06-18 17:47:31.403	\N
cmlezxiey01vw39t5pcv89jzs	FOOTREST ATAS + TUTUP AKI SCOOPY 20	\N	0	HONDA	95000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	95000.00	HON-LEG-FOO-1218	2026-02-09 09:55:15.054	01B6234382AA1
cmlezxizn01x839t536j5tl0y	FOOTREST ATAS + TUTUP AKI SCOOPY FI 17 HITAM	\N	0	HONDA	121000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	24000.00	HON-LEG-FOO-1220	2026-02-09 09:55:15.055	01B4834382AA1
cmlezxjds01y439t5rueaqw48	FOOTREST ATAS + TUTUP AKI SCOOPY FI ESP HITAM	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	126000.00	HON-LEG-FOO-1221	2026-02-09 09:55:15.055	01B5634382AA1
cmlezxhwu01v139t5gzjkywu9	FOOTREST ATAS + TUTUP AKI SCOOPY FI ESP	\N	0	HONDA	146000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	126000.00	HON-LEG-FOO-1224	2026-02-09 09:55:15.054	01B5634382AA1
cmlezxi4c01v439t5da4le2vm	FOOTREST ATAS + TUTUP AKI SCOOPY FI	\N	0	HONDA	125000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	125000.00	HON-LEG-FOO-1225	2026-02-09 09:55:15.054	01B4334382AA1
c5fcc91f-676a-4e26-bf36-fcb9eb6ef9b8	FRONT HANDLE COVER / BATOK DEPAN  SUPRA X 125 SILVER CAKRAM	\N	0	HONDA	92000.00	FRONT HANDLE COVER	2026-06-18 17:47:31.403	BODY PART	92000.00	HON-FHC-2687	2026-06-18 17:47:31.403	\N
cmlezxicf01vm39t55op9ooki	FOOTREST BAWAH VARIO 150	\N	0	HONDA	83000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	45000.00	HON-LEG-FOO-1237	2026-02-09 09:55:15.054	01B4434982AA1
24d1b550-cd1d-4d12-9451-6e6d0dc349b7	FRONT HANDLE COVER / BATOK DEPAN  KARISMA X BIRU CAKRAM	\N	0	HONDA	75000.00	FRONT HANDLE COVER	2026-06-18 17:47:31.403	BODY PART	75000.00	HON-FHC-2688	2026-06-18 17:47:31.403	\N
cmlezxjs601z839t5t465zhzn	COVER RADIATOR VARIO 160	\N	0	HONDA	0.00	BOX FILTER UDARA	2026-02-09 09:55:15.055	MESIN & OLI	38000.00	HON-BOX-COV-1298	2026-06-18 17:19:42.083	01B6437182AA1
bbbf5dcf-c57e-45ab-8daa-d07d11576d1a	REAR HANDLE COVER / BATOK BELAKANG KARISMA X BIRU	\N	0	HONDA	69000.00	REAR HANDLE	2026-06-18 17:47:31.403	BODY PART	69000.00	HON-RHC-2689	2026-06-18 17:47:31.403	\N
7ccc054e-76c8-42a1-b0da-db554d023071	COVER STOP/ Rr STOP CB 150 R NEW MERAH	\N	0	HONDA	72000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	72000.00	HON-CST-2690	2026-06-18 17:47:31.403	\N
ab95a74c-ab9b-4f52-965c-5e0262e07ae2	COVER STOP/ Rr STOP CB 150 R NEW PUTIH	\N	0	HONDA	72000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	72000.00	HON-CST-2691	2026-06-18 17:47:31.403	\N
2f87607b-5c34-4030-8d87-a09e511a8a94	COVER STOP/ Rr STOP SCOOPY FI 17 KREM	\N	0	HONDA	118000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	118000.00	HON-CST-2692	2026-06-18 17:47:31.403	\N
12cec765-7e4f-4680-83d4-29d79de22e2a	COVER STOP/ Rr STOP SCOOPY FI / SCOOPY FI ESP KREM	\N	0	HONDA	96000.00	COVER STOP	2026-06-18 17:47:31.403	BODY PART	96000.00	HON-CST-2693	2026-06-18 17:47:31.403	\N
cmlezxidz01vu39t5q51wx9br	FOOTREST BAWAH SCOOPY FI 17 R+L KREM	\N	0	HONDA	201000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	232000.00	HON-LEG-FOO-1253	2026-06-19 22:08:01.925	01B4836583AA1
cmlezxiii01w439t5vkvnnmm4	FOOTREST BAWAH SCOOPY FI 17 R+L MERAH	\N	0	HONDA	201000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	232000.00	HON-LEG-FOO-1254	2026-06-19 22:08:02.045	01B4836581AA1
cmlezxik101w739t53z73qags	FOOTREST BAWAH SCOOPY FI 17 R+L MERAH DOFF	\N	0	HONDA	201000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.054	BODY PART	232000.00	HON-LEG-FOO-1255	2026-06-19 22:08:02.166	01B4836587AA1
cmlezxik101w639t5id4v5i1g	FOOTREST BAWAH SCOOPY FI 17 R+L PUTIH	\N	0	HONDA	201000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	232000.00	HON-LEG-FOO-1256	2026-06-19 22:08:02.285	01B4836547AA1
cmlezxinl01wk39t5w34wtlia	FOOTREST BAWAH SCOOPY FI B BIRU	\N	0	HONDA	188000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	232000.00	HON-LEG-FOO-1259	2026-06-19 22:08:02.412	01B4336574AA1
cmlezxizw01xc39t5ynq2q2gm	FOOTREST BAWAH SCOOPY FI B HITAM	\N	0	HONDA	160000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	232000.00	HON-LEG-FOO-1261	2026-06-19 22:08:02.53	01B4336540AA1
cmlezxjh701yg39t5zn2dsfs9	FOOTREST BAWAH SCOOPY FI B PUTIH	\N	0	HONDA	184000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	232000.00	HON-LEG-FOO-1264	2026-06-19 22:08:02.771	01B4336547AA1
cmlezxj3k01xi39t59ayqh231	GARNIS VARIO 150	\N	0	HONDA	44000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	48000.00	HON-LEG-GAR-1276	2026-06-19 22:08:02.893	01B4438382AA10
cmlezxj8p01xq39t59qs7b0ne	GARNIS VARIO 160	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	48000.00	HON-LEG-GAR-1277	2026-06-19 22:08:03.009	01B6438382AA7
cmlezxjit01yi39t5a9xn90fb	STANDARD SAMPING VARIO 150	\N	0	HONDA	0.00	STANDARD TENGAH	2026-02-09 09:55:15.055	KAKI-KAKI	37000.00	HON-STA-STA-1283	2026-06-19 22:08:03.134	01B4499997AA1
cmlezxjwv01zh39t5lhkbq8my	COVER RADIATOR VARIO	\N	0	HONDA	26000.00	BOX FILTER UDARA	2026-02-09 09:55:15.055	MESIN & OLI	38000.00	HON-BOX-COV-1300	2026-06-19 22:08:03.253	01B2237182AA1
cmlezxo4j026h39t5fhexuhp7	FILTER UDARA VARIO 150 18	\N	0	HONDA	27000.00		2026-02-09 09:55:22.865	LAIN-LAIN	41000.00	HON-TUT-FIL-1426	2026-06-23 18:25:31.993	01B5242400AA1
cmlezxn5t025c39t5iw6rek53	TUTUP KIPAS BEAT	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	14000.00	HON-TUT-TUT-1313	2026-06-19 22:08:03.495	01B2735882AA22
cmlezxjrs01z439t5eqzs0aj9	COVER RADIATOR VARIO 150 / 150 18 / 125 23	\N	0	HONDA	40000.00	BOX FILTER UDARA	2026-02-09 09:55:15.055	MESIN & OLI	38000.00	HON-BOX-COV-1297	2026-06-19 22:08:03.619	01B4437182AA1
cmlezxl8f020u39t5ybqx857b	COVER MESIN SET BEAT 20 / SCOOPY 20 / BEAT STREET 20	\N	0	HONDA	0.00	COVER FILTER UDARA	2026-02-09 09:55:18.839	BODY PART	52000.00	HON-COV-COV-1303	2026-06-19 22:08:03.738	01B5935582AA8
cmlezxnau025o39t5qz0tp2sw	TUTUP KIPAS BEAT ESP 16	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	19000.00	HON-TUT-TUT-1312	2026-06-19 22:08:03.859	01B4635882AA20
cmlezxm68022w39t5i7w0yfch	VISOR VARIO 125 23 PUTIH DOFF	\N	0	HONDA	0.00	TUTUP KIPAS (HONDA)	2026-02-09 09:55:18.839	LAIN-LAIN	98000.00	HON-TUT-VIS-1348	2026-06-19 22:08:03.982	01B6705593AA1
cmlezxjji01yk39t5g3phayqq	STANDARD SAMPING SUPRA	\N	0	HONDA	0.00	STANDARD TENGAH	2026-02-09 09:55:15.055	KAKI-KAKI	36000.00	HON-STA-STA-1284	2026-06-19 22:08:04.102	01B1199997AA1
c89b7a33-cfd0-4af2-912f-388a6ae820c9	TUTUP AKI BEAT ESP 16	\N	0	HONDA	28000.00	TUTUP	2026-06-18 17:47:31.403	BODY PART	28000.00	HON-TUT-2694	2026-06-18 17:47:31.403	\N
a1530eca-91c2-42cd-8d71-068168897c95	TUTUP AKI SCOOPY FI	\N	0	HONDA	29000.00	TUTUP	2026-06-18 17:47:31.403	BODY PART	29000.00	HON-TUT-2695	2026-06-18 17:47:31.403	\N
7d17c6c6-eb1e-4037-8f5b-d76223dc829e	MIKA SEN FR / MIKA SEN DEPAN BEAT 20 SMOKE	\N	0	HONDA	62000.00	MIKA	2026-06-18 17:47:31.403	KELISTRIKAN	62000.00	HON-MIK-2696	2026-06-18 17:47:31.403	\N
8a73dfd3-769e-4dd2-a674-945ab3994cbe	KARET BARSTEP SATRIA FU 150 14	\N	0	HONDA	24000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	24000.00	HON-OTH-2697	2026-06-18 17:47:31.403	\N
a229f3ac-17ab-4dbd-b52c-ece57a4a4f71	KARET BARSTEP NEW SHOGUN	\N	0	HONDA	16000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	16000.00	HON-OTH-2698	2026-06-18 17:47:31.403	\N
caca4203-9d46-429e-b1e5-389f840fc614	KARET BARSTEP TORNADO	\N	0	HONDA	18000.00	LAINNYA	2026-06-18 17:47:31.403	LAINNYA	18000.00	HON-OTH-2699	2026-06-18 17:47:31.403	\N
8772b55b-8430-455a-bfbb-0b9ae9f9bf81	PIPA GAS SUPRA X 125 07	\N	0	HONDA	13000.00	PIPA	2026-06-18 17:47:31.403	BODY PART	13000.00	HON-PIP-2700	2026-06-18 17:47:31.403	\N
ceb64782-847e-44d6-98b8-f0c631d7edfb	PIPA GAS MEGAPRO 06	\N	0	HONDA	14000.00	PIPA	2026-06-18 17:47:31.403	BODY PART	14000.00	HON-PIP-2701	2026-06-18 17:47:31.403	\N
a5dd716a-5d6c-490a-97f9-21446b86406b	PIPA GAS TORNADO	\N	0	HONDA	13000.00	PIPA	2026-06-18 17:47:31.403	BODY PART	13000.00	HON-PIP-2702	2026-06-18 17:47:31.403	\N
8b644ec5-c319-458f-8907-0b9a17b9b9c3	LAMPU DEPAN SCOOPY FI 17 + LED BIRU VARIASI	\N	0	HONDA	589000.00	LAMPU DEPAN	2026-06-18 17:47:31.403	KELISTRIKAN	589000.00	HON-LDP-2703	2026-06-18 17:47:31.403	\N
beeb57f5-269f-4681-bb73-cfe32141ab5a	LAMPU DEPAN SCOOPY FI 17 + LED MERAH VARIASI	\N	0	HONDA	589000.00	LAMPU DEPAN	2026-06-18 17:47:31.403	KELISTRIKAN	589000.00	HON-LDP-2704	2026-06-18 17:47:31.403	\N
e70fa446-1fdb-42fd-a811-ce955311bf29	COMPLETE SET BODY MIO MERAH	\N	0	HONDA	697000.00	COMPLETE SET BODY	2026-06-18 17:47:31.403	BODY PART	697000.00	HON-COM-2705	2026-06-18 17:47:31.403	\N
d10fa1a9-e8ce-4072-a102-a6a90e27056e	COVER BODY / BODY SAMPING VARIO 125 23 BESAR MERAH	\N	0	HONDA	305000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	305000.00	HON-COV-2706	2026-06-18 17:47:31.403	\N
8eb4c40e-adb9-4563-b3b1-6cac0fb8cfc1	COVER BODY / BODY SAMPING  VARIO 125 23 BESAR PUTIH DOFF	\N	0	HONDA	305000.00	COVER BODY	2026-06-18 17:47:31.403	BODY PART	305000.00	HON-COV-2707	2026-06-18 17:47:31.403	\N
ac5b5f7a-d93d-4cbb-a5a0-92e3eb438f47	BOX BAGASI SCOOPY 20	\N	0	HONDA	129000.00	BOX	2026-06-18 17:47:31.403	AKSESORIS	129000.00	HON-BOX-2110	2026-06-18 22:23:48.216	\N
91066f0b-c977-4d4f-a10c-831c05c4bf4d	BOX BAGASI BEAT 20 / BEAT STREET 20	\N	0	HONDA	91000.00	BOX	2026-06-18 17:47:31.403	AKSESORIS	91000.00	HON-BOX-2111	2026-06-18 22:23:48.216	\N
7fa71ed0-5044-41c8-bffe-a95acfeb0b51	BOX BAGASI SUPRA X 125 14	\N	0	HONDA	103000.00	BOX	2026-06-18 17:47:31.403	AKSESORIS	103000.00	HON-BOX-2112	2026-06-18 22:23:48.216	\N
4d7dba22-4b2f-41c7-b657-5aaf518a6497	BOX BAGASI ABSOLUTE REVO	\N	0	HONDA	77000.00	BOX	2026-06-18 17:47:31.403	AKSESORIS	77000.00	HON-BOX-2113	2026-06-18 22:23:48.216	\N
d40961d7-cbeb-47ba-9fc5-9e855e57fbf8	BOX BAGASI VARIO TECHNO + TUTUP BOX	\N	0	HONDA	81000.00	BOX	2026-06-18 17:47:31.403	AKSESORIS	81000.00	HON-BOX-2114	2026-06-18 22:23:48.216	\N
a24ba354-8065-4067-ab81-687b00230f49	BOX BAGASI VARIO	\N	0	HONDA	75000.00	BOX	2026-06-18 17:47:31.403	AKSESORIS	75000.00	HON-BOX-2116	2026-06-18 22:23:48.216	\N
6cc0bc3d-94ce-44f6-895d-b84334c36fa0	BOX BAGASI BEAT / BEAT 10	\N	0	HONDA	65000.00	BOX	2026-06-18 17:47:31.403	AKSESORIS	65000.00	HON-BOX-2115	2026-06-18 22:23:48.216	\N
07860490-226a-4e79-8ca1-8ee3a11f8809	BOX BAGASI SUPRA FIT NEW	\N	0	HONDA	78000.00	BOX	2026-06-18 17:47:31.403	AKSESORIS	78000.00	HON-BOX-2117	2026-06-18 22:23:48.216	\N
d9a6e726-fdf7-4504-8568-cbfddf355fd8	BOX AKI BEAT 20 / BEAT STREET 20 / BEAT 24 / BEAT STREET 24 / GENIO KECIL	\N	0	HONDA	37000.00	BOX	2026-06-18 17:47:31.403	AKSESORIS	37000.00	HON-BOX-2118	2026-06-18 22:23:48.216	\N
54d94ed7-8bb7-4e68-a003-119bf9a04e21	FOOTREST BAWAH / UNDERSIDE BEAT 24 / BEAT STREET 24	\N	0	HONDA	76000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	76000.00	HON-FOT-2135	2026-06-18 22:23:48.216	\N
20c01749-6401-4e08-9c26-c8660668388a	FOOTREST BAWAH / UNDERSIDE NEW N-MAX B R+L HITAM DOFF	\N	0	HONDA	152000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	152000.00	HON-FOT-2136	2026-06-18 22:23:48.216	\N
fd8464e7-c900-4d24-874e-a956b842c989	FOOTREST BAWAH / UNDERSIDE NEW N-MAX B R+L PUTIH	\N	0	HONDA	152000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	152000.00	HON-FOT-2137	2026-06-18 22:23:48.216	\N
ee92c3f7-6db3-49ad-b34e-22e9f936d1fc	STANDARD SAMPING SUPRA X 125 14 / BLADE 125 FI (2014 - SEKARANG)	\N	0	HONDA	29000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	29000.00	HON-STD-2150	2026-06-18 22:23:48.216	\N
1aa23cae-7911-4900-9cba-288aa7c3224f	STANDARD TENGAH REVO FI / ABSOLUTE REVO / REVO NEW (2010 - 2014)	\N	0	HONDA	91000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	91000.00	HON-STD-2151	2026-06-18 22:23:48.216	\N
6dd77887-7bb4-4ecf-a9c3-bb7092cc5c03	STANDARD TENGAH SUPRA X 125 14 / BLADE 125 FI (2014 - SEKARANG)	\N	0	HONDA	91000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	91000.00	HON-STD-2152	2026-06-18 22:23:48.216	\N
9cbd1e10-1299-40aa-bbb3-6086d57fca92	STANDARD TENGAH SUPRA X 125 / SUPRA X 125 07 (2007 - 2014) / REVO (2007 - 2009) / SUPRA FIT NEW / KARISMA / KARISMA X	\N	0	HONDA	91000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	91000.00	HON-STD-2153	2026-06-18 22:23:48.216	\N
12eb65c7-e8cb-4ef5-9f8d-79acad37695e	STANDARD TENGAH GL MAX / PRO	\N	0	HONDA	97000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	97000.00	HON-STD-2154	2026-06-18 22:23:48.216	\N
567f5dc9-1079-47aa-98ef-f6b9244b555c	BOX BAGASI BEAT ESP 16 / BEAT STREET 16	\N	0	HONDA	96000.00	BOX	2026-06-18 17:47:31.403	AKSESORIS	96000.00	HON-BOX-2412	2026-06-18 22:23:48.216	\N
e9253127-5642-484a-8a92-de21247f51c3	BOX AKI BEAT ESP 16 / BEAT STREET 16	\N	0	HONDA	23000.00	BOX	2026-06-18 17:47:31.403	AKSESORIS	23000.00	HON-BOX-2414	2026-06-18 22:23:48.216	\N
677e0917-4316-4796-8e5c-6235364352a7	FOOTREST ATAS / PINJAKAN KAKI + TUTUP AKI VARIO 160	\N	0	HONDA	107000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	107000.00	HON-FOT-2455	2026-06-18 22:23:48.216	\N
22695b91-490b-4da1-bcee-88e6c79f56ae	FOOTREST ATAS / PINJAKAN KAKI + TUTUP AKI SCOOPY 20	\N	0	HONDA	108000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	108000.00	HON-FOT-2456	2026-06-18 22:23:48.216	\N
dcc00d1e-f77c-4749-a5cd-def86fe68ba2	FOOTREST ATAS / PINJAKAN KAKI + TUTUP AKI BEAT 20 / BEAT STREET 20 / BEAT 24 / BEAT STREET 24	\N	0	HONDA	96000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	96000.00	HON-FOT-2457	2026-06-18 22:23:48.216	\N
134e595b-1c11-4997-8154-8604ad291583	FOOTREST ATAS / PINJAKAN KAKI + TUTUP AKI VARIO 110 FI ESP	\N	0	HONDA	108000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	108000.00	HON-FOT-2458	2026-06-18 22:23:48.216	\N
020ae847-3fad-4901-a1a4-fb704ca4a8a4	FOOTREST ATAS / PINJAKAN KAKI + TUTUP AKI SCOOPY FI ESP COKLAT	\N	0	HONDA	137000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	137000.00	HON-FOT-2459	2026-06-18 22:23:48.216	\N
858498b2-ad72-4e2d-ba76-ffea984e2c9e	ACCESORIES PANEL SUPRA X 125 14	\N	2	HONDA	13000.00		2026-06-18 17:47:31.403	AKSESORIS	13000.00	HON-PAN-2145	2026-06-23 19:17:00.584	\N
34ceda5b-4eb8-4adb-8881-6ca050c316dd	FOOTREST ATAS / PINJAKAN KAKI + TUTUP AKI BEAT ESP 16 / BEAT STREET 16	\N	0	HONDA	93000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	93000.00	HON-FOT-2460	2026-06-18 22:23:48.216	\N
498e08aa-56cc-42cd-ae73-2ee47e9f6833	FOOTREST ATAS / PINJAKAN KAKI + TUTUP AKI BEAT POP	\N	0	HONDA	203000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	203000.00	HON-FOT-2461	2026-06-18 22:23:48.216	\N
b706e493-d92d-4bc8-a414-53bc8f9f16be	FOOTREST ATAS / PINJAKAN KAKI + TUTUP AKI SCOOPY FI	\N	0	HONDA	136000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	136000.00	HON-FOT-2462	2026-06-18 22:23:48.216	\N
09be67ad-2711-4028-9069-093b1340a8ad	FOOTREST BAWAH / UNDERSIDE VARIO 125 23 B R+L	\N	0	HONDA	83000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	83000.00	HON-FOT-2463	2026-06-18 22:23:48.216	\N
c918c101-baec-49ca-80de-355cc33121ec	FOOTREST BAWAH / UNDERSIDE VARIO 160 A	\N	0	HONDA	52000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	52000.00	HON-FOT-2464	2026-06-18 22:23:48.216	\N
7015b579-42d8-4613-a16e-93692b33c8bd	FOOTREST BAWAH / UNDERSIDE VARIO 160 B R+L REAR	\N	0	HONDA	63000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	63000.00	HON-FOT-2465	2026-06-18 22:23:48.216	\N
6674374d-29b5-4b1c-ab9f-05e530067dda	FOOTREST BAWAH / UNDERSIDE VARIO 160 B R+L FRONT HITAM	\N	0	HONDA	188000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	188000.00	HON-FOT-2466	2026-06-18 22:23:48.216	\N
3cda1ba3-c0ea-44dd-a3dd-b1e379c5856d	FOOTREST BAWAH / UNDERSIDE VARIO 160 B R+L FRONT HITAM DOFF	\N	0	HONDA	213000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	213000.00	HON-FOT-2467	2026-06-18 22:23:48.216	\N
aedf10b8-9732-4236-91c1-37d204ce84e5	FOOTREST BAWAH / UNDERSIDE VARIO 160 B R+L FRONT MERAH DOFF	\N	0	HONDA	213000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	213000.00	HON-FOT-2468	2026-06-18 22:23:48.216	\N
4c640bce-255e-45e1-bbdf-b8b204a7d4b3	FOOTREST BAWAH / UNDERSIDE VARIO 160 B R+L FRONT PUTIH DOFF	\N	0	HONDA	213000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	213000.00	HON-FOT-2469	2026-06-18 22:23:48.216	\N
80a34c3e-979c-4284-9c6a-e77255cfdd72	FOOTREST BAWAH / UNDERSIDE BEAT 20 / BEAT STREET 20	\N	0	HONDA	84000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	84000.00	HON-FOT-2470	2026-06-18 22:23:48.216	\N
5341502a-8599-46d6-a1a4-81c6b24f8659	FOOTREST BAWAH / UNDERSIDE SCOOPY 20 B R+L HITAM	\N	0	HONDA	231000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	231000.00	HON-FOT-2471	2026-06-18 22:23:48.216	\N
e41565f5-a4b3-4040-a087-7a941554c69f	FOOTREST BAWAH / UNDERSIDE SCOOPY 20 B R+L PUTIH	\N	0	HONDA	259000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	259000.00	HON-FOT-2472	2026-06-18 22:23:48.216	\N
14794a1f-3203-4626-833f-dcf8dcf2898d	FOOTREST BAWAH / UNDERSIDE SCOOPY 20 B R+L BIRU DOFF	\N	0	HONDA	240000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	240000.00	HON-FOT-2473	2026-06-18 22:23:48.216	\N
cc4340df-b1a7-43b2-b3a0-73f049e76995	FOOTREST BAWAH / UNDERSIDE SCOOPY 20 B R+L HIJAU DOFF	\N	0	HONDA	240000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	240000.00	HON-FOT-2474	2026-06-18 22:23:48.216	\N
109b5809-9b1f-4356-b692-6f7cfea06542	FOOTREST BAWAH / UNDERSIDE PCX 150 18 B R+L HITAM	\N	0	HONDA	307000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	307000.00	HON-FOT-2475	2026-06-18 22:23:48.216	\N
fe43cb01-b8ce-4b58-b58b-20c13d1088a3	FOOTREST BAWAH / UNDERSIDE PCX 150 18 B R+L MERAH DOFF	\N	0	HONDA	331000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	331000.00	HON-FOT-2476	2026-06-18 22:23:48.216	\N
415b9be3-0539-4058-917f-0f928cb12f43	FOOTREST BAWAH / UNDERSIDE PCX 150 18 B R+L PUTIH	\N	0	HONDA	331000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	331000.00	HON-FOT-2477	2026-06-18 22:23:48.216	\N
5452cf38-8b8b-44eb-bf8c-f6c3de84f05e	FOOTREST BAWAH / UNDERSIDE PCX 150 18 A	\N	0	HONDA	49000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	49000.00	HON-FOT-2478	2026-06-18 22:23:48.216	\N
a9e03ef2-d806-4168-b0cb-6b654480dc19	FOOTREST BAWAH / UNDERSIDE VARIO 150 18 / VARIO 125 18 / 125 23 A	\N	0	HONDA	53000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	53000.00	HON-FOT-2479	2026-06-18 22:23:48.216	\N
1093741c-02af-4240-a063-bd9e8a845e67	FOOTREST BAWAH / UNDERSIDE VARIO 150 18 B R+L HITAM	\N	0	HONDA	277000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	277000.00	HON-FOT-2480	2026-06-18 22:23:48.216	\N
43a2e35d-5a76-41c7-9926-eb7ead72690f	FOOTREST BAWAH / UNDERSIDE VARIO 150 18 B R+L HITAM DOFF	\N	0	HONDA	313000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	313000.00	HON-FOT-2481	2026-06-18 22:23:48.216	\N
99331209-0ac4-4278-bc87-1caa6d3d1ac7	FOOTREST BAWAH / UNDERSIDE VARIO 150 18 B R+L MERAH DOFF	\N	0	HONDA	313000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	313000.00	HON-FOT-2482	2026-06-18 22:23:48.216	\N
900d74ba-8d73-4935-a180-b2700fb8eec2	FOOTREST BAWAH / UNDERSIDE VARIO 150 18 B R+L GRAY DOFF	\N	0	HONDA	313000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	313000.00	HON-FOT-2483	2026-06-18 22:23:48.216	\N
300c4ec1-5695-440d-a1d9-0cd485668a84	FOOTREST BAWAH / UNDERSIDE VARIO 150 18 B R+L PUTIH	\N	0	HONDA	313000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	313000.00	HON-FOT-2484	2026-06-18 22:23:48.216	\N
9bbf4c5d-8525-49f4-8044-79e959f5c98a	FOOTREST BAWAH / UNDERSIDE BEAT ESP 16 / BEAT STREET 16	\N	0	HONDA	87000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	87000.00	HON-FOT-2485	2026-06-18 22:23:48.216	\N
a5529763-c6f6-476d-bfcf-9002e99f9f5b	FOOTREST BAWAH / UNDERSIDE BEAT POP B R+L	\N	0	HONDA	88000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	88000.00	HON-FOT-2487	2026-06-18 22:23:48.216	\N
28f6c22b-982f-4645-8b0b-aa237eaba564	FOOTREST BAWAH / UNDERSIDE VARIO 110 FI ESP B R+L	\N	0	HONDA	79000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	79000.00	HON-FOT-2488	2026-06-18 22:23:48.216	\N
c86f4ad2-8400-46d6-8f38-6fc7b81d7c21	FOOTREST BAWAH / UNDERSIDE SCOOPY FI / SCOOPY FI ESP B HITAM	\N	0	HONDA	179000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	179000.00	HON-FOT-2489	2026-06-18 22:23:48.216	\N
6bd3578a-5c54-47fa-88c2-4b7619809525	FOOTREST BAWAH / UNDERSIDE SCOOPY FI / SCOOPY FI ESP B KREM	\N	0	HONDA	206000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	206000.00	HON-FOT-2490	2026-06-18 22:23:48.216	\N
d49f15d3-186d-4732-9852-453729eb55a3	FOOTREST BAWAH / UNDERSIDE SCOOPY FI / SCOOPY FI ESP B MERAH	\N	0	HONDA	206000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	206000.00	HON-FOT-2491	2026-06-18 22:23:48.216	\N
95029907-96bb-47ec-a5a4-48b4d15a453b	FOOTREST BAWAH / UNDERSIDE SCOOPY FI / SCOOPY FI ESP B PUTIH	\N	0	HONDA	206000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	206000.00	HON-FOT-2492	2026-06-18 22:23:48.216	\N
74423347-c343-45da-9d0f-ae0a2c186ebb	STANDARD SAMPING BEAT 20 / GENIO / SCOOPY 20 / BEAT STREET 20	\N	0	HONDA	33000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	33000.00	HON-STD-2556	2026-06-18 22:23:48.216	\N
9a602271-1a0d-4b5b-9153-1769aa083ef3	STANDARD SAMPING BEAT FI / BEAT POP / BEAT FI ESP	\N	0	HONDA	31000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	31000.00	HON-STD-2557	2026-06-18 22:23:48.216	\N
ec4a8684-589f-4f63-85a7-e6ee11638192	STANDARD SAMPING SUPRA / SUPRA X / SUPRA FIT	\N	0	HONDA	32000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	32000.00	HON-STD-2558	2026-06-18 22:23:48.216	\N
cmlg3snlk001cerj0bq33ngkb	PIPA GAS SATRIA FU 150 14	\N	0	SUZUKI	10000.00	PIPA GAS / (SUZUKI)	2026-02-10 04:31:07.268	AKSESORIS	13000.00	SUZ-AKS-PIP-44	2026-06-18 22:23:48.216	\N
256effad-28ed-47b0-a75e-e68f12dd57c0	STANDARD TENGAH BEAT 20 / BEAT STREET 20 / GENIO	\N	0	HONDA	89000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	89000.00	HON-STD-2559	2026-06-18 22:23:48.216	\N
70a3e005-35c3-482a-830e-c24fd5aa0eaa	STANDARD TENGAH VARIO 150 / 150 18 / 125 23	\N	0	HONDA	79000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	79000.00	HON-STD-2560	2026-06-18 22:23:48.216	\N
ff865927-e9cf-453c-aa96-35c4b024dcc4	STANDARD TENGAH BEAT FI / BEAT FI ESP / BEAT POP / SCOOPY FI / SCOOPY FI 17	\N	0	HONDA	71000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	71000.00	HON-STD-2561	2026-06-18 22:23:48.216	\N
3a208159-4045-41af-973d-8240c818fd13	STANDARD TENGAH BEAT / BEAT 10 / SCOOPY	\N	0	HONDA	78000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	78000.00	HON-STD-2562	2026-06-18 22:23:48.216	\N
03c3641c-9132-4e93-a914-1a41b5d469e5	STANDARD TENGAH SUPRA / SUPRA X / SUPRA FIT	\N	0	HONDA	83000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	83000.00	HON-STD-2563	2026-06-18 22:23:48.216	\N
dae1b5a3-185e-452c-b2b0-e0d58aa95a62	HANDFAT / KARET GAS BEAT FI / BEAT POP / VARIO 125 PGMFI / VARIO 110 FI / VARIO 150 / VARIO 125 ESP / ABSOLUTE REVO FIT / BLADE / BLADE 11 / REVO FI / SUPRA X 125 14	\N	0	HONDA	25000.00	HANDFAT	2026-06-18 17:47:31.403	AKSESORIS	25000.00	HON-HAN-2575	2026-06-18 22:23:48.216	\N
468df1b3-277f-4e7c-8de9-4376cba83bd8	HANDFAT / KARET GAS VERZA	\N	0	HONDA	27000.00	HANDFAT	2026-06-18 17:47:31.403	AKSESORIS	27000.00	HON-HAN-2577	2026-06-18 22:23:48.216	\N
7440dc4c-eb87-490d-8940-157a2c520f34	HANDFAT / KARET GAS CB 150 R	\N	0	HONDA	27000.00	HANDFAT	2026-06-18 17:47:31.403	AKSESORIS	27000.00	HON-HAN-2578	2026-06-18 22:23:48.216	\N
0e610efb-31f9-4893-820f-6d40077cf62b	HANDFAT / KARET GAS BEAT / BEAT 10 / VARIO TECHNO / VARIO / SPACY	\N	0	HONDA	26000.00	HANDFAT	2026-06-18 17:47:31.403	AKSESORIS	26000.00	HON-HAN-2579	2026-06-18 22:23:48.216	\N
2fca908d-2c44-4aeb-8f69-3763a6d12f98	HANDFAT / KARET GAS SUPRA X 125 07 / SUPRA FIT NEW / KARISMA / KARISMA X / SUPRA FIT X / SUPRA X 125 HELM IN / KIRANA	\N	0	HONDA	21000.00	HANDFAT	2026-06-18 17:47:31.403	AKSESORIS	21000.00	HON-HAN-2580	2026-06-18 22:23:48.216	\N
d68e6346-75b6-43f1-a22e-ccb76ae0f4f1	HANDFAT / KARET GAS SUPRA / SUPRA X / SUPRA XX / SUPRA FIT	\N	0	HONDA	26000.00	HANDFAT	2026-06-18 17:47:31.403	AKSESORIS	26000.00	HON-HAN-2581	2026-06-18 22:23:48.216	\N
3f6aff9e-15eb-40dd-b7a4-1d088697ee73	HANDFAT / KARET GAS GRAND / LEGENDA / LEGENDA 2 / ASTREA STAR / PRIMA / IMPRESSA	\N	0	HONDA	22000.00	HANDFAT	2026-06-18 17:47:31.403	AKSESORIS	22000.00	HON-HAN-2582	2026-06-18 22:23:48.216	\N
c044c64c-d018-4a06-82b2-aea6f2f53f85	HANDFAT / KARET GAS L/R GL PRO NEOTECH	\N	0	HONDA	22000.00	HANDFAT	2026-06-18 17:47:31.403	AKSESORIS	22000.00	HON-HAN-2583	2026-06-18 22:23:48.216	\N
e0922308-db9b-4d00-ac65-247e7f0e3b64	STANDARD SAMPING GL MAX / PRO	\N	0	HONDA	47000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	47000.00	HON-STD-2592	2026-06-18 22:23:48.216	\N
a808bc0a-9d20-4fae-ab06-38e8e1f5ea81	STANG STIR BEAT 20	\N	0	HONDA	131000.00	STANG	2026-06-18 17:47:31.403	AKSESORIS	131000.00	HON-STA-2593	2026-06-18 22:23:48.216	\N
0f782c33-6f2e-4661-a2b9-6f4bb4407496	STANG STIR VARIO 150 18 / VARIO 125 18 / VARIO 125 23	\N	0	HONDA	104000.00	STANG	2026-06-18 17:47:31.403	AKSESORIS	104000.00	HON-STA-2594	2026-06-18 22:23:48.216	\N
242dac26-177f-447c-b597-8c4b3a2643ef	STANG STIR BEAT ESP 16	\N	0	HONDA	117000.00	STANG	2026-06-18 17:47:31.403	AKSESORIS	117000.00	HON-STA-2595	2026-06-18 22:23:48.216	\N
f4c1b1e2-f899-49c7-b7d0-8eca2d09122b	STANG STIR BEAT FI CBS	\N	0	HONDA	124000.00	STANG	2026-06-18 17:47:31.403	AKSESORIS	124000.00	HON-STA-2596	2026-06-18 22:23:48.216	\N
80d16004-8a4f-44e9-83f1-ce0a43c13bc7	STANG STIR BEAT FI NON CBS	\N	0	HONDA	114000.00	STANG	2026-06-18 17:47:31.403	AKSESORIS	114000.00	HON-STA-2597	2026-06-18 22:23:48.216	\N
7f9fa7c3-382c-44a3-8d74-d5f96bcffe12	STANG STIR BEAT / BEAT 10	\N	0	HONDA	121000.00	STANG	2026-06-18 17:47:31.403	AKSESORIS	121000.00	HON-STA-2598	2026-06-18 22:23:48.216	\N
c0d77c5a-6328-49f6-b48e-4324dfa5845d	STANG STIR SUPRA X 125 07	\N	0	HONDA	87000.00	STANG	2026-06-18 17:47:31.403	AKSESORIS	87000.00	HON-STA-2599	2026-06-18 22:23:48.216	\N
c066771f-60ed-4d02-bf43-794b080795da	STANG STIR KARISMA	\N	0	HONDA	114000.00	STANG	2026-06-18 17:47:31.403	AKSESORIS	114000.00	HON-STA-2600	2026-06-18 22:23:48.216	\N
a3c3c171-2295-445d-bdc6-ecbad90a0106	STANG STIR GRAND	\N	0	HONDA	121000.00	STANG	2026-06-18 17:47:31.403	AKSESORIS	121000.00	HON-STA-2601	2026-06-18 22:23:48.216	\N
a49990a2-302b-400a-9d9f-531368905a8e	PEDAL REM ABSOLUTE REVO	\N	0	HONDA	42000.00	PEDAL	2026-06-18 17:47:31.403	AKSESORIS	42000.00	HON-PED-2602	2026-06-18 22:23:48.216	\N
90d6b888-c7e9-4c3b-aa63-b8837173499e	PEDAL REM SUPRA X 125	\N	0	HONDA	41000.00	PEDAL	2026-06-18 17:47:31.403	AKSESORIS	41000.00	HON-PED-2603	2026-06-18 22:23:48.216	\N
bdeede5f-a238-42b1-be67-004ff459fb52	PEDAL REM SUPRA / SUPRA X	\N	0	HONDA	41000.00	PEDAL	2026-06-18 17:47:31.403	AKSESORIS	41000.00	HON-PED-2604	2026-06-18 22:23:48.216	\N
9317f377-bb0d-4b26-b5b0-534c6ecea480	STANDARD SAMPING PCX 160	\N	0	HONDA	39000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	39000.00	HON-STD-2623	2026-06-18 22:23:48.216	\N
e8cc7102-408d-4d8e-9db3-4af3a3a0bd15	STANDARD SAMPING VARIO 150 / VARIO 150 18 / VARIO 125 / VARIO 125 18	\N	0	HONDA	30000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	30000.00	HON-STD-2624	2026-06-18 22:23:48.216	\N
ed6e2885-8b03-46f7-8112-1e9c3252930f	STANDARD SAMPING SCOOPY FI	\N	0	HONDA	36000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	36000.00	HON-STD-2625	2026-06-18 22:23:48.216	\N
a7749da4-02cc-4ef5-a0ab-cd4f574e5c87	STANDARD SAMPING BEAT / BEAT 10	\N	0	HONDA	32000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	32000.00	HON-STD-2626	2026-06-18 22:23:48.216	\N
5f880f1e-decd-4159-90f5-71fcd8b52a54	STANDARD TENGAH PCX 160	\N	0	HONDA	103000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	103000.00	HON-STD-2627	2026-06-18 22:23:48.216	\N
58ad3e44-52ba-4701-88f8-2c81010c2db1	STANDARD TENGAH BEAT ESP 16 / BEAT STREET 16	\N	0	HONDA	87000.00	STANDARD	2026-06-18 17:47:31.403	AKSESORIS	87000.00	HON-STD-2628	2026-06-18 22:23:48.216	\N
4c0e2862-c5cd-4712-aea4-f2f0dc6226d7	FOOTREST BAWAH/ UNDERSIDE VARIO 150 18 B R+L SILVER	\N	0	HONDA	322000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	322000.00	HON-FOT-2674	2026-06-18 22:23:48.216	\N
c14809a5-1dcf-4aeb-bbee-dcf062184e0f	FOOTREST BAWAH/ UNDERSIDE SCOOPY FI / SCOOPY FI ESP B BIRU	\N	0	HONDA	210000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	210000.00	HON-FOT-2675	2026-06-18 22:23:48.216	\N
a54de56e-299e-46a8-89ce-54e879dd9493	FOOTREST BAWAH/ UNDERSIDE SCOOPY FI / SCOOPY FI ESP B MERAH MAROON	\N	0	HONDA	210000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	210000.00	HON-FOT-2676	2026-06-18 22:23:48.216	\N
ec2425b6-179a-4024-bb0e-b2448d350122	FOOTREST BAWAH / UNDERSIDE SCOOPY 20 B R+L GRAY DOFF	\N	0	HONDA	240000.00	FOOTREST	2026-06-18 17:47:31.403	AKSESORIS	240000.00	HON-FOT-2684	2026-06-18 22:23:48.216	\N
cmlg43q1d00qppv85ga6e9hr0	HANDFAT / KARET GAS MIO J	\N	0	YAMAHA	18000.00	HANDFAT / KARET GAS (YAMAHA)	2026-02-10 04:39:46.569	AKSESORIS	21000.00	YAM-AKS-HAN-663	2026-06-18 22:23:48.216	\N
cmlg43p9u00p2pv85d5wgua6k	VISOR AEROX 155	\N	0	YAMAHA	119000.00	VISOR (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	122000.00	YAM-AKS-VIS-661	2026-06-18 22:23:48.216	\N
cmlg43oib00o8pv8550ooevzp	HANDFAT / KARET GAS L/R VEGA R 06	\N	0	YAMAHA	21000.00	HANDFAT / KARET GAS (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	24000.00	YAM-AKS-HAN-667	2026-06-18 22:23:48.216	\N
cmlg43p6f00orpv85lkbuzvrp	PIPA GAS N-MAX	\N	0	YAMAHA	9000.00	HANDFAT / KARET GAS (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	12000.00	YAM-AKS-PIP-674	2026-06-18 22:23:48.216	\N
cmlg43pfw00p9pv85qbydupos	PIPA GAS RX KING / NEW / SCORPIO / Z	\N	0	YAMAHA	10000.00	HANDFAT / KARET GAS (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	13000.00	YAM-AKS-PIP-679	2026-06-18 22:23:48.216	\N
cmlg43p6f00oqpv85qofr6pyt	HANDFAT / KARET GAS JUPITER MX	\N	0	YAMAHA	21000.00	HANDFAT / KARET GAS (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	24000.00	YAM-AKS-HAN-668	2026-06-18 22:23:48.216	\N
cmlg43o4i00nmpv85cx0my572	TUTUP KNALPOT MIO 08	\N	0	YAMAHA	51000.00	TUTUP KNALPOT (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	54000.00	YAM-AKS-TUT-654	2026-06-18 22:23:48.216	\N
cmlg43ojf00ocpv85nvbh46m9	HANDFAT / KARET GAS V-IXION	\N	0	YAMAHA	21000.00	HANDFAT / KARET GAS (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	24000.00	YAM-AKS-HAN-666	2026-06-18 22:23:48.216	\N
cmlg43oib00o0pv85m7cpurvy	HANDFAT / KARET GAS V-IXION 12	\N	0	YAMAHA	21000.00	HANDFAT / KARET GAS (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	24000.00	YAM-AKS-HAN-665	2026-06-18 22:23:48.216	\N
cmlg43p7200oupv85osfbtl5a	TUTUP KNALPOT MIO SOUL GT 125 BLUE CORE	\N	0	YAMAHA	38000.00	TUTUP KNALPOT (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	41000.00	YAM-AKS-TUT-649	2026-06-18 22:23:48.216	\N
cmlg43phf00pgpv85u2nzor7l	TUTUP KNALPOT V-IXION 12	\N	0	YAMAHA	34000.00	TUTUP KNALPOT (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	37000.00	YAM-AKS-TUT-650	2026-06-18 22:23:48.216	\N
cmlg43ol100oepv85tidk120w	PIPA GAS MIO M3	\N	0	YAMAHA	8000.00	HANDFAT / KARET GAS (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	11000.00	YAM-AKS-PIP-672	2026-06-18 22:23:48.216	\N
cmlg43p3l00oopv85sfjmcpnx	PIPA GAS MIO J	\N	0	YAMAHA	9000.00	HANDFAT / KARET GAS (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	12000.00	YAM-AKS-PIP-673	2026-06-18 22:23:48.216	\N
cmlg43pak00p6pv85wcon3diw	PIPA GAS V-IXION	\N	0	YAMAHA	10000.00	HANDFAT / KARET GAS (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	13000.00	YAM-AKS-PIP-678	2026-06-18 22:23:48.216	\N
cmlg43o2m00nfpv855axsqojs	TUTUP KNALPOT MIO J	\N	0	YAMAHA	32000.00	TUTUP KNALPOT (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	35000.00	YAM-AKS-TUT-653	2026-06-18 22:23:48.216	\N
cmlg43p1z00ogpv85zwbqxpcq	GARNIS AEROX 155	\N	0	YAMAHA	25000.00	GARNIS (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	28000.00	YAM-AKS-GAR-660	2026-06-18 22:23:48.216	\N
cmlg43qho00repv85vot6dc3y	HANDFAT / KARET GAS MIO 08	\N	0	YAMAHA	23000.00	HANDFAT / KARET GAS (YAMAHA)	2026-02-10 04:39:46.569	AKSESORIS	26000.00	YAM-AKS-HAN-664	2026-06-18 22:23:48.216	\N
cmlg43p3000olpv857xsl6b9r	TUTUP KNALPOT MIO M3 / MIO Z	\N	0	YAMAHA	40000.00	TUTUP KNALPOT (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	43000.00	YAM-AKS-TUT-648	2026-06-18 22:23:48.216	\N
cmlg43pai00p4pv85p3jbh7yl	PIPA GAS VEGA ZR	\N	0	YAMAHA	9000.00	HANDFAT / KARET GAS (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	12000.00	YAM-AKS-PIP-677	2026-06-18 22:23:48.216	\N
cmlg43q4w00qupv85p0b2a73m	PIPA GAS MIO / 08 / MIO SOUL	\N	0	YAMAHA	9000.00	HANDFAT / KARET GAS (YAMAHA)	2026-02-10 04:39:46.569	AKSESORIS	12000.00	YAM-AKS-PIP-671	2026-06-18 22:23:48.216	\N
cmlg43p8000owpv85lmdo7h5j	PIPA GAS JUPITER MX 11	\N	0	YAMAHA	10000.00	HANDFAT / KARET GAS (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	13000.00	YAM-AKS-PIP-675	2026-06-18 22:23:48.216	\N
cmlg43p9600oypv856izam4mx	PIPA GAS JUPITER MX	\N	0	YAMAHA	11000.00	HANDFAT / KARET GAS (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	14000.00	YAM-AKS-PIP-676	2026-06-18 22:23:48.216	\N
cmlg43phf00phpv8518mh39hd	HANDFAT / KARET GAS JUPITER Z HITAM	\N	0	YAMAHA	25000.00	HANDFAT / KARET GAS (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	28000.00	YAM-AKS-HAN-669	2026-06-18 22:23:48.216	\N
cmlg43pqa00q2pv85omghaqn4	PIPA GAS (YAMAHA)	\N	0	YAMAHA	0.00	HANDFAT / KARET GAS (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	0.00	YAM-AKS-PIP-670	2026-06-18 22:23:48.216	\N
cmlg43pgh00pepv85mbgk6bwa	PIPA GAS F1Z-R / F1 / CRYPTON / JUPITER / Z / Z 06	\N	0	YAMAHA	10000.00	HANDFAT / KARET GAS (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	13000.00	YAM-AKS-PIP-680	2026-06-18 22:23:48.216	\N
cmlg43prj00q5pv85kvghu9w5	VISOR N-MAX 155	\N	0	YAMAHA	146000.00	VISOR (YAMAHA)	2026-02-10 04:39:46.568	AKSESORIS	149000.00	YAM-AKS-VIS-662	2026-06-18 22:23:48.216	\N
cmlg43pyx00qipv85ejihmayp	TUTUP KNALPOT N-MAX	\N	0	YAMAHA	46000.00	TUTUP KNALPOT (YAMAHA)	2026-02-10 04:39:46.569	AKSESORIS	49000.00	YAM-AKS-TUT-652	2026-06-18 22:23:48.216	\N
98351aa9-dbef-48fc-a289-e3faeaa77c0f	KARET BARSTEP SATRIA FU 150 14	\N	0	SUZUKI	22000.00	BARSTEP	2026-06-18 17:44:06.615	AKSESORIS	22000.00	SUZ-BAR-2	2026-06-18 22:23:48.216	\N
f614bb29-0aa7-429f-b274-84a71cf959b0	KARET BARSTEP NEW SHOGUN	\N	0	SUZUKI	15000.00	BARSTEP	2026-06-18 17:44:06.615	AKSESORIS	15000.00	SUZ-BAR-3	2026-06-18 22:23:48.216	\N
3a08246e-8947-4895-85eb-6d79a0aee635	KARET BARSTEP TORNADO	\N	0	SUZUKI	17000.00	BARSTEP	2026-06-18 17:44:06.615	AKSESORIS	17000.00	SUZ-BAR-4	2026-06-18 22:23:48.216	\N
cmlg3sn5n000yerj0v9tm2jfz	HANDFAT L/R SHOGUN	\N	0	SUZUKI	17000.00	HANDFAT / (SUZUKI)	2026-02-10 04:31:07.267	AKSESORIS	20000.00	SUZ-AKS-HAN-43	2026-06-18 22:23:48.216	\N
cmlg3so0k001perj0sxklkqfg	PIPA GAS NEW SHOGUN	\N	0	SUZUKI	11000.00	PIPA GAS / (SUZUKI)	2026-02-10 04:31:07.268	AKSESORIS	14000.00	SUZ-AKS-PIP-46	2026-06-18 22:23:48.216	\N
cmlg3sps8003aerj03t1ixz9x	VISOR SATRIA FU 150	\N	0	SUZUKI	45000.00	VISOR / (SUZUKI)	2026-02-10 04:31:07.269	AKSESORIS	48000.00	SUZ-AKS-VIS-74	2026-06-18 22:23:48.216	\N
cmlg3smtz000uerj0t1dx9smm	HANDFAT SATRIA FU 150 14	\N	0	SUZUKI	21000.00	HANDFAT / (SUZUKI)	2026-02-10 04:31:07.267	AKSESORIS	24000.00	SUZ-AKS-HAN-42	2026-06-18 22:23:48.216	\N
cmlezxogk027639t51tk0jd9s	BARSTEP BLADE 11	\N	0	HONDA	19000.00		2026-02-09 09:55:22.865	LAIN-LAIN	22000.00	HON-TUT-BAR-1443	2026-06-19 10:47:18.364	\N
cmlezwggi001339t5okvvkytn	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BEAT FI PUTIH	\N	0	HONDA	191000.00	COVER BODY / BODY SAMPING BELAKANG  KANAN KIRI (HONDA)	2026-02-09 09:54:25.619	BODY PART	191000.00	HON-COV-COV-16	2026-06-19 22:05:52.071	01B3832747AA1
cmlezxe2h01nh39t59i3rmvh8	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 HITAM	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.266	BODY PART	239000.00	HON-LEG-LEG-1086	2026-06-19 22:05:54.064	01B5231840AA1
cmlezxf5i01pm39t5x11pcnox	LEGSHIELD LUAR / SAYAP LUAR SUPRA X 125 14 PUTIH	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	231000.00	HON-LEG-LEG-1117	2026-06-19 22:05:55.801	01B4131847AA1
cmlezxgld01t639t5toi6uxhe	LEGSHIELD DALAM / SAYAP DALAM VARIO 125 23 KECIL MERAH	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:11.246	BODY PART	102000.00	HON-LEG-LEG-1138	2026-06-19 22:05:57.841	01B6736781AA1
cmlezx5w4016e39t52lcxzelw	LAMPU DEPAN / HEAD LAMP BEAT 20 / BEAT STREET 20 + LED	\N	0	HONDA	0.00	LAMPU DEPAN / HEAD LAMP	2026-02-09 09:54:56.89	KELISTRIKAN	351000.00	HON-LAM-LAM-733	2026-06-19 22:06:00.018	01B5900400AA6
cmlezwnmx00bl39t5kvp8qdgq	FRONT FENDER / SPAKBOR DEPAN  SCOOPY 20 PUTIH DOFF	\N	0	HONDA	150000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	162000.00	HON-FRO-FRO-202	2026-06-19 22:06:01.618	01B6230793AA1
cmlezxe1u01nd39t5nzfbdwdj	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 MERAH DOFF	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.266	BODY PART	257000.00	HON-LEG-LEG-1085	2026-06-19 22:06:02.629	01B5231887AA1
cmlezwzae00t839t5ognrtzmd	FRONT HANDLE COVER / BATOK DEPAN VARIO 160 + ACC MERAH DOFF	\N	0	HONDA	162000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	190000.00	HON-FRO-FRO-538	2026-06-19 22:06:05.247	01B6434587AA1
cmlezwrgo00gq39t5vf3x7qae	FRONT FENDER / SPAKBOR DEPAN  A KARISMA HITAM	\N	0	HONDA	59000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:40.777	BODY PART	89000.00	HON-FRO-FRO-302	2026-06-19 22:06:07.631	01B1430840AA1
cmlezx7o0019839t5cpzhp7me	MIKA SPEEDOMETER VARIO 150 18 / 125 23	\N	0	HONDA	41000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.489	KELISTRIKAN	43000.00	HON-MIK-MIK-844	2026-06-19 22:06:11.307	01B5201700AA12
cmlezx2hb010m39t5lbosancc	COVER STOP / RR STOP SCOOPY FI 17 GRAY DOFF	\N	0	HONDA	116000.00	COVER STOP / RR STOP (HONDA)	2026-02-09 09:54:53.444	BODY PART	116000.00	HON-COV-COV-683	2026-06-19 22:06:13.92	01B4833186AA1
cmlezwh23002k39t5zq67eyao	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO 150 125 BESAR MERAH	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.619	BODY PART	305000.00	HON-COV-COV-45	2026-06-19 22:06:15.847	01B4432781AA1
cmlezwsix00iq39t51vxv33te	REAR FENDER / SPAKBOR BELAKANG VARIO 150 18 / 125 23	\N	0	HONDA	44000.00	REAR FENDER/SPAKBOR BELAKANG (HONDA)	2026-02-09 09:54:40.779	BODY PART	17000.00	HON-REA-REA-309	2026-06-19 22:06:18.883	01B5233282AA1
cmlezwv5d00m439t5i23qrv7k	PANEL / TAMENGVARIO TECHNO 125 23 KECIL HITAM DOFF	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:40.78	LAIN-LAIN	136000.00	HON-PAN-PAN-400	2026-06-19 22:06:20.992	01B6734880AA1
cmlezwxl400q439t5w6wqaym5	PANEL / TAMENGSCOOPY 20 HITAM	\N	0	HONDA	251000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	270000.00	HON-PAN-PAN-433	2026-06-19 22:06:21.897	01B6230540AA1
cmlezwxz500qw39t5rcbbf8gg	PANEL DEPAN BAGIAN BAWAH SCOOPY 20	\N	0	HONDA	0.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	96000.00	HON-PAN-PAN-494	2026-06-19 22:06:23.468	01B6235182AA1
cmlezxjz701zu39t54h1eh1kg	FOOTREST ATAS + TUTUP AKI BEAT ESP 16 / BEAT STREET 16	\N	0	HONDA	84000.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:15.055	BODY PART	93000.00	HON-LEG-FOO-1213	2026-06-19 22:06:23.609	01B4634382AA1
cmlezwxrp00qg39t5u7h4vpln	PANEL DEPAN BAGIAN BAWAH BEAT FI / ESP	\N	0	HONDA	69000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	76000.00	HON-PAN-PAN-492	2026-06-19 22:06:24.022	01B3835182AA1
cmlezwzdb00tk39t5rzkqzcrl	FRONT HANDLE COVER / BATOK DEPAN BEAT FI ESP HITAM	\N	0	HONDA	86000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	95000.00	HON-FRO-FRO-512	2026-06-19 22:06:25.169	01B4530040AA1
cmlezx0q500wo39t5m3h8qzvc	FRONT HANDLE COVER / BATOK DEPAN SUPRA X 125 HITAM CAKRAM	\N	0	HONDA	66000.00	FRONT HANDLE COVER / BATOK DEPAN (HONDA)	2026-02-09 09:54:50.207	BODY PART	71000.00	HON-FRO-FRO-591	2026-06-19 22:06:26.222	01B2030A40AA1
cmlezx1lj00y839t5ka6064xe	REAR HANDLE / BATOK BELAKANG COVER VARIO 150	\N	0	HONDA	35000.00	REAR HANDLE / BATOK BELAKANG (HONDA)	2026-02-09 09:54:53.444	BODY PART	26000.00	HON-REA-REA-624	2026-06-19 22:06:26.798	01B4430100AA1
cmlezxhb001uj39t5impyogjq	LEGSHIELD TENGAH SUPRA FIT NEW HITAM PU	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.247	BODY PART	58000.00	HON-LEG-LEG-1194	2026-06-19 22:06:28.283	01B2132282AA1
cmlg43ee0007spv85nf24kvkx	PANEL DEPAN BAGIAN BAWAH MIO SOUL	\N	0	YAMAHA	50000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	54000.00	YAM-BOD-PAN-371	2026-06-19 22:06:32.153	01D2635182AA1
cmlg43ff0009spv85t0c2g4gx	PANEL MIO 08 PUTIH	\N	0	YAMAHA	110000.00	PANEL (YAMAHA)	2026-02-10 04:39:33.557	BODY PART	114000.00	YAM-BOD-PAN-314	2026-06-19 22:06:36.189	01D2430547AA1
cmlg44awj004ax6tt7tp42e9q	LEGSHIELD DALAM MIO	\N	0	YAMAHA	60000.00	LEGSHIELD DALAM (YAMAHA)	2026-02-10 04:40:07.576	BODY PART	63000.00	YAM-BOD-LEG-96	2026-06-19 22:06:40.501	01D1935282AA1
cmlezwkyv008239t5tezu010x	FRONT FENDER / SPAKBOR DEPAN  VARIO 150 HITAM DOFF	\N	0	HONDA	110000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:30.884	BODY PART	105000.00	HON-FRO-FRO-168	2026-06-19 22:06:41.418	01B4430780AA1
cmlg44ew0008cx6tte2e2fc73	FRONT FENDER/SPAKBOR DEPAN MIO 08 BIRU MUDA	\N	0	YAMAHA	83000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:40:18.146	BODY PART	86000.00	YAM-BOD-FRO-189	2026-06-19 22:06:41.941	01D2430760AA1
cmlezxees01oc39t5gbp57uuz	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 HITAM DOFF	\N	0	HONDA	0.00	LEGSHIELD LUAR / SAYAP LUAR VARIO 150 18 KECIL	2026-02-09 09:55:08.266	BODY PART	194000.00	HON-LEG-LEG-1098	2026-06-19 22:06:42.218	01B4431880AA1
cmlezxha101ug39t5luafvo0t	LEGSHIELD TENGAH ATAS ABSOULUTE REVO X FIT	\N	0	HONDA	0.00	LEGSHIELD DALAM KECIL / LACI / KUPU KUPU	2026-02-09 09:55:11.247	BODY PART	48000.00	HON-LEG-LEG-1200	2026-06-19 22:06:42.882	01B3732382AA1
cmlezwij0005239t5063dik90	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VERZA HITAM	\N	0	HONDA	169000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	137000.00	HON-COV-COV-97	2026-06-19 22:06:43.41	01B9232740AA1
cmlg44497000cx6ttzgu81sx7	REAR HANDLE COVER /BATOK BELAKANG MIO SOUL	\N	0	YAMAHA	24000.00	REAR HANDLE COVER /BATOK BELAKANG(YAMAHA)	2026-02-10 04:40:07.574	BODY PART	27000.00	YAM-BOD-REA-22	2026-06-19 22:06:43.948	01D2630182AA1
cmlg4394g0024pv85s94h9cf3	FRONT FENDER/SPAKBOR DEPAN N-MAX HITAM	\N	0	YAMAHA	82000.00	FRONT FENDER/SPAKBOR DEPAN (YAMAHA)	2026-02-10 04:39:23.839	BODY PART	85000.00	YAM-BOD-FRO-259	2026-06-19 22:06:44.923	01D4230779AA1
cmlg43eyk0094pv85xe7nczqv	FRONT HANDLE COVER/ BATOK DEPAN MIO 08 MERAH MAROON	\N	0	YAMAHA	62000.00	FRONT HANDLE COVER/ BATOK DEPAN (YAMAHA)	2026-02-10 04:39:33.556	BODY PART	65000.00	YAM-BOD-FRO-384	2026-06-19 22:06:47.211	01D2430052AA1
cmlezwgj4001839t5l9j36fu4	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI BEAT ESP 16 HITAM	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG  KANAN KIRI (HONDA)	2026-02-09 09:54:25.619	BODY PART	176000.00	HON-COV-COV-31	2026-06-19 22:06:50.471	01B4632740AA1
cmlezwhwy004239t55jnr87ir	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI SCOOPY MERAH MAROON	\N	0	HONDA	174000.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:25.62	BODY PART	177000.00	HON-COV-COV-81	2026-06-19 22:06:53.845	01B3132755AA1
cmlezwkn0007e39t5dzg2pu0c	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI KHARISMA X HITAM + COVER STOP	\N	0	HONDA	0.00	COVER BODY / BODY SAMPING BELAKANG KANAN KIRI VARIO TECHNO 125 PUTIH	2026-02-09 09:54:30.884	BODY PART	231000.00	HON-COV-COV-122	2026-06-19 22:06:55.693	01B2334440AA1
cmlezx8vc01c439t5f7urkng1	MIKA SPEEDOMETER VARIO	\N	0	HONDA	22000.00	MIKA LAMPU (HONDA)	2026-02-09 09:55:01.49	KELISTRIKAN	27000.00	HON-MIK-MIK-843	2026-06-19 22:06:56.448	01B1901700AA8
cmlezxbjd01hc39t58kuj9zcp	FRONT WINKER / SEN DEPAN UNIT SCOOPY 20	\N	0	HONDA	116000.00	FRONT WINKER / SEN DEPAN (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	109000.00	HON-FRO-FRO-971	2026-06-19 22:06:56.711	01B6206400AA5
cmlezxbk601hh39t5jzfkopkw	FRONT WINKER / SEN DEPAN UNIT GENIO	\N	0	HONDA	66000.00	FRONT WINKER / SEN DEPAN (HONDA)	2026-02-09 09:55:04.848	LAIN-LAIN	76000.00	HON-FRO-FRO-975	2026-06-19 22:06:58.08	01B5701300AA2
cmlezwx4500p139t5slw5858s	PANEL / TAMENGABSOLUTE REVO FIT HITAM	\N	0	HONDA	161000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	165000.00	HON-PAN-PAN-464	2026-06-19 22:07:00.429	01B3730540AA1
cmlezxdqq01ml39t54peyfcsi	LEGSHIELD DALAM ATAS / LEGSHIELD KONTAK VARIO 110 FI / FI ESP KECIL	\N	0	HONDA	0.00	LEGSHIELD DALAM ATAS / LEGSHIELD KONTAK (HONDA)	2026-02-09 09:55:08.265	BODY PART	66000.00	HON-LEG-LEG-1076	2026-06-19 22:07:02.416	01B4206340AA8
cmlezxjbr01y039t5n1ynt6lt	STANDARD SAMPING BEAT ESP 16	\N	0	HONDA	0.00	STANDARD TENGAH	2026-02-09 09:55:15.055	KAKI-KAKI	27000.00	HON-STA-STA-1281	2026-06-19 22:07:02.546	01B4699997AA1
cmlezwvx400mv39t5fpmf7o6j	PANEL / TAMENGVARIO 150 18 BESAR SILVER	\N	0	HONDA	195000.00	PANEL / TAMENG (HONDA)	2026-02-09 09:54:46.185	LAIN-LAIN	187000.00	HON-PAN-PAN-420	2026-06-19 22:07:11.315	01B5230542AA1
cmlezwojr00dk39t5uxsjx2wy	FRONT FENDER / SPAKBOR DEPAN  VERZA HITAM	\N	0	HONDA	128000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	89000.00	HON-FRO-FRO-239	2026-06-19 22:07:11.45	01B9230740AA1
cmlezwnue00c139t56dfsba9k	FRONT FENDER / SPAKBOR DEPAN  CB 150 R NEW PUTIH	\N	0	HONDA	137000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.581	BODY PART	105000.00	HON-FRO-FRO-237	2026-06-19 22:07:15.874	01B9630747AA1
cmlezwonl00ds39t5mted6v1v	FRONT FENDER / SPAKBOR DEPAN  A SUPRA X 125 HITAM	\N	0	HONDA	79000.00	FRONT FENDER / SPAKBOR DEPAN (HONDA)	2026-02-09 09:54:35.582	BODY PART	89000.00	HON-FRO-FRO-259	2026-06-19 22:07:17.659	01B2030840AA1
cmlezwu7h00ka39t5edrm0imr	REAR FENDER / SPAKBOR BELAKANG VARIO 110 FI	\N	0	HONDA	80000.00	REAR FENDER/SPAKBOR BELAKANG (HONDA)	2026-02-09 09:54:40.779	BODY PART	97000.00	HON-REA-REA-311	2026-06-19 22:07:19.51	01B4233282AA1
\.


--
-- Data for Name: ShopData; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ShopData" (id, name) FROM stdin;
\.


--
-- Data for Name: Transaction; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Transaction" ("totalAmount", "createdAt", id, "isComplete", "changeAmount", "paymentAmount", status, "discountAmount", "deletedAt") FROM stdin;
210000.00	2026-06-19 10:15:39.21	TRS-be0fb001	t	40000.00	250000.00	SUKSES	0.00	\N
22000.00	2026-06-19 10:47:17.123	TRS-9568c2b9	t	3000.00	25000.00	SUKSES	0.00	\N
661000.00	2026-06-19 22:46:21.971	TRS-98ae404c	t	9000.00	670000.00	SUKSES	0.00	\N
13000.00	2026-06-21 11:21:07.904	TRS-00d93ea6	t	7000.00	20000.00	SUKSES	0.00	\N
210000.00	2026-06-21 11:24:10.379	TRS-058b0e8e	t	90000.00	300000.00	SUKSES	0.00	\N
210000.00	2026-06-22 20:53:03.433	TRS-cb64db83	t	0.00	0.00	HUTANG	0.00	\N
13000.00	2026-06-22 20:53:51.244	TRS-785126c5	t	0.00	13000.00	HUTANG	0.00	\N
210000.00	2026-06-22 21:15:15.332	TRS-d720612f	t	0.00	0.00	SUKSES	0.00	\N
829000.00	2026-06-23 17:19:42.921	TRS-bf43e9cd	t	0.00	829000.00	SUKSES	0.00	\N
13000.00	2026-06-23 18:45:39.425	TRS-a6d63ed5	t	0.00	13000.00	SUKSES	0.00	\N
1110000.00	2026-06-23 18:25:26.609	TRS-5803ce2e	t	0.00	0.00	SUKSES	0.00	\N
200700.00	2026-06-23 19:16:59.66	TRS-c729c220	t	0.00	200700.00	SUKSES	22300.00	\N
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."User" (id, name, username, email, "emailVerified", image, password, role) FROM stdin;
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
389939b6-0165-4008-9576-729589636552	a3d3cb18058a505953216950fca06aef35c87f2950223ec20e4c2760086283c8	2026-02-06 08:57:51.180255+00	20240515032826_test	\N	\N	2026-02-06 08:57:49.720288+00	1
9dd7a603-5430-4c30-a458-a09b57d2cc29	52dbe1b0d5ec921d47ceb6451582c3150733409cfc456e8526ece46b9047d1d9	2026-02-06 08:58:16.895923+00	20240527110703_add_store_name	\N	\N	2026-02-06 08:58:15.581044+00	1
6e0cb862-b1d9-4dee-baeb-fb85dc4c2f17	4b7676727abdc700cd91d42b61b4c569acc39a8f96b059f7c7473428e4fc2975	2026-02-06 08:57:52.324272+00	20240515083332_add_trans	\N	\N	2026-02-06 08:57:51.582856+00	1
7ffcf9bf-8fe8-4f04-8b97-c5849b9515da	2d3d5d6274260c86edcb87283d150dad4f5b57cb0650e19bfc5d76f9227dac72	2026-02-06 08:57:53.356719+00	20240515152151_edit_id	\N	\N	2026-02-06 08:57:52.809578+00	1
fdafa52d-4da3-431a-b40e-0a544b6ca08a	ef02d3fe6a145e88edf90f448da9e4620486dfbeda6d114752f932ceac211384	2026-02-06 08:57:54.932956+00	20240515152759_fix_error	\N	\N	2026-02-06 08:57:53.758731+00	1
f889f295-c268-4620-844d-b1bbf08d8359	3512cd960b9233f5a0e2800522aa5a98f97e92646a62e077e6a0ed5f3968aba9	2026-02-06 08:58:19.775927+00	20260206082212_remove_tax_field	\N	\N	2026-02-06 08:58:17.237741+00	1
d4f568e3-fcc0-4459-bb96-f210d79205f8	dc6a449623377cd36b4d7f21b5b60784ed2ed15c0785589fbed77fcd772c8485	2026-02-06 08:57:56.749325+00	20240515153708_	\N	\N	2026-02-06 08:57:55.765106+00	1
d5626614-c57a-44ae-a97b-09fd647bfa22	d985b9545c290df8538973e8dd126eef2c67ec7097b1b74246ad2b8266d0645f	2026-02-06 08:57:57.985241+00	20240516014808_	\N	\N	2026-02-06 08:57:57.098056+00	1
4ef0fb22-6089-454a-a02b-559d82373dec	dc6a449623377cd36b4d7f21b5b60784ed2ed15c0785589fbed77fcd772c8485	2026-02-06 08:57:59.363606+00	20240516042559_	\N	\N	2026-02-06 08:57:58.154034+00	1
2285004d-86cb-487c-964a-a69eefe88192	89bde8c089e591f18d4493e68ca945530d864024b14459c3bb033c367da14f16	2026-06-18 18:17:19.879728+00	20260619000000_decimal_and_indexes	\N	\N	2026-06-18 18:17:19.580389+00	1
a70b4d58-c2e9-4b4c-b663-82a08f62772b	77271bc0bc41df36e358669b8628b5b071d77924809b661202b592fb336a755c	2026-02-06 08:58:02.820671+00	20240519150627_transacyions_uuid	\N	\N	2026-02-06 08:58:00.122284+00	1
b10048ce-8e46-41a3-81b2-fc3e663a12d6	67c576d7e4ba97e247bb601f86342438f03d094100d09166d634d9c43b8348fb	2026-02-06 08:58:04.625317+00	20240519153340_add_ref	\N	\N	2026-02-06 08:58:03.319307+00	1
03709897-3819-4d86-aa5e-9ce412bf13d1	b7f86bfdee45c260da5000a97350897aa5835a50c99a3486a16dd247ab875171	2026-02-06 08:58:06.51175+00	20240520085843_fix	\N	\N	2026-02-06 08:58:04.99261+00	1
1c2dcc3d-b792-4267-b980-e8ecfd2989b3	a69a02fea1a0d1caf9c6c0cbd5d0c5d4d0f22d9b1e01fb20290b73d2f8f72036	\N	20260619120000_add_debt_model	A migration failed to apply. New migrations cannot be applied before the error is recovered from. Read more about how to resolve migration issues in a production database: https://pris.ly/d/migrate-resolve\n\nMigration name: 20260619120000_add_debt_model\n\nDatabase error code: 42710\n\nDatabase error:\nERROR: enum label "HUTANG" already exists\n\nDbError { severity: "ERROR", parsed_severity: Some(Error), code: SqlState(E42710), message: "enum label \\"HUTANG\\" already exists", detail: None, hint: None, position: None, where_: None, schema: None, table: None, column: None, datatype: None, constraint: None, file: Some("pg_enum.c"), line: Some(348), routine: Some("AddEnumLabel") }\n\n   0: sql_schema_connector::apply_migration::apply_script\n           with migration_name="20260619120000_add_debt_model"\n             at schema-engine/connectors/sql-schema-connector/src/apply_migration.rs:106\n   1: schema_core::commands::apply_migrations::Applying migration\n           with migration_name="20260619120000_add_debt_model"\n             at schema-engine/core/src/commands/apply_migrations.rs:91\n   2: schema_core::state::ApplyMigrations\n             at schema-engine/core/src/state.rs:226	2026-06-18 19:36:11.666256+00	2026-06-18 19:35:57.644268+00	0
9157bb6b-6010-4adb-ba56-9a357a39d6ca	2ffde452e2b7f5714fb0ec5c6f36a25e57bd34b69cb944b285efff40c336b73e	2026-02-06 08:58:08.965311+00	20240520094234_d	\N	\N	2026-02-06 08:58:07.729076+00	1
62461022-5ba4-410d-8cd3-7d62f28d9305	1c102c6582c9b594198b11173ad3b26698b52e4960f55a19a577b9d9d4b33506	2026-06-18 19:36:11.718213+00	20260619120000_add_debt_model		\N	2026-06-18 19:36:11.718213+00	0
48ac3413-228a-4d7a-8f29-024ef370909c	f2632dbe1d6a6d108bec2fbe0fbee163fd293ee7e6864b932dc46ab35e9cc003	2026-02-06 08:58:10.920919+00	20240520094708_j	\N	\N	2026-02-06 08:58:09.968481+00	1
480052ab-38ce-477c-b6fc-c6b3f72673f0	ef24937277a3b47cfba1e84827c77d8b95e1cbd77a36b57910fb08e0ab3c1875	2026-02-06 08:58:12.122498+00	20240522043648_remove_ref	\N	\N	2026-02-06 08:58:11.11047+00	1
fd320451-512d-4a0d-8ca7-c386e8417d2c	2c79a6a455bb996d8a95c9bd042c2f67605be87a92448776361b46dcc5b23ae0	2026-02-06 08:58:14.52345+00	20240527110429_add_tax	\N	\N	2026-02-06 08:58:12.506137+00	1
\.


--
-- Name: Category Category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Category"
    ADD CONSTRAINT "Category_pkey" PRIMARY KEY (id);


--
-- Name: Debt Debt_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Debt"
    ADD CONSTRAINT "Debt_pkey" PRIMARY KEY (id);


--
-- Name: Expense Expense_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Expense"
    ADD CONSTRAINT "Expense_pkey" PRIMARY KEY (id);


--
-- Name: OnSaleProduct OnSaleProduct_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."OnSaleProduct"
    ADD CONSTRAINT "OnSaleProduct_pkey" PRIMARY KEY (id);


--
-- Name: OnSaleProduct OnSaleProduct_productId_transactionId_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."OnSaleProduct"
    ADD CONSTRAINT "OnSaleProduct_productId_transactionId_key" UNIQUE ("productId", "transactionId");


--
-- Name: ProductStock ProductStock_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ProductStock"
    ADD CONSTRAINT "ProductStock_pkey" PRIMARY KEY (id);


--
-- Name: Product Product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Product"
    ADD CONSTRAINT "Product_pkey" PRIMARY KEY (id);


--
-- Name: ShopData ShopData_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ShopData"
    ADD CONSTRAINT "ShopData_pkey" PRIMARY KEY (id);


--
-- Name: Transaction Transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Transaction"
    ADD CONSTRAINT "Transaction_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: User User_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_username_key" UNIQUE (username);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: Category_name_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Category_name_key" ON public."Category" USING btree (name);


--
-- Name: Debt_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Debt_createdAt_idx" ON public."Debt" USING btree ("createdAt");


--
-- Name: Debt_customerName_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Debt_customerName_idx" ON public."Debt" USING btree ("customerName");


--
-- Name: Debt_isPaid_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Debt_isPaid_idx" ON public."Debt" USING btree ("isPaid");


--
-- Name: Debt_transactionId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Debt_transactionId_key" ON public."Debt" USING btree ("transactionId");


--
-- Name: Expense_category_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Expense_category_idx" ON public."Expense" USING btree (category);


--
-- Name: Expense_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Expense_createdAt_idx" ON public."Expense" USING btree ("createdAt");


--
-- Name: OnSaleProduct_transactionId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "OnSaleProduct_transactionId_idx" ON public."OnSaleProduct" USING btree ("transactionId");


--
-- Name: ProductStock_brand_category_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "ProductStock_brand_category_idx" ON public."ProductStock" USING btree (brand, category);


--
-- Name: ProductStock_brand_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "ProductStock_brand_idx" ON public."ProductStock" USING btree (brand);


--
-- Name: ProductStock_brand_masterCategory_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "ProductStock_brand_masterCategory_idx" ON public."ProductStock" USING btree (brand, "masterCategory");


--
-- Name: ProductStock_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "ProductStock_name_idx" ON public."ProductStock" USING btree (name);


--
-- Name: ProductStock_skuManual_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "ProductStock_skuManual_key" ON public."ProductStock" USING btree ("skuManual");


--
-- Name: Product_productId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Product_productId_key" ON public."Product" USING btree ("productId");


--
-- Name: Transaction_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Transaction_createdAt_idx" ON public."Transaction" USING btree ("createdAt");


--
-- Name: Transaction_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Transaction_status_idx" ON public."Transaction" USING btree (status);


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: Debt Debt_transactionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Debt"
    ADD CONSTRAINT "Debt_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES public."Transaction"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: OnSaleProduct OnSaleProduct_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."OnSaleProduct"
    ADD CONSTRAINT "OnSaleProduct_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."Product"("productId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: OnSaleProduct OnSaleProduct_transactionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."OnSaleProduct"
    ADD CONSTRAINT "OnSaleProduct_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES public."Transaction"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Product Product_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Product"
    ADD CONSTRAINT "Product_productId_fkey" FOREIGN KEY ("productId") REFERENCES public."ProductStock"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict desL64CnFnyKLbqbBxR1pBIj5ZlFzaUiGUedvsPn1iDjBCT3aFusT36NdZ70ivD

