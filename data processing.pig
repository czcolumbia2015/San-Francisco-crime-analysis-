#Extract category and resolutions:
crime = LOAD '/Users/chenzheng/Downloads/train.csv' USING PigStorage(',') as (Dates, Category, Descript, DayOfWeek, PdDistrict, Resolution, Address, X,Y);
crime = FOREACH crime GENERATE Category, (Resolution == 'NONE' ? 0 : 1) AS count;
by_category = group crime by Category;
by_category_counts = FOREACH by_category GENERATE group as Category, SUM(crime.count), COUNT(crime);
store by_category_counts into '/Users/chenzheng/Documents/big_data/project/by_category_counts';

#Extract PdDistrict, count(crime), X, Y
crime = LOAD '/Users/chenzheng/Downloads/train2.csv' USING PigStorage(',') as (Dates, Category, Descript, DayOfWeek, PdDistrict, Resolution, Address, X,Y);
by_PdDistrict = group crime by PdDistrict;
PdDistrict_counts = foreach by_PdDistrict generate group as PdDistrict, COUNT(crime), AVG(crime.X), AVG(crime.Y);

#Extract DayOfWeek, count(crime)
crime = LOAD '/Users/chenzheng/Downloads/train2.csv' USING PigStorage(',') as (Dates, Category, Descript, DayOfWeek, PdDistrict, Resolution, Address, X,Y);
by_DayOfWeek = group crime by DayOfWeek;
DayOfWeek_counts = foreach by_DayOfWeek generate group as DayOfWeek, COUNT(crime);
store DayOfWeek_counts into '/Users/chenzheng/Documents/big_data/project/DayOfWeek_counts';

#Extract HourOfDay, Year
value = foreach splt generate $0 as id, $1 as time;
HourOfDay = foreach value generate FLATTEN(STRSPLIT(time, ':'));
HOD = foreach HourOfDay generate $0 as value1;
BY_HOD = group HOD by value1;
HOD_counts = foreach BY_HOD generate group as value1, COUNT(HOD);
store HOD_counts into '/Users/chenzheng/Documents/big_data/project/HOD_counts';

Year = foreach value generate id, LAST_INDEX_OF(id, '/') as p;
YY = foreach Year generate SUBSTRING(id, p+1, p+3) as year;
by_YY = group YY by year;
YY_counts = foreach by_YY generate group as year, COUNT(YY);
store YY_counts into '/Users/chenzheng/Documents/big_data/project/YY_counts';
