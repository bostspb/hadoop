-----------------------------------------------------------------------
-- Средние цены по районам Берлина и соответствующее количество отзывов
-----------------------------------------------------------------------
-- т.к. данные в файле были не очень, то для такого простого запроса пришлось применить небольшую оптимизацию,
-- чтобы можно было потом отфильтровать строки без NULL в поле id
alter table student9_7.listings change id id int

-- но это не особо помогло, поэтому пришлось еще присоединить к таблице справочник районов,
-- чтобы в выборку попали только строки с корректными районами
-- после этих манипуляций запрос стал выдавать что-то адекватное
select l.neighbourhood_group, round(avg(l.price),2) as avg_price, sum(l.number_of_reviews) as reviews_count
from student9_7.listings l
inner join student9_7.neighbourhoods n on n.neighbourhood_group = l.neighbourhood_group
where l.neighbourhood_group is not null
    and l.price is not null
    and l.number_of_reviews is not null
    and l.neighbourhood_group != ''
group by l.neighbourhood_group;


--------------------------
-- Вспомогательные запросы
--------------------------
drop table student9_7.calendar_summary;
drop table student9_7.listings;
drop table student9_7.listings_summary;
drop table student9_7.neighbourhoods;
drop table student9_7.reviews;
drop table student9_7.reviews_summary;

msck repair table student9_7.calendar_summary;
msck repair table student9_7.listings;
msck repair table student9_7.listings_summary;
msck repair table student9_7.neighbourhoods;
msck repair table student9_7.reviews;
msck repair table student9_7.reviews_summary;


select * from student9_7.calendar_summary limit 100;
select * from student9_7.listings limit 100;
select * from student9_7.listings_summary limit 100;
select * from student9_7.neighbourhoods limit 100;
select * from student9_7.reviews limit 100;
select * from student9_7.reviews_summary limit 100;