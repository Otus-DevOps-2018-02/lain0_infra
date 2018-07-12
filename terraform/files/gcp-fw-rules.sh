gcloud compute firewall-rules list --filter network=default \
    --sort-by priority \
    --format="table(
        name,
        priority,
        sourceRanges.list():label=[SRC_RANGES],
        destinationRanges.list():label=[DEST_RANGES],
        allowed[].map().firewall_rule().list():label=ALLOW,
        denied[].map().firewall_rule().list():label=DENY,
        sourceTags.list():label=[SRC_TAGS],
        targetTags.list():label=[TARGET_TAGS]
        )"
