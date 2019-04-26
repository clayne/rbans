# Downloading directly from pushshift.io

data_dir=/data/reddit

for year in $(seq 2005 2017); do
    for month in $(seq -f "%02g" 4 4); do
        if [ -f "$data_dir"/RC_"$year"-"$month" ]; then
            echo "Now extracting RC_"$year"-"$month"..."
            pv "$data_dir"/RC_"$year"-"$month" \
                | pbzip2 -c -d \
                | jq -c '{author,gilded,subreddit,created_utc,edited,controversiality,parent_id,score,link_id,id,subreddit_id,body}' \
                > "$data_dir"/extracted/RC_"$year"-"$month".json
        fi
    done
done

for year in 2018 2019; do
    for month in 01 12; do
            echo "Now extracting RC_"$year"-"$month"..."
            pv "$data_dir"/RC_"$year"-"$month".xz \
                | xz -T0 -d -c \
                | jq -c '{author,gilded,subreddit,created_utc,edited,controversiality,parent_id,score,link_id,id,subreddit_id,body}' \
                > "$data_dir"/extracted/RC_"$year"-"$month".json
    done
done
