-- Insert designers
INSERT INTO designer (id, name, url) VALUES
(1, 'Jonathan Hoefler', 'https://www.typography.com'),
(2, 'Erik Spiekermann', 'https://spiekermann.com'),
(3, 'Adrian Frutiger', 'https://www.linotype.com');

-- Insert manufacturers
INSERT INTO manufacturer (id, name, url) VALUES
(1, 'Hoefler & Co.', 'https://www.typography.com'),
(2, 'FontFont', 'https://www.monotype.com/fonts/fontfont'),
(3, 'Linotype', 'https://www.linotype.com');

-- Insert font families
INSERT INTO family (id, family, designer_id, manufacturer_id, created_at, updated_at) VALUES
(1, 'Gotham', 1, 1, strftime('%s', 'now'), strftime('%s', 'now')),
(2, 'Meta', 2, 2, strftime('%s', 'now'), strftime('%s', 'now')),
(3, 'Frutiger', 3, 3, strftime('%s', 'now'), strftime('%s', 'now'));

-- Insert sub-families
INSERT INTO sub_family (id, family_id, sub_family, created_at, updated_at) VALUES
(1, 1, 'Gotham Book', strftime('%s', 'now'), strftime('%s', 'now')),
(2, 1, 'Gotham Bold', strftime('%s', 'now'), strftime('%s', 'now')),
(3, 2, 'FF Meta Normal', strftime('%s', 'now'), strftime('%s', 'now')),
(4, 3, 'Frutiger 55 Roman', strftime('%s', 'now'), strftime('%s', 'now'));

-- Insert sub-family versions
INSERT INTO sub_family_version (sub_family_id, version, src) VALUES
(1, 1.0, 'fonts/gotham-book.woff2'),
(2, 1.0, 'fonts/gotham-bold.woff2'),
(3, 2.1, 'fonts/meta-normal.woff2'),
(4, 3.0, 'fonts/frutiger-55.woff2');

-- Insert elements
INSERT INTO element (id, name) VALUES
(1, 'h1'),
(2, 'h2'),
(3, 'p'),
(4, 'button');

-- Insert usage examples
INSERT INTO usage (id, element_id, sub_family_id, weight, line_height, size) VALUES
(1, 1, 2, 700, 1.2, 32), -- h1 using Gotham Bold
(2, 2, 1, 400, 1.4, 24), -- h2 using Gotham Book
(3, 3, 3, 400, 1.5, 16), -- p using FF Meta Normal
(4, 4, 4, 400, 1.4, 14); -- button using Frutiger

-- Insert domains
INSERT INTO domain (id, url) VALUES
(1, 'example.com'),
(2, 'testsite.org');

-- Insert paths
INSERT INTO path (id, name, domain_id) VALUES
(1, '/home', 1),
(2, '/about', 1),
(3, '/blog', 2);

-- Insert pages
INSERT INTO page (id, path_id, screenshot_count, created_at, updated_at) VALUES
(1, 1, 2, strftime('%s', 'now'), strftime('%s', 'now')),
(2, 2, 1, strftime('%s', 'now'), strftime('%s', 'now')),
(3, 3, 3, strftime('%s', 'now'), strftime('%s', 'now'));

-- Insert page usage relationships
INSERT INTO page_usage (page_id, usage_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 2),
(2, 3),
(3, 1);

-- Insert page history
INSERT INTO page_history (id, page_id, screenshot_count, created_at, archived_at) VALUES
(1, 1, 1, strftime('%s', 'now') - 86400, strftime('%s', 'now')), -- Yesterday
(2, 2, 1, strftime('%s', 'now') - 172800, strftime('%s', 'now')), -- 2 days ago
(3, 3, 2, strftime('%s', 'now') - 259200, strftime('%s', 'now')); -- 3 days ago

-- Insert page history usage
INSERT INTO page_history_usage (page_history_id, usage_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4);

-- Insert users
INSERT INTO user (id, email, created_at, updated_at) VALUES
(1, 'john@example.com', strftime('%s', 'now'), strftime('%s', 'now')),
(2, 'jane@testsite.org', strftime('%s', 'now'), strftime('%s', 'now'));

-- Insert bookmarks
INSERT INTO bookmark (user_id, page_id, page_created_at, collection_name, created_at) VALUES
(1, 1, strftime('%s', 'now') - 86400, 'Favorites', strftime('%s', 'now')),
(1, 2, strftime('%s', 'now') - 172800, 'Reading List', strftime('%s', 'now')),
(2, 3, strftime('%s', 'now') - 259200, 'Inspiration', strftime('%s', 'now'));