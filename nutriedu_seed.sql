-- ============================================================
--  NutriEdu — Complete Seed Data
--  Safe to run on a clean DB (TRUNCATE first if re-seeding)
--  Insertion order respects FK constraints
-- ============================================================

-- ============================================================
-- 0. Reset sequences (run only on a clean / re-seed scenario)
-- ============================================================
-- SELECT setval('public.ingredientes_id_seq', 1, false);
-- SELECT setval('public.restricciones_id_seq', 1, false);
-- SELECT setval('public.recetas_id_seq', 1, false);

-- ============================================================
-- 1. INGREDIENTES  (80 total, IDs 1-80)
-- ============================================================
INSERT INTO public.ingredientes (id, nombre) VALUES
(1,  'harina de trigo'),
(2,  'leche'),
(3,  'azucar'),
(4,  'pollo'),
(5,  'arroz'),
(6,  'zanahoria'),
(7,  'brocoli'),
(8,  'queso'),
(9,  'huevo'),
(10, 'almendras'),
(11, 'camaron'),
(12, 'avena'),
(13, 'yogur natural'),
(14, 'papa'),
(15, 'espinaca'),
(16, 'albahaca'),
-- new from 17 onward
(17, 'tomate'),
(18, 'cebolla'),
(19, 'ajo'),
(20, 'pimiento rojo'),
(21, 'pimiento verde'),
(22, 'lechuga'),
(23, 'pepino'),
(24, 'apio'),
(25, 'aguacate'),
(26, 'limon'),
(27, 'naranja'),
(28, 'manzana'),
(29, 'platano'),
(30, 'fresa'),
(31, 'mango'),
(32, 'pina'),
(33, 'uva'),
(34, 'sandia'),
(35, 'melon'),
(36, 'pera'),
(37, 'durazno'),
(38, 'carne de res'),
(39, 'carne de cerdo'),
(40, 'salmon'),
(41, 'atun'),
(42, 'sardina'),
(43, 'tofu'),
(44, 'lentejas'),
(45, 'frijoles negros'),
(46, 'garbanzos'),
(47, 'soya'),
(48, 'mantequilla'),
(49, 'aceite de oliva'),
(50, 'aceite de coco'),
(51, 'vinagre'),
(52, 'sal'),
(53, 'pimienta negra'),
(54, 'oregano'),
(55, 'comino'),
(56, 'curcuma'),
(57, 'canela'),
(58, 'jengibre'),
(59, 'miel'),
(60, 'stevia'),
(61, 'pasta integral'),
(62, 'pan integral'),
(63, 'tortilla de maiz'),
(64, 'quinoa'),
(65, 'cuscus'),
(66, 'maiz'),
(67, 'chayote'),
(68, 'calabacin'),
(69, 'berenjena'),
(70, 'champiñones'),
(71, 'esparagos'),
(72, 'col rizada'),
(73, 'rabano'),
(74, 'betabel'),
(75, 'nuez'),
(76, 'cacahuete'),
(77, 'semillas de chia'),
(78, 'semillas de girasol'),
(79, 'leche de almendra'),
(80, 'crema de leche');

-- ============================================================
-- 2. RESTRICCIONES  (15 total, IDs 1-15)
-- ============================================================
INSERT INTO public.restricciones (id, nombre, descripcion) VALUES
(1,  'gluten',        'Restricción para personas con enfermedad celíaca o sensibilidad al gluten.'),
(2,  'lactosa',       'Restricción para personas con intolerancia a la lactosa o alergia a la proteína de la leche.'),
(3,  'azucar',        'Restricción para personas diabéticas o que siguen dietas bajas en azúcar añadida.'),
(4,  'frutos secos',  'Restricción para personas con alergia a frutos secos como almendras, nueces o avellanas.'),
(5,  'mariscos',      'Restricción para personas con alergia a mariscos y crustáceos.'),
(6,  'vegano',        'Restricción para personas que excluyen todos los productos de origen animal de su dieta.'),
(7,  'vegetariano',   'Restricción para personas que no consumen carne ni pescado.'),
(8,  'huevo',         'Restricción para personas con alergia o intolerancia al huevo.'),
(9,  'soja',          'Restricción para personas con alergia a la soja y sus derivados.'),
(10, 'cacahuete',     'Restricción para personas con alergia al cacahuete, una de las alergias alimentarias más severas.'),
(11, 'alcohol',       'Restricción para personas que evitan el consumo de alcohol por razones de salud o personales.'),
(12, 'cafeina',       'Restricción para personas sensibles a la cafeína o que siguen dietas libres de estimulantes.'),
(13, 'sulfitos',      'Restricción para personas con hipersensibilidad a los sulfitos, presentes en vinos y alimentos procesados.'),
(14, 'cerdo',         'Restricción para personas que no consumen carne de cerdo por razones religiosas, culturales o de salud.'),
(15, 'trigo',         'Restricción para personas con alergia específica al trigo, distinta de la intolerancia al gluten.');

-- ============================================================
-- 3. RECETAS  (50 total, IDs 1-50)
--    Columns: id, nombre, descripcion, calorias,
--             tiempo_preparacion (min), nivel_salud (1-5)
-- ============================================================
INSERT INTO public.recetas (id, nombre, descripcion, calorias, tiempo_preparacion, nivel_salud) VALUES
(1,  'Pollo con arroz',                 'Plato clásico de pollo al horno acompañado de arroz blanco.',                          400, 35, 4),
(2,  'Ensalada de brocoli',             'Ensalada fresca de brócoli con aderezo de limón y aceite de oliva.',                    200, 15, 5),
(3,  'Spaghetti Alfredo con pollo',     'Pasta con salsa cremosa alfredo y trozos de pollo a la plancha.',                       620, 30, 2),
(4,  'Omelette de espinaca',            'Tortilla esponjosa rellena de espinaca salteada y queso.',                              260, 10, 5),
(5,  'Arroz con camarones',             'Arroz salteado con camarones frescos, ajo y pimiento.',                                 490, 25, 3),
(6,  'Yogur con almendras',             'Yogur natural cremoso con almendras tostadas y un toque de miel.',                      310,  5, 4),
(7,  'Sopa de verduras',                'Sopa reconfortante con zanahoria, papa, chayote y especias.',                           185, 30, 5),
(8,  'Ensalada César',                  'Lechuga romana con aderezo César, crutones y queso parmesano.',                         340, 15, 3),
(9,  'Tacos de pollo',                  'Tortillas de maíz rellenas de pollo a la plancha con pico de gallo.',                   410, 20, 4),
(10, 'Smoothie verde',                  'Batido nutritivo de espinaca, plátano, manzana y leche de almendra.',                   210, 10, 5),
(11, 'Avena con frutos rojos',          'Avena cocida con fresas frescas, plátano y semillas de chía.',                          320, 10, 5),
(12, 'Salmón al horno',                 'Filete de salmón horneado con limón, ajo y espárragos.',                                380, 25, 5),
(13, 'Ensalada de quinoa',              'Quinoa cocida con pepino, tomate, aguacate y aderezo de limón.',                        360, 20, 5),
(14, 'Crema de zanahoria',              'Sopa cremosa de zanahoria con jengibre y leche de coco.',                               230, 30, 5),
(15, 'Pasta integral con atún',         'Pasta integral con salsa de tomate, atún y aceitunas.',                                 430, 25, 4),
(16, 'Burrito de frijoles negros',      'Tortilla integral rellena de frijoles negros, aguacate y pimiento.',                    500, 20, 4),
(17, 'Pollo al curry',                  'Pechuga de pollo en salsa de curry con arroz basmati.',                                 520, 35, 3),
(18, 'Wrap de atún',                    'Tortilla integral con atún, lechuga, tomate y mostaza.',                                350, 10, 4),
(19, 'Tortilla española',               'Clásica tortilla de papa y huevo con cebolla caramelizada.',                            420, 30, 3),
(20, 'Bowl de açaí',                    'Puré de açaí con granola, plátano, fresa y miel.',                                     380, 10, 4),
(21, 'Lentejas guisadas',               'Lentejas cocidas con zanahoria, tomate, cebolla y especias mediterráneas.',             370, 40, 5),
(22, 'Ceviche de camarón',              'Camarones marinados en limón con tomate, cebolla y cilantro.',                          220, 15, 5),
(23, 'Pizza integral de vegetales',     'Base integral con salsa de tomate, champiñones, pimiento y queso.',                     480, 25, 3),
(24, 'Batido de proteína',              'Batido de plátano, avena, yogur y mantequilla de cacahuete.',                           420, 5,  4),
(25, 'Arroz integral con garbanzos',    'Arroz integral salteado con garbanzos, cúrcuma y zanahoria.',                           400, 30, 5),
(26, 'Hamburguesa de lentejas',         'Hamburguesa vegetal de lentejas y zanahoria en pan integral.',                          440, 35, 4),
(27, 'Sopa de tomate',                  'Sopa clásica de tomate con albahaca fresca y un chorrito de crema.',                    200, 25, 4),
(28, 'Pollo al limón',                  'Muslos de pollo marinados en limón, ajo y hierbas al horno.',                           360, 45, 4),
(29, 'Ensalada de aguacate y tomate',   'Rodajas de tomate y aguacate con cebolla morada y aceite de oliva.',                    280, 10, 5),
(30, 'Panqueques de avena',             'Panqueques esponjosos hechos con avena, huevo y plátano.',                              310, 20, 4),
(31, 'Risotto de champiñones',          'Arroz cremoso con champiñones salteados, cebolla y queso parmesano.',                   520, 40, 3),
(32, 'Tofu salteado',                   'Tofu firme salteado con pimiento, zanahoria, soya y jengibre.',                         310, 20, 5),
(33, 'Gazpacho andaluz',                'Sopa fría de tomate, pepino, pimiento y ajo con aceite de oliva.',                      160, 15, 5),
(34, 'Pollo con verduras al wok',       'Pechuga de pollo salteada con brócoli, zanahoria y salsa de soja.',                     390, 20, 5),
(35, 'Muffins de zanahoria',            'Muffins esponjosos con zanahoria rallada, canela y nuez.',                              280, 35, 3),
(36, 'Caldo de pollo casero',           'Caldo reconfortante con pollo, apio, zanahoria y cebolla.',                             150, 60, 5),
(37, 'Ensalada de garbanzos',           'Garbanzos con pepino, tomate, cebolla, limón y aceite de oliva.',                       330, 10, 5),
(38, 'Stir-fry de res y brocoli',       'Tiras de carne de res salteadas con brócoli y salsa teriyaki.',                         460, 20, 3),
(39, 'Crêpes de espinaca',              'Crêpes finos rellenos de espinaca salteada y queso ricotta.',                           350, 25, 4),
(40, 'Sopa de lenteja roja',            'Sopa cremosa de lenteja roja con cúrcuma, comino y limón.',                             290, 35, 5),
(41, 'Bowl de salmón y quinoa',         'Quinoa con salmón a la plancha, aguacate, edamame y semillas de sésamo.',               520, 25, 5),
(42, 'Granola casera',                  'Granola horneada con avena, miel, semillas de girasol y frutos secos.',                 400, 30, 4),
(43, 'Berenjena al horno',              'Berenjena asada con tomate, ajo, albahaca y aceite de oliva.',                          190, 35, 5),
(44, 'Wrap de pollo y aguacate',        'Tortilla integral con pollo a la plancha, aguacate, lechuga y tomate.',                 430, 15, 4),
(45, 'Crema de calabacín',              'Sopa cremosa de calabacín con cebolla, ajo y un toque de crema.',                       210, 30, 4),
(46, 'Tostadas de aguacate',            'Pan integral tostado con aguacate machacado, limón y semillas de chía.',                290, 10, 5),
(47, 'Fajitas de pollo',                'Tiras de pollo con pimiento y cebolla salteadas en tortillas de maíz.',                  450, 25, 4),
(48, 'Pudín de chía',                   'Semillas de chía hidratadas en leche de almendra con mango y coco.',                    280, 5,  5),
(49, 'Cazuela de verduras',             'Mezcla de berenjena, calabacín, tomate y cebolla horneada con hierbas.',                230, 50, 5),
(50, 'Batido de mango y jengibre',      'Batido refrescante de mango, naranja, jengibre y una pizca de cúrcuma.',                220, 5,  5);

-- ============================================================
-- 4. INGREDIENTE_RESTRICCIONES
--    Logical mappings: which ingredient triggers which restriction
-- ============================================================
INSERT INTO public.ingrediente_restricciones (ingrediente_id, restriccion_id) VALUES
-- gluten (1)
(1,  1),  -- harina de trigo → gluten
(1,  15), -- harina de trigo → trigo
(12, 1),  -- avena → gluten
(61, 1),  -- pasta integral → gluten
(62, 1),  -- pan integral → gluten
(65, 1),  -- cuscus → gluten
-- lactosa (2)
(2,  2),  -- leche → lactosa
(8,  2),  -- queso → lactosa
(13, 2),  -- yogur natural → lactosa
(48, 2),  -- mantequilla → lactosa
(80, 2),  -- crema de leche → lactosa
-- azucar (3)
(3,  3),  -- azucar → azucar
(59, 3),  -- miel → azucar
-- frutos secos (4)
(10, 4),  -- almendras → frutos secos
(75, 4),  -- nuez → frutos secos
(78, 4),  -- semillas de girasol → frutos secos
-- mariscos (5)
(11, 5),  -- camaron → mariscos
(40, 5),  -- salmon → mariscos (pescado, marcado para alergias)
(41, 5),  -- atun → mariscos
(42, 5),  -- sardina → mariscos
-- vegano (6) — animal products
(2,  6),  -- leche → vegano
(8,  6),  -- queso → vegano
(9,  6),  -- huevo → vegano
(4,  6),  -- pollo → vegano
(11, 6),  -- camaron → vegano
(13, 6),  -- yogur natural → vegano
(38, 6),  -- carne de res → vegano
(39, 6),  -- carne de cerdo → vegano
(40, 6),  -- salmon → vegano
(41, 6),  -- atun → vegano
(42, 6),  -- sardina → vegano
(48, 6),  -- mantequilla → vegano
(80, 6),  -- crema de leche → vegano
-- vegetariano (7) — meat/fish
(4,  7),  -- pollo → vegetariano
(11, 7),  -- camaron → vegetariano
(38, 7),  -- carne de res → vegetariano
(39, 7),  -- carne de cerdo → vegetariano
(40, 7),  -- salmon → vegetariano
(41, 7),  -- atun → vegetariano
(42, 7),  -- sardina → vegetariano
-- huevo (8)
(9,  8),  -- huevo → huevo
-- soja (9)
(47, 9),  -- soya → soja
(43, 9),  -- tofu → soja (derived from soy)
-- cacahuete (10)
(76, 10), -- cacahuete → cacahuete
-- cerdo (14)
(39, 14), -- carne de cerdo → cerdo
-- trigo (15)
(62, 15); -- pan integral → trigo

-- ============================================================
-- 5. RECETA_INGREDIENTES
--    3-8 ingredients per recipe, all IDs valid (1-80)
-- ============================================================
INSERT INTO public.receta_ingredientes (receta_id, ingrediente_id) VALUES
-- 1 Pollo con arroz
(1, 4),(1, 5),(1, 6),(1, 18),(1, 19),(1, 49),
-- 2 Ensalada de brocoli
(2, 7),(2, 17),(2, 22),(2, 26),(2, 49),(2, 52),
-- 3 Spaghetti Alfredo con pollo
(3, 4),(3, 8),(3, 2),(3, 48),(3, 61),(3, 19),
-- 4 Omelette de espinaca
(4, 9),(4, 15),(4, 8),(4, 18),(4, 49),(4, 52),
-- 5 Arroz con camarones
(5, 11),(5, 5),(5, 19),(5, 20),(5, 49),(5, 26),
-- 6 Yogur con almendras
(6, 13),(6, 10),(6, 59),
-- 7 Sopa de verduras
(7, 6),(7, 14),(7, 67),(7, 18),(7, 24),(7, 52),(7, 55),
-- 8 Ensalada César
(8, 22),(8, 8),(8, 9),(8, 26),(8, 19),(8, 62),
-- 9 Tacos de pollo
(9, 4),(9, 63),(9, 17),(9, 18),(9, 26),(9, 52),
-- 10 Smoothie verde
(10, 15),(10, 29),(10, 28),(10, 79),
-- 11 Avena con frutos rojos
(11, 12),(11, 30),(11, 29),(11, 77),(11, 59),
-- 12 Salmon al horno
(12, 40),(12, 26),(12, 19),(12, 71),(12, 49),(12, 52),
-- 13 Ensalada de quinoa
(13, 64),(13, 23),(13, 17),(13, 25),(13, 26),(13, 49),
-- 14 Crema de zanahoria
(14, 6),(14, 58),(14, 18),(14, 50),(14, 52),
-- 15 Pasta integral con atun
(15, 61),(15, 41),(15, 17),(15, 49),(15, 54),(15, 52),
-- 16 Burrito de frijoles negros
(16, 45),(16, 25),(16, 20),(16, 62),(16, 18),(16, 52),
-- 17 Pollo al curry
(17, 4),(17, 5),(17, 18),(17, 19),(17, 56),(17, 55),(17, 2),
-- 18 Wrap de atun
(18, 41),(18, 22),(18, 17),(18, 63),(18, 51),
-- 19 Tortilla española
(19, 14),(19, 9),(19, 18),(19, 49),(19, 52),
-- 20 Bowl de acai
(20, 12),(20, 29),(20, 30),(20, 59),
-- 21 Lentejas guisadas
(21, 44),(21, 6),(21, 17),(21, 18),(21, 54),(21, 52),(21, 49),
-- 22 Ceviche de camaron
(22, 11),(22, 26),(22, 17),(22, 18),(22, 52),
-- 23 Pizza integral de vegetales
(23, 62),(23, 17),(23, 70),(23, 20),(23, 8),(23, 54),
-- 24 Batido de proteina
(24, 29),(24, 12),(24, 13),(24, 76),
-- 25 Arroz integral con garbanzos
(25, 5),(25, 46),(25, 56),(25, 6),(25, 49),
-- 26 Hamburguesa de lentejas
(26, 44),(26, 6),(26, 18),(26, 62),(26, 52),(26, 55),
-- 27 Sopa de tomate
(27, 17),(27, 16),(27, 18),(27, 80),(27, 49),(27, 52),
-- 28 Pollo al limon
(28, 4),(28, 26),(28, 19),(28, 54),(28, 49),(28, 52),
-- 29 Ensalada de aguacate y tomate
(29, 25),(29, 17),(29, 18),(29, 49),(29, 26),(29, 52),
-- 30 Panqueques de avena
(30, 12),(30, 9),(30, 29),(30, 2),(30, 57),
-- 31 Risotto de champiñones
(31, 5),(31, 70),(31, 18),(31, 8),(31, 48),(31, 49),
-- 32 Tofu salteado
(32, 43),(32, 20),(32, 6),(32, 47),(32, 58),(32, 49),
-- 33 Gazpacho andaluz
(33, 17),(33, 23),(33, 21),(33, 19),(33, 49),(33, 51),(33, 52),
-- 34 Pollo con verduras al wok
(34, 4),(34, 7),(34, 6),(34, 47),(34, 49),(34, 58),
-- 35 Muffins de zanahoria
(35, 6),(35, 57),(35, 75),(35, 9),(35, 1),(35, 3),
-- 36 Caldo de pollo casero
(36, 4),(36, 24),(36, 6),(36, 18),(36, 52),
-- 37 Ensalada de garbanzos
(37, 46),(37, 23),(37, 17),(37, 18),(37, 26),(37, 49),
-- 38 Stir-fry de res y brocoli
(38, 38),(38, 7),(38, 47),(38, 49),(38, 19),(38, 58),
-- 39 Crepes de espinaca
(39, 15),(39, 8),(39, 9),(39, 1),(39, 2),(39, 48),
-- 40 Sopa de lenteja roja
(40, 44),(40, 56),(40, 55),(40, 26),(40, 18),(40, 52),
-- 41 Bowl de salmon y quinoa
(41, 40),(41, 64),(41, 25),(41, 49),(41, 52),
-- 42 Granola casera
(42, 12),(42, 59),(42, 78),(42, 10),(42, 57),
-- 43 Berenjena al horno
(43, 69),(43, 17),(43, 19),(43, 16),(43, 49),(43, 52),
-- 44 Wrap de pollo y aguacate
(44, 4),(44, 25),(44, 22),(44, 17),(44, 63),
-- 45 Crema de calabacin
(45, 68),(45, 18),(45, 19),(45, 80),(45, 49),(45, 52),
-- 46 Tostadas de aguacate
(46, 25),(46, 62),(46, 26),(46, 77),(46, 52),
-- 47 Fajitas de pollo
(47, 4),(47, 20),(47, 21),(47, 18),(47, 63),(47, 49),(47, 52),
-- 48 Pudin de chia
(48, 77),(48, 79),(48, 31),(48, 59),
-- 49 Cazuela de verduras
(49, 69),(49, 68),(49, 17),(49, 18),(49, 49),(49, 54),(49, 52),
-- 50 Batido de mango y jengibre
(50, 31),(50, 27),(50, 58),(50, 56);

-- ============================================================
-- 6. Update sequences so nextval() starts after seeded IDs
-- ============================================================
SELECT setval('public.ingredientes_id_seq',  80);
SELECT setval('public.restricciones_id_seq', 15);
SELECT setval('public.recetas_id_seq',       50);

-- ============================================================
-- End of NutriEdu seed data
-- ============================================================
