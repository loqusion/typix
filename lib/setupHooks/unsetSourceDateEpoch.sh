unsetSourceDateEpoch() {
    unset SOURCE_DATE_EPOCH
}

preBuildHooks+=(unsetSourceDateEpoch)
