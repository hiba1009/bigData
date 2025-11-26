Microsoft Windows [Version 10.0.19045.6456]
(c) Microsoft Corporation. All rights reserved.

C:\Users\HSN>docker pull cassandra:4.1
4.1: Pulling from library/cassandra
e10875650961: Pull complete
1842296f3005: Pull complete
66c894d7b18a: Pull complete
cbac7e3957e4: Pull complete
b93334ff643d: Pull complete
7e49dc6156b0: Pull complete
e8db061f1dd5: Pull complete
f2a58a7b9815: Pull complete
d2a7c5c92273: Pull complete
afbec7c91e5e: Pull complete
Digest: sha256:ef317ed8ee30492ba1d3841093540e56d5347f3b18da458042839d8d312d98b7
Status: Downloaded newer image for cassandra:4.1
docker.io/library/cassandra:4.1

C:\Users\HSN>docker run --name cassandra -d cassandra:4.1
9a2459da360901f00404951a32163e8d70b6dfcaafd943ed6fbc2c3b4afc700a

C:\Users\HSN>docker ps
CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS                                         NAMES
9a2459da3609   cassandra:4.1   "docker-entrypoint.s…"   39 seconds ago   Up 38 seconds   7000-7001/tcp, 7199/tcp, 9042/tcp, 9160/tcp   cassandra


C:\Users\HSN>docker exec -it cassandra cqlsh
Connected to Test Cluster at 127.0.0.1:9042
[cqlsh 6.1.0 | Cassandra 4.1.10 | CQL spec 3.4.6 | Native protocol v5]
Use HELP for help.
cqlsh> CREATE KEYSPACE IF NOT EXISTS resto_NY
   ... WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor': 1};
cqlsh> USE resto_NY;
cqlsh:resto_ny> CREATE TABLE Restaurant (
            ...     id INT,
            ...     Name VARCHAR,
            ...     borough VARCHAR,
            ...     BuildingNum VARCHAR,
            ...     Street VARCHAR,
            ...     ZipCode INT,
            ...     Phone text,
            ...     CuisineType VARCHAR,
            ...     PRIMARY KEY (id)
            ... );
cqlsh:resto_ny>
cqlsh:resto_ny> CREATE INDEX fk_Restaurant_cuisine ON Restaurant (CuisineType);
cqlsh:resto_ny>
cqlsh:resto_ny> CREATE TABLE Inspection (
            ...     idRestaurant INT,
            ...     InspectionDate date,
            ...     ViolationCode VARCHAR,
            ...     ViolationDescription VARCHAR,
            ...     CriticalFlag VARCHAR,
            ...     Score INT,
            ...     GRADE VARCHAR,
            ...     PRIMARY KEY (idRestaurant, InspectionDate)
            ... );
cqlsh:resto_ny>
cqlsh:resto_ny> CREATE INDEX fk_Inspection_Restaurant ON Inspection (Grade);
cqlsh:resto_ny> DESC Restaurant;

CREATE TABLE resto_ny.restaurant (
    id int PRIMARY KEY,
    borough text,
    buildingnum text,
    cuisinetype text,
    name text,
    phone text,
    street text,
    zipcode int
) WITH additional_write_policy = '99p'
    AND bloom_filter_fp_chance = 0.01
    AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
    AND cdc = false
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold': '32', 'min_threshold': '4'}
    AND compression = {'chunk_length_in_kb': '16', 'class': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND memtable = 'default'
    AND crc_check_chance = 1.0
    AND default_time_to_live = 0
    AND extensions = {}
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair = 'BLOCKING'
    AND speculative_retry = '99p';

CREATE INDEX fk_restaurant_cuisine ON resto_ny.restaurant (cuisinetype);
cqlsh:resto_ny> DESC Inspection;

CREATE TABLE resto_ny.inspection (
    idrestaurant int,
    inspectiondate date,
    criticalflag text,
    grade text,
    score int,
    violationcode text,
    violationdescription text,
    PRIMARY KEY (idrestaurant, inspectiondate)
) WITH CLUSTERING ORDER BY (inspectiondate ASC)
    AND additional_write_policy = '99p'
    AND bloom_filter_fp_chance = 0.01
    AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
    AND cdc = false
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold': '32', 'min_threshold': '4'}
    AND compression = {'chunk_length_in_kb': '16', 'class': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND memtable = 'default'
    AND crc_check_chance = 1.0
    AND default_time_to_live = 0
    AND extensions = {}
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair = 'BLOCKING'
    AND speculative_retry = '99p';

CREATE INDEX fk_inspection_restaurant ON resto_ny.inspection (grade);

C:\Users\HSN>docker ps
CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS                                         NAMES
9a2459da3609   cassandra:4.1   "docker-entrypoint.s…"   30 minutes ago   Up 30 minutes   7000-7001/tcp, 7199/tcp, 9042/tcp, 9160/tcp   cassandra

C:\Users\HSN>docker cp C:\Users\HSN\OneDrive\Desktop\bigData\TP6\files\restaurants.csv 9a2459da3609:/
Successfully copied 2.11MB to 9a2459da3609:/

C:\Users\HSN>docker cp C:\Users\HSN\OneDrive\Desktop\bigData\TP6\files\restaurants_inspections.csv 9a2459da3609:/
Successfully copied 82.5MB to 9a2459da3609:/

C:\Users\HSN>
C:\Users\HSN>docker exec -it cassandra cqlsh
Connected to Test Cluster at 127.0.0.1:9042
[cqlsh 6.1.0 | Cassandra 4.1.10 | CQL spec 3.4.6 | Native protocol v5]
Use HELP for help.
cqlsh> USE resto_NY;
cqlsh:resto_ny> COPY Restaurant (id, name, borough, buildingnum, street, zipcode, phone, cuisinetype)
            ... FROM '/restaurants.csv'
            ... WITH DELIMITER = ',';
Using 7 child processes

Starting copy of resto_ny.restaurant with columns [id, name, borough, buildingnum, street, zipcode, phone, cuisinetype].
Processed: 25624 rows; Rate:   16857 rows/s; Avg. rate:    8605 rows/s
25624 rows imported from 1 files in 0 day, 0 hour, 0 minute, and 2.978 seconds (0 skipped).
cqlsh:resto_ny> COPY Inspection (idrestaurant, inspectiondate, violationcode, violationdescription, criticalflag, score, grade)
            ... FROM '/restaurants_inspections.csv'
            ... WITH DELIMITER = ',';
Using 7 child processes

Starting copy of resto_ny.inspection with columns [idrestaurant, inspectiondate, violationcode, violationdescription, criticalflag, score, grade].
Processed: 441712 rows; Rate:   11596 rows/s; Avg. rate:   21667 rows/s
441712 rows imported from 1 files in 0 day, 0 hour, 0 minute, and 20.387 seconds (0 skipped).

cqlsh:resto_ny> SELECT count(*) FROM Restaurant;

 count
-------
 25624

(1 rows)

Warnings :
Aggregation query used without partition key

cqlsh:resto_ny> SELECT count(*) FROM Inspection;

 count
--------
 149818

(1 rows)

Warnings :
Aggregation query used without partition key

cqlsh:resto_ny> SELECT * FROM Restaurant;

 id       | borough       | buildingnum | cuisinetype                                                      | name                                             | phone      | street                      | zipcode
----------+---------------+-------------+------------------------------------------------------------------+--------------------------------------------------+------------+-----------------------------+---------
 40786914 | STATEN ISLAND |        1465 |                                                         American |                                    BOSTON MARKET | 7188151198 |               FOREST AVENUE |   10302
 40366162 |        QUEENS |       11909 |                                                         American |                                 LENIHAN'S SALOON | 7188469770 |             ATLANTIC AVENUE |   11418
 41692194 |     MANHATTAN |         360 |                                                             Thai |                                    BANGKOK HOUSE | 2125415943 |            WEST   46 STREET |   10036
 41430956 |      BROOKLYN |        2225 |                                                        Caribbean |                                TJ'S TASTY CORNER | 7184844783 |               TILDEN AVENUE |   11226
 41395531 |        QUEENS |         126 |                                                         American |                                NATHAN'S HOT DOGS | 7185958100 |            ROOSEVELT AVENUE |   11368
 50005384 | STATEN ISLAND |         271 |                                                          Chinese |                                      YUMMY YUMMY | 7184425888 |           PORT RICHMOND AVE |   10302
 50005858 |      BROOKLYN |        6005 |                                                          Chinese |                                   KING'S KITCHEN | 7188531388 |          FORT HAMILTON PKWY |   11219
 40962612 |     MANHATTAN |         164 |                                                          Italian |                                            CESCA | 2127876300 |            WEST   75 STREET |   10023
 40995404 |     MANHATTAN |        4195 | Latin (Cuban, Dominican, Puerto Rican, South & Central American) |                EL GUANACO RESTAURANT & PUPUSERIA | 2127955400 |                    BROADWAY |   10033
 40368763 |     MANHATTAN |         111 |                                                         American |                                        THE BROOK | 2127537020 |            EAST   54 STREET |   10022
 50019260 |      BROOKLYN |         604 |                                                     Delicatessen |                               LEO'S DELI & GRILL | 3474629400 |                  E 102ND ST |   11236
 50015473 |     MANHATTAN |          90 |                                                         Japanese |                        KAEDE JAPANESE RESTAURANT | 2127668686 |                 CHAMBERS ST |   10007
 41704055 |         BRONX |        1788 |                                                            Pizza |                                      JOHNS PIZZA | 7188220201 |          WESTCHESTER AVENUE |   10472
 40860476 |        QUEENS |        9109 | Latin (Cuban, Dominican, Puerto Rican, South & Central American) |                           RICE & BEANS LECHONERA | 7187400265 |       SPRINGFIELD BOULEVARD |   11428
 50044741 | STATEN ISLAND |        1203 |                                                           Indian |                                   INDIAN EXPRESS | 7184426673 |                  HYLAN BLVD |   10305
 41630020 |     MANHATTAN |         341 |                                                      Continental |                         DOUBLETREE GREENHOUSE 36 | 2125428990 |            WEST   36 STREET |   10018
 41569081 |         BRONX |        2002 |                                                          Mexican |                                         VIDAELVA | 7186841333 |      CROSS BRONX EXPRESSWAY |   10472
 50048575 |        QUEENS |       16120 |                                                          Chinese |                        TK VILLAGE BAKERY COMPANY | 7183590015 |               NORTHERN BLVD |   11358
 41569184 |     MANHATTAN |         321 |                                                         American |                                              BKB | 2128611038 |            EAST   73 STREET |   10021
 41710788 |        QUEENS |      136-20 |                                                            Asian |                                           SPRING | 7183958073 |                   38 AVENUE |   11354
 41443240 |     MANHATTAN |          40 |                                                           Donuts |                                   DUNKIN' DONUTS | 2122542055 |           UNION SQUARE EAST |   10003
 41517701 |         BRONX |        5981 |                                                          Chicken |                                     PLANET WINGS | 7188849464 |                    BROADWAY |   10471
 50015747 |         BRONX |        3035 |                                                          Chinese |                    NEW CHINA RESTAURANT WANG INC | 7182922493 |                     3RD AVE |   10455
 50009349 |      BROOKLYN |        1708 |                                                            Asian |                                 JIN SUSHI & THAI | 7183363887 |                   E 16TH ST |   11229
 50011687 |        QUEENS |        1641 |                                                 Chinese/Japanese |                           JADE ASIAN EXPRESS INC | 7183818878 |                 WOODBINE ST |   11385
 41483427 |     MANHATTAN |        1109 |                                                          Italian |                                TIELLA RESTAURANT | 2125880100 |                    1 AVENUE |   10065
 41615509 |     MANHATTAN |         107 |                                   Sandwiches/Salads/Mixed Buffet |                                           SUBWAY | 2122217003 |            WEST   37 STREET |   10018
 41450562 |     MANHATTAN |         924 |                                                           French |                                          MATISSE | 2125469300 |                    2 AVENUE |   10022
 50037966 |         BRONX |        2449 |                                                          Spanish |                                     FRESH FRUTII | 3472718932 |                 CRESTON AVE |   10468
 40380628 |        QUEENS |        6568 |                                                    Pizza/Italian |                                    PISA PIZZERIA | 7183816368 |               MYRTLE AVENUE |   11385
 41376760 |     MANHATTAN |         187 |                                                           Bakery |                                PATISSERIE CLAUDE | 2122555911 |            WEST    4 STREET |   10014
 41332375 |     MANHATTAN |         233 |                                  Ice Cream, Gelato, Yogurt, Ices |                                             GROM | 2122061738 |             BLEECKER STREET |   10014
 41231284 |     MANHATTAN |         173 |                                                         American |                                        WESTVILLE | 2126772033 |                    AVENUE A |   10009
 41428195 |        QUEENS |       11136 |                                                            Pizza |                                 FARMERS PIZZERIA | 7184641500 |           FARMERS BOULEVARD |   11412
 50005784 |        QUEENS |        9706 |                                                          Spanish |     ORGANIC FOOD, NATURAL JUICES AND COFFEE SHOP | 9174201425 |               ROOSEVELT AVE |   11368
 41409366 |     MANHATTAN |          11 |                                                    Jewish/Kosher |                                          CAFE 11 | 2124252233 |                    BROADWAY |   10004
 50052502 |     MANHATTAN |         150 |                                                         American | COMMUNITY DINING HALL AT MCKEON HALL FORDAM UNIV | 6463465110 |                   W 62ND ST |   10023
 50001970 |      BROOKLYN |        1591 |                                                         American |                              CROWN FRIED CHICKEN | 7184536433 |                    BROADWAY |   11207
 50037419 |      BROOKLYN |           1 |                                                 CafÃ©/Coffee/Tea |                                  BROOKLYN CAFE 1 | 7184851111 |               BROOKDALE PLZ |   11212
 50046836 |        QUEENS |        6507 |                                                         American |                            MINT JUICERY AND YOGO | 3478134357 |              WOODHAVEN BLVD |   11374
 41642313 |         BRONX |        155B |                                                           Bakery |                                   LA ROSA BAKERY | 7182934153 |            EAST  170 STREET |   10452
 40388419 |     MANHATTAN |        2859 |                                                            Pizza |                         FAMOUS FAMIGLIA PIZZERIA | 2128651234 |                    BROADWAY |   10025
 41229180 |     MANHATTAN |         186 |                                                    Pizza/Italian |                               FRANCESCO PIZZERIA | 2127210066 |             COLUMBUS AVENUE |   10023
 50008086 |        QUEENS |       14615 |                                                          Chinese |                                 NO. 1 YUMMY TACO | 7188481288 |               ROCKAWAY BLVD |   11436
 41306360 |      BROOKLYN |        3325 |                                                          Mexican |                             CRESCENT COFFEE SHOP | 7182773780 |               FULTON STREET |   11208
 50046219 |      BROOKLYN |         492 |                                                    Mediterranean |                      LA ROYALE BEER BURGER HOUSE | 3476894378 |                     5TH AVE |   11215
 41298198 |        QUEENS |       13618 |                                                           Bakery |                                    FAY DA BAKERY | 7183211759 |                   39 AVENUE |   11354
 50033104 |     MANHATTAN |          83 |                                                         American |                                HILLTOP PERK DELI | 6466435187 |                   HAVEN AVE |   10032
 41685325 |      BROOKLYN |         615 |                                                         American |                               CONNECTICUT MUFFIN | 3473053872 |             NOSTRAND AVENUE |   11216
 41049219 |         BRONX |         941 |                                                          Chicken |                        KENNEDY CHICKEN AND PIZZA | 7188602295 |            INTERVALE AVENUE |   10459
 41567020 |      BROOKLYN |          67 |                                                           Salads |                              GREENSTREETS SALADS | 3474057956 |               IRVING AVENUE |   11237
 50050334 |     MANHATTAN |           1 |                                                            Other |                               BLUE BOTTLE COFFEE | 5106533394 |             ROCKEFELLER PLZ |   10020
 50041073 |      BROOKLYN |         251 |                                                         American |                                        THE TOPAZ | 3477707217 |                BUSHWICK AVE |   11206
 50033938 |     MANHATTAN |         109 |                                                          Mexican |                                     R & J LOUNGE | 6467855832 |                  E 116TH ST |   10029
 41583458 |     MANHATTAN |         780 |                                                           Bakery |                               SPRINKLES CUPCAKES | 2122078375 |            LEXINGTON AVENUE |   10065
 40969326 |      BROOKLYN |         369 | Latin (Cuban, Dominican, Puerto Rican, South & Central American) |                                   LA GUARIDA BAR | 9179518643 |                   36 STREET |   11232
 50035012 |      BROOKLYN |       1876A |                                                        Soul Food |                               MAMA ROZ SOUL FOOD | 3477898135 |                   FULTON ST |   11233
 41688653 |     MANHATTAN |           1 |                                                 CafÃ©/Coffee/Tea |                                  STARBUCK COFFEE | 2123461283 |                  PACE PLAZA |   10038
 50054647 |      BROOKLYN |         807 |                                                           Bakery |                                 HONG KONG BAKERY | 9174557883 |                     42ND ST |   11232
 50032618 |        QUEENS |        4108 |                                                           Korean |                           DAEJI DAEJI KOREAN BBQ | 7188866797 |                    149TH PL |   11355
 50036072 |     MANHATTAN |        1351 | Latin (Cuban, Dominican, Puerto Rican, South & Central American) |                                LUISA CHIMICHURRY | 2127811489 |          SAINT NICHOLAS AVE |   10033
 40700724 |     MANHATTAN |         165 |                                                          Italian |                                   SCALINI FEDELI | 2125280400 |                DUANE STREET |   10013
 50046157 |        QUEENS |        9245 | Latin (Cuban, Dominican, Puerto Rican, South & Central American) |      GREEN APPLE FOOD COURT /LATIN MEXICAN GRILL | 7186588887 |           GUY R BREWER BLVD |   11433
 41250691 |     MANHATTAN |         421 |                                                       Sandwiches |                                           SUBWAY | 2125322720 |                    2 AVENUE |   10010
 40371807 |        QUEENS |        4619 |                                                          Italian |                 AUNT BELLA'S REST OF LITTLE NECK | 7182254700 |            MARATHON PARKWAY |   11362
 41574344 |     MANHATTAN |          28 |                                                           French |                                          ALMANAC | 2129327566 |              7 AVENUE SOUTH |   10014
 41495616 |      BROOKLYN |         NKA |                                                         American |                       BROOKLYN BRIDGE GARDEN BAR | 3474248211 |        BROOKLYN BRIDGE PARK |   11201
 50037658 |     MANHATTAN |        1613 |                                                    Mediterranean |                                   HUMMUS KITCHEN | 2129880347 |                     2ND AVE |   10028
 41679915 | STATEN ISLAND |         272 |                                                          Mexican |                                 LA NUEVA CANASTA | 3474249647 |                   SAND LANE |   10305
 50048338 |        QUEENS |       13822 |                                                          Chinese |                                    DRAGON PALACE | 7187121300 |                FARMERS BLVD |   11434
 50007940 |     MANHATTAN |         225 |                                                         American |                                  LITTLE MUENSTER | 2127860186 |                  LIBERTY ST |   10281
 50013363 |         BRONX |        4513 |                                                         American |                        KELLY COMMONS MARKETPLACE | 7188627737 |      MANHATTAN COLLEGE PKWY |   10471
 40744238 |         BRONX |         151 | Latin (Cuban, Dominican, Puerto Rican, South & Central American) |                           PICANTERIA EL BOTECITO | 7184017366 |          BRUCKNER BOULEVARD |   10454
 50012829 |      BROOKLYN |         232 |                                                 CafÃ©/Coffee/Tea |                                      THE CANTINE | 9175737765 |                      3RD ST |   11215
 40608422 |         BRONX |           1 |                                                         American |                        BEDFORD CAFE & RESTAURANT | 7183653416 | EAST BEDFORD PARK BOULEVARD |   10468
 41561546 |        QUEENS |         905 |                                                           Bakery |                                    RUDY'S BAKERY | 7188215890 |               SENECA AVENUE |   11385
 41576416 |     MANHATTAN |         237 |                                                         Japanese |                                            JUKAI | 2125889788 |            EAST   53 STREET |   10022
 40958136 |        QUEENS |           0 |                                                         American |                           SIX BLOCKS BAKERY CAFE | 7186519494 |           LAGUARDIA AIRPORT |   11369
 50007413 |        QUEENS |       16519 |                                                           Korean |                                FLUSHING BANGGANE | 7187622799 |               NORTHERN BLVD |   11358
 50009019 |     MANHATTAN |        1306 |                                                           Salads |                                       JUST SALAD | 2122441111 |                     1ST AVE |   10021
 50000419 |     MANHATTAN |       43-45 |                                                         American |                                      NATUREWORKS | 2123333020 |                 W 55 STREET |   10019
 41283984 | STATEN ISLAND |         150 |                                                       Sandwiches |                                           SUBWAY | 7187271777 |                  BAY STREET |   10301
 40364576 |     MANHATTAN |         311 |                                                           French |                                     TOUT VA BIEN | 2122650190 |            WEST   51 STREET |   10019
 40378774 |        QUEENS |        6967 |                                                         American |                                       FAME DINER | 7184784674 |                GRAND AVENUE |   11378
 50049009 |     MANHATTAN |          42 |                                                            Other |                        RESTAURANT ASSOCIATES LLC | 3477582694 |                    BROADWAY |   10004
 50049046 |        QUEENS |       15412 |                                                           Indian |                                     NAAN & GRILL | 7184134842 |               ROCKAWAY BLVD |   11434
 41718215 |     MANHATTAN |         251 |                                                         Japanese |                                   YAKITORI TOTTO | 2122454555 |            WEST   55 STREET |   10019
 50000095 |     MANHATTAN |         255 |                                                          Chinese |                          NEW JING HUI RESTAURANT | 2122838118 |                 W. 148TH ST |   10039
 50044781 |     MANHATTAN |         328 |                                                 CafÃ©/Coffee/Tea |                                 TERREMOTO COFFEE | 2122434300 |                   W 15TH ST |   10011
 50056581 |      BROOKLYN |         224 |                                                            Other |                                    THE GUMBO BRO | 2124016944 |                ATLANTIC AVE |   11201
 41362423 |        QUEENS |           0 |                                                         American |                      CIBO EXPRESS GOURMET MARKET | 6464835087 |           JFK INTL. AIRPORT |   11430
 41252214 |     MANHATTAN |         310 |                                                         American |                                       LAZY POINT | 2124637406 |               SPRING STREET |   10013
 41708947 |        QUEENS |        4914 |                                                         American |                         SECRETS GENTLEMAN'S CLUB | 6463533242 |            QUEENS BOULEVARD |   11377
 41350559 |         BRONX |          60 |                                                       Hamburgers |           BURGER KING, POPEYES LOUISIANA KITCHEN | 7188223678 |           METROPOLITAN OVAL |   10462
 50043150 |     MANHATTAN |         609 |                                                       Sandwiches |                                BETWEEN THE BREAD | 2127651687 |                   W 27TH ST |   10001
 50041565 |        QUEENS |        3125 |                                                            Pizza |                                 Sicilia Pizzeria | 3477068525 |                 THOMSON AVE |   11101
 50039126 |      BROOKLYN |         201 |                                  Ice Cream, Gelato, Yogurt, Ices |                                DAVEY'S ICE CREAM | 6462458414 |                 BEDFORD AVE |   11211
 41186217 |     MANHATTAN |          90 |                                                         American |                                   THE LITTLE OWL | 2127414695 |              BEDFORD STREET |   10014
 50044421 |     MANHATTAN |        4961 |                                                         Armenian |                                      GARDEN CAFE | 3478658750 |                    BROADWAY |   10034
 50051009 |         BRONX |        2367 |                                                    Pizza/Italian |                               BEST ITALIAN PIZZA | 7189336780 |             GRAND CONCOURSE |   10468

---MORE---



cqlsh:resto_ny> SELECT name FROM Restaurant;

 name
--------------------------------------------------
                                    BOSTON MARKET
                                 LENIHAN'S SALOON
                                    BANGKOK HOUSE
                                TJ'S TASTY CORNER
                                NATHAN'S HOT DOGS
                                      YUMMY YUMMY
                                   KING'S KITCHEN
                                            CESCA
                EL GUANACO RESTAURANT & PUPUSERIA
                                        THE BROOK
                               LEO'S DELI & GRILL
                        KAEDE JAPANESE RESTAURANT
                                      JOHNS PIZZA
                           RICE & BEANS LECHONERA
                                   INDIAN EXPRESS
                         DOUBLETREE GREENHOUSE 36
                                         VIDAELVA
                        TK VILLAGE BAKERY COMPANY
                                              BKB
                                           SPRING
                                   DUNKIN' DONUTS
                                     PLANET WINGS
                    NEW CHINA RESTAURANT WANG INC
                                 JIN SUSHI & THAI
                           JADE ASIAN EXPRESS INC
                                TIELLA RESTAURANT
                                           SUBWAY
                                          MATISSE
                                     FRESH FRUTII
                                    PISA PIZZERIA
                                PATISSERIE CLAUDE
                                             GROM
                                        WESTVILLE
                                 FARMERS PIZZERIA
     ORGANIC FOOD, NATURAL JUICES AND COFFEE SHOP
                                          CAFE 11
 COMMUNITY DINING HALL AT MCKEON HALL FORDAM UNIV
                              CROWN FRIED CHICKEN
                                  BROOKLYN CAFE 1
                            MINT JUICERY AND YOGO
                                   LA ROSA BAKERY
                         FAMOUS FAMIGLIA PIZZERIA
                               FRANCESCO PIZZERIA
                                 NO. 1 YUMMY TACO
                             CRESCENT COFFEE SHOP
                      LA ROYALE BEER BURGER HOUSE
                                    FAY DA BAKERY
                                HILLTOP PERK DELI
                               CONNECTICUT MUFFIN
                        KENNEDY CHICKEN AND PIZZA
                              GREENSTREETS SALADS
                               BLUE BOTTLE COFFEE
                                        THE TOPAZ
                                     R & J LOUNGE
                               SPRINKLES CUPCAKES
                                   LA GUARIDA BAR
                               MAMA ROZ SOUL FOOD
                                  STARBUCK COFFEE
                                 HONG KONG BAKERY
                           DAEJI DAEJI KOREAN BBQ
                                LUISA CHIMICHURRY
                                   SCALINI FEDELI
      GREEN APPLE FOOD COURT /LATIN MEXICAN GRILL
                                           SUBWAY
                 AUNT BELLA'S REST OF LITTLE NECK
                                          ALMANAC
                       BROOKLYN BRIDGE GARDEN BAR
                                   HUMMUS KITCHEN
                                 LA NUEVA CANASTA
                                    DRAGON PALACE
                                  LITTLE MUENSTER
                        KELLY COMMONS MARKETPLACE
                           PICANTERIA EL BOTECITO
                                      THE CANTINE
                        BEDFORD CAFE & RESTAURANT
                                    RUDY'S BAKERY
                                            JUKAI
                           SIX BLOCKS BAKERY CAFE
                                FLUSHING BANGGANE
                                       JUST SALAD
                                      NATUREWORKS
                                           SUBWAY
                                     TOUT VA BIEN
                                       FAME DINER
                        RESTAURANT ASSOCIATES LLC
                                     NAAN & GRILL
                                   YAKITORI TOTTO
                          NEW JING HUI RESTAURANT
                                 TERREMOTO COFFEE
                                    THE GUMBO BRO
                      CIBO EXPRESS GOURMET MARKET
                                       LAZY POINT
                         SECRETS GENTLEMAN'S CLUB
           BURGER KING, POPEYES LOUISIANA KITCHEN
                                BETWEEN THE BREAD
                                 Sicilia Pizzeria
                                DAVEY'S ICE CREAM
                                   THE LITTLE OWL
                                      GARDEN CAFE
                               BEST ITALIAN PIZZA

---MORE---

cqlsh:resto_ny> SELECT name, borough
            ... FROM Restaurant
            ... WHERE id = 41569764;

 name    | borough
---------+----------
 BACCHUS | BROOKLYN

(1 rows)
cqlsh:resto_ny> SELECT inspectiondate, grade
            ... FROM Inspection
            ... WHERE idrestaurant = 41569764;

 inspectiondate | grade
----------------+-------
     2013-06-27 |  null
     2013-07-08 |     A
     2013-12-26 |  null
     2014-02-05 |     A
     2014-07-17 |  null
     2014-08-06 |     A
     2015-01-08 |     A
     2016-02-25 |     A

(8 rows)
cqlsh:resto_ny> SELECT name FROM Restaurant WHERE cuisinetype = 'French';

 name
--------------------------------
                        MATISSE
                        ALMANAC
                   TOUT VA BIEN
                          FELIX
             CREPES ON COLUMBUS
               THE BARONESS BAR
                     THE SIMONE
                      FP BAKERY
                  VIN ET FLEURS
       CAFE BOULUD/BAR PLEIADES
                        COCOTTE
                  Bourgeois Pig
              DELICE & SARRASIN
               LA TARTE FLAMBEE
                   JEAN GEORGES
                     MAISON MAY
                         DANIEL
                    SAJU BISTRO
              LE PAIN QUOTIDIEN
                     CAFE CLUNY
                         BIN 71
                 CREPES CELSTES
                 JOYCE BAKESHOP
         THE FOX AND THE CREPES
                      CAFE LOUP
                   ROUGE TOMATE
                    LE PERIGORD
                 NOGLU NEW YORK
               BLISS 46  BISTRO
                       PASCALOU
                        BUVETTE
              LE PAIN QUOTIDIEN
 UNION CLUB OF CITY OF NEW YORK
                CAFE LUXEMBOURG
                       TISSERIE
              LE PAIN QUOTIDIEN
                      BAGATELLE
                 PARIS BAGUETTE
              LE PAIN QUOTIDIEN
                  CAFE D'ALSACE
                       KING BEE
                   LA BERGAMOTE
         TOCQUEVILLE RESTAURANT
               BISTRO CHAT NOIR
                 MADISON BISTRO
               57TH BELLE HOUSE
        LA MIRABELLE RESTAURANT
         LE TRAIN BLEU & B CAFE
              HUDSON CLEARWATER
                          CHERI
                       VAUCLUSE
               PARDON MY FRENCH
                 L' ANTAGONISTE
                 MADAME SOU SOU
                     THE BOUNTY
                 DUET BRASSERIE
                  MAISON KAYSER
           DIRTY PIERRES BISTRO
  L'AILE OU LA CUISSE (L'A.O.C)
                     ABC COCINA
           FRENCH CAFE GOURMAND
                 BISTRO VENDOME
                    LE COQ RICO
              THE LITTLE PRINCE
                      LE COUCOU
                  TURKS & FROGS
                     MAISON MAY
                     Le Village
               DOMAINE WINE BAR
                         B CAFE
             LUCIEN RESTAURAUNT
       SEL ET POIVRE RESTAURANT
                 PETITE ABEILLE
                         RAMONA
                         BOULEY
                QUATORZE BISTRO
          BONJOUR CREPES & WINE
                         CAMAJE
               CHICKEN PROVENCE
                      LAFAYETTE
                  VIVE LA CREPE
                          ORSAY
                  CHEZ NAPOLEAN
                 CHEZ JOSEPHINE
          LA BONNE SOUPE BISTRO
           BALTHAZAR RESTAURANT
                   LA MANGEOIRE
               LA BOITE EN BOIS
                     PETIT OVEN
            CHOKOLAT PATISSERIE
                    VAN LEEUWEN
            CANNELLE PATISSERIE
                      BISTRO SK
                     MONTMARTRE
                  VIN SUR VINGT
              HEADLESS HORSEMAN
            PETROSSIAN BOUTIQUE
            BREUKELEN BRASSERIE
                  GOLDEN CREPES
                     LE BARATIN

---MORE---

cqlsh:resto_ny> SELECT name FROM Restaurant WHERE borough = 'BROOKLYN' ALLOW FILTERING;

 name
--------------------------------------------
                          TJ'S TASTY CORNER
                             KING'S KITCHEN
                         LEO'S DELI & GRILL
                           JIN SUSHI & THAI
                        CROWN FRIED CHICKEN
                            BROOKLYN CAFE 1
                       CRESCENT COFFEE SHOP
                LA ROYALE BEER BURGER HOUSE
                         CONNECTICUT MUFFIN
                        GREENSTREETS SALADS
                                  THE TOPAZ
                             LA GUARIDA BAR
                         MAMA ROZ SOUL FOOD
                           HONG KONG BAKERY
                 BROOKLYN BRIDGE GARDEN BAR
                                THE CANTINE
                              THE GUMBO BRO
                          DAVEY'S ICE CREAM
                        CROWN FRIED CHICKEN
                                THAI TONY'S
                               CHINA DRAGON
                           KNAPP BAGEL CAFE
                     SCHNITZI SCHNITZEL BAR
                            INDIGO MURPHY'S
                    EDDIE JR'S SPORT LOUNGE
                       EL GRAN MAR DE PLATA
                               MALAY BAKERY
                EL NUEVO BARZOLA RESTAURANT
                         PURITAN RESTAURANT
                          EL CHARRO POBLANO
                        HOLIDAY INN EXPRESS
                                     SUBWAY
                          BREUCKELEN COLONY
                                SILENT BARN
                                     BATATA
                               WHITE CASTLE
                          BUBBLE TEA- B.B.Q
                         RED SUN RESTAURANT
                                    OUTPOST
                           ROCCO'S PIZZERIA
                   SAPPORO JAPANESE CUISINE
                              CAMILA'S CAFE
                                 ZOMBIE HUT
                                     SUBWAY
                              EAST MET WEST
                                   BOOMWICH
                                 MCDONALD'S
                                        KFC
                NEW HONG KONG RESTAURANT II
                                SHAKE SHACK
                              NABLUS SWEETS
                                WOLF & LAMB
                            BARCEY'S COFFEE
                          KALINA RESTAURANT
                            ARMANDO'S PIZZA
                        SING WAH RESTAURANT
              EL TEQUILERO BAR & RESTAURANT
                                  KONDITORI
                           SWEETLEAF COFFEE
                         NEW ZHANG'S GARDEN
                                   VAQUEROS
                         LIU'S SHANGHAI INC
               LA CEMITA MEXICAN GRILL CORP
                                COURT ORDER
                      EL PASO MEXICAN GRILL
                                   SCOPELLO
 VETERANS OF FOREIGN WARS POST #107 CANTEEN
                                      RASOI
                                   MIRAKUYA
                               AGRA HEIGHTS
                                HAAGEN-DAZS
                                 TYGERSHARK
             COURT STREET GROCERS HERO SHOP
                                 MUCHMORE'S
                             DUNKIN' DONUTS
                             FAMILY KITCHEN
                       ANARKALI INDIAN FOOD
                                        GFC
        TONY'S PIZZA, JERK CHICKEN AND FISH
                       PETITE FLEURY BAKERY
                                    PIQUANT
                    CHEZ MACOULE RESTAURANT
                    FOOTPRINTS CAFE EXPRESS
                                      PANDA
                             DUNKIN' DONUTS
                   KINARA INDIAN RESTAURANT
                         TEPANGO RESTAURANT
                                   FRANNY'S
                               FRANKIES 457
                                   re.union
                                   JAM ROCK
                   983 BUSHWICK LIVING ROOM
                              PROPELLERHEAD
                              HOPE & ANCHOR
                                IKHOFI CAFE
                                   THE VALE
                         YOSSIS GLATT SUSHI
                                 BLANK CAFE
                                   KI SUSHI
                                     SUBWAY

---MORE---


cqlsh:resto_ny>SELECT grade, score FROM Inspection
            ... WHERE idRestaurant = 41569764 AND score >= 10 ALLOW FILTERING;

 grade | score
-------+-------
  null |    19
     A |    10


cqlsh:resto_ny> SELECT grade
            ... FROM Inspection
            ... WHERE score > 30
            ...   AND grade IS NOT NULL
            ... ALLOW FILTERING;
InvalidRequest: Error from server: code=2200 [Invalid query] message="Unsupported restriction: grade IS NOT NULL"



cqlsh:resto_ny> SELECT COUNT(*)
            ... FROM Inspection
            ... WHERE score > 30
            ...   AND grade IS NOT NULL
            ... ALLOW FILTERING;
InvalidRequest: Error from server: code=2200 [Invalid query] message="Unsupported restriction: grade IS NOT NULL"