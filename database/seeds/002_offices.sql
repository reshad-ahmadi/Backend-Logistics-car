INSERT INTO exchange_offices (office_name)
VALUES
  ('Jalalabad'),
  ('Herat'),
  ('Saif Kabul')
ON CONFLICT (office_name) DO NOTHING;

INSERT INTO border_offices (office_name)
VALUES
  ('Islam Qala'),
  ('Rozanak'),
  ('Farah (Mahirood)'),
  ('Nimroz'),
  ('Hairatan')
ON CONFLICT (office_name) DO NOTHING;
