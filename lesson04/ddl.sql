create external table student9_7.calendar_summary (
    listing_id string,
    date string,
    available string,
    price string
)
ROW FORMAT serde 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES ('field.delim' = ',')
location "/user/hive/warehouse/student9_7.db/calendar_summary/"
tblproperties ("skip.header.line.count"="1")
;


create external table student9_7.listings (
    id string,
    name string,
    host_id string,
    host_name string,
    neighbourhood_group string,
    neighbourhood string,
    latitude string,
    longitude string,
    room_type string,
    price string,
    minimum_nights string,
    number_of_reviews string,
    last_review string,
    reviews_per_month string,
    calculated_host_listings_count string,
    availability_365  string
)
ROW FORMAT serde 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES ('field.delim' = ',')
location "/user/hive/warehouse/student9_7.db/listings/"
tblproperties ("skip.header.line.count"="1")
;


create external table student9_7.listings_summary (
    id string,
    listing_url string,
    scrape_id string,
    last_scraped string,
    name string,
    summary string,
    space string,
    description string,
    experiences_offered string,
    neighborhood_overview string,
    notes string,
    transit string,
    access string,
    interaction string,
    house_rules string,
    thumbnail_url string,
    medium_url string,
    picture_url string,
    xl_picture_url string,
    host_id string,
    host_url string,
    host_name string,
    host_since string,
    host_location string,
    host_about string,
    host_response_time string,
    host_response_rate string,
    host_acceptance_rate string,
    host_is_superhost string,
    host_thumbnail_url string,
    host_picture_url string,
    host_neighbourhood string,
    host_listings_count string,
    host_total_listings_count string,
    host_verifications string,
    host_has_profile_pic string,
    host_identity_verified string,
    street string,
    neighbourhood string,
    neighbourhood_cleansed string,
    neighbourhood_group_cleansed string,
    city string,
    state string,
    zipcode string,
    market string,
    smart_location string,
    country_code string,
    country string,
    latitude string,
    longitude string,
    is_location_exact string,
    property_type string,
    room_type string,
    accommodates string,
    bathrooms string,
    bedrooms string,
    beds string,
    bed_type string,
    amenities string,
    square_feet string,
    price string,
    weekly_price string,
    monthly_price string,
    security_deposit string,
    cleaning_fee string,
    guests_included string,
    extra_people string,
    minimum_nights string,
    maximum_nights string,
    calendar_updated string,
    has_availability string,
    availability_30 string,
    availability_60 string,
    availability_90 string,
    availability_365 string,
    calendar_last_scraped string,
    number_of_reviews string,
    first_review string,
    last_review string,
    review_scores_rating string,
    review_scores_accuracy string,
    review_scores_cleanliness string,
    review_scores_checkin string,
    review_scores_communication string,
    review_scores_location string,
    review_scores_value string,
    requires_license string,
    license string,
    jurisdiction_names string,
    instant_bookable string,
    is_business_travel_ready string,
    cancellation_policy string,
    require_guest_profile_picture string,
    require_guest_phone_verification string,
    calculated_host_listings_count string,
    reviews_per_month string
)
ROW FORMAT serde 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES ('field.delim' = ',')
location "/user/hive/warehouse/student9_7.db/listings_summary/"
tblproperties ("skip.header.line.count"="1")
;


create external table student9_7.neighbourhoods (
    neighbourhood_group string,
    neighbourhood string
)
ROW FORMAT serde 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES ('field.delim' = ',')
location "/user/hive/warehouse/student9_7.db/neighbourhoods/"
tblproperties ("skip.header.line.count"="1")
;


create external table student9_7.reviews (
    listing_id string,
    date string
)
ROW FORMAT serde 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES ('field.delim' = ',')
location "/user/hive/warehouse/student9_7.db/reviews/"
tblproperties ("skip.header.line.count"="1")
;


create external table student9_7.reviews_summary (
    listing_id string,
    id string,
    date string,
    reviewer_id string,
    reviewer_name string,
    comments string
)
ROW FORMAT serde 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES ('field.delim' = ',')
location "/user/hive/warehouse/student9_7.db/reviews_summary/"
tblproperties ("skip.header.line.count"="1")
;
