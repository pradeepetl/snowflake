---------- Twitter sample data -------------
--select * from demo_db.public.twitter_sample;

--describe table demo_db.public.twitter_sample;

create or replace file format JSON_FORMAT
type = JSON;

--drop stage MY_S3_UNLOAD_STAGE

-- Create stage objete to read s3 file.
create or replace stage MY_S3_UNLOAD_STAGE
url = 's3://semistructdata067'
file_format = JSON_FORMAT;

-- check if you are able to access the s3 file.
ls @MY_S3_UNLOAD_STAGE;

select $1 from 
@MY_S3_UNLOAD_STAGE/twitter_data/twitter_sample.json
(file_format =>JSON_FORMAT);

create table demo_db.public.twitter_sample_raw
as
select 
parse_json('{
    "_id": {
        "$oid": "59435062a7986c085b072088"
    },
    "text": "@shaqdarcy hahaha.. soya talaga bro.. :)",
    "in_reply_to_user_id_str": "238156878",
    "id_str": "133582462910611456",
    "contributors": null,
    "in_reply_to_user_id": 238156878,
    "created_at": "Mon Nov 07 16:31:55 +0000 2011",
    "in_reply_to_status_id": {
        "$numberLong": "133582357465792513"
    },
    "entities": {
        "hashtags": [],
        "user_mentions": [
            {
                "screen_name": "shaqdarcy",
                "indices": [
                    0,
                    10
                ],
                "id_str": "238156878",
                "name": "Darcy Nicolas",
                "id": 238156878
            }
        ],
        "urls": [],
        "media": null
    },
    "geo": null,
    "source": "web",
    "place": null,
    "favorited": false,
    "truncated": false,
    "coordinates": null,
    "retweet_count": 0,
    "in_reply_to_screen_name": "shaqdarcy",
    "user": {
        "profile_use_background_image": true,
        "favourites_count": 13,
        "screen_name": "JaybeatBolido",
        "id_str": "255006912",
        "default_profile_image": false,
        "geo_enabled": false,
        "profile_text_color": "333333",
        "statuses_count": 467,
        "profile_background_image_url": "http://a0.twimg.com/images/themes/theme1/bg.png",
        "created_at": "Sun Feb 20 13:31:09 +0000 2011",
        "friends_count": 92,
        "profile_link_color": "0084B4",
        "description": "I want to be a JEDI.",
        "follow_request_sent": null,
        "lang": "en",
        "profile_image_url_https": "https://si0.twimg.com/profile_images/1614465172/jp_normal.jpg",
        "profile_background_color": "C0DEED",
        "url": null,
        "contributors_enabled": false,
        "profile_background_tile": false,
        "following": null,
        "profile_sidebar_fill_color": "DDEEF6",
        "protected": false,
        "show_all_inline_media": false,
        "listed_count": 1,
        "location": "Phillipines-Manila",
        "name": "Japhette Pulido",
        "is_translator": false,
        "default_profile": true,
        "notifications": null,
        "profile_sidebar_border_color": "C0DEED",
        "id": 255006912,
        "verified": false,
        "profile_background_image_url_https": "https://si0.twimg.com/images/themes/theme1/bg.png",
        "time_zone": null,
        "utc_offset": null,
        "followers_count": 42,
        "profile_image_url": "http://a1.twimg.com/profile_images/1614465172/jp_normal.jpg"
    },
    "retweeted": false,
    "id": {
        "$numberLong": "133582462910611456"
    },
    "in_reply_to_status_id_str": "133582357465792513",
    "possibly_sensitive": null,
    "retweeted_status": null,
    "delete": null
}') twitter_data;


create table demo_db.public.twitter_sample
as
select twitter_data:"_id":"$oid" oid,
twitter_data:"text" text,
twitter_data:"in_reply_to_status_id":"$numberLong" numberLong,
twitter_data:"entities":"user_mentions" user_mentions,
f.value:"screen_name" screen_name,
f.value:"id_str" id_str,
f.value:"id" id,
twitter_data:"in_reply_to_screen_name" in_reply_to_screen_name,
twitter_data:"user":"profile_use_background_image" profile_use_background_image,
twitter_data:"user":"friends_count" friends_count,
twitter_data:"user":"description" description,
twitter_data:"user":"followers_count" followers_count,
twitter_data:"id":"$numberLong" numberLong_id
from demo_db.public.twitter_sample_raw,
table(flatten(twitter_data:"entities":"user_mentions")) f;

copy into @%twitter_sample
from(
select 
t.$1:"_id":"$oid" oid,
t.$1:"text" text,
t.$1:"in_reply_to_status_id":"$numberLong" numberLong,
t.$1:"entities":"user_mentions" user_mentions,
f.value:"screen_name" screen_name,
f.value:"id_str" id_str,
f.value:"id" id,
t.$1:"in_reply_to_screen_name" in_reply_to_screen_name,
t.$1:"user":"profile_use_background_image" profile_use_background_image,
t.$1:"user":"friends_count" friends_count,
t.$1:"user":"description" description,
t.$1:"user":"followers_count" followers_count,
t.$1:"id":"$numberLong" numberLong_id
from  @MY_S3_UNLOAD_STAGE/twitter_data/twitter_sample.json t,
table(flatten($1:"entities":"user_mentions")) f
);

ls @%twitter_sample;

--rm @%twitter_sample;

copy into twitter_sample
from @%twitter_sample
file_format =(type='csv')
ON_ERROR='CONTINUE';

select * from twitter_sample